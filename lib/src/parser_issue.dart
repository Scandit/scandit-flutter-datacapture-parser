/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

enum ParserIssueCode {
  none('none'),
  unspecified('unspecified'),
  mandatoryEpdMissing('mandatoryEpdMissing'),
  invalidDate('invalidDate'),
  stringTooShort('stringTooShort'),
  wrongStartingCharacters('wrongStartingCharacters'),
  invalidSeparationBetweenElements('invalidSeparationBetweenElements'),
  unsupportedVersion('unsupportedVersion'),
  incompleteCode('incompleteCode'),
  emptyElementContent('emptyElementContent'),
  invalidElementLength('invalidElementLength'),
  tooLongElement('tooLongElement'),
  nonEmptyElementContent('nonEmptyElementContent'),
  invalidCharsetInElement('invalidCharsetInElement'),
  tooManyAltPmtFields('tooManyAltPmtFields'),
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

enum ParserIssueAdditionalInfoKey {
  startingCharacters('startingCharacters'),
  version('version'),
  minimalVersion('minimalVersion'),
  elementName('elementName'),
  string('string'),
  length('length'),
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

class ParserIssue {
  final ParserIssueCode _code;
  ParserIssueCode get code => _code;

  final String _message;
  String get message => _message;

  final Map<ParserIssueAdditionalInfoKey, String> _additionalInfo;
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
