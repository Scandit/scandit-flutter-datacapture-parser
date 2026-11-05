/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'parsed_field.dart';

/// Holds the result of a successfully parsed data string or raw data. Instances of this class are returned by [Parser.parseString] and [Parser.parseRawData] methods. The parsed data is divided into *fields*, each identified by a name.
///
/// The data contained in this result object can be accessed in one of the following ways:
///
/// - Through an array of parser fields (see [ParsedData.fields]).
/// - Through a dictionary that maps field names to the field (see [ParsedData.fieldsByName]).
/// - Directly as a JSON string (see [ParsedData.jsonString]).
///
/// Added in version 6.10.0
class ParsedData {
  final String _jsonString;
  /// The result object as a serialized JSON string.
  ///
  /// Added in version 6.10.0
  String get jsonString => _jsonString;

  final List<ParsedField> _fields;
  /// The order of the fields matches the order in the original data string. The fields are data format specific. Consult the data format documentation for information on available fields.
  ///
  /// Added in version 6.10.0
  List<ParsedField> get fields => _fields;

  final Map<String, ParsedField> _fieldsByName;
  /// Provides by-name lookup of the fields. The field names are data format specific. Consult the data format documentation for information on available fields.
  ///
  /// Added in version 6.10.0
  Map<String, ParsedField> get fieldsByName => _fieldsByName;

  final List<ParsedField> _fieldsWithIssues;
  /// Like [ParsedData.fields], but only returns fields with issues
  ///
  /// Added in version 6.26.0
  List<ParsedField> get fieldsWithIssues => _fieldsWithIssues;

  ParsedData._(this._jsonString, this._fields, this._fieldsByName, this._fieldsWithIssues);

  factory ParsedData.fromJSON(List<Map<String, dynamic>> json) {
    var jsonString = jsonEncode(json);
    var fields = json.map((e) => ParsedField.fromJSON(e)).toList();
    var fieldsByName = {for (var element in fields) element.name: element};
    var fieldsWithIssues = fields.where((item) => item.warnings.isNotEmpty).toList();
    return ParsedData._(jsonString, fields, fieldsByName, fieldsWithIssues);
  }
}
