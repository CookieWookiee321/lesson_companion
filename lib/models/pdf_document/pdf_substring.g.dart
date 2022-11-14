// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_substring.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const PdfSubstringSchema = Schema(
  name: r'PdfSubstring',
  id: -4676676766713438994,
  properties: {
    r'bold': PropertySchema(
      id: 0,
      name: r'bold',
      type: IsarType.bool,
    ),
    r'color': PropertySchema(
      id: 1,
      name: r'color',
      type: IsarType.byte,
      enumMap: _PdfSubstringcolorEnumValueMap,
    ),
    r'italic': PropertySchema(
      id: 2,
      name: r'italic',
      type: IsarType.bool,
    ),
    r'text': PropertySchema(
      id: 3,
      name: r'text',
      type: IsarType.string,
    ),
    r'underlined': PropertySchema(
      id: 4,
      name: r'underlined',
      type: IsarType.bool,
    )
  },
  estimateSize: _pdfSubstringEstimateSize,
  serialize: _pdfSubstringSerialize,
  deserialize: _pdfSubstringDeserialize,
  deserializeProp: _pdfSubstringDeserializeProp,
);

int _pdfSubstringEstimateSize(
  PdfSubstring object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.text.length * 3;
  return bytesCount;
}

void _pdfSubstringSerialize(
  PdfSubstring object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.bold);
  writer.writeByte(offsets[1], object.color.index);
  writer.writeBool(offsets[2], object.italic);
  writer.writeString(offsets[3], object.text);
  writer.writeBool(offsets[4], object.underlined);
}

PdfSubstring _pdfSubstringDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PdfSubstring();
  object.bold = reader.readBool(offsets[0]);
  object.color =
      _PdfSubstringcolorValueEnumMap[reader.readByteOrNull(offsets[1])] ??
          ColorOption.purple;
  object.italic = reader.readBool(offsets[2]);
  object.text = reader.readString(offsets[3]);
  object.underlined = reader.readBool(offsets[4]);
  return object;
}

P _pdfSubstringDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (_PdfSubstringcolorValueEnumMap[reader.readByteOrNull(offset)] ??
          ColorOption.purple) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PdfSubstringcolorEnumValueMap = {
  'purple': 0,
  'orange': 1,
  'green': 2,
  'regular': 3,
  'gray': 4,
};
const _PdfSubstringcolorValueEnumMap = {
  0: ColorOption.purple,
  1: ColorOption.orange,
  2: ColorOption.green,
  3: ColorOption.regular,
  4: ColorOption.silver,
};

extension PdfSubstringQueryFilter
    on QueryBuilder<PdfSubstring, PdfSubstring, QFilterCondition> {
  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition> boldEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bold',
        value: value,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition> colorEqualTo(
      ColorOption value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      colorGreaterThan(
    ColorOption value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition> colorLessThan(
    ColorOption value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition> colorBetween(
    ColorOption lower,
    ColorOption upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition> italicEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'italic',
        value: value,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition> textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition> textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition> textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition> textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition> textContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition> textMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      underlinedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'underlined',
        value: value,
      ));
    });
  }
}

extension PdfSubstringQueryObject
    on QueryBuilder<PdfSubstring, PdfSubstring, QFilterCondition> {}
