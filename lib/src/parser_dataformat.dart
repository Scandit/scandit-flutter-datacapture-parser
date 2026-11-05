/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

/// Data formats supported by the [Parser].
///
/// Added in version 6.10.0
enum ParserDataFormat {
  /// GS1 Application Identifier (AI) data format for parsing GS1 General Specifications standard data, see [http://www.gs1.org/](http://www.gs1.org/)
  ///
  /// Added in version 6.10.0
  gs1Ai('gs1ai'),
  /// Health Industry Bar Code (HIBC) data format for healthcare industry applications, see [https://www.hibcc.org/](https://www.hibcc.org/)
  ///
  /// Added in version 6.10.0
  hibc('hibc'),
  /// Swiss QR-bill data format for Swiss payment processing and banking applications
  ///
  /// Added in version 6.10.0
  swissQr('swissqr'),
  /// Vehicle Identification Number (VIN) data format, see [https://www.iso.org/standard/52200.html](https://www.iso.org/standard/52200.html) and [https://www.iso.org/standard/45844.html](https://www.iso.org/standard/45844.html)
  ///
  /// Added in version 6.10.0
  vin('vin'),
  /// IATA Bar Coded Boarding Pass (BCBP) data format for airline boarding passes, see [https://www.iata.org/](https://www.iata.org/)
  ///
  /// Added in version 6.26.0
  iataBcbp('iata_bcbp'),
  /// GS1 Digital Link data format for web-based product identification, see [https://ref.gs1.org/standards/digital-link/uri-syntax/](https://ref.gs1.org/standards/digital-link/uri-syntax/)
  ///
  /// Added in version 6.26.0
  gs1DigitalLink('gs1_digital_link'),
  /// Electronic Product Code (EPC) data format, see [https://www.gs1.org/standards/epc-rfid](https://www.gs1.org/standards/epc-rfid)
  ///
  /// Currently only the RFID Tag EPC Memory Bank Contents (hexadecimal, SGTIN-96 format) is supported.
  ///
  /// Added in version 8.2.0
  epc('epc'),
  /// French 2D-Doc (ANTS) data format, see [https://ants.gouv.fr/nos-missions/les-solutions-numeriques/2d-doc](https://ants.gouv.fr/nos-missions/les-solutions-numeriques/2d-doc)
  ///
  /// The 2D-Doc header and data zone are parsed into structured fields and the signature is decoded; cryptographic signature verification against the ANTS trust list is not performed.
  ///
  /// Added in version 8.7.0
  french2dDoc('french2ddoc');

  const ParserDataFormat(this._name);

  @override
  String toString() => _name;

  final String _name;
}
