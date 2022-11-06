// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_table_row.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const PdfTableRowSchema = Schema(
  name: r'PdfTableRow',
  id: 3124125583363875615,
  properties: {
    r'lhs': PropertySchema(
      id: 0,
      name: r'lhs',
      type: IsarType.object,
      target: r'PdfText',
    ),
    r'rhs': PropertySchema(
      id: 1,
      name: r'rhs',
      type: IsarType.object,
      target: r'PdfText',
    )
  },
  estimateSize: _pdfTableRowEstimateSize,
  serialize: _pdfTableRowSerialize,
  deserialize: _pdfTableRowDeserialize,
  deserializeProp: _pdfTableRowDeserializeProp,
);

int _pdfTableRowEstimateSize(
  PdfTableRowModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.lhs;
    if (value != null) {
      bytesCount += 3 +
          PdfTextSchema.estimateSize(value, allOffsets[PdfText]!, allOffsets);
    }
  }
  {
    final value = object.rhs;
    if (value != null) {
      bytesCount += 3 +
          PdfTextSchema.estimateSize(value, allOffsets[PdfText]!, allOffsets);
    }
  }
  return bytesCount;
}

void _pdfTableRowSerialize(
  PdfTableRowModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<PdfText>(
    offsets[0],
    allOffsets,
    PdfTextSchema.serialize,
    object.lhs,
  );
  writer.writeObject<PdfText>(
    offsets[1],
    allOffsets,
    PdfTextSchema.serialize,
    object.rhs,
  );
}

PdfTableRowModel _pdfTableRowDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PdfTableRowModel();
  object.lhs = reader.readObjectOrNull<PdfText>(
    offsets[0],
    PdfTextSchema.deserialize,
    allOffsets,
  );
  object.rhs = reader.readObjectOrNull<PdfText>(
    offsets[1],
    PdfTextSchema.deserialize,
    allOffsets,
  );
  return object;
}

P _pdfTableRowDeserializeProp<P>(
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
      return (reader.readObjectOrNull<PdfText>(
        offset,
        PdfTextSchema.deserialize,
        allOffsets,
      )) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PdfTableRowQueryFilter
    on QueryBuilder<PdfTableRowModel, PdfTableRowModel, QFilterCondition> {
  QueryBuilder<PdfTableRowModel, PdfTableRowModel, QAfterFilterCondition>
      lhsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lhs',
      ));
    });
  }

  QueryBuilder<PdfTableRowModel, PdfTableRowModel, QAfterFilterCondition>
      lhsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lhs',
      ));
    });
  }

  QueryBuilder<PdfTableRowModel, PdfTableRowModel, QAfterFilterCondition>
      rhsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rhs',
      ));
    });
  }

  QueryBuilder<PdfTableRowModel, PdfTableRowModel, QAfterFilterCondition>
      rhsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rhs',
      ));
    });
  }
}

extension PdfTableRowQueryObject
    on QueryBuilder<PdfTableRowModel, PdfTableRowModel, QFilterCondition> {
  QueryBuilder<PdfTableRowModel, PdfTableRowModel, QAfterFilterCondition> lhs(
      FilterQuery<PdfText> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'lhs');
    });
  }

  QueryBuilder<PdfTableRowModel, PdfTableRowModel, QAfterFilterCondition> rhs(
      FilterQuery<PdfText> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'rhs');
    });
  }
}
