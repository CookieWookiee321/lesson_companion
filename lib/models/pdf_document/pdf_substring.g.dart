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
    r'setText': PropertySchema(
      id: 0,
      name: r'setText',
      type: IsarType.string,
    ),
    r'setTextType': PropertySchema(
      id: 1,
      name: r'setTextType',
      type: IsarType.byte,
      enumMap: _PdfSubstringsetTextTypeEnumValueMap,
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
  bytesCount += 3 + object.setText.length * 3;
  return bytesCount;
}

void _pdfSubstringSerialize(
  PdfSubstring object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.setText);
  writer.writeByte(offsets[1], object.setTextType.index);
}

PdfSubstring _pdfSubstringDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PdfSubstring();
  object.setText = reader.readString(offsets[0]);
  object.setTextType =
      _PdfSubstringsetTextTypeValueEnumMap[reader.readByteOrNull(offsets[1])] ??
          PdfTextType.question;
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
      return (reader.readString(offset)) as P;
    case 1:
      return (_PdfSubstringsetTextTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          PdfTextType.question) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PdfSubstringsetTextTypeEnumValueMap = {
  'question': 0,
  'base': 1,
  'sub': 2,
  'example': 3,
  'info': 4,
  'tableHeader': 5,
};
const _PdfSubstringsetTextTypeValueEnumMap = {
  0: PdfTextType.question,
  1: PdfTextType.base,
  2: PdfTextType.sub,
  3: PdfTextType.example,
  4: PdfTextType.info,
  5: PdfTextType.tableHeader,
};

extension PdfSubstringQueryFilter
    on QueryBuilder<PdfSubstring, PdfSubstring, QFilterCondition> {
  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      setTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      setTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'setText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      setTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'setText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      setTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'setText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      setTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'setText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      setTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'setText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      setTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'setText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      setTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'setText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      setTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setText',
        value: '',
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      setTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'setText',
        value: '',
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      setTextTypeEqualTo(PdfTextType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setTextType',
        value: value,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      setTextTypeGreaterThan(
    PdfTextType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'setTextType',
        value: value,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      setTextTypeLessThan(
    PdfTextType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'setTextType',
        value: value,
      ));
    });
  }

  QueryBuilder<PdfSubstring, PdfSubstring, QAfterFilterCondition>
      setTextTypeBetween(
    PdfTextType lower,
    PdfTextType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'setTextType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PdfSubstringQueryObject
    on QueryBuilder<PdfSubstring, PdfSubstring, QFilterCondition> {}
