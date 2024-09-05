/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'parser_issue.dart';

class ParsedField {
  final String _name;
  String get name => _name;

  final dynamic _parsed;
  dynamic get parsed => _parsed;

  final String _rawString;
  String get rawString => _rawString;

  final List<String> _issues;

  @Deprecated('Use the property `warnings` instead.')
  List<String> get issues => _issues;

  final List<ParserIssue> _warnings;
  List<ParserIssue> get warnings => _warnings;

  ParsedField._(this._name, this._parsed, this._rawString, this._issues, this._warnings);

  factory ParsedField.fromJSON(Map<String, dynamic> json) {
    var issues = <String>[];
    if (json.containsKey('issues') && json["issues"] != null) {
      issues.addAll(json['issues'] as List<String>);
    }
    var warnings = <ParserIssue>[];
    if (json.containsKey('warnings') && json["warnings"] != null) {
      warnings.addAll((json['warnings'] as List<dynamic>).map((e) => ParserIssue.fromJSON(e)));
    }
    return ParsedField._(json['name'], json['parsed'], json['rawString'], issues, warnings);
  }
}
