// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_document.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetPdfDocCollection on Isar {
  IsarCollection<PdfDoc> get pdfDocs => this.collection();
}

const PdfDocSchema = CollectionSchema(
  name: r'PdfDoc',
  id: 2078896034367170468,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.object,
      target: r'PdfText',
    ),
    r'homework': PropertySchema(
      id: 1,
      name: r'homework',
      type: IsarType.object,
      target: r'PdfText',
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.object,
      target: r'PdfText',
    ),
    r'table1': PropertySchema(
      id: 3,
      name: r'table1',
      type: IsarType.object,
      target: r'PdfTable',
    ),
    r'table2': PropertySchema(
      id: 4,
      name: r'table2',
      type: IsarType.object,
      target: r'PdfTable',
    ),
    r'table3': PropertySchema(
      id: 5,
      name: r'table3',
      type: IsarType.object,
      target: r'PdfTable',
    ),
    r'topic': PropertySchema(
      id: 6,
      name: r'topic',
      type: IsarType.object,
      target: r'PdfText',
    )
  },
  estimateSize: _pdfDocEstimateSize,
  serialize: _pdfDocSerialize,
  deserialize: _pdfDocDeserialize,
  deserializeProp: _pdfDocDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'PdfText': PdfTextSchema,
    r'PdfSubstring': PdfSubstringSchema,
    r'PdfTable': PdfTableSchema,
    r'PdfTableRow': PdfTableRowSchema
  },
  getId: _pdfDocGetId,
  getLinks: _pdfDocGetLinks,
  attach: _pdfDocAttach,
  version: '3.0.2',
);

int _pdfDocEstimateSize(
  PdfDoc object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 +
      PdfTextSchema.estimateSize(object.date, allOffsets[PdfText]!, allOffsets);
  {
    final value = object.homework;
    if (value != null) {
      bytesCount += 3 +
          PdfTextSchema.estimateSize(value, allOffsets[PdfText]!, allOffsets);
    }
  }
  bytesCount += 3 +
      PdfTextSchema.estimateSize(object.name, allOffsets[PdfText]!, allOffsets);
  bytesCount += 3 +
      PdfTableSchema.estimateSize(
          object.table1, allOffsets[PdfTableModel]!, allOffsets);
  {
    final value = object.table2;
    if (value != null) {
      bytesCount += 3 +
          PdfTableSchema.estimateSize(
              value, allOffsets[PdfTableModel]!, allOffsets);
    }
  }
  {
    final value = object.table3;
    if (value != null) {
      bytesCount += 3 +
          PdfTableSchema.estimateSize(
              value, allOffsets[PdfTableModel]!, allOffsets);
    }
  }
  bytesCount += 3 +
      PdfTextSchema.estimateSize(
          object.topic, allOffsets[PdfText]!, allOffsets);
  return bytesCount;
}

void _pdfDocSerialize(
  PdfDoc object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<PdfText>(
    offsets[0],
    allOffsets,
    PdfTextSchema.serialize,
    object.date,
  );
  writer.writeObject<PdfText>(
    offsets[1],
    allOffsets,
    PdfTextSchema.serialize,
    object.homework,
  );
  writer.writeObject<PdfText>(
    offsets[2],
    allOffsets,
    PdfTextSchema.serialize,
    object.name,
  );
  writer.writeObject<PdfTableModel>(
    offsets[3],
    allOffsets,
    PdfTableSchema.serialize,
    object.table1,
  );
  writer.writeObject<PdfTableModel>(
    offsets[4],
    allOffsets,
    PdfTableSchema.serialize,
    object.table2,
  );
  writer.writeObject<PdfTableModel>(
    offsets[5],
    allOffsets,
    PdfTableSchema.serialize,
    object.table3,
  );
  writer.writeObject<PdfText>(
    offsets[6],
    allOffsets,
    PdfTextSchema.serialize,
    object.topic,
  );
}

PdfDoc _pdfDocDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PdfDoc(
    reader.readObjectOrNull<PdfText>(
          offsets[2],
          PdfTextSchema.deserialize,
          allOffsets,
        ) ??
        PdfText(),
    reader.readObjectOrNull<PdfText>(
          offsets[0],
          PdfTextSchema.deserialize,
          allOffsets,
        ) ??
        PdfText(),
    reader.readObjectOrNull<PdfText>(
          offsets[6],
          PdfTextSchema.deserialize,
          allOffsets,
        ) ??
        PdfText(),
    reader.readObjectOrNull<PdfText>(
      offsets[1],
      PdfTextSchema.deserialize,
      allOffsets,
    ),
    reader.readObjectOrNull<PdfTableModel>(
          offsets[3],
          PdfTableSchema.deserialize,
          allOffsets,
        ) ??
        PdfTableModel(),
    reader.readObjectOrNull<PdfTableModel>(
      offsets[4],
      PdfTableSchema.deserialize,
      allOffsets,
    ),
    reader.readObjectOrNull<PdfTableModel>(
      offsets[5],
      PdfTableSchema.deserialize,
      allOffsets,
    ),
  );
  return object;
}

P _pdfDocDeserializeProp<P>(
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
          ) ??
          PdfText()) as P;
    case 1:
      return (reader.readObjectOrNull<PdfText>(
        offset,
        PdfTextSchema.deserialize,
        allOffsets,
      )) as P;
    case 2:
      return (reader.readObjectOrNull<PdfText>(
            offset,
            PdfTextSchema.deserialize,
            allOffsets,
          ) ??
          PdfText()) as P;
    case 3:
      return (reader.readObjectOrNull<PdfTableModel>(
            offset,
            PdfTableSchema.deserialize,
            allOffsets,
          ) ??
          PdfTableModel()) as P;
    case 4:
      return (reader.readObjectOrNull<PdfTableModel>(
        offset,
        PdfTableSchema.deserialize,
        allOffsets,
      )) as P;
    case 5:
      return (reader.readObjectOrNull<PdfTableModel>(
        offset,
        PdfTableSchema.deserialize,
        allOffsets,
      )) as P;
    case 6:
      return (reader.readObjectOrNull<PdfText>(
            offset,
            PdfTextSchema.deserialize,
            allOffsets,
          ) ??
          PdfText()) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pdfDocGetId(PdfDoc object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pdfDocGetLinks(PdfDoc object) {
  return [];
}

void _pdfDocAttach(IsarCollection<dynamic> col, Id id, PdfDoc object) {}

extension PdfDocQueryWhereSort on QueryBuilder<PdfDoc, PdfDoc, QWhere> {
  QueryBuilder<PdfDoc, PdfDoc, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PdfDocQueryWhere on QueryBuilder<PdfDoc, PdfDoc, QWhereClause> {
  QueryBuilder<PdfDoc, PdfDoc, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PdfDocQueryFilter on QueryBuilder<PdfDoc, PdfDoc, QFilterCondition> {
  QueryBuilder<PdfDoc, PdfDoc, QAfterFilterCondition> homeworkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'homework',
      ));
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterFilterCondition> homeworkIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'homework',
      ));
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterFilterCondition> table2IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'table2',
      ));
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterFilterCondition> table2IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'table2',
      ));
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterFilterCondition> table3IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'table3',
      ));
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterFilterCondition> table3IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'table3',
      ));
    });
  }
}

extension PdfDocQueryObject on QueryBuilder<PdfDoc, PdfDoc, QFilterCondition> {
  QueryBuilder<PdfDoc, PdfDoc, QAfterFilterCondition> date(
      FilterQuery<PdfText> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'date');
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterFilterCondition> homework(
      FilterQuery<PdfText> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'homework');
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterFilterCondition> name(
      FilterQuery<PdfText> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'name');
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterFilterCondition> table1(
      FilterQuery<PdfTableModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'table1');
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterFilterCondition> table2(
      FilterQuery<PdfTableModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'table2');
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterFilterCondition> table3(
      FilterQuery<PdfTableModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'table3');
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterFilterCondition> topic(
      FilterQuery<PdfText> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'topic');
    });
  }
}

extension PdfDocQueryLinks on QueryBuilder<PdfDoc, PdfDoc, QFilterCondition> {}

extension PdfDocQuerySortBy on QueryBuilder<PdfDoc, PdfDoc, QSortBy> {}

extension PdfDocQuerySortThenBy on QueryBuilder<PdfDoc, PdfDoc, QSortThenBy> {
  QueryBuilder<PdfDoc, PdfDoc, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PdfDoc, PdfDoc, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension PdfDocQueryWhereDistinct on QueryBuilder<PdfDoc, PdfDoc, QDistinct> {}

extension PdfDocQueryProperty on QueryBuilder<PdfDoc, PdfDoc, QQueryProperty> {
  QueryBuilder<PdfDoc, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PdfDoc, PdfText, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<PdfDoc, PdfText?, QQueryOperations> homeworkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'homework');
    });
  }

  QueryBuilder<PdfDoc, PdfText, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<PdfDoc, PdfTableModel, QQueryOperations> table1Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'table1');
    });
  }

  QueryBuilder<PdfDoc, PdfTableModel?, QQueryOperations> table2Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'table2');
    });
  }

  QueryBuilder<PdfDoc, PdfTableModel?, QQueryOperations> table3Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'table3');
    });
  }

  QueryBuilder<PdfDoc, PdfText, QQueryOperations> topicProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topic');
    });
  }
}
