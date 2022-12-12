// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'style_snippet.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetStyleSnippetCollection on Isar {
  IsarCollection<StyleSnippet> get styleSnippets => this.collection();
}

const StyleSnippetSchema = CollectionSchema(
  name: r'StyleSnippet',
  id: 6487127595738180429,
  properties: {
    r'colour': PropertySchema(
      id: 0,
      name: r'colour',
      type: IsarType.long,
    ),
    r'marker': PropertySchema(
      id: 1,
      name: r'marker',
      type: IsarType.string,
    ),
    r'size': PropertySchema(
      id: 2,
      name: r'size',
      type: IsarType.double,
    ),
    r'styles': PropertySchema(
      id: 3,
      name: r'styles',
      type: IsarType.longList,
    )
  },
  estimateSize: _styleSnippetEstimateSize,
  serialize: _styleSnippetSerialize,
  deserialize: _styleSnippetDeserialize,
  deserializeProp: _styleSnippetDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _styleSnippetGetId,
  getLinks: _styleSnippetGetLinks,
  attach: _styleSnippetAttach,
  version: '3.0.5',
);

int _styleSnippetEstimateSize(
  StyleSnippet object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.marker.length * 3;
  bytesCount += 3 + object.styles.length * 8;
  return bytesCount;
}

void _styleSnippetSerialize(
  StyleSnippet object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.colour);
  writer.writeString(offsets[1], object.marker);
  writer.writeDouble(offsets[2], object.size);
  writer.writeLongList(offsets[3], object.styles);
}

StyleSnippet _styleSnippetDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StyleSnippet(
    id,
    reader.readString(offsets[1]),
    reader.readDouble(offsets[2]),
    reader.readLong(offsets[0]),
    reader.readLongList(offsets[3]) ?? [],
  );
  return object;
}

P _styleSnippetDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLongList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _styleSnippetGetId(StyleSnippet object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _styleSnippetGetLinks(StyleSnippet object) {
  return [];
}

void _styleSnippetAttach(
    IsarCollection<dynamic> col, Id id, StyleSnippet object) {
  object.id = id;
}

extension StyleSnippetQueryWhereSort
    on QueryBuilder<StyleSnippet, StyleSnippet, QWhere> {
  QueryBuilder<StyleSnippet, StyleSnippet, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StyleSnippetQueryWhere
    on QueryBuilder<StyleSnippet, StyleSnippet, QWhereClause> {
  QueryBuilder<StyleSnippet, StyleSnippet, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterWhereClause> idBetween(
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

extension StyleSnippetQueryFilter
    on QueryBuilder<StyleSnippet, StyleSnippet, QFilterCondition> {
  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition> colourEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colour',
        value: value,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      colourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colour',
        value: value,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      colourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colour',
        value: value,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition> colourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition> idGreaterThan(
    Id? value, {
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

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition> idLessThan(
    Id? value, {
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

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
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

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition> markerEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'marker',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      markerGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'marker',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      markerLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'marker',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition> markerBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'marker',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      markerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'marker',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      markerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'marker',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      markerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'marker',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition> markerMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'marker',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      markerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'marker',
        value: '',
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      markerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'marker',
        value: '',
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition> sizeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'size',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      sizeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'size',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition> sizeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'size',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition> sizeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'size',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      stylesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styles',
        value: value,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      stylesElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'styles',
        value: value,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      stylesElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'styles',
        value: value,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      stylesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'styles',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      stylesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'styles',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      stylesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'styles',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      stylesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'styles',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      stylesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'styles',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      stylesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'styles',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterFilterCondition>
      stylesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'styles',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension StyleSnippetQueryObject
    on QueryBuilder<StyleSnippet, StyleSnippet, QFilterCondition> {}

extension StyleSnippetQueryLinks
    on QueryBuilder<StyleSnippet, StyleSnippet, QFilterCondition> {}

extension StyleSnippetQuerySortBy
    on QueryBuilder<StyleSnippet, StyleSnippet, QSortBy> {
  QueryBuilder<StyleSnippet, StyleSnippet, QAfterSortBy> sortByColour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colour', Sort.asc);
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterSortBy> sortByColourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colour', Sort.desc);
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterSortBy> sortByMarker() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marker', Sort.asc);
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterSortBy> sortByMarkerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marker', Sort.desc);
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterSortBy> sortBySize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.asc);
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterSortBy> sortBySizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.desc);
    });
  }
}

extension StyleSnippetQuerySortThenBy
    on QueryBuilder<StyleSnippet, StyleSnippet, QSortThenBy> {
  QueryBuilder<StyleSnippet, StyleSnippet, QAfterSortBy> thenByColour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colour', Sort.asc);
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterSortBy> thenByColourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colour', Sort.desc);
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterSortBy> thenByMarker() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marker', Sort.asc);
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterSortBy> thenByMarkerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marker', Sort.desc);
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterSortBy> thenBySize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.asc);
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QAfterSortBy> thenBySizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.desc);
    });
  }
}

extension StyleSnippetQueryWhereDistinct
    on QueryBuilder<StyleSnippet, StyleSnippet, QDistinct> {
  QueryBuilder<StyleSnippet, StyleSnippet, QDistinct> distinctByColour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colour');
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QDistinct> distinctByMarker(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'marker', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QDistinct> distinctBySize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'size');
    });
  }

  QueryBuilder<StyleSnippet, StyleSnippet, QDistinct> distinctByStyles() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'styles');
    });
  }
}

extension StyleSnippetQueryProperty
    on QueryBuilder<StyleSnippet, StyleSnippet, QQueryProperty> {
  QueryBuilder<StyleSnippet, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StyleSnippet, int, QQueryOperations> colourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colour');
    });
  }

  QueryBuilder<StyleSnippet, String, QQueryOperations> markerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'marker');
    });
  }

  QueryBuilder<StyleSnippet, double, QQueryOperations> sizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'size');
    });
  }

  QueryBuilder<StyleSnippet, List<int>, QQueryOperations> stylesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'styles');
    });
  }
}
