/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

enum ParserDataFormat {
  gs1Ai('gs1ai'),
  hibc('hibc'),
  swissQr('swissqr'),
  vin('vin'),
  iataBcbp('iata_bcbp'),
  gs1DigitalLink('gs1_digital_link');

  const ParserDataFormat(this._name);

  @override
  String toString() => _name;

  final String _name;
}
