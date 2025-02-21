/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'parsed_field.dart';

class ParsedData {
  final String _jsonString;
  String get jsonString => _jsonString;

  final List<ParsedField> _fields;
  List<ParsedField> get fields => _fields;

  final Map<String, ParsedField> _fieldsByName;
  Map<String, ParsedField> get fieldsByName => _fieldsByName;

  final List<ParsedField> _fieldsWithIssues;
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
