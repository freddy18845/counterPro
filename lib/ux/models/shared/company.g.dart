// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCompanyCollection on Isar {
  IsarCollection<Company> get companys => this.collection();
}

const CompanySchema = CollectionSchema(
  name: r'Company',
  id: -3921622125198845844,
  properties: {
    r'address': PropertySchema(
      id: 0,
      name: r'address',
      type: IsarType.string,
    ),
    r'companyId': PropertySchema(
      id: 1,
      name: r'companyId',
      type: IsarType.string,
    ),
    r'contactOne': PropertySchema(
      id: 2,
      name: r'contactOne',
      type: IsarType.string,
    ),
    r'contactTwo': PropertySchema(
      id: 3,
      name: r'contactTwo',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'daysUntilExpiry': PropertySchema(
      id: 5,
      name: r'daysUntilExpiry',
      type: IsarType.long,
    ),
    r'email': PropertySchema(
      id: 6,
      name: r'email',
      type: IsarType.string,
    ),
    r'isExpiringSoon': PropertySchema(
      id: 7,
      name: r'isExpiringSoon',
      type: IsarType.bool,
    ),
    r'isSubscriptionActive': PropertySchema(
      id: 8,
      name: r'isSubscriptionActive',
      type: IsarType.bool,
    ),
    r'isSubscriptionExpired': PropertySchema(
      id: 9,
      name: r'isSubscriptionExpired',
      type: IsarType.bool,
    ),
    r'logoPath': PropertySchema(
      id: 10,
      name: r'logoPath',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 11,
      name: r'name',
      type: IsarType.string,
    ),
    r'slogan': PropertySchema(
      id: 12,
      name: r'slogan',
      type: IsarType.string,
    ),
    r'subscriptionEndDate': PropertySchema(
      id: 13,
      name: r'subscriptionEndDate',
      type: IsarType.dateTime,
    ),
    r'subscriptionPlan': PropertySchema(
      id: 14,
      name: r'subscriptionPlan',
      type: IsarType.string,
      enumMap: _CompanysubscriptionPlanEnumValueMap,
    ),
    r'subscriptionStartDate': PropertySchema(
      id: 15,
      name: r'subscriptionStartDate',
      type: IsarType.dateTime,
    ),
    r'subscriptionStatus': PropertySchema(
      id: 16,
      name: r'subscriptionStatus',
      type: IsarType.string,
      enumMap: _CompanysubscriptionStatusEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 17,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _companyEstimateSize,
  serialize: _companySerialize,
  deserialize: _companyDeserialize,
  deserializeProp: _companyDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _companyGetId,
  getLinks: _companyGetLinks,
  attach: _companyAttach,
  version: '3.1.0+1',
);

int _companyEstimateSize(
  Company object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.address.length * 3;
  {
    final value = object.companyId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.contactOne.length * 3;
  bytesCount += 3 + object.contactTwo.length * 3;
  bytesCount += 3 + object.email.length * 3;
  {
    final value = object.logoPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.slogan;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.subscriptionPlan.name.length * 3;
  bytesCount += 3 + object.subscriptionStatus.name.length * 3;
  return bytesCount;
}

void _companySerialize(
  Company object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.address);
  writer.writeString(offsets[1], object.companyId);
  writer.writeString(offsets[2], object.contactOne);
  writer.writeString(offsets[3], object.contactTwo);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeLong(offsets[5], object.daysUntilExpiry);
  writer.writeString(offsets[6], object.email);
  writer.writeBool(offsets[7], object.isExpiringSoon);
  writer.writeBool(offsets[8], object.isSubscriptionActive);
  writer.writeBool(offsets[9], object.isSubscriptionExpired);
  writer.writeString(offsets[10], object.logoPath);
  writer.writeString(offsets[11], object.name);
  writer.writeString(offsets[12], object.slogan);
  writer.writeDateTime(offsets[13], object.subscriptionEndDate);
  writer.writeString(offsets[14], object.subscriptionPlan.name);
  writer.writeDateTime(offsets[15], object.subscriptionStartDate);
  writer.writeString(offsets[16], object.subscriptionStatus.name);
  writer.writeDateTime(offsets[17], object.updatedAt);
}

Company _companyDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Company();
  object.address = reader.readString(offsets[0]);
  object.companyId = reader.readStringOrNull(offsets[1]);
  object.contactOne = reader.readString(offsets[2]);
  object.contactTwo = reader.readString(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.email = reader.readString(offsets[6]);
  object.id = id;
  object.logoPath = reader.readStringOrNull(offsets[10]);
  object.name = reader.readString(offsets[11]);
  object.slogan = reader.readStringOrNull(offsets[12]);
  object.subscriptionEndDate = reader.readDateTimeOrNull(offsets[13]);
  object.subscriptionPlan = _CompanysubscriptionPlanValueEnumMap[
          reader.readStringOrNull(offsets[14])] ??
      SubscriptionPlan.basic;
  object.subscriptionStartDate = reader.readDateTimeOrNull(offsets[15]);
  object.subscriptionStatus = _CompanysubscriptionStatusValueEnumMap[
          reader.readStringOrNull(offsets[16])] ??
      SubscriptionStatus.active;
  object.updatedAt = reader.readDateTime(offsets[17]);
  return object;
}

P _companyDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 14:
      return (_CompanysubscriptionPlanValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SubscriptionPlan.basic) as P;
    case 15:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 16:
      return (_CompanysubscriptionStatusValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SubscriptionStatus.active) as P;
    case 17:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CompanysubscriptionPlanEnumValueMap = {
  r'basic': r'basic',
  r'pro': r'pro',
  r'enterprise': r'enterprise',
};
const _CompanysubscriptionPlanValueEnumMap = {
  r'basic': SubscriptionPlan.basic,
  r'pro': SubscriptionPlan.pro,
  r'enterprise': SubscriptionPlan.enterprise,
};
const _CompanysubscriptionStatusEnumValueMap = {
  r'active': r'active',
  r'expired': r'expired',
  r'cancelled': r'cancelled',
  r'trial': r'trial',
};
const _CompanysubscriptionStatusValueEnumMap = {
  r'active': SubscriptionStatus.active,
  r'expired': SubscriptionStatus.expired,
  r'cancelled': SubscriptionStatus.cancelled,
  r'trial': SubscriptionStatus.trial,
};

Id _companyGetId(Company object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _companyGetLinks(Company object) {
  return [];
}

void _companyAttach(IsarCollection<dynamic> col, Id id, Company object) {
  object.id = id;
}

extension CompanyQueryWhereSort on QueryBuilder<Company, Company, QWhere> {
  QueryBuilder<Company, Company, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CompanyQueryWhere on QueryBuilder<Company, Company, QWhereClause> {
  QueryBuilder<Company, Company, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Company, Company, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Company, Company, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Company, Company, QAfterWhereClause> idBetween(
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

extension CompanyQueryFilter
    on QueryBuilder<Company, Company, QFilterCondition> {
  QueryBuilder<Company, Company, QAfterFilterCondition> addressEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> addressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> addressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> addressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'address',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> addressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> addressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> addressContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> addressMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'address',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> companyIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'companyId',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> companyIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'companyId',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> companyIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'companyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> companyIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'companyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> companyIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'companyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> companyIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'companyId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> companyIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'companyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> companyIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'companyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> companyIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'companyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> companyIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'companyId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> companyIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'companyId',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> companyIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'companyId',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactOneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contactOne',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactOneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contactOne',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactOneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contactOne',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactOneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contactOne',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactOneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contactOne',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactOneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contactOne',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactOneContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contactOne',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactOneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contactOne',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactOneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contactOne',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactOneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contactOne',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactTwoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contactTwo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactTwoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contactTwo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactTwoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contactTwo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactTwoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contactTwo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactTwoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contactTwo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactTwoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contactTwo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactTwoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contactTwo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactTwoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contactTwo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactTwoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contactTwo',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> contactTwoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contactTwo',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> daysUntilExpiryEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'daysUntilExpiry',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      daysUntilExpiryGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'daysUntilExpiry',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> daysUntilExpiryLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'daysUntilExpiry',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> daysUntilExpiryBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'daysUntilExpiry',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> emailEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> emailGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> emailLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> emailBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'email',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> emailContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> emailMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'email',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Company, Company, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Company, Company, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Company, Company, QAfterFilterCondition> isExpiringSoonEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isExpiringSoon',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      isSubscriptionActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSubscriptionActive',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      isSubscriptionExpiredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSubscriptionExpired',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> logoPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'logoPath',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> logoPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'logoPath',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> logoPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> logoPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> logoPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> logoPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'logoPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> logoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> logoPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> logoPathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> logoPathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'logoPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> logoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> logoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'logoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Company, Company, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Company, Company, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Company, Company, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Company, Company, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Company, Company, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Company, Company, QAfterFilterCondition> nameContains(
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

  QueryBuilder<Company, Company, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<Company, Company, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> sloganIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'slogan',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> sloganIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'slogan',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> sloganEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slogan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> sloganGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slogan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> sloganLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slogan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> sloganBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slogan',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> sloganStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slogan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> sloganEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slogan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> sloganContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slogan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> sloganMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slogan',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> sloganIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slogan',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> sloganIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slogan',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionEndDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'subscriptionEndDate',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionEndDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'subscriptionEndDate',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionEndDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subscriptionEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionEndDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subscriptionEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionEndDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subscriptionEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionEndDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subscriptionEndDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> subscriptionPlanEqualTo(
    SubscriptionPlan value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subscriptionPlan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionPlanGreaterThan(
    SubscriptionPlan value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subscriptionPlan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionPlanLessThan(
    SubscriptionPlan value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subscriptionPlan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> subscriptionPlanBetween(
    SubscriptionPlan lower,
    SubscriptionPlan upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subscriptionPlan',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionPlanStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subscriptionPlan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionPlanEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subscriptionPlan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionPlanContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subscriptionPlan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> subscriptionPlanMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subscriptionPlan',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionPlanIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subscriptionPlan',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionPlanIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'subscriptionPlan',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionStartDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'subscriptionStartDate',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionStartDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'subscriptionStartDate',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionStartDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subscriptionStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionStartDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subscriptionStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionStartDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subscriptionStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionStartDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subscriptionStartDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionStatusEqualTo(
    SubscriptionStatus value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subscriptionStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionStatusGreaterThan(
    SubscriptionStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subscriptionStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionStatusLessThan(
    SubscriptionStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subscriptionStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionStatusBetween(
    SubscriptionStatus lower,
    SubscriptionStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subscriptionStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subscriptionStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subscriptionStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subscriptionStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subscriptionStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subscriptionStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition>
      subscriptionStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'subscriptionStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CompanyQueryObject
    on QueryBuilder<Company, Company, QFilterCondition> {}

extension CompanyQueryLinks
    on QueryBuilder<Company, Company, QFilterCondition> {}

extension CompanyQuerySortBy on QueryBuilder<Company, Company, QSortBy> {
  QueryBuilder<Company, Company, QAfterSortBy> sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByContactOne() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactOne', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByContactOneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactOne', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByContactTwo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactTwo', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByContactTwoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactTwo', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByDaysUntilExpiry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysUntilExpiry', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByDaysUntilExpiryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysUntilExpiry', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByIsExpiringSoon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpiringSoon', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByIsExpiringSoonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpiringSoon', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByIsSubscriptionActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSubscriptionActive', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy>
      sortByIsSubscriptionActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSubscriptionActive', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByIsSubscriptionExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSubscriptionExpired', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy>
      sortByIsSubscriptionExpiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSubscriptionExpired', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByLogoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByLogoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortBySlogan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slogan', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortBySloganDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slogan', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortBySubscriptionEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionEndDate', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortBySubscriptionEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionEndDate', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortBySubscriptionPlan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionPlan', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortBySubscriptionPlanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionPlan', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortBySubscriptionStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionStartDate', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy>
      sortBySubscriptionStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionStartDate', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortBySubscriptionStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionStatus', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortBySubscriptionStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionStatus', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension CompanyQuerySortThenBy
    on QueryBuilder<Company, Company, QSortThenBy> {
  QueryBuilder<Company, Company, QAfterSortBy> thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByContactOne() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactOne', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByContactOneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactOne', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByContactTwo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactTwo', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByContactTwoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactTwo', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByDaysUntilExpiry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysUntilExpiry', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByDaysUntilExpiryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysUntilExpiry', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByIsExpiringSoon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpiringSoon', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByIsExpiringSoonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpiringSoon', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByIsSubscriptionActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSubscriptionActive', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy>
      thenByIsSubscriptionActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSubscriptionActive', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByIsSubscriptionExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSubscriptionExpired', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy>
      thenByIsSubscriptionExpiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSubscriptionExpired', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByLogoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByLogoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenBySlogan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slogan', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenBySloganDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slogan', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenBySubscriptionEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionEndDate', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenBySubscriptionEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionEndDate', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenBySubscriptionPlan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionPlan', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenBySubscriptionPlanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionPlan', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenBySubscriptionStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionStartDate', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy>
      thenBySubscriptionStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionStartDate', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenBySubscriptionStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionStatus', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenBySubscriptionStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionStatus', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension CompanyQueryWhereDistinct
    on QueryBuilder<Company, Company, QDistinct> {
  QueryBuilder<Company, Company, QDistinct> distinctByAddress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctByCompanyId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'companyId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctByContactOne(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contactOne', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctByContactTwo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contactTwo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctByDaysUntilExpiry() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'daysUntilExpiry');
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctByEmail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctByIsExpiringSoon() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isExpiringSoon');
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctByIsSubscriptionActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSubscriptionActive');
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctByIsSubscriptionExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSubscriptionExpired');
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctByLogoPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'logoPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctBySlogan(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slogan', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctBySubscriptionEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subscriptionEndDate');
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctBySubscriptionPlan(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subscriptionPlan',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctBySubscriptionStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subscriptionStartDate');
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctBySubscriptionStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subscriptionStatus',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension CompanyQueryProperty
    on QueryBuilder<Company, Company, QQueryProperty> {
  QueryBuilder<Company, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Company, String, QQueryOperations> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<Company, String?, QQueryOperations> companyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'companyId');
    });
  }

  QueryBuilder<Company, String, QQueryOperations> contactOneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contactOne');
    });
  }

  QueryBuilder<Company, String, QQueryOperations> contactTwoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contactTwo');
    });
  }

  QueryBuilder<Company, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Company, int, QQueryOperations> daysUntilExpiryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'daysUntilExpiry');
    });
  }

  QueryBuilder<Company, String, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<Company, bool, QQueryOperations> isExpiringSoonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isExpiringSoon');
    });
  }

  QueryBuilder<Company, bool, QQueryOperations> isSubscriptionActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSubscriptionActive');
    });
  }

  QueryBuilder<Company, bool, QQueryOperations>
      isSubscriptionExpiredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSubscriptionExpired');
    });
  }

  QueryBuilder<Company, String?, QQueryOperations> logoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'logoPath');
    });
  }

  QueryBuilder<Company, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Company, String?, QQueryOperations> sloganProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slogan');
    });
  }

  QueryBuilder<Company, DateTime?, QQueryOperations>
      subscriptionEndDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subscriptionEndDate');
    });
  }

  QueryBuilder<Company, SubscriptionPlan, QQueryOperations>
      subscriptionPlanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subscriptionPlan');
    });
  }

  QueryBuilder<Company, DateTime?, QQueryOperations>
      subscriptionStartDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subscriptionStartDate');
    });
  }

  QueryBuilder<Company, SubscriptionStatus, QQueryOperations>
      subscriptionStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subscriptionStatus');
    });
  }

  QueryBuilder<Company, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
