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

/// Added in version 6.10.0
class Parser extends DataCaptureComponent implements Serializable {
  /// Implemented from [DataCaptureComponent]. See [DataCaptureComponent.id].
  ///
  /// Added in version 6.10.0
  @override
  // ignore: unnecessary_overrides
  String get id => super.id;

  late _ParserController _controller;

  final ParserDataFormat _dataFormat;

  final Map<String, dynamic> _options = {};

  Parser._(this._dataFormat) : super(DateTime.now().toUtc().millisecondsSinceEpoch.toString()) {
    _controller = _ParserController(this);
  }

  /// Constructs a new Parser instance with the provided dataFormat.
  ///
  /// Added in version 7.6.0
  static Future<Parser> create(ParserDataFormat dataFormat) {
    var parser = Parser._(dataFormat);
    return parser._controller.createUpdateNativeInstance().then((value) => parser);
  }

  /// Sets the provided options on the parser.
  ///
  /// Available options depend on the data format type of the parser and are documented for each of the supported data formats.
  ///
  /// In case the options are invalid, an exception is raised. More detailed information on why creation failed is contained in the exception error message.
  ///
  /// Added in version 6.10.0
  Future<void> setOptions(Map<String, dynamic> options) {
    _options.clear();
    _options.addAll(options);
    return _controller.createUpdateNativeInstance();
  }

  /// Parses the data string and returns the contained field in the result object. Typical inputs to this method is the data contained in a barcode (see [Barcode.data])
  ///
  /// In case the data string could not be parsed, an exception is raised. More detailed information on why creation failed is contained in the exception error message.
  ///
  /// Added in version 6.10.0
  Future<ParsedData> parseString(String data) {
    return _controller.parseString(data);
  }

  /// Parses the raw data and returns the contained field in the result object. Typical inputs to this method is the raw data of a barcode (see [Barcode.rawData]).
  ///
  /// In case the data string could not be parsed, an exception is raised. More detailed information on why creation failed is contained in the exception error message.
  ///
  /// Added in version 6.10.0
  Future<ParsedData> parseRawData(String data) {
    return _controller.parseRawData(data);
  }

  /// Disposes the parser.
  ///
  /// Added in version 6.22.0
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
