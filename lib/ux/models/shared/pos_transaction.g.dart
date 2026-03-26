// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_transaction.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPosTransactionCollection on Isar {
  IsarCollection<PosTransaction> get posTransactions => this.collection();
}

const PosTransactionSchema = CollectionSchema(
  name: r'PosTransaction',
  id: 1748761910945871487,
  properties: {
    r'amountPaid': PropertySchema(
      id: 0,
      name: r'amountPaid',
      type: IsarType.double,
    ),
    r'changeGiven': PropertySchema(
      id: 1,
      name: r'changeGiven',
      type: IsarType.double,
    ),
    r'orderNumber': PropertySchema(
      id: 2,
      name: r'orderNumber',
      type: IsarType.string,
    ),
    r'paymentMethod': PropertySchema(
      id: 3,
      name: r'paymentMethod',
      type: IsarType.string,
      enumMap: _PosTransactionpaymentMethodEnumValueMap,
    ),
    r'processedByUserId': PropertySchema(
      id: 4,
      name: r'processedByUserId',
      type: IsarType.long,
    ),
    r'refundReason': PropertySchema(
      id: 5,
      name: r'refundReason',
      type: IsarType.string,
    ),
    r'saleOrderId': PropertySchema(
      id: 6,
      name: r'saleOrderId',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 7,
      name: r'status',
      type: IsarType.string,
      enumMap: _PosTransactionstatusEnumValueMap,
    ),
    r'timestamp': PropertySchema(
      id: 8,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
    r'totalAmount': PropertySchema(
      id: 9,
      name: r'totalAmount',
      type: IsarType.double,
    ),
    r'transactionNumber': PropertySchema(
      id: 10,
      name: r'transactionNumber',
      type: IsarType.string,
    )
  },
  estimateSize: _posTransactionEstimateSize,
  serialize: _posTransactionSerialize,
  deserialize: _posTransactionDeserialize,
  deserializeProp: _posTransactionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _posTransactionGetId,
  getLinks: _posTransactionGetLinks,
  attach: _posTransactionAttach,
  version: '3.1.0+1',
);

int _posTransactionEstimateSize(
  PosTransaction object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.orderNumber.length * 3;
  bytesCount += 3 + object.paymentMethod.name.length * 3;
  {
    final value = object.refundReason;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.status.name.length * 3;
  bytesCount += 3 + object.transactionNumber.length * 3;
  return bytesCount;
}

void _posTransactionSerialize(
  PosTransaction object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amountPaid);
  writer.writeDouble(offsets[1], object.changeGiven);
  writer.writeString(offsets[2], object.orderNumber);
  writer.writeString(offsets[3], object.paymentMethod.name);
  writer.writeLong(offsets[4], object.processedByUserId);
  writer.writeString(offsets[5], object.refundReason);
  writer.writeLong(offsets[6], object.saleOrderId);
  writer.writeString(offsets[7], object.status.name);
  writer.writeDateTime(offsets[8], object.timestamp);
  writer.writeDouble(offsets[9], object.totalAmount);
  writer.writeString(offsets[10], object.transactionNumber);
}

PosTransaction _posTransactionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PosTransaction();
  object.amountPaid = reader.readDouble(offsets[0]);
  object.changeGiven = reader.readDouble(offsets[1]);
  object.id = id;
  object.orderNumber = reader.readString(offsets[2]);
  object.paymentMethod = _PosTransactionpaymentMethodValueEnumMap[
          reader.readStringOrNull(offsets[3])] ??
      PaymentMethod.cash;
  object.processedByUserId = reader.readLong(offsets[4]);
  object.refundReason = reader.readStringOrNull(offsets[5]);
  object.saleOrderId = reader.readLong(offsets[6]);
  object.status =
      _PosTransactionstatusValueEnumMap[reader.readStringOrNull(offsets[7])] ??
          PosTransactionStatus.completed;
  object.timestamp = reader.readDateTime(offsets[8]);
  object.totalAmount = reader.readDouble(offsets[9]);
  object.transactionNumber = reader.readString(offsets[10]);
  return object;
}

P _posTransactionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (_PosTransactionpaymentMethodValueEnumMap[
              reader.readStringOrNull(offset)] ??
          PaymentMethod.cash) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (_PosTransactionstatusValueEnumMap[
              reader.readStringOrNull(offset)] ??
          PosTransactionStatus.completed) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PosTransactionpaymentMethodEnumValueMap = {
  r'cash': r'cash',
  r'card': r'card',
  r'mobileMoney': r'mobileMoney',
  r'split': r'split',
};
const _PosTransactionpaymentMethodValueEnumMap = {
  r'cash': PaymentMethod.cash,
  r'card': PaymentMethod.card,
  r'mobileMoney': PaymentMethod.mobileMoney,
  r'split': PaymentMethod.split,
};
const _PosTransactionstatusEnumValueMap = {
  r'completed': r'completed',
  r'refunded': r'refunded',
  r'voided': r'voided',
};
const _PosTransactionstatusValueEnumMap = {
  r'completed': PosTransactionStatus.completed,
  r'refunded': PosTransactionStatus.refunded,
  r'voided': PosTransactionStatus.voided,
};

Id _posTransactionGetId(PosTransaction object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _posTransactionGetLinks(PosTransaction object) {
  return [];
}

void _posTransactionAttach(
    IsarCollection<dynamic> col, Id id, PosTransaction object) {
  object.id = id;
}

extension PosTransactionQueryWhereSort
    on QueryBuilder<PosTransaction, PosTransaction, QWhere> {
  QueryBuilder<PosTransaction, PosTransaction, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PosTransactionQueryWhere
    on QueryBuilder<PosTransaction, PosTransaction, QWhereClause> {
  QueryBuilder<PosTransaction, PosTransaction, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<PosTransaction, PosTransaction, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterWhereClause> idBetween(
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

extension PosTransactionQueryFilter
    on QueryBuilder<PosTransaction, PosTransaction, QFilterCondition> {
  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      amountPaidEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amountPaid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      amountPaidGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amountPaid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      amountPaidLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amountPaid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      amountPaidBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amountPaid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      changeGivenEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'changeGiven',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      changeGivenGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'changeGiven',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      changeGivenLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'changeGiven',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      changeGivenBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'changeGiven',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      orderNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      orderNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      orderNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      orderNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      orderNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'orderNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      orderNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'orderNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      orderNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'orderNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      orderNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'orderNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      orderNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      orderNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'orderNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      paymentMethodEqualTo(
    PaymentMethod value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      paymentMethodGreaterThan(
    PaymentMethod value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      paymentMethodLessThan(
    PaymentMethod value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      paymentMethodBetween(
    PaymentMethod lower,
    PaymentMethod upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentMethod',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      paymentMethodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      paymentMethodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      paymentMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      paymentMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'paymentMethod',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      paymentMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      paymentMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'paymentMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      processedByUserIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'processedByUserId',
        value: value,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      processedByUserIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'processedByUserId',
        value: value,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      processedByUserIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'processedByUserId',
        value: value,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      processedByUserIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'processedByUserId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      refundReasonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'refundReason',
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      refundReasonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'refundReason',
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      refundReasonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'refundReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      refundReasonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'refundReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      refundReasonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'refundReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      refundReasonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'refundReason',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      refundReasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'refundReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      refundReasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'refundReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      refundReasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'refundReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      refundReasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'refundReason',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      refundReasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'refundReason',
        value: '',
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      refundReasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'refundReason',
        value: '',
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      saleOrderIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saleOrderId',
        value: value,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      saleOrderIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'saleOrderId',
        value: value,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      saleOrderIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'saleOrderId',
        value: value,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      saleOrderIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'saleOrderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      statusEqualTo(
    PosTransactionStatus value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      statusGreaterThan(
    PosTransactionStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      statusLessThan(
    PosTransactionStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      statusBetween(
    PosTransactionStatus lower,
    PosTransactionStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
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

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
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

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
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

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      totalAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      totalAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      totalAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      totalAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      transactionNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transactionNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      transactionNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transactionNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      transactionNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transactionNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      transactionNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transactionNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      transactionNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'transactionNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      transactionNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'transactionNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      transactionNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'transactionNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      transactionNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'transactionNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      transactionNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transactionNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterFilterCondition>
      transactionNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'transactionNumber',
        value: '',
      ));
    });
  }
}

extension PosTransactionQueryObject
    on QueryBuilder<PosTransaction, PosTransaction, QFilterCondition> {}

extension PosTransactionQueryLinks
    on QueryBuilder<PosTransaction, PosTransaction, QFilterCondition> {}

extension PosTransactionQuerySortBy
    on QueryBuilder<PosTransaction, PosTransaction, QSortBy> {
  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortByAmountPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountPaid', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortByAmountPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountPaid', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortByChangeGiven() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'changeGiven', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortByChangeGivenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'changeGiven', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortByOrderNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderNumber', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortByOrderNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderNumber', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortByPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortByProcessedByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processedByUserId', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortByProcessedByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processedByUserId', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortByRefundReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refundReason', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortByRefundReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refundReason', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortBySaleOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderId', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortBySaleOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderId', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortByTotalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortByTransactionNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionNumber', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      sortByTransactionNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionNumber', Sort.desc);
    });
  }
}

extension PosTransactionQuerySortThenBy
    on QueryBuilder<PosTransaction, PosTransaction, QSortThenBy> {
  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenByAmountPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountPaid', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenByAmountPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountPaid', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenByChangeGiven() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'changeGiven', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenByChangeGivenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'changeGiven', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenByOrderNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderNumber', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenByOrderNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderNumber', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenByPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenByProcessedByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processedByUserId', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenByProcessedByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processedByUserId', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenByRefundReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refundReason', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenByRefundReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refundReason', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenBySaleOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderId', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenBySaleOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderId', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenByTotalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.desc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenByTransactionNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionNumber', Sort.asc);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QAfterSortBy>
      thenByTransactionNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionNumber', Sort.desc);
    });
  }
}

extension PosTransactionQueryWhereDistinct
    on QueryBuilder<PosTransaction, PosTransaction, QDistinct> {
  QueryBuilder<PosTransaction, PosTransaction, QDistinct>
      distinctByAmountPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountPaid');
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QDistinct>
      distinctByChangeGiven() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'changeGiven');
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QDistinct> distinctByOrderNumber(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QDistinct>
      distinctByPaymentMethod({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentMethod',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QDistinct>
      distinctByProcessedByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'processedByUserId');
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QDistinct>
      distinctByRefundReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'refundReason', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QDistinct>
      distinctBySaleOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saleOrderId');
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QDistinct>
      distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QDistinct>
      distinctByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalAmount');
    });
  }

  QueryBuilder<PosTransaction, PosTransaction, QDistinct>
      distinctByTransactionNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transactionNumber',
          caseSensitive: caseSensitive);
    });
  }
}

extension PosTransactionQueryProperty
    on QueryBuilder<PosTransaction, PosTransaction, QQueryProperty> {
  QueryBuilder<PosTransaction, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PosTransaction, double, QQueryOperations> amountPaidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountPaid');
    });
  }

  QueryBuilder<PosTransaction, double, QQueryOperations> changeGivenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'changeGiven');
    });
  }

  QueryBuilder<PosTransaction, String, QQueryOperations> orderNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderNumber');
    });
  }

  QueryBuilder<PosTransaction, PaymentMethod, QQueryOperations>
      paymentMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentMethod');
    });
  }

  QueryBuilder<PosTransaction, int, QQueryOperations>
      processedByUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'processedByUserId');
    });
  }

  QueryBuilder<PosTransaction, String?, QQueryOperations>
      refundReasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'refundReason');
    });
  }

  QueryBuilder<PosTransaction, int, QQueryOperations> saleOrderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saleOrderId');
    });
  }

  QueryBuilder<PosTransaction, PosTransactionStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<PosTransaction, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<PosTransaction, double, QQueryOperations> totalAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalAmount');
    });
  }

  QueryBuilder<PosTransaction, String, QQueryOperations>
      transactionNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transactionNumber');
    });
  }
}
