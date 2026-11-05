/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'parser_issue.dart';

/// Added in version 6.10.0
class ParsedField {
  final String _name;
  /// The name of the field.
  ///
  /// Added in version 6.10.0
  String get name => _name;

  final dynamic _parsed;
  /// The parsed data contained in this field. Depending on the field type, this returns a [num](https://api.flutter.dev/flutter/dart-core/num-class.html), [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) or [String](https://api.flutter.dev/flutter/dart-core/String-class.html) instance. Consult the field documentation for information on the type for the fields you are interested in.
  ///
  /// Added in version 6.10.0
  dynamic get parsed => _parsed;

  final String _rawString;
  /// The raw string that represents this field in the input string/data.
  ///
  /// Added in version 6.10.0
  String get rawString => _rawString;

  final List<ParserIssue> _warnings;
  /// Warnings associated with this field
  ///
  /// Added in version 6.26.0
  List<ParserIssue> get warnings => _warnings;

  ParsedField._(this._name, this._parsed, this._rawString, this._warnings);

  factory ParsedField.fromJSON(Map<String, dynamic> json) {
    var warnings = <ParserIssue>[];
    if (json.containsKey('warnings') && json["warnings"] != null) {
      warnings.addAll((json['warnings'] as List<dynamic>).map((e) => ParserIssue.fromJSON(e)));
    }
    return ParsedField._(json['name'], json['parsed'], json['rawString'], warnings);
  }
}
