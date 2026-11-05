/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

// THIS FILE IS GENERATED. DO NOT EDIT MANUALLY.
// Generator: scripts/bridge_generator/generate.py
// Schema: scripts/bridge_generator/schemas/parser.json
//
// ignore_for_file: constant_identifier_names, non_constant_identifier_names
// Wire-format names (schema property/enum-value strings, e.g.
// `number_of_mandatory_instances`, `royal_mail_4state`) are preserved
// verbatim as Dart identifiers for fidelity with the JSON payload; they are
// not renamed to lowerCamelCase.
//
// Typed classes + throwing fromJson/toJson derived from the serialization
// JSON schemas referenced by this module's bridge params. No runtime
// dependency: validation is hand-rolled below, not json_serializable/built_value.
//
// fromJson enforces only the JSON Schema keywords expressible without a
// schema engine: required, type, enum, string const, additionalProperties,
// null-ness, and root-level oneOf (dispatched on the discriminator to the
// matching variant's fromJson).
// NOT enforced -- a payload violating one of these still parses:
//   pattern, minimum/maximum, minLength/maxLength, multipleOf, and
//   property-level oneOf of more than one non-null variant (those
//   properties are typed Object? and left unvalidated).
//
// Each plain object class also gets a top-level `buildX` function: a
// shallow-typed, validation-free map builder for outbound (Dart -> native)
// payloads. It never parses or throws.
//
// THE BUILDER CONTRACT (stated once here; each buildX carries a one-line
// pointer back to it rather than repeating this block 300+ times).
//
// Outbound payloads are deliberately NOT runtime-validated. The generated
// `fromJson` enforces `additionalProperties: false`, so validating outbound
// would turn the next property added to a public model into a customer-facing
// throw. Compile-time named parameters give the shape guarantee instead.
//
// Emit rule -- "key absent" and "key present and null" are DIFFERENT
// instructions to the deserializers, so the builder reproduces exactly what
// the caller asked for and nothing more:
//   - required                -> always written (omitting it would make
//                                `fromJson` throw "missing required property").
//   - optional, non-nullable  -> omitted when null; null means "not set".
//   - optional + nullable     -> written IF AND ONLY IF the caller passed it,
//                                including when what they passed was null.
//
// That last case is why those parameters are typed `Object?` with an `_unset`
// default instead of their schema type: Dart cannot otherwise tell "passed
// null" from "not passed", and the difference is load-bearing. The schema
// declares null a valid value for these (core/data_capture_view.json documents
// `focusGesture` as "Set to null to disable", and the C++ side branches on
// `containsNull` before falling back to the current value for an absent key),
// so writing the key when the caller stayed silent is just as wrong as
// dropping one they set. A blanket "always write" did exactly that and
// disabled every Android DataCaptureView by adding `parentId: null`, which
// `DataCaptureViewCreationData.kt` reads with `has()` + `getInt()`.
//
// Consequence worth knowing: the generated class's own `toJson()` omits an
// optional+nullable key when null, while `buildX` preserves the caller's
// explicit null. The asymmetry is intended -- `toJson` round-trips a parsed
// object (inbound), `buildX` expresses a caller's intent (outbound) -- so
// `fromJson(buildX(k: null)).toJson()` drops `k`.
//
// Nested `$ref`/array-of-`$ref` properties are typed shallowly
// (`Object?`/`List<Object?>`, not the generated nested class): those classes
// duplicate the hand-written public models (e.g. Brush, Color, Viewfinder)
// that callers already hold an already-serialized map for, so the builder
// accepts that map directly instead of requiring the generated type.

/// A data format parser component.
class Parser {
  final String type;
  final String? id;
  final String dataFormat;
  final Object? options;

  const Parser({
    required this.type,
    this.id,
    required this.dataFormat,
    this.options,
  });

  factory Parser.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Parser: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'id',
      'dataFormat',
      'options',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Parser: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("Parser.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['parser'].contains(typeRaw)) {
        throw FormatException("Parser.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('Parser.type: null is not allowed');
    }
    final hasId = raw.containsKey('id');
    final idRaw = raw['id'];
    String? idValue;
    if (hasId && idRaw != null) {
      if (idRaw is! String) {
        throw FormatException('Parser.id: expected a String');
      }
      idValue = idRaw;
    } else if (hasId && idRaw == null) {
      throw FormatException('Parser.id: null is not allowed');
    }
    final hasDataFormat = raw.containsKey('dataFormat');
    if (!hasDataFormat) {
      throw FormatException("Parser.dataFormat: missing required property");
    }
    final dataFormatRaw = raw['dataFormat'];
    String? dataFormatValue;
    if (hasDataFormat && dataFormatRaw != null) {
      if (dataFormatRaw is! String ||
          !const <String>[
            'gs1ai',
            'hibc',
            'dlid',
            'mrtd',
            'swissqr',
            'vin',
            'us_usid',
            'iata_bcbp',
            'gs1_digital_link',
            'epc',
            'french2ddoc'
          ].contains(dataFormatRaw)) {
        throw FormatException("Parser.dataFormat: unknown enum value '$dataFormatRaw'");
      }
      dataFormatValue = dataFormatRaw;
    } else if (hasDataFormat && dataFormatRaw == null) {
      throw FormatException('Parser.dataFormat: null is not allowed');
    }
    final hasOptions = raw.containsKey('options');
    final optionsRaw = raw['options'];
    Object? optionsValue;
    if (hasOptions && optionsRaw != null) {
      optionsValue = optionsRaw;
    } else if (hasOptions && optionsRaw == null) {
      throw FormatException('Parser.options: null is not allowed');
    }
    return Parser(
      type: typeValue!,
      id: idValue,
      dataFormat: dataFormatValue!,
      options: optionsValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (id != null) {
      map['id'] = id;
    }
    map['dataFormat'] = dataFormat;
    if (options != null) {
      map['options'] = options;
    }
    return map;
  }
}

/// Typed builder for the `Parser` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildParser({
  required String type,
  String? id,
  required String dataFormat,
  Object? options,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (id != null) {
    map['id'] = id;
  }
  map['dataFormat'] = dataFormat;
  if (options != null) {
    map['options'] = options;
  }
  return map;
}
