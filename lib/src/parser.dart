/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'function_names.dart';
import 'parsed_data.dart';
import 'parser_dataformat.dart';

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

  @Deprecated('Use constructor Parser(ParserDataFormat dataFormat) instead.')
  static Future<Parser> forContextAndFormat(DataCaptureContext context, ParserDataFormat dataFormat) {
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

class _ParserController {
  final Parser _parser;

  final MethodChannel _methodChannel = const MethodChannel('com.scandit.datacapture.parser/method_channel');

  _ParserController(this._parser);

  Future<void> createUpdateNativeInstance() {
    var encoded = jsonEncode(_parser.toMap());
    return _methodChannel.invokeMethod(FunctionNames.createUpdateNativeInstance, encoded).onError(_onError);
  }

  Future<ParsedData> parseString(String data) {
    var arguments = _createParserInvocationArgs(data);
    return _methodChannel
        .invokeMethod(FunctionNames.parseStringMethodName, jsonEncode(arguments))
        .then(_parseData, onError: _onError);
  }

  Future<ParsedData> parseRawData(String data) {
    var arguments = _createParserInvocationArgs(data);
    return _methodChannel
        .invokeMethod(FunctionNames.parseRawDataMethodName, jsonEncode(arguments))
        .then(_parseData, onError: _onError);
  }

  Map<String, dynamic> _createParserInvocationArgs(String data) {
    return {'parserId': _parser.id, 'data': data};
  }

  FutureOr<ParsedData> _parseData(dynamic result) {
    var jsonData = jsonDecode(result) as List<dynamic>;
    var json = jsonData.cast<Map<String, dynamic>>();
    var parsedData = ParsedData.fromJSON(json);
    return parsedData;
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }

  void dispose() {
    _methodChannel.invokeMethod(FunctionNames.disposeParser, _parser.id).onError(_onError);
  }
}
