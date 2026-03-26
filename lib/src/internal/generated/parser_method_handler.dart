/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

// THIS FILE IS GENERATED. DO NOT EDIT MANUALLY.
// Generator: scripts/bridge_generator/generate.py
// Schema: scripts/bridge_generator/schemas/parser.json

import 'package:flutter/services.dart';

/// Generated Parser method handler for Flutter.
/// Routes all Parser method calls through a single executeParser entry point.
class ParserMethodHandler {
  final MethodChannel _methodChannel;

  ParserMethodHandler(this._methodChannel);

  /// Single entry point for all Parser operations.
  /// Routes to appropriate native command based on moduleName and methodName.
  Future<dynamic> executeParser(String moduleName, String methodName, Map<String, dynamic> params) async {
    final arguments = {'moduleName': moduleName, 'methodName': methodName, ...params};
    return await _methodChannel.invokeMethod('executeParser', arguments);
  }

  /// Parses a string and returns structured data
  Future<String> parseString({required String parserId, required String data}) async {
    final params = {'parserId': parserId, 'data': data};
    final result = await executeParser('ParserModule', 'parseString', params);
    return result;
  }

  /// Parses raw data and returns structured data
  Future<String> parseRawData({required String parserId, required String data}) async {
    final params = {'parserId': parserId, 'data': data};
    final result = await executeParser('ParserModule', 'parseRawData', params);
    return result;
  }

  /// Creates or updates a native parser instance
  Future<void> createUpdateNativeInstance({required String parserJson}) async {
    final params = {'parserJson': parserJson};
    return await executeParser('ParserModule', 'createUpdateNativeInstance', params);
  }

  /// Disposes the parser instance and releases resources
  Future<void> disposeParser({required String parserId}) async {
    final params = {'parserId': parserId};
    return await executeParser('ParserModule', 'disposeParser', params);
  }
}
