/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

enum ParserDataFormat {
  gs1Ai('gs1ai'),
  hibc('hibc'),
  @Deprecated('Use ID Capture instead.')
  dlid('dlid'),
  @Deprecated('Use ID Capture instead.')
  mrtd('mrtd'),
  swissQr('swissQr'),
  vin('vin'),
  @Deprecated('Use ID Capture instead.')
  usUsid('usUsid');

  const ParserDataFormat(this._name);

  @override
  String toString() => _name;

  final String _name;
}
