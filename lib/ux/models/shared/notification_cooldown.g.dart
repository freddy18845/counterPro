// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_cooldown.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNotificationCooldownCollection on Isar {
  IsarCollection<NotificationCooldown> get notificationCooldowns =>
      this.collection();
}

const NotificationCooldownSchema = CollectionSchema(
  name: r'NotificationCooldown',
  id: 6618824802653017928,
  properties: {
    r'lastNotificationTime': PropertySchema(
      id: 0,
      name: r'lastNotificationTime',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _notificationCooldownEstimateSize,
  serialize: _notificationCooldownSerialize,
  deserialize: _notificationCooldownDeserialize,
  deserializeProp: _notificationCooldownDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _notificationCooldownGetId,
  getLinks: _notificationCooldownGetLinks,
  attach: _notificationCooldownAttach,
  version: '3.1.0+1',
);

int _notificationCooldownEstimateSize(
  NotificationCooldown object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _notificationCooldownSerialize(
  NotificationCooldown object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.lastNotificationTime);
}

NotificationCooldown _notificationCooldownDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NotificationCooldown(
    id: id,
    lastNotificationTime: reader.readDateTime(offsets[0]),
  );
  return object;
}

P _notificationCooldownDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _notificationCooldownGetId(NotificationCooldown object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _notificationCooldownGetLinks(
    NotificationCooldown object) {
  return [];
}

void _notificationCooldownAttach(
    IsarCollection<dynamic> col, Id id, NotificationCooldown object) {
  object.id = id;
}

extension NotificationCooldownQueryWhereSort
    on QueryBuilder<NotificationCooldown, NotificationCooldown, QWhere> {
  QueryBuilder<NotificationCooldown, NotificationCooldown, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NotificationCooldownQueryWhere
    on QueryBuilder<NotificationCooldown, NotificationCooldown, QWhereClause> {
  QueryBuilder<NotificationCooldown, NotificationCooldown, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NotificationCooldown, NotificationCooldown, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<NotificationCooldown, NotificationCooldown, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NotificationCooldown, NotificationCooldown, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NotificationCooldown, NotificationCooldown, QAfterWhereClause>
      idBetween(
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

extension NotificationCooldownQueryFilter on QueryBuilder<NotificationCooldown,
    NotificationCooldown, QFilterCondition> {
  QueryBuilder<NotificationCooldown, NotificationCooldown,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationCooldown, NotificationCooldown,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<NotificationCooldown, NotificationCooldown,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<NotificationCooldown, NotificationCooldown,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<NotificationCooldown, NotificationCooldown,
      QAfterFilterCondition> lastNotificationTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastNotificationTime',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationCooldown, NotificationCooldown,
      QAfterFilterCondition> lastNotificationTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastNotificationTime',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationCooldown, NotificationCooldown,
      QAfterFilterCondition> lastNotificationTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastNotificationTime',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationCooldown, NotificationCooldown,
      QAfterFilterCondition> lastNotificationTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastNotificationTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NotificationCooldownQueryObject on QueryBuilder<NotificationCooldown,
    NotificationCooldown, QFilterCondition> {}

extension NotificationCooldownQueryLinks on QueryBuilder<NotificationCooldown,
    NotificationCooldown, QFilterCondition> {}

extension NotificationCooldownQuerySortBy
    on QueryBuilder<NotificationCooldown, NotificationCooldown, QSortBy> {
  QueryBuilder<NotificationCooldown, NotificationCooldown, QAfterSortBy>
      sortByLastNotificationTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastNotificationTime', Sort.asc);
    });
  }

  QueryBuilder<NotificationCooldown, NotificationCooldown, QAfterSortBy>
      sortByLastNotificationTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastNotificationTime', Sort.desc);
    });
  }
}

extension NotificationCooldownQuerySortThenBy
    on QueryBuilder<NotificationCooldown, NotificationCooldown, QSortThenBy> {
  QueryBuilder<NotificationCooldown, NotificationCooldown, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NotificationCooldown, NotificationCooldown, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NotificationCooldown, NotificationCooldown, QAfterSortBy>
      thenByLastNotificationTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastNotificationTime', Sort.asc);
    });
  }

  QueryBuilder<NotificationCooldown, NotificationCooldown, QAfterSortBy>
      thenByLastNotificationTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastNotificationTime', Sort.desc);
    });
  }
}

extension NotificationCooldownQueryWhereDistinct
    on QueryBuilder<NotificationCooldown, NotificationCooldown, QDistinct> {
  QueryBuilder<NotificationCooldown, NotificationCooldown, QDistinct>
      distinctByLastNotificationTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastNotificationTime');
    });
  }
}

extension NotificationCooldownQueryProperty on QueryBuilder<
    NotificationCooldown, NotificationCooldown, QQueryProperty> {
  QueryBuilder<NotificationCooldown, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NotificationCooldown, DateTime, QQueryOperations>
      lastNotificationTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastNotificationTime');
    });
  }
}
