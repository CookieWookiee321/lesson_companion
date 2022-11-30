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
    r'headingPrefix': PropertySchema(
      id: 0,
      name: r'headingPrefix',
      type: IsarType.string,
    ),
    r'linePrefix': PropertySchema(
      id: 1,
      name: r'linePrefix',
      type: IsarType.string,
    ),
    r'objectSplitter': PropertySchema(
      id: 2,
      name: r'objectSplitter',
      type: IsarType.string,
    ),
    r'tableSubheading': PropertySchema(
      id: 3,
      name: r'tableSubheading',
      type: IsarType.string,
    ),
    r'text': PropertySchema(
      id: 4,
      name: r'text',
      type: IsarType.string,
    )
  },
  estimateSize: _reportEstimateSize,
  serialize: _reportSerialize,
  deserialize: _reportDeserialize,
  deserializeProp: _reportDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
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
  bytesCount += 3 + object.linePrefix.length * 3;
  bytesCount += 3 + object.objectSplitter.length * 3;
  bytesCount += 3 + object.tableSubheading.length * 3;
  bytesCount += 3 + object.text.length * 3;
  return bytesCount;
}

void _reportSerialize(
  Report object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.headingPrefix);
  writer.writeString(offsets[1], object.linePrefix);
  writer.writeString(offsets[2], object.objectSplitter);
  writer.writeString(offsets[3], object.tableSubheading);
  writer.writeString(offsets[4], object.text);
}

Report _reportDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Report(
    reader.readString(offsets[4]),
  );
  object.id = id;
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
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
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

  QueryBuilder<Report, Report, QAfterFilterCondition> textEqualTo(
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

  QueryBuilder<Report, Report, QAfterFilterCondition> textGreaterThan(
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

  QueryBuilder<Report, Report, QAfterFilterCondition> textLessThan(
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

  QueryBuilder<Report, Report, QAfterFilterCondition> textBetween(
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

  QueryBuilder<Report, Report, QAfterFilterCondition> textStartsWith(
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

  QueryBuilder<Report, Report, QAfterFilterCondition> textEndsWith(
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

  QueryBuilder<Report, Report, QAfterFilterCondition> textContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> textMatches(
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

  QueryBuilder<Report, Report, QAfterFilterCondition> textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }
}

extension ReportQueryObject on QueryBuilder<Report, Report, QFilterCondition> {}

extension ReportQueryLinks on QueryBuilder<Report, Report, QFilterCondition> {}

extension ReportQuerySortBy on QueryBuilder<Report, Report, QSortBy> {
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

  QueryBuilder<Report, Report, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension ReportQuerySortThenBy on QueryBuilder<Report, Report, QSortThenBy> {
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

  QueryBuilder<Report, Report, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension ReportQueryWhereDistinct on QueryBuilder<Report, Report, QDistinct> {
  QueryBuilder<Report, Report, QDistinct> distinctByHeadingPrefix(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'headingPrefix',
          caseSensitive: caseSensitive);
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

  QueryBuilder<Report, Report, QDistinct> distinctByTableSubheading(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tableSubheading',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }
}

extension ReportQueryProperty on QueryBuilder<Report, Report, QQueryProperty> {
  QueryBuilder<Report, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Report, String, QQueryOperations> headingPrefixProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'headingPrefix');
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

  QueryBuilder<Report, String, QQueryOperations> tableSubheadingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tableSubheading');
    });
  }

  QueryBuilder<Report, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }
}
