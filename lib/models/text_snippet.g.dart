// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_snippet.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetTextSnippetCollection on Isar {
  IsarCollection<TextSnippet> get textSnippets => this.collection();
}

const TextSnippetSchema = CollectionSchema(
  name: r'TextSnippet',
  id: -40316447844821208,
  properties: {
    r'arguments': PropertySchema(
      id: 0,
      name: r'arguments',
      type: IsarType.stringList,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    ),
    r'unpacked': PropertySchema(
      id: 2,
      name: r'unpacked',
      type: IsarType.string,
    )
  },
  estimateSize: _textSnippetEstimateSize,
  serialize: _textSnippetSerialize,
  deserialize: _textSnippetDeserialize,
  deserializeProp: _textSnippetDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _textSnippetGetId,
  getLinks: _textSnippetGetLinks,
  attach: _textSnippetAttach,
  version: '3.0.5',
);

int _textSnippetEstimateSize(
  TextSnippet object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.arguments.length * 3;
  {
    for (var i = 0; i < object.arguments.length; i++) {
      final value = object.arguments[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.unpacked.length * 3;
  return bytesCount;
}

void _textSnippetSerialize(
  TextSnippet object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.arguments);
  writer.writeString(offsets[1], object.name);
  writer.writeString(offsets[2], object.unpacked);
}

TextSnippet _textSnippetDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TextSnippet(
    arguments: reader.readStringList(offsets[0]) ?? [],
    name: reader.readString(offsets[1]),
    unpacked: reader.readString(offsets[2]),
  );
  object.id = id;
  return object;
}

P _textSnippetDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _textSnippetGetId(TextSnippet object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _textSnippetGetLinks(TextSnippet object) {
  return [];
}

void _textSnippetAttach(
    IsarCollection<dynamic> col, Id id, TextSnippet object) {
  object.id = id;
}

extension TextSnippetQueryWhereSort
    on QueryBuilder<TextSnippet, TextSnippet, QWhere> {
  QueryBuilder<TextSnippet, TextSnippet, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TextSnippetQueryWhere
    on QueryBuilder<TextSnippet, TextSnippet, QWhereClause> {
  QueryBuilder<TextSnippet, TextSnippet, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<TextSnippet, TextSnippet, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterWhereClause> idBetween(
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

extension TextSnippetQueryFilter
    on QueryBuilder<TextSnippet, TextSnippet, QFilterCondition> {
  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      argumentsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'arguments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      argumentsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'arguments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      argumentsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'arguments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      argumentsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'arguments',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      argumentsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'arguments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      argumentsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'arguments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      argumentsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'arguments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      argumentsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'arguments',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      argumentsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'arguments',
        value: '',
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      argumentsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'arguments',
        value: '',
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      argumentsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'arguments',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      argumentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'arguments',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      argumentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'arguments',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      argumentsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'arguments',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      argumentsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'arguments',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      argumentsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'arguments',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition> unpackedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unpacked',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      unpackedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unpacked',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      unpackedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unpacked',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition> unpackedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unpacked',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      unpackedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'unpacked',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      unpackedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'unpacked',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      unpackedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'unpacked',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition> unpackedMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'unpacked',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      unpackedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unpacked',
        value: '',
      ));
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterFilterCondition>
      unpackedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'unpacked',
        value: '',
      ));
    });
  }
}

extension TextSnippetQueryObject
    on QueryBuilder<TextSnippet, TextSnippet, QFilterCondition> {}

extension TextSnippetQueryLinks
    on QueryBuilder<TextSnippet, TextSnippet, QFilterCondition> {}

extension TextSnippetQuerySortBy
    on QueryBuilder<TextSnippet, TextSnippet, QSortBy> {
  QueryBuilder<TextSnippet, TextSnippet, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterSortBy> sortByUnpacked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unpacked', Sort.asc);
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterSortBy> sortByUnpackedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unpacked', Sort.desc);
    });
  }
}

extension TextSnippetQuerySortThenBy
    on QueryBuilder<TextSnippet, TextSnippet, QSortThenBy> {
  QueryBuilder<TextSnippet, TextSnippet, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterSortBy> thenByUnpacked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unpacked', Sort.asc);
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QAfterSortBy> thenByUnpackedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unpacked', Sort.desc);
    });
  }
}

extension TextSnippetQueryWhereDistinct
    on QueryBuilder<TextSnippet, TextSnippet, QDistinct> {
  QueryBuilder<TextSnippet, TextSnippet, QDistinct> distinctByArguments() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'arguments');
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TextSnippet, TextSnippet, QDistinct> distinctByUnpacked(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unpacked', caseSensitive: caseSensitive);
    });
  }
}

extension TextSnippetQueryProperty
    on QueryBuilder<TextSnippet, TextSnippet, QQueryProperty> {
  QueryBuilder<TextSnippet, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TextSnippet, List<String>, QQueryOperations>
      argumentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'arguments');
    });
  }

  QueryBuilder<TextSnippet, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<TextSnippet, String, QQueryOperations> unpackedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unpacked');
    });
  }
}
