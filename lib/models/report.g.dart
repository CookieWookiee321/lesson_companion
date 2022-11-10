// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetReportCollection on Isar {
  IsarCollection<Report> get reports => this.collection();
}

const ReportSchema = CollectionSchema(
  name: r'Report',
  id: 4107730612455750309,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'headingPrefix': PropertySchema(
      id: 1,
      name: r'headingPrefix',
      type: IsarType.string,
    ),
    r'homework': PropertySchema(
      id: 2,
      name: r'homework',
      type: IsarType.stringList,
    ),
    r'lessonId': PropertySchema(
      id: 3,
      name: r'lessonId',
      type: IsarType.long,
    ),
    r'linePrefix': PropertySchema(
      id: 4,
      name: r'linePrefix',
      type: IsarType.string,
    ),
    r'objectSplitter': PropertySchema(
      id: 5,
      name: r'objectSplitter',
      type: IsarType.string,
    ),
    r'studentId': PropertySchema(
      id: 6,
      name: r'studentId',
      type: IsarType.long,
    ),
    r'studentName': PropertySchema(
      id: 7,
      name: r'studentName',
      type: IsarType.string,
    ),
    r'tableSubheading': PropertySchema(
      id: 8,
      name: r'tableSubheading',
      type: IsarType.string,
    ),
    r'tables': PropertySchema(
      id: 9,
      name: r'tables',
      type: IsarType.objectList,
      target: r'PdfTableModel',
    ),
    r'topic': PropertySchema(
      id: 10,
      name: r'topic',
      type: IsarType.stringList,
    )
  },
  estimateSize: _reportEstimateSize,
  serialize: _reportSerialize,
  deserialize: _reportDeserialize,
  deserializeProp: _reportDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'PdfTableModel': PdfTableModelSchema,
    r'PdfText': PdfTextSchema,
    r'PdfSubstring': PdfSubstringSchema,
    r'PdfTableRowModel': PdfTableRowModelSchema
  },
  getId: _reportGetId,
  getLinks: _reportGetLinks,
  attach: _reportAttach,
  version: '3.0.2',
);

int _reportEstimateSize(
  Report object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.headingPrefix.length * 3;
  {
    final list = object.homework;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  bytesCount += 3 + object.linePrefix.length * 3;
  bytesCount += 3 + object.objectSplitter.length * 3;
  {
    final value = object.studentName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.tableSubheading.length * 3;
  {
    final list = object.tables;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[PdfTableModel]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              PdfTableModelSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final list = object.topic;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  return bytesCount;
}

void _reportSerialize(
  Report object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeString(offsets[1], object.headingPrefix);
  writer.writeStringList(offsets[2], object.homework);
  writer.writeLong(offsets[3], object.lessonId);
  writer.writeString(offsets[4], object.linePrefix);
  writer.writeString(offsets[5], object.objectSplitter);
  writer.writeLong(offsets[6], object.studentId);
  writer.writeString(offsets[7], object.studentName);
  writer.writeString(offsets[8], object.tableSubheading);
  writer.writeObjectList<PdfTableModel>(
    offsets[9],
    allOffsets,
    PdfTableModelSchema.serialize,
    object.tables,
  );
  writer.writeStringList(offsets[10], object.topic);
}

Report _reportDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Report();
  object.date = reader.readDateTimeOrNull(offsets[0]);
  object.homework = reader.readStringList(offsets[2]);
  object.id = id;
  object.lessonId = reader.readLongOrNull(offsets[3]);
  object.studentId = reader.readLongOrNull(offsets[6]);
  object.studentName = reader.readStringOrNull(offsets[7]);
  object.tables = reader.readObjectList<PdfTableModel>(
    offsets[9],
    PdfTableModelSchema.deserialize,
    allOffsets,
    PdfTableModel(),
  );
  object.topic = reader.readStringList(offsets[10]);
  return object;
}

P _reportDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringList(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readObjectList<PdfTableModel>(
        offset,
        PdfTableModelSchema.deserialize,
        allOffsets,
        PdfTableModel(),
      )) as P;
    case 10:
      return (reader.readStringList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _reportGetId(Report object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _reportGetLinks(Report object) {
  return [];
}

void _reportAttach(IsarCollection<dynamic> col, Id id, Report object) {
  object.id = id;
}

extension ReportQueryWhereSort on QueryBuilder<Report, Report, QWhere> {
  QueryBuilder<Report, Report, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ReportQueryWhere on QueryBuilder<Report, Report, QWhereClause> {
  QueryBuilder<Report, Report, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Report, Report, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Report, Report, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Report, Report, QAfterWhereClause> idBetween(
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

extension ReportQueryFilter on QueryBuilder<Report, Report, QFilterCondition> {
  QueryBuilder<Report, Report, QAfterFilterCondition> dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> dateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> dateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> dateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> dateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> headingPrefixEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'headingPrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> headingPrefixGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'headingPrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> headingPrefixLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'headingPrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> headingPrefixBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'headingPrefix',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> headingPrefixStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'headingPrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> headingPrefixEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'headingPrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> headingPrefixContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'headingPrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> headingPrefixMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'headingPrefix',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> headingPrefixIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'headingPrefix',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      headingPrefixIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'headingPrefix',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> homeworkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'homework',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> homeworkIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'homework',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> homeworkElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'homework',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      homeworkElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'homework',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> homeworkElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'homework',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> homeworkElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'homework',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> homeworkElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'homework',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> homeworkElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'homework',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> homeworkElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'homework',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> homeworkElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'homework',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> homeworkElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'homework',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      homeworkElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'homework',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> homeworkLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'homework',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> homeworkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'homework',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> homeworkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'homework',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> homeworkLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'homework',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> homeworkLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'homework',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> homeworkLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'homework',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Report, Report, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Report, Report, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Report, Report, QAfterFilterCondition> lessonIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lessonId',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> lessonIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lessonId',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> lessonIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lessonId',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> lessonIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lessonId',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> lessonIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lessonId',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> lessonIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lessonId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> linePrefixEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> linePrefixGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'linePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> linePrefixLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'linePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> linePrefixBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'linePrefix',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> linePrefixStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'linePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> linePrefixEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'linePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> linePrefixContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'linePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> linePrefixMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'linePrefix',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> linePrefixIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linePrefix',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> linePrefixIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'linePrefix',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> objectSplitterEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'objectSplitter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> objectSplitterGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'objectSplitter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> objectSplitterLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'objectSplitter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> objectSplitterBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'objectSplitter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> objectSplitterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'objectSplitter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> objectSplitterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'objectSplitter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> objectSplitterContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'objectSplitter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> objectSplitterMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'objectSplitter',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> objectSplitterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'objectSplitter',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      objectSplitterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'objectSplitter',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> studentIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'studentId',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> studentIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'studentId',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> studentIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'studentId',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> studentIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'studentId',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> studentIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'studentId',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> studentIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'studentId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> studentNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'studentName',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> studentNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'studentName',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> studentNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'studentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> studentNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'studentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> studentNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'studentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> studentNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'studentName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> studentNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'studentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> studentNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'studentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> studentNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'studentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> studentNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'studentName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> studentNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'studentName',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> studentNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'studentName',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> tableSubheadingEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tableSubheading',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      tableSubheadingGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tableSubheading',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> tableSubheadingLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tableSubheading',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> tableSubheadingBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tableSubheading',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> tableSubheadingStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tableSubheading',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> tableSubheadingEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tableSubheading',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> tableSubheadingContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tableSubheading',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> tableSubheadingMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tableSubheading',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> tableSubheadingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tableSubheading',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      tableSubheadingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tableSubheading',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> tablesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tables',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> tablesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tables',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> tablesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tables',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> tablesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tables',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> tablesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tables',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> tablesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tables',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> tablesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tables',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> tablesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tables',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> topicIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'topic',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> topicIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'topic',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> topicElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> topicElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'topic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> topicElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'topic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> topicElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'topic',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> topicElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'topic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> topicElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'topic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> topicElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'topic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> topicElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'topic',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> topicElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topic',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> topicElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'topic',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> topicLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'topic',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> topicIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'topic',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> topicIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'topic',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> topicLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'topic',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> topicLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'topic',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> topicLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'topic',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ReportQueryObject on QueryBuilder<Report, Report, QFilterCondition> {
  QueryBuilder<Report, Report, QAfterFilterCondition> tablesElement(
      FilterQuery<PdfTableModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'tables');
    });
  }
}

extension ReportQueryLinks on QueryBuilder<Report, Report, QFilterCondition> {}

extension ReportQuerySortBy on QueryBuilder<Report, Report, QSortBy> {
  QueryBuilder<Report, Report, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByHeadingPrefix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headingPrefix', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByHeadingPrefixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headingPrefix', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByLessonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lessonId', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByLessonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lessonId', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByLinePrefix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linePrefix', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByLinePrefixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linePrefix', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByObjectSplitter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'objectSplitter', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByObjectSplitterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'objectSplitter', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByStudentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studentId', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByStudentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studentId', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByStudentName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studentName', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByStudentNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studentName', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByTableSubheading() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableSubheading', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByTableSubheadingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableSubheading', Sort.desc);
    });
  }
}

extension ReportQuerySortThenBy on QueryBuilder<Report, Report, QSortThenBy> {
  QueryBuilder<Report, Report, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByHeadingPrefix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headingPrefix', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByHeadingPrefixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headingPrefix', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByLessonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lessonId', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByLessonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lessonId', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByLinePrefix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linePrefix', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByLinePrefixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linePrefix', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByObjectSplitter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'objectSplitter', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByObjectSplitterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'objectSplitter', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByStudentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studentId', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByStudentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studentId', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByStudentName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studentName', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByStudentNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studentName', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByTableSubheading() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableSubheading', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByTableSubheadingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableSubheading', Sort.desc);
    });
  }
}

extension ReportQueryWhereDistinct on QueryBuilder<Report, Report, QDistinct> {
  QueryBuilder<Report, Report, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByHeadingPrefix(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'headingPrefix',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByHomework() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'homework');
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByLessonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lessonId');
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByLinePrefix(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'linePrefix', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByObjectSplitter(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'objectSplitter',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByStudentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'studentId');
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByStudentName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'studentName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByTableSubheading(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tableSubheading',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByTopic() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topic');
    });
  }
}

extension ReportQueryProperty on QueryBuilder<Report, Report, QQueryProperty> {
  QueryBuilder<Report, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Report, DateTime?, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<Report, String, QQueryOperations> headingPrefixProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'headingPrefix');
    });
  }

  QueryBuilder<Report, List<String>?, QQueryOperations> homeworkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'homework');
    });
  }

  QueryBuilder<Report, int?, QQueryOperations> lessonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lessonId');
    });
  }

  QueryBuilder<Report, String, QQueryOperations> linePrefixProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linePrefix');
    });
  }

  QueryBuilder<Report, String, QQueryOperations> objectSplitterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'objectSplitter');
    });
  }

  QueryBuilder<Report, int?, QQueryOperations> studentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'studentId');
    });
  }

  QueryBuilder<Report, String?, QQueryOperations> studentNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'studentName');
    });
  }

  QueryBuilder<Report, String, QQueryOperations> tableSubheadingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tableSubheading');
    });
  }

  QueryBuilder<Report, List<PdfTableModel>?, QQueryOperations>
      tablesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tables');
    });
  }

  QueryBuilder<Report, List<String>?, QQueryOperations> topicProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topic');
    });
  }
}
