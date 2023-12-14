/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

enum ParserDataFormat {
  gs1Ai('gs1ai'),
  hibc('hibc'),
  dlid('dlid'),
  mrtd('mrtd'),
  swissQr('swissQr'),
  vin('vin'),
  usUsid('usUsid');

  const ParserDataFormat(this._name);

  @override
  String toString() => _name;

  final String _name;
}
