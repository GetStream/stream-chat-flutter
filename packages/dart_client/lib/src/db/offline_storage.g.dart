// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_storage.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class _ConnectionEventData extends DataClass
    implements Insertable<_ConnectionEventData> {
  final int id;
  final Map<String, dynamic> ownUser;
  final int totalUnreadCount;
  final int unreadChannels;
  final DateTime lastEventAt;
  final DateTime lastSyncAt;
  _ConnectionEventData(
      {@required this.id,
      this.ownUser,
      this.totalUnreadCount,
      this.unreadChannels,
      this.lastEventAt,
      this.lastSyncAt});
  factory _ConnectionEventData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return _ConnectionEventData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      ownUser: $_ConnectionEventTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}own_user'])),
      totalUnreadCount: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}total_unread_count']),
      unreadChannels: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}unread_channels']),
      lastEventAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_event_at']),
      lastSyncAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_sync_at']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || ownUser != null) {
      final converter = $_ConnectionEventTable.$converter0;
      map['own_user'] = Variable<String>(converter.mapToSql(ownUser));
    }
    if (!nullToAbsent || totalUnreadCount != null) {
      map['total_unread_count'] = Variable<int>(totalUnreadCount);
    }
    if (!nullToAbsent || unreadChannels != null) {
      map['unread_channels'] = Variable<int>(unreadChannels);
    }
    if (!nullToAbsent || lastEventAt != null) {
      map['last_event_at'] = Variable<DateTime>(lastEventAt);
    }
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    return map;
  }

  _ConnectionEventCompanion toCompanion(bool nullToAbsent) {
    return _ConnectionEventCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      ownUser: ownUser == null && nullToAbsent
          ? const Value.absent()
          : Value(ownUser),
      totalUnreadCount: totalUnreadCount == null && nullToAbsent
          ? const Value.absent()
          : Value(totalUnreadCount),
      unreadChannels: unreadChannels == null && nullToAbsent
          ? const Value.absent()
          : Value(unreadChannels),
      lastEventAt: lastEventAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastEventAt),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory _ConnectionEventData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return _ConnectionEventData(
      id: serializer.fromJson<int>(json['id']),
      ownUser: serializer.fromJson<Map<String, dynamic>>(json['ownUser']),
      totalUnreadCount: serializer.fromJson<int>(json['totalUnreadCount']),
      unreadChannels: serializer.fromJson<int>(json['unreadChannels']),
      lastEventAt: serializer.fromJson<DateTime>(json['lastEventAt']),
      lastSyncAt: serializer.fromJson<DateTime>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownUser': serializer.toJson<Map<String, dynamic>>(ownUser),
      'totalUnreadCount': serializer.toJson<int>(totalUnreadCount),
      'unreadChannels': serializer.toJson<int>(unreadChannels),
      'lastEventAt': serializer.toJson<DateTime>(lastEventAt),
      'lastSyncAt': serializer.toJson<DateTime>(lastSyncAt),
    };
  }

  _ConnectionEventData copyWith(
          {int id,
          Map<String, dynamic> ownUser,
          int totalUnreadCount,
          int unreadChannels,
          DateTime lastEventAt,
          DateTime lastSyncAt}) =>
      _ConnectionEventData(
        id: id ?? this.id,
        ownUser: ownUser ?? this.ownUser,
        totalUnreadCount: totalUnreadCount ?? this.totalUnreadCount,
        unreadChannels: unreadChannels ?? this.unreadChannels,
        lastEventAt: lastEventAt ?? this.lastEventAt,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      );
  @override
  String toString() {
    return (StringBuffer('_ConnectionEventData(')
          ..write('id: $id, ')
          ..write('ownUser: $ownUser, ')
          ..write('totalUnreadCount: $totalUnreadCount, ')
          ..write('unreadChannels: $unreadChannels, ')
          ..write('lastEventAt: $lastEventAt, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          ownUser.hashCode,
          $mrjc(
              totalUnreadCount.hashCode,
              $mrjc(unreadChannels.hashCode,
                  $mrjc(lastEventAt.hashCode, lastSyncAt.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is _ConnectionEventData &&
          other.id == this.id &&
          other.ownUser == this.ownUser &&
          other.totalUnreadCount == this.totalUnreadCount &&
          other.unreadChannels == this.unreadChannels &&
          other.lastEventAt == this.lastEventAt &&
          other.lastSyncAt == this.lastSyncAt);
}

class _ConnectionEventCompanion extends UpdateCompanion<_ConnectionEventData> {
  final Value<int> id;
  final Value<Map<String, dynamic>> ownUser;
  final Value<int> totalUnreadCount;
  final Value<int> unreadChannels;
  final Value<DateTime> lastEventAt;
  final Value<DateTime> lastSyncAt;
  const _ConnectionEventCompanion({
    this.id = const Value.absent(),
    this.ownUser = const Value.absent(),
    this.totalUnreadCount = const Value.absent(),
    this.unreadChannels = const Value.absent(),
    this.lastEventAt = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  });
  _ConnectionEventCompanion.insert({
    this.id = const Value.absent(),
    this.ownUser = const Value.absent(),
    this.totalUnreadCount = const Value.absent(),
    this.unreadChannels = const Value.absent(),
    this.lastEventAt = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  });
  static Insertable<_ConnectionEventData> custom({
    Expression<int> id,
    Expression<String> ownUser,
    Expression<int> totalUnreadCount,
    Expression<int> unreadChannels,
    Expression<DateTime> lastEventAt,
    Expression<DateTime> lastSyncAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownUser != null) 'own_user': ownUser,
      if (totalUnreadCount != null) 'total_unread_count': totalUnreadCount,
      if (unreadChannels != null) 'unread_channels': unreadChannels,
      if (lastEventAt != null) 'last_event_at': lastEventAt,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
    });
  }

  _ConnectionEventCompanion copyWith(
      {Value<int> id,
      Value<Map<String, dynamic>> ownUser,
      Value<int> totalUnreadCount,
      Value<int> unreadChannels,
      Value<DateTime> lastEventAt,
      Value<DateTime> lastSyncAt}) {
    return _ConnectionEventCompanion(
      id: id ?? this.id,
      ownUser: ownUser ?? this.ownUser,
      totalUnreadCount: totalUnreadCount ?? this.totalUnreadCount,
      unreadChannels: unreadChannels ?? this.unreadChannels,
      lastEventAt: lastEventAt ?? this.lastEventAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownUser.present) {
      final converter = $_ConnectionEventTable.$converter0;
      map['own_user'] = Variable<String>(converter.mapToSql(ownUser.value));
    }
    if (totalUnreadCount.present) {
      map['total_unread_count'] = Variable<int>(totalUnreadCount.value);
    }
    if (unreadChannels.present) {
      map['unread_channels'] = Variable<int>(unreadChannels.value);
    }
    if (lastEventAt.present) {
      map['last_event_at'] = Variable<DateTime>(lastEventAt.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('_ConnectionEventCompanion(')
          ..write('id: $id, ')
          ..write('ownUser: $ownUser, ')
          ..write('totalUnreadCount: $totalUnreadCount, ')
          ..write('unreadChannels: $unreadChannels, ')
          ..write('lastEventAt: $lastEventAt, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }
}

class $_ConnectionEventTable extends _ConnectionEvent
    with TableInfo<$_ConnectionEventTable, _ConnectionEventData> {
  final GeneratedDatabase _db;
  final String _alias;
  $_ConnectionEventTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _ownUserMeta = const VerificationMeta('ownUser');
  GeneratedTextColumn _ownUser;
  @override
  GeneratedTextColumn get ownUser => _ownUser ??= _constructOwnUser();
  GeneratedTextColumn _constructOwnUser() {
    return GeneratedTextColumn(
      'own_user',
      $tableName,
      true,
    );
  }

  final VerificationMeta _totalUnreadCountMeta =
      const VerificationMeta('totalUnreadCount');
  GeneratedIntColumn _totalUnreadCount;
  @override
  GeneratedIntColumn get totalUnreadCount =>
      _totalUnreadCount ??= _constructTotalUnreadCount();
  GeneratedIntColumn _constructTotalUnreadCount() {
    return GeneratedIntColumn(
      'total_unread_count',
      $tableName,
      true,
    );
  }

  final VerificationMeta _unreadChannelsMeta =
      const VerificationMeta('unreadChannels');
  GeneratedIntColumn _unreadChannels;
  @override
  GeneratedIntColumn get unreadChannels =>
      _unreadChannels ??= _constructUnreadChannels();
  GeneratedIntColumn _constructUnreadChannels() {
    return GeneratedIntColumn(
      'unread_channels',
      $tableName,
      true,
    );
  }

  final VerificationMeta _lastEventAtMeta =
      const VerificationMeta('lastEventAt');
  GeneratedDateTimeColumn _lastEventAt;
  @override
  GeneratedDateTimeColumn get lastEventAt =>
      _lastEventAt ??= _constructLastEventAt();
  GeneratedDateTimeColumn _constructLastEventAt() {
    return GeneratedDateTimeColumn(
      'last_event_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _lastSyncAtMeta = const VerificationMeta('lastSyncAt');
  GeneratedDateTimeColumn _lastSyncAt;
  @override
  GeneratedDateTimeColumn get lastSyncAt =>
      _lastSyncAt ??= _constructLastSyncAt();
  GeneratedDateTimeColumn _constructLastSyncAt() {
    return GeneratedDateTimeColumn(
      'last_sync_at',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, ownUser, totalUnreadCount, unreadChannels, lastEventAt, lastSyncAt];
  @override
  $_ConnectionEventTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'connection_event';
  @override
  final String actualTableName = 'connection_event';
  @override
  VerificationContext validateIntegrity(
      Insertable<_ConnectionEventData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    context.handle(_ownUserMeta, const VerificationResult.success());
    if (data.containsKey('total_unread_count')) {
      context.handle(
          _totalUnreadCountMeta,
          totalUnreadCount.isAcceptableOrUnknown(
              data['total_unread_count'], _totalUnreadCountMeta));
    }
    if (data.containsKey('unread_channels')) {
      context.handle(
          _unreadChannelsMeta,
          unreadChannels.isAcceptableOrUnknown(
              data['unread_channels'], _unreadChannelsMeta));
    }
    if (data.containsKey('last_event_at')) {
      context.handle(
          _lastEventAtMeta,
          lastEventAt.isAcceptableOrUnknown(
              data['last_event_at'], _lastEventAtMeta));
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
          _lastSyncAtMeta,
          lastSyncAt.isAcceptableOrUnknown(
              data['last_sync_at'], _lastSyncAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  _ConnectionEventData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return _ConnectionEventData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $_ConnectionEventTable createAlias(String alias) {
    return $_ConnectionEventTable(_db, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converter0 =
      _ExtraDataConverter();
}

class _Channel extends DataClass implements Insertable<_Channel> {
  final String id;
  final String type;
  final String cid;
  final String config;
  final bool frozen;
  final DateTime lastMessageAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;
  final int memberCount;
  final Map<String, dynamic> extraData;
  final String createdBy;
  _Channel(
      {@required this.id,
      @required this.type,
      @required this.cid,
      @required this.config,
      @required this.frozen,
      this.lastMessageAt,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.memberCount,
      this.extraData,
      this.createdBy});
  factory _Channel.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final intType = db.typeSystem.forDartType<int>();
    return _Channel(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
      cid: stringType.mapFromDatabaseResponse(data['${effectivePrefix}cid']),
      config:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}config']),
      frozen:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}frozen']),
      lastMessageAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_message_at']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
      deletedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted_at']),
      memberCount: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}member_count']),
      extraData: $_ChannelsTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}extra_data'])),
      createdBy: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_by']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || cid != null) {
      map['cid'] = Variable<String>(cid);
    }
    if (!nullToAbsent || config != null) {
      map['config'] = Variable<String>(config);
    }
    if (!nullToAbsent || frozen != null) {
      map['frozen'] = Variable<bool>(frozen);
    }
    if (!nullToAbsent || lastMessageAt != null) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || memberCount != null) {
      map['member_count'] = Variable<int>(memberCount);
    }
    if (!nullToAbsent || extraData != null) {
      final converter = $_ChannelsTable.$converter0;
      map['extra_data'] = Variable<String>(converter.mapToSql(extraData));
    }
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    return map;
  }

  _ChannelsCompanion toCompanion(bool nullToAbsent) {
    return _ChannelsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      cid: cid == null && nullToAbsent ? const Value.absent() : Value(cid),
      config:
          config == null && nullToAbsent ? const Value.absent() : Value(config),
      frozen:
          frozen == null && nullToAbsent ? const Value.absent() : Value(frozen),
      lastMessageAt: lastMessageAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageAt),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      memberCount: memberCount == null && nullToAbsent
          ? const Value.absent()
          : Value(memberCount),
      extraData: extraData == null && nullToAbsent
          ? const Value.absent()
          : Value(extraData),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
    );
  }

  factory _Channel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return _Channel(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      cid: serializer.fromJson<String>(json['cid']),
      config: serializer.fromJson<String>(json['config']),
      frozen: serializer.fromJson<bool>(json['frozen']),
      lastMessageAt: serializer.fromJson<DateTime>(json['lastMessageAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime>(json['deletedAt']),
      memberCount: serializer.fromJson<int>(json['memberCount']),
      extraData: serializer.fromJson<Map<String, dynamic>>(json['extraData']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'cid': serializer.toJson<String>(cid),
      'config': serializer.toJson<String>(config),
      'frozen': serializer.toJson<bool>(frozen),
      'lastMessageAt': serializer.toJson<DateTime>(lastMessageAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime>(deletedAt),
      'memberCount': serializer.toJson<int>(memberCount),
      'extraData': serializer.toJson<Map<String, dynamic>>(extraData),
      'createdBy': serializer.toJson<String>(createdBy),
    };
  }

  _Channel copyWith(
          {String id,
          String type,
          String cid,
          String config,
          bool frozen,
          DateTime lastMessageAt,
          DateTime createdAt,
          DateTime updatedAt,
          DateTime deletedAt,
          int memberCount,
          Map<String, dynamic> extraData,
          String createdBy}) =>
      _Channel(
        id: id ?? this.id,
        type: type ?? this.type,
        cid: cid ?? this.cid,
        config: config ?? this.config,
        frozen: frozen ?? this.frozen,
        lastMessageAt: lastMessageAt ?? this.lastMessageAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        memberCount: memberCount ?? this.memberCount,
        extraData: extraData ?? this.extraData,
        createdBy: createdBy ?? this.createdBy,
      );
  @override
  String toString() {
    return (StringBuffer('_Channel(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('cid: $cid, ')
          ..write('config: $config, ')
          ..write('frozen: $frozen, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('memberCount: $memberCount, ')
          ..write('extraData: $extraData, ')
          ..write('createdBy: $createdBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          type.hashCode,
          $mrjc(
              cid.hashCode,
              $mrjc(
                  config.hashCode,
                  $mrjc(
                      frozen.hashCode,
                      $mrjc(
                          lastMessageAt.hashCode,
                          $mrjc(
                              createdAt.hashCode,
                              $mrjc(
                                  updatedAt.hashCode,
                                  $mrjc(
                                      deletedAt.hashCode,
                                      $mrjc(
                                          memberCount.hashCode,
                                          $mrjc(extraData.hashCode,
                                              createdBy.hashCode))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is _Channel &&
          other.id == this.id &&
          other.type == this.type &&
          other.cid == this.cid &&
          other.config == this.config &&
          other.frozen == this.frozen &&
          other.lastMessageAt == this.lastMessageAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.memberCount == this.memberCount &&
          other.extraData == this.extraData &&
          other.createdBy == this.createdBy);
}

class _ChannelsCompanion extends UpdateCompanion<_Channel> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> cid;
  final Value<String> config;
  final Value<bool> frozen;
  final Value<DateTime> lastMessageAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> deletedAt;
  final Value<int> memberCount;
  final Value<Map<String, dynamic>> extraData;
  final Value<String> createdBy;
  const _ChannelsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.cid = const Value.absent(),
    this.config = const Value.absent(),
    this.frozen = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.memberCount = const Value.absent(),
    this.extraData = const Value.absent(),
    this.createdBy = const Value.absent(),
  });
  _ChannelsCompanion.insert({
    @required String id,
    @required String type,
    @required String cid,
    @required String config,
    this.frozen = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.memberCount = const Value.absent(),
    this.extraData = const Value.absent(),
    this.createdBy = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        cid = Value(cid),
        config = Value(config);
  static Insertable<_Channel> custom({
    Expression<String> id,
    Expression<String> type,
    Expression<String> cid,
    Expression<String> config,
    Expression<bool> frozen,
    Expression<DateTime> lastMessageAt,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
    Expression<DateTime> deletedAt,
    Expression<int> memberCount,
    Expression<String> extraData,
    Expression<String> createdBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (cid != null) 'cid': cid,
      if (config != null) 'config': config,
      if (frozen != null) 'frozen': frozen,
      if (lastMessageAt != null) 'last_message_at': lastMessageAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (memberCount != null) 'member_count': memberCount,
      if (extraData != null) 'extra_data': extraData,
      if (createdBy != null) 'created_by': createdBy,
    });
  }

  _ChannelsCompanion copyWith(
      {Value<String> id,
      Value<String> type,
      Value<String> cid,
      Value<String> config,
      Value<bool> frozen,
      Value<DateTime> lastMessageAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime> deletedAt,
      Value<int> memberCount,
      Value<Map<String, dynamic>> extraData,
      Value<String> createdBy}) {
    return _ChannelsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      cid: cid ?? this.cid,
      config: config ?? this.config,
      frozen: frozen ?? this.frozen,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      memberCount: memberCount ?? this.memberCount,
      extraData: extraData ?? this.extraData,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (cid.present) {
      map['cid'] = Variable<String>(cid.value);
    }
    if (config.present) {
      map['config'] = Variable<String>(config.value);
    }
    if (frozen.present) {
      map['frozen'] = Variable<bool>(frozen.value);
    }
    if (lastMessageAt.present) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (memberCount.present) {
      map['member_count'] = Variable<int>(memberCount.value);
    }
    if (extraData.present) {
      final converter = $_ChannelsTable.$converter0;
      map['extra_data'] = Variable<String>(converter.mapToSql(extraData.value));
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('_ChannelsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('cid: $cid, ')
          ..write('config: $config, ')
          ..write('frozen: $frozen, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('memberCount: $memberCount, ')
          ..write('extraData: $extraData, ')
          ..write('createdBy: $createdBy')
          ..write(')'))
        .toString();
  }
}

class $_ChannelsTable extends _Channels
    with TableInfo<$_ChannelsTable, _Channel> {
  final GeneratedDatabase _db;
  final String _alias;
  $_ChannelsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedTextColumn _type;
  @override
  GeneratedTextColumn get type => _type ??= _constructType();
  GeneratedTextColumn _constructType() {
    return GeneratedTextColumn(
      'type',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cidMeta = const VerificationMeta('cid');
  GeneratedTextColumn _cid;
  @override
  GeneratedTextColumn get cid => _cid ??= _constructCid();
  GeneratedTextColumn _constructCid() {
    return GeneratedTextColumn(
      'cid',
      $tableName,
      false,
    );
  }

  final VerificationMeta _configMeta = const VerificationMeta('config');
  GeneratedTextColumn _config;
  @override
  GeneratedTextColumn get config => _config ??= _constructConfig();
  GeneratedTextColumn _constructConfig() {
    return GeneratedTextColumn(
      'config',
      $tableName,
      false,
    );
  }

  final VerificationMeta _frozenMeta = const VerificationMeta('frozen');
  GeneratedBoolColumn _frozen;
  @override
  GeneratedBoolColumn get frozen => _frozen ??= _constructFrozen();
  GeneratedBoolColumn _constructFrozen() {
    return GeneratedBoolColumn('frozen', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _lastMessageAtMeta =
      const VerificationMeta('lastMessageAt');
  GeneratedDateTimeColumn _lastMessageAt;
  @override
  GeneratedDateTimeColumn get lastMessageAt =>
      _lastMessageAt ??= _constructLastMessageAt();
  GeneratedDateTimeColumn _constructLastMessageAt() {
    return GeneratedDateTimeColumn(
      'last_message_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn(
      'created_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  GeneratedDateTimeColumn _deletedAt;
  @override
  GeneratedDateTimeColumn get deletedAt => _deletedAt ??= _constructDeletedAt();
  GeneratedDateTimeColumn _constructDeletedAt() {
    return GeneratedDateTimeColumn(
      'deleted_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _memberCountMeta =
      const VerificationMeta('memberCount');
  GeneratedIntColumn _memberCount;
  @override
  GeneratedIntColumn get memberCount =>
      _memberCount ??= _constructMemberCount();
  GeneratedIntColumn _constructMemberCount() {
    return GeneratedIntColumn(
      'member_count',
      $tableName,
      true,
    );
  }

  final VerificationMeta _extraDataMeta = const VerificationMeta('extraData');
  GeneratedTextColumn _extraData;
  @override
  GeneratedTextColumn get extraData => _extraData ??= _constructExtraData();
  GeneratedTextColumn _constructExtraData() {
    return GeneratedTextColumn(
      'extra_data',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createdByMeta = const VerificationMeta('createdBy');
  GeneratedTextColumn _createdBy;
  @override
  GeneratedTextColumn get createdBy => _createdBy ??= _constructCreatedBy();
  GeneratedTextColumn _constructCreatedBy() {
    return GeneratedTextColumn(
      'created_by',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        type,
        cid,
        config,
        frozen,
        lastMessageAt,
        createdAt,
        updatedAt,
        deletedAt,
        memberCount,
        extraData,
        createdBy
      ];
  @override
  $_ChannelsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'channels';
  @override
  final String actualTableName = 'channels';
  @override
  VerificationContext validateIntegrity(Insertable<_Channel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type'], _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('cid')) {
      context.handle(
          _cidMeta, cid.isAcceptableOrUnknown(data['cid'], _cidMeta));
    } else if (isInserting) {
      context.missing(_cidMeta);
    }
    if (data.containsKey('config')) {
      context.handle(_configMeta,
          config.isAcceptableOrUnknown(data['config'], _configMeta));
    } else if (isInserting) {
      context.missing(_configMeta);
    }
    if (data.containsKey('frozen')) {
      context.handle(_frozenMeta,
          frozen.isAcceptableOrUnknown(data['frozen'], _frozenMeta));
    }
    if (data.containsKey('last_message_at')) {
      context.handle(
          _lastMessageAtMeta,
          lastMessageAt.isAcceptableOrUnknown(
              data['last_message_at'], _lastMessageAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at'], _deletedAtMeta));
    }
    if (data.containsKey('member_count')) {
      context.handle(
          _memberCountMeta,
          memberCount.isAcceptableOrUnknown(
              data['member_count'], _memberCountMeta));
    }
    context.handle(_extraDataMeta, const VerificationResult.success());
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by'], _createdByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cid};
  @override
  _Channel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return _Channel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $_ChannelsTable createAlias(String alias) {
    return $_ChannelsTable(_db, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converter0 =
      _ExtraDataConverter();
}

class _User extends DataClass implements Insertable<_User> {
  final String id;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime lastActive;
  final bool online;
  final bool banned;
  final Map<String, dynamic> extraData;
  _User(
      {@required this.id,
      this.role,
      this.createdAt,
      this.updatedAt,
      this.lastActive,
      this.online,
      this.banned,
      this.extraData});
  factory _User.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return _User(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      role: stringType.mapFromDatabaseResponse(data['${effectivePrefix}role']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
      lastActive: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_active']),
      online:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}online']),
      banned:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}banned']),
      extraData: $_UsersTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}extra_data'])),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || role != null) {
      map['role'] = Variable<String>(role);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || lastActive != null) {
      map['last_active'] = Variable<DateTime>(lastActive);
    }
    if (!nullToAbsent || online != null) {
      map['online'] = Variable<bool>(online);
    }
    if (!nullToAbsent || banned != null) {
      map['banned'] = Variable<bool>(banned);
    }
    if (!nullToAbsent || extraData != null) {
      final converter = $_UsersTable.$converter0;
      map['extra_data'] = Variable<String>(converter.mapToSql(extraData));
    }
    return map;
  }

  _UsersCompanion toCompanion(bool nullToAbsent) {
    return _UsersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      role: role == null && nullToAbsent ? const Value.absent() : Value(role),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      lastActive: lastActive == null && nullToAbsent
          ? const Value.absent()
          : Value(lastActive),
      online:
          online == null && nullToAbsent ? const Value.absent() : Value(online),
      banned:
          banned == null && nullToAbsent ? const Value.absent() : Value(banned),
      extraData: extraData == null && nullToAbsent
          ? const Value.absent()
          : Value(extraData),
    );
  }

  factory _User.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return _User(
      id: serializer.fromJson<String>(json['id']),
      role: serializer.fromJson<String>(json['role']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastActive: serializer.fromJson<DateTime>(json['lastActive']),
      online: serializer.fromJson<bool>(json['online']),
      banned: serializer.fromJson<bool>(json['banned']),
      extraData: serializer.fromJson<Map<String, dynamic>>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'role': serializer.toJson<String>(role),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastActive': serializer.toJson<DateTime>(lastActive),
      'online': serializer.toJson<bool>(online),
      'banned': serializer.toJson<bool>(banned),
      'extraData': serializer.toJson<Map<String, dynamic>>(extraData),
    };
  }

  _User copyWith(
          {String id,
          String role,
          DateTime createdAt,
          DateTime updatedAt,
          DateTime lastActive,
          bool online,
          bool banned,
          Map<String, dynamic> extraData}) =>
      _User(
        id: id ?? this.id,
        role: role ?? this.role,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastActive: lastActive ?? this.lastActive,
        online: online ?? this.online,
        banned: banned ?? this.banned,
        extraData: extraData ?? this.extraData,
      );
  @override
  String toString() {
    return (StringBuffer('_User(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastActive: $lastActive, ')
          ..write('online: $online, ')
          ..write('banned: $banned, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          role.hashCode,
          $mrjc(
              createdAt.hashCode,
              $mrjc(
                  updatedAt.hashCode,
                  $mrjc(
                      lastActive.hashCode,
                      $mrjc(online.hashCode,
                          $mrjc(banned.hashCode, extraData.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is _User &&
          other.id == this.id &&
          other.role == this.role &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastActive == this.lastActive &&
          other.online == this.online &&
          other.banned == this.banned &&
          other.extraData == this.extraData);
}

class _UsersCompanion extends UpdateCompanion<_User> {
  final Value<String> id;
  final Value<String> role;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> lastActive;
  final Value<bool> online;
  final Value<bool> banned;
  final Value<Map<String, dynamic>> extraData;
  const _UsersCompanion({
    this.id = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastActive = const Value.absent(),
    this.online = const Value.absent(),
    this.banned = const Value.absent(),
    this.extraData = const Value.absent(),
  });
  _UsersCompanion.insert({
    @required String id,
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastActive = const Value.absent(),
    this.online = const Value.absent(),
    this.banned = const Value.absent(),
    this.extraData = const Value.absent(),
  }) : id = Value(id);
  static Insertable<_User> custom({
    Expression<String> id,
    Expression<String> role,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
    Expression<DateTime> lastActive,
    Expression<bool> online,
    Expression<bool> banned,
    Expression<String> extraData,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (role != null) 'role': role,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastActive != null) 'last_active': lastActive,
      if (online != null) 'online': online,
      if (banned != null) 'banned': banned,
      if (extraData != null) 'extra_data': extraData,
    });
  }

  _UsersCompanion copyWith(
      {Value<String> id,
      Value<String> role,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime> lastActive,
      Value<bool> online,
      Value<bool> banned,
      Value<Map<String, dynamic>> extraData}) {
    return _UsersCompanion(
      id: id ?? this.id,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastActive: lastActive ?? this.lastActive,
      online: online ?? this.online,
      banned: banned ?? this.banned,
      extraData: extraData ?? this.extraData,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastActive.present) {
      map['last_active'] = Variable<DateTime>(lastActive.value);
    }
    if (online.present) {
      map['online'] = Variable<bool>(online.value);
    }
    if (banned.present) {
      map['banned'] = Variable<bool>(banned.value);
    }
    if (extraData.present) {
      final converter = $_UsersTable.$converter0;
      map['extra_data'] = Variable<String>(converter.mapToSql(extraData.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('_UsersCompanion(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastActive: $lastActive, ')
          ..write('online: $online, ')
          ..write('banned: $banned, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }
}

class $_UsersTable extends _Users with TableInfo<$_UsersTable, _User> {
  final GeneratedDatabase _db;
  final String _alias;
  $_UsersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _roleMeta = const VerificationMeta('role');
  GeneratedTextColumn _role;
  @override
  GeneratedTextColumn get role => _role ??= _constructRole();
  GeneratedTextColumn _constructRole() {
    return GeneratedTextColumn(
      'role',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn(
      'created_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _lastActiveMeta = const VerificationMeta('lastActive');
  GeneratedDateTimeColumn _lastActive;
  @override
  GeneratedDateTimeColumn get lastActive =>
      _lastActive ??= _constructLastActive();
  GeneratedDateTimeColumn _constructLastActive() {
    return GeneratedDateTimeColumn(
      'last_active',
      $tableName,
      true,
    );
  }

  final VerificationMeta _onlineMeta = const VerificationMeta('online');
  GeneratedBoolColumn _online;
  @override
  GeneratedBoolColumn get online => _online ??= _constructOnline();
  GeneratedBoolColumn _constructOnline() {
    return GeneratedBoolColumn(
      'online',
      $tableName,
      true,
    );
  }

  final VerificationMeta _bannedMeta = const VerificationMeta('banned');
  GeneratedBoolColumn _banned;
  @override
  GeneratedBoolColumn get banned => _banned ??= _constructBanned();
  GeneratedBoolColumn _constructBanned() {
    return GeneratedBoolColumn(
      'banned',
      $tableName,
      true,
    );
  }

  final VerificationMeta _extraDataMeta = const VerificationMeta('extraData');
  GeneratedTextColumn _extraData;
  @override
  GeneratedTextColumn get extraData => _extraData ??= _constructExtraData();
  GeneratedTextColumn _constructExtraData() {
    return GeneratedTextColumn(
      'extra_data',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, role, createdAt, updatedAt, lastActive, online, banned, extraData];
  @override
  $_UsersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'users';
  @override
  final String actualTableName = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<_User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role'], _roleMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
    }
    if (data.containsKey('last_active')) {
      context.handle(
          _lastActiveMeta,
          lastActive.isAcceptableOrUnknown(
              data['last_active'], _lastActiveMeta));
    }
    if (data.containsKey('online')) {
      context.handle(_onlineMeta,
          online.isAcceptableOrUnknown(data['online'], _onlineMeta));
    }
    if (data.containsKey('banned')) {
      context.handle(_bannedMeta,
          banned.isAcceptableOrUnknown(data['banned'], _bannedMeta));
    }
    context.handle(_extraDataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  _User map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return _User.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $_UsersTable createAlias(String alias) {
    return $_UsersTable(_db, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converter0 =
      _ExtraDataConverter();
}

class _Message extends DataClass implements Insertable<_Message> {
  final String id;
  final String messageText;
  final String attachmentJson;
  final MessageSendingStatus status;
  final String type;
  final Map<String, int> reactionCounts;
  final Map<String, int> reactionScores;
  final String parentId;
  final String quotedMessageId;
  final int replyCount;
  final bool showInChannel;
  final bool shadowed;
  final String command;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;
  final String userId;
  final String channelCid;
  final Map<String, dynamic> extraData;
  _Message(
      {@required this.id,
      this.messageText,
      this.attachmentJson,
      this.status,
      this.type,
      this.reactionCounts,
      this.reactionScores,
      this.parentId,
      this.quotedMessageId,
      this.replyCount,
      this.showInChannel,
      this.shadowed,
      this.command,
      @required this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.userId,
      this.channelCid,
      this.extraData});
  factory _Message.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    final boolType = db.typeSystem.forDartType<bool>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return _Message(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      messageText: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}message_text']),
      attachmentJson: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}attachment_json']),
      status: $_MessagesTable.$converter0.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}status'])),
      type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
      reactionCounts: $_MessagesTable.$converter1.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}reaction_counts'])),
      reactionScores: $_MessagesTable.$converter2.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}reaction_scores'])),
      parentId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}parent_id']),
      quotedMessageId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}quoted_message_id']),
      replyCount: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}reply_count']),
      showInChannel: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}show_in_channel']),
      shadowed:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}shadowed']),
      command:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}command']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
      deletedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted_at']),
      userId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      channelCid: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_cid']),
      extraData: $_MessagesTable.$converter3.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}extra_data'])),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || messageText != null) {
      map['message_text'] = Variable<String>(messageText);
    }
    if (!nullToAbsent || attachmentJson != null) {
      map['attachment_json'] = Variable<String>(attachmentJson);
    }
    if (!nullToAbsent || status != null) {
      final converter = $_MessagesTable.$converter0;
      map['status'] = Variable<int>(converter.mapToSql(status));
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || reactionCounts != null) {
      final converter = $_MessagesTable.$converter1;
      map['reaction_counts'] =
          Variable<String>(converter.mapToSql(reactionCounts));
    }
    if (!nullToAbsent || reactionScores != null) {
      final converter = $_MessagesTable.$converter2;
      map['reaction_scores'] =
          Variable<String>(converter.mapToSql(reactionScores));
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    if (!nullToAbsent || quotedMessageId != null) {
      map['quoted_message_id'] = Variable<String>(quotedMessageId);
    }
    if (!nullToAbsent || replyCount != null) {
      map['reply_count'] = Variable<int>(replyCount);
    }
    if (!nullToAbsent || showInChannel != null) {
      map['show_in_channel'] = Variable<bool>(showInChannel);
    }
    if (!nullToAbsent || shadowed != null) {
      map['shadowed'] = Variable<bool>(shadowed);
    }
    if (!nullToAbsent || command != null) {
      map['command'] = Variable<String>(command);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || channelCid != null) {
      map['channel_cid'] = Variable<String>(channelCid);
    }
    if (!nullToAbsent || extraData != null) {
      final converter = $_MessagesTable.$converter3;
      map['extra_data'] = Variable<String>(converter.mapToSql(extraData));
    }
    return map;
  }

  _MessagesCompanion toCompanion(bool nullToAbsent) {
    return _MessagesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      messageText: messageText == null && nullToAbsent
          ? const Value.absent()
          : Value(messageText),
      attachmentJson: attachmentJson == null && nullToAbsent
          ? const Value.absent()
          : Value(attachmentJson),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      reactionCounts: reactionCounts == null && nullToAbsent
          ? const Value.absent()
          : Value(reactionCounts),
      reactionScores: reactionScores == null && nullToAbsent
          ? const Value.absent()
          : Value(reactionScores),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      quotedMessageId: quotedMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(quotedMessageId),
      replyCount: replyCount == null && nullToAbsent
          ? const Value.absent()
          : Value(replyCount),
      showInChannel: showInChannel == null && nullToAbsent
          ? const Value.absent()
          : Value(showInChannel),
      shadowed: shadowed == null && nullToAbsent
          ? const Value.absent()
          : Value(shadowed),
      command: command == null && nullToAbsent
          ? const Value.absent()
          : Value(command),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      channelCid: channelCid == null && nullToAbsent
          ? const Value.absent()
          : Value(channelCid),
      extraData: extraData == null && nullToAbsent
          ? const Value.absent()
          : Value(extraData),
    );
  }

  factory _Message.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return _Message(
      id: serializer.fromJson<String>(json['id']),
      messageText: serializer.fromJson<String>(json['messageText']),
      attachmentJson: serializer.fromJson<String>(json['attachmentJson']),
      status: serializer.fromJson<MessageSendingStatus>(json['status']),
      type: serializer.fromJson<String>(json['type']),
      reactionCounts:
          serializer.fromJson<Map<String, int>>(json['reactionCounts']),
      reactionScores:
          serializer.fromJson<Map<String, int>>(json['reactionScores']),
      parentId: serializer.fromJson<String>(json['parentId']),
      quotedMessageId: serializer.fromJson<String>(json['quotedMessageId']),
      replyCount: serializer.fromJson<int>(json['replyCount']),
      showInChannel: serializer.fromJson<bool>(json['showInChannel']),
      shadowed: serializer.fromJson<bool>(json['shadowed']),
      command: serializer.fromJson<String>(json['command']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime>(json['deletedAt']),
      userId: serializer.fromJson<String>(json['userId']),
      channelCid: serializer.fromJson<String>(json['channelCid']),
      extraData: serializer.fromJson<Map<String, dynamic>>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageText': serializer.toJson<String>(messageText),
      'attachmentJson': serializer.toJson<String>(attachmentJson),
      'status': serializer.toJson<MessageSendingStatus>(status),
      'type': serializer.toJson<String>(type),
      'reactionCounts': serializer.toJson<Map<String, int>>(reactionCounts),
      'reactionScores': serializer.toJson<Map<String, int>>(reactionScores),
      'parentId': serializer.toJson<String>(parentId),
      'quotedMessageId': serializer.toJson<String>(quotedMessageId),
      'replyCount': serializer.toJson<int>(replyCount),
      'showInChannel': serializer.toJson<bool>(showInChannel),
      'shadowed': serializer.toJson<bool>(shadowed),
      'command': serializer.toJson<String>(command),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime>(deletedAt),
      'userId': serializer.toJson<String>(userId),
      'channelCid': serializer.toJson<String>(channelCid),
      'extraData': serializer.toJson<Map<String, dynamic>>(extraData),
    };
  }

  _Message copyWith(
          {String id,
          String messageText,
          String attachmentJson,
          MessageSendingStatus status,
          String type,
          Map<String, int> reactionCounts,
          Map<String, int> reactionScores,
          String parentId,
          String quotedMessageId,
          int replyCount,
          bool showInChannel,
          bool shadowed,
          String command,
          DateTime createdAt,
          DateTime updatedAt,
          DateTime deletedAt,
          String userId,
          String channelCid,
          Map<String, dynamic> extraData}) =>
      _Message(
        id: id ?? this.id,
        messageText: messageText ?? this.messageText,
        attachmentJson: attachmentJson ?? this.attachmentJson,
        status: status ?? this.status,
        type: type ?? this.type,
        reactionCounts: reactionCounts ?? this.reactionCounts,
        reactionScores: reactionScores ?? this.reactionScores,
        parentId: parentId ?? this.parentId,
        quotedMessageId: quotedMessageId ?? this.quotedMessageId,
        replyCount: replyCount ?? this.replyCount,
        showInChannel: showInChannel ?? this.showInChannel,
        shadowed: shadowed ?? this.shadowed,
        command: command ?? this.command,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        userId: userId ?? this.userId,
        channelCid: channelCid ?? this.channelCid,
        extraData: extraData ?? this.extraData,
      );
  @override
  String toString() {
    return (StringBuffer('_Message(')
          ..write('id: $id, ')
          ..write('messageText: $messageText, ')
          ..write('attachmentJson: $attachmentJson, ')
          ..write('status: $status, ')
          ..write('type: $type, ')
          ..write('reactionCounts: $reactionCounts, ')
          ..write('reactionScores: $reactionScores, ')
          ..write('parentId: $parentId, ')
          ..write('quotedMessageId: $quotedMessageId, ')
          ..write('replyCount: $replyCount, ')
          ..write('showInChannel: $showInChannel, ')
          ..write('shadowed: $shadowed, ')
          ..write('command: $command, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('userId: $userId, ')
          ..write('channelCid: $channelCid, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          messageText.hashCode,
          $mrjc(
              attachmentJson.hashCode,
              $mrjc(
                  status.hashCode,
                  $mrjc(
                      type.hashCode,
                      $mrjc(
                          reactionCounts.hashCode,
                          $mrjc(
                              reactionScores.hashCode,
                              $mrjc(
                                  parentId.hashCode,
                                  $mrjc(
                                      quotedMessageId.hashCode,
                                      $mrjc(
                                          replyCount.hashCode,
                                          $mrjc(
                                              showInChannel.hashCode,
                                              $mrjc(
                                                  shadowed.hashCode,
                                                  $mrjc(
                                                      command.hashCode,
                                                      $mrjc(
                                                          createdAt.hashCode,
                                                          $mrjc(
                                                              updatedAt
                                                                  .hashCode,
                                                              $mrjc(
                                                                  deletedAt
                                                                      .hashCode,
                                                                  $mrjc(
                                                                      userId
                                                                          .hashCode,
                                                                      $mrjc(
                                                                          channelCid
                                                                              .hashCode,
                                                                          extraData
                                                                              .hashCode)))))))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is _Message &&
          other.id == this.id &&
          other.messageText == this.messageText &&
          other.attachmentJson == this.attachmentJson &&
          other.status == this.status &&
          other.type == this.type &&
          other.reactionCounts == this.reactionCounts &&
          other.reactionScores == this.reactionScores &&
          other.parentId == this.parentId &&
          other.quotedMessageId == this.quotedMessageId &&
          other.replyCount == this.replyCount &&
          other.showInChannel == this.showInChannel &&
          other.shadowed == this.shadowed &&
          other.command == this.command &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.userId == this.userId &&
          other.channelCid == this.channelCid &&
          other.extraData == this.extraData);
}

class _MessagesCompanion extends UpdateCompanion<_Message> {
  final Value<String> id;
  final Value<String> messageText;
  final Value<String> attachmentJson;
  final Value<MessageSendingStatus> status;
  final Value<String> type;
  final Value<Map<String, int>> reactionCounts;
  final Value<Map<String, int>> reactionScores;
  final Value<String> parentId;
  final Value<String> quotedMessageId;
  final Value<int> replyCount;
  final Value<bool> showInChannel;
  final Value<bool> shadowed;
  final Value<String> command;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> deletedAt;
  final Value<String> userId;
  final Value<String> channelCid;
  final Value<Map<String, dynamic>> extraData;
  const _MessagesCompanion({
    this.id = const Value.absent(),
    this.messageText = const Value.absent(),
    this.attachmentJson = const Value.absent(),
    this.status = const Value.absent(),
    this.type = const Value.absent(),
    this.reactionCounts = const Value.absent(),
    this.reactionScores = const Value.absent(),
    this.parentId = const Value.absent(),
    this.quotedMessageId = const Value.absent(),
    this.replyCount = const Value.absent(),
    this.showInChannel = const Value.absent(),
    this.shadowed = const Value.absent(),
    this.command = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.channelCid = const Value.absent(),
    this.extraData = const Value.absent(),
  });
  _MessagesCompanion.insert({
    @required String id,
    this.messageText = const Value.absent(),
    this.attachmentJson = const Value.absent(),
    this.status = const Value.absent(),
    this.type = const Value.absent(),
    this.reactionCounts = const Value.absent(),
    this.reactionScores = const Value.absent(),
    this.parentId = const Value.absent(),
    this.quotedMessageId = const Value.absent(),
    this.replyCount = const Value.absent(),
    this.showInChannel = const Value.absent(),
    this.shadowed = const Value.absent(),
    this.command = const Value.absent(),
    @required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.channelCid = const Value.absent(),
    this.extraData = const Value.absent(),
  })  : id = Value(id),
        createdAt = Value(createdAt);
  static Insertable<_Message> custom({
    Expression<String> id,
    Expression<String> messageText,
    Expression<String> attachmentJson,
    Expression<int> status,
    Expression<String> type,
    Expression<String> reactionCounts,
    Expression<String> reactionScores,
    Expression<String> parentId,
    Expression<String> quotedMessageId,
    Expression<int> replyCount,
    Expression<bool> showInChannel,
    Expression<bool> shadowed,
    Expression<String> command,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
    Expression<DateTime> deletedAt,
    Expression<String> userId,
    Expression<String> channelCid,
    Expression<String> extraData,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageText != null) 'message_text': messageText,
      if (attachmentJson != null) 'attachment_json': attachmentJson,
      if (status != null) 'status': status,
      if (type != null) 'type': type,
      if (reactionCounts != null) 'reaction_counts': reactionCounts,
      if (reactionScores != null) 'reaction_scores': reactionScores,
      if (parentId != null) 'parent_id': parentId,
      if (quotedMessageId != null) 'quoted_message_id': quotedMessageId,
      if (replyCount != null) 'reply_count': replyCount,
      if (showInChannel != null) 'show_in_channel': showInChannel,
      if (shadowed != null) 'shadowed': shadowed,
      if (command != null) 'command': command,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (userId != null) 'user_id': userId,
      if (channelCid != null) 'channel_cid': channelCid,
      if (extraData != null) 'extra_data': extraData,
    });
  }

  _MessagesCompanion copyWith(
      {Value<String> id,
      Value<String> messageText,
      Value<String> attachmentJson,
      Value<MessageSendingStatus> status,
      Value<String> type,
      Value<Map<String, int>> reactionCounts,
      Value<Map<String, int>> reactionScores,
      Value<String> parentId,
      Value<String> quotedMessageId,
      Value<int> replyCount,
      Value<bool> showInChannel,
      Value<bool> shadowed,
      Value<String> command,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime> deletedAt,
      Value<String> userId,
      Value<String> channelCid,
      Value<Map<String, dynamic>> extraData}) {
    return _MessagesCompanion(
      id: id ?? this.id,
      messageText: messageText ?? this.messageText,
      attachmentJson: attachmentJson ?? this.attachmentJson,
      status: status ?? this.status,
      type: type ?? this.type,
      reactionCounts: reactionCounts ?? this.reactionCounts,
      reactionScores: reactionScores ?? this.reactionScores,
      parentId: parentId ?? this.parentId,
      quotedMessageId: quotedMessageId ?? this.quotedMessageId,
      replyCount: replyCount ?? this.replyCount,
      showInChannel: showInChannel ?? this.showInChannel,
      shadowed: shadowed ?? this.shadowed,
      command: command ?? this.command,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      userId: userId ?? this.userId,
      channelCid: channelCid ?? this.channelCid,
      extraData: extraData ?? this.extraData,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (messageText.present) {
      map['message_text'] = Variable<String>(messageText.value);
    }
    if (attachmentJson.present) {
      map['attachment_json'] = Variable<String>(attachmentJson.value);
    }
    if (status.present) {
      final converter = $_MessagesTable.$converter0;
      map['status'] = Variable<int>(converter.mapToSql(status.value));
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (reactionCounts.present) {
      final converter = $_MessagesTable.$converter1;
      map['reaction_counts'] =
          Variable<String>(converter.mapToSql(reactionCounts.value));
    }
    if (reactionScores.present) {
      final converter = $_MessagesTable.$converter2;
      map['reaction_scores'] =
          Variable<String>(converter.mapToSql(reactionScores.value));
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (quotedMessageId.present) {
      map['quoted_message_id'] = Variable<String>(quotedMessageId.value);
    }
    if (replyCount.present) {
      map['reply_count'] = Variable<int>(replyCount.value);
    }
    if (showInChannel.present) {
      map['show_in_channel'] = Variable<bool>(showInChannel.value);
    }
    if (shadowed.present) {
      map['shadowed'] = Variable<bool>(shadowed.value);
    }
    if (command.present) {
      map['command'] = Variable<String>(command.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (channelCid.present) {
      map['channel_cid'] = Variable<String>(channelCid.value);
    }
    if (extraData.present) {
      final converter = $_MessagesTable.$converter3;
      map['extra_data'] = Variable<String>(converter.mapToSql(extraData.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('_MessagesCompanion(')
          ..write('id: $id, ')
          ..write('messageText: $messageText, ')
          ..write('attachmentJson: $attachmentJson, ')
          ..write('status: $status, ')
          ..write('type: $type, ')
          ..write('reactionCounts: $reactionCounts, ')
          ..write('reactionScores: $reactionScores, ')
          ..write('parentId: $parentId, ')
          ..write('quotedMessageId: $quotedMessageId, ')
          ..write('replyCount: $replyCount, ')
          ..write('showInChannel: $showInChannel, ')
          ..write('shadowed: $shadowed, ')
          ..write('command: $command, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('userId: $userId, ')
          ..write('channelCid: $channelCid, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }
}

class $_MessagesTable extends _Messages
    with TableInfo<$_MessagesTable, _Message> {
  final GeneratedDatabase _db;
  final String _alias;
  $_MessagesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _messageTextMeta =
      const VerificationMeta('messageText');
  GeneratedTextColumn _messageText;
  @override
  GeneratedTextColumn get messageText =>
      _messageText ??= _constructMessageText();
  GeneratedTextColumn _constructMessageText() {
    return GeneratedTextColumn(
      'message_text',
      $tableName,
      true,
    );
  }

  final VerificationMeta _attachmentJsonMeta =
      const VerificationMeta('attachmentJson');
  GeneratedTextColumn _attachmentJson;
  @override
  GeneratedTextColumn get attachmentJson =>
      _attachmentJson ??= _constructAttachmentJson();
  GeneratedTextColumn _constructAttachmentJson() {
    return GeneratedTextColumn(
      'attachment_json',
      $tableName,
      true,
    );
  }

  final VerificationMeta _statusMeta = const VerificationMeta('status');
  GeneratedIntColumn _status;
  @override
  GeneratedIntColumn get status => _status ??= _constructStatus();
  GeneratedIntColumn _constructStatus() {
    return GeneratedIntColumn(
      'status',
      $tableName,
      true,
    );
  }

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedTextColumn _type;
  @override
  GeneratedTextColumn get type => _type ??= _constructType();
  GeneratedTextColumn _constructType() {
    return GeneratedTextColumn(
      'type',
      $tableName,
      true,
    );
  }

  final VerificationMeta _reactionCountsMeta =
      const VerificationMeta('reactionCounts');
  GeneratedTextColumn _reactionCounts;
  @override
  GeneratedTextColumn get reactionCounts =>
      _reactionCounts ??= _constructReactionCounts();
  GeneratedTextColumn _constructReactionCounts() {
    return GeneratedTextColumn(
      'reaction_counts',
      $tableName,
      true,
    );
  }

  final VerificationMeta _reactionScoresMeta =
      const VerificationMeta('reactionScores');
  GeneratedTextColumn _reactionScores;
  @override
  GeneratedTextColumn get reactionScores =>
      _reactionScores ??= _constructReactionScores();
  GeneratedTextColumn _constructReactionScores() {
    return GeneratedTextColumn(
      'reaction_scores',
      $tableName,
      true,
    );
  }

  final VerificationMeta _parentIdMeta = const VerificationMeta('parentId');
  GeneratedTextColumn _parentId;
  @override
  GeneratedTextColumn get parentId => _parentId ??= _constructParentId();
  GeneratedTextColumn _constructParentId() {
    return GeneratedTextColumn(
      'parent_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _quotedMessageIdMeta =
      const VerificationMeta('quotedMessageId');
  GeneratedTextColumn _quotedMessageId;
  @override
  GeneratedTextColumn get quotedMessageId =>
      _quotedMessageId ??= _constructQuotedMessageId();
  GeneratedTextColumn _constructQuotedMessageId() {
    return GeneratedTextColumn(
      'quoted_message_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _replyCountMeta = const VerificationMeta('replyCount');
  GeneratedIntColumn _replyCount;
  @override
  GeneratedIntColumn get replyCount => _replyCount ??= _constructReplyCount();
  GeneratedIntColumn _constructReplyCount() {
    return GeneratedIntColumn(
      'reply_count',
      $tableName,
      true,
    );
  }

  final VerificationMeta _showInChannelMeta =
      const VerificationMeta('showInChannel');
  GeneratedBoolColumn _showInChannel;
  @override
  GeneratedBoolColumn get showInChannel =>
      _showInChannel ??= _constructShowInChannel();
  GeneratedBoolColumn _constructShowInChannel() {
    return GeneratedBoolColumn(
      'show_in_channel',
      $tableName,
      true,
    );
  }

  final VerificationMeta _shadowedMeta = const VerificationMeta('shadowed');
  GeneratedBoolColumn _shadowed;
  @override
  GeneratedBoolColumn get shadowed => _shadowed ??= _constructShadowed();
  GeneratedBoolColumn _constructShadowed() {
    return GeneratedBoolColumn(
      'shadowed',
      $tableName,
      true,
    );
  }

  final VerificationMeta _commandMeta = const VerificationMeta('command');
  GeneratedTextColumn _command;
  @override
  GeneratedTextColumn get command => _command ??= _constructCommand();
  GeneratedTextColumn _constructCommand() {
    return GeneratedTextColumn(
      'command',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn(
      'created_at',
      $tableName,
      false,
    );
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  GeneratedDateTimeColumn _deletedAt;
  @override
  GeneratedDateTimeColumn get deletedAt => _deletedAt ??= _constructDeletedAt();
  GeneratedDateTimeColumn _constructDeletedAt() {
    return GeneratedDateTimeColumn(
      'deleted_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  GeneratedTextColumn _userId;
  @override
  GeneratedTextColumn get userId => _userId ??= _constructUserId();
  GeneratedTextColumn _constructUserId() {
    return GeneratedTextColumn(
      'user_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _channelCidMeta = const VerificationMeta('channelCid');
  GeneratedTextColumn _channelCid;
  @override
  GeneratedTextColumn get channelCid => _channelCid ??= _constructChannelCid();
  GeneratedTextColumn _constructChannelCid() {
    return GeneratedTextColumn(
      'channel_cid',
      $tableName,
      true,
    );
  }

  final VerificationMeta _extraDataMeta = const VerificationMeta('extraData');
  GeneratedTextColumn _extraData;
  @override
  GeneratedTextColumn get extraData => _extraData ??= _constructExtraData();
  GeneratedTextColumn _constructExtraData() {
    return GeneratedTextColumn(
      'extra_data',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        messageText,
        attachmentJson,
        status,
        type,
        reactionCounts,
        reactionScores,
        parentId,
        quotedMessageId,
        replyCount,
        showInChannel,
        shadowed,
        command,
        createdAt,
        updatedAt,
        deletedAt,
        userId,
        channelCid,
        extraData
      ];
  @override
  $_MessagesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'messages';
  @override
  final String actualTableName = 'messages';
  @override
  VerificationContext validateIntegrity(Insertable<_Message> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('message_text')) {
      context.handle(
          _messageTextMeta,
          messageText.isAcceptableOrUnknown(
              data['message_text'], _messageTextMeta));
    }
    if (data.containsKey('attachment_json')) {
      context.handle(
          _attachmentJsonMeta,
          attachmentJson.isAcceptableOrUnknown(
              data['attachment_json'], _attachmentJsonMeta));
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type'], _typeMeta));
    }
    context.handle(_reactionCountsMeta, const VerificationResult.success());
    context.handle(_reactionScoresMeta, const VerificationResult.success());
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id'], _parentIdMeta));
    }
    if (data.containsKey('quoted_message_id')) {
      context.handle(
          _quotedMessageIdMeta,
          quotedMessageId.isAcceptableOrUnknown(
              data['quoted_message_id'], _quotedMessageIdMeta));
    }
    if (data.containsKey('reply_count')) {
      context.handle(
          _replyCountMeta,
          replyCount.isAcceptableOrUnknown(
              data['reply_count'], _replyCountMeta));
    }
    if (data.containsKey('show_in_channel')) {
      context.handle(
          _showInChannelMeta,
          showInChannel.isAcceptableOrUnknown(
              data['show_in_channel'], _showInChannelMeta));
    }
    if (data.containsKey('shadowed')) {
      context.handle(_shadowedMeta,
          shadowed.isAcceptableOrUnknown(data['shadowed'], _shadowedMeta));
    }
    if (data.containsKey('command')) {
      context.handle(_commandMeta,
          command.isAcceptableOrUnknown(data['command'], _commandMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at'], _deletedAtMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id'], _userIdMeta));
    }
    if (data.containsKey('channel_cid')) {
      context.handle(
          _channelCidMeta,
          channelCid.isAcceptableOrUnknown(
              data['channel_cid'], _channelCidMeta));
    }
    context.handle(_extraDataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  _Message map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return _Message.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $_MessagesTable createAlias(String alias) {
    return $_MessagesTable(_db, alias);
  }

  static TypeConverter<MessageSendingStatus, int> $converter0 =
      _MessageSendingStatusConverter();
  static TypeConverter<Map<String, int>, String> $converter1 =
      _ExtraDataConverter<int>();
  static TypeConverter<Map<String, int>, String> $converter2 =
      _ExtraDataConverter<int>();
  static TypeConverter<Map<String, dynamic>, String> $converter3 =
      _ExtraDataConverter();
}

class _Read extends DataClass implements Insertable<_Read> {
  final DateTime lastRead;
  final String userId;
  final String channelCid;
  final int unreadMessages;
  _Read(
      {@required this.lastRead,
      @required this.userId,
      @required this.channelCid,
      this.unreadMessages});
  factory _Read.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    return _Read(
      lastRead: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_read']),
      userId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      channelCid: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_cid']),
      unreadMessages: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}unread_messages']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || lastRead != null) {
      map['last_read'] = Variable<DateTime>(lastRead);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || channelCid != null) {
      map['channel_cid'] = Variable<String>(channelCid);
    }
    if (!nullToAbsent || unreadMessages != null) {
      map['unread_messages'] = Variable<int>(unreadMessages);
    }
    return map;
  }

  _ReadsCompanion toCompanion(bool nullToAbsent) {
    return _ReadsCompanion(
      lastRead: lastRead == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRead),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      channelCid: channelCid == null && nullToAbsent
          ? const Value.absent()
          : Value(channelCid),
      unreadMessages: unreadMessages == null && nullToAbsent
          ? const Value.absent()
          : Value(unreadMessages),
    );
  }

  factory _Read.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return _Read(
      lastRead: serializer.fromJson<DateTime>(json['lastRead']),
      userId: serializer.fromJson<String>(json['userId']),
      channelCid: serializer.fromJson<String>(json['channelCid']),
      unreadMessages: serializer.fromJson<int>(json['unreadMessages']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lastRead': serializer.toJson<DateTime>(lastRead),
      'userId': serializer.toJson<String>(userId),
      'channelCid': serializer.toJson<String>(channelCid),
      'unreadMessages': serializer.toJson<int>(unreadMessages),
    };
  }

  _Read copyWith(
          {DateTime lastRead,
          String userId,
          String channelCid,
          int unreadMessages}) =>
      _Read(
        lastRead: lastRead ?? this.lastRead,
        userId: userId ?? this.userId,
        channelCid: channelCid ?? this.channelCid,
        unreadMessages: unreadMessages ?? this.unreadMessages,
      );
  @override
  String toString() {
    return (StringBuffer('_Read(')
          ..write('lastRead: $lastRead, ')
          ..write('userId: $userId, ')
          ..write('channelCid: $channelCid, ')
          ..write('unreadMessages: $unreadMessages')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      lastRead.hashCode,
      $mrjc(userId.hashCode,
          $mrjc(channelCid.hashCode, unreadMessages.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is _Read &&
          other.lastRead == this.lastRead &&
          other.userId == this.userId &&
          other.channelCid == this.channelCid &&
          other.unreadMessages == this.unreadMessages);
}

class _ReadsCompanion extends UpdateCompanion<_Read> {
  final Value<DateTime> lastRead;
  final Value<String> userId;
  final Value<String> channelCid;
  final Value<int> unreadMessages;
  const _ReadsCompanion({
    this.lastRead = const Value.absent(),
    this.userId = const Value.absent(),
    this.channelCid = const Value.absent(),
    this.unreadMessages = const Value.absent(),
  });
  _ReadsCompanion.insert({
    @required DateTime lastRead,
    @required String userId,
    @required String channelCid,
    this.unreadMessages = const Value.absent(),
  })  : lastRead = Value(lastRead),
        userId = Value(userId),
        channelCid = Value(channelCid);
  static Insertable<_Read> custom({
    Expression<DateTime> lastRead,
    Expression<String> userId,
    Expression<String> channelCid,
    Expression<int> unreadMessages,
  }) {
    return RawValuesInsertable({
      if (lastRead != null) 'last_read': lastRead,
      if (userId != null) 'user_id': userId,
      if (channelCid != null) 'channel_cid': channelCid,
      if (unreadMessages != null) 'unread_messages': unreadMessages,
    });
  }

  _ReadsCompanion copyWith(
      {Value<DateTime> lastRead,
      Value<String> userId,
      Value<String> channelCid,
      Value<int> unreadMessages}) {
    return _ReadsCompanion(
      lastRead: lastRead ?? this.lastRead,
      userId: userId ?? this.userId,
      channelCid: channelCid ?? this.channelCid,
      unreadMessages: unreadMessages ?? this.unreadMessages,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lastRead.present) {
      map['last_read'] = Variable<DateTime>(lastRead.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (channelCid.present) {
      map['channel_cid'] = Variable<String>(channelCid.value);
    }
    if (unreadMessages.present) {
      map['unread_messages'] = Variable<int>(unreadMessages.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('_ReadsCompanion(')
          ..write('lastRead: $lastRead, ')
          ..write('userId: $userId, ')
          ..write('channelCid: $channelCid, ')
          ..write('unreadMessages: $unreadMessages')
          ..write(')'))
        .toString();
  }
}

class $_ReadsTable extends _Reads with TableInfo<$_ReadsTable, _Read> {
  final GeneratedDatabase _db;
  final String _alias;
  $_ReadsTable(this._db, [this._alias]);
  final VerificationMeta _lastReadMeta = const VerificationMeta('lastRead');
  GeneratedDateTimeColumn _lastRead;
  @override
  GeneratedDateTimeColumn get lastRead => _lastRead ??= _constructLastRead();
  GeneratedDateTimeColumn _constructLastRead() {
    return GeneratedDateTimeColumn(
      'last_read',
      $tableName,
      false,
    );
  }

  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  GeneratedTextColumn _userId;
  @override
  GeneratedTextColumn get userId => _userId ??= _constructUserId();
  GeneratedTextColumn _constructUserId() {
    return GeneratedTextColumn(
      'user_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _channelCidMeta = const VerificationMeta('channelCid');
  GeneratedTextColumn _channelCid;
  @override
  GeneratedTextColumn get channelCid => _channelCid ??= _constructChannelCid();
  GeneratedTextColumn _constructChannelCid() {
    return GeneratedTextColumn(
      'channel_cid',
      $tableName,
      false,
    );
  }

  final VerificationMeta _unreadMessagesMeta =
      const VerificationMeta('unreadMessages');
  GeneratedIntColumn _unreadMessages;
  @override
  GeneratedIntColumn get unreadMessages =>
      _unreadMessages ??= _constructUnreadMessages();
  GeneratedIntColumn _constructUnreadMessages() {
    return GeneratedIntColumn(
      'unread_messages',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [lastRead, userId, channelCid, unreadMessages];
  @override
  $_ReadsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'reads';
  @override
  final String actualTableName = 'reads';
  @override
  VerificationContext validateIntegrity(Insertable<_Read> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('last_read')) {
      context.handle(_lastReadMeta,
          lastRead.isAcceptableOrUnknown(data['last_read'], _lastReadMeta));
    } else if (isInserting) {
      context.missing(_lastReadMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id'], _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('channel_cid')) {
      context.handle(
          _channelCidMeta,
          channelCid.isAcceptableOrUnknown(
              data['channel_cid'], _channelCidMeta));
    } else if (isInserting) {
      context.missing(_channelCidMeta);
    }
    if (data.containsKey('unread_messages')) {
      context.handle(
          _unreadMessagesMeta,
          unreadMessages.isAcceptableOrUnknown(
              data['unread_messages'], _unreadMessagesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, channelCid};
  @override
  _Read map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return _Read.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $_ReadsTable createAlias(String alias) {
    return $_ReadsTable(_db, alias);
  }
}

class _Member extends DataClass implements Insertable<_Member> {
  final String userId;
  final String channelCid;
  final String role;
  final DateTime inviteAcceptedAt;
  final DateTime inviteRejectedAt;
  final bool invited;
  final bool banned;
  final bool shadowBanned;
  final bool isModerator;
  final DateTime createdAt;
  final DateTime updatedAt;
  _Member(
      {@required this.userId,
      @required this.channelCid,
      this.role,
      this.inviteAcceptedAt,
      this.inviteRejectedAt,
      this.invited,
      this.banned,
      this.shadowBanned,
      this.isModerator,
      @required this.createdAt,
      this.updatedAt});
  factory _Member.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return _Member(
      userId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      channelCid: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_cid']),
      role: stringType.mapFromDatabaseResponse(data['${effectivePrefix}role']),
      inviteAcceptedAt: dateTimeType.mapFromDatabaseResponse(
          data['${effectivePrefix}invite_accepted_at']),
      inviteRejectedAt: dateTimeType.mapFromDatabaseResponse(
          data['${effectivePrefix}invite_rejected_at']),
      invited:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}invited']),
      banned:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}banned']),
      shadowBanned: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}shadow_banned']),
      isModerator: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_moderator']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || channelCid != null) {
      map['channel_cid'] = Variable<String>(channelCid);
    }
    if (!nullToAbsent || role != null) {
      map['role'] = Variable<String>(role);
    }
    if (!nullToAbsent || inviteAcceptedAt != null) {
      map['invite_accepted_at'] = Variable<DateTime>(inviteAcceptedAt);
    }
    if (!nullToAbsent || inviteRejectedAt != null) {
      map['invite_rejected_at'] = Variable<DateTime>(inviteRejectedAt);
    }
    if (!nullToAbsent || invited != null) {
      map['invited'] = Variable<bool>(invited);
    }
    if (!nullToAbsent || banned != null) {
      map['banned'] = Variable<bool>(banned);
    }
    if (!nullToAbsent || shadowBanned != null) {
      map['shadow_banned'] = Variable<bool>(shadowBanned);
    }
    if (!nullToAbsent || isModerator != null) {
      map['is_moderator'] = Variable<bool>(isModerator);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  _MembersCompanion toCompanion(bool nullToAbsent) {
    return _MembersCompanion(
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      channelCid: channelCid == null && nullToAbsent
          ? const Value.absent()
          : Value(channelCid),
      role: role == null && nullToAbsent ? const Value.absent() : Value(role),
      inviteAcceptedAt: inviteAcceptedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(inviteAcceptedAt),
      inviteRejectedAt: inviteRejectedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(inviteRejectedAt),
      invited: invited == null && nullToAbsent
          ? const Value.absent()
          : Value(invited),
      banned:
          banned == null && nullToAbsent ? const Value.absent() : Value(banned),
      shadowBanned: shadowBanned == null && nullToAbsent
          ? const Value.absent()
          : Value(shadowBanned),
      isModerator: isModerator == null && nullToAbsent
          ? const Value.absent()
          : Value(isModerator),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory _Member.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return _Member(
      userId: serializer.fromJson<String>(json['userId']),
      channelCid: serializer.fromJson<String>(json['channelCid']),
      role: serializer.fromJson<String>(json['role']),
      inviteAcceptedAt: serializer.fromJson<DateTime>(json['inviteAcceptedAt']),
      inviteRejectedAt: serializer.fromJson<DateTime>(json['inviteRejectedAt']),
      invited: serializer.fromJson<bool>(json['invited']),
      banned: serializer.fromJson<bool>(json['banned']),
      shadowBanned: serializer.fromJson<bool>(json['shadowBanned']),
      isModerator: serializer.fromJson<bool>(json['isModerator']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'channelCid': serializer.toJson<String>(channelCid),
      'role': serializer.toJson<String>(role),
      'inviteAcceptedAt': serializer.toJson<DateTime>(inviteAcceptedAt),
      'inviteRejectedAt': serializer.toJson<DateTime>(inviteRejectedAt),
      'invited': serializer.toJson<bool>(invited),
      'banned': serializer.toJson<bool>(banned),
      'shadowBanned': serializer.toJson<bool>(shadowBanned),
      'isModerator': serializer.toJson<bool>(isModerator),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  _Member copyWith(
          {String userId,
          String channelCid,
          String role,
          DateTime inviteAcceptedAt,
          DateTime inviteRejectedAt,
          bool invited,
          bool banned,
          bool shadowBanned,
          bool isModerator,
          DateTime createdAt,
          DateTime updatedAt}) =>
      _Member(
        userId: userId ?? this.userId,
        channelCid: channelCid ?? this.channelCid,
        role: role ?? this.role,
        inviteAcceptedAt: inviteAcceptedAt ?? this.inviteAcceptedAt,
        inviteRejectedAt: inviteRejectedAt ?? this.inviteRejectedAt,
        invited: invited ?? this.invited,
        banned: banned ?? this.banned,
        shadowBanned: shadowBanned ?? this.shadowBanned,
        isModerator: isModerator ?? this.isModerator,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('_Member(')
          ..write('userId: $userId, ')
          ..write('channelCid: $channelCid, ')
          ..write('role: $role, ')
          ..write('inviteAcceptedAt: $inviteAcceptedAt, ')
          ..write('inviteRejectedAt: $inviteRejectedAt, ')
          ..write('invited: $invited, ')
          ..write('banned: $banned, ')
          ..write('shadowBanned: $shadowBanned, ')
          ..write('isModerator: $isModerator, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      userId.hashCode,
      $mrjc(
          channelCid.hashCode,
          $mrjc(
              role.hashCode,
              $mrjc(
                  inviteAcceptedAt.hashCode,
                  $mrjc(
                      inviteRejectedAt.hashCode,
                      $mrjc(
                          invited.hashCode,
                          $mrjc(
                              banned.hashCode,
                              $mrjc(
                                  shadowBanned.hashCode,
                                  $mrjc(
                                      isModerator.hashCode,
                                      $mrjc(createdAt.hashCode,
                                          updatedAt.hashCode)))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is _Member &&
          other.userId == this.userId &&
          other.channelCid == this.channelCid &&
          other.role == this.role &&
          other.inviteAcceptedAt == this.inviteAcceptedAt &&
          other.inviteRejectedAt == this.inviteRejectedAt &&
          other.invited == this.invited &&
          other.banned == this.banned &&
          other.shadowBanned == this.shadowBanned &&
          other.isModerator == this.isModerator &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class _MembersCompanion extends UpdateCompanion<_Member> {
  final Value<String> userId;
  final Value<String> channelCid;
  final Value<String> role;
  final Value<DateTime> inviteAcceptedAt;
  final Value<DateTime> inviteRejectedAt;
  final Value<bool> invited;
  final Value<bool> banned;
  final Value<bool> shadowBanned;
  final Value<bool> isModerator;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const _MembersCompanion({
    this.userId = const Value.absent(),
    this.channelCid = const Value.absent(),
    this.role = const Value.absent(),
    this.inviteAcceptedAt = const Value.absent(),
    this.inviteRejectedAt = const Value.absent(),
    this.invited = const Value.absent(),
    this.banned = const Value.absent(),
    this.shadowBanned = const Value.absent(),
    this.isModerator = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  _MembersCompanion.insert({
    @required String userId,
    @required String channelCid,
    this.role = const Value.absent(),
    this.inviteAcceptedAt = const Value.absent(),
    this.inviteRejectedAt = const Value.absent(),
    this.invited = const Value.absent(),
    this.banned = const Value.absent(),
    this.shadowBanned = const Value.absent(),
    this.isModerator = const Value.absent(),
    @required DateTime createdAt,
    this.updatedAt = const Value.absent(),
  })  : userId = Value(userId),
        channelCid = Value(channelCid),
        createdAt = Value(createdAt);
  static Insertable<_Member> custom({
    Expression<String> userId,
    Expression<String> channelCid,
    Expression<String> role,
    Expression<DateTime> inviteAcceptedAt,
    Expression<DateTime> inviteRejectedAt,
    Expression<bool> invited,
    Expression<bool> banned,
    Expression<bool> shadowBanned,
    Expression<bool> isModerator,
    Expression<DateTime> createdAt,
    Expression<DateTime> updatedAt,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (channelCid != null) 'channel_cid': channelCid,
      if (role != null) 'role': role,
      if (inviteAcceptedAt != null) 'invite_accepted_at': inviteAcceptedAt,
      if (inviteRejectedAt != null) 'invite_rejected_at': inviteRejectedAt,
      if (invited != null) 'invited': invited,
      if (banned != null) 'banned': banned,
      if (shadowBanned != null) 'shadow_banned': shadowBanned,
      if (isModerator != null) 'is_moderator': isModerator,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  _MembersCompanion copyWith(
      {Value<String> userId,
      Value<String> channelCid,
      Value<String> role,
      Value<DateTime> inviteAcceptedAt,
      Value<DateTime> inviteRejectedAt,
      Value<bool> invited,
      Value<bool> banned,
      Value<bool> shadowBanned,
      Value<bool> isModerator,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt}) {
    return _MembersCompanion(
      userId: userId ?? this.userId,
      channelCid: channelCid ?? this.channelCid,
      role: role ?? this.role,
      inviteAcceptedAt: inviteAcceptedAt ?? this.inviteAcceptedAt,
      inviteRejectedAt: inviteRejectedAt ?? this.inviteRejectedAt,
      invited: invited ?? this.invited,
      banned: banned ?? this.banned,
      shadowBanned: shadowBanned ?? this.shadowBanned,
      isModerator: isModerator ?? this.isModerator,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (channelCid.present) {
      map['channel_cid'] = Variable<String>(channelCid.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (inviteAcceptedAt.present) {
      map['invite_accepted_at'] = Variable<DateTime>(inviteAcceptedAt.value);
    }
    if (inviteRejectedAt.present) {
      map['invite_rejected_at'] = Variable<DateTime>(inviteRejectedAt.value);
    }
    if (invited.present) {
      map['invited'] = Variable<bool>(invited.value);
    }
    if (banned.present) {
      map['banned'] = Variable<bool>(banned.value);
    }
    if (shadowBanned.present) {
      map['shadow_banned'] = Variable<bool>(shadowBanned.value);
    }
    if (isModerator.present) {
      map['is_moderator'] = Variable<bool>(isModerator.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('_MembersCompanion(')
          ..write('userId: $userId, ')
          ..write('channelCid: $channelCid, ')
          ..write('role: $role, ')
          ..write('inviteAcceptedAt: $inviteAcceptedAt, ')
          ..write('inviteRejectedAt: $inviteRejectedAt, ')
          ..write('invited: $invited, ')
          ..write('banned: $banned, ')
          ..write('shadowBanned: $shadowBanned, ')
          ..write('isModerator: $isModerator, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $_MembersTable extends _Members with TableInfo<$_MembersTable, _Member> {
  final GeneratedDatabase _db;
  final String _alias;
  $_MembersTable(this._db, [this._alias]);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  GeneratedTextColumn _userId;
  @override
  GeneratedTextColumn get userId => _userId ??= _constructUserId();
  GeneratedTextColumn _constructUserId() {
    return GeneratedTextColumn(
      'user_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _channelCidMeta = const VerificationMeta('channelCid');
  GeneratedTextColumn _channelCid;
  @override
  GeneratedTextColumn get channelCid => _channelCid ??= _constructChannelCid();
  GeneratedTextColumn _constructChannelCid() {
    return GeneratedTextColumn(
      'channel_cid',
      $tableName,
      false,
    );
  }

  final VerificationMeta _roleMeta = const VerificationMeta('role');
  GeneratedTextColumn _role;
  @override
  GeneratedTextColumn get role => _role ??= _constructRole();
  GeneratedTextColumn _constructRole() {
    return GeneratedTextColumn(
      'role',
      $tableName,
      true,
    );
  }

  final VerificationMeta _inviteAcceptedAtMeta =
      const VerificationMeta('inviteAcceptedAt');
  GeneratedDateTimeColumn _inviteAcceptedAt;
  @override
  GeneratedDateTimeColumn get inviteAcceptedAt =>
      _inviteAcceptedAt ??= _constructInviteAcceptedAt();
  GeneratedDateTimeColumn _constructInviteAcceptedAt() {
    return GeneratedDateTimeColumn(
      'invite_accepted_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _inviteRejectedAtMeta =
      const VerificationMeta('inviteRejectedAt');
  GeneratedDateTimeColumn _inviteRejectedAt;
  @override
  GeneratedDateTimeColumn get inviteRejectedAt =>
      _inviteRejectedAt ??= _constructInviteRejectedAt();
  GeneratedDateTimeColumn _constructInviteRejectedAt() {
    return GeneratedDateTimeColumn(
      'invite_rejected_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _invitedMeta = const VerificationMeta('invited');
  GeneratedBoolColumn _invited;
  @override
  GeneratedBoolColumn get invited => _invited ??= _constructInvited();
  GeneratedBoolColumn _constructInvited() {
    return GeneratedBoolColumn(
      'invited',
      $tableName,
      true,
    );
  }

  final VerificationMeta _bannedMeta = const VerificationMeta('banned');
  GeneratedBoolColumn _banned;
  @override
  GeneratedBoolColumn get banned => _banned ??= _constructBanned();
  GeneratedBoolColumn _constructBanned() {
    return GeneratedBoolColumn(
      'banned',
      $tableName,
      true,
    );
  }

  final VerificationMeta _shadowBannedMeta =
      const VerificationMeta('shadowBanned');
  GeneratedBoolColumn _shadowBanned;
  @override
  GeneratedBoolColumn get shadowBanned =>
      _shadowBanned ??= _constructShadowBanned();
  GeneratedBoolColumn _constructShadowBanned() {
    return GeneratedBoolColumn(
      'shadow_banned',
      $tableName,
      true,
    );
  }

  final VerificationMeta _isModeratorMeta =
      const VerificationMeta('isModerator');
  GeneratedBoolColumn _isModerator;
  @override
  GeneratedBoolColumn get isModerator =>
      _isModerator ??= _constructIsModerator();
  GeneratedBoolColumn _constructIsModerator() {
    return GeneratedBoolColumn(
      'is_moderator',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn(
      'created_at',
      $tableName,
      false,
    );
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        userId,
        channelCid,
        role,
        inviteAcceptedAt,
        inviteRejectedAt,
        invited,
        banned,
        shadowBanned,
        isModerator,
        createdAt,
        updatedAt
      ];
  @override
  $_MembersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'members';
  @override
  final String actualTableName = 'members';
  @override
  VerificationContext validateIntegrity(Insertable<_Member> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id'], _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('channel_cid')) {
      context.handle(
          _channelCidMeta,
          channelCid.isAcceptableOrUnknown(
              data['channel_cid'], _channelCidMeta));
    } else if (isInserting) {
      context.missing(_channelCidMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role'], _roleMeta));
    }
    if (data.containsKey('invite_accepted_at')) {
      context.handle(
          _inviteAcceptedAtMeta,
          inviteAcceptedAt.isAcceptableOrUnknown(
              data['invite_accepted_at'], _inviteAcceptedAtMeta));
    }
    if (data.containsKey('invite_rejected_at')) {
      context.handle(
          _inviteRejectedAtMeta,
          inviteRejectedAt.isAcceptableOrUnknown(
              data['invite_rejected_at'], _inviteRejectedAtMeta));
    }
    if (data.containsKey('invited')) {
      context.handle(_invitedMeta,
          invited.isAcceptableOrUnknown(data['invited'], _invitedMeta));
    }
    if (data.containsKey('banned')) {
      context.handle(_bannedMeta,
          banned.isAcceptableOrUnknown(data['banned'], _bannedMeta));
    }
    if (data.containsKey('shadow_banned')) {
      context.handle(
          _shadowBannedMeta,
          shadowBanned.isAcceptableOrUnknown(
              data['shadow_banned'], _shadowBannedMeta));
    }
    if (data.containsKey('is_moderator')) {
      context.handle(
          _isModeratorMeta,
          isModerator.isAcceptableOrUnknown(
              data['is_moderator'], _isModeratorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, channelCid};
  @override
  _Member map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return _Member.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $_MembersTable createAlias(String alias) {
    return $_MembersTable(_db, alias);
  }
}

class ChannelQuery extends DataClass implements Insertable<ChannelQuery> {
  final String queryHash;
  final String channelCid;
  ChannelQuery({@required this.queryHash, @required this.channelCid});
  factory ChannelQuery.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return ChannelQuery(
      queryHash: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}query_hash']),
      channelCid: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_cid']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || queryHash != null) {
      map['query_hash'] = Variable<String>(queryHash);
    }
    if (!nullToAbsent || channelCid != null) {
      map['channel_cid'] = Variable<String>(channelCid);
    }
    return map;
  }

  _ChannelQueriesCompanion toCompanion(bool nullToAbsent) {
    return _ChannelQueriesCompanion(
      queryHash: queryHash == null && nullToAbsent
          ? const Value.absent()
          : Value(queryHash),
      channelCid: channelCid == null && nullToAbsent
          ? const Value.absent()
          : Value(channelCid),
    );
  }

  factory ChannelQuery.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ChannelQuery(
      queryHash: serializer.fromJson<String>(json['queryHash']),
      channelCid: serializer.fromJson<String>(json['channelCid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'queryHash': serializer.toJson<String>(queryHash),
      'channelCid': serializer.toJson<String>(channelCid),
    };
  }

  ChannelQuery copyWith({String queryHash, String channelCid}) => ChannelQuery(
        queryHash: queryHash ?? this.queryHash,
        channelCid: channelCid ?? this.channelCid,
      );
  @override
  String toString() {
    return (StringBuffer('ChannelQuery(')
          ..write('queryHash: $queryHash, ')
          ..write('channelCid: $channelCid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(queryHash.hashCode, channelCid.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ChannelQuery &&
          other.queryHash == this.queryHash &&
          other.channelCid == this.channelCid);
}

class _ChannelQueriesCompanion extends UpdateCompanion<ChannelQuery> {
  final Value<String> queryHash;
  final Value<String> channelCid;
  const _ChannelQueriesCompanion({
    this.queryHash = const Value.absent(),
    this.channelCid = const Value.absent(),
  });
  _ChannelQueriesCompanion.insert({
    @required String queryHash,
    @required String channelCid,
  })  : queryHash = Value(queryHash),
        channelCid = Value(channelCid);
  static Insertable<ChannelQuery> custom({
    Expression<String> queryHash,
    Expression<String> channelCid,
  }) {
    return RawValuesInsertable({
      if (queryHash != null) 'query_hash': queryHash,
      if (channelCid != null) 'channel_cid': channelCid,
    });
  }

  _ChannelQueriesCompanion copyWith(
      {Value<String> queryHash, Value<String> channelCid}) {
    return _ChannelQueriesCompanion(
      queryHash: queryHash ?? this.queryHash,
      channelCid: channelCid ?? this.channelCid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (queryHash.present) {
      map['query_hash'] = Variable<String>(queryHash.value);
    }
    if (channelCid.present) {
      map['channel_cid'] = Variable<String>(channelCid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('_ChannelQueriesCompanion(')
          ..write('queryHash: $queryHash, ')
          ..write('channelCid: $channelCid')
          ..write(')'))
        .toString();
  }
}

class $_ChannelQueriesTable extends _ChannelQueries
    with TableInfo<$_ChannelQueriesTable, ChannelQuery> {
  final GeneratedDatabase _db;
  final String _alias;
  $_ChannelQueriesTable(this._db, [this._alias]);
  final VerificationMeta _queryHashMeta = const VerificationMeta('queryHash');
  GeneratedTextColumn _queryHash;
  @override
  GeneratedTextColumn get queryHash => _queryHash ??= _constructQueryHash();
  GeneratedTextColumn _constructQueryHash() {
    return GeneratedTextColumn(
      'query_hash',
      $tableName,
      false,
    );
  }

  final VerificationMeta _channelCidMeta = const VerificationMeta('channelCid');
  GeneratedTextColumn _channelCid;
  @override
  GeneratedTextColumn get channelCid => _channelCid ??= _constructChannelCid();
  GeneratedTextColumn _constructChannelCid() {
    return GeneratedTextColumn(
      'channel_cid',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [queryHash, channelCid];
  @override
  $_ChannelQueriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'channel_queries';
  @override
  final String actualTableName = 'channel_queries';
  @override
  VerificationContext validateIntegrity(Insertable<ChannelQuery> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('query_hash')) {
      context.handle(_queryHashMeta,
          queryHash.isAcceptableOrUnknown(data['query_hash'], _queryHashMeta));
    } else if (isInserting) {
      context.missing(_queryHashMeta);
    }
    if (data.containsKey('channel_cid')) {
      context.handle(
          _channelCidMeta,
          channelCid.isAcceptableOrUnknown(
              data['channel_cid'], _channelCidMeta));
    } else if (isInserting) {
      context.missing(_channelCidMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {queryHash, channelCid};
  @override
  ChannelQuery map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ChannelQuery.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $_ChannelQueriesTable createAlias(String alias) {
    return $_ChannelQueriesTable(_db, alias);
  }
}

class _Reaction extends DataClass implements Insertable<_Reaction> {
  final String messageId;
  final String type;
  final DateTime createdAt;
  final int score;
  final String userId;
  final Map<String, dynamic> extraData;
  _Reaction(
      {@required this.messageId,
      @required this.type,
      @required this.createdAt,
      this.score,
      @required this.userId,
      this.extraData});
  factory _Reaction.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final intType = db.typeSystem.forDartType<int>();
    return _Reaction(
      messageId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}message_id']),
      type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      score: intType.mapFromDatabaseResponse(data['${effectivePrefix}score']),
      userId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      extraData: $_ReactionsTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}extra_data'])),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || messageId != null) {
      map['message_id'] = Variable<String>(messageId);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || extraData != null) {
      final converter = $_ReactionsTable.$converter0;
      map['extra_data'] = Variable<String>(converter.mapToSql(extraData));
    }
    return map;
  }

  _ReactionsCompanion toCompanion(bool nullToAbsent) {
    return _ReactionsCompanion(
      messageId: messageId == null && nullToAbsent
          ? const Value.absent()
          : Value(messageId),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      score:
          score == null && nullToAbsent ? const Value.absent() : Value(score),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      extraData: extraData == null && nullToAbsent
          ? const Value.absent()
          : Value(extraData),
    );
  }

  factory _Reaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return _Reaction(
      messageId: serializer.fromJson<String>(json['messageId']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      score: serializer.fromJson<int>(json['score']),
      userId: serializer.fromJson<String>(json['userId']),
      extraData: serializer.fromJson<Map<String, dynamic>>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'messageId': serializer.toJson<String>(messageId),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'score': serializer.toJson<int>(score),
      'userId': serializer.toJson<String>(userId),
      'extraData': serializer.toJson<Map<String, dynamic>>(extraData),
    };
  }

  _Reaction copyWith(
          {String messageId,
          String type,
          DateTime createdAt,
          int score,
          String userId,
          Map<String, dynamic> extraData}) =>
      _Reaction(
        messageId: messageId ?? this.messageId,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        score: score ?? this.score,
        userId: userId ?? this.userId,
        extraData: extraData ?? this.extraData,
      );
  @override
  String toString() {
    return (StringBuffer('_Reaction(')
          ..write('messageId: $messageId, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('score: $score, ')
          ..write('userId: $userId, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      messageId.hashCode,
      $mrjc(
          type.hashCode,
          $mrjc(
              createdAt.hashCode,
              $mrjc(score.hashCode,
                  $mrjc(userId.hashCode, extraData.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is _Reaction &&
          other.messageId == this.messageId &&
          other.type == this.type &&
          other.createdAt == this.createdAt &&
          other.score == this.score &&
          other.userId == this.userId &&
          other.extraData == this.extraData);
}

class _ReactionsCompanion extends UpdateCompanion<_Reaction> {
  final Value<String> messageId;
  final Value<String> type;
  final Value<DateTime> createdAt;
  final Value<int> score;
  final Value<String> userId;
  final Value<Map<String, dynamic>> extraData;
  const _ReactionsCompanion({
    this.messageId = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.score = const Value.absent(),
    this.userId = const Value.absent(),
    this.extraData = const Value.absent(),
  });
  _ReactionsCompanion.insert({
    @required String messageId,
    @required String type,
    @required DateTime createdAt,
    this.score = const Value.absent(),
    @required String userId,
    this.extraData = const Value.absent(),
  })  : messageId = Value(messageId),
        type = Value(type),
        createdAt = Value(createdAt),
        userId = Value(userId);
  static Insertable<_Reaction> custom({
    Expression<String> messageId,
    Expression<String> type,
    Expression<DateTime> createdAt,
    Expression<int> score,
    Expression<String> userId,
    Expression<String> extraData,
  }) {
    return RawValuesInsertable({
      if (messageId != null) 'message_id': messageId,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (score != null) 'score': score,
      if (userId != null) 'user_id': userId,
      if (extraData != null) 'extra_data': extraData,
    });
  }

  _ReactionsCompanion copyWith(
      {Value<String> messageId,
      Value<String> type,
      Value<DateTime> createdAt,
      Value<int> score,
      Value<String> userId,
      Value<Map<String, dynamic>> extraData}) {
    return _ReactionsCompanion(
      messageId: messageId ?? this.messageId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      score: score ?? this.score,
      userId: userId ?? this.userId,
      extraData: extraData ?? this.extraData,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (extraData.present) {
      final converter = $_ReactionsTable.$converter0;
      map['extra_data'] = Variable<String>(converter.mapToSql(extraData.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('_ReactionsCompanion(')
          ..write('messageId: $messageId, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('score: $score, ')
          ..write('userId: $userId, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }
}

class $_ReactionsTable extends _Reactions
    with TableInfo<$_ReactionsTable, _Reaction> {
  final GeneratedDatabase _db;
  final String _alias;
  $_ReactionsTable(this._db, [this._alias]);
  final VerificationMeta _messageIdMeta = const VerificationMeta('messageId');
  GeneratedTextColumn _messageId;
  @override
  GeneratedTextColumn get messageId => _messageId ??= _constructMessageId();
  GeneratedTextColumn _constructMessageId() {
    return GeneratedTextColumn(
      'message_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedTextColumn _type;
  @override
  GeneratedTextColumn get type => _type ??= _constructType();
  GeneratedTextColumn _constructType() {
    return GeneratedTextColumn(
      'type',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn(
      'created_at',
      $tableName,
      false,
    );
  }

  final VerificationMeta _scoreMeta = const VerificationMeta('score');
  GeneratedIntColumn _score;
  @override
  GeneratedIntColumn get score => _score ??= _constructScore();
  GeneratedIntColumn _constructScore() {
    return GeneratedIntColumn(
      'score',
      $tableName,
      true,
    );
  }

  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  GeneratedTextColumn _userId;
  @override
  GeneratedTextColumn get userId => _userId ??= _constructUserId();
  GeneratedTextColumn _constructUserId() {
    return GeneratedTextColumn(
      'user_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _extraDataMeta = const VerificationMeta('extraData');
  GeneratedTextColumn _extraData;
  @override
  GeneratedTextColumn get extraData => _extraData ??= _constructExtraData();
  GeneratedTextColumn _constructExtraData() {
    return GeneratedTextColumn(
      'extra_data',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [messageId, type, createdAt, score, userId, extraData];
  @override
  $_ReactionsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'reactions';
  @override
  final String actualTableName = 'reactions';
  @override
  VerificationContext validateIntegrity(Insertable<_Reaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id'], _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type'], _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score'], _scoreMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id'], _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    context.handle(_extraDataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {messageId, type, userId};
  @override
  _Reaction map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return _Reaction.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $_ReactionsTable createAlias(String alias) {
    return $_ReactionsTable(_db, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converter0 =
      _ExtraDataConverter();
}

abstract class _$OfflineStorage extends GeneratedDatabase {
  _$OfflineStorage(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  _$OfflineStorage.connect(DatabaseConnection c) : super.connect(c);
  $_ConnectionEventTable _connectionEvent;
  $_ConnectionEventTable get connectionEvent =>
      _connectionEvent ??= $_ConnectionEventTable(this);
  $_ChannelsTable _channels;
  $_ChannelsTable get channels => _channels ??= $_ChannelsTable(this);
  $_UsersTable _users;
  $_UsersTable get users => _users ??= $_UsersTable(this);
  $_MessagesTable _messages;
  $_MessagesTable get messages => _messages ??= $_MessagesTable(this);
  $_ReadsTable _reads;
  $_ReadsTable get reads => _reads ??= $_ReadsTable(this);
  $_MembersTable _members;
  $_MembersTable get members => _members ??= $_MembersTable(this);
  $_ChannelQueriesTable _channelQueries;
  $_ChannelQueriesTable get channelQueries =>
      _channelQueries ??= $_ChannelQueriesTable(this);
  $_ReactionsTable _reactions;
  $_ReactionsTable get reactions => _reactions ??= $_ReactionsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        connectionEvent,
        channels,
        users,
        messages,
        reads,
        members,
        channelQueries,
        reactions
      ];
}
