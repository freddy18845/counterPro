// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNotificationSettingsCollection on Isar {
  IsarCollection<NotificationSettings> get notificationSettings =>
      this.collection();
}

const NotificationSettingsSchema = CollectionSchema(
  name: r'NotificationSettings',
  id: 4766171496376314778,
  properties: {
    r'checkIntervalSeconds': PropertySchema(
      id: 0,
      name: r'checkIntervalSeconds',
      type: IsarType.long,
    ),
    r'cooldownMinutes': PropertySchema(
      id: 1,
      name: r'cooldownMinutes',
      type: IsarType.long,
    ),
    r'enableLowStockAlerts': PropertySchema(
      id: 2,
      name: r'enableLowStockAlerts',
      type: IsarType.bool,
    ),
    r'enableNotifications': PropertySchema(
      id: 3,
      name: r'enableNotifications',
      type: IsarType.bool,
    ),
    r'enableOutOfStockAlerts': PropertySchema(
      id: 4,
      name: r'enableOutOfStockAlerts',
      type: IsarType.bool,
    ),
    r'quietMode': PropertySchema(
      id: 5,
      name: r'quietMode',
      type: IsarType.bool,
    ),
    r'quietModeEndHour': PropertySchema(
      id: 6,
      name: r'quietModeEndHour',
      type: IsarType.long,
    ),
    r'quietModeStartHour': PropertySchema(
      id: 7,
      name: r'quietModeStartHour',
      type: IsarType.long,
    )
  },
  estimateSize: _notificationSettingsEstimateSize,
  serialize: _notificationSettingsSerialize,
  deserialize: _notificationSettingsDeserialize,
  deserializeProp: _notificationSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _notificationSettingsGetId,
  getLinks: _notificationSettingsGetLinks,
  attach: _notificationSettingsAttach,
  version: '3.1.0+1',
);

int _notificationSettingsEstimateSize(
  NotificationSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _notificationSettingsSerialize(
  NotificationSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.checkIntervalSeconds);
  writer.writeLong(offsets[1], object.cooldownMinutes);
  writer.writeBool(offsets[2], object.enableLowStockAlerts);
  writer.writeBool(offsets[3], object.enableNotifications);
  writer.writeBool(offsets[4], object.enableOutOfStockAlerts);
  writer.writeBool(offsets[5], object.quietMode);
  writer.writeLong(offsets[6], object.quietModeEndHour);
  writer.writeLong(offsets[7], object.quietModeStartHour);
}

NotificationSettings _notificationSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NotificationSettings(
    checkIntervalSeconds: reader.readLongOrNull(offsets[0]) ?? 30,
    cooldownMinutes: reader.readLongOrNull(offsets[1]) ?? 5,
    enableLowStockAlerts: reader.readBoolOrNull(offsets[2]) ?? true,
    enableNotifications: reader.readBoolOrNull(offsets[3]) ?? true,
    enableOutOfStockAlerts: reader.readBoolOrNull(offsets[4]) ?? true,
    quietMode: reader.readBoolOrNull(offsets[5]) ?? false,
    quietModeEndHour: reader.readLongOrNull(offsets[6]) ?? 7,
    quietModeStartHour: reader.readLongOrNull(offsets[7]) ?? 22,
  );
  object.id = id;
  return object;
}

P _notificationSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 30) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 5) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 5:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 6:
      return (reader.readLongOrNull(offset) ?? 7) as P;
    case 7:
      return (reader.readLongOrNull(offset) ?? 22) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _notificationSettingsGetId(NotificationSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _notificationSettingsGetLinks(
    NotificationSettings object) {
  return [];
}

void _notificationSettingsAttach(
    IsarCollection<dynamic> col, Id id, NotificationSettings object) {
  object.id = id;
}

extension NotificationSettingsQueryWhereSort
    on QueryBuilder<NotificationSettings, NotificationSettings, QWhere> {
  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NotificationSettingsQueryWhere
    on QueryBuilder<NotificationSettings, NotificationSettings, QWhereClause> {
  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
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

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
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

extension NotificationSettingsQueryFilter on QueryBuilder<NotificationSettings,
    NotificationSettings, QFilterCondition> {
  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> checkIntervalSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkIntervalSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> checkIntervalSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checkIntervalSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> checkIntervalSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checkIntervalSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> checkIntervalSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checkIntervalSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> cooldownMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cooldownMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> cooldownMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cooldownMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> cooldownMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cooldownMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> cooldownMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cooldownMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> enableLowStockAlertsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enableLowStockAlerts',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> enableNotificationsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enableNotifications',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> enableOutOfStockAlertsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enableOutOfStockAlerts',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
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

  QueryBuilder<NotificationSettings, NotificationSettings,
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

  QueryBuilder<NotificationSettings, NotificationSettings,
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

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> quietModeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quietMode',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> quietModeEndHourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quietModeEndHour',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> quietModeEndHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quietModeEndHour',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> quietModeEndHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quietModeEndHour',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> quietModeEndHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quietModeEndHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> quietModeStartHourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quietModeStartHour',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> quietModeStartHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quietModeStartHour',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> quietModeStartHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quietModeStartHour',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> quietModeStartHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quietModeStartHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NotificationSettingsQueryObject on QueryBuilder<NotificationSettings,
    NotificationSettings, QFilterCondition> {}

extension NotificationSettingsQueryLinks on QueryBuilder<NotificationSettings,
    NotificationSettings, QFilterCondition> {}

extension NotificationSettingsQuerySortBy
    on QueryBuilder<NotificationSettings, NotificationSettings, QSortBy> {
  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByCheckIntervalSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkIntervalSeconds', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByCheckIntervalSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkIntervalSeconds', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByCooldownMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cooldownMinutes', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByCooldownMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cooldownMinutes', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByEnableLowStockAlerts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableLowStockAlerts', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByEnableLowStockAlertsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableLowStockAlerts', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByEnableNotifications() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableNotifications', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByEnableNotificationsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableNotifications', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByEnableOutOfStockAlerts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableOutOfStockAlerts', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByEnableOutOfStockAlertsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableOutOfStockAlerts', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByQuietMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietMode', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByQuietModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietMode', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByQuietModeEndHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietModeEndHour', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByQuietModeEndHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietModeEndHour', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByQuietModeStartHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietModeStartHour', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByQuietModeStartHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietModeStartHour', Sort.desc);
    });
  }
}

extension NotificationSettingsQuerySortThenBy
    on QueryBuilder<NotificationSettings, NotificationSettings, QSortThenBy> {
  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByCheckIntervalSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkIntervalSeconds', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByCheckIntervalSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkIntervalSeconds', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByCooldownMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cooldownMinutes', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByCooldownMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cooldownMinutes', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByEnableLowStockAlerts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableLowStockAlerts', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByEnableLowStockAlertsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableLowStockAlerts', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByEnableNotifications() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableNotifications', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByEnableNotificationsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableNotifications', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByEnableOutOfStockAlerts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableOutOfStockAlerts', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByEnableOutOfStockAlertsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableOutOfStockAlerts', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByQuietMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietMode', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByQuietModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietMode', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByQuietModeEndHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietModeEndHour', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByQuietModeEndHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietModeEndHour', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByQuietModeStartHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietModeStartHour', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByQuietModeStartHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietModeStartHour', Sort.desc);
    });
  }
}

extension NotificationSettingsQueryWhereDistinct
    on QueryBuilder<NotificationSettings, NotificationSettings, QDistinct> {
  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByCheckIntervalSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkIntervalSeconds');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByCooldownMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cooldownMinutes');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByEnableLowStockAlerts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableLowStockAlerts');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByEnableNotifications() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableNotifications');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByEnableOutOfStockAlerts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableOutOfStockAlerts');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByQuietMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quietMode');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByQuietModeEndHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quietModeEndHour');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByQuietModeStartHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quietModeStartHour');
    });
  }
}

extension NotificationSettingsQueryProperty on QueryBuilder<
    NotificationSettings, NotificationSettings, QQueryProperty> {
  QueryBuilder<NotificationSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NotificationSettings, int, QQueryOperations>
      checkIntervalSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkIntervalSeconds');
    });
  }

  QueryBuilder<NotificationSettings, int, QQueryOperations>
      cooldownMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cooldownMinutes');
    });
  }

  QueryBuilder<NotificationSettings, bool, QQueryOperations>
      enableLowStockAlertsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableLowStockAlerts');
    });
  }

  QueryBuilder<NotificationSettings, bool, QQueryOperations>
      enableNotificationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableNotifications');
    });
  }

  QueryBuilder<NotificationSettings, bool, QQueryOperations>
      enableOutOfStockAlertsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableOutOfStockAlerts');
    });
  }

  QueryBuilder<NotificationSettings, bool, QQueryOperations>
      quietModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quietMode');
    });
  }

  QueryBuilder<NotificationSettings, int, QQueryOperations>
      quietModeEndHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quietModeEndHour');
    });
  }

  QueryBuilder<NotificationSettings, int, QQueryOperations>
      quietModeStartHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quietModeStartHour');
    });
  }
}
