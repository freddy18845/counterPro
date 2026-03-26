// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetInventoryLogCollection on Isar {
  IsarCollection<InventoryLog> get inventoryLogs => this.collection();
}

const InventoryLogSchema = CollectionSchema(
  name: r'InventoryLog',
  id: 896598393566791370,
  properties: {
    r'action': PropertySchema(
      id: 0,
      name: r'action',
      type: IsarType.string,
      enumMap: _InventoryLogactionEnumValueMap,
    ),
    r'note': PropertySchema(
      id: 1,
      name: r'note',
      type: IsarType.string,
    ),
    r'performedByUserId': PropertySchema(
      id: 2,
      name: r'performedByUserId',
      type: IsarType.long,
    ),
    r'productId': PropertySchema(
      id: 3,
      name: r'productId',
      type: IsarType.long,
    ),
    r'productName': PropertySchema(
      id: 4,
      name: r'productName',
      type: IsarType.string,
    ),
    r'quantityAfter': PropertySchema(
      id: 5,
      name: r'quantityAfter',
      type: IsarType.long,
    ),
    r'quantityBefore': PropertySchema(
      id: 6,
      name: r'quantityBefore',
      type: IsarType.long,
    ),
    r'quantityChanged': PropertySchema(
      id: 7,
      name: r'quantityChanged',
      type: IsarType.long,
    ),
    r'timestamp': PropertySchema(
      id: 8,
      name: r'timestamp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _inventoryLogEstimateSize,
  serialize: _inventoryLogSerialize,
  deserialize: _inventoryLogDeserialize,
  deserializeProp: _inventoryLogDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _inventoryLogGetId,
  getLinks: _inventoryLogGetLinks,
  attach: _inventoryLogAttach,
  version: '3.1.0+1',
);

int _inventoryLogEstimateSize(
  InventoryLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.action.name.length * 3;
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.productName.length * 3;
  return bytesCount;
}

void _inventoryLogSerialize(
  InventoryLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.action.name);
  writer.writeString(offsets[1], object.note);
  writer.writeLong(offsets[2], object.performedByUserId);
  writer.writeLong(offsets[3], object.productId);
  writer.writeString(offsets[4], object.productName);
  writer.writeLong(offsets[5], object.quantityAfter);
  writer.writeLong(offsets[6], object.quantityBefore);
  writer.writeLong(offsets[7], object.quantityChanged);
  writer.writeDateTime(offsets[8], object.timestamp);
}

InventoryLog _inventoryLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = InventoryLog();
  object.action =
      _InventoryLogactionValueEnumMap[reader.readStringOrNull(offsets[0])] ??
          InventoryAction.stockIn;
  object.id = id;
  object.note = reader.readStringOrNull(offsets[1]);
  object.performedByUserId = reader.readLong(offsets[2]);
  object.productId = reader.readLong(offsets[3]);
  object.productName = reader.readString(offsets[4]);
  object.quantityAfter = reader.readLong(offsets[5]);
  object.quantityBefore = reader.readLong(offsets[6]);
  object.quantityChanged = reader.readLong(offsets[7]);
  object.timestamp = reader.readDateTime(offsets[8]);
  return object;
}

P _inventoryLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_InventoryLogactionValueEnumMap[
              reader.readStringOrNull(offset)] ??
          InventoryAction.stockIn) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _InventoryLogactionEnumValueMap = {
  r'stockIn': r'stockIn',
  r'stockOut': r'stockOut',
  r'adjustment': r'adjustment',
  r'saleDeduction': r'saleDeduction',
};
const _InventoryLogactionValueEnumMap = {
  r'stockIn': InventoryAction.stockIn,
  r'stockOut': InventoryAction.stockOut,
  r'adjustment': InventoryAction.adjustment,
  r'saleDeduction': InventoryAction.saleDeduction,
};

Id _inventoryLogGetId(InventoryLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _inventoryLogGetLinks(InventoryLog object) {
  return [];
}

void _inventoryLogAttach(
    IsarCollection<dynamic> col, Id id, InventoryLog object) {
  object.id = id;
}

extension InventoryLogQueryWhereSort
    on QueryBuilder<InventoryLog, InventoryLog, QWhere> {
  QueryBuilder<InventoryLog, InventoryLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension InventoryLogQueryWhere
    on QueryBuilder<InventoryLog, InventoryLog, QWhereClause> {
  QueryBuilder<InventoryLog, InventoryLog, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<InventoryLog, InventoryLog, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterWhereClause> idBetween(
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

extension InventoryLogQueryFilter
    on QueryBuilder<InventoryLog, InventoryLog, QFilterCondition> {
  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition> actionEqualTo(
    InventoryAction value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      actionGreaterThan(
    InventoryAction value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      actionLessThan(
    InventoryAction value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition> actionBetween(
    InventoryAction lower,
    InventoryAction upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'action',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      actionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      actionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      actionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition> actionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'action',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      actionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'action',
        value: '',
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      actionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'action',
        value: '',
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition> idBetween(
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

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition> noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition> noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition> noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition> noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition> noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition> noteContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition> noteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      performedByUserIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'performedByUserId',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      performedByUserIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'performedByUserId',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      performedByUserIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'performedByUserId',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      performedByUserIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'performedByUserId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      productIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      productIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      productIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      productIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      productNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      productNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      productNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      productNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      productNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      productNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      productNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      productNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'productName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      productNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productName',
        value: '',
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      productNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'productName',
        value: '',
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      quantityAfterEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quantityAfter',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      quantityAfterGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quantityAfter',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      quantityAfterLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quantityAfter',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      quantityAfterBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quantityAfter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      quantityBeforeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quantityBefore',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      quantityBeforeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quantityBefore',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      quantityBeforeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quantityBefore',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      quantityBeforeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quantityBefore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      quantityChangedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quantityChanged',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      quantityChangedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quantityChanged',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      quantityChangedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quantityChanged',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      quantityChangedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quantityChanged',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterFilterCondition>
      timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension InventoryLogQueryObject
    on QueryBuilder<InventoryLog, InventoryLog, QFilterCondition> {}

extension InventoryLogQueryLinks
    on QueryBuilder<InventoryLog, InventoryLog, QFilterCondition> {}

extension InventoryLogQuerySortBy
    on QueryBuilder<InventoryLog, InventoryLog, QSortBy> {
  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> sortByAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> sortByActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.desc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy>
      sortByPerformedByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performedByUserId', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy>
      sortByPerformedByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performedByUserId', Sort.desc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> sortByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> sortByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> sortByProductName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy>
      sortByProductNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.desc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> sortByQuantityAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantityAfter', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy>
      sortByQuantityAfterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantityAfter', Sort.desc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy>
      sortByQuantityBefore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantityBefore', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy>
      sortByQuantityBeforeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantityBefore', Sort.desc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy>
      sortByQuantityChanged() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantityChanged', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy>
      sortByQuantityChangedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantityChanged', Sort.desc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension InventoryLogQuerySortThenBy
    on QueryBuilder<InventoryLog, InventoryLog, QSortThenBy> {
  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> thenByAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> thenByActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.desc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy>
      thenByPerformedByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performedByUserId', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy>
      thenByPerformedByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performedByUserId', Sort.desc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> thenByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> thenByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> thenByProductName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy>
      thenByProductNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.desc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> thenByQuantityAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantityAfter', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy>
      thenByQuantityAfterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantityAfter', Sort.desc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy>
      thenByQuantityBefore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantityBefore', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy>
      thenByQuantityBeforeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantityBefore', Sort.desc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy>
      thenByQuantityChanged() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantityChanged', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy>
      thenByQuantityChangedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantityChanged', Sort.desc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QAfterSortBy> thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension InventoryLogQueryWhereDistinct
    on QueryBuilder<InventoryLog, InventoryLog, QDistinct> {
  QueryBuilder<InventoryLog, InventoryLog, QDistinct> distinctByAction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'action', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QDistinct>
      distinctByPerformedByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'performedByUserId');
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QDistinct> distinctByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productId');
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QDistinct> distinctByProductName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QDistinct>
      distinctByQuantityAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quantityAfter');
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QDistinct>
      distinctByQuantityBefore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quantityBefore');
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QDistinct>
      distinctByQuantityChanged() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quantityChanged');
    });
  }

  QueryBuilder<InventoryLog, InventoryLog, QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension InventoryLogQueryProperty
    on QueryBuilder<InventoryLog, InventoryLog, QQueryProperty> {
  QueryBuilder<InventoryLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<InventoryLog, InventoryAction, QQueryOperations>
      actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'action');
    });
  }

  QueryBuilder<InventoryLog, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<InventoryLog, int, QQueryOperations>
      performedByUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'performedByUserId');
    });
  }

  QueryBuilder<InventoryLog, int, QQueryOperations> productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productId');
    });
  }

  QueryBuilder<InventoryLog, String, QQueryOperations> productNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productName');
    });
  }

  QueryBuilder<InventoryLog, int, QQueryOperations> quantityAfterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quantityAfter');
    });
  }

  QueryBuilder<InventoryLog, int, QQueryOperations> quantityBeforeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quantityBefore');
    });
  }

  QueryBuilder<InventoryLog, int, QQueryOperations> quantityChangedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quantityChanged');
    });
  }

  QueryBuilder<InventoryLog, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}
