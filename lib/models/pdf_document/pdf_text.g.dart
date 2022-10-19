// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_text.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const PdfTextSchema = Schema(
  name: r'PdfText',
  id: -7169193563872187785,
  properties: {
    r'components': PropertySchema(
      id: 0,
      name: r'components',
      type: IsarType.objectList,
      target: r'PdfSubstring',
    )
  },
  estimateSize: _pdfTextEstimateSize,
  serialize: _pdfTextSerialize,
  deserialize: _pdfTextDeserialize,
  deserializeProp: _pdfTextDeserializeProp,
);

int _pdfTextEstimateSize(
  PdfText object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.components.length * 3;
  {
    final offsets = allOffsets[PdfSubstring]!;
    for (var i = 0; i < object.components.length; i++) {
      final value = object.components[i];
      bytesCount += PdfSubstringSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _pdfTextSerialize(
  PdfText object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<PdfSubstring>(
    offsets[0],
    allOffsets,
    PdfSubstringSchema.serialize,
    object.components,
  );
}

PdfText _pdfTextDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PdfText();
  object.components = reader.readObjectList<PdfSubstring>(
        offsets[0],
        PdfSubstringSchema.deserialize,
        allOffsets,
        PdfSubstring(),
      ) ??
      [];
  return object;
}

P _pdfTextDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<PdfSubstring>(
            offset,
            PdfSubstringSchema.deserialize,
            allOffsets,
            PdfSubstring(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PdfTextQueryFilter
    on QueryBuilder<PdfText, PdfText, QFilterCondition> {
  QueryBuilder<PdfText, PdfText, QAfterFilterCondition> componentsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'components',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PdfText, PdfText, QAfterFilterCondition> componentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'components',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PdfText, PdfText, QAfterFilterCondition> componentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'components',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PdfText, PdfText, QAfterFilterCondition>
      componentsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'components',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PdfText, PdfText, QAfterFilterCondition>
      componentsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'components',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PdfText, PdfText, QAfterFilterCondition> componentsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'components',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension PdfTextQueryObject
    on QueryBuilder<PdfText, PdfText, QFilterCondition> {
  QueryBuilder<PdfText, PdfText, QAfterFilterCondition> componentsElement(
      FilterQuery<PdfSubstring> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'components');
    });
  }
}
