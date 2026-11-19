/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_parser/src/internal/generated/parser_method_handler.dart';
import 'parsed_data.dart';
import 'parser_dataformat.dart';

// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';

class Parser extends DataCaptureComponent implements Serializable {
  @override
  // ignore: unnecessary_overrides
  String get id => super.id;

  late _ParserController _controller;

  final ParserDataFormat _dataFormat;

  final Map<String, dynamic> _options = {};

  Parser._(this._dataFormat) : super(DateTime.now().toUtc().millisecondsSinceEpoch.toString()) {
    _controller = _ParserController(this);
  }

  static Future<Parser> create(ParserDataFormat dataFormat) {
    var parser = Parser._(dataFormat);
    return parser._controller.createUpdateNativeInstance().then((value) => parser);
  }

  Future<void> setOptions(Map<String, dynamic> options) {
    _options.clear();
    _options.addAll(options);
    return _controller.createUpdateNativeInstance();
  }

  Future<ParsedData> parseString(String data) {
    return _controller.parseString(data);
  }

  Future<ParsedData> parseRawData(String data) {
    return _controller.parseRawData(data);
  }

  void dispose() {
    _controller.dispose();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({'type': 'parser', 'dataFormat': _dataFormat.toString(), 'options': _options});
    return json;
  }
}

class _ParserController extends BaseController {
  final Parser _parser;
  late final ParserMethodHandler parserMethodHandler;

  _ParserController(this._parser) : super('com.scandit.datacapture.parser/method_channel') {
    parserMethodHandler = ParserMethodHandler(methodChannel);
  }

  Future<void> createUpdateNativeInstance() {
    var encoded = jsonEncode(_parser.toMap());
    return parserMethodHandler.createUpdateNativeInstance(parserJson: encoded).onError(onError);
  }

  Future<ParsedData> parseString(String data) async {
    final result = await parserMethodHandler.parseString(parserId: _parser.id, data: data);
    return _parseData(result);
  }

  Future<ParsedData> parseRawData(String data) async {
    final result = await parserMethodHandler.parseRawData(parserId: _parser.id, data: data);
    return _parseData(result);
  }

  FutureOr<ParsedData> _parseData(dynamic result) {
    var jsonData = jsonDecode(result) as List<dynamic>;
    var json = jsonData.cast<Map<String, dynamic>>();
    var parsedData = ParsedData.fromJSON(json);
    return parsedData;
  }

  @override
  void dispose() {
    parserMethodHandler.disposeParser(parserId: _parser.id).onError(onError);
  }
}
