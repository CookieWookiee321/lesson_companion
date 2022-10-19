// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_table.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const PdfTableSchema = Schema(
  name: r'PdfTable',
  id: -3078727781336404101,
  properties: {
    r'heading': PropertySchema(
      id: 0,
      name: r'heading',
      type: IsarType.object,
      target: r'PdfText',
    ),
    r'rows': PropertySchema(
      id: 1,
      name: r'rows',
      type: IsarType.objectList,
      target: r'PdfTableRow',
    )
  },
  estimateSize: _pdfTableEstimateSize,
  serialize: _pdfTableSerialize,
  deserialize: _pdfTableDeserialize,
  deserializeProp: _pdfTableDeserializeProp,
);

int _pdfTableEstimateSize(
  PdfTable object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.heading;
    if (value != null) {
      bytesCount += 3 +
          PdfTextSchema.estimateSize(value, allOffsets[PdfText]!, allOffsets);
    }
  }
  {
    final list = object.rows;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[PdfTableRow]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              PdfTableRowSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  return bytesCount;
}

void _pdfTableSerialize(
  PdfTable object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<PdfText>(
    offsets[0],
    allOffsets,
    PdfTextSchema.serialize,
    object.heading,
  );
  writer.writeObjectList<PdfTableRow>(
    offsets[1],
    allOffsets,
    PdfTableRowSchema.serialize,
    object.rows,
  );
}

PdfTable _pdfTableDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PdfTable();
  object.heading = reader.readObjectOrNull<PdfText>(
    offsets[0],
    PdfTextSchema.deserialize,
    allOffsets,
  );
  object.rows = reader.readObjectList<PdfTableRow>(
    offsets[1],
    PdfTableRowSchema.deserialize,
    allOffsets,
    PdfTableRow(),
  );
  return object;
}

P _pdfTableDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<PdfText>(
        offset,
        PdfTextSchema.deserialize,
        allOffsets,
      )) as P;
    case 1:
      return (reader.readObjectList<PdfTableRow>(
        offset,
        PdfTableRowSchema.deserialize,
        allOffsets,
        PdfTableRow(),
      )) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PdfTableQueryFilter
    on QueryBuilder<PdfTable, PdfTable, QFilterCondition> {
  QueryBuilder<PdfTable, PdfTable, QAfterFilterCondition> headingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'heading',
      ));
    });
  }

  QueryBuilder<PdfTable, PdfTable, QAfterFilterCondition> headingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'heading',
      ));
    });
  }

  QueryBuilder<PdfTable, PdfTable, QAfterFilterCondition> rowsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rows',
      ));
    });
  }

  QueryBuilder<PdfTable, PdfTable, QAfterFilterCondition> rowsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rows',
      ));
    });
  }

  QueryBuilder<PdfTable, PdfTable, QAfterFilterCondition> rowsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rows',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PdfTable, PdfTable, QAfterFilterCondition> rowsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rows',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PdfTable, PdfTable, QAfterFilterCondition> rowsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rows',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PdfTable, PdfTable, QAfterFilterCondition> rowsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rows',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PdfTable, PdfTable, QAfterFilterCondition> rowsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rows',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PdfTable, PdfTable, QAfterFilterCondition> rowsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rows',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension PdfTableQueryObject
    on QueryBuilder<PdfTable, PdfTable, QFilterCondition> {
  QueryBuilder<PdfTable, PdfTable, QAfterFilterCondition> heading(
      FilterQuery<PdfText> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'heading');
    });
  }

  QueryBuilder<PdfTable, PdfTable, QAfterFilterCondition> rowsElement(
      FilterQuery<PdfTableRow> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'rows');
    });
  }
}
