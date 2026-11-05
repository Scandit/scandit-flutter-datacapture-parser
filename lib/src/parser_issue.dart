/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

/// Error code identifying the cause of the parser issue.
///
/// Added in version 6.26.0
enum ParserIssueCode {
  /// No issue found
  ///
  /// Added in version 6.26.0
  none('none'),
  /// Unspecified issue found
  ///
  /// Added in version 6.26.0
  unspecified('unspecified'),
  /// Mandatory EPD missing
  ///
  /// Added in version 6.26.0
  mandatoryEpdMissing('mandatoryEpdMissing'),
  /// Invalid date
  ///
  /// Added in version 6.26.0
  invalidDate('invalidDate'),
  /// String too short
  ///
  /// Added in version 6.26.0
  stringTooShort('stringTooShort'),
  /// Wrong starting characters
  ///
  /// Added in version 6.26.0
  wrongStartingCharacters('wrongStartingCharacters'),
  /// Invalid separation between elements
  ///
  /// Added in version 6.26.0
  invalidSeparationBetweenElements('invalidSeparationBetweenElements'),
  /// Unsupported version
  ///
  /// Added in version 6.26.0
  unsupportedVersion('unsupportedVersion'),
  /// Incomplete code
  ///
  /// Added in version 6.26.0
  incompleteCode('incompleteCode'),
  /// Empty element content
  ///
  /// Added in version 6.26.0
  emptyElementContent('emptyElementContent'),
  /// Invalid element length
  ///
  /// Added in version 6.26.0
  invalidElementLength('invalidElementLength'),
  /// Element is too long
  ///
  /// Added in version 6.26.0
  tooLongElement('tooLongElement'),
  /// Content found in an element that should be empty
  ///
  /// Added in version 6.26.0
  nonEmptyElementContent('nonEmptyElementContent'),
  /// Invalid characterset in an element
  ///
  /// Added in version 6.26.0
  invalidCharsetInElement('invalidCharsetInElement'),
  /// Too many alt PMT fields
  ///
  /// Added in version 6.26.0
  tooManyAltPmtFields('tooManyAltPmtFields'),
  /// The content cannot contain spaces
  ///
  /// Added in version 6.26.0
  cannotContainSpaces('cannotContainSpaces');

  const ParserIssueCode(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension ParserIssueCodeSerializer on ParserIssueCode {
  static ParserIssueCode fromJSON(String jsonValue) {
    return ParserIssueCode.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

/// Keys used to retrieve additional info regarding an issue.
///
/// Added in version 6.26.0
enum ParserIssueAdditionalInfoKey {
  /// Added in version 6.26.0
  startingCharacters('startingCharacters'),
  /// Added in version 6.26.0
  version('version'),
  /// Added in version 6.26.0
  minimalVersion('minimalVersion'),
  /// Added in version 6.26.0
  elementName('elementName'),
  /// Added in version 6.26.0
  string('string'),
  /// Added in version 6.26.0
  length('length'),
  /// Added in version 6.26.0
  charset('charset');

  const ParserIssueAdditionalInfoKey(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension ParserIssueAdditionalInfoKeySerializer on ParserIssueAdditionalInfoKey {
  static ParserIssueAdditionalInfoKey fromJSON(String jsonValue) {
    return ParserIssueAdditionalInfoKey.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

/// Added in version 6.26.0
class ParserIssue {
  final ParserIssueCode _code;
  /// Error code identifying the cause of the issue.
  ///
  /// Added in version 6.26.0
  ParserIssueCode get code => _code;

  final String _message;
  /// English description of the error
  ///
  /// Added in version 6.26.0
  String get message => _message;

  final Map<ParserIssueAdditionalInfoKey, String> _additionalInfo;
  /// Dictionary that provides additional info regarding the error.
  ///
  /// Added in version 6.26.0
  Map<ParserIssueAdditionalInfoKey, String> get additionalInfo => _additionalInfo;

  ParserIssue._(this._code, this._message, this._additionalInfo);

  factory ParserIssue.fromJSON(Map<String, dynamic> json) {
    var code = ParserIssueCodeSerializer.fromJSON(json['code'] as String);
    var message = json['message'] as String;
    var additionalInfo = (json['additionalInfo'] as Map<String, String>)
        .map((key, value) => MapEntry(ParserIssueAdditionalInfoKeySerializer.fromJSON(key), value));
    return ParserIssue._(code, message, additionalInfo);
  }
}
