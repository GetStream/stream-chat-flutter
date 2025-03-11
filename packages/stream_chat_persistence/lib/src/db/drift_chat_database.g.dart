// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_chat_database.dart';

// ignore_for_file: type=lint
class $ChannelsTable extends Channels
    with TableInfo<$ChannelsTable, ChannelEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cidMeta = const VerificationMeta('cid');
  @override
  late final GeneratedColumn<String> cid = GeneratedColumn<String>(
      'cid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownCapabilitiesMeta =
      const VerificationMeta('ownCapabilities');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String>
      ownCapabilities = GeneratedColumn<String>(
              'own_capabilities', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<List<String>?>(
              $ChannelsTable.$converterownCapabilitiesn);
  static const VerificationMeta _configMeta = const VerificationMeta('config');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      config = GeneratedColumn<String>('config', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>($ChannelsTable.$converterconfig);
  static const VerificationMeta _frozenMeta = const VerificationMeta('frozen');
  @override
  late final GeneratedColumn<bool> frozen = GeneratedColumn<bool>(
      'frozen', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("frozen" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastMessageAtMeta =
      const VerificationMeta('lastMessageAt');
  @override
  late final GeneratedColumn<DateTime> lastMessageAt =
      GeneratedColumn<DateTime>('last_message_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _memberCountMeta =
      const VerificationMeta('memberCount');
  @override
  late final GeneratedColumn<int> memberCount = GeneratedColumn<int>(
      'member_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdByIdMeta =
      const VerificationMeta('createdById');
  @override
  late final GeneratedColumn<String> createdById = GeneratedColumn<String>(
      'created_by_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _extraDataMeta =
      const VerificationMeta('extraData');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      extraData = GeneratedColumn<String>('extra_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, dynamic>?>(
              $ChannelsTable.$converterextraDatan);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        type,
        cid,
        ownCapabilities,
        config,
        frozen,
        lastMessageAt,
        createdAt,
        updatedAt,
        deletedAt,
        memberCount,
        createdById,
        extraData
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channels';
  @override
  VerificationContext validateIntegrity(Insertable<ChannelEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('cid')) {
      context.handle(
          _cidMeta, cid.isAcceptableOrUnknown(data['cid']!, _cidMeta));
    } else if (isInserting) {
      context.missing(_cidMeta);
    }
    context.handle(_ownCapabilitiesMeta, const VerificationResult.success());
    context.handle(_configMeta, const VerificationResult.success());
    if (data.containsKey('frozen')) {
      context.handle(_frozenMeta,
          frozen.isAcceptableOrUnknown(data['frozen']!, _frozenMeta));
    }
    if (data.containsKey('last_message_at')) {
      context.handle(
          _lastMessageAtMeta,
          lastMessageAt.isAcceptableOrUnknown(
              data['last_message_at']!, _lastMessageAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('member_count')) {
      context.handle(
          _memberCountMeta,
          memberCount.isAcceptableOrUnknown(
              data['member_count']!, _memberCountMeta));
    }
    if (data.containsKey('created_by_id')) {
      context.handle(
          _createdByIdMeta,
          createdById.isAcceptableOrUnknown(
              data['created_by_id']!, _createdByIdMeta));
    }
    context.handle(_extraDataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cid};
  @override
  ChannelEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      cid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cid'])!,
      ownCapabilities: $ChannelsTable.$converterownCapabilitiesn.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}own_capabilities'])),
      config: $ChannelsTable.$converterconfig.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}config'])!),
      frozen: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}frozen'])!,
      lastMessageAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_message_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      memberCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}member_count'])!,
      createdById: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by_id']),
      extraData: $ChannelsTable.$converterextraDatan.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extra_data'])),
    );
  }

  @override
  $ChannelsTable createAlias(String alias) {
    return $ChannelsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterownCapabilities =
      ListConverter<String>();
  static TypeConverter<List<String>?, String?> $converterownCapabilitiesn =
      NullAwareTypeConverter.wrap($converterownCapabilities);
  static TypeConverter<Map<String, dynamic>, String> $converterconfig =
      MapConverter();
  static TypeConverter<Map<String, dynamic>, String> $converterextraData =
      MapConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $converterextraDatan =
      NullAwareTypeConverter.wrap($converterextraData);
}

class ChannelEntity extends DataClass implements Insertable<ChannelEntity> {
  /// The id of this channel
  final String id;

  /// The type of this channel
  final String type;

  /// The cid of this channel
  final String cid;

  /// List of user permissions on this channel
  final List<String>? ownCapabilities;

  /// The channel configuration data
  final Map<String, dynamic> config;

  /// True if this channel entity is frozen
  final bool frozen;

  /// The date of the last message
  final DateTime? lastMessageAt;

  /// The date of channel creation
  final DateTime createdAt;

  /// The date of the last channel update
  final DateTime updatedAt;

  /// The date of channel deletion
  final DateTime? deletedAt;

  /// The count of this channel members
  final int memberCount;

  /// The id of the user that created this channel
  final String? createdById;

  /// Map of custom channel extraData
  final Map<String, dynamic>? extraData;
  const ChannelEntity(
      {required this.id,
      required this.type,
      required this.cid,
      this.ownCapabilities,
      required this.config,
      required this.frozen,
      this.lastMessageAt,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.memberCount,
      this.createdById,
      this.extraData});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['cid'] = Variable<String>(cid);
    if (!nullToAbsent || ownCapabilities != null) {
      map['own_capabilities'] = Variable<String>(
          $ChannelsTable.$converterownCapabilitiesn.toSql(ownCapabilities));
    }
    {
      map['config'] =
          Variable<String>($ChannelsTable.$converterconfig.toSql(config));
    }
    map['frozen'] = Variable<bool>(frozen);
    if (!nullToAbsent || lastMessageAt != null) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['member_count'] = Variable<int>(memberCount);
    if (!nullToAbsent || createdById != null) {
      map['created_by_id'] = Variable<String>(createdById);
    }
    if (!nullToAbsent || extraData != null) {
      map['extra_data'] = Variable<String>(
          $ChannelsTable.$converterextraDatan.toSql(extraData));
    }
    return map;
  }

  factory ChannelEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelEntity(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      cid: serializer.fromJson<String>(json['cid']),
      ownCapabilities:
          serializer.fromJson<List<String>?>(json['ownCapabilities']),
      config: serializer.fromJson<Map<String, dynamic>>(json['config']),
      frozen: serializer.fromJson<bool>(json['frozen']),
      lastMessageAt: serializer.fromJson<DateTime?>(json['lastMessageAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      memberCount: serializer.fromJson<int>(json['memberCount']),
      createdById: serializer.fromJson<String?>(json['createdById']),
      extraData: serializer.fromJson<Map<String, dynamic>?>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'cid': serializer.toJson<String>(cid),
      'ownCapabilities': serializer.toJson<List<String>?>(ownCapabilities),
      'config': serializer.toJson<Map<String, dynamic>>(config),
      'frozen': serializer.toJson<bool>(frozen),
      'lastMessageAt': serializer.toJson<DateTime?>(lastMessageAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'memberCount': serializer.toJson<int>(memberCount),
      'createdById': serializer.toJson<String?>(createdById),
      'extraData': serializer.toJson<Map<String, dynamic>?>(extraData),
    };
  }

  ChannelEntity copyWith(
          {String? id,
          String? type,
          String? cid,
          Value<List<String>?> ownCapabilities = const Value.absent(),
          Map<String, dynamic>? config,
          bool? frozen,
          Value<DateTime?> lastMessageAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          int? memberCount,
          Value<String?> createdById = const Value.absent(),
          Value<Map<String, dynamic>?> extraData = const Value.absent()}) =>
      ChannelEntity(
        id: id ?? this.id,
        type: type ?? this.type,
        cid: cid ?? this.cid,
        ownCapabilities: ownCapabilities.present
            ? ownCapabilities.value
            : this.ownCapabilities,
        config: config ?? this.config,
        frozen: frozen ?? this.frozen,
        lastMessageAt:
            lastMessageAt.present ? lastMessageAt.value : this.lastMessageAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        memberCount: memberCount ?? this.memberCount,
        createdById: createdById.present ? createdById.value : this.createdById,
        extraData: extraData.present ? extraData.value : this.extraData,
      );
  ChannelEntity copyWithCompanion(ChannelsCompanion data) {
    return ChannelEntity(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      cid: data.cid.present ? data.cid.value : this.cid,
      ownCapabilities: data.ownCapabilities.present
          ? data.ownCapabilities.value
          : this.ownCapabilities,
      config: data.config.present ? data.config.value : this.config,
      frozen: data.frozen.present ? data.frozen.value : this.frozen,
      lastMessageAt: data.lastMessageAt.present
          ? data.lastMessageAt.value
          : this.lastMessageAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      memberCount:
          data.memberCount.present ? data.memberCount.value : this.memberCount,
      createdById:
          data.createdById.present ? data.createdById.value : this.createdById,
      extraData: data.extraData.present ? data.extraData.value : this.extraData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelEntity(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('cid: $cid, ')
          ..write('ownCapabilities: $ownCapabilities, ')
          ..write('config: $config, ')
          ..write('frozen: $frozen, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('memberCount: $memberCount, ')
          ..write('createdById: $createdById, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      type,
      cid,
      ownCapabilities,
      config,
      frozen,
      lastMessageAt,
      createdAt,
      updatedAt,
      deletedAt,
      memberCount,
      createdById,
      extraData);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelEntity &&
          other.id == this.id &&
          other.type == this.type &&
          other.cid == this.cid &&
          other.ownCapabilities == this.ownCapabilities &&
          other.config == this.config &&
          other.frozen == this.frozen &&
          other.lastMessageAt == this.lastMessageAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.memberCount == this.memberCount &&
          other.createdById == this.createdById &&
          other.extraData == this.extraData);
}

class ChannelsCompanion extends UpdateCompanion<ChannelEntity> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> cid;
  final Value<List<String>?> ownCapabilities;
  final Value<Map<String, dynamic>> config;
  final Value<bool> frozen;
  final Value<DateTime?> lastMessageAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> memberCount;
  final Value<String?> createdById;
  final Value<Map<String, dynamic>?> extraData;
  final Value<int> rowid;
  const ChannelsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.cid = const Value.absent(),
    this.ownCapabilities = const Value.absent(),
    this.config = const Value.absent(),
    this.frozen = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.memberCount = const Value.absent(),
    this.createdById = const Value.absent(),
    this.extraData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelsCompanion.insert({
    required String id,
    required String type,
    required String cid,
    this.ownCapabilities = const Value.absent(),
    required Map<String, dynamic> config,
    this.frozen = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.memberCount = const Value.absent(),
    this.createdById = const Value.absent(),
    this.extraData = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        cid = Value(cid),
        config = Value(config);
  static Insertable<ChannelEntity> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? cid,
    Expression<String>? ownCapabilities,
    Expression<String>? config,
    Expression<bool>? frozen,
    Expression<DateTime>? lastMessageAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? memberCount,
    Expression<String>? createdById,
    Expression<String>? extraData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (cid != null) 'cid': cid,
      if (ownCapabilities != null) 'own_capabilities': ownCapabilities,
      if (config != null) 'config': config,
      if (frozen != null) 'frozen': frozen,
      if (lastMessageAt != null) 'last_message_at': lastMessageAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (memberCount != null) 'member_count': memberCount,
      if (createdById != null) 'created_by_id': createdById,
      if (extraData != null) 'extra_data': extraData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelsCompanion copyWith(
      {Value<String>? id,
      Value<String>? type,
      Value<String>? cid,
      Value<List<String>?>? ownCapabilities,
      Value<Map<String, dynamic>>? config,
      Value<bool>? frozen,
      Value<DateTime?>? lastMessageAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? memberCount,
      Value<String?>? createdById,
      Value<Map<String, dynamic>?>? extraData,
      Value<int>? rowid}) {
    return ChannelsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      cid: cid ?? this.cid,
      ownCapabilities: ownCapabilities ?? this.ownCapabilities,
      config: config ?? this.config,
      frozen: frozen ?? this.frozen,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      memberCount: memberCount ?? this.memberCount,
      createdById: createdById ?? this.createdById,
      extraData: extraData ?? this.extraData,
      rowid: rowid ?? this.rowid,
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
    if (ownCapabilities.present) {
      map['own_capabilities'] = Variable<String>($ChannelsTable
          .$converterownCapabilitiesn
          .toSql(ownCapabilities.value));
    }
    if (config.present) {
      map['config'] =
          Variable<String>($ChannelsTable.$converterconfig.toSql(config.value));
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
    if (createdById.present) {
      map['created_by_id'] = Variable<String>(createdById.value);
    }
    if (extraData.present) {
      map['extra_data'] = Variable<String>(
          $ChannelsTable.$converterextraDatan.toSql(extraData.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('cid: $cid, ')
          ..write('ownCapabilities: $ownCapabilities, ')
          ..write('config: $config, ')
          ..write('frozen: $frozen, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('memberCount: $memberCount, ')
          ..write('createdById: $createdById, ')
          ..write('extraData: $extraData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages
    with TableInfo<$MessagesTable, MessageEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageTextMeta =
      const VerificationMeta('messageText');
  @override
  late final GeneratedColumn<String> messageText = GeneratedColumn<String>(
      'message_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _attachmentsMeta =
      const VerificationMeta('attachments');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
      attachments = GeneratedColumn<String>('attachments', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($MessagesTable.$converterattachments);
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
      'state', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('regular'));
  static const VerificationMeta _mentionedUsersMeta =
      const VerificationMeta('mentionedUsers');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
      mentionedUsers = GeneratedColumn<String>(
              'mentioned_users', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($MessagesTable.$convertermentionedUsers);
  static const VerificationMeta _reactionCountsMeta =
      const VerificationMeta('reactionCounts');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, int>?, String>
      reactionCounts = GeneratedColumn<String>(
              'reaction_counts', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, int>?>(
              $MessagesTable.$converterreactionCountsn);
  static const VerificationMeta _reactionScoresMeta =
      const VerificationMeta('reactionScores');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, int>?, String>
      reactionScores = GeneratedColumn<String>(
              'reaction_scores', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, int>?>(
              $MessagesTable.$converterreactionScoresn);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quotedMessageIdMeta =
      const VerificationMeta('quotedMessageId');
  @override
  late final GeneratedColumn<String> quotedMessageId = GeneratedColumn<String>(
      'quoted_message_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pollIdMeta = const VerificationMeta('pollId');
  @override
  late final GeneratedColumn<String> pollId = GeneratedColumn<String>(
      'poll_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _replyCountMeta =
      const VerificationMeta('replyCount');
  @override
  late final GeneratedColumn<int> replyCount = GeneratedColumn<int>(
      'reply_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _showInChannelMeta =
      const VerificationMeta('showInChannel');
  @override
  late final GeneratedColumn<bool> showInChannel = GeneratedColumn<bool>(
      'show_in_channel', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_in_channel" IN (0, 1))'));
  static const VerificationMeta _shadowedMeta =
      const VerificationMeta('shadowed');
  @override
  late final GeneratedColumn<bool> shadowed = GeneratedColumn<bool>(
      'shadowed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("shadowed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _commandMeta =
      const VerificationMeta('command');
  @override
  late final GeneratedColumn<String> command = GeneratedColumn<String>(
      'command', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _localCreatedAtMeta =
      const VerificationMeta('localCreatedAt');
  @override
  late final GeneratedColumn<DateTime> localCreatedAt =
      GeneratedColumn<DateTime>('local_created_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _remoteCreatedAtMeta =
      const VerificationMeta('remoteCreatedAt');
  @override
  late final GeneratedColumn<DateTime> remoteCreatedAt =
      GeneratedColumn<DateTime>('remote_created_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _remoteUpdatedAtMeta =
      const VerificationMeta('remoteUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> remoteUpdatedAt =
      GeneratedColumn<DateTime>('remote_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _localDeletedAtMeta =
      const VerificationMeta('localDeletedAt');
  @override
  late final GeneratedColumn<DateTime> localDeletedAt =
      GeneratedColumn<DateTime>('local_deleted_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _remoteDeletedAtMeta =
      const VerificationMeta('remoteDeletedAt');
  @override
  late final GeneratedColumn<DateTime> remoteDeletedAt =
      GeneratedColumn<DateTime>('remote_deleted_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _messageTextUpdatedAtMeta =
      const VerificationMeta('messageTextUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> messageTextUpdatedAt =
      GeneratedColumn<DateTime>('message_text_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pinnedMeta = const VerificationMeta('pinned');
  @override
  late final GeneratedColumn<bool> pinned = GeneratedColumn<bool>(
      'pinned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("pinned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _pinnedAtMeta =
      const VerificationMeta('pinnedAt');
  @override
  late final GeneratedColumn<DateTime> pinnedAt = GeneratedColumn<DateTime>(
      'pinned_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _pinExpiresMeta =
      const VerificationMeta('pinExpires');
  @override
  late final GeneratedColumn<DateTime> pinExpires = GeneratedColumn<DateTime>(
      'pin_expires', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _pinnedByUserIdMeta =
      const VerificationMeta('pinnedByUserId');
  @override
  late final GeneratedColumn<String> pinnedByUserId = GeneratedColumn<String>(
      'pinned_by_user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _channelCidMeta =
      const VerificationMeta('channelCid');
  @override
  late final GeneratedColumn<String> channelCid = GeneratedColumn<String>(
      'channel_cid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES channels (cid) ON DELETE CASCADE'));
  static const VerificationMeta _i18nMeta = const VerificationMeta('i18n');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>?, String>
      i18n = GeneratedColumn<String>('i18n', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, String>?>($MessagesTable.$converteri18n);
  static const VerificationMeta _restrictedVisibilityMeta =
      const VerificationMeta('restrictedVisibility');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String>
      restrictedVisibility = GeneratedColumn<String>(
              'restricted_visibility', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<List<String>?>(
              $MessagesTable.$converterrestrictedVisibilityn);
  static const VerificationMeta _extraDataMeta =
      const VerificationMeta('extraData');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      extraData = GeneratedColumn<String>('extra_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, dynamic>?>(
              $MessagesTable.$converterextraDatan);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        messageText,
        attachments,
        state,
        type,
        mentionedUsers,
        reactionCounts,
        reactionScores,
        parentId,
        quotedMessageId,
        pollId,
        replyCount,
        showInChannel,
        shadowed,
        command,
        localCreatedAt,
        remoteCreatedAt,
        localUpdatedAt,
        remoteUpdatedAt,
        localDeletedAt,
        remoteDeletedAt,
        messageTextUpdatedAt,
        userId,
        pinned,
        pinnedAt,
        pinExpires,
        pinnedByUserId,
        channelCid,
        i18n,
        restrictedVisibility,
        extraData
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(Insertable<MessageEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('message_text')) {
      context.handle(
          _messageTextMeta,
          messageText.isAcceptableOrUnknown(
              data['message_text']!, _messageTextMeta));
    }
    context.handle(_attachmentsMeta, const VerificationResult.success());
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    context.handle(_mentionedUsersMeta, const VerificationResult.success());
    context.handle(_reactionCountsMeta, const VerificationResult.success());
    context.handle(_reactionScoresMeta, const VerificationResult.success());
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('quoted_message_id')) {
      context.handle(
          _quotedMessageIdMeta,
          quotedMessageId.isAcceptableOrUnknown(
              data['quoted_message_id']!, _quotedMessageIdMeta));
    }
    if (data.containsKey('poll_id')) {
      context.handle(_pollIdMeta,
          pollId.isAcceptableOrUnknown(data['poll_id']!, _pollIdMeta));
    }
    if (data.containsKey('reply_count')) {
      context.handle(
          _replyCountMeta,
          replyCount.isAcceptableOrUnknown(
              data['reply_count']!, _replyCountMeta));
    }
    if (data.containsKey('show_in_channel')) {
      context.handle(
          _showInChannelMeta,
          showInChannel.isAcceptableOrUnknown(
              data['show_in_channel']!, _showInChannelMeta));
    }
    if (data.containsKey('shadowed')) {
      context.handle(_shadowedMeta,
          shadowed.isAcceptableOrUnknown(data['shadowed']!, _shadowedMeta));
    }
    if (data.containsKey('command')) {
      context.handle(_commandMeta,
          command.isAcceptableOrUnknown(data['command']!, _commandMeta));
    }
    if (data.containsKey('local_created_at')) {
      context.handle(
          _localCreatedAtMeta,
          localCreatedAt.isAcceptableOrUnknown(
              data['local_created_at']!, _localCreatedAtMeta));
    }
    if (data.containsKey('remote_created_at')) {
      context.handle(
          _remoteCreatedAtMeta,
          remoteCreatedAt.isAcceptableOrUnknown(
              data['remote_created_at']!, _remoteCreatedAtMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    if (data.containsKey('remote_updated_at')) {
      context.handle(
          _remoteUpdatedAtMeta,
          remoteUpdatedAt.isAcceptableOrUnknown(
              data['remote_updated_at']!, _remoteUpdatedAtMeta));
    }
    if (data.containsKey('local_deleted_at')) {
      context.handle(
          _localDeletedAtMeta,
          localDeletedAt.isAcceptableOrUnknown(
              data['local_deleted_at']!, _localDeletedAtMeta));
    }
    if (data.containsKey('remote_deleted_at')) {
      context.handle(
          _remoteDeletedAtMeta,
          remoteDeletedAt.isAcceptableOrUnknown(
              data['remote_deleted_at']!, _remoteDeletedAtMeta));
    }
    if (data.containsKey('message_text_updated_at')) {
      context.handle(
          _messageTextUpdatedAtMeta,
          messageTextUpdatedAt.isAcceptableOrUnknown(
              data['message_text_updated_at']!, _messageTextUpdatedAtMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('pinned')) {
      context.handle(_pinnedMeta,
          pinned.isAcceptableOrUnknown(data['pinned']!, _pinnedMeta));
    }
    if (data.containsKey('pinned_at')) {
      context.handle(_pinnedAtMeta,
          pinnedAt.isAcceptableOrUnknown(data['pinned_at']!, _pinnedAtMeta));
    }
    if (data.containsKey('pin_expires')) {
      context.handle(
          _pinExpiresMeta,
          pinExpires.isAcceptableOrUnknown(
              data['pin_expires']!, _pinExpiresMeta));
    }
    if (data.containsKey('pinned_by_user_id')) {
      context.handle(
          _pinnedByUserIdMeta,
          pinnedByUserId.isAcceptableOrUnknown(
              data['pinned_by_user_id']!, _pinnedByUserIdMeta));
    }
    if (data.containsKey('channel_cid')) {
      context.handle(
          _channelCidMeta,
          channelCid.isAcceptableOrUnknown(
              data['channel_cid']!, _channelCidMeta));
    } else if (isInserting) {
      context.missing(_channelCidMeta);
    }
    context.handle(_i18nMeta, const VerificationResult.success());
    context.handle(
        _restrictedVisibilityMeta, const VerificationResult.success());
    context.handle(_extraDataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      messageText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_text']),
      attachments: $MessagesTable.$converterattachments.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attachments'])!),
      state: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}state'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      mentionedUsers: $MessagesTable.$convertermentionedUsers.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}mentioned_users'])!),
      reactionCounts: $MessagesTable.$converterreactionCountsn.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}reaction_counts'])),
      reactionScores: $MessagesTable.$converterreactionScoresn.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}reaction_scores'])),
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
      quotedMessageId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}quoted_message_id']),
      pollId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}poll_id']),
      replyCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reply_count']),
      showInChannel: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_in_channel']),
      shadowed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}shadowed'])!,
      command: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}command']),
      localCreatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_created_at']),
      remoteCreatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}remote_created_at']),
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at']),
      remoteUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}remote_updated_at']),
      localDeletedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_deleted_at']),
      remoteDeletedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}remote_deleted_at']),
      messageTextUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}message_text_updated_at']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      pinned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pinned'])!,
      pinnedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}pinned_at']),
      pinExpires: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}pin_expires']),
      pinnedByUserId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}pinned_by_user_id']),
      channelCid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}channel_cid'])!,
      i18n: $MessagesTable.$converteri18n.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}i18n'])),
      restrictedVisibility: $MessagesTable.$converterrestrictedVisibilityn
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}restricted_visibility'])),
      extraData: $MessagesTable.$converterextraDatan.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extra_data'])),
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterattachments =
      ListConverter<String>();
  static TypeConverter<List<String>, String> $convertermentionedUsers =
      ListConverter<String>();
  static TypeConverter<Map<String, int>, String> $converterreactionCounts =
      MapConverter<int>();
  static TypeConverter<Map<String, int>?, String?> $converterreactionCountsn =
      NullAwareTypeConverter.wrap($converterreactionCounts);
  static TypeConverter<Map<String, int>, String> $converterreactionScores =
      MapConverter<int>();
  static TypeConverter<Map<String, int>?, String?> $converterreactionScoresn =
      NullAwareTypeConverter.wrap($converterreactionScores);
  static TypeConverter<Map<String, String>?, String?> $converteri18n =
      NullableMapConverter<String>();
  static TypeConverter<List<String>, String> $converterrestrictedVisibility =
      ListConverter<String>();
  static TypeConverter<List<String>?, String?> $converterrestrictedVisibilityn =
      NullAwareTypeConverter.wrap($converterrestrictedVisibility);
  static TypeConverter<Map<String, dynamic>, String> $converterextraData =
      MapConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $converterextraDatan =
      NullAwareTypeConverter.wrap($converterextraData);
}

class MessageEntity extends DataClass implements Insertable<MessageEntity> {
  /// The message id
  final String id;

  /// The text of this message
  final String? messageText;

  /// The list of attachments, either provided by the user
  /// or generated from a command or as a result of URL scraping.
  final List<String> attachments;

  /// The current state of the message.
  final String state;

  /// The message type
  final String type;

  /// The list of user mentioned in the message
  final List<String> mentionedUsers;

  /// A map describing the count of number of every reaction
  final Map<String, int>? reactionCounts;

  /// A map describing the count of score of every reaction
  final Map<String, int>? reactionScores;

  /// The ID of the parent message, if the message is a thread reply.
  final String? parentId;

  /// The ID of the quoted message, if the message is a quoted reply.
  final String? quotedMessageId;

  /// The ID of the poll, if the message is a poll.
  final String? pollId;

  /// Number of replies for this message.
  final int? replyCount;

  /// Check if this message needs to show in the channel.
  final bool? showInChannel;

  /// If true the message is shadowed
  final bool shadowed;

  /// A used command name.
  final String? command;

  /// The DateTime on which the message was created on the client.
  final DateTime? localCreatedAt;

  /// The DateTime on which the message was created on the server.
  final DateTime? remoteCreatedAt;

  /// The DateTime on which the message was updated on the client.
  final DateTime? localUpdatedAt;

  /// The DateTime on which the message was updated on the server.
  final DateTime? remoteUpdatedAt;

  /// The DateTime on which the message was deleted on the client.
  final DateTime? localDeletedAt;

  /// The DateTime on which the message was deleted on the server.
  final DateTime? remoteDeletedAt;

  /// The DateTime at which the message text was edited
  final DateTime? messageTextUpdatedAt;

  /// Id of the User who sent the message
  final String? userId;

  /// Whether the message is pinned or not
  final bool pinned;

  /// The DateTime at which the message was pinned
  final DateTime? pinnedAt;

  /// The DateTime on which the message pin expires
  final DateTime? pinExpires;

  /// Id of the User who pinned the message
  final String? pinnedByUserId;

  /// The channel cid of which this message is part of
  final String channelCid;

  /// A Map of [messageText] translations.
  final Map<String, String>? i18n;

  /// The list of user ids that should be able to see the message.
  final List<String>? restrictedVisibility;

  /// Message custom extraData
  final Map<String, dynamic>? extraData;
  const MessageEntity(
      {required this.id,
      this.messageText,
      required this.attachments,
      required this.state,
      required this.type,
      required this.mentionedUsers,
      this.reactionCounts,
      this.reactionScores,
      this.parentId,
      this.quotedMessageId,
      this.pollId,
      this.replyCount,
      this.showInChannel,
      required this.shadowed,
      this.command,
      this.localCreatedAt,
      this.remoteCreatedAt,
      this.localUpdatedAt,
      this.remoteUpdatedAt,
      this.localDeletedAt,
      this.remoteDeletedAt,
      this.messageTextUpdatedAt,
      this.userId,
      required this.pinned,
      this.pinnedAt,
      this.pinExpires,
      this.pinnedByUserId,
      required this.channelCid,
      this.i18n,
      this.restrictedVisibility,
      this.extraData});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || messageText != null) {
      map['message_text'] = Variable<String>(messageText);
    }
    {
      map['attachments'] = Variable<String>(
          $MessagesTable.$converterattachments.toSql(attachments));
    }
    map['state'] = Variable<String>(state);
    map['type'] = Variable<String>(type);
    {
      map['mentioned_users'] = Variable<String>(
          $MessagesTable.$convertermentionedUsers.toSql(mentionedUsers));
    }
    if (!nullToAbsent || reactionCounts != null) {
      map['reaction_counts'] = Variable<String>(
          $MessagesTable.$converterreactionCountsn.toSql(reactionCounts));
    }
    if (!nullToAbsent || reactionScores != null) {
      map['reaction_scores'] = Variable<String>(
          $MessagesTable.$converterreactionScoresn.toSql(reactionScores));
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    if (!nullToAbsent || quotedMessageId != null) {
      map['quoted_message_id'] = Variable<String>(quotedMessageId);
    }
    if (!nullToAbsent || pollId != null) {
      map['poll_id'] = Variable<String>(pollId);
    }
    if (!nullToAbsent || replyCount != null) {
      map['reply_count'] = Variable<int>(replyCount);
    }
    if (!nullToAbsent || showInChannel != null) {
      map['show_in_channel'] = Variable<bool>(showInChannel);
    }
    map['shadowed'] = Variable<bool>(shadowed);
    if (!nullToAbsent || command != null) {
      map['command'] = Variable<String>(command);
    }
    if (!nullToAbsent || localCreatedAt != null) {
      map['local_created_at'] = Variable<DateTime>(localCreatedAt);
    }
    if (!nullToAbsent || remoteCreatedAt != null) {
      map['remote_created_at'] = Variable<DateTime>(remoteCreatedAt);
    }
    if (!nullToAbsent || localUpdatedAt != null) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    }
    if (!nullToAbsent || remoteUpdatedAt != null) {
      map['remote_updated_at'] = Variable<DateTime>(remoteUpdatedAt);
    }
    if (!nullToAbsent || localDeletedAt != null) {
      map['local_deleted_at'] = Variable<DateTime>(localDeletedAt);
    }
    if (!nullToAbsent || remoteDeletedAt != null) {
      map['remote_deleted_at'] = Variable<DateTime>(remoteDeletedAt);
    }
    if (!nullToAbsent || messageTextUpdatedAt != null) {
      map['message_text_updated_at'] = Variable<DateTime>(messageTextUpdatedAt);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['pinned'] = Variable<bool>(pinned);
    if (!nullToAbsent || pinnedAt != null) {
      map['pinned_at'] = Variable<DateTime>(pinnedAt);
    }
    if (!nullToAbsent || pinExpires != null) {
      map['pin_expires'] = Variable<DateTime>(pinExpires);
    }
    if (!nullToAbsent || pinnedByUserId != null) {
      map['pinned_by_user_id'] = Variable<String>(pinnedByUserId);
    }
    map['channel_cid'] = Variable<String>(channelCid);
    if (!nullToAbsent || i18n != null) {
      map['i18n'] = Variable<String>($MessagesTable.$converteri18n.toSql(i18n));
    }
    if (!nullToAbsent || restrictedVisibility != null) {
      map['restricted_visibility'] = Variable<String>($MessagesTable
          .$converterrestrictedVisibilityn
          .toSql(restrictedVisibility));
    }
    if (!nullToAbsent || extraData != null) {
      map['extra_data'] = Variable<String>(
          $MessagesTable.$converterextraDatan.toSql(extraData));
    }
    return map;
  }

  factory MessageEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageEntity(
      id: serializer.fromJson<String>(json['id']),
      messageText: serializer.fromJson<String?>(json['messageText']),
      attachments: serializer.fromJson<List<String>>(json['attachments']),
      state: serializer.fromJson<String>(json['state']),
      type: serializer.fromJson<String>(json['type']),
      mentionedUsers: serializer.fromJson<List<String>>(json['mentionedUsers']),
      reactionCounts:
          serializer.fromJson<Map<String, int>?>(json['reactionCounts']),
      reactionScores:
          serializer.fromJson<Map<String, int>?>(json['reactionScores']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      quotedMessageId: serializer.fromJson<String?>(json['quotedMessageId']),
      pollId: serializer.fromJson<String?>(json['pollId']),
      replyCount: serializer.fromJson<int?>(json['replyCount']),
      showInChannel: serializer.fromJson<bool?>(json['showInChannel']),
      shadowed: serializer.fromJson<bool>(json['shadowed']),
      command: serializer.fromJson<String?>(json['command']),
      localCreatedAt: serializer.fromJson<DateTime?>(json['localCreatedAt']),
      remoteCreatedAt: serializer.fromJson<DateTime?>(json['remoteCreatedAt']),
      localUpdatedAt: serializer.fromJson<DateTime?>(json['localUpdatedAt']),
      remoteUpdatedAt: serializer.fromJson<DateTime?>(json['remoteUpdatedAt']),
      localDeletedAt: serializer.fromJson<DateTime?>(json['localDeletedAt']),
      remoteDeletedAt: serializer.fromJson<DateTime?>(json['remoteDeletedAt']),
      messageTextUpdatedAt:
          serializer.fromJson<DateTime?>(json['messageTextUpdatedAt']),
      userId: serializer.fromJson<String?>(json['userId']),
      pinned: serializer.fromJson<bool>(json['pinned']),
      pinnedAt: serializer.fromJson<DateTime?>(json['pinnedAt']),
      pinExpires: serializer.fromJson<DateTime?>(json['pinExpires']),
      pinnedByUserId: serializer.fromJson<String?>(json['pinnedByUserId']),
      channelCid: serializer.fromJson<String>(json['channelCid']),
      i18n: serializer.fromJson<Map<String, String>?>(json['i18n']),
      restrictedVisibility:
          serializer.fromJson<List<String>?>(json['restrictedVisibility']),
      extraData: serializer.fromJson<Map<String, dynamic>?>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageText': serializer.toJson<String?>(messageText),
      'attachments': serializer.toJson<List<String>>(attachments),
      'state': serializer.toJson<String>(state),
      'type': serializer.toJson<String>(type),
      'mentionedUsers': serializer.toJson<List<String>>(mentionedUsers),
      'reactionCounts': serializer.toJson<Map<String, int>?>(reactionCounts),
      'reactionScores': serializer.toJson<Map<String, int>?>(reactionScores),
      'parentId': serializer.toJson<String?>(parentId),
      'quotedMessageId': serializer.toJson<String?>(quotedMessageId),
      'pollId': serializer.toJson<String?>(pollId),
      'replyCount': serializer.toJson<int?>(replyCount),
      'showInChannel': serializer.toJson<bool?>(showInChannel),
      'shadowed': serializer.toJson<bool>(shadowed),
      'command': serializer.toJson<String?>(command),
      'localCreatedAt': serializer.toJson<DateTime?>(localCreatedAt),
      'remoteCreatedAt': serializer.toJson<DateTime?>(remoteCreatedAt),
      'localUpdatedAt': serializer.toJson<DateTime?>(localUpdatedAt),
      'remoteUpdatedAt': serializer.toJson<DateTime?>(remoteUpdatedAt),
      'localDeletedAt': serializer.toJson<DateTime?>(localDeletedAt),
      'remoteDeletedAt': serializer.toJson<DateTime?>(remoteDeletedAt),
      'messageTextUpdatedAt':
          serializer.toJson<DateTime?>(messageTextUpdatedAt),
      'userId': serializer.toJson<String?>(userId),
      'pinned': serializer.toJson<bool>(pinned),
      'pinnedAt': serializer.toJson<DateTime?>(pinnedAt),
      'pinExpires': serializer.toJson<DateTime?>(pinExpires),
      'pinnedByUserId': serializer.toJson<String?>(pinnedByUserId),
      'channelCid': serializer.toJson<String>(channelCid),
      'i18n': serializer.toJson<Map<String, String>?>(i18n),
      'restrictedVisibility':
          serializer.toJson<List<String>?>(restrictedVisibility),
      'extraData': serializer.toJson<Map<String, dynamic>?>(extraData),
    };
  }

  MessageEntity copyWith(
          {String? id,
          Value<String?> messageText = const Value.absent(),
          List<String>? attachments,
          String? state,
          String? type,
          List<String>? mentionedUsers,
          Value<Map<String, int>?> reactionCounts = const Value.absent(),
          Value<Map<String, int>?> reactionScores = const Value.absent(),
          Value<String?> parentId = const Value.absent(),
          Value<String?> quotedMessageId = const Value.absent(),
          Value<String?> pollId = const Value.absent(),
          Value<int?> replyCount = const Value.absent(),
          Value<bool?> showInChannel = const Value.absent(),
          bool? shadowed,
          Value<String?> command = const Value.absent(),
          Value<DateTime?> localCreatedAt = const Value.absent(),
          Value<DateTime?> remoteCreatedAt = const Value.absent(),
          Value<DateTime?> localUpdatedAt = const Value.absent(),
          Value<DateTime?> remoteUpdatedAt = const Value.absent(),
          Value<DateTime?> localDeletedAt = const Value.absent(),
          Value<DateTime?> remoteDeletedAt = const Value.absent(),
          Value<DateTime?> messageTextUpdatedAt = const Value.absent(),
          Value<String?> userId = const Value.absent(),
          bool? pinned,
          Value<DateTime?> pinnedAt = const Value.absent(),
          Value<DateTime?> pinExpires = const Value.absent(),
          Value<String?> pinnedByUserId = const Value.absent(),
          String? channelCid,
          Value<Map<String, String>?> i18n = const Value.absent(),
          Value<List<String>?> restrictedVisibility = const Value.absent(),
          Value<Map<String, dynamic>?> extraData = const Value.absent()}) =>
      MessageEntity(
        id: id ?? this.id,
        messageText: messageText.present ? messageText.value : this.messageText,
        attachments: attachments ?? this.attachments,
        state: state ?? this.state,
        type: type ?? this.type,
        mentionedUsers: mentionedUsers ?? this.mentionedUsers,
        reactionCounts:
            reactionCounts.present ? reactionCounts.value : this.reactionCounts,
        reactionScores:
            reactionScores.present ? reactionScores.value : this.reactionScores,
        parentId: parentId.present ? parentId.value : this.parentId,
        quotedMessageId: quotedMessageId.present
            ? quotedMessageId.value
            : this.quotedMessageId,
        pollId: pollId.present ? pollId.value : this.pollId,
        replyCount: replyCount.present ? replyCount.value : this.replyCount,
        showInChannel:
            showInChannel.present ? showInChannel.value : this.showInChannel,
        shadowed: shadowed ?? this.shadowed,
        command: command.present ? command.value : this.command,
        localCreatedAt:
            localCreatedAt.present ? localCreatedAt.value : this.localCreatedAt,
        remoteCreatedAt: remoteCreatedAt.present
            ? remoteCreatedAt.value
            : this.remoteCreatedAt,
        localUpdatedAt:
            localUpdatedAt.present ? localUpdatedAt.value : this.localUpdatedAt,
        remoteUpdatedAt: remoteUpdatedAt.present
            ? remoteUpdatedAt.value
            : this.remoteUpdatedAt,
        localDeletedAt:
            localDeletedAt.present ? localDeletedAt.value : this.localDeletedAt,
        remoteDeletedAt: remoteDeletedAt.present
            ? remoteDeletedAt.value
            : this.remoteDeletedAt,
        messageTextUpdatedAt: messageTextUpdatedAt.present
            ? messageTextUpdatedAt.value
            : this.messageTextUpdatedAt,
        userId: userId.present ? userId.value : this.userId,
        pinned: pinned ?? this.pinned,
        pinnedAt: pinnedAt.present ? pinnedAt.value : this.pinnedAt,
        pinExpires: pinExpires.present ? pinExpires.value : this.pinExpires,
        pinnedByUserId:
            pinnedByUserId.present ? pinnedByUserId.value : this.pinnedByUserId,
        channelCid: channelCid ?? this.channelCid,
        i18n: i18n.present ? i18n.value : this.i18n,
        restrictedVisibility: restrictedVisibility.present
            ? restrictedVisibility.value
            : this.restrictedVisibility,
        extraData: extraData.present ? extraData.value : this.extraData,
      );
  MessageEntity copyWithCompanion(MessagesCompanion data) {
    return MessageEntity(
      id: data.id.present ? data.id.value : this.id,
      messageText:
          data.messageText.present ? data.messageText.value : this.messageText,
      attachments:
          data.attachments.present ? data.attachments.value : this.attachments,
      state: data.state.present ? data.state.value : this.state,
      type: data.type.present ? data.type.value : this.type,
      mentionedUsers: data.mentionedUsers.present
          ? data.mentionedUsers.value
          : this.mentionedUsers,
      reactionCounts: data.reactionCounts.present
          ? data.reactionCounts.value
          : this.reactionCounts,
      reactionScores: data.reactionScores.present
          ? data.reactionScores.value
          : this.reactionScores,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      quotedMessageId: data.quotedMessageId.present
          ? data.quotedMessageId.value
          : this.quotedMessageId,
      pollId: data.pollId.present ? data.pollId.value : this.pollId,
      replyCount:
          data.replyCount.present ? data.replyCount.value : this.replyCount,
      showInChannel: data.showInChannel.present
          ? data.showInChannel.value
          : this.showInChannel,
      shadowed: data.shadowed.present ? data.shadowed.value : this.shadowed,
      command: data.command.present ? data.command.value : this.command,
      localCreatedAt: data.localCreatedAt.present
          ? data.localCreatedAt.value
          : this.localCreatedAt,
      remoteCreatedAt: data.remoteCreatedAt.present
          ? data.remoteCreatedAt.value
          : this.remoteCreatedAt,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
      remoteUpdatedAt: data.remoteUpdatedAt.present
          ? data.remoteUpdatedAt.value
          : this.remoteUpdatedAt,
      localDeletedAt: data.localDeletedAt.present
          ? data.localDeletedAt.value
          : this.localDeletedAt,
      remoteDeletedAt: data.remoteDeletedAt.present
          ? data.remoteDeletedAt.value
          : this.remoteDeletedAt,
      messageTextUpdatedAt: data.messageTextUpdatedAt.present
          ? data.messageTextUpdatedAt.value
          : this.messageTextUpdatedAt,
      userId: data.userId.present ? data.userId.value : this.userId,
      pinned: data.pinned.present ? data.pinned.value : this.pinned,
      pinnedAt: data.pinnedAt.present ? data.pinnedAt.value : this.pinnedAt,
      pinExpires:
          data.pinExpires.present ? data.pinExpires.value : this.pinExpires,
      pinnedByUserId: data.pinnedByUserId.present
          ? data.pinnedByUserId.value
          : this.pinnedByUserId,
      channelCid:
          data.channelCid.present ? data.channelCid.value : this.channelCid,
      i18n: data.i18n.present ? data.i18n.value : this.i18n,
      restrictedVisibility: data.restrictedVisibility.present
          ? data.restrictedVisibility.value
          : this.restrictedVisibility,
      extraData: data.extraData.present ? data.extraData.value : this.extraData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageEntity(')
          ..write('id: $id, ')
          ..write('messageText: $messageText, ')
          ..write('attachments: $attachments, ')
          ..write('state: $state, ')
          ..write('type: $type, ')
          ..write('mentionedUsers: $mentionedUsers, ')
          ..write('reactionCounts: $reactionCounts, ')
          ..write('reactionScores: $reactionScores, ')
          ..write('parentId: $parentId, ')
          ..write('quotedMessageId: $quotedMessageId, ')
          ..write('pollId: $pollId, ')
          ..write('replyCount: $replyCount, ')
          ..write('showInChannel: $showInChannel, ')
          ..write('shadowed: $shadowed, ')
          ..write('command: $command, ')
          ..write('localCreatedAt: $localCreatedAt, ')
          ..write('remoteCreatedAt: $remoteCreatedAt, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('localDeletedAt: $localDeletedAt, ')
          ..write('remoteDeletedAt: $remoteDeletedAt, ')
          ..write('messageTextUpdatedAt: $messageTextUpdatedAt, ')
          ..write('userId: $userId, ')
          ..write('pinned: $pinned, ')
          ..write('pinnedAt: $pinnedAt, ')
          ..write('pinExpires: $pinExpires, ')
          ..write('pinnedByUserId: $pinnedByUserId, ')
          ..write('channelCid: $channelCid, ')
          ..write('i18n: $i18n, ')
          ..write('restrictedVisibility: $restrictedVisibility, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        messageText,
        attachments,
        state,
        type,
        mentionedUsers,
        reactionCounts,
        reactionScores,
        parentId,
        quotedMessageId,
        pollId,
        replyCount,
        showInChannel,
        shadowed,
        command,
        localCreatedAt,
        remoteCreatedAt,
        localUpdatedAt,
        remoteUpdatedAt,
        localDeletedAt,
        remoteDeletedAt,
        messageTextUpdatedAt,
        userId,
        pinned,
        pinnedAt,
        pinExpires,
        pinnedByUserId,
        channelCid,
        i18n,
        restrictedVisibility,
        extraData
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageEntity &&
          other.id == this.id &&
          other.messageText == this.messageText &&
          other.attachments == this.attachments &&
          other.state == this.state &&
          other.type == this.type &&
          other.mentionedUsers == this.mentionedUsers &&
          other.reactionCounts == this.reactionCounts &&
          other.reactionScores == this.reactionScores &&
          other.parentId == this.parentId &&
          other.quotedMessageId == this.quotedMessageId &&
          other.pollId == this.pollId &&
          other.replyCount == this.replyCount &&
          other.showInChannel == this.showInChannel &&
          other.shadowed == this.shadowed &&
          other.command == this.command &&
          other.localCreatedAt == this.localCreatedAt &&
          other.remoteCreatedAt == this.remoteCreatedAt &&
          other.localUpdatedAt == this.localUpdatedAt &&
          other.remoteUpdatedAt == this.remoteUpdatedAt &&
          other.localDeletedAt == this.localDeletedAt &&
          other.remoteDeletedAt == this.remoteDeletedAt &&
          other.messageTextUpdatedAt == this.messageTextUpdatedAt &&
          other.userId == this.userId &&
          other.pinned == this.pinned &&
          other.pinnedAt == this.pinnedAt &&
          other.pinExpires == this.pinExpires &&
          other.pinnedByUserId == this.pinnedByUserId &&
          other.channelCid == this.channelCid &&
          other.i18n == this.i18n &&
          other.restrictedVisibility == this.restrictedVisibility &&
          other.extraData == this.extraData);
}

class MessagesCompanion extends UpdateCompanion<MessageEntity> {
  final Value<String> id;
  final Value<String?> messageText;
  final Value<List<String>> attachments;
  final Value<String> state;
  final Value<String> type;
  final Value<List<String>> mentionedUsers;
  final Value<Map<String, int>?> reactionCounts;
  final Value<Map<String, int>?> reactionScores;
  final Value<String?> parentId;
  final Value<String?> quotedMessageId;
  final Value<String?> pollId;
  final Value<int?> replyCount;
  final Value<bool?> showInChannel;
  final Value<bool> shadowed;
  final Value<String?> command;
  final Value<DateTime?> localCreatedAt;
  final Value<DateTime?> remoteCreatedAt;
  final Value<DateTime?> localUpdatedAt;
  final Value<DateTime?> remoteUpdatedAt;
  final Value<DateTime?> localDeletedAt;
  final Value<DateTime?> remoteDeletedAt;
  final Value<DateTime?> messageTextUpdatedAt;
  final Value<String?> userId;
  final Value<bool> pinned;
  final Value<DateTime?> pinnedAt;
  final Value<DateTime?> pinExpires;
  final Value<String?> pinnedByUserId;
  final Value<String> channelCid;
  final Value<Map<String, String>?> i18n;
  final Value<List<String>?> restrictedVisibility;
  final Value<Map<String, dynamic>?> extraData;
  final Value<int> rowid;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.messageText = const Value.absent(),
    this.attachments = const Value.absent(),
    this.state = const Value.absent(),
    this.type = const Value.absent(),
    this.mentionedUsers = const Value.absent(),
    this.reactionCounts = const Value.absent(),
    this.reactionScores = const Value.absent(),
    this.parentId = const Value.absent(),
    this.quotedMessageId = const Value.absent(),
    this.pollId = const Value.absent(),
    this.replyCount = const Value.absent(),
    this.showInChannel = const Value.absent(),
    this.shadowed = const Value.absent(),
    this.command = const Value.absent(),
    this.localCreatedAt = const Value.absent(),
    this.remoteCreatedAt = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.localDeletedAt = const Value.absent(),
    this.remoteDeletedAt = const Value.absent(),
    this.messageTextUpdatedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.pinned = const Value.absent(),
    this.pinnedAt = const Value.absent(),
    this.pinExpires = const Value.absent(),
    this.pinnedByUserId = const Value.absent(),
    this.channelCid = const Value.absent(),
    this.i18n = const Value.absent(),
    this.restrictedVisibility = const Value.absent(),
    this.extraData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesCompanion.insert({
    required String id,
    this.messageText = const Value.absent(),
    required List<String> attachments,
    required String state,
    this.type = const Value.absent(),
    required List<String> mentionedUsers,
    this.reactionCounts = const Value.absent(),
    this.reactionScores = const Value.absent(),
    this.parentId = const Value.absent(),
    this.quotedMessageId = const Value.absent(),
    this.pollId = const Value.absent(),
    this.replyCount = const Value.absent(),
    this.showInChannel = const Value.absent(),
    this.shadowed = const Value.absent(),
    this.command = const Value.absent(),
    this.localCreatedAt = const Value.absent(),
    this.remoteCreatedAt = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.localDeletedAt = const Value.absent(),
    this.remoteDeletedAt = const Value.absent(),
    this.messageTextUpdatedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.pinned = const Value.absent(),
    this.pinnedAt = const Value.absent(),
    this.pinExpires = const Value.absent(),
    this.pinnedByUserId = const Value.absent(),
    required String channelCid,
    this.i18n = const Value.absent(),
    this.restrictedVisibility = const Value.absent(),
    this.extraData = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        attachments = Value(attachments),
        state = Value(state),
        mentionedUsers = Value(mentionedUsers),
        channelCid = Value(channelCid);
  static Insertable<MessageEntity> custom({
    Expression<String>? id,
    Expression<String>? messageText,
    Expression<String>? attachments,
    Expression<String>? state,
    Expression<String>? type,
    Expression<String>? mentionedUsers,
    Expression<String>? reactionCounts,
    Expression<String>? reactionScores,
    Expression<String>? parentId,
    Expression<String>? quotedMessageId,
    Expression<String>? pollId,
    Expression<int>? replyCount,
    Expression<bool>? showInChannel,
    Expression<bool>? shadowed,
    Expression<String>? command,
    Expression<DateTime>? localCreatedAt,
    Expression<DateTime>? remoteCreatedAt,
    Expression<DateTime>? localUpdatedAt,
    Expression<DateTime>? remoteUpdatedAt,
    Expression<DateTime>? localDeletedAt,
    Expression<DateTime>? remoteDeletedAt,
    Expression<DateTime>? messageTextUpdatedAt,
    Expression<String>? userId,
    Expression<bool>? pinned,
    Expression<DateTime>? pinnedAt,
    Expression<DateTime>? pinExpires,
    Expression<String>? pinnedByUserId,
    Expression<String>? channelCid,
    Expression<String>? i18n,
    Expression<String>? restrictedVisibility,
    Expression<String>? extraData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageText != null) 'message_text': messageText,
      if (attachments != null) 'attachments': attachments,
      if (state != null) 'state': state,
      if (type != null) 'type': type,
      if (mentionedUsers != null) 'mentioned_users': mentionedUsers,
      if (reactionCounts != null) 'reaction_counts': reactionCounts,
      if (reactionScores != null) 'reaction_scores': reactionScores,
      if (parentId != null) 'parent_id': parentId,
      if (quotedMessageId != null) 'quoted_message_id': quotedMessageId,
      if (pollId != null) 'poll_id': pollId,
      if (replyCount != null) 'reply_count': replyCount,
      if (showInChannel != null) 'show_in_channel': showInChannel,
      if (shadowed != null) 'shadowed': shadowed,
      if (command != null) 'command': command,
      if (localCreatedAt != null) 'local_created_at': localCreatedAt,
      if (remoteCreatedAt != null) 'remote_created_at': remoteCreatedAt,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (remoteUpdatedAt != null) 'remote_updated_at': remoteUpdatedAt,
      if (localDeletedAt != null) 'local_deleted_at': localDeletedAt,
      if (remoteDeletedAt != null) 'remote_deleted_at': remoteDeletedAt,
      if (messageTextUpdatedAt != null)
        'message_text_updated_at': messageTextUpdatedAt,
      if (userId != null) 'user_id': userId,
      if (pinned != null) 'pinned': pinned,
      if (pinnedAt != null) 'pinned_at': pinnedAt,
      if (pinExpires != null) 'pin_expires': pinExpires,
      if (pinnedByUserId != null) 'pinned_by_user_id': pinnedByUserId,
      if (channelCid != null) 'channel_cid': channelCid,
      if (i18n != null) 'i18n': i18n,
      if (restrictedVisibility != null)
        'restricted_visibility': restrictedVisibility,
      if (extraData != null) 'extra_data': extraData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesCompanion copyWith(
      {Value<String>? id,
      Value<String?>? messageText,
      Value<List<String>>? attachments,
      Value<String>? state,
      Value<String>? type,
      Value<List<String>>? mentionedUsers,
      Value<Map<String, int>?>? reactionCounts,
      Value<Map<String, int>?>? reactionScores,
      Value<String?>? parentId,
      Value<String?>? quotedMessageId,
      Value<String?>? pollId,
      Value<int?>? replyCount,
      Value<bool?>? showInChannel,
      Value<bool>? shadowed,
      Value<String?>? command,
      Value<DateTime?>? localCreatedAt,
      Value<DateTime?>? remoteCreatedAt,
      Value<DateTime?>? localUpdatedAt,
      Value<DateTime?>? remoteUpdatedAt,
      Value<DateTime?>? localDeletedAt,
      Value<DateTime?>? remoteDeletedAt,
      Value<DateTime?>? messageTextUpdatedAt,
      Value<String?>? userId,
      Value<bool>? pinned,
      Value<DateTime?>? pinnedAt,
      Value<DateTime?>? pinExpires,
      Value<String?>? pinnedByUserId,
      Value<String>? channelCid,
      Value<Map<String, String>?>? i18n,
      Value<List<String>?>? restrictedVisibility,
      Value<Map<String, dynamic>?>? extraData,
      Value<int>? rowid}) {
    return MessagesCompanion(
      id: id ?? this.id,
      messageText: messageText ?? this.messageText,
      attachments: attachments ?? this.attachments,
      state: state ?? this.state,
      type: type ?? this.type,
      mentionedUsers: mentionedUsers ?? this.mentionedUsers,
      reactionCounts: reactionCounts ?? this.reactionCounts,
      reactionScores: reactionScores ?? this.reactionScores,
      parentId: parentId ?? this.parentId,
      quotedMessageId: quotedMessageId ?? this.quotedMessageId,
      pollId: pollId ?? this.pollId,
      replyCount: replyCount ?? this.replyCount,
      showInChannel: showInChannel ?? this.showInChannel,
      shadowed: shadowed ?? this.shadowed,
      command: command ?? this.command,
      localCreatedAt: localCreatedAt ?? this.localCreatedAt,
      remoteCreatedAt: remoteCreatedAt ?? this.remoteCreatedAt,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
      localDeletedAt: localDeletedAt ?? this.localDeletedAt,
      remoteDeletedAt: remoteDeletedAt ?? this.remoteDeletedAt,
      messageTextUpdatedAt: messageTextUpdatedAt ?? this.messageTextUpdatedAt,
      userId: userId ?? this.userId,
      pinned: pinned ?? this.pinned,
      pinnedAt: pinnedAt ?? this.pinnedAt,
      pinExpires: pinExpires ?? this.pinExpires,
      pinnedByUserId: pinnedByUserId ?? this.pinnedByUserId,
      channelCid: channelCid ?? this.channelCid,
      i18n: i18n ?? this.i18n,
      restrictedVisibility: restrictedVisibility ?? this.restrictedVisibility,
      extraData: extraData ?? this.extraData,
      rowid: rowid ?? this.rowid,
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
    if (attachments.present) {
      map['attachments'] = Variable<String>(
          $MessagesTable.$converterattachments.toSql(attachments.value));
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (mentionedUsers.present) {
      map['mentioned_users'] = Variable<String>(
          $MessagesTable.$convertermentionedUsers.toSql(mentionedUsers.value));
    }
    if (reactionCounts.present) {
      map['reaction_counts'] = Variable<String>(
          $MessagesTable.$converterreactionCountsn.toSql(reactionCounts.value));
    }
    if (reactionScores.present) {
      map['reaction_scores'] = Variable<String>(
          $MessagesTable.$converterreactionScoresn.toSql(reactionScores.value));
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (quotedMessageId.present) {
      map['quoted_message_id'] = Variable<String>(quotedMessageId.value);
    }
    if (pollId.present) {
      map['poll_id'] = Variable<String>(pollId.value);
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
    if (localCreatedAt.present) {
      map['local_created_at'] = Variable<DateTime>(localCreatedAt.value);
    }
    if (remoteCreatedAt.present) {
      map['remote_created_at'] = Variable<DateTime>(remoteCreatedAt.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (remoteUpdatedAt.present) {
      map['remote_updated_at'] = Variable<DateTime>(remoteUpdatedAt.value);
    }
    if (localDeletedAt.present) {
      map['local_deleted_at'] = Variable<DateTime>(localDeletedAt.value);
    }
    if (remoteDeletedAt.present) {
      map['remote_deleted_at'] = Variable<DateTime>(remoteDeletedAt.value);
    }
    if (messageTextUpdatedAt.present) {
      map['message_text_updated_at'] =
          Variable<DateTime>(messageTextUpdatedAt.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (pinned.present) {
      map['pinned'] = Variable<bool>(pinned.value);
    }
    if (pinnedAt.present) {
      map['pinned_at'] = Variable<DateTime>(pinnedAt.value);
    }
    if (pinExpires.present) {
      map['pin_expires'] = Variable<DateTime>(pinExpires.value);
    }
    if (pinnedByUserId.present) {
      map['pinned_by_user_id'] = Variable<String>(pinnedByUserId.value);
    }
    if (channelCid.present) {
      map['channel_cid'] = Variable<String>(channelCid.value);
    }
    if (i18n.present) {
      map['i18n'] =
          Variable<String>($MessagesTable.$converteri18n.toSql(i18n.value));
    }
    if (restrictedVisibility.present) {
      map['restricted_visibility'] = Variable<String>($MessagesTable
          .$converterrestrictedVisibilityn
          .toSql(restrictedVisibility.value));
    }
    if (extraData.present) {
      map['extra_data'] = Variable<String>(
          $MessagesTable.$converterextraDatan.toSql(extraData.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('messageText: $messageText, ')
          ..write('attachments: $attachments, ')
          ..write('state: $state, ')
          ..write('type: $type, ')
          ..write('mentionedUsers: $mentionedUsers, ')
          ..write('reactionCounts: $reactionCounts, ')
          ..write('reactionScores: $reactionScores, ')
          ..write('parentId: $parentId, ')
          ..write('quotedMessageId: $quotedMessageId, ')
          ..write('pollId: $pollId, ')
          ..write('replyCount: $replyCount, ')
          ..write('showInChannel: $showInChannel, ')
          ..write('shadowed: $shadowed, ')
          ..write('command: $command, ')
          ..write('localCreatedAt: $localCreatedAt, ')
          ..write('remoteCreatedAt: $remoteCreatedAt, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('localDeletedAt: $localDeletedAt, ')
          ..write('remoteDeletedAt: $remoteDeletedAt, ')
          ..write('messageTextUpdatedAt: $messageTextUpdatedAt, ')
          ..write('userId: $userId, ')
          ..write('pinned: $pinned, ')
          ..write('pinnedAt: $pinnedAt, ')
          ..write('pinExpires: $pinExpires, ')
          ..write('pinnedByUserId: $pinnedByUserId, ')
          ..write('channelCid: $channelCid, ')
          ..write('i18n: $i18n, ')
          ..write('restrictedVisibility: $restrictedVisibility, ')
          ..write('extraData: $extraData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PinnedMessagesTable extends PinnedMessages
    with TableInfo<$PinnedMessagesTable, PinnedMessageEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PinnedMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageTextMeta =
      const VerificationMeta('messageText');
  @override
  late final GeneratedColumn<String> messageText = GeneratedColumn<String>(
      'message_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _attachmentsMeta =
      const VerificationMeta('attachments');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
      attachments = GeneratedColumn<String>('attachments', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>(
              $PinnedMessagesTable.$converterattachments);
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
      'state', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('regular'));
  static const VerificationMeta _mentionedUsersMeta =
      const VerificationMeta('mentionedUsers');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
      mentionedUsers = GeneratedColumn<String>(
              'mentioned_users', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>(
              $PinnedMessagesTable.$convertermentionedUsers);
  static const VerificationMeta _reactionCountsMeta =
      const VerificationMeta('reactionCounts');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, int>?, String>
      reactionCounts = GeneratedColumn<String>(
              'reaction_counts', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, int>?>(
              $PinnedMessagesTable.$converterreactionCountsn);
  static const VerificationMeta _reactionScoresMeta =
      const VerificationMeta('reactionScores');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, int>?, String>
      reactionScores = GeneratedColumn<String>(
              'reaction_scores', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, int>?>(
              $PinnedMessagesTable.$converterreactionScoresn);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quotedMessageIdMeta =
      const VerificationMeta('quotedMessageId');
  @override
  late final GeneratedColumn<String> quotedMessageId = GeneratedColumn<String>(
      'quoted_message_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pollIdMeta = const VerificationMeta('pollId');
  @override
  late final GeneratedColumn<String> pollId = GeneratedColumn<String>(
      'poll_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _replyCountMeta =
      const VerificationMeta('replyCount');
  @override
  late final GeneratedColumn<int> replyCount = GeneratedColumn<int>(
      'reply_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _showInChannelMeta =
      const VerificationMeta('showInChannel');
  @override
  late final GeneratedColumn<bool> showInChannel = GeneratedColumn<bool>(
      'show_in_channel', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_in_channel" IN (0, 1))'));
  static const VerificationMeta _shadowedMeta =
      const VerificationMeta('shadowed');
  @override
  late final GeneratedColumn<bool> shadowed = GeneratedColumn<bool>(
      'shadowed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("shadowed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _commandMeta =
      const VerificationMeta('command');
  @override
  late final GeneratedColumn<String> command = GeneratedColumn<String>(
      'command', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _localCreatedAtMeta =
      const VerificationMeta('localCreatedAt');
  @override
  late final GeneratedColumn<DateTime> localCreatedAt =
      GeneratedColumn<DateTime>('local_created_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _remoteCreatedAtMeta =
      const VerificationMeta('remoteCreatedAt');
  @override
  late final GeneratedColumn<DateTime> remoteCreatedAt =
      GeneratedColumn<DateTime>('remote_created_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _remoteUpdatedAtMeta =
      const VerificationMeta('remoteUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> remoteUpdatedAt =
      GeneratedColumn<DateTime>('remote_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _localDeletedAtMeta =
      const VerificationMeta('localDeletedAt');
  @override
  late final GeneratedColumn<DateTime> localDeletedAt =
      GeneratedColumn<DateTime>('local_deleted_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _remoteDeletedAtMeta =
      const VerificationMeta('remoteDeletedAt');
  @override
  late final GeneratedColumn<DateTime> remoteDeletedAt =
      GeneratedColumn<DateTime>('remote_deleted_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _messageTextUpdatedAtMeta =
      const VerificationMeta('messageTextUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> messageTextUpdatedAt =
      GeneratedColumn<DateTime>('message_text_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pinnedMeta = const VerificationMeta('pinned');
  @override
  late final GeneratedColumn<bool> pinned = GeneratedColumn<bool>(
      'pinned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("pinned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _pinnedAtMeta =
      const VerificationMeta('pinnedAt');
  @override
  late final GeneratedColumn<DateTime> pinnedAt = GeneratedColumn<DateTime>(
      'pinned_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _pinExpiresMeta =
      const VerificationMeta('pinExpires');
  @override
  late final GeneratedColumn<DateTime> pinExpires = GeneratedColumn<DateTime>(
      'pin_expires', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _pinnedByUserIdMeta =
      const VerificationMeta('pinnedByUserId');
  @override
  late final GeneratedColumn<String> pinnedByUserId = GeneratedColumn<String>(
      'pinned_by_user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _channelCidMeta =
      const VerificationMeta('channelCid');
  @override
  late final GeneratedColumn<String> channelCid = GeneratedColumn<String>(
      'channel_cid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _i18nMeta = const VerificationMeta('i18n');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>?, String>
      i18n = GeneratedColumn<String>('i18n', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, String>?>(
              $PinnedMessagesTable.$converteri18n);
  static const VerificationMeta _restrictedVisibilityMeta =
      const VerificationMeta('restrictedVisibility');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String>
      restrictedVisibility = GeneratedColumn<String>(
              'restricted_visibility', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<List<String>?>(
              $PinnedMessagesTable.$converterrestrictedVisibilityn);
  static const VerificationMeta _extraDataMeta =
      const VerificationMeta('extraData');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      extraData = GeneratedColumn<String>('extra_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, dynamic>?>(
              $PinnedMessagesTable.$converterextraDatan);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        messageText,
        attachments,
        state,
        type,
        mentionedUsers,
        reactionCounts,
        reactionScores,
        parentId,
        quotedMessageId,
        pollId,
        replyCount,
        showInChannel,
        shadowed,
        command,
        localCreatedAt,
        remoteCreatedAt,
        localUpdatedAt,
        remoteUpdatedAt,
        localDeletedAt,
        remoteDeletedAt,
        messageTextUpdatedAt,
        userId,
        pinned,
        pinnedAt,
        pinExpires,
        pinnedByUserId,
        channelCid,
        i18n,
        restrictedVisibility,
        extraData
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pinned_messages';
  @override
  VerificationContext validateIntegrity(
      Insertable<PinnedMessageEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('message_text')) {
      context.handle(
          _messageTextMeta,
          messageText.isAcceptableOrUnknown(
              data['message_text']!, _messageTextMeta));
    }
    context.handle(_attachmentsMeta, const VerificationResult.success());
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    context.handle(_mentionedUsersMeta, const VerificationResult.success());
    context.handle(_reactionCountsMeta, const VerificationResult.success());
    context.handle(_reactionScoresMeta, const VerificationResult.success());
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('quoted_message_id')) {
      context.handle(
          _quotedMessageIdMeta,
          quotedMessageId.isAcceptableOrUnknown(
              data['quoted_message_id']!, _quotedMessageIdMeta));
    }
    if (data.containsKey('poll_id')) {
      context.handle(_pollIdMeta,
          pollId.isAcceptableOrUnknown(data['poll_id']!, _pollIdMeta));
    }
    if (data.containsKey('reply_count')) {
      context.handle(
          _replyCountMeta,
          replyCount.isAcceptableOrUnknown(
              data['reply_count']!, _replyCountMeta));
    }
    if (data.containsKey('show_in_channel')) {
      context.handle(
          _showInChannelMeta,
          showInChannel.isAcceptableOrUnknown(
              data['show_in_channel']!, _showInChannelMeta));
    }
    if (data.containsKey('shadowed')) {
      context.handle(_shadowedMeta,
          shadowed.isAcceptableOrUnknown(data['shadowed']!, _shadowedMeta));
    }
    if (data.containsKey('command')) {
      context.handle(_commandMeta,
          command.isAcceptableOrUnknown(data['command']!, _commandMeta));
    }
    if (data.containsKey('local_created_at')) {
      context.handle(
          _localCreatedAtMeta,
          localCreatedAt.isAcceptableOrUnknown(
              data['local_created_at']!, _localCreatedAtMeta));
    }
    if (data.containsKey('remote_created_at')) {
      context.handle(
          _remoteCreatedAtMeta,
          remoteCreatedAt.isAcceptableOrUnknown(
              data['remote_created_at']!, _remoteCreatedAtMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    if (data.containsKey('remote_updated_at')) {
      context.handle(
          _remoteUpdatedAtMeta,
          remoteUpdatedAt.isAcceptableOrUnknown(
              data['remote_updated_at']!, _remoteUpdatedAtMeta));
    }
    if (data.containsKey('local_deleted_at')) {
      context.handle(
          _localDeletedAtMeta,
          localDeletedAt.isAcceptableOrUnknown(
              data['local_deleted_at']!, _localDeletedAtMeta));
    }
    if (data.containsKey('remote_deleted_at')) {
      context.handle(
          _remoteDeletedAtMeta,
          remoteDeletedAt.isAcceptableOrUnknown(
              data['remote_deleted_at']!, _remoteDeletedAtMeta));
    }
    if (data.containsKey('message_text_updated_at')) {
      context.handle(
          _messageTextUpdatedAtMeta,
          messageTextUpdatedAt.isAcceptableOrUnknown(
              data['message_text_updated_at']!, _messageTextUpdatedAtMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('pinned')) {
      context.handle(_pinnedMeta,
          pinned.isAcceptableOrUnknown(data['pinned']!, _pinnedMeta));
    }
    if (data.containsKey('pinned_at')) {
      context.handle(_pinnedAtMeta,
          pinnedAt.isAcceptableOrUnknown(data['pinned_at']!, _pinnedAtMeta));
    }
    if (data.containsKey('pin_expires')) {
      context.handle(
          _pinExpiresMeta,
          pinExpires.isAcceptableOrUnknown(
              data['pin_expires']!, _pinExpiresMeta));
    }
    if (data.containsKey('pinned_by_user_id')) {
      context.handle(
          _pinnedByUserIdMeta,
          pinnedByUserId.isAcceptableOrUnknown(
              data['pinned_by_user_id']!, _pinnedByUserIdMeta));
    }
    if (data.containsKey('channel_cid')) {
      context.handle(
          _channelCidMeta,
          channelCid.isAcceptableOrUnknown(
              data['channel_cid']!, _channelCidMeta));
    } else if (isInserting) {
      context.missing(_channelCidMeta);
    }
    context.handle(_i18nMeta, const VerificationResult.success());
    context.handle(
        _restrictedVisibilityMeta, const VerificationResult.success());
    context.handle(_extraDataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PinnedMessageEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PinnedMessageEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      messageText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_text']),
      attachments: $PinnedMessagesTable.$converterattachments.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}attachments'])!),
      state: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}state'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      mentionedUsers: $PinnedMessagesTable.$convertermentionedUsers.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}mentioned_users'])!),
      reactionCounts: $PinnedMessagesTable.$converterreactionCountsn.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}reaction_counts'])),
      reactionScores: $PinnedMessagesTable.$converterreactionScoresn.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}reaction_scores'])),
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
      quotedMessageId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}quoted_message_id']),
      pollId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}poll_id']),
      replyCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reply_count']),
      showInChannel: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_in_channel']),
      shadowed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}shadowed'])!,
      command: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}command']),
      localCreatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_created_at']),
      remoteCreatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}remote_created_at']),
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at']),
      remoteUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}remote_updated_at']),
      localDeletedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_deleted_at']),
      remoteDeletedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}remote_deleted_at']),
      messageTextUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}message_text_updated_at']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      pinned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pinned'])!,
      pinnedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}pinned_at']),
      pinExpires: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}pin_expires']),
      pinnedByUserId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}pinned_by_user_id']),
      channelCid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}channel_cid'])!,
      i18n: $PinnedMessagesTable.$converteri18n.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}i18n'])),
      restrictedVisibility: $PinnedMessagesTable.$converterrestrictedVisibilityn
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}restricted_visibility'])),
      extraData: $PinnedMessagesTable.$converterextraDatan.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}extra_data'])),
    );
  }

  @override
  $PinnedMessagesTable createAlias(String alias) {
    return $PinnedMessagesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterattachments =
      ListConverter<String>();
  static TypeConverter<List<String>, String> $convertermentionedUsers =
      ListConverter<String>();
  static TypeConverter<Map<String, int>, String> $converterreactionCounts =
      MapConverter<int>();
  static TypeConverter<Map<String, int>?, String?> $converterreactionCountsn =
      NullAwareTypeConverter.wrap($converterreactionCounts);
  static TypeConverter<Map<String, int>, String> $converterreactionScores =
      MapConverter<int>();
  static TypeConverter<Map<String, int>?, String?> $converterreactionScoresn =
      NullAwareTypeConverter.wrap($converterreactionScores);
  static TypeConverter<Map<String, String>?, String?> $converteri18n =
      NullableMapConverter<String>();
  static TypeConverter<List<String>, String> $converterrestrictedVisibility =
      ListConverter<String>();
  static TypeConverter<List<String>?, String?> $converterrestrictedVisibilityn =
      NullAwareTypeConverter.wrap($converterrestrictedVisibility);
  static TypeConverter<Map<String, dynamic>, String> $converterextraData =
      MapConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $converterextraDatan =
      NullAwareTypeConverter.wrap($converterextraData);
}

class PinnedMessageEntity extends DataClass
    implements Insertable<PinnedMessageEntity> {
  /// The message id
  final String id;

  /// The text of this message
  final String? messageText;

  /// The list of attachments, either provided by the user
  /// or generated from a command or as a result of URL scraping.
  final List<String> attachments;

  /// The current state of the message.
  final String state;

  /// The message type
  final String type;

  /// The list of user mentioned in the message
  final List<String> mentionedUsers;

  /// A map describing the count of number of every reaction
  final Map<String, int>? reactionCounts;

  /// A map describing the count of score of every reaction
  final Map<String, int>? reactionScores;

  /// The ID of the parent message, if the message is a thread reply.
  final String? parentId;

  /// The ID of the quoted message, if the message is a quoted reply.
  final String? quotedMessageId;

  /// The ID of the poll, if the message is a poll.
  final String? pollId;

  /// Number of replies for this message.
  final int? replyCount;

  /// Check if this message needs to show in the channel.
  final bool? showInChannel;

  /// If true the message is shadowed
  final bool shadowed;

  /// A used command name.
  final String? command;

  /// The DateTime on which the message was created on the client.
  final DateTime? localCreatedAt;

  /// The DateTime on which the message was created on the server.
  final DateTime? remoteCreatedAt;

  /// The DateTime on which the message was updated on the client.
  final DateTime? localUpdatedAt;

  /// The DateTime on which the message was updated on the server.
  final DateTime? remoteUpdatedAt;

  /// The DateTime on which the message was deleted on the client.
  final DateTime? localDeletedAt;

  /// The DateTime on which the message was deleted on the server.
  final DateTime? remoteDeletedAt;

  /// The DateTime at which the message text was edited
  final DateTime? messageTextUpdatedAt;

  /// Id of the User who sent the message
  final String? userId;

  /// Whether the message is pinned or not
  final bool pinned;

  /// The DateTime at which the message was pinned
  final DateTime? pinnedAt;

  /// The DateTime on which the message pin expires
  final DateTime? pinExpires;

  /// Id of the User who pinned the message
  final String? pinnedByUserId;

  /// The channel cid of which this message is part of
  final String channelCid;

  /// A Map of [messageText] translations.
  final Map<String, String>? i18n;

  /// The list of user ids that should be able to see the message.
  final List<String>? restrictedVisibility;

  /// Message custom extraData
  final Map<String, dynamic>? extraData;
  const PinnedMessageEntity(
      {required this.id,
      this.messageText,
      required this.attachments,
      required this.state,
      required this.type,
      required this.mentionedUsers,
      this.reactionCounts,
      this.reactionScores,
      this.parentId,
      this.quotedMessageId,
      this.pollId,
      this.replyCount,
      this.showInChannel,
      required this.shadowed,
      this.command,
      this.localCreatedAt,
      this.remoteCreatedAt,
      this.localUpdatedAt,
      this.remoteUpdatedAt,
      this.localDeletedAt,
      this.remoteDeletedAt,
      this.messageTextUpdatedAt,
      this.userId,
      required this.pinned,
      this.pinnedAt,
      this.pinExpires,
      this.pinnedByUserId,
      required this.channelCid,
      this.i18n,
      this.restrictedVisibility,
      this.extraData});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || messageText != null) {
      map['message_text'] = Variable<String>(messageText);
    }
    {
      map['attachments'] = Variable<String>(
          $PinnedMessagesTable.$converterattachments.toSql(attachments));
    }
    map['state'] = Variable<String>(state);
    map['type'] = Variable<String>(type);
    {
      map['mentioned_users'] = Variable<String>(
          $PinnedMessagesTable.$convertermentionedUsers.toSql(mentionedUsers));
    }
    if (!nullToAbsent || reactionCounts != null) {
      map['reaction_counts'] = Variable<String>(
          $PinnedMessagesTable.$converterreactionCountsn.toSql(reactionCounts));
    }
    if (!nullToAbsent || reactionScores != null) {
      map['reaction_scores'] = Variable<String>(
          $PinnedMessagesTable.$converterreactionScoresn.toSql(reactionScores));
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    if (!nullToAbsent || quotedMessageId != null) {
      map['quoted_message_id'] = Variable<String>(quotedMessageId);
    }
    if (!nullToAbsent || pollId != null) {
      map['poll_id'] = Variable<String>(pollId);
    }
    if (!nullToAbsent || replyCount != null) {
      map['reply_count'] = Variable<int>(replyCount);
    }
    if (!nullToAbsent || showInChannel != null) {
      map['show_in_channel'] = Variable<bool>(showInChannel);
    }
    map['shadowed'] = Variable<bool>(shadowed);
    if (!nullToAbsent || command != null) {
      map['command'] = Variable<String>(command);
    }
    if (!nullToAbsent || localCreatedAt != null) {
      map['local_created_at'] = Variable<DateTime>(localCreatedAt);
    }
    if (!nullToAbsent || remoteCreatedAt != null) {
      map['remote_created_at'] = Variable<DateTime>(remoteCreatedAt);
    }
    if (!nullToAbsent || localUpdatedAt != null) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    }
    if (!nullToAbsent || remoteUpdatedAt != null) {
      map['remote_updated_at'] = Variable<DateTime>(remoteUpdatedAt);
    }
    if (!nullToAbsent || localDeletedAt != null) {
      map['local_deleted_at'] = Variable<DateTime>(localDeletedAt);
    }
    if (!nullToAbsent || remoteDeletedAt != null) {
      map['remote_deleted_at'] = Variable<DateTime>(remoteDeletedAt);
    }
    if (!nullToAbsent || messageTextUpdatedAt != null) {
      map['message_text_updated_at'] = Variable<DateTime>(messageTextUpdatedAt);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['pinned'] = Variable<bool>(pinned);
    if (!nullToAbsent || pinnedAt != null) {
      map['pinned_at'] = Variable<DateTime>(pinnedAt);
    }
    if (!nullToAbsent || pinExpires != null) {
      map['pin_expires'] = Variable<DateTime>(pinExpires);
    }
    if (!nullToAbsent || pinnedByUserId != null) {
      map['pinned_by_user_id'] = Variable<String>(pinnedByUserId);
    }
    map['channel_cid'] = Variable<String>(channelCid);
    if (!nullToAbsent || i18n != null) {
      map['i18n'] =
          Variable<String>($PinnedMessagesTable.$converteri18n.toSql(i18n));
    }
    if (!nullToAbsent || restrictedVisibility != null) {
      map['restricted_visibility'] = Variable<String>($PinnedMessagesTable
          .$converterrestrictedVisibilityn
          .toSql(restrictedVisibility));
    }
    if (!nullToAbsent || extraData != null) {
      map['extra_data'] = Variable<String>(
          $PinnedMessagesTable.$converterextraDatan.toSql(extraData));
    }
    return map;
  }

  factory PinnedMessageEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PinnedMessageEntity(
      id: serializer.fromJson<String>(json['id']),
      messageText: serializer.fromJson<String?>(json['messageText']),
      attachments: serializer.fromJson<List<String>>(json['attachments']),
      state: serializer.fromJson<String>(json['state']),
      type: serializer.fromJson<String>(json['type']),
      mentionedUsers: serializer.fromJson<List<String>>(json['mentionedUsers']),
      reactionCounts:
          serializer.fromJson<Map<String, int>?>(json['reactionCounts']),
      reactionScores:
          serializer.fromJson<Map<String, int>?>(json['reactionScores']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      quotedMessageId: serializer.fromJson<String?>(json['quotedMessageId']),
      pollId: serializer.fromJson<String?>(json['pollId']),
      replyCount: serializer.fromJson<int?>(json['replyCount']),
      showInChannel: serializer.fromJson<bool?>(json['showInChannel']),
      shadowed: serializer.fromJson<bool>(json['shadowed']),
      command: serializer.fromJson<String?>(json['command']),
      localCreatedAt: serializer.fromJson<DateTime?>(json['localCreatedAt']),
      remoteCreatedAt: serializer.fromJson<DateTime?>(json['remoteCreatedAt']),
      localUpdatedAt: serializer.fromJson<DateTime?>(json['localUpdatedAt']),
      remoteUpdatedAt: serializer.fromJson<DateTime?>(json['remoteUpdatedAt']),
      localDeletedAt: serializer.fromJson<DateTime?>(json['localDeletedAt']),
      remoteDeletedAt: serializer.fromJson<DateTime?>(json['remoteDeletedAt']),
      messageTextUpdatedAt:
          serializer.fromJson<DateTime?>(json['messageTextUpdatedAt']),
      userId: serializer.fromJson<String?>(json['userId']),
      pinned: serializer.fromJson<bool>(json['pinned']),
      pinnedAt: serializer.fromJson<DateTime?>(json['pinnedAt']),
      pinExpires: serializer.fromJson<DateTime?>(json['pinExpires']),
      pinnedByUserId: serializer.fromJson<String?>(json['pinnedByUserId']),
      channelCid: serializer.fromJson<String>(json['channelCid']),
      i18n: serializer.fromJson<Map<String, String>?>(json['i18n']),
      restrictedVisibility:
          serializer.fromJson<List<String>?>(json['restrictedVisibility']),
      extraData: serializer.fromJson<Map<String, dynamic>?>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageText': serializer.toJson<String?>(messageText),
      'attachments': serializer.toJson<List<String>>(attachments),
      'state': serializer.toJson<String>(state),
      'type': serializer.toJson<String>(type),
      'mentionedUsers': serializer.toJson<List<String>>(mentionedUsers),
      'reactionCounts': serializer.toJson<Map<String, int>?>(reactionCounts),
      'reactionScores': serializer.toJson<Map<String, int>?>(reactionScores),
      'parentId': serializer.toJson<String?>(parentId),
      'quotedMessageId': serializer.toJson<String?>(quotedMessageId),
      'pollId': serializer.toJson<String?>(pollId),
      'replyCount': serializer.toJson<int?>(replyCount),
      'showInChannel': serializer.toJson<bool?>(showInChannel),
      'shadowed': serializer.toJson<bool>(shadowed),
      'command': serializer.toJson<String?>(command),
      'localCreatedAt': serializer.toJson<DateTime?>(localCreatedAt),
      'remoteCreatedAt': serializer.toJson<DateTime?>(remoteCreatedAt),
      'localUpdatedAt': serializer.toJson<DateTime?>(localUpdatedAt),
      'remoteUpdatedAt': serializer.toJson<DateTime?>(remoteUpdatedAt),
      'localDeletedAt': serializer.toJson<DateTime?>(localDeletedAt),
      'remoteDeletedAt': serializer.toJson<DateTime?>(remoteDeletedAt),
      'messageTextUpdatedAt':
          serializer.toJson<DateTime?>(messageTextUpdatedAt),
      'userId': serializer.toJson<String?>(userId),
      'pinned': serializer.toJson<bool>(pinned),
      'pinnedAt': serializer.toJson<DateTime?>(pinnedAt),
      'pinExpires': serializer.toJson<DateTime?>(pinExpires),
      'pinnedByUserId': serializer.toJson<String?>(pinnedByUserId),
      'channelCid': serializer.toJson<String>(channelCid),
      'i18n': serializer.toJson<Map<String, String>?>(i18n),
      'restrictedVisibility':
          serializer.toJson<List<String>?>(restrictedVisibility),
      'extraData': serializer.toJson<Map<String, dynamic>?>(extraData),
    };
  }

  PinnedMessageEntity copyWith(
          {String? id,
          Value<String?> messageText = const Value.absent(),
          List<String>? attachments,
          String? state,
          String? type,
          List<String>? mentionedUsers,
          Value<Map<String, int>?> reactionCounts = const Value.absent(),
          Value<Map<String, int>?> reactionScores = const Value.absent(),
          Value<String?> parentId = const Value.absent(),
          Value<String?> quotedMessageId = const Value.absent(),
          Value<String?> pollId = const Value.absent(),
          Value<int?> replyCount = const Value.absent(),
          Value<bool?> showInChannel = const Value.absent(),
          bool? shadowed,
          Value<String?> command = const Value.absent(),
          Value<DateTime?> localCreatedAt = const Value.absent(),
          Value<DateTime?> remoteCreatedAt = const Value.absent(),
          Value<DateTime?> localUpdatedAt = const Value.absent(),
          Value<DateTime?> remoteUpdatedAt = const Value.absent(),
          Value<DateTime?> localDeletedAt = const Value.absent(),
          Value<DateTime?> remoteDeletedAt = const Value.absent(),
          Value<DateTime?> messageTextUpdatedAt = const Value.absent(),
          Value<String?> userId = const Value.absent(),
          bool? pinned,
          Value<DateTime?> pinnedAt = const Value.absent(),
          Value<DateTime?> pinExpires = const Value.absent(),
          Value<String?> pinnedByUserId = const Value.absent(),
          String? channelCid,
          Value<Map<String, String>?> i18n = const Value.absent(),
          Value<List<String>?> restrictedVisibility = const Value.absent(),
          Value<Map<String, dynamic>?> extraData = const Value.absent()}) =>
      PinnedMessageEntity(
        id: id ?? this.id,
        messageText: messageText.present ? messageText.value : this.messageText,
        attachments: attachments ?? this.attachments,
        state: state ?? this.state,
        type: type ?? this.type,
        mentionedUsers: mentionedUsers ?? this.mentionedUsers,
        reactionCounts:
            reactionCounts.present ? reactionCounts.value : this.reactionCounts,
        reactionScores:
            reactionScores.present ? reactionScores.value : this.reactionScores,
        parentId: parentId.present ? parentId.value : this.parentId,
        quotedMessageId: quotedMessageId.present
            ? quotedMessageId.value
            : this.quotedMessageId,
        pollId: pollId.present ? pollId.value : this.pollId,
        replyCount: replyCount.present ? replyCount.value : this.replyCount,
        showInChannel:
            showInChannel.present ? showInChannel.value : this.showInChannel,
        shadowed: shadowed ?? this.shadowed,
        command: command.present ? command.value : this.command,
        localCreatedAt:
            localCreatedAt.present ? localCreatedAt.value : this.localCreatedAt,
        remoteCreatedAt: remoteCreatedAt.present
            ? remoteCreatedAt.value
            : this.remoteCreatedAt,
        localUpdatedAt:
            localUpdatedAt.present ? localUpdatedAt.value : this.localUpdatedAt,
        remoteUpdatedAt: remoteUpdatedAt.present
            ? remoteUpdatedAt.value
            : this.remoteUpdatedAt,
        localDeletedAt:
            localDeletedAt.present ? localDeletedAt.value : this.localDeletedAt,
        remoteDeletedAt: remoteDeletedAt.present
            ? remoteDeletedAt.value
            : this.remoteDeletedAt,
        messageTextUpdatedAt: messageTextUpdatedAt.present
            ? messageTextUpdatedAt.value
            : this.messageTextUpdatedAt,
        userId: userId.present ? userId.value : this.userId,
        pinned: pinned ?? this.pinned,
        pinnedAt: pinnedAt.present ? pinnedAt.value : this.pinnedAt,
        pinExpires: pinExpires.present ? pinExpires.value : this.pinExpires,
        pinnedByUserId:
            pinnedByUserId.present ? pinnedByUserId.value : this.pinnedByUserId,
        channelCid: channelCid ?? this.channelCid,
        i18n: i18n.present ? i18n.value : this.i18n,
        restrictedVisibility: restrictedVisibility.present
            ? restrictedVisibility.value
            : this.restrictedVisibility,
        extraData: extraData.present ? extraData.value : this.extraData,
      );
  PinnedMessageEntity copyWithCompanion(PinnedMessagesCompanion data) {
    return PinnedMessageEntity(
      id: data.id.present ? data.id.value : this.id,
      messageText:
          data.messageText.present ? data.messageText.value : this.messageText,
      attachments:
          data.attachments.present ? data.attachments.value : this.attachments,
      state: data.state.present ? data.state.value : this.state,
      type: data.type.present ? data.type.value : this.type,
      mentionedUsers: data.mentionedUsers.present
          ? data.mentionedUsers.value
          : this.mentionedUsers,
      reactionCounts: data.reactionCounts.present
          ? data.reactionCounts.value
          : this.reactionCounts,
      reactionScores: data.reactionScores.present
          ? data.reactionScores.value
          : this.reactionScores,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      quotedMessageId: data.quotedMessageId.present
          ? data.quotedMessageId.value
          : this.quotedMessageId,
      pollId: data.pollId.present ? data.pollId.value : this.pollId,
      replyCount:
          data.replyCount.present ? data.replyCount.value : this.replyCount,
      showInChannel: data.showInChannel.present
          ? data.showInChannel.value
          : this.showInChannel,
      shadowed: data.shadowed.present ? data.shadowed.value : this.shadowed,
      command: data.command.present ? data.command.value : this.command,
      localCreatedAt: data.localCreatedAt.present
          ? data.localCreatedAt.value
          : this.localCreatedAt,
      remoteCreatedAt: data.remoteCreatedAt.present
          ? data.remoteCreatedAt.value
          : this.remoteCreatedAt,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
      remoteUpdatedAt: data.remoteUpdatedAt.present
          ? data.remoteUpdatedAt.value
          : this.remoteUpdatedAt,
      localDeletedAt: data.localDeletedAt.present
          ? data.localDeletedAt.value
          : this.localDeletedAt,
      remoteDeletedAt: data.remoteDeletedAt.present
          ? data.remoteDeletedAt.value
          : this.remoteDeletedAt,
      messageTextUpdatedAt: data.messageTextUpdatedAt.present
          ? data.messageTextUpdatedAt.value
          : this.messageTextUpdatedAt,
      userId: data.userId.present ? data.userId.value : this.userId,
      pinned: data.pinned.present ? data.pinned.value : this.pinned,
      pinnedAt: data.pinnedAt.present ? data.pinnedAt.value : this.pinnedAt,
      pinExpires:
          data.pinExpires.present ? data.pinExpires.value : this.pinExpires,
      pinnedByUserId: data.pinnedByUserId.present
          ? data.pinnedByUserId.value
          : this.pinnedByUserId,
      channelCid:
          data.channelCid.present ? data.channelCid.value : this.channelCid,
      i18n: data.i18n.present ? data.i18n.value : this.i18n,
      restrictedVisibility: data.restrictedVisibility.present
          ? data.restrictedVisibility.value
          : this.restrictedVisibility,
      extraData: data.extraData.present ? data.extraData.value : this.extraData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PinnedMessageEntity(')
          ..write('id: $id, ')
          ..write('messageText: $messageText, ')
          ..write('attachments: $attachments, ')
          ..write('state: $state, ')
          ..write('type: $type, ')
          ..write('mentionedUsers: $mentionedUsers, ')
          ..write('reactionCounts: $reactionCounts, ')
          ..write('reactionScores: $reactionScores, ')
          ..write('parentId: $parentId, ')
          ..write('quotedMessageId: $quotedMessageId, ')
          ..write('pollId: $pollId, ')
          ..write('replyCount: $replyCount, ')
          ..write('showInChannel: $showInChannel, ')
          ..write('shadowed: $shadowed, ')
          ..write('command: $command, ')
          ..write('localCreatedAt: $localCreatedAt, ')
          ..write('remoteCreatedAt: $remoteCreatedAt, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('localDeletedAt: $localDeletedAt, ')
          ..write('remoteDeletedAt: $remoteDeletedAt, ')
          ..write('messageTextUpdatedAt: $messageTextUpdatedAt, ')
          ..write('userId: $userId, ')
          ..write('pinned: $pinned, ')
          ..write('pinnedAt: $pinnedAt, ')
          ..write('pinExpires: $pinExpires, ')
          ..write('pinnedByUserId: $pinnedByUserId, ')
          ..write('channelCid: $channelCid, ')
          ..write('i18n: $i18n, ')
          ..write('restrictedVisibility: $restrictedVisibility, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        messageText,
        attachments,
        state,
        type,
        mentionedUsers,
        reactionCounts,
        reactionScores,
        parentId,
        quotedMessageId,
        pollId,
        replyCount,
        showInChannel,
        shadowed,
        command,
        localCreatedAt,
        remoteCreatedAt,
        localUpdatedAt,
        remoteUpdatedAt,
        localDeletedAt,
        remoteDeletedAt,
        messageTextUpdatedAt,
        userId,
        pinned,
        pinnedAt,
        pinExpires,
        pinnedByUserId,
        channelCid,
        i18n,
        restrictedVisibility,
        extraData
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PinnedMessageEntity &&
          other.id == this.id &&
          other.messageText == this.messageText &&
          other.attachments == this.attachments &&
          other.state == this.state &&
          other.type == this.type &&
          other.mentionedUsers == this.mentionedUsers &&
          other.reactionCounts == this.reactionCounts &&
          other.reactionScores == this.reactionScores &&
          other.parentId == this.parentId &&
          other.quotedMessageId == this.quotedMessageId &&
          other.pollId == this.pollId &&
          other.replyCount == this.replyCount &&
          other.showInChannel == this.showInChannel &&
          other.shadowed == this.shadowed &&
          other.command == this.command &&
          other.localCreatedAt == this.localCreatedAt &&
          other.remoteCreatedAt == this.remoteCreatedAt &&
          other.localUpdatedAt == this.localUpdatedAt &&
          other.remoteUpdatedAt == this.remoteUpdatedAt &&
          other.localDeletedAt == this.localDeletedAt &&
          other.remoteDeletedAt == this.remoteDeletedAt &&
          other.messageTextUpdatedAt == this.messageTextUpdatedAt &&
          other.userId == this.userId &&
          other.pinned == this.pinned &&
          other.pinnedAt == this.pinnedAt &&
          other.pinExpires == this.pinExpires &&
          other.pinnedByUserId == this.pinnedByUserId &&
          other.channelCid == this.channelCid &&
          other.i18n == this.i18n &&
          other.restrictedVisibility == this.restrictedVisibility &&
          other.extraData == this.extraData);
}

class PinnedMessagesCompanion extends UpdateCompanion<PinnedMessageEntity> {
  final Value<String> id;
  final Value<String?> messageText;
  final Value<List<String>> attachments;
  final Value<String> state;
  final Value<String> type;
  final Value<List<String>> mentionedUsers;
  final Value<Map<String, int>?> reactionCounts;
  final Value<Map<String, int>?> reactionScores;
  final Value<String?> parentId;
  final Value<String?> quotedMessageId;
  final Value<String?> pollId;
  final Value<int?> replyCount;
  final Value<bool?> showInChannel;
  final Value<bool> shadowed;
  final Value<String?> command;
  final Value<DateTime?> localCreatedAt;
  final Value<DateTime?> remoteCreatedAt;
  final Value<DateTime?> localUpdatedAt;
  final Value<DateTime?> remoteUpdatedAt;
  final Value<DateTime?> localDeletedAt;
  final Value<DateTime?> remoteDeletedAt;
  final Value<DateTime?> messageTextUpdatedAt;
  final Value<String?> userId;
  final Value<bool> pinned;
  final Value<DateTime?> pinnedAt;
  final Value<DateTime?> pinExpires;
  final Value<String?> pinnedByUserId;
  final Value<String> channelCid;
  final Value<Map<String, String>?> i18n;
  final Value<List<String>?> restrictedVisibility;
  final Value<Map<String, dynamic>?> extraData;
  final Value<int> rowid;
  const PinnedMessagesCompanion({
    this.id = const Value.absent(),
    this.messageText = const Value.absent(),
    this.attachments = const Value.absent(),
    this.state = const Value.absent(),
    this.type = const Value.absent(),
    this.mentionedUsers = const Value.absent(),
    this.reactionCounts = const Value.absent(),
    this.reactionScores = const Value.absent(),
    this.parentId = const Value.absent(),
    this.quotedMessageId = const Value.absent(),
    this.pollId = const Value.absent(),
    this.replyCount = const Value.absent(),
    this.showInChannel = const Value.absent(),
    this.shadowed = const Value.absent(),
    this.command = const Value.absent(),
    this.localCreatedAt = const Value.absent(),
    this.remoteCreatedAt = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.localDeletedAt = const Value.absent(),
    this.remoteDeletedAt = const Value.absent(),
    this.messageTextUpdatedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.pinned = const Value.absent(),
    this.pinnedAt = const Value.absent(),
    this.pinExpires = const Value.absent(),
    this.pinnedByUserId = const Value.absent(),
    this.channelCid = const Value.absent(),
    this.i18n = const Value.absent(),
    this.restrictedVisibility = const Value.absent(),
    this.extraData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PinnedMessagesCompanion.insert({
    required String id,
    this.messageText = const Value.absent(),
    required List<String> attachments,
    required String state,
    this.type = const Value.absent(),
    required List<String> mentionedUsers,
    this.reactionCounts = const Value.absent(),
    this.reactionScores = const Value.absent(),
    this.parentId = const Value.absent(),
    this.quotedMessageId = const Value.absent(),
    this.pollId = const Value.absent(),
    this.replyCount = const Value.absent(),
    this.showInChannel = const Value.absent(),
    this.shadowed = const Value.absent(),
    this.command = const Value.absent(),
    this.localCreatedAt = const Value.absent(),
    this.remoteCreatedAt = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.localDeletedAt = const Value.absent(),
    this.remoteDeletedAt = const Value.absent(),
    this.messageTextUpdatedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.pinned = const Value.absent(),
    this.pinnedAt = const Value.absent(),
    this.pinExpires = const Value.absent(),
    this.pinnedByUserId = const Value.absent(),
    required String channelCid,
    this.i18n = const Value.absent(),
    this.restrictedVisibility = const Value.absent(),
    this.extraData = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        attachments = Value(attachments),
        state = Value(state),
        mentionedUsers = Value(mentionedUsers),
        channelCid = Value(channelCid);
  static Insertable<PinnedMessageEntity> custom({
    Expression<String>? id,
    Expression<String>? messageText,
    Expression<String>? attachments,
    Expression<String>? state,
    Expression<String>? type,
    Expression<String>? mentionedUsers,
    Expression<String>? reactionCounts,
    Expression<String>? reactionScores,
    Expression<String>? parentId,
    Expression<String>? quotedMessageId,
    Expression<String>? pollId,
    Expression<int>? replyCount,
    Expression<bool>? showInChannel,
    Expression<bool>? shadowed,
    Expression<String>? command,
    Expression<DateTime>? localCreatedAt,
    Expression<DateTime>? remoteCreatedAt,
    Expression<DateTime>? localUpdatedAt,
    Expression<DateTime>? remoteUpdatedAt,
    Expression<DateTime>? localDeletedAt,
    Expression<DateTime>? remoteDeletedAt,
    Expression<DateTime>? messageTextUpdatedAt,
    Expression<String>? userId,
    Expression<bool>? pinned,
    Expression<DateTime>? pinnedAt,
    Expression<DateTime>? pinExpires,
    Expression<String>? pinnedByUserId,
    Expression<String>? channelCid,
    Expression<String>? i18n,
    Expression<String>? restrictedVisibility,
    Expression<String>? extraData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageText != null) 'message_text': messageText,
      if (attachments != null) 'attachments': attachments,
      if (state != null) 'state': state,
      if (type != null) 'type': type,
      if (mentionedUsers != null) 'mentioned_users': mentionedUsers,
      if (reactionCounts != null) 'reaction_counts': reactionCounts,
      if (reactionScores != null) 'reaction_scores': reactionScores,
      if (parentId != null) 'parent_id': parentId,
      if (quotedMessageId != null) 'quoted_message_id': quotedMessageId,
      if (pollId != null) 'poll_id': pollId,
      if (replyCount != null) 'reply_count': replyCount,
      if (showInChannel != null) 'show_in_channel': showInChannel,
      if (shadowed != null) 'shadowed': shadowed,
      if (command != null) 'command': command,
      if (localCreatedAt != null) 'local_created_at': localCreatedAt,
      if (remoteCreatedAt != null) 'remote_created_at': remoteCreatedAt,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (remoteUpdatedAt != null) 'remote_updated_at': remoteUpdatedAt,
      if (localDeletedAt != null) 'local_deleted_at': localDeletedAt,
      if (remoteDeletedAt != null) 'remote_deleted_at': remoteDeletedAt,
      if (messageTextUpdatedAt != null)
        'message_text_updated_at': messageTextUpdatedAt,
      if (userId != null) 'user_id': userId,
      if (pinned != null) 'pinned': pinned,
      if (pinnedAt != null) 'pinned_at': pinnedAt,
      if (pinExpires != null) 'pin_expires': pinExpires,
      if (pinnedByUserId != null) 'pinned_by_user_id': pinnedByUserId,
      if (channelCid != null) 'channel_cid': channelCid,
      if (i18n != null) 'i18n': i18n,
      if (restrictedVisibility != null)
        'restricted_visibility': restrictedVisibility,
      if (extraData != null) 'extra_data': extraData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PinnedMessagesCompanion copyWith(
      {Value<String>? id,
      Value<String?>? messageText,
      Value<List<String>>? attachments,
      Value<String>? state,
      Value<String>? type,
      Value<List<String>>? mentionedUsers,
      Value<Map<String, int>?>? reactionCounts,
      Value<Map<String, int>?>? reactionScores,
      Value<String?>? parentId,
      Value<String?>? quotedMessageId,
      Value<String?>? pollId,
      Value<int?>? replyCount,
      Value<bool?>? showInChannel,
      Value<bool>? shadowed,
      Value<String?>? command,
      Value<DateTime?>? localCreatedAt,
      Value<DateTime?>? remoteCreatedAt,
      Value<DateTime?>? localUpdatedAt,
      Value<DateTime?>? remoteUpdatedAt,
      Value<DateTime?>? localDeletedAt,
      Value<DateTime?>? remoteDeletedAt,
      Value<DateTime?>? messageTextUpdatedAt,
      Value<String?>? userId,
      Value<bool>? pinned,
      Value<DateTime?>? pinnedAt,
      Value<DateTime?>? pinExpires,
      Value<String?>? pinnedByUserId,
      Value<String>? channelCid,
      Value<Map<String, String>?>? i18n,
      Value<List<String>?>? restrictedVisibility,
      Value<Map<String, dynamic>?>? extraData,
      Value<int>? rowid}) {
    return PinnedMessagesCompanion(
      id: id ?? this.id,
      messageText: messageText ?? this.messageText,
      attachments: attachments ?? this.attachments,
      state: state ?? this.state,
      type: type ?? this.type,
      mentionedUsers: mentionedUsers ?? this.mentionedUsers,
      reactionCounts: reactionCounts ?? this.reactionCounts,
      reactionScores: reactionScores ?? this.reactionScores,
      parentId: parentId ?? this.parentId,
      quotedMessageId: quotedMessageId ?? this.quotedMessageId,
      pollId: pollId ?? this.pollId,
      replyCount: replyCount ?? this.replyCount,
      showInChannel: showInChannel ?? this.showInChannel,
      shadowed: shadowed ?? this.shadowed,
      command: command ?? this.command,
      localCreatedAt: localCreatedAt ?? this.localCreatedAt,
      remoteCreatedAt: remoteCreatedAt ?? this.remoteCreatedAt,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
      localDeletedAt: localDeletedAt ?? this.localDeletedAt,
      remoteDeletedAt: remoteDeletedAt ?? this.remoteDeletedAt,
      messageTextUpdatedAt: messageTextUpdatedAt ?? this.messageTextUpdatedAt,
      userId: userId ?? this.userId,
      pinned: pinned ?? this.pinned,
      pinnedAt: pinnedAt ?? this.pinnedAt,
      pinExpires: pinExpires ?? this.pinExpires,
      pinnedByUserId: pinnedByUserId ?? this.pinnedByUserId,
      channelCid: channelCid ?? this.channelCid,
      i18n: i18n ?? this.i18n,
      restrictedVisibility: restrictedVisibility ?? this.restrictedVisibility,
      extraData: extraData ?? this.extraData,
      rowid: rowid ?? this.rowid,
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
    if (attachments.present) {
      map['attachments'] = Variable<String>(
          $PinnedMessagesTable.$converterattachments.toSql(attachments.value));
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (mentionedUsers.present) {
      map['mentioned_users'] = Variable<String>($PinnedMessagesTable
          .$convertermentionedUsers
          .toSql(mentionedUsers.value));
    }
    if (reactionCounts.present) {
      map['reaction_counts'] = Variable<String>($PinnedMessagesTable
          .$converterreactionCountsn
          .toSql(reactionCounts.value));
    }
    if (reactionScores.present) {
      map['reaction_scores'] = Variable<String>($PinnedMessagesTable
          .$converterreactionScoresn
          .toSql(reactionScores.value));
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (quotedMessageId.present) {
      map['quoted_message_id'] = Variable<String>(quotedMessageId.value);
    }
    if (pollId.present) {
      map['poll_id'] = Variable<String>(pollId.value);
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
    if (localCreatedAt.present) {
      map['local_created_at'] = Variable<DateTime>(localCreatedAt.value);
    }
    if (remoteCreatedAt.present) {
      map['remote_created_at'] = Variable<DateTime>(remoteCreatedAt.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (remoteUpdatedAt.present) {
      map['remote_updated_at'] = Variable<DateTime>(remoteUpdatedAt.value);
    }
    if (localDeletedAt.present) {
      map['local_deleted_at'] = Variable<DateTime>(localDeletedAt.value);
    }
    if (remoteDeletedAt.present) {
      map['remote_deleted_at'] = Variable<DateTime>(remoteDeletedAt.value);
    }
    if (messageTextUpdatedAt.present) {
      map['message_text_updated_at'] =
          Variable<DateTime>(messageTextUpdatedAt.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (pinned.present) {
      map['pinned'] = Variable<bool>(pinned.value);
    }
    if (pinnedAt.present) {
      map['pinned_at'] = Variable<DateTime>(pinnedAt.value);
    }
    if (pinExpires.present) {
      map['pin_expires'] = Variable<DateTime>(pinExpires.value);
    }
    if (pinnedByUserId.present) {
      map['pinned_by_user_id'] = Variable<String>(pinnedByUserId.value);
    }
    if (channelCid.present) {
      map['channel_cid'] = Variable<String>(channelCid.value);
    }
    if (i18n.present) {
      map['i18n'] = Variable<String>(
          $PinnedMessagesTable.$converteri18n.toSql(i18n.value));
    }
    if (restrictedVisibility.present) {
      map['restricted_visibility'] = Variable<String>($PinnedMessagesTable
          .$converterrestrictedVisibilityn
          .toSql(restrictedVisibility.value));
    }
    if (extraData.present) {
      map['extra_data'] = Variable<String>(
          $PinnedMessagesTable.$converterextraDatan.toSql(extraData.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PinnedMessagesCompanion(')
          ..write('id: $id, ')
          ..write('messageText: $messageText, ')
          ..write('attachments: $attachments, ')
          ..write('state: $state, ')
          ..write('type: $type, ')
          ..write('mentionedUsers: $mentionedUsers, ')
          ..write('reactionCounts: $reactionCounts, ')
          ..write('reactionScores: $reactionScores, ')
          ..write('parentId: $parentId, ')
          ..write('quotedMessageId: $quotedMessageId, ')
          ..write('pollId: $pollId, ')
          ..write('replyCount: $replyCount, ')
          ..write('showInChannel: $showInChannel, ')
          ..write('shadowed: $shadowed, ')
          ..write('command: $command, ')
          ..write('localCreatedAt: $localCreatedAt, ')
          ..write('remoteCreatedAt: $remoteCreatedAt, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('localDeletedAt: $localDeletedAt, ')
          ..write('remoteDeletedAt: $remoteDeletedAt, ')
          ..write('messageTextUpdatedAt: $messageTextUpdatedAt, ')
          ..write('userId: $userId, ')
          ..write('pinned: $pinned, ')
          ..write('pinnedAt: $pinnedAt, ')
          ..write('pinExpires: $pinExpires, ')
          ..write('pinnedByUserId: $pinnedByUserId, ')
          ..write('channelCid: $channelCid, ')
          ..write('i18n: $i18n, ')
          ..write('restrictedVisibility: $restrictedVisibility, ')
          ..write('extraData: $extraData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PollsTable extends Polls with TableInfo<$PollsTable, PollEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PollsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _optionsMeta =
      const VerificationMeta('options');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> options =
      GeneratedColumn<String>('options', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($PollsTable.$converteroptions);
  static const VerificationMeta _votingVisibilityMeta =
      const VerificationMeta('votingVisibility');
  @override
  late final GeneratedColumnWithTypeConverter<VotingVisibility, String>
      votingVisibility = GeneratedColumn<String>(
              'voting_visibility', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('public'))
          .withConverter<VotingVisibility>(
              $PollsTable.$convertervotingVisibility);
  static const VerificationMeta _enforceUniqueVoteMeta =
      const VerificationMeta('enforceUniqueVote');
  @override
  late final GeneratedColumn<bool> enforceUniqueVote = GeneratedColumn<bool>(
      'enforce_unique_vote', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("enforce_unique_vote" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _maxVotesAllowedMeta =
      const VerificationMeta('maxVotesAllowed');
  @override
  late final GeneratedColumn<int> maxVotesAllowed = GeneratedColumn<int>(
      'max_votes_allowed', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _allowUserSuggestedOptionsMeta =
      const VerificationMeta('allowUserSuggestedOptions');
  @override
  late final GeneratedColumn<bool> allowUserSuggestedOptions =
      GeneratedColumn<bool>('allow_user_suggested_options', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("allow_user_suggested_options" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _allowAnswersMeta =
      const VerificationMeta('allowAnswers');
  @override
  late final GeneratedColumn<bool> allowAnswers = GeneratedColumn<bool>(
      'allow_answers', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("allow_answers" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isClosedMeta =
      const VerificationMeta('isClosed');
  @override
  late final GeneratedColumn<bool> isClosed = GeneratedColumn<bool>(
      'is_closed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_closed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _answersCountMeta =
      const VerificationMeta('answersCount');
  @override
  late final GeneratedColumn<int> answersCount = GeneratedColumn<int>(
      'answers_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _voteCountsByOptionMeta =
      const VerificationMeta('voteCountsByOption');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, int>, String>
      voteCountsByOption = GeneratedColumn<String>(
              'vote_counts_by_option', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, int>>(
              $PollsTable.$convertervoteCountsByOption);
  static const VerificationMeta _voteCountMeta =
      const VerificationMeta('voteCount');
  @override
  late final GeneratedColumn<int> voteCount = GeneratedColumn<int>(
      'vote_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdByIdMeta =
      const VerificationMeta('createdById');
  @override
  late final GeneratedColumn<String> createdById = GeneratedColumn<String>(
      'created_by_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _extraDataMeta =
      const VerificationMeta('extraData');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      extraData = GeneratedColumn<String>('extra_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, dynamic>?>(
              $PollsTable.$converterextraDatan);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        options,
        votingVisibility,
        enforceUniqueVote,
        maxVotesAllowed,
        allowUserSuggestedOptions,
        allowAnswers,
        isClosed,
        answersCount,
        voteCountsByOption,
        voteCount,
        createdById,
        createdAt,
        updatedAt,
        extraData
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'polls';
  @override
  VerificationContext validateIntegrity(Insertable<PollEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    context.handle(_optionsMeta, const VerificationResult.success());
    context.handle(_votingVisibilityMeta, const VerificationResult.success());
    if (data.containsKey('enforce_unique_vote')) {
      context.handle(
          _enforceUniqueVoteMeta,
          enforceUniqueVote.isAcceptableOrUnknown(
              data['enforce_unique_vote']!, _enforceUniqueVoteMeta));
    }
    if (data.containsKey('max_votes_allowed')) {
      context.handle(
          _maxVotesAllowedMeta,
          maxVotesAllowed.isAcceptableOrUnknown(
              data['max_votes_allowed']!, _maxVotesAllowedMeta));
    }
    if (data.containsKey('allow_user_suggested_options')) {
      context.handle(
          _allowUserSuggestedOptionsMeta,
          allowUserSuggestedOptions.isAcceptableOrUnknown(
              data['allow_user_suggested_options']!,
              _allowUserSuggestedOptionsMeta));
    }
    if (data.containsKey('allow_answers')) {
      context.handle(
          _allowAnswersMeta,
          allowAnswers.isAcceptableOrUnknown(
              data['allow_answers']!, _allowAnswersMeta));
    }
    if (data.containsKey('is_closed')) {
      context.handle(_isClosedMeta,
          isClosed.isAcceptableOrUnknown(data['is_closed']!, _isClosedMeta));
    }
    if (data.containsKey('answers_count')) {
      context.handle(
          _answersCountMeta,
          answersCount.isAcceptableOrUnknown(
              data['answers_count']!, _answersCountMeta));
    }
    context.handle(_voteCountsByOptionMeta, const VerificationResult.success());
    if (data.containsKey('vote_count')) {
      context.handle(_voteCountMeta,
          voteCount.isAcceptableOrUnknown(data['vote_count']!, _voteCountMeta));
    }
    if (data.containsKey('created_by_id')) {
      context.handle(
          _createdByIdMeta,
          createdById.isAcceptableOrUnknown(
              data['created_by_id']!, _createdByIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    context.handle(_extraDataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PollEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PollEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      options: $PollsTable.$converteroptions.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}options'])!),
      votingVisibility: $PollsTable.$convertervotingVisibility.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}voting_visibility'])!),
      enforceUniqueVote: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}enforce_unique_vote'])!,
      maxVotesAllowed: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_votes_allowed']),
      allowUserSuggestedOptions: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}allow_user_suggested_options'])!,
      allowAnswers: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}allow_answers'])!,
      isClosed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_closed'])!,
      answersCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}answers_count'])!,
      voteCountsByOption: $PollsTable.$convertervoteCountsByOption.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}vote_counts_by_option'])!),
      voteCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vote_count'])!,
      createdById: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      extraData: $PollsTable.$converterextraDatan.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extra_data'])),
    );
  }

  @override
  $PollsTable createAlias(String alias) {
    return $PollsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converteroptions =
      ListConverter<String>();
  static TypeConverter<VotingVisibility, String> $convertervotingVisibility =
      const VotingVisibilityConverter();
  static TypeConverter<Map<String, int>, String> $convertervoteCountsByOption =
      MapConverter<int>();
  static TypeConverter<Map<String, dynamic>, String> $converterextraData =
      MapConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $converterextraDatan =
      NullAwareTypeConverter.wrap($converterextraData);
}

class PollEntity extends DataClass implements Insertable<PollEntity> {
  /// The unique identifier of the poll.
  final String id;

  /// The name of the poll.
  final String name;

  /// The description of the poll.
  final String? description;

  /// The list of options available for the poll.
  final List<String> options;

  /// Represents the visibility of the voting process.
  ///
  /// Defaults to 'public'.
  final VotingVisibility votingVisibility;

  /// If true, only unique votes are allowed.
  ///
  /// Defaults to false.
  final bool enforceUniqueVote;

  /// The maximum number of votes allowed per user.
  final int? maxVotesAllowed;

  /// If true, users can suggest their own options.
  ///
  /// Defaults to false.
  final bool allowUserSuggestedOptions;

  /// If true, users can provide their own answers/comments.
  ///
  /// Defaults to false.
  final bool allowAnswers;

  /// Indicates if the poll is closed.
  final bool isClosed;

  /// The total number of answers received by the poll.
  final int answersCount;

  /// Map of vote counts by option.
  final Map<String, int> voteCountsByOption;

  /// The total number of votes received by the poll.
  final int voteCount;

  /// The id of the user who created the poll.
  final String? createdById;

  /// The date when the poll was created.
  final DateTime createdAt;

  /// The date when the poll was last updated.
  final DateTime updatedAt;

  /// Map of custom poll extraData
  final Map<String, dynamic>? extraData;
  const PollEntity(
      {required this.id,
      required this.name,
      this.description,
      required this.options,
      required this.votingVisibility,
      required this.enforceUniqueVote,
      this.maxVotesAllowed,
      required this.allowUserSuggestedOptions,
      required this.allowAnswers,
      required this.isClosed,
      required this.answersCount,
      required this.voteCountsByOption,
      required this.voteCount,
      this.createdById,
      required this.createdAt,
      required this.updatedAt,
      this.extraData});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    {
      map['options'] =
          Variable<String>($PollsTable.$converteroptions.toSql(options));
    }
    {
      map['voting_visibility'] = Variable<String>(
          $PollsTable.$convertervotingVisibility.toSql(votingVisibility));
    }
    map['enforce_unique_vote'] = Variable<bool>(enforceUniqueVote);
    if (!nullToAbsent || maxVotesAllowed != null) {
      map['max_votes_allowed'] = Variable<int>(maxVotesAllowed);
    }
    map['allow_user_suggested_options'] =
        Variable<bool>(allowUserSuggestedOptions);
    map['allow_answers'] = Variable<bool>(allowAnswers);
    map['is_closed'] = Variable<bool>(isClosed);
    map['answers_count'] = Variable<int>(answersCount);
    {
      map['vote_counts_by_option'] = Variable<String>(
          $PollsTable.$convertervoteCountsByOption.toSql(voteCountsByOption));
    }
    map['vote_count'] = Variable<int>(voteCount);
    if (!nullToAbsent || createdById != null) {
      map['created_by_id'] = Variable<String>(createdById);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || extraData != null) {
      map['extra_data'] =
          Variable<String>($PollsTable.$converterextraDatan.toSql(extraData));
    }
    return map;
  }

  factory PollEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PollEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      options: serializer.fromJson<List<String>>(json['options']),
      votingVisibility:
          serializer.fromJson<VotingVisibility>(json['votingVisibility']),
      enforceUniqueVote: serializer.fromJson<bool>(json['enforceUniqueVote']),
      maxVotesAllowed: serializer.fromJson<int?>(json['maxVotesAllowed']),
      allowUserSuggestedOptions:
          serializer.fromJson<bool>(json['allowUserSuggestedOptions']),
      allowAnswers: serializer.fromJson<bool>(json['allowAnswers']),
      isClosed: serializer.fromJson<bool>(json['isClosed']),
      answersCount: serializer.fromJson<int>(json['answersCount']),
      voteCountsByOption:
          serializer.fromJson<Map<String, int>>(json['voteCountsByOption']),
      voteCount: serializer.fromJson<int>(json['voteCount']),
      createdById: serializer.fromJson<String?>(json['createdById']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      extraData: serializer.fromJson<Map<String, dynamic>?>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'options': serializer.toJson<List<String>>(options),
      'votingVisibility': serializer.toJson<VotingVisibility>(votingVisibility),
      'enforceUniqueVote': serializer.toJson<bool>(enforceUniqueVote),
      'maxVotesAllowed': serializer.toJson<int?>(maxVotesAllowed),
      'allowUserSuggestedOptions':
          serializer.toJson<bool>(allowUserSuggestedOptions),
      'allowAnswers': serializer.toJson<bool>(allowAnswers),
      'isClosed': serializer.toJson<bool>(isClosed),
      'answersCount': serializer.toJson<int>(answersCount),
      'voteCountsByOption':
          serializer.toJson<Map<String, int>>(voteCountsByOption),
      'voteCount': serializer.toJson<int>(voteCount),
      'createdById': serializer.toJson<String?>(createdById),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'extraData': serializer.toJson<Map<String, dynamic>?>(extraData),
    };
  }

  PollEntity copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          List<String>? options,
          VotingVisibility? votingVisibility,
          bool? enforceUniqueVote,
          Value<int?> maxVotesAllowed = const Value.absent(),
          bool? allowUserSuggestedOptions,
          bool? allowAnswers,
          bool? isClosed,
          int? answersCount,
          Map<String, int>? voteCountsByOption,
          int? voteCount,
          Value<String?> createdById = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<Map<String, dynamic>?> extraData = const Value.absent()}) =>
      PollEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        options: options ?? this.options,
        votingVisibility: votingVisibility ?? this.votingVisibility,
        enforceUniqueVote: enforceUniqueVote ?? this.enforceUniqueVote,
        maxVotesAllowed: maxVotesAllowed.present
            ? maxVotesAllowed.value
            : this.maxVotesAllowed,
        allowUserSuggestedOptions:
            allowUserSuggestedOptions ?? this.allowUserSuggestedOptions,
        allowAnswers: allowAnswers ?? this.allowAnswers,
        isClosed: isClosed ?? this.isClosed,
        answersCount: answersCount ?? this.answersCount,
        voteCountsByOption: voteCountsByOption ?? this.voteCountsByOption,
        voteCount: voteCount ?? this.voteCount,
        createdById: createdById.present ? createdById.value : this.createdById,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        extraData: extraData.present ? extraData.value : this.extraData,
      );
  PollEntity copyWithCompanion(PollsCompanion data) {
    return PollEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      options: data.options.present ? data.options.value : this.options,
      votingVisibility: data.votingVisibility.present
          ? data.votingVisibility.value
          : this.votingVisibility,
      enforceUniqueVote: data.enforceUniqueVote.present
          ? data.enforceUniqueVote.value
          : this.enforceUniqueVote,
      maxVotesAllowed: data.maxVotesAllowed.present
          ? data.maxVotesAllowed.value
          : this.maxVotesAllowed,
      allowUserSuggestedOptions: data.allowUserSuggestedOptions.present
          ? data.allowUserSuggestedOptions.value
          : this.allowUserSuggestedOptions,
      allowAnswers: data.allowAnswers.present
          ? data.allowAnswers.value
          : this.allowAnswers,
      isClosed: data.isClosed.present ? data.isClosed.value : this.isClosed,
      answersCount: data.answersCount.present
          ? data.answersCount.value
          : this.answersCount,
      voteCountsByOption: data.voteCountsByOption.present
          ? data.voteCountsByOption.value
          : this.voteCountsByOption,
      voteCount: data.voteCount.present ? data.voteCount.value : this.voteCount,
      createdById:
          data.createdById.present ? data.createdById.value : this.createdById,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      extraData: data.extraData.present ? data.extraData.value : this.extraData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PollEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('options: $options, ')
          ..write('votingVisibility: $votingVisibility, ')
          ..write('enforceUniqueVote: $enforceUniqueVote, ')
          ..write('maxVotesAllowed: $maxVotesAllowed, ')
          ..write('allowUserSuggestedOptions: $allowUserSuggestedOptions, ')
          ..write('allowAnswers: $allowAnswers, ')
          ..write('isClosed: $isClosed, ')
          ..write('answersCount: $answersCount, ')
          ..write('voteCountsByOption: $voteCountsByOption, ')
          ..write('voteCount: $voteCount, ')
          ..write('createdById: $createdById, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      options,
      votingVisibility,
      enforceUniqueVote,
      maxVotesAllowed,
      allowUserSuggestedOptions,
      allowAnswers,
      isClosed,
      answersCount,
      voteCountsByOption,
      voteCount,
      createdById,
      createdAt,
      updatedAt,
      extraData);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PollEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.options == this.options &&
          other.votingVisibility == this.votingVisibility &&
          other.enforceUniqueVote == this.enforceUniqueVote &&
          other.maxVotesAllowed == this.maxVotesAllowed &&
          other.allowUserSuggestedOptions == this.allowUserSuggestedOptions &&
          other.allowAnswers == this.allowAnswers &&
          other.isClosed == this.isClosed &&
          other.answersCount == this.answersCount &&
          other.voteCountsByOption == this.voteCountsByOption &&
          other.voteCount == this.voteCount &&
          other.createdById == this.createdById &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.extraData == this.extraData);
}

class PollsCompanion extends UpdateCompanion<PollEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<List<String>> options;
  final Value<VotingVisibility> votingVisibility;
  final Value<bool> enforceUniqueVote;
  final Value<int?> maxVotesAllowed;
  final Value<bool> allowUserSuggestedOptions;
  final Value<bool> allowAnswers;
  final Value<bool> isClosed;
  final Value<int> answersCount;
  final Value<Map<String, int>> voteCountsByOption;
  final Value<int> voteCount;
  final Value<String?> createdById;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<Map<String, dynamic>?> extraData;
  final Value<int> rowid;
  const PollsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.options = const Value.absent(),
    this.votingVisibility = const Value.absent(),
    this.enforceUniqueVote = const Value.absent(),
    this.maxVotesAllowed = const Value.absent(),
    this.allowUserSuggestedOptions = const Value.absent(),
    this.allowAnswers = const Value.absent(),
    this.isClosed = const Value.absent(),
    this.answersCount = const Value.absent(),
    this.voteCountsByOption = const Value.absent(),
    this.voteCount = const Value.absent(),
    this.createdById = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.extraData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PollsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required List<String> options,
    this.votingVisibility = const Value.absent(),
    this.enforceUniqueVote = const Value.absent(),
    this.maxVotesAllowed = const Value.absent(),
    this.allowUserSuggestedOptions = const Value.absent(),
    this.allowAnswers = const Value.absent(),
    this.isClosed = const Value.absent(),
    this.answersCount = const Value.absent(),
    required Map<String, int> voteCountsByOption,
    this.voteCount = const Value.absent(),
    this.createdById = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.extraData = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        options = Value(options),
        voteCountsByOption = Value(voteCountsByOption);
  static Insertable<PollEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? options,
    Expression<String>? votingVisibility,
    Expression<bool>? enforceUniqueVote,
    Expression<int>? maxVotesAllowed,
    Expression<bool>? allowUserSuggestedOptions,
    Expression<bool>? allowAnswers,
    Expression<bool>? isClosed,
    Expression<int>? answersCount,
    Expression<String>? voteCountsByOption,
    Expression<int>? voteCount,
    Expression<String>? createdById,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? extraData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (options != null) 'options': options,
      if (votingVisibility != null) 'voting_visibility': votingVisibility,
      if (enforceUniqueVote != null) 'enforce_unique_vote': enforceUniqueVote,
      if (maxVotesAllowed != null) 'max_votes_allowed': maxVotesAllowed,
      if (allowUserSuggestedOptions != null)
        'allow_user_suggested_options': allowUserSuggestedOptions,
      if (allowAnswers != null) 'allow_answers': allowAnswers,
      if (isClosed != null) 'is_closed': isClosed,
      if (answersCount != null) 'answers_count': answersCount,
      if (voteCountsByOption != null)
        'vote_counts_by_option': voteCountsByOption,
      if (voteCount != null) 'vote_count': voteCount,
      if (createdById != null) 'created_by_id': createdById,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (extraData != null) 'extra_data': extraData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PollsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<List<String>>? options,
      Value<VotingVisibility>? votingVisibility,
      Value<bool>? enforceUniqueVote,
      Value<int?>? maxVotesAllowed,
      Value<bool>? allowUserSuggestedOptions,
      Value<bool>? allowAnswers,
      Value<bool>? isClosed,
      Value<int>? answersCount,
      Value<Map<String, int>>? voteCountsByOption,
      Value<int>? voteCount,
      Value<String?>? createdById,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<Map<String, dynamic>?>? extraData,
      Value<int>? rowid}) {
    return PollsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      options: options ?? this.options,
      votingVisibility: votingVisibility ?? this.votingVisibility,
      enforceUniqueVote: enforceUniqueVote ?? this.enforceUniqueVote,
      maxVotesAllowed: maxVotesAllowed ?? this.maxVotesAllowed,
      allowUserSuggestedOptions:
          allowUserSuggestedOptions ?? this.allowUserSuggestedOptions,
      allowAnswers: allowAnswers ?? this.allowAnswers,
      isClosed: isClosed ?? this.isClosed,
      answersCount: answersCount ?? this.answersCount,
      voteCountsByOption: voteCountsByOption ?? this.voteCountsByOption,
      voteCount: voteCount ?? this.voteCount,
      createdById: createdById ?? this.createdById,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      extraData: extraData ?? this.extraData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (options.present) {
      map['options'] =
          Variable<String>($PollsTable.$converteroptions.toSql(options.value));
    }
    if (votingVisibility.present) {
      map['voting_visibility'] = Variable<String>(
          $PollsTable.$convertervotingVisibility.toSql(votingVisibility.value));
    }
    if (enforceUniqueVote.present) {
      map['enforce_unique_vote'] = Variable<bool>(enforceUniqueVote.value);
    }
    if (maxVotesAllowed.present) {
      map['max_votes_allowed'] = Variable<int>(maxVotesAllowed.value);
    }
    if (allowUserSuggestedOptions.present) {
      map['allow_user_suggested_options'] =
          Variable<bool>(allowUserSuggestedOptions.value);
    }
    if (allowAnswers.present) {
      map['allow_answers'] = Variable<bool>(allowAnswers.value);
    }
    if (isClosed.present) {
      map['is_closed'] = Variable<bool>(isClosed.value);
    }
    if (answersCount.present) {
      map['answers_count'] = Variable<int>(answersCount.value);
    }
    if (voteCountsByOption.present) {
      map['vote_counts_by_option'] = Variable<String>($PollsTable
          .$convertervoteCountsByOption
          .toSql(voteCountsByOption.value));
    }
    if (voteCount.present) {
      map['vote_count'] = Variable<int>(voteCount.value);
    }
    if (createdById.present) {
      map['created_by_id'] = Variable<String>(createdById.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (extraData.present) {
      map['extra_data'] = Variable<String>(
          $PollsTable.$converterextraDatan.toSql(extraData.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PollsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('options: $options, ')
          ..write('votingVisibility: $votingVisibility, ')
          ..write('enforceUniqueVote: $enforceUniqueVote, ')
          ..write('maxVotesAllowed: $maxVotesAllowed, ')
          ..write('allowUserSuggestedOptions: $allowUserSuggestedOptions, ')
          ..write('allowAnswers: $allowAnswers, ')
          ..write('isClosed: $isClosed, ')
          ..write('answersCount: $answersCount, ')
          ..write('voteCountsByOption: $voteCountsByOption, ')
          ..write('voteCount: $voteCount, ')
          ..write('createdById: $createdById, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('extraData: $extraData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PollVotesTable extends PollVotes
    with TableInfo<$PollVotesTable, PollVoteEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PollVotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pollIdMeta = const VerificationMeta('pollId');
  @override
  late final GeneratedColumn<String> pollId = GeneratedColumn<String>(
      'poll_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES polls (id) ON DELETE CASCADE'));
  static const VerificationMeta _optionIdMeta =
      const VerificationMeta('optionId');
  @override
  late final GeneratedColumn<String> optionId = GeneratedColumn<String>(
      'option_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _answerTextMeta =
      const VerificationMeta('answerText');
  @override
  late final GeneratedColumn<String> answerText = GeneratedColumn<String>(
      'answer_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, pollId, optionId, answerText, createdAt, updatedAt, userId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'poll_votes';
  @override
  VerificationContext validateIntegrity(Insertable<PollVoteEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('poll_id')) {
      context.handle(_pollIdMeta,
          pollId.isAcceptableOrUnknown(data['poll_id']!, _pollIdMeta));
    }
    if (data.containsKey('option_id')) {
      context.handle(_optionIdMeta,
          optionId.isAcceptableOrUnknown(data['option_id']!, _optionIdMeta));
    }
    if (data.containsKey('answer_text')) {
      context.handle(
          _answerTextMeta,
          answerText.isAcceptableOrUnknown(
              data['answer_text']!, _answerTextMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, pollId};
  @override
  PollVoteEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PollVoteEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id']),
      pollId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}poll_id']),
      optionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}option_id']),
      answerText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer_text']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
    );
  }

  @override
  $PollVotesTable createAlias(String alias) {
    return $PollVotesTable(attachedDatabase, alias);
  }
}

class PollVoteEntity extends DataClass implements Insertable<PollVoteEntity> {
  /// The unique identifier of the poll vote.
  final String? id;

  /// The unique identifier of the poll the vote belongs to.
  final String? pollId;

  /// The unique identifier of the option selected in the poll.
  ///
  /// Nullable if the user provided an answer.
  final String? optionId;

  /// The text of the answer provided in the poll.
  ///
  /// Nullable if the user selected an option.
  final String? answerText;

  /// The date when the poll vote was created.
  final DateTime createdAt;

  /// The date when the poll vote was last updated.
  final DateTime updatedAt;

  /// The unique identifier of the user who voted.
  ///
  /// Nullable if the poll is anonymous.
  final String? userId;
  const PollVoteEntity(
      {this.id,
      this.pollId,
      this.optionId,
      this.answerText,
      required this.createdAt,
      required this.updatedAt,
      this.userId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || pollId != null) {
      map['poll_id'] = Variable<String>(pollId);
    }
    if (!nullToAbsent || optionId != null) {
      map['option_id'] = Variable<String>(optionId);
    }
    if (!nullToAbsent || answerText != null) {
      map['answer_text'] = Variable<String>(answerText);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    return map;
  }

  factory PollVoteEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PollVoteEntity(
      id: serializer.fromJson<String?>(json['id']),
      pollId: serializer.fromJson<String?>(json['pollId']),
      optionId: serializer.fromJson<String?>(json['optionId']),
      answerText: serializer.fromJson<String?>(json['answerText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      userId: serializer.fromJson<String?>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String?>(id),
      'pollId': serializer.toJson<String?>(pollId),
      'optionId': serializer.toJson<String?>(optionId),
      'answerText': serializer.toJson<String?>(answerText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'userId': serializer.toJson<String?>(userId),
    };
  }

  PollVoteEntity copyWith(
          {Value<String?> id = const Value.absent(),
          Value<String?> pollId = const Value.absent(),
          Value<String?> optionId = const Value.absent(),
          Value<String?> answerText = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<String?> userId = const Value.absent()}) =>
      PollVoteEntity(
        id: id.present ? id.value : this.id,
        pollId: pollId.present ? pollId.value : this.pollId,
        optionId: optionId.present ? optionId.value : this.optionId,
        answerText: answerText.present ? answerText.value : this.answerText,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        userId: userId.present ? userId.value : this.userId,
      );
  PollVoteEntity copyWithCompanion(PollVotesCompanion data) {
    return PollVoteEntity(
      id: data.id.present ? data.id.value : this.id,
      pollId: data.pollId.present ? data.pollId.value : this.pollId,
      optionId: data.optionId.present ? data.optionId.value : this.optionId,
      answerText:
          data.answerText.present ? data.answerText.value : this.answerText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PollVoteEntity(')
          ..write('id: $id, ')
          ..write('pollId: $pollId, ')
          ..write('optionId: $optionId, ')
          ..write('answerText: $answerText, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, pollId, optionId, answerText, createdAt, updatedAt, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PollVoteEntity &&
          other.id == this.id &&
          other.pollId == this.pollId &&
          other.optionId == this.optionId &&
          other.answerText == this.answerText &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.userId == this.userId);
}

class PollVotesCompanion extends UpdateCompanion<PollVoteEntity> {
  final Value<String?> id;
  final Value<String?> pollId;
  final Value<String?> optionId;
  final Value<String?> answerText;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> userId;
  final Value<int> rowid;
  const PollVotesCompanion({
    this.id = const Value.absent(),
    this.pollId = const Value.absent(),
    this.optionId = const Value.absent(),
    this.answerText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PollVotesCompanion.insert({
    this.id = const Value.absent(),
    this.pollId = const Value.absent(),
    this.optionId = const Value.absent(),
    this.answerText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<PollVoteEntity> custom({
    Expression<String>? id,
    Expression<String>? pollId,
    Expression<String>? optionId,
    Expression<String>? answerText,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? userId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pollId != null) 'poll_id': pollId,
      if (optionId != null) 'option_id': optionId,
      if (answerText != null) 'answer_text': answerText,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PollVotesCompanion copyWith(
      {Value<String?>? id,
      Value<String?>? pollId,
      Value<String?>? optionId,
      Value<String?>? answerText,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String?>? userId,
      Value<int>? rowid}) {
    return PollVotesCompanion(
      id: id ?? this.id,
      pollId: pollId ?? this.pollId,
      optionId: optionId ?? this.optionId,
      answerText: answerText ?? this.answerText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (pollId.present) {
      map['poll_id'] = Variable<String>(pollId.value);
    }
    if (optionId.present) {
      map['option_id'] = Variable<String>(optionId.value);
    }
    if (answerText.present) {
      map['answer_text'] = Variable<String>(answerText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PollVotesCompanion(')
          ..write('id: $id, ')
          ..write('pollId: $pollId, ')
          ..write('optionId: $optionId, ')
          ..write('answerText: $answerText, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PinnedMessageReactionsTable extends PinnedMessageReactions
    with TableInfo<$PinnedMessageReactionsTable, PinnedMessageReactionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PinnedMessageReactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageIdMeta =
      const VerificationMeta('messageId');
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
      'message_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES pinned_messages (id) ON DELETE CASCADE'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _extraDataMeta =
      const VerificationMeta('extraData');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      extraData = GeneratedColumn<String>('extra_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, dynamic>?>(
              $PinnedMessageReactionsTable.$converterextraDatan);
  @override
  List<GeneratedColumn> get $columns =>
      [userId, messageId, type, createdAt, score, extraData];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pinned_message_reactions';
  @override
  VerificationContext validateIntegrity(
      Insertable<PinnedMessageReactionEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    }
    context.handle(_extraDataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {messageId, type, userId};
  @override
  PinnedMessageReactionEntity map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PinnedMessageReactionEntity(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      messageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score'])!,
      extraData: $PinnedMessageReactionsTable.$converterextraDatan.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}extra_data'])),
    );
  }

  @override
  $PinnedMessageReactionsTable createAlias(String alias) {
    return $PinnedMessageReactionsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converterextraData =
      MapConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $converterextraDatan =
      NullAwareTypeConverter.wrap($converterextraData);
}

class PinnedMessageReactionEntity extends DataClass
    implements Insertable<PinnedMessageReactionEntity> {
  /// The id of the user that sent the reaction
  final String userId;

  /// The messageId to which the reaction belongs
  final String messageId;

  /// The type of the reaction
  final String type;

  /// The DateTime on which the reaction is created
  final DateTime createdAt;

  /// The score of the reaction (ie. number of reactions sent)
  final int score;

  /// Reaction custom extraData
  final Map<String, dynamic>? extraData;
  const PinnedMessageReactionEntity(
      {required this.userId,
      required this.messageId,
      required this.type,
      required this.createdAt,
      required this.score,
      this.extraData});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['message_id'] = Variable<String>(messageId);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['score'] = Variable<int>(score);
    if (!nullToAbsent || extraData != null) {
      map['extra_data'] = Variable<String>(
          $PinnedMessageReactionsTable.$converterextraDatan.toSql(extraData));
    }
    return map;
  }

  factory PinnedMessageReactionEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PinnedMessageReactionEntity(
      userId: serializer.fromJson<String>(json['userId']),
      messageId: serializer.fromJson<String>(json['messageId']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      score: serializer.fromJson<int>(json['score']),
      extraData: serializer.fromJson<Map<String, dynamic>?>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'messageId': serializer.toJson<String>(messageId),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'score': serializer.toJson<int>(score),
      'extraData': serializer.toJson<Map<String, dynamic>?>(extraData),
    };
  }

  PinnedMessageReactionEntity copyWith(
          {String? userId,
          String? messageId,
          String? type,
          DateTime? createdAt,
          int? score,
          Value<Map<String, dynamic>?> extraData = const Value.absent()}) =>
      PinnedMessageReactionEntity(
        userId: userId ?? this.userId,
        messageId: messageId ?? this.messageId,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        score: score ?? this.score,
        extraData: extraData.present ? extraData.value : this.extraData,
      );
  PinnedMessageReactionEntity copyWithCompanion(
      PinnedMessageReactionsCompanion data) {
    return PinnedMessageReactionEntity(
      userId: data.userId.present ? data.userId.value : this.userId,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      score: data.score.present ? data.score.value : this.score,
      extraData: data.extraData.present ? data.extraData.value : this.extraData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PinnedMessageReactionEntity(')
          ..write('userId: $userId, ')
          ..write('messageId: $messageId, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('score: $score, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, messageId, type, createdAt, score, extraData);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PinnedMessageReactionEntity &&
          other.userId == this.userId &&
          other.messageId == this.messageId &&
          other.type == this.type &&
          other.createdAt == this.createdAt &&
          other.score == this.score &&
          other.extraData == this.extraData);
}

class PinnedMessageReactionsCompanion
    extends UpdateCompanion<PinnedMessageReactionEntity> {
  final Value<String> userId;
  final Value<String> messageId;
  final Value<String> type;
  final Value<DateTime> createdAt;
  final Value<int> score;
  final Value<Map<String, dynamic>?> extraData;
  final Value<int> rowid;
  const PinnedMessageReactionsCompanion({
    this.userId = const Value.absent(),
    this.messageId = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.score = const Value.absent(),
    this.extraData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PinnedMessageReactionsCompanion.insert({
    required String userId,
    required String messageId,
    required String type,
    this.createdAt = const Value.absent(),
    this.score = const Value.absent(),
    this.extraData = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        messageId = Value(messageId),
        type = Value(type);
  static Insertable<PinnedMessageReactionEntity> custom({
    Expression<String>? userId,
    Expression<String>? messageId,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
    Expression<int>? score,
    Expression<String>? extraData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (messageId != null) 'message_id': messageId,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (score != null) 'score': score,
      if (extraData != null) 'extra_data': extraData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PinnedMessageReactionsCompanion copyWith(
      {Value<String>? userId,
      Value<String>? messageId,
      Value<String>? type,
      Value<DateTime>? createdAt,
      Value<int>? score,
      Value<Map<String, dynamic>?>? extraData,
      Value<int>? rowid}) {
    return PinnedMessageReactionsCompanion(
      userId: userId ?? this.userId,
      messageId: messageId ?? this.messageId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      score: score ?? this.score,
      extraData: extraData ?? this.extraData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
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
    if (extraData.present) {
      map['extra_data'] = Variable<String>($PinnedMessageReactionsTable
          .$converterextraDatan
          .toSql(extraData.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PinnedMessageReactionsCompanion(')
          ..write('userId: $userId, ')
          ..write('messageId: $messageId, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('score: $score, ')
          ..write('extraData: $extraData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReactionsTable extends Reactions
    with TableInfo<$ReactionsTable, ReactionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageIdMeta =
      const VerificationMeta('messageId');
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
      'message_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES messages (id) ON DELETE CASCADE'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _extraDataMeta =
      const VerificationMeta('extraData');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      extraData = GeneratedColumn<String>('extra_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, dynamic>?>(
              $ReactionsTable.$converterextraDatan);
  @override
  List<GeneratedColumn> get $columns =>
      [userId, messageId, type, createdAt, score, extraData];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reactions';
  @override
  VerificationContext validateIntegrity(Insertable<ReactionEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    }
    context.handle(_extraDataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {messageId, type, userId};
  @override
  ReactionEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReactionEntity(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      messageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score'])!,
      extraData: $ReactionsTable.$converterextraDatan.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extra_data'])),
    );
  }

  @override
  $ReactionsTable createAlias(String alias) {
    return $ReactionsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converterextraData =
      MapConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $converterextraDatan =
      NullAwareTypeConverter.wrap($converterextraData);
}

class ReactionEntity extends DataClass implements Insertable<ReactionEntity> {
  /// The id of the user that sent the reaction
  final String userId;

  /// The messageId to which the reaction belongs
  final String messageId;

  /// The type of the reaction
  final String type;

  /// The DateTime on which the reaction is created
  final DateTime createdAt;

  /// The score of the reaction (ie. number of reactions sent)
  final int score;

  /// Reaction custom extraData
  final Map<String, dynamic>? extraData;
  const ReactionEntity(
      {required this.userId,
      required this.messageId,
      required this.type,
      required this.createdAt,
      required this.score,
      this.extraData});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['message_id'] = Variable<String>(messageId);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['score'] = Variable<int>(score);
    if (!nullToAbsent || extraData != null) {
      map['extra_data'] = Variable<String>(
          $ReactionsTable.$converterextraDatan.toSql(extraData));
    }
    return map;
  }

  factory ReactionEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReactionEntity(
      userId: serializer.fromJson<String>(json['userId']),
      messageId: serializer.fromJson<String>(json['messageId']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      score: serializer.fromJson<int>(json['score']),
      extraData: serializer.fromJson<Map<String, dynamic>?>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'messageId': serializer.toJson<String>(messageId),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'score': serializer.toJson<int>(score),
      'extraData': serializer.toJson<Map<String, dynamic>?>(extraData),
    };
  }

  ReactionEntity copyWith(
          {String? userId,
          String? messageId,
          String? type,
          DateTime? createdAt,
          int? score,
          Value<Map<String, dynamic>?> extraData = const Value.absent()}) =>
      ReactionEntity(
        userId: userId ?? this.userId,
        messageId: messageId ?? this.messageId,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        score: score ?? this.score,
        extraData: extraData.present ? extraData.value : this.extraData,
      );
  ReactionEntity copyWithCompanion(ReactionsCompanion data) {
    return ReactionEntity(
      userId: data.userId.present ? data.userId.value : this.userId,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      score: data.score.present ? data.score.value : this.score,
      extraData: data.extraData.present ? data.extraData.value : this.extraData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReactionEntity(')
          ..write('userId: $userId, ')
          ..write('messageId: $messageId, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('score: $score, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, messageId, type, createdAt, score, extraData);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReactionEntity &&
          other.userId == this.userId &&
          other.messageId == this.messageId &&
          other.type == this.type &&
          other.createdAt == this.createdAt &&
          other.score == this.score &&
          other.extraData == this.extraData);
}

class ReactionsCompanion extends UpdateCompanion<ReactionEntity> {
  final Value<String> userId;
  final Value<String> messageId;
  final Value<String> type;
  final Value<DateTime> createdAt;
  final Value<int> score;
  final Value<Map<String, dynamic>?> extraData;
  final Value<int> rowid;
  const ReactionsCompanion({
    this.userId = const Value.absent(),
    this.messageId = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.score = const Value.absent(),
    this.extraData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReactionsCompanion.insert({
    required String userId,
    required String messageId,
    required String type,
    this.createdAt = const Value.absent(),
    this.score = const Value.absent(),
    this.extraData = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        messageId = Value(messageId),
        type = Value(type);
  static Insertable<ReactionEntity> custom({
    Expression<String>? userId,
    Expression<String>? messageId,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
    Expression<int>? score,
    Expression<String>? extraData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (messageId != null) 'message_id': messageId,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (score != null) 'score': score,
      if (extraData != null) 'extra_data': extraData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReactionsCompanion copyWith(
      {Value<String>? userId,
      Value<String>? messageId,
      Value<String>? type,
      Value<DateTime>? createdAt,
      Value<int>? score,
      Value<Map<String, dynamic>?>? extraData,
      Value<int>? rowid}) {
    return ReactionsCompanion(
      userId: userId ?? this.userId,
      messageId: messageId ?? this.messageId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      score: score ?? this.score,
      extraData: extraData ?? this.extraData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
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
    if (extraData.present) {
      map['extra_data'] = Variable<String>(
          $ReactionsTable.$converterextraDatan.toSql(extraData.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReactionsCompanion(')
          ..write('userId: $userId, ')
          ..write('messageId: $messageId, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('score: $score, ')
          ..write('extraData: $extraData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, UserEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastActiveMeta =
      const VerificationMeta('lastActive');
  @override
  late final GeneratedColumn<DateTime> lastActive = GeneratedColumn<DateTime>(
      'last_active', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _onlineMeta = const VerificationMeta('online');
  @override
  late final GeneratedColumn<bool> online = GeneratedColumn<bool>(
      'online', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("online" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _bannedMeta = const VerificationMeta('banned');
  @override
  late final GeneratedColumn<bool> banned = GeneratedColumn<bool>(
      'banned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("banned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _extraDataMeta =
      const VerificationMeta('extraData');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      extraData = GeneratedColumn<String>('extra_data', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>($UsersTable.$converterextraData);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        role,
        language,
        createdAt,
        updatedAt,
        lastActive,
        online,
        banned,
        extraData
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<UserEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('last_active')) {
      context.handle(
          _lastActiveMeta,
          lastActive.isAcceptableOrUnknown(
              data['last_active']!, _lastActiveMeta));
    }
    if (data.containsKey('online')) {
      context.handle(_onlineMeta,
          online.isAcceptableOrUnknown(data['online']!, _onlineMeta));
    }
    if (data.containsKey('banned')) {
      context.handle(_bannedMeta,
          banned.isAcceptableOrUnknown(data['banned']!, _bannedMeta));
    }
    context.handle(_extraDataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role']),
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      lastActive: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_active']),
      online: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}online'])!,
      banned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}banned'])!,
      extraData: $UsersTable.$converterextraData.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extra_data'])!),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converterextraData =
      MapConverter();
}

class UserEntity extends DataClass implements Insertable<UserEntity> {
  /// User id
  final String id;

  /// User role
  final String? role;

  /// The language this user prefers.
  final String? language;

  /// Date of user creation
  final DateTime? createdAt;

  /// Date of last user update
  final DateTime? updatedAt;

  /// Date of last user connection
  final DateTime? lastActive;

  /// True if user is online
  final bool online;

  /// True if user is banned from the chat
  final bool banned;

  /// Map of custom user extraData
  final Map<String, dynamic> extraData;
  const UserEntity(
      {required this.id,
      this.role,
      this.language,
      this.createdAt,
      this.updatedAt,
      this.lastActive,
      required this.online,
      required this.banned,
      required this.extraData});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || role != null) {
      map['role'] = Variable<String>(role);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
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
    map['online'] = Variable<bool>(online);
    map['banned'] = Variable<bool>(banned);
    {
      map['extra_data'] =
          Variable<String>($UsersTable.$converterextraData.toSql(extraData));
    }
    return map;
  }

  factory UserEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserEntity(
      id: serializer.fromJson<String>(json['id']),
      role: serializer.fromJson<String?>(json['role']),
      language: serializer.fromJson<String?>(json['language']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      lastActive: serializer.fromJson<DateTime?>(json['lastActive']),
      online: serializer.fromJson<bool>(json['online']),
      banned: serializer.fromJson<bool>(json['banned']),
      extraData: serializer.fromJson<Map<String, dynamic>>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'role': serializer.toJson<String?>(role),
      'language': serializer.toJson<String?>(language),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'lastActive': serializer.toJson<DateTime?>(lastActive),
      'online': serializer.toJson<bool>(online),
      'banned': serializer.toJson<bool>(banned),
      'extraData': serializer.toJson<Map<String, dynamic>>(extraData),
    };
  }

  UserEntity copyWith(
          {String? id,
          Value<String?> role = const Value.absent(),
          Value<String?> language = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<DateTime?> lastActive = const Value.absent(),
          bool? online,
          bool? banned,
          Map<String, dynamic>? extraData}) =>
      UserEntity(
        id: id ?? this.id,
        role: role.present ? role.value : this.role,
        language: language.present ? language.value : this.language,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        lastActive: lastActive.present ? lastActive.value : this.lastActive,
        online: online ?? this.online,
        banned: banned ?? this.banned,
        extraData: extraData ?? this.extraData,
      );
  UserEntity copyWithCompanion(UsersCompanion data) {
    return UserEntity(
      id: data.id.present ? data.id.value : this.id,
      role: data.role.present ? data.role.value : this.role,
      language: data.language.present ? data.language.value : this.language,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastActive:
          data.lastActive.present ? data.lastActive.value : this.lastActive,
      online: data.online.present ? data.online.value : this.online,
      banned: data.banned.present ? data.banned.value : this.banned,
      extraData: data.extraData.present ? data.extraData.value : this.extraData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserEntity(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('language: $language, ')
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
  int get hashCode => Object.hash(id, role, language, createdAt, updatedAt,
      lastActive, online, banned, extraData);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserEntity &&
          other.id == this.id &&
          other.role == this.role &&
          other.language == this.language &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastActive == this.lastActive &&
          other.online == this.online &&
          other.banned == this.banned &&
          other.extraData == this.extraData);
}

class UsersCompanion extends UpdateCompanion<UserEntity> {
  final Value<String> id;
  final Value<String?> role;
  final Value<String?> language;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> lastActive;
  final Value<bool> online;
  final Value<bool> banned;
  final Value<Map<String, dynamic>> extraData;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.role = const Value.absent(),
    this.language = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastActive = const Value.absent(),
    this.online = const Value.absent(),
    this.banned = const Value.absent(),
    this.extraData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    this.role = const Value.absent(),
    this.language = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastActive = const Value.absent(),
    this.online = const Value.absent(),
    this.banned = const Value.absent(),
    required Map<String, dynamic> extraData,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        extraData = Value(extraData);
  static Insertable<UserEntity> custom({
    Expression<String>? id,
    Expression<String>? role,
    Expression<String>? language,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastActive,
    Expression<bool>? online,
    Expression<bool>? banned,
    Expression<String>? extraData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (role != null) 'role': role,
      if (language != null) 'language': language,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastActive != null) 'last_active': lastActive,
      if (online != null) 'online': online,
      if (banned != null) 'banned': banned,
      if (extraData != null) 'extra_data': extraData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String?>? role,
      Value<String?>? language,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<DateTime?>? lastActive,
      Value<bool>? online,
      Value<bool>? banned,
      Value<Map<String, dynamic>>? extraData,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      role: role ?? this.role,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastActive: lastActive ?? this.lastActive,
      online: online ?? this.online,
      banned: banned ?? this.banned,
      extraData: extraData ?? this.extraData,
      rowid: rowid ?? this.rowid,
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
    if (language.present) {
      map['language'] = Variable<String>(language.value);
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
      map['extra_data'] = Variable<String>(
          $UsersTable.$converterextraData.toSql(extraData.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('language: $language, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastActive: $lastActive, ')
          ..write('online: $online, ')
          ..write('banned: $banned, ')
          ..write('extraData: $extraData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MembersTable extends Members
    with TableInfo<$MembersTable, MemberEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _channelCidMeta =
      const VerificationMeta('channelCid');
  @override
  late final GeneratedColumn<String> channelCid = GeneratedColumn<String>(
      'channel_cid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES channels (cid) ON DELETE CASCADE'));
  static const VerificationMeta _channelRoleMeta =
      const VerificationMeta('channelRole');
  @override
  late final GeneratedColumn<String> channelRole = GeneratedColumn<String>(
      'channel_role', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _inviteAcceptedAtMeta =
      const VerificationMeta('inviteAcceptedAt');
  @override
  late final GeneratedColumn<DateTime> inviteAcceptedAt =
      GeneratedColumn<DateTime>('invite_accepted_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _inviteRejectedAtMeta =
      const VerificationMeta('inviteRejectedAt');
  @override
  late final GeneratedColumn<DateTime> inviteRejectedAt =
      GeneratedColumn<DateTime>('invite_rejected_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _invitedMeta =
      const VerificationMeta('invited');
  @override
  late final GeneratedColumn<bool> invited = GeneratedColumn<bool>(
      'invited', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("invited" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _bannedMeta = const VerificationMeta('banned');
  @override
  late final GeneratedColumn<bool> banned = GeneratedColumn<bool>(
      'banned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("banned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _shadowBannedMeta =
      const VerificationMeta('shadowBanned');
  @override
  late final GeneratedColumn<bool> shadowBanned = GeneratedColumn<bool>(
      'shadow_banned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("shadow_banned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isModeratorMeta =
      const VerificationMeta('isModerator');
  @override
  late final GeneratedColumn<bool> isModerator = GeneratedColumn<bool>(
      'is_moderator', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_moderator" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _extraDataMeta =
      const VerificationMeta('extraData');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      extraData = GeneratedColumn<String>('extra_data', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, dynamic>?>(
              $MembersTable.$converterextraDatan);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        userId,
        channelCid,
        channelRole,
        inviteAcceptedAt,
        inviteRejectedAt,
        invited,
        banned,
        shadowBanned,
        isModerator,
        extraData,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'members';
  @override
  VerificationContext validateIntegrity(Insertable<MemberEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('channel_cid')) {
      context.handle(
          _channelCidMeta,
          channelCid.isAcceptableOrUnknown(
              data['channel_cid']!, _channelCidMeta));
    } else if (isInserting) {
      context.missing(_channelCidMeta);
    }
    if (data.containsKey('channel_role')) {
      context.handle(
          _channelRoleMeta,
          channelRole.isAcceptableOrUnknown(
              data['channel_role']!, _channelRoleMeta));
    }
    if (data.containsKey('invite_accepted_at')) {
      context.handle(
          _inviteAcceptedAtMeta,
          inviteAcceptedAt.isAcceptableOrUnknown(
              data['invite_accepted_at']!, _inviteAcceptedAtMeta));
    }
    if (data.containsKey('invite_rejected_at')) {
      context.handle(
          _inviteRejectedAtMeta,
          inviteRejectedAt.isAcceptableOrUnknown(
              data['invite_rejected_at']!, _inviteRejectedAtMeta));
    }
    if (data.containsKey('invited')) {
      context.handle(_invitedMeta,
          invited.isAcceptableOrUnknown(data['invited']!, _invitedMeta));
    }
    if (data.containsKey('banned')) {
      context.handle(_bannedMeta,
          banned.isAcceptableOrUnknown(data['banned']!, _bannedMeta));
    }
    if (data.containsKey('shadow_banned')) {
      context.handle(
          _shadowBannedMeta,
          shadowBanned.isAcceptableOrUnknown(
              data['shadow_banned']!, _shadowBannedMeta));
    }
    if (data.containsKey('is_moderator')) {
      context.handle(
          _isModeratorMeta,
          isModerator.isAcceptableOrUnknown(
              data['is_moderator']!, _isModeratorMeta));
    }
    context.handle(_extraDataMeta, const VerificationResult.success());
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, channelCid};
  @override
  MemberEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemberEntity(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      channelCid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}channel_cid'])!,
      channelRole: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}channel_role']),
      inviteAcceptedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}invite_accepted_at']),
      inviteRejectedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}invite_rejected_at']),
      invited: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}invited'])!,
      banned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}banned'])!,
      shadowBanned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}shadow_banned'])!,
      isModerator: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_moderator'])!,
      extraData: $MembersTable.$converterextraDatan.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extra_data'])),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MembersTable createAlias(String alias) {
    return $MembersTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converterextraData =
      MapConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $converterextraDatan =
      NullAwareTypeConverter.wrap($converterextraData);
}

class MemberEntity extends DataClass implements Insertable<MemberEntity> {
  /// The interested user id
  final String userId;

  /// The channel cid of which this user is part of
  final String channelCid;

  /// The role of the user in the channel
  final String? channelRole;

  /// The date on which the user accepted the invite to the channel
  final DateTime? inviteAcceptedAt;

  /// The date on which the user rejected the invite to the channel
  final DateTime? inviteRejectedAt;

  /// True if the user has been invited to the channel
  final bool invited;

  /// True if the member is banned from the channel
  final bool banned;

  /// True if the member is shadow banned from the channel
  final bool shadowBanned;

  /// True if the user is a moderator of the channel
  final bool isModerator;

  /// Map of custom member extraData
  final Map<String, dynamic>? extraData;

  /// The date of creation
  final DateTime createdAt;

  /// The last date of update
  final DateTime updatedAt;
  const MemberEntity(
      {required this.userId,
      required this.channelCid,
      this.channelRole,
      this.inviteAcceptedAt,
      this.inviteRejectedAt,
      required this.invited,
      required this.banned,
      required this.shadowBanned,
      required this.isModerator,
      this.extraData,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['channel_cid'] = Variable<String>(channelCid);
    if (!nullToAbsent || channelRole != null) {
      map['channel_role'] = Variable<String>(channelRole);
    }
    if (!nullToAbsent || inviteAcceptedAt != null) {
      map['invite_accepted_at'] = Variable<DateTime>(inviteAcceptedAt);
    }
    if (!nullToAbsent || inviteRejectedAt != null) {
      map['invite_rejected_at'] = Variable<DateTime>(inviteRejectedAt);
    }
    map['invited'] = Variable<bool>(invited);
    map['banned'] = Variable<bool>(banned);
    map['shadow_banned'] = Variable<bool>(shadowBanned);
    map['is_moderator'] = Variable<bool>(isModerator);
    if (!nullToAbsent || extraData != null) {
      map['extra_data'] =
          Variable<String>($MembersTable.$converterextraDatan.toSql(extraData));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  factory MemberEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemberEntity(
      userId: serializer.fromJson<String>(json['userId']),
      channelCid: serializer.fromJson<String>(json['channelCid']),
      channelRole: serializer.fromJson<String?>(json['channelRole']),
      inviteAcceptedAt:
          serializer.fromJson<DateTime?>(json['inviteAcceptedAt']),
      inviteRejectedAt:
          serializer.fromJson<DateTime?>(json['inviteRejectedAt']),
      invited: serializer.fromJson<bool>(json['invited']),
      banned: serializer.fromJson<bool>(json['banned']),
      shadowBanned: serializer.fromJson<bool>(json['shadowBanned']),
      isModerator: serializer.fromJson<bool>(json['isModerator']),
      extraData: serializer.fromJson<Map<String, dynamic>?>(json['extraData']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'channelCid': serializer.toJson<String>(channelCid),
      'channelRole': serializer.toJson<String?>(channelRole),
      'inviteAcceptedAt': serializer.toJson<DateTime?>(inviteAcceptedAt),
      'inviteRejectedAt': serializer.toJson<DateTime?>(inviteRejectedAt),
      'invited': serializer.toJson<bool>(invited),
      'banned': serializer.toJson<bool>(banned),
      'shadowBanned': serializer.toJson<bool>(shadowBanned),
      'isModerator': serializer.toJson<bool>(isModerator),
      'extraData': serializer.toJson<Map<String, dynamic>?>(extraData),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MemberEntity copyWith(
          {String? userId,
          String? channelCid,
          Value<String?> channelRole = const Value.absent(),
          Value<DateTime?> inviteAcceptedAt = const Value.absent(),
          Value<DateTime?> inviteRejectedAt = const Value.absent(),
          bool? invited,
          bool? banned,
          bool? shadowBanned,
          bool? isModerator,
          Value<Map<String, dynamic>?> extraData = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MemberEntity(
        userId: userId ?? this.userId,
        channelCid: channelCid ?? this.channelCid,
        channelRole: channelRole.present ? channelRole.value : this.channelRole,
        inviteAcceptedAt: inviteAcceptedAt.present
            ? inviteAcceptedAt.value
            : this.inviteAcceptedAt,
        inviteRejectedAt: inviteRejectedAt.present
            ? inviteRejectedAt.value
            : this.inviteRejectedAt,
        invited: invited ?? this.invited,
        banned: banned ?? this.banned,
        shadowBanned: shadowBanned ?? this.shadowBanned,
        isModerator: isModerator ?? this.isModerator,
        extraData: extraData.present ? extraData.value : this.extraData,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MemberEntity copyWithCompanion(MembersCompanion data) {
    return MemberEntity(
      userId: data.userId.present ? data.userId.value : this.userId,
      channelCid:
          data.channelCid.present ? data.channelCid.value : this.channelCid,
      channelRole:
          data.channelRole.present ? data.channelRole.value : this.channelRole,
      inviteAcceptedAt: data.inviteAcceptedAt.present
          ? data.inviteAcceptedAt.value
          : this.inviteAcceptedAt,
      inviteRejectedAt: data.inviteRejectedAt.present
          ? data.inviteRejectedAt.value
          : this.inviteRejectedAt,
      invited: data.invited.present ? data.invited.value : this.invited,
      banned: data.banned.present ? data.banned.value : this.banned,
      shadowBanned: data.shadowBanned.present
          ? data.shadowBanned.value
          : this.shadowBanned,
      isModerator:
          data.isModerator.present ? data.isModerator.value : this.isModerator,
      extraData: data.extraData.present ? data.extraData.value : this.extraData,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemberEntity(')
          ..write('userId: $userId, ')
          ..write('channelCid: $channelCid, ')
          ..write('channelRole: $channelRole, ')
          ..write('inviteAcceptedAt: $inviteAcceptedAt, ')
          ..write('inviteRejectedAt: $inviteRejectedAt, ')
          ..write('invited: $invited, ')
          ..write('banned: $banned, ')
          ..write('shadowBanned: $shadowBanned, ')
          ..write('isModerator: $isModerator, ')
          ..write('extraData: $extraData, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      userId,
      channelCid,
      channelRole,
      inviteAcceptedAt,
      inviteRejectedAt,
      invited,
      banned,
      shadowBanned,
      isModerator,
      extraData,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemberEntity &&
          other.userId == this.userId &&
          other.channelCid == this.channelCid &&
          other.channelRole == this.channelRole &&
          other.inviteAcceptedAt == this.inviteAcceptedAt &&
          other.inviteRejectedAt == this.inviteRejectedAt &&
          other.invited == this.invited &&
          other.banned == this.banned &&
          other.shadowBanned == this.shadowBanned &&
          other.isModerator == this.isModerator &&
          other.extraData == this.extraData &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MembersCompanion extends UpdateCompanion<MemberEntity> {
  final Value<String> userId;
  final Value<String> channelCid;
  final Value<String?> channelRole;
  final Value<DateTime?> inviteAcceptedAt;
  final Value<DateTime?> inviteRejectedAt;
  final Value<bool> invited;
  final Value<bool> banned;
  final Value<bool> shadowBanned;
  final Value<bool> isModerator;
  final Value<Map<String, dynamic>?> extraData;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MembersCompanion({
    this.userId = const Value.absent(),
    this.channelCid = const Value.absent(),
    this.channelRole = const Value.absent(),
    this.inviteAcceptedAt = const Value.absent(),
    this.inviteRejectedAt = const Value.absent(),
    this.invited = const Value.absent(),
    this.banned = const Value.absent(),
    this.shadowBanned = const Value.absent(),
    this.isModerator = const Value.absent(),
    this.extraData = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MembersCompanion.insert({
    required String userId,
    required String channelCid,
    this.channelRole = const Value.absent(),
    this.inviteAcceptedAt = const Value.absent(),
    this.inviteRejectedAt = const Value.absent(),
    this.invited = const Value.absent(),
    this.banned = const Value.absent(),
    this.shadowBanned = const Value.absent(),
    this.isModerator = const Value.absent(),
    this.extraData = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        channelCid = Value(channelCid);
  static Insertable<MemberEntity> custom({
    Expression<String>? userId,
    Expression<String>? channelCid,
    Expression<String>? channelRole,
    Expression<DateTime>? inviteAcceptedAt,
    Expression<DateTime>? inviteRejectedAt,
    Expression<bool>? invited,
    Expression<bool>? banned,
    Expression<bool>? shadowBanned,
    Expression<bool>? isModerator,
    Expression<String>? extraData,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (channelCid != null) 'channel_cid': channelCid,
      if (channelRole != null) 'channel_role': channelRole,
      if (inviteAcceptedAt != null) 'invite_accepted_at': inviteAcceptedAt,
      if (inviteRejectedAt != null) 'invite_rejected_at': inviteRejectedAt,
      if (invited != null) 'invited': invited,
      if (banned != null) 'banned': banned,
      if (shadowBanned != null) 'shadow_banned': shadowBanned,
      if (isModerator != null) 'is_moderator': isModerator,
      if (extraData != null) 'extra_data': extraData,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MembersCompanion copyWith(
      {Value<String>? userId,
      Value<String>? channelCid,
      Value<String?>? channelRole,
      Value<DateTime?>? inviteAcceptedAt,
      Value<DateTime?>? inviteRejectedAt,
      Value<bool>? invited,
      Value<bool>? banned,
      Value<bool>? shadowBanned,
      Value<bool>? isModerator,
      Value<Map<String, dynamic>?>? extraData,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return MembersCompanion(
      userId: userId ?? this.userId,
      channelCid: channelCid ?? this.channelCid,
      channelRole: channelRole ?? this.channelRole,
      inviteAcceptedAt: inviteAcceptedAt ?? this.inviteAcceptedAt,
      inviteRejectedAt: inviteRejectedAt ?? this.inviteRejectedAt,
      invited: invited ?? this.invited,
      banned: banned ?? this.banned,
      shadowBanned: shadowBanned ?? this.shadowBanned,
      isModerator: isModerator ?? this.isModerator,
      extraData: extraData ?? this.extraData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
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
    if (channelRole.present) {
      map['channel_role'] = Variable<String>(channelRole.value);
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
    if (extraData.present) {
      map['extra_data'] = Variable<String>(
          $MembersTable.$converterextraDatan.toSql(extraData.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MembersCompanion(')
          ..write('userId: $userId, ')
          ..write('channelCid: $channelCid, ')
          ..write('channelRole: $channelRole, ')
          ..write('inviteAcceptedAt: $inviteAcceptedAt, ')
          ..write('inviteRejectedAt: $inviteRejectedAt, ')
          ..write('invited: $invited, ')
          ..write('banned: $banned, ')
          ..write('shadowBanned: $shadowBanned, ')
          ..write('isModerator: $isModerator, ')
          ..write('extraData: $extraData, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadsTable extends Reads with TableInfo<$ReadsTable, ReadEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lastReadMeta =
      const VerificationMeta('lastRead');
  @override
  late final GeneratedColumn<DateTime> lastRead = GeneratedColumn<DateTime>(
      'last_read', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _channelCidMeta =
      const VerificationMeta('channelCid');
  @override
  late final GeneratedColumn<String> channelCid = GeneratedColumn<String>(
      'channel_cid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES channels (cid) ON DELETE CASCADE'));
  static const VerificationMeta _unreadMessagesMeta =
      const VerificationMeta('unreadMessages');
  @override
  late final GeneratedColumn<int> unreadMessages = GeneratedColumn<int>(
      'unread_messages', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastReadMessageIdMeta =
      const VerificationMeta('lastReadMessageId');
  @override
  late final GeneratedColumn<String> lastReadMessageId =
      GeneratedColumn<String>('last_read_message_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [lastRead, userId, channelCid, unreadMessages, lastReadMessageId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reads';
  @override
  VerificationContext validateIntegrity(Insertable<ReadEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('last_read')) {
      context.handle(_lastReadMeta,
          lastRead.isAcceptableOrUnknown(data['last_read']!, _lastReadMeta));
    } else if (isInserting) {
      context.missing(_lastReadMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('channel_cid')) {
      context.handle(
          _channelCidMeta,
          channelCid.isAcceptableOrUnknown(
              data['channel_cid']!, _channelCidMeta));
    } else if (isInserting) {
      context.missing(_channelCidMeta);
    }
    if (data.containsKey('unread_messages')) {
      context.handle(
          _unreadMessagesMeta,
          unreadMessages.isAcceptableOrUnknown(
              data['unread_messages']!, _unreadMessagesMeta));
    }
    if (data.containsKey('last_read_message_id')) {
      context.handle(
          _lastReadMessageIdMeta,
          lastReadMessageId.isAcceptableOrUnknown(
              data['last_read_message_id']!, _lastReadMessageIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, channelCid};
  @override
  ReadEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadEntity(
      lastRead: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_read'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      channelCid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}channel_cid'])!,
      unreadMessages: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unread_messages'])!,
      lastReadMessageId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_read_message_id']),
    );
  }

  @override
  $ReadsTable createAlias(String alias) {
    return $ReadsTable(attachedDatabase, alias);
  }
}

class ReadEntity extends DataClass implements Insertable<ReadEntity> {
  /// Date of the read event
  final DateTime lastRead;

  /// Id of the User who sent the event
  final String userId;

  /// The channel cid of which this read belongs
  final String channelCid;

  /// Number of unread messages
  final int unreadMessages;

  /// Id of the last read message
  final String? lastReadMessageId;
  const ReadEntity(
      {required this.lastRead,
      required this.userId,
      required this.channelCid,
      required this.unreadMessages,
      this.lastReadMessageId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['last_read'] = Variable<DateTime>(lastRead);
    map['user_id'] = Variable<String>(userId);
    map['channel_cid'] = Variable<String>(channelCid);
    map['unread_messages'] = Variable<int>(unreadMessages);
    if (!nullToAbsent || lastReadMessageId != null) {
      map['last_read_message_id'] = Variable<String>(lastReadMessageId);
    }
    return map;
  }

  factory ReadEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadEntity(
      lastRead: serializer.fromJson<DateTime>(json['lastRead']),
      userId: serializer.fromJson<String>(json['userId']),
      channelCid: serializer.fromJson<String>(json['channelCid']),
      unreadMessages: serializer.fromJson<int>(json['unreadMessages']),
      lastReadMessageId:
          serializer.fromJson<String?>(json['lastReadMessageId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lastRead': serializer.toJson<DateTime>(lastRead),
      'userId': serializer.toJson<String>(userId),
      'channelCid': serializer.toJson<String>(channelCid),
      'unreadMessages': serializer.toJson<int>(unreadMessages),
      'lastReadMessageId': serializer.toJson<String?>(lastReadMessageId),
    };
  }

  ReadEntity copyWith(
          {DateTime? lastRead,
          String? userId,
          String? channelCid,
          int? unreadMessages,
          Value<String?> lastReadMessageId = const Value.absent()}) =>
      ReadEntity(
        lastRead: lastRead ?? this.lastRead,
        userId: userId ?? this.userId,
        channelCid: channelCid ?? this.channelCid,
        unreadMessages: unreadMessages ?? this.unreadMessages,
        lastReadMessageId: lastReadMessageId.present
            ? lastReadMessageId.value
            : this.lastReadMessageId,
      );
  ReadEntity copyWithCompanion(ReadsCompanion data) {
    return ReadEntity(
      lastRead: data.lastRead.present ? data.lastRead.value : this.lastRead,
      userId: data.userId.present ? data.userId.value : this.userId,
      channelCid:
          data.channelCid.present ? data.channelCid.value : this.channelCid,
      unreadMessages: data.unreadMessages.present
          ? data.unreadMessages.value
          : this.unreadMessages,
      lastReadMessageId: data.lastReadMessageId.present
          ? data.lastReadMessageId.value
          : this.lastReadMessageId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadEntity(')
          ..write('lastRead: $lastRead, ')
          ..write('userId: $userId, ')
          ..write('channelCid: $channelCid, ')
          ..write('unreadMessages: $unreadMessages, ')
          ..write('lastReadMessageId: $lastReadMessageId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      lastRead, userId, channelCid, unreadMessages, lastReadMessageId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadEntity &&
          other.lastRead == this.lastRead &&
          other.userId == this.userId &&
          other.channelCid == this.channelCid &&
          other.unreadMessages == this.unreadMessages &&
          other.lastReadMessageId == this.lastReadMessageId);
}

class ReadsCompanion extends UpdateCompanion<ReadEntity> {
  final Value<DateTime> lastRead;
  final Value<String> userId;
  final Value<String> channelCid;
  final Value<int> unreadMessages;
  final Value<String?> lastReadMessageId;
  final Value<int> rowid;
  const ReadsCompanion({
    this.lastRead = const Value.absent(),
    this.userId = const Value.absent(),
    this.channelCid = const Value.absent(),
    this.unreadMessages = const Value.absent(),
    this.lastReadMessageId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadsCompanion.insert({
    required DateTime lastRead,
    required String userId,
    required String channelCid,
    this.unreadMessages = const Value.absent(),
    this.lastReadMessageId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : lastRead = Value(lastRead),
        userId = Value(userId),
        channelCid = Value(channelCid);
  static Insertable<ReadEntity> custom({
    Expression<DateTime>? lastRead,
    Expression<String>? userId,
    Expression<String>? channelCid,
    Expression<int>? unreadMessages,
    Expression<String>? lastReadMessageId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lastRead != null) 'last_read': lastRead,
      if (userId != null) 'user_id': userId,
      if (channelCid != null) 'channel_cid': channelCid,
      if (unreadMessages != null) 'unread_messages': unreadMessages,
      if (lastReadMessageId != null) 'last_read_message_id': lastReadMessageId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadsCompanion copyWith(
      {Value<DateTime>? lastRead,
      Value<String>? userId,
      Value<String>? channelCid,
      Value<int>? unreadMessages,
      Value<String?>? lastReadMessageId,
      Value<int>? rowid}) {
    return ReadsCompanion(
      lastRead: lastRead ?? this.lastRead,
      userId: userId ?? this.userId,
      channelCid: channelCid ?? this.channelCid,
      unreadMessages: unreadMessages ?? this.unreadMessages,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
      rowid: rowid ?? this.rowid,
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
    if (lastReadMessageId.present) {
      map['last_read_message_id'] = Variable<String>(lastReadMessageId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadsCompanion(')
          ..write('lastRead: $lastRead, ')
          ..write('userId: $userId, ')
          ..write('channelCid: $channelCid, ')
          ..write('unreadMessages: $unreadMessages, ')
          ..write('lastReadMessageId: $lastReadMessageId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelQueriesTable extends ChannelQueries
    with TableInfo<$ChannelQueriesTable, ChannelQueryEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelQueriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _queryHashMeta =
      const VerificationMeta('queryHash');
  @override
  late final GeneratedColumn<String> queryHash = GeneratedColumn<String>(
      'query_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _channelCidMeta =
      const VerificationMeta('channelCid');
  @override
  late final GeneratedColumn<String> channelCid = GeneratedColumn<String>(
      'channel_cid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [queryHash, channelCid];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_queries';
  @override
  VerificationContext validateIntegrity(Insertable<ChannelQueryEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('query_hash')) {
      context.handle(_queryHashMeta,
          queryHash.isAcceptableOrUnknown(data['query_hash']!, _queryHashMeta));
    } else if (isInserting) {
      context.missing(_queryHashMeta);
    }
    if (data.containsKey('channel_cid')) {
      context.handle(
          _channelCidMeta,
          channelCid.isAcceptableOrUnknown(
              data['channel_cid']!, _channelCidMeta));
    } else if (isInserting) {
      context.missing(_channelCidMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {queryHash, channelCid};
  @override
  ChannelQueryEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelQueryEntity(
      queryHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}query_hash'])!,
      channelCid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}channel_cid'])!,
    );
  }

  @override
  $ChannelQueriesTable createAlias(String alias) {
    return $ChannelQueriesTable(attachedDatabase, alias);
  }
}

class ChannelQueryEntity extends DataClass
    implements Insertable<ChannelQueryEntity> {
  /// The unique hash of this query
  final String queryHash;

  /// The channel cid of this query
  final String channelCid;
  const ChannelQueryEntity({required this.queryHash, required this.channelCid});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['query_hash'] = Variable<String>(queryHash);
    map['channel_cid'] = Variable<String>(channelCid);
    return map;
  }

  factory ChannelQueryEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelQueryEntity(
      queryHash: serializer.fromJson<String>(json['queryHash']),
      channelCid: serializer.fromJson<String>(json['channelCid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'queryHash': serializer.toJson<String>(queryHash),
      'channelCid': serializer.toJson<String>(channelCid),
    };
  }

  ChannelQueryEntity copyWith({String? queryHash, String? channelCid}) =>
      ChannelQueryEntity(
        queryHash: queryHash ?? this.queryHash,
        channelCid: channelCid ?? this.channelCid,
      );
  ChannelQueryEntity copyWithCompanion(ChannelQueriesCompanion data) {
    return ChannelQueryEntity(
      queryHash: data.queryHash.present ? data.queryHash.value : this.queryHash,
      channelCid:
          data.channelCid.present ? data.channelCid.value : this.channelCid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelQueryEntity(')
          ..write('queryHash: $queryHash, ')
          ..write('channelCid: $channelCid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(queryHash, channelCid);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelQueryEntity &&
          other.queryHash == this.queryHash &&
          other.channelCid == this.channelCid);
}

class ChannelQueriesCompanion extends UpdateCompanion<ChannelQueryEntity> {
  final Value<String> queryHash;
  final Value<String> channelCid;
  final Value<int> rowid;
  const ChannelQueriesCompanion({
    this.queryHash = const Value.absent(),
    this.channelCid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelQueriesCompanion.insert({
    required String queryHash,
    required String channelCid,
    this.rowid = const Value.absent(),
  })  : queryHash = Value(queryHash),
        channelCid = Value(channelCid);
  static Insertable<ChannelQueryEntity> custom({
    Expression<String>? queryHash,
    Expression<String>? channelCid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (queryHash != null) 'query_hash': queryHash,
      if (channelCid != null) 'channel_cid': channelCid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelQueriesCompanion copyWith(
      {Value<String>? queryHash,
      Value<String>? channelCid,
      Value<int>? rowid}) {
    return ChannelQueriesCompanion(
      queryHash: queryHash ?? this.queryHash,
      channelCid: channelCid ?? this.channelCid,
      rowid: rowid ?? this.rowid,
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelQueriesCompanion(')
          ..write('queryHash: $queryHash, ')
          ..write('channelCid: $channelCid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConnectionEventsTable extends ConnectionEvents
    with TableInfo<$ConnectionEventsTable, ConnectionEventEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConnectionEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownUserMeta =
      const VerificationMeta('ownUser');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      ownUser = GeneratedColumn<String>('own_user', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, dynamic>?>(
              $ConnectionEventsTable.$converterownUsern);
  static const VerificationMeta _totalUnreadCountMeta =
      const VerificationMeta('totalUnreadCount');
  @override
  late final GeneratedColumn<int> totalUnreadCount = GeneratedColumn<int>(
      'total_unread_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _unreadChannelsMeta =
      const VerificationMeta('unreadChannels');
  @override
  late final GeneratedColumn<int> unreadChannels = GeneratedColumn<int>(
      'unread_channels', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastEventAtMeta =
      const VerificationMeta('lastEventAt');
  @override
  late final GeneratedColumn<DateTime> lastEventAt = GeneratedColumn<DateTime>(
      'last_event_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncAtMeta =
      const VerificationMeta('lastSyncAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
      'last_sync_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        type,
        ownUser,
        totalUnreadCount,
        unreadChannels,
        lastEventAt,
        lastSyncAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'connection_events';
  @override
  VerificationContext validateIntegrity(
      Insertable<ConnectionEventEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    context.handle(_ownUserMeta, const VerificationResult.success());
    if (data.containsKey('total_unread_count')) {
      context.handle(
          _totalUnreadCountMeta,
          totalUnreadCount.isAcceptableOrUnknown(
              data['total_unread_count']!, _totalUnreadCountMeta));
    }
    if (data.containsKey('unread_channels')) {
      context.handle(
          _unreadChannelsMeta,
          unreadChannels.isAcceptableOrUnknown(
              data['unread_channels']!, _unreadChannelsMeta));
    }
    if (data.containsKey('last_event_at')) {
      context.handle(
          _lastEventAtMeta,
          lastEventAt.isAcceptableOrUnknown(
              data['last_event_at']!, _lastEventAtMeta));
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
          _lastSyncAtMeta,
          lastSyncAt.isAcceptableOrUnknown(
              data['last_sync_at']!, _lastSyncAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConnectionEventEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConnectionEventEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      ownUser: $ConnectionEventsTable.$converterownUsern.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}own_user'])),
      totalUnreadCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_unread_count']),
      unreadChannels: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unread_channels']),
      lastEventAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_event_at']),
      lastSyncAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_sync_at']),
    );
  }

  @override
  $ConnectionEventsTable createAlias(String alias) {
    return $ConnectionEventsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converterownUser =
      MapConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $converterownUsern =
      NullAwareTypeConverter.wrap($converterownUser);
}

class ConnectionEventEntity extends DataClass
    implements Insertable<ConnectionEventEntity> {
  /// event id
  final int id;

  /// event type
  final String type;

  /// User object of the current user
  final Map<String, dynamic>? ownUser;

  /// The number of unread messages for current user
  final int? totalUnreadCount;

  /// User total unread channels for current user
  final int? unreadChannels;

  /// DateTime of the last event
  final DateTime? lastEventAt;

  /// DateTime of the last sync
  final DateTime? lastSyncAt;
  const ConnectionEventEntity(
      {required this.id,
      required this.type,
      this.ownUser,
      this.totalUnreadCount,
      this.unreadChannels,
      this.lastEventAt,
      this.lastSyncAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || ownUser != null) {
      map['own_user'] = Variable<String>(
          $ConnectionEventsTable.$converterownUsern.toSql(ownUser));
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

  factory ConnectionEventEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConnectionEventEntity(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      ownUser: serializer.fromJson<Map<String, dynamic>?>(json['ownUser']),
      totalUnreadCount: serializer.fromJson<int?>(json['totalUnreadCount']),
      unreadChannels: serializer.fromJson<int?>(json['unreadChannels']),
      lastEventAt: serializer.fromJson<DateTime?>(json['lastEventAt']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'ownUser': serializer.toJson<Map<String, dynamic>?>(ownUser),
      'totalUnreadCount': serializer.toJson<int?>(totalUnreadCount),
      'unreadChannels': serializer.toJson<int?>(unreadChannels),
      'lastEventAt': serializer.toJson<DateTime?>(lastEventAt),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
    };
  }

  ConnectionEventEntity copyWith(
          {int? id,
          String? type,
          Value<Map<String, dynamic>?> ownUser = const Value.absent(),
          Value<int?> totalUnreadCount = const Value.absent(),
          Value<int?> unreadChannels = const Value.absent(),
          Value<DateTime?> lastEventAt = const Value.absent(),
          Value<DateTime?> lastSyncAt = const Value.absent()}) =>
      ConnectionEventEntity(
        id: id ?? this.id,
        type: type ?? this.type,
        ownUser: ownUser.present ? ownUser.value : this.ownUser,
        totalUnreadCount: totalUnreadCount.present
            ? totalUnreadCount.value
            : this.totalUnreadCount,
        unreadChannels:
            unreadChannels.present ? unreadChannels.value : this.unreadChannels,
        lastEventAt: lastEventAt.present ? lastEventAt.value : this.lastEventAt,
        lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
      );
  ConnectionEventEntity copyWithCompanion(ConnectionEventsCompanion data) {
    return ConnectionEventEntity(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      ownUser: data.ownUser.present ? data.ownUser.value : this.ownUser,
      totalUnreadCount: data.totalUnreadCount.present
          ? data.totalUnreadCount.value
          : this.totalUnreadCount,
      unreadChannels: data.unreadChannels.present
          ? data.unreadChannels.value
          : this.unreadChannels,
      lastEventAt:
          data.lastEventAt.present ? data.lastEventAt.value : this.lastEventAt,
      lastSyncAt:
          data.lastSyncAt.present ? data.lastSyncAt.value : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConnectionEventEntity(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('ownUser: $ownUser, ')
          ..write('totalUnreadCount: $totalUnreadCount, ')
          ..write('unreadChannels: $unreadChannels, ')
          ..write('lastEventAt: $lastEventAt, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, ownUser, totalUnreadCount,
      unreadChannels, lastEventAt, lastSyncAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConnectionEventEntity &&
          other.id == this.id &&
          other.type == this.type &&
          other.ownUser == this.ownUser &&
          other.totalUnreadCount == this.totalUnreadCount &&
          other.unreadChannels == this.unreadChannels &&
          other.lastEventAt == this.lastEventAt &&
          other.lastSyncAt == this.lastSyncAt);
}

class ConnectionEventsCompanion extends UpdateCompanion<ConnectionEventEntity> {
  final Value<int> id;
  final Value<String> type;
  final Value<Map<String, dynamic>?> ownUser;
  final Value<int?> totalUnreadCount;
  final Value<int?> unreadChannels;
  final Value<DateTime?> lastEventAt;
  final Value<DateTime?> lastSyncAt;
  const ConnectionEventsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.ownUser = const Value.absent(),
    this.totalUnreadCount = const Value.absent(),
    this.unreadChannels = const Value.absent(),
    this.lastEventAt = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  });
  ConnectionEventsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    this.ownUser = const Value.absent(),
    this.totalUnreadCount = const Value.absent(),
    this.unreadChannels = const Value.absent(),
    this.lastEventAt = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  }) : type = Value(type);
  static Insertable<ConnectionEventEntity> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? ownUser,
    Expression<int>? totalUnreadCount,
    Expression<int>? unreadChannels,
    Expression<DateTime>? lastEventAt,
    Expression<DateTime>? lastSyncAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (ownUser != null) 'own_user': ownUser,
      if (totalUnreadCount != null) 'total_unread_count': totalUnreadCount,
      if (unreadChannels != null) 'unread_channels': unreadChannels,
      if (lastEventAt != null) 'last_event_at': lastEventAt,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
    });
  }

  ConnectionEventsCompanion copyWith(
      {Value<int>? id,
      Value<String>? type,
      Value<Map<String, dynamic>?>? ownUser,
      Value<int?>? totalUnreadCount,
      Value<int?>? unreadChannels,
      Value<DateTime?>? lastEventAt,
      Value<DateTime?>? lastSyncAt}) {
    return ConnectionEventsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
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
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (ownUser.present) {
      map['own_user'] = Variable<String>(
          $ConnectionEventsTable.$converterownUsern.toSql(ownUser.value));
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
    return (StringBuffer('ConnectionEventsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('ownUser: $ownUser, ')
          ..write('totalUnreadCount: $totalUnreadCount, ')
          ..write('unreadChannels: $unreadChannels, ')
          ..write('lastEventAt: $lastEventAt, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$DriftChatDatabase extends GeneratedDatabase {
  _$DriftChatDatabase(QueryExecutor e) : super(e);
  $DriftChatDatabaseManager get managers => $DriftChatDatabaseManager(this);
  late final $ChannelsTable channels = $ChannelsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $PinnedMessagesTable pinnedMessages = $PinnedMessagesTable(this);
  late final $PollsTable polls = $PollsTable(this);
  late final $PollVotesTable pollVotes = $PollVotesTable(this);
  late final $PinnedMessageReactionsTable pinnedMessageReactions =
      $PinnedMessageReactionsTable(this);
  late final $ReactionsTable reactions = $ReactionsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $MembersTable members = $MembersTable(this);
  late final $ReadsTable reads = $ReadsTable(this);
  late final $ChannelQueriesTable channelQueries = $ChannelQueriesTable(this);
  late final $ConnectionEventsTable connectionEvents =
      $ConnectionEventsTable(this);
  late final UserDao userDao = UserDao(this as DriftChatDatabase);
  late final ChannelDao channelDao = ChannelDao(this as DriftChatDatabase);
  late final MessageDao messageDao = MessageDao(this as DriftChatDatabase);
  late final PinnedMessageDao pinnedMessageDao =
      PinnedMessageDao(this as DriftChatDatabase);
  late final PinnedMessageReactionDao pinnedMessageReactionDao =
      PinnedMessageReactionDao(this as DriftChatDatabase);
  late final MemberDao memberDao = MemberDao(this as DriftChatDatabase);
  late final PollDao pollDao = PollDao(this as DriftChatDatabase);
  late final PollVoteDao pollVoteDao = PollVoteDao(this as DriftChatDatabase);
  late final ReactionDao reactionDao = ReactionDao(this as DriftChatDatabase);
  late final ReadDao readDao = ReadDao(this as DriftChatDatabase);
  late final ChannelQueryDao channelQueryDao =
      ChannelQueryDao(this as DriftChatDatabase);
  late final ConnectionEventDao connectionEventDao =
      ConnectionEventDao(this as DriftChatDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        channels,
        messages,
        pinnedMessages,
        polls,
        pollVotes,
        pinnedMessageReactions,
        reactions,
        users,
        members,
        reads,
        channelQueries,
        connectionEvents
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('channels',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('messages', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('polls',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('poll_votes', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('pinned_messages',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('pinned_message_reactions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('messages',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('reactions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('channels',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('members', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('channels',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('reads', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$ChannelsTableCreateCompanionBuilder = ChannelsCompanion Function({
  required String id,
  required String type,
  required String cid,
  Value<List<String>?> ownCapabilities,
  required Map<String, dynamic> config,
  Value<bool> frozen,
  Value<DateTime?> lastMessageAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> memberCount,
  Value<String?> createdById,
  Value<Map<String, dynamic>?> extraData,
  Value<int> rowid,
});
typedef $$ChannelsTableUpdateCompanionBuilder = ChannelsCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<String> cid,
  Value<List<String>?> ownCapabilities,
  Value<Map<String, dynamic>> config,
  Value<bool> frozen,
  Value<DateTime?> lastMessageAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> memberCount,
  Value<String?> createdById,
  Value<Map<String, dynamic>?> extraData,
  Value<int> rowid,
});

final class $$ChannelsTableReferences
    extends BaseReferences<_$DriftChatDatabase, $ChannelsTable, ChannelEntity> {
  $$ChannelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MessagesTable, List<MessageEntity>>
      _messagesRefsTable(_$DriftChatDatabase db) =>
          MultiTypedResultKey.fromTable(db.messages,
              aliasName: $_aliasNameGenerator(
                  db.channels.cid, db.messages.channelCid));

  $$MessagesTableProcessedTableManager get messagesRefs {
    final manager = $$MessagesTableTableManager($_db, $_db.messages)
        .filter((f) => f.channelCid.cid($_item.cid));

    final cache = $_typedResult.readTableOrNull(_messagesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MembersTable, List<MemberEntity>>
      _membersRefsTable(_$DriftChatDatabase db) =>
          MultiTypedResultKey.fromTable(db.members,
              aliasName:
                  $_aliasNameGenerator(db.channels.cid, db.members.channelCid));

  $$MembersTableProcessedTableManager get membersRefs {
    final manager = $$MembersTableTableManager($_db, $_db.members)
        .filter((f) => f.channelCid.cid($_item.cid));

    final cache = $_typedResult.readTableOrNull(_membersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ReadsTable, List<ReadEntity>> _readsRefsTable(
          _$DriftChatDatabase db) =>
      MultiTypedResultKey.fromTable(db.reads,
          aliasName:
              $_aliasNameGenerator(db.channels.cid, db.reads.channelCid));

  $$ReadsTableProcessedTableManager get readsRefs {
    final manager = $$ReadsTableTableManager($_db, $_db.reads)
        .filter((f) => f.channelCid.cid($_item.cid));

    final cache = $_typedResult.readTableOrNull(_readsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ChannelsTableFilterComposer
    extends Composer<_$DriftChatDatabase, $ChannelsTable> {
  $$ChannelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cid => $composableBuilder(
      column: $table.cid, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
      get ownCapabilities => $composableBuilder(
          column: $table.ownCapabilities,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get config => $composableBuilder(
          column: $table.config,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get frozen => $composableBuilder(
      column: $table.frozen, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastMessageAt => $composableBuilder(
      column: $table.lastMessageAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get memberCount => $composableBuilder(
      column: $table.memberCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdById => $composableBuilder(
      column: $table.createdById, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>?, Map<String, dynamic>,
          String>
      get extraData => $composableBuilder(
          column: $table.extraData,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  Expression<bool> messagesRefs(
      Expression<bool> Function($$MessagesTableFilterComposer f) f) {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cid,
        referencedTable: $db.messages,
        getReferencedColumn: (t) => t.channelCid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessagesTableFilterComposer(
              $db: $db,
              $table: $db.messages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> membersRefs(
      Expression<bool> Function($$MembersTableFilterComposer f) f) {
    final $$MembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cid,
        referencedTable: $db.members,
        getReferencedColumn: (t) => t.channelCid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MembersTableFilterComposer(
              $db: $db,
              $table: $db.members,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> readsRefs(
      Expression<bool> Function($$ReadsTableFilterComposer f) f) {
    final $$ReadsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cid,
        referencedTable: $db.reads,
        getReferencedColumn: (t) => t.channelCid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReadsTableFilterComposer(
              $db: $db,
              $table: $db.reads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChannelsTableOrderingComposer
    extends Composer<_$DriftChatDatabase, $ChannelsTable> {
  $$ChannelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cid => $composableBuilder(
      column: $table.cid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownCapabilities => $composableBuilder(
      column: $table.ownCapabilities,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get config => $composableBuilder(
      column: $table.config, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get frozen => $composableBuilder(
      column: $table.frozen, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastMessageAt => $composableBuilder(
      column: $table.lastMessageAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get memberCount => $composableBuilder(
      column: $table.memberCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdById => $composableBuilder(
      column: $table.createdById, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extraData => $composableBuilder(
      column: $table.extraData, builder: (column) => ColumnOrderings(column));
}

class $$ChannelsTableAnnotationComposer
    extends Composer<_$DriftChatDatabase, $ChannelsTable> {
  $$ChannelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get cid =>
      $composableBuilder(column: $table.cid, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>?, String> get ownCapabilities =>
      $composableBuilder(
          column: $table.ownCapabilities, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get config =>
      $composableBuilder(column: $table.config, builder: (column) => column);

  GeneratedColumn<bool> get frozen =>
      $composableBuilder(column: $table.frozen, builder: (column) => column);

  GeneratedColumn<DateTime> get lastMessageAt => $composableBuilder(
      column: $table.lastMessageAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get memberCount => $composableBuilder(
      column: $table.memberCount, builder: (column) => column);

  GeneratedColumn<String> get createdById => $composableBuilder(
      column: $table.createdById, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      get extraData => $composableBuilder(
          column: $table.extraData, builder: (column) => column);

  Expression<T> messagesRefs<T extends Object>(
      Expression<T> Function($$MessagesTableAnnotationComposer a) f) {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cid,
        referencedTable: $db.messages,
        getReferencedColumn: (t) => t.channelCid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessagesTableAnnotationComposer(
              $db: $db,
              $table: $db.messages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> membersRefs<T extends Object>(
      Expression<T> Function($$MembersTableAnnotationComposer a) f) {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cid,
        referencedTable: $db.members,
        getReferencedColumn: (t) => t.channelCid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MembersTableAnnotationComposer(
              $db: $db,
              $table: $db.members,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> readsRefs<T extends Object>(
      Expression<T> Function($$ReadsTableAnnotationComposer a) f) {
    final $$ReadsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cid,
        referencedTable: $db.reads,
        getReferencedColumn: (t) => t.channelCid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReadsTableAnnotationComposer(
              $db: $db,
              $table: $db.reads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChannelsTableTableManager extends RootTableManager<
    _$DriftChatDatabase,
    $ChannelsTable,
    ChannelEntity,
    $$ChannelsTableFilterComposer,
    $$ChannelsTableOrderingComposer,
    $$ChannelsTableAnnotationComposer,
    $$ChannelsTableCreateCompanionBuilder,
    $$ChannelsTableUpdateCompanionBuilder,
    (ChannelEntity, $$ChannelsTableReferences),
    ChannelEntity,
    PrefetchHooks Function(
        {bool messagesRefs, bool membersRefs, bool readsRefs})> {
  $$ChannelsTableTableManager(_$DriftChatDatabase db, $ChannelsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> cid = const Value.absent(),
            Value<List<String>?> ownCapabilities = const Value.absent(),
            Value<Map<String, dynamic>> config = const Value.absent(),
            Value<bool> frozen = const Value.absent(),
            Value<DateTime?> lastMessageAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> memberCount = const Value.absent(),
            Value<String?> createdById = const Value.absent(),
            Value<Map<String, dynamic>?> extraData = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChannelsCompanion(
            id: id,
            type: type,
            cid: cid,
            ownCapabilities: ownCapabilities,
            config: config,
            frozen: frozen,
            lastMessageAt: lastMessageAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            memberCount: memberCount,
            createdById: createdById,
            extraData: extraData,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String type,
            required String cid,
            Value<List<String>?> ownCapabilities = const Value.absent(),
            required Map<String, dynamic> config,
            Value<bool> frozen = const Value.absent(),
            Value<DateTime?> lastMessageAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> memberCount = const Value.absent(),
            Value<String?> createdById = const Value.absent(),
            Value<Map<String, dynamic>?> extraData = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChannelsCompanion.insert(
            id: id,
            type: type,
            cid: cid,
            ownCapabilities: ownCapabilities,
            config: config,
            frozen: frozen,
            lastMessageAt: lastMessageAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            memberCount: memberCount,
            createdById: createdById,
            extraData: extraData,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ChannelsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {messagesRefs = false, membersRefs = false, readsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (messagesRefs) db.messages,
                if (membersRefs) db.members,
                if (readsRefs) db.reads
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (messagesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$ChannelsTableReferences._messagesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChannelsTableReferences(db, table, p0)
                                .messagesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.channelCid == item.cid),
                        typedResults: items),
                  if (membersRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$ChannelsTableReferences._membersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChannelsTableReferences(db, table, p0)
                                .membersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.channelCid == item.cid),
                        typedResults: items),
                  if (readsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$ChannelsTableReferences._readsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChannelsTableReferences(db, table, p0).readsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.channelCid == item.cid),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ChannelsTableProcessedTableManager = ProcessedTableManager<
    _$DriftChatDatabase,
    $ChannelsTable,
    ChannelEntity,
    $$ChannelsTableFilterComposer,
    $$ChannelsTableOrderingComposer,
    $$ChannelsTableAnnotationComposer,
    $$ChannelsTableCreateCompanionBuilder,
    $$ChannelsTableUpdateCompanionBuilder,
    (ChannelEntity, $$ChannelsTableReferences),
    ChannelEntity,
    PrefetchHooks Function(
        {bool messagesRefs, bool membersRefs, bool readsRefs})>;
typedef $$MessagesTableCreateCompanionBuilder = MessagesCompanion Function({
  required String id,
  Value<String?> messageText,
  required List<String> attachments,
  required String state,
  Value<String> type,
  required List<String> mentionedUsers,
  Value<Map<String, int>?> reactionCounts,
  Value<Map<String, int>?> reactionScores,
  Value<String?> parentId,
  Value<String?> quotedMessageId,
  Value<String?> pollId,
  Value<int?> replyCount,
  Value<bool?> showInChannel,
  Value<bool> shadowed,
  Value<String?> command,
  Value<DateTime?> localCreatedAt,
  Value<DateTime?> remoteCreatedAt,
  Value<DateTime?> localUpdatedAt,
  Value<DateTime?> remoteUpdatedAt,
  Value<DateTime?> localDeletedAt,
  Value<DateTime?> remoteDeletedAt,
  Value<DateTime?> messageTextUpdatedAt,
  Value<String?> userId,
  Value<bool> pinned,
  Value<DateTime?> pinnedAt,
  Value<DateTime?> pinExpires,
  Value<String?> pinnedByUserId,
  required String channelCid,
  Value<Map<String, String>?> i18n,
  Value<List<String>?> restrictedVisibility,
  Value<Map<String, dynamic>?> extraData,
  Value<int> rowid,
});
typedef $$MessagesTableUpdateCompanionBuilder = MessagesCompanion Function({
  Value<String> id,
  Value<String?> messageText,
  Value<List<String>> attachments,
  Value<String> state,
  Value<String> type,
  Value<List<String>> mentionedUsers,
  Value<Map<String, int>?> reactionCounts,
  Value<Map<String, int>?> reactionScores,
  Value<String?> parentId,
  Value<String?> quotedMessageId,
  Value<String?> pollId,
  Value<int?> replyCount,
  Value<bool?> showInChannel,
  Value<bool> shadowed,
  Value<String?> command,
  Value<DateTime?> localCreatedAt,
  Value<DateTime?> remoteCreatedAt,
  Value<DateTime?> localUpdatedAt,
  Value<DateTime?> remoteUpdatedAt,
  Value<DateTime?> localDeletedAt,
  Value<DateTime?> remoteDeletedAt,
  Value<DateTime?> messageTextUpdatedAt,
  Value<String?> userId,
  Value<bool> pinned,
  Value<DateTime?> pinnedAt,
  Value<DateTime?> pinExpires,
  Value<String?> pinnedByUserId,
  Value<String> channelCid,
  Value<Map<String, String>?> i18n,
  Value<List<String>?> restrictedVisibility,
  Value<Map<String, dynamic>?> extraData,
  Value<int> rowid,
});

final class $$MessagesTableReferences
    extends BaseReferences<_$DriftChatDatabase, $MessagesTable, MessageEntity> {
  $$MessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChannelsTable _channelCidTable(_$DriftChatDatabase db) =>
      db.channels.createAlias(
          $_aliasNameGenerator(db.messages.channelCid, db.channels.cid));

  $$ChannelsTableProcessedTableManager get channelCid {
    final manager = $$ChannelsTableTableManager($_db, $_db.channels)
        .filter((f) => f.cid($_item.channelCid!));
    final item = $_typedResult.readTableOrNull(_channelCidTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ReactionsTable, List<ReactionEntity>>
      _reactionsRefsTable(_$DriftChatDatabase db) =>
          MultiTypedResultKey.fromTable(db.reactions,
              aliasName:
                  $_aliasNameGenerator(db.messages.id, db.reactions.messageId));

  $$ReactionsTableProcessedTableManager get reactionsRefs {
    final manager = $$ReactionsTableTableManager($_db, $_db.reactions)
        .filter((f) => f.messageId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_reactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MessagesTableFilterComposer
    extends Composer<_$DriftChatDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get messageText => $composableBuilder(
      column: $table.messageText, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get attachments => $composableBuilder(
          column: $table.attachments,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get mentionedUsers => $composableBuilder(
          column: $table.mentionedUsers,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Map<String, int>?, Map<String, int>, String>
      get reactionCounts => $composableBuilder(
          column: $table.reactionCounts,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Map<String, int>?, Map<String, int>, String>
      get reactionScores => $composableBuilder(
          column: $table.reactionScores,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get quotedMessageId => $composableBuilder(
      column: $table.quotedMessageId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pollId => $composableBuilder(
      column: $table.pollId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get replyCount => $composableBuilder(
      column: $table.replyCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showInChannel => $composableBuilder(
      column: $table.showInChannel, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get shadowed => $composableBuilder(
      column: $table.shadowed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get command => $composableBuilder(
      column: $table.command, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localCreatedAt => $composableBuilder(
      column: $table.localCreatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get remoteCreatedAt => $composableBuilder(
      column: $table.remoteCreatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localDeletedAt => $composableBuilder(
      column: $table.localDeletedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get remoteDeletedAt => $composableBuilder(
      column: $table.remoteDeletedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get messageTextUpdatedAt => $composableBuilder(
      column: $table.messageTextUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pinned => $composableBuilder(
      column: $table.pinned, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get pinnedAt => $composableBuilder(
      column: $table.pinnedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get pinExpires => $composableBuilder(
      column: $table.pinExpires, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinnedByUserId => $composableBuilder(
      column: $table.pinnedByUserId,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, String>?, Map<String, String>,
          String>
      get i18n => $composableBuilder(
          column: $table.i18n,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
      get restrictedVisibility => $composableBuilder(
          column: $table.restrictedVisibility,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>?, Map<String, dynamic>,
          String>
      get extraData => $composableBuilder(
          column: $table.extraData,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$ChannelsTableFilterComposer get channelCid {
    final $$ChannelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.channelCid,
        referencedTable: $db.channels,
        getReferencedColumn: (t) => t.cid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChannelsTableFilterComposer(
              $db: $db,
              $table: $db.channels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> reactionsRefs(
      Expression<bool> Function($$ReactionsTableFilterComposer f) f) {
    final $$ReactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reactions,
        getReferencedColumn: (t) => t.messageId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReactionsTableFilterComposer(
              $db: $db,
              $table: $db.reactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MessagesTableOrderingComposer
    extends Composer<_$DriftChatDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get messageText => $composableBuilder(
      column: $table.messageText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attachments => $composableBuilder(
      column: $table.attachments, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mentionedUsers => $composableBuilder(
      column: $table.mentionedUsers,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reactionCounts => $composableBuilder(
      column: $table.reactionCounts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reactionScores => $composableBuilder(
      column: $table.reactionScores,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get quotedMessageId => $composableBuilder(
      column: $table.quotedMessageId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pollId => $composableBuilder(
      column: $table.pollId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get replyCount => $composableBuilder(
      column: $table.replyCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showInChannel => $composableBuilder(
      column: $table.showInChannel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get shadowed => $composableBuilder(
      column: $table.shadowed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get command => $composableBuilder(
      column: $table.command, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localCreatedAt => $composableBuilder(
      column: $table.localCreatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get remoteCreatedAt => $composableBuilder(
      column: $table.remoteCreatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localDeletedAt => $composableBuilder(
      column: $table.localDeletedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get remoteDeletedAt => $composableBuilder(
      column: $table.remoteDeletedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get messageTextUpdatedAt => $composableBuilder(
      column: $table.messageTextUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pinned => $composableBuilder(
      column: $table.pinned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get pinnedAt => $composableBuilder(
      column: $table.pinnedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get pinExpires => $composableBuilder(
      column: $table.pinExpires, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinnedByUserId => $composableBuilder(
      column: $table.pinnedByUserId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get i18n => $composableBuilder(
      column: $table.i18n, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get restrictedVisibility => $composableBuilder(
      column: $table.restrictedVisibility,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extraData => $composableBuilder(
      column: $table.extraData, builder: (column) => ColumnOrderings(column));

  $$ChannelsTableOrderingComposer get channelCid {
    final $$ChannelsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.channelCid,
        referencedTable: $db.channels,
        getReferencedColumn: (t) => t.cid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChannelsTableOrderingComposer(
              $db: $db,
              $table: $db.channels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$DriftChatDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get messageText => $composableBuilder(
      column: $table.messageText, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get attachments =>
      $composableBuilder(
          column: $table.attachments, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get mentionedUsers =>
      $composableBuilder(
          column: $table.mentionedUsers, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, int>?, String>
      get reactionCounts => $composableBuilder(
          column: $table.reactionCounts, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, int>?, String>
      get reactionScores => $composableBuilder(
          column: $table.reactionScores, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get quotedMessageId => $composableBuilder(
      column: $table.quotedMessageId, builder: (column) => column);

  GeneratedColumn<String> get pollId =>
      $composableBuilder(column: $table.pollId, builder: (column) => column);

  GeneratedColumn<int> get replyCount => $composableBuilder(
      column: $table.replyCount, builder: (column) => column);

  GeneratedColumn<bool> get showInChannel => $composableBuilder(
      column: $table.showInChannel, builder: (column) => column);

  GeneratedColumn<bool> get shadowed =>
      $composableBuilder(column: $table.shadowed, builder: (column) => column);

  GeneratedColumn<String> get command =>
      $composableBuilder(column: $table.command, builder: (column) => column);

  GeneratedColumn<DateTime> get localCreatedAt => $composableBuilder(
      column: $table.localCreatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get remoteCreatedAt => $composableBuilder(
      column: $table.remoteCreatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get localDeletedAt => $composableBuilder(
      column: $table.localDeletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get remoteDeletedAt => $composableBuilder(
      column: $table.remoteDeletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get messageTextUpdatedAt => $composableBuilder(
      column: $table.messageTextUpdatedAt, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get pinned =>
      $composableBuilder(column: $table.pinned, builder: (column) => column);

  GeneratedColumn<DateTime> get pinnedAt =>
      $composableBuilder(column: $table.pinnedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get pinExpires => $composableBuilder(
      column: $table.pinExpires, builder: (column) => column);

  GeneratedColumn<String> get pinnedByUserId => $composableBuilder(
      column: $table.pinnedByUserId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, String>?, String> get i18n =>
      $composableBuilder(column: $table.i18n, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>?, String>
      get restrictedVisibility => $composableBuilder(
          column: $table.restrictedVisibility, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      get extraData => $composableBuilder(
          column: $table.extraData, builder: (column) => column);

  $$ChannelsTableAnnotationComposer get channelCid {
    final $$ChannelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.channelCid,
        referencedTable: $db.channels,
        getReferencedColumn: (t) => t.cid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChannelsTableAnnotationComposer(
              $db: $db,
              $table: $db.channels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> reactionsRefs<T extends Object>(
      Expression<T> Function($$ReactionsTableAnnotationComposer a) f) {
    final $$ReactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reactions,
        getReferencedColumn: (t) => t.messageId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.reactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MessagesTableTableManager extends RootTableManager<
    _$DriftChatDatabase,
    $MessagesTable,
    MessageEntity,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableAnnotationComposer,
    $$MessagesTableCreateCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder,
    (MessageEntity, $$MessagesTableReferences),
    MessageEntity,
    PrefetchHooks Function({bool channelCid, bool reactionsRefs})> {
  $$MessagesTableTableManager(_$DriftChatDatabase db, $MessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> messageText = const Value.absent(),
            Value<List<String>> attachments = const Value.absent(),
            Value<String> state = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<List<String>> mentionedUsers = const Value.absent(),
            Value<Map<String, int>?> reactionCounts = const Value.absent(),
            Value<Map<String, int>?> reactionScores = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<String?> quotedMessageId = const Value.absent(),
            Value<String?> pollId = const Value.absent(),
            Value<int?> replyCount = const Value.absent(),
            Value<bool?> showInChannel = const Value.absent(),
            Value<bool> shadowed = const Value.absent(),
            Value<String?> command = const Value.absent(),
            Value<DateTime?> localCreatedAt = const Value.absent(),
            Value<DateTime?> remoteCreatedAt = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<DateTime?> remoteUpdatedAt = const Value.absent(),
            Value<DateTime?> localDeletedAt = const Value.absent(),
            Value<DateTime?> remoteDeletedAt = const Value.absent(),
            Value<DateTime?> messageTextUpdatedAt = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<bool> pinned = const Value.absent(),
            Value<DateTime?> pinnedAt = const Value.absent(),
            Value<DateTime?> pinExpires = const Value.absent(),
            Value<String?> pinnedByUserId = const Value.absent(),
            Value<String> channelCid = const Value.absent(),
            Value<Map<String, String>?> i18n = const Value.absent(),
            Value<List<String>?> restrictedVisibility = const Value.absent(),
            Value<Map<String, dynamic>?> extraData = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesCompanion(
            id: id,
            messageText: messageText,
            attachments: attachments,
            state: state,
            type: type,
            mentionedUsers: mentionedUsers,
            reactionCounts: reactionCounts,
            reactionScores: reactionScores,
            parentId: parentId,
            quotedMessageId: quotedMessageId,
            pollId: pollId,
            replyCount: replyCount,
            showInChannel: showInChannel,
            shadowed: shadowed,
            command: command,
            localCreatedAt: localCreatedAt,
            remoteCreatedAt: remoteCreatedAt,
            localUpdatedAt: localUpdatedAt,
            remoteUpdatedAt: remoteUpdatedAt,
            localDeletedAt: localDeletedAt,
            remoteDeletedAt: remoteDeletedAt,
            messageTextUpdatedAt: messageTextUpdatedAt,
            userId: userId,
            pinned: pinned,
            pinnedAt: pinnedAt,
            pinExpires: pinExpires,
            pinnedByUserId: pinnedByUserId,
            channelCid: channelCid,
            i18n: i18n,
            restrictedVisibility: restrictedVisibility,
            extraData: extraData,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> messageText = const Value.absent(),
            required List<String> attachments,
            required String state,
            Value<String> type = const Value.absent(),
            required List<String> mentionedUsers,
            Value<Map<String, int>?> reactionCounts = const Value.absent(),
            Value<Map<String, int>?> reactionScores = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<String?> quotedMessageId = const Value.absent(),
            Value<String?> pollId = const Value.absent(),
            Value<int?> replyCount = const Value.absent(),
            Value<bool?> showInChannel = const Value.absent(),
            Value<bool> shadowed = const Value.absent(),
            Value<String?> command = const Value.absent(),
            Value<DateTime?> localCreatedAt = const Value.absent(),
            Value<DateTime?> remoteCreatedAt = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<DateTime?> remoteUpdatedAt = const Value.absent(),
            Value<DateTime?> localDeletedAt = const Value.absent(),
            Value<DateTime?> remoteDeletedAt = const Value.absent(),
            Value<DateTime?> messageTextUpdatedAt = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<bool> pinned = const Value.absent(),
            Value<DateTime?> pinnedAt = const Value.absent(),
            Value<DateTime?> pinExpires = const Value.absent(),
            Value<String?> pinnedByUserId = const Value.absent(),
            required String channelCid,
            Value<Map<String, String>?> i18n = const Value.absent(),
            Value<List<String>?> restrictedVisibility = const Value.absent(),
            Value<Map<String, dynamic>?> extraData = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesCompanion.insert(
            id: id,
            messageText: messageText,
            attachments: attachments,
            state: state,
            type: type,
            mentionedUsers: mentionedUsers,
            reactionCounts: reactionCounts,
            reactionScores: reactionScores,
            parentId: parentId,
            quotedMessageId: quotedMessageId,
            pollId: pollId,
            replyCount: replyCount,
            showInChannel: showInChannel,
            shadowed: shadowed,
            command: command,
            localCreatedAt: localCreatedAt,
            remoteCreatedAt: remoteCreatedAt,
            localUpdatedAt: localUpdatedAt,
            remoteUpdatedAt: remoteUpdatedAt,
            localDeletedAt: localDeletedAt,
            remoteDeletedAt: remoteDeletedAt,
            messageTextUpdatedAt: messageTextUpdatedAt,
            userId: userId,
            pinned: pinned,
            pinnedAt: pinnedAt,
            pinExpires: pinExpires,
            pinnedByUserId: pinnedByUserId,
            channelCid: channelCid,
            i18n: i18n,
            restrictedVisibility: restrictedVisibility,
            extraData: extraData,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MessagesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({channelCid = false, reactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (reactionsRefs) db.reactions],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (channelCid) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.channelCid,
                    referencedTable:
                        $$MessagesTableReferences._channelCidTable(db),
                    referencedColumn:
                        $$MessagesTableReferences._channelCidTable(db).cid,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (reactionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$MessagesTableReferences._reactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MessagesTableReferences(db, table, p0)
                                .reactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.messageId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MessagesTableProcessedTableManager = ProcessedTableManager<
    _$DriftChatDatabase,
    $MessagesTable,
    MessageEntity,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableAnnotationComposer,
    $$MessagesTableCreateCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder,
    (MessageEntity, $$MessagesTableReferences),
    MessageEntity,
    PrefetchHooks Function({bool channelCid, bool reactionsRefs})>;
typedef $$PinnedMessagesTableCreateCompanionBuilder = PinnedMessagesCompanion
    Function({
  required String id,
  Value<String?> messageText,
  required List<String> attachments,
  required String state,
  Value<String> type,
  required List<String> mentionedUsers,
  Value<Map<String, int>?> reactionCounts,
  Value<Map<String, int>?> reactionScores,
  Value<String?> parentId,
  Value<String?> quotedMessageId,
  Value<String?> pollId,
  Value<int?> replyCount,
  Value<bool?> showInChannel,
  Value<bool> shadowed,
  Value<String?> command,
  Value<DateTime?> localCreatedAt,
  Value<DateTime?> remoteCreatedAt,
  Value<DateTime?> localUpdatedAt,
  Value<DateTime?> remoteUpdatedAt,
  Value<DateTime?> localDeletedAt,
  Value<DateTime?> remoteDeletedAt,
  Value<DateTime?> messageTextUpdatedAt,
  Value<String?> userId,
  Value<bool> pinned,
  Value<DateTime?> pinnedAt,
  Value<DateTime?> pinExpires,
  Value<String?> pinnedByUserId,
  required String channelCid,
  Value<Map<String, String>?> i18n,
  Value<List<String>?> restrictedVisibility,
  Value<Map<String, dynamic>?> extraData,
  Value<int> rowid,
});
typedef $$PinnedMessagesTableUpdateCompanionBuilder = PinnedMessagesCompanion
    Function({
  Value<String> id,
  Value<String?> messageText,
  Value<List<String>> attachments,
  Value<String> state,
  Value<String> type,
  Value<List<String>> mentionedUsers,
  Value<Map<String, int>?> reactionCounts,
  Value<Map<String, int>?> reactionScores,
  Value<String?> parentId,
  Value<String?> quotedMessageId,
  Value<String?> pollId,
  Value<int?> replyCount,
  Value<bool?> showInChannel,
  Value<bool> shadowed,
  Value<String?> command,
  Value<DateTime?> localCreatedAt,
  Value<DateTime?> remoteCreatedAt,
  Value<DateTime?> localUpdatedAt,
  Value<DateTime?> remoteUpdatedAt,
  Value<DateTime?> localDeletedAt,
  Value<DateTime?> remoteDeletedAt,
  Value<DateTime?> messageTextUpdatedAt,
  Value<String?> userId,
  Value<bool> pinned,
  Value<DateTime?> pinnedAt,
  Value<DateTime?> pinExpires,
  Value<String?> pinnedByUserId,
  Value<String> channelCid,
  Value<Map<String, String>?> i18n,
  Value<List<String>?> restrictedVisibility,
  Value<Map<String, dynamic>?> extraData,
  Value<int> rowid,
});

final class $$PinnedMessagesTableReferences extends BaseReferences<
    _$DriftChatDatabase, $PinnedMessagesTable, PinnedMessageEntity> {
  $$PinnedMessagesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PinnedMessageReactionsTable,
      List<PinnedMessageReactionEntity>> _pinnedMessageReactionsRefsTable(
          _$DriftChatDatabase db) =>
      MultiTypedResultKey.fromTable(db.pinnedMessageReactions,
          aliasName: $_aliasNameGenerator(
              db.pinnedMessages.id, db.pinnedMessageReactions.messageId));

  $$PinnedMessageReactionsTableProcessedTableManager
      get pinnedMessageReactionsRefs {
    final manager = $$PinnedMessageReactionsTableTableManager(
            $_db, $_db.pinnedMessageReactions)
        .filter((f) => f.messageId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_pinnedMessageReactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PinnedMessagesTableFilterComposer
    extends Composer<_$DriftChatDatabase, $PinnedMessagesTable> {
  $$PinnedMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get messageText => $composableBuilder(
      column: $table.messageText, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get attachments => $composableBuilder(
          column: $table.attachments,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get mentionedUsers => $composableBuilder(
          column: $table.mentionedUsers,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Map<String, int>?, Map<String, int>, String>
      get reactionCounts => $composableBuilder(
          column: $table.reactionCounts,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Map<String, int>?, Map<String, int>, String>
      get reactionScores => $composableBuilder(
          column: $table.reactionScores,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get quotedMessageId => $composableBuilder(
      column: $table.quotedMessageId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pollId => $composableBuilder(
      column: $table.pollId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get replyCount => $composableBuilder(
      column: $table.replyCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showInChannel => $composableBuilder(
      column: $table.showInChannel, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get shadowed => $composableBuilder(
      column: $table.shadowed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get command => $composableBuilder(
      column: $table.command, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localCreatedAt => $composableBuilder(
      column: $table.localCreatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get remoteCreatedAt => $composableBuilder(
      column: $table.remoteCreatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localDeletedAt => $composableBuilder(
      column: $table.localDeletedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get remoteDeletedAt => $composableBuilder(
      column: $table.remoteDeletedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get messageTextUpdatedAt => $composableBuilder(
      column: $table.messageTextUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pinned => $composableBuilder(
      column: $table.pinned, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get pinnedAt => $composableBuilder(
      column: $table.pinnedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get pinExpires => $composableBuilder(
      column: $table.pinExpires, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinnedByUserId => $composableBuilder(
      column: $table.pinnedByUserId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get channelCid => $composableBuilder(
      column: $table.channelCid, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, String>?, Map<String, String>,
          String>
      get i18n => $composableBuilder(
          column: $table.i18n,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
      get restrictedVisibility => $composableBuilder(
          column: $table.restrictedVisibility,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>?, Map<String, dynamic>,
          String>
      get extraData => $composableBuilder(
          column: $table.extraData,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  Expression<bool> pinnedMessageReactionsRefs(
      Expression<bool> Function($$PinnedMessageReactionsTableFilterComposer f)
          f) {
    final $$PinnedMessageReactionsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.pinnedMessageReactions,
            getReferencedColumn: (t) => t.messageId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PinnedMessageReactionsTableFilterComposer(
                  $db: $db,
                  $table: $db.pinnedMessageReactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$PinnedMessagesTableOrderingComposer
    extends Composer<_$DriftChatDatabase, $PinnedMessagesTable> {
  $$PinnedMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get messageText => $composableBuilder(
      column: $table.messageText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attachments => $composableBuilder(
      column: $table.attachments, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mentionedUsers => $composableBuilder(
      column: $table.mentionedUsers,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reactionCounts => $composableBuilder(
      column: $table.reactionCounts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reactionScores => $composableBuilder(
      column: $table.reactionScores,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get quotedMessageId => $composableBuilder(
      column: $table.quotedMessageId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pollId => $composableBuilder(
      column: $table.pollId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get replyCount => $composableBuilder(
      column: $table.replyCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showInChannel => $composableBuilder(
      column: $table.showInChannel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get shadowed => $composableBuilder(
      column: $table.shadowed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get command => $composableBuilder(
      column: $table.command, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localCreatedAt => $composableBuilder(
      column: $table.localCreatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get remoteCreatedAt => $composableBuilder(
      column: $table.remoteCreatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localDeletedAt => $composableBuilder(
      column: $table.localDeletedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get remoteDeletedAt => $composableBuilder(
      column: $table.remoteDeletedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get messageTextUpdatedAt => $composableBuilder(
      column: $table.messageTextUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pinned => $composableBuilder(
      column: $table.pinned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get pinnedAt => $composableBuilder(
      column: $table.pinnedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get pinExpires => $composableBuilder(
      column: $table.pinExpires, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinnedByUserId => $composableBuilder(
      column: $table.pinnedByUserId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get channelCid => $composableBuilder(
      column: $table.channelCid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get i18n => $composableBuilder(
      column: $table.i18n, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get restrictedVisibility => $composableBuilder(
      column: $table.restrictedVisibility,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extraData => $composableBuilder(
      column: $table.extraData, builder: (column) => ColumnOrderings(column));
}

class $$PinnedMessagesTableAnnotationComposer
    extends Composer<_$DriftChatDatabase, $PinnedMessagesTable> {
  $$PinnedMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get messageText => $composableBuilder(
      column: $table.messageText, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get attachments =>
      $composableBuilder(
          column: $table.attachments, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get mentionedUsers =>
      $composableBuilder(
          column: $table.mentionedUsers, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, int>?, String>
      get reactionCounts => $composableBuilder(
          column: $table.reactionCounts, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, int>?, String>
      get reactionScores => $composableBuilder(
          column: $table.reactionScores, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get quotedMessageId => $composableBuilder(
      column: $table.quotedMessageId, builder: (column) => column);

  GeneratedColumn<String> get pollId =>
      $composableBuilder(column: $table.pollId, builder: (column) => column);

  GeneratedColumn<int> get replyCount => $composableBuilder(
      column: $table.replyCount, builder: (column) => column);

  GeneratedColumn<bool> get showInChannel => $composableBuilder(
      column: $table.showInChannel, builder: (column) => column);

  GeneratedColumn<bool> get shadowed =>
      $composableBuilder(column: $table.shadowed, builder: (column) => column);

  GeneratedColumn<String> get command =>
      $composableBuilder(column: $table.command, builder: (column) => column);

  GeneratedColumn<DateTime> get localCreatedAt => $composableBuilder(
      column: $table.localCreatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get remoteCreatedAt => $composableBuilder(
      column: $table.remoteCreatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get remoteUpdatedAt => $composableBuilder(
      column: $table.remoteUpdatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get localDeletedAt => $composableBuilder(
      column: $table.localDeletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get remoteDeletedAt => $composableBuilder(
      column: $table.remoteDeletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get messageTextUpdatedAt => $composableBuilder(
      column: $table.messageTextUpdatedAt, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get pinned =>
      $composableBuilder(column: $table.pinned, builder: (column) => column);

  GeneratedColumn<DateTime> get pinnedAt =>
      $composableBuilder(column: $table.pinnedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get pinExpires => $composableBuilder(
      column: $table.pinExpires, builder: (column) => column);

  GeneratedColumn<String> get pinnedByUserId => $composableBuilder(
      column: $table.pinnedByUserId, builder: (column) => column);

  GeneratedColumn<String> get channelCid => $composableBuilder(
      column: $table.channelCid, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, String>?, String> get i18n =>
      $composableBuilder(column: $table.i18n, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>?, String>
      get restrictedVisibility => $composableBuilder(
          column: $table.restrictedVisibility, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      get extraData => $composableBuilder(
          column: $table.extraData, builder: (column) => column);

  Expression<T> pinnedMessageReactionsRefs<T extends Object>(
      Expression<T> Function($$PinnedMessageReactionsTableAnnotationComposer a)
          f) {
    final $$PinnedMessageReactionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.pinnedMessageReactions,
            getReferencedColumn: (t) => t.messageId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PinnedMessageReactionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.pinnedMessageReactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$PinnedMessagesTableTableManager extends RootTableManager<
    _$DriftChatDatabase,
    $PinnedMessagesTable,
    PinnedMessageEntity,
    $$PinnedMessagesTableFilterComposer,
    $$PinnedMessagesTableOrderingComposer,
    $$PinnedMessagesTableAnnotationComposer,
    $$PinnedMessagesTableCreateCompanionBuilder,
    $$PinnedMessagesTableUpdateCompanionBuilder,
    (PinnedMessageEntity, $$PinnedMessagesTableReferences),
    PinnedMessageEntity,
    PrefetchHooks Function({bool pinnedMessageReactionsRefs})> {
  $$PinnedMessagesTableTableManager(
      _$DriftChatDatabase db, $PinnedMessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PinnedMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PinnedMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PinnedMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> messageText = const Value.absent(),
            Value<List<String>> attachments = const Value.absent(),
            Value<String> state = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<List<String>> mentionedUsers = const Value.absent(),
            Value<Map<String, int>?> reactionCounts = const Value.absent(),
            Value<Map<String, int>?> reactionScores = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<String?> quotedMessageId = const Value.absent(),
            Value<String?> pollId = const Value.absent(),
            Value<int?> replyCount = const Value.absent(),
            Value<bool?> showInChannel = const Value.absent(),
            Value<bool> shadowed = const Value.absent(),
            Value<String?> command = const Value.absent(),
            Value<DateTime?> localCreatedAt = const Value.absent(),
            Value<DateTime?> remoteCreatedAt = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<DateTime?> remoteUpdatedAt = const Value.absent(),
            Value<DateTime?> localDeletedAt = const Value.absent(),
            Value<DateTime?> remoteDeletedAt = const Value.absent(),
            Value<DateTime?> messageTextUpdatedAt = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<bool> pinned = const Value.absent(),
            Value<DateTime?> pinnedAt = const Value.absent(),
            Value<DateTime?> pinExpires = const Value.absent(),
            Value<String?> pinnedByUserId = const Value.absent(),
            Value<String> channelCid = const Value.absent(),
            Value<Map<String, String>?> i18n = const Value.absent(),
            Value<List<String>?> restrictedVisibility = const Value.absent(),
            Value<Map<String, dynamic>?> extraData = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PinnedMessagesCompanion(
            id: id,
            messageText: messageText,
            attachments: attachments,
            state: state,
            type: type,
            mentionedUsers: mentionedUsers,
            reactionCounts: reactionCounts,
            reactionScores: reactionScores,
            parentId: parentId,
            quotedMessageId: quotedMessageId,
            pollId: pollId,
            replyCount: replyCount,
            showInChannel: showInChannel,
            shadowed: shadowed,
            command: command,
            localCreatedAt: localCreatedAt,
            remoteCreatedAt: remoteCreatedAt,
            localUpdatedAt: localUpdatedAt,
            remoteUpdatedAt: remoteUpdatedAt,
            localDeletedAt: localDeletedAt,
            remoteDeletedAt: remoteDeletedAt,
            messageTextUpdatedAt: messageTextUpdatedAt,
            userId: userId,
            pinned: pinned,
            pinnedAt: pinnedAt,
            pinExpires: pinExpires,
            pinnedByUserId: pinnedByUserId,
            channelCid: channelCid,
            i18n: i18n,
            restrictedVisibility: restrictedVisibility,
            extraData: extraData,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> messageText = const Value.absent(),
            required List<String> attachments,
            required String state,
            Value<String> type = const Value.absent(),
            required List<String> mentionedUsers,
            Value<Map<String, int>?> reactionCounts = const Value.absent(),
            Value<Map<String, int>?> reactionScores = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<String?> quotedMessageId = const Value.absent(),
            Value<String?> pollId = const Value.absent(),
            Value<int?> replyCount = const Value.absent(),
            Value<bool?> showInChannel = const Value.absent(),
            Value<bool> shadowed = const Value.absent(),
            Value<String?> command = const Value.absent(),
            Value<DateTime?> localCreatedAt = const Value.absent(),
            Value<DateTime?> remoteCreatedAt = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<DateTime?> remoteUpdatedAt = const Value.absent(),
            Value<DateTime?> localDeletedAt = const Value.absent(),
            Value<DateTime?> remoteDeletedAt = const Value.absent(),
            Value<DateTime?> messageTextUpdatedAt = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<bool> pinned = const Value.absent(),
            Value<DateTime?> pinnedAt = const Value.absent(),
            Value<DateTime?> pinExpires = const Value.absent(),
            Value<String?> pinnedByUserId = const Value.absent(),
            required String channelCid,
            Value<Map<String, String>?> i18n = const Value.absent(),
            Value<List<String>?> restrictedVisibility = const Value.absent(),
            Value<Map<String, dynamic>?> extraData = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PinnedMessagesCompanion.insert(
            id: id,
            messageText: messageText,
            attachments: attachments,
            state: state,
            type: type,
            mentionedUsers: mentionedUsers,
            reactionCounts: reactionCounts,
            reactionScores: reactionScores,
            parentId: parentId,
            quotedMessageId: quotedMessageId,
            pollId: pollId,
            replyCount: replyCount,
            showInChannel: showInChannel,
            shadowed: shadowed,
            command: command,
            localCreatedAt: localCreatedAt,
            remoteCreatedAt: remoteCreatedAt,
            localUpdatedAt: localUpdatedAt,
            remoteUpdatedAt: remoteUpdatedAt,
            localDeletedAt: localDeletedAt,
            remoteDeletedAt: remoteDeletedAt,
            messageTextUpdatedAt: messageTextUpdatedAt,
            userId: userId,
            pinned: pinned,
            pinnedAt: pinnedAt,
            pinExpires: pinExpires,
            pinnedByUserId: pinnedByUserId,
            channelCid: channelCid,
            i18n: i18n,
            restrictedVisibility: restrictedVisibility,
            extraData: extraData,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PinnedMessagesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({pinnedMessageReactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (pinnedMessageReactionsRefs) db.pinnedMessageReactions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (pinnedMessageReactionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$PinnedMessagesTableReferences
                            ._pinnedMessageReactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PinnedMessagesTableReferences(db, table, p0)
                                .pinnedMessageReactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.messageId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PinnedMessagesTableProcessedTableManager = ProcessedTableManager<
    _$DriftChatDatabase,
    $PinnedMessagesTable,
    PinnedMessageEntity,
    $$PinnedMessagesTableFilterComposer,
    $$PinnedMessagesTableOrderingComposer,
    $$PinnedMessagesTableAnnotationComposer,
    $$PinnedMessagesTableCreateCompanionBuilder,
    $$PinnedMessagesTableUpdateCompanionBuilder,
    (PinnedMessageEntity, $$PinnedMessagesTableReferences),
    PinnedMessageEntity,
    PrefetchHooks Function({bool pinnedMessageReactionsRefs})>;
typedef $$PollsTableCreateCompanionBuilder = PollsCompanion Function({
  required String id,
  required String name,
  Value<String?> description,
  required List<String> options,
  Value<VotingVisibility> votingVisibility,
  Value<bool> enforceUniqueVote,
  Value<int?> maxVotesAllowed,
  Value<bool> allowUserSuggestedOptions,
  Value<bool> allowAnswers,
  Value<bool> isClosed,
  Value<int> answersCount,
  required Map<String, int> voteCountsByOption,
  Value<int> voteCount,
  Value<String?> createdById,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<Map<String, dynamic>?> extraData,
  Value<int> rowid,
});
typedef $$PollsTableUpdateCompanionBuilder = PollsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<List<String>> options,
  Value<VotingVisibility> votingVisibility,
  Value<bool> enforceUniqueVote,
  Value<int?> maxVotesAllowed,
  Value<bool> allowUserSuggestedOptions,
  Value<bool> allowAnswers,
  Value<bool> isClosed,
  Value<int> answersCount,
  Value<Map<String, int>> voteCountsByOption,
  Value<int> voteCount,
  Value<String?> createdById,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<Map<String, dynamic>?> extraData,
  Value<int> rowid,
});

final class $$PollsTableReferences
    extends BaseReferences<_$DriftChatDatabase, $PollsTable, PollEntity> {
  $$PollsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PollVotesTable, List<PollVoteEntity>>
      _pollVotesRefsTable(_$DriftChatDatabase db) =>
          MultiTypedResultKey.fromTable(db.pollVotes,
              aliasName:
                  $_aliasNameGenerator(db.polls.id, db.pollVotes.pollId));

  $$PollVotesTableProcessedTableManager get pollVotesRefs {
    final manager = $$PollVotesTableTableManager($_db, $_db.pollVotes)
        .filter((f) => f.pollId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_pollVotesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PollsTableFilterComposer
    extends Composer<_$DriftChatDatabase, $PollsTable> {
  $$PollsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get options => $composableBuilder(
          column: $table.options,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<VotingVisibility, VotingVisibility, String>
      get votingVisibility => $composableBuilder(
          column: $table.votingVisibility,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get enforceUniqueVote => $composableBuilder(
      column: $table.enforceUniqueVote,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxVotesAllowed => $composableBuilder(
      column: $table.maxVotesAllowed,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get allowUserSuggestedOptions => $composableBuilder(
      column: $table.allowUserSuggestedOptions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get allowAnswers => $composableBuilder(
      column: $table.allowAnswers, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isClosed => $composableBuilder(
      column: $table.isClosed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get answersCount => $composableBuilder(
      column: $table.answersCount, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, int>, Map<String, int>, String>
      get voteCountsByOption => $composableBuilder(
          column: $table.voteCountsByOption,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get voteCount => $composableBuilder(
      column: $table.voteCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdById => $composableBuilder(
      column: $table.createdById, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>?, Map<String, dynamic>,
          String>
      get extraData => $composableBuilder(
          column: $table.extraData,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  Expression<bool> pollVotesRefs(
      Expression<bool> Function($$PollVotesTableFilterComposer f) f) {
    final $$PollVotesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pollVotes,
        getReferencedColumn: (t) => t.pollId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PollVotesTableFilterComposer(
              $db: $db,
              $table: $db.pollVotes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PollsTableOrderingComposer
    extends Composer<_$DriftChatDatabase, $PollsTable> {
  $$PollsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get options => $composableBuilder(
      column: $table.options, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get votingVisibility => $composableBuilder(
      column: $table.votingVisibility,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enforceUniqueVote => $composableBuilder(
      column: $table.enforceUniqueVote,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxVotesAllowed => $composableBuilder(
      column: $table.maxVotesAllowed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get allowUserSuggestedOptions => $composableBuilder(
      column: $table.allowUserSuggestedOptions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get allowAnswers => $composableBuilder(
      column: $table.allowAnswers,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isClosed => $composableBuilder(
      column: $table.isClosed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get answersCount => $composableBuilder(
      column: $table.answersCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get voteCountsByOption => $composableBuilder(
      column: $table.voteCountsByOption,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get voteCount => $composableBuilder(
      column: $table.voteCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdById => $composableBuilder(
      column: $table.createdById, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extraData => $composableBuilder(
      column: $table.extraData, builder: (column) => ColumnOrderings(column));
}

class $$PollsTableAnnotationComposer
    extends Composer<_$DriftChatDatabase, $PollsTable> {
  $$PollsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get options =>
      $composableBuilder(column: $table.options, builder: (column) => column);

  GeneratedColumnWithTypeConverter<VotingVisibility, String>
      get votingVisibility => $composableBuilder(
          column: $table.votingVisibility, builder: (column) => column);

  GeneratedColumn<bool> get enforceUniqueVote => $composableBuilder(
      column: $table.enforceUniqueVote, builder: (column) => column);

  GeneratedColumn<int> get maxVotesAllowed => $composableBuilder(
      column: $table.maxVotesAllowed, builder: (column) => column);

  GeneratedColumn<bool> get allowUserSuggestedOptions => $composableBuilder(
      column: $table.allowUserSuggestedOptions, builder: (column) => column);

  GeneratedColumn<bool> get allowAnswers => $composableBuilder(
      column: $table.allowAnswers, builder: (column) => column);

  GeneratedColumn<bool> get isClosed =>
      $composableBuilder(column: $table.isClosed, builder: (column) => column);

  GeneratedColumn<int> get answersCount => $composableBuilder(
      column: $table.answersCount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, int>, String>
      get voteCountsByOption => $composableBuilder(
          column: $table.voteCountsByOption, builder: (column) => column);

  GeneratedColumn<int> get voteCount =>
      $composableBuilder(column: $table.voteCount, builder: (column) => column);

  GeneratedColumn<String> get createdById => $composableBuilder(
      column: $table.createdById, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      get extraData => $composableBuilder(
          column: $table.extraData, builder: (column) => column);

  Expression<T> pollVotesRefs<T extends Object>(
      Expression<T> Function($$PollVotesTableAnnotationComposer a) f) {
    final $$PollVotesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pollVotes,
        getReferencedColumn: (t) => t.pollId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PollVotesTableAnnotationComposer(
              $db: $db,
              $table: $db.pollVotes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PollsTableTableManager extends RootTableManager<
    _$DriftChatDatabase,
    $PollsTable,
    PollEntity,
    $$PollsTableFilterComposer,
    $$PollsTableOrderingComposer,
    $$PollsTableAnnotationComposer,
    $$PollsTableCreateCompanionBuilder,
    $$PollsTableUpdateCompanionBuilder,
    (PollEntity, $$PollsTableReferences),
    PollEntity,
    PrefetchHooks Function({bool pollVotesRefs})> {
  $$PollsTableTableManager(_$DriftChatDatabase db, $PollsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PollsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PollsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PollsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<List<String>> options = const Value.absent(),
            Value<VotingVisibility> votingVisibility = const Value.absent(),
            Value<bool> enforceUniqueVote = const Value.absent(),
            Value<int?> maxVotesAllowed = const Value.absent(),
            Value<bool> allowUserSuggestedOptions = const Value.absent(),
            Value<bool> allowAnswers = const Value.absent(),
            Value<bool> isClosed = const Value.absent(),
            Value<int> answersCount = const Value.absent(),
            Value<Map<String, int>> voteCountsByOption = const Value.absent(),
            Value<int> voteCount = const Value.absent(),
            Value<String?> createdById = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<Map<String, dynamic>?> extraData = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PollsCompanion(
            id: id,
            name: name,
            description: description,
            options: options,
            votingVisibility: votingVisibility,
            enforceUniqueVote: enforceUniqueVote,
            maxVotesAllowed: maxVotesAllowed,
            allowUserSuggestedOptions: allowUserSuggestedOptions,
            allowAnswers: allowAnswers,
            isClosed: isClosed,
            answersCount: answersCount,
            voteCountsByOption: voteCountsByOption,
            voteCount: voteCount,
            createdById: createdById,
            createdAt: createdAt,
            updatedAt: updatedAt,
            extraData: extraData,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> description = const Value.absent(),
            required List<String> options,
            Value<VotingVisibility> votingVisibility = const Value.absent(),
            Value<bool> enforceUniqueVote = const Value.absent(),
            Value<int?> maxVotesAllowed = const Value.absent(),
            Value<bool> allowUserSuggestedOptions = const Value.absent(),
            Value<bool> allowAnswers = const Value.absent(),
            Value<bool> isClosed = const Value.absent(),
            Value<int> answersCount = const Value.absent(),
            required Map<String, int> voteCountsByOption,
            Value<int> voteCount = const Value.absent(),
            Value<String?> createdById = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<Map<String, dynamic>?> extraData = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PollsCompanion.insert(
            id: id,
            name: name,
            description: description,
            options: options,
            votingVisibility: votingVisibility,
            enforceUniqueVote: enforceUniqueVote,
            maxVotesAllowed: maxVotesAllowed,
            allowUserSuggestedOptions: allowUserSuggestedOptions,
            allowAnswers: allowAnswers,
            isClosed: isClosed,
            answersCount: answersCount,
            voteCountsByOption: voteCountsByOption,
            voteCount: voteCount,
            createdById: createdById,
            createdAt: createdAt,
            updatedAt: updatedAt,
            extraData: extraData,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PollsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({pollVotesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (pollVotesRefs) db.pollVotes],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (pollVotesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$PollsTableReferences._pollVotesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PollsTableReferences(db, table, p0).pollVotesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.pollId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PollsTableProcessedTableManager = ProcessedTableManager<
    _$DriftChatDatabase,
    $PollsTable,
    PollEntity,
    $$PollsTableFilterComposer,
    $$PollsTableOrderingComposer,
    $$PollsTableAnnotationComposer,
    $$PollsTableCreateCompanionBuilder,
    $$PollsTableUpdateCompanionBuilder,
    (PollEntity, $$PollsTableReferences),
    PollEntity,
    PrefetchHooks Function({bool pollVotesRefs})>;
typedef $$PollVotesTableCreateCompanionBuilder = PollVotesCompanion Function({
  Value<String?> id,
  Value<String?> pollId,
  Value<String?> optionId,
  Value<String?> answerText,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String?> userId,
  Value<int> rowid,
});
typedef $$PollVotesTableUpdateCompanionBuilder = PollVotesCompanion Function({
  Value<String?> id,
  Value<String?> pollId,
  Value<String?> optionId,
  Value<String?> answerText,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String?> userId,
  Value<int> rowid,
});

final class $$PollVotesTableReferences extends BaseReferences<
    _$DriftChatDatabase, $PollVotesTable, PollVoteEntity> {
  $$PollVotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PollsTable _pollIdTable(_$DriftChatDatabase db) => db.polls
      .createAlias($_aliasNameGenerator(db.pollVotes.pollId, db.polls.id));

  $$PollsTableProcessedTableManager? get pollId {
    if ($_item.pollId == null) return null;
    final manager = $$PollsTableTableManager($_db, $_db.polls)
        .filter((f) => f.id($_item.pollId!));
    final item = $_typedResult.readTableOrNull(_pollIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PollVotesTableFilterComposer
    extends Composer<_$DriftChatDatabase, $PollVotesTable> {
  $$PollVotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get optionId => $composableBuilder(
      column: $table.optionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get answerText => $composableBuilder(
      column: $table.answerText, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  $$PollsTableFilterComposer get pollId {
    final $$PollsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pollId,
        referencedTable: $db.polls,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PollsTableFilterComposer(
              $db: $db,
              $table: $db.polls,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PollVotesTableOrderingComposer
    extends Composer<_$DriftChatDatabase, $PollVotesTable> {
  $$PollVotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get optionId => $composableBuilder(
      column: $table.optionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get answerText => $composableBuilder(
      column: $table.answerText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  $$PollsTableOrderingComposer get pollId {
    final $$PollsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pollId,
        referencedTable: $db.polls,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PollsTableOrderingComposer(
              $db: $db,
              $table: $db.polls,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PollVotesTableAnnotationComposer
    extends Composer<_$DriftChatDatabase, $PollVotesTable> {
  $$PollVotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get optionId =>
      $composableBuilder(column: $table.optionId, builder: (column) => column);

  GeneratedColumn<String> get answerText => $composableBuilder(
      column: $table.answerText, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  $$PollsTableAnnotationComposer get pollId {
    final $$PollsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pollId,
        referencedTable: $db.polls,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PollsTableAnnotationComposer(
              $db: $db,
              $table: $db.polls,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PollVotesTableTableManager extends RootTableManager<
    _$DriftChatDatabase,
    $PollVotesTable,
    PollVoteEntity,
    $$PollVotesTableFilterComposer,
    $$PollVotesTableOrderingComposer,
    $$PollVotesTableAnnotationComposer,
    $$PollVotesTableCreateCompanionBuilder,
    $$PollVotesTableUpdateCompanionBuilder,
    (PollVoteEntity, $$PollVotesTableReferences),
    PollVoteEntity,
    PrefetchHooks Function({bool pollId})> {
  $$PollVotesTableTableManager(_$DriftChatDatabase db, $PollVotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PollVotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PollVotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PollVotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String?> id = const Value.absent(),
            Value<String?> pollId = const Value.absent(),
            Value<String?> optionId = const Value.absent(),
            Value<String?> answerText = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PollVotesCompanion(
            id: id,
            pollId: pollId,
            optionId: optionId,
            answerText: answerText,
            createdAt: createdAt,
            updatedAt: updatedAt,
            userId: userId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String?> id = const Value.absent(),
            Value<String?> pollId = const Value.absent(),
            Value<String?> optionId = const Value.absent(),
            Value<String?> answerText = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PollVotesCompanion.insert(
            id: id,
            pollId: pollId,
            optionId: optionId,
            answerText: answerText,
            createdAt: createdAt,
            updatedAt: updatedAt,
            userId: userId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PollVotesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({pollId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (pollId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.pollId,
                    referencedTable:
                        $$PollVotesTableReferences._pollIdTable(db),
                    referencedColumn:
                        $$PollVotesTableReferences._pollIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PollVotesTableProcessedTableManager = ProcessedTableManager<
    _$DriftChatDatabase,
    $PollVotesTable,
    PollVoteEntity,
    $$PollVotesTableFilterComposer,
    $$PollVotesTableOrderingComposer,
    $$PollVotesTableAnnotationComposer,
    $$PollVotesTableCreateCompanionBuilder,
    $$PollVotesTableUpdateCompanionBuilder,
    (PollVoteEntity, $$PollVotesTableReferences),
    PollVoteEntity,
    PrefetchHooks Function({bool pollId})>;
typedef $$PinnedMessageReactionsTableCreateCompanionBuilder
    = PinnedMessageReactionsCompanion Function({
  required String userId,
  required String messageId,
  required String type,
  Value<DateTime> createdAt,
  Value<int> score,
  Value<Map<String, dynamic>?> extraData,
  Value<int> rowid,
});
typedef $$PinnedMessageReactionsTableUpdateCompanionBuilder
    = PinnedMessageReactionsCompanion Function({
  Value<String> userId,
  Value<String> messageId,
  Value<String> type,
  Value<DateTime> createdAt,
  Value<int> score,
  Value<Map<String, dynamic>?> extraData,
  Value<int> rowid,
});

final class $$PinnedMessageReactionsTableReferences extends BaseReferences<
    _$DriftChatDatabase,
    $PinnedMessageReactionsTable,
    PinnedMessageReactionEntity> {
  $$PinnedMessageReactionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PinnedMessagesTable _messageIdTable(_$DriftChatDatabase db) =>
      db.pinnedMessages.createAlias($_aliasNameGenerator(
          db.pinnedMessageReactions.messageId, db.pinnedMessages.id));

  $$PinnedMessagesTableProcessedTableManager get messageId {
    final manager = $$PinnedMessagesTableTableManager($_db, $_db.pinnedMessages)
        .filter((f) => f.id($_item.messageId!));
    final item = $_typedResult.readTableOrNull(_messageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PinnedMessageReactionsTableFilterComposer
    extends Composer<_$DriftChatDatabase, $PinnedMessageReactionsTable> {
  $$PinnedMessageReactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>?, Map<String, dynamic>,
          String>
      get extraData => $composableBuilder(
          column: $table.extraData,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$PinnedMessagesTableFilterComposer get messageId {
    final $$PinnedMessagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.messageId,
        referencedTable: $db.pinnedMessages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PinnedMessagesTableFilterComposer(
              $db: $db,
              $table: $db.pinnedMessages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PinnedMessageReactionsTableOrderingComposer
    extends Composer<_$DriftChatDatabase, $PinnedMessageReactionsTable> {
  $$PinnedMessageReactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extraData => $composableBuilder(
      column: $table.extraData, builder: (column) => ColumnOrderings(column));

  $$PinnedMessagesTableOrderingComposer get messageId {
    final $$PinnedMessagesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.messageId,
        referencedTable: $db.pinnedMessages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PinnedMessagesTableOrderingComposer(
              $db: $db,
              $table: $db.pinnedMessages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PinnedMessageReactionsTableAnnotationComposer
    extends Composer<_$DriftChatDatabase, $PinnedMessageReactionsTable> {
  $$PinnedMessageReactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      get extraData => $composableBuilder(
          column: $table.extraData, builder: (column) => column);

  $$PinnedMessagesTableAnnotationComposer get messageId {
    final $$PinnedMessagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.messageId,
        referencedTable: $db.pinnedMessages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PinnedMessagesTableAnnotationComposer(
              $db: $db,
              $table: $db.pinnedMessages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PinnedMessageReactionsTableTableManager extends RootTableManager<
    _$DriftChatDatabase,
    $PinnedMessageReactionsTable,
    PinnedMessageReactionEntity,
    $$PinnedMessageReactionsTableFilterComposer,
    $$PinnedMessageReactionsTableOrderingComposer,
    $$PinnedMessageReactionsTableAnnotationComposer,
    $$PinnedMessageReactionsTableCreateCompanionBuilder,
    $$PinnedMessageReactionsTableUpdateCompanionBuilder,
    (PinnedMessageReactionEntity, $$PinnedMessageReactionsTableReferences),
    PinnedMessageReactionEntity,
    PrefetchHooks Function({bool messageId})> {
  $$PinnedMessageReactionsTableTableManager(
      _$DriftChatDatabase db, $PinnedMessageReactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PinnedMessageReactionsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$PinnedMessageReactionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PinnedMessageReactionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<String> messageId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> score = const Value.absent(),
            Value<Map<String, dynamic>?> extraData = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PinnedMessageReactionsCompanion(
            userId: userId,
            messageId: messageId,
            type: type,
            createdAt: createdAt,
            score: score,
            extraData: extraData,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required String messageId,
            required String type,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> score = const Value.absent(),
            Value<Map<String, dynamic>?> extraData = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PinnedMessageReactionsCompanion.insert(
            userId: userId,
            messageId: messageId,
            type: type,
            createdAt: createdAt,
            score: score,
            extraData: extraData,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PinnedMessageReactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({messageId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (messageId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.messageId,
                    referencedTable: $$PinnedMessageReactionsTableReferences
                        ._messageIdTable(db),
                    referencedColumn: $$PinnedMessageReactionsTableReferences
                        ._messageIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PinnedMessageReactionsTableProcessedTableManager
    = ProcessedTableManager<
        _$DriftChatDatabase,
        $PinnedMessageReactionsTable,
        PinnedMessageReactionEntity,
        $$PinnedMessageReactionsTableFilterComposer,
        $$PinnedMessageReactionsTableOrderingComposer,
        $$PinnedMessageReactionsTableAnnotationComposer,
        $$PinnedMessageReactionsTableCreateCompanionBuilder,
        $$PinnedMessageReactionsTableUpdateCompanionBuilder,
        (PinnedMessageReactionEntity, $$PinnedMessageReactionsTableReferences),
        PinnedMessageReactionEntity,
        PrefetchHooks Function({bool messageId})>;
typedef $$ReactionsTableCreateCompanionBuilder = ReactionsCompanion Function({
  required String userId,
  required String messageId,
  required String type,
  Value<DateTime> createdAt,
  Value<int> score,
  Value<Map<String, dynamic>?> extraData,
  Value<int> rowid,
});
typedef $$ReactionsTableUpdateCompanionBuilder = ReactionsCompanion Function({
  Value<String> userId,
  Value<String> messageId,
  Value<String> type,
  Value<DateTime> createdAt,
  Value<int> score,
  Value<Map<String, dynamic>?> extraData,
  Value<int> rowid,
});

final class $$ReactionsTableReferences extends BaseReferences<
    _$DriftChatDatabase, $ReactionsTable, ReactionEntity> {
  $$ReactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MessagesTable _messageIdTable(_$DriftChatDatabase db) =>
      db.messages.createAlias(
          $_aliasNameGenerator(db.reactions.messageId, db.messages.id));

  $$MessagesTableProcessedTableManager get messageId {
    final manager = $$MessagesTableTableManager($_db, $_db.messages)
        .filter((f) => f.id($_item.messageId!));
    final item = $_typedResult.readTableOrNull(_messageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ReactionsTableFilterComposer
    extends Composer<_$DriftChatDatabase, $ReactionsTable> {
  $$ReactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>?, Map<String, dynamic>,
          String>
      get extraData => $composableBuilder(
          column: $table.extraData,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$MessagesTableFilterComposer get messageId {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.messageId,
        referencedTable: $db.messages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessagesTableFilterComposer(
              $db: $db,
              $table: $db.messages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReactionsTableOrderingComposer
    extends Composer<_$DriftChatDatabase, $ReactionsTable> {
  $$ReactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extraData => $composableBuilder(
      column: $table.extraData, builder: (column) => ColumnOrderings(column));

  $$MessagesTableOrderingComposer get messageId {
    final $$MessagesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.messageId,
        referencedTable: $db.messages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessagesTableOrderingComposer(
              $db: $db,
              $table: $db.messages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReactionsTableAnnotationComposer
    extends Composer<_$DriftChatDatabase, $ReactionsTable> {
  $$ReactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      get extraData => $composableBuilder(
          column: $table.extraData, builder: (column) => column);

  $$MessagesTableAnnotationComposer get messageId {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.messageId,
        referencedTable: $db.messages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessagesTableAnnotationComposer(
              $db: $db,
              $table: $db.messages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReactionsTableTableManager extends RootTableManager<
    _$DriftChatDatabase,
    $ReactionsTable,
    ReactionEntity,
    $$ReactionsTableFilterComposer,
    $$ReactionsTableOrderingComposer,
    $$ReactionsTableAnnotationComposer,
    $$ReactionsTableCreateCompanionBuilder,
    $$ReactionsTableUpdateCompanionBuilder,
    (ReactionEntity, $$ReactionsTableReferences),
    ReactionEntity,
    PrefetchHooks Function({bool messageId})> {
  $$ReactionsTableTableManager(_$DriftChatDatabase db, $ReactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<String> messageId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> score = const Value.absent(),
            Value<Map<String, dynamic>?> extraData = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReactionsCompanion(
            userId: userId,
            messageId: messageId,
            type: type,
            createdAt: createdAt,
            score: score,
            extraData: extraData,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required String messageId,
            required String type,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> score = const Value.absent(),
            Value<Map<String, dynamic>?> extraData = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReactionsCompanion.insert(
            userId: userId,
            messageId: messageId,
            type: type,
            createdAt: createdAt,
            score: score,
            extraData: extraData,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ReactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({messageId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (messageId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.messageId,
                    referencedTable:
                        $$ReactionsTableReferences._messageIdTable(db),
                    referencedColumn:
                        $$ReactionsTableReferences._messageIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ReactionsTableProcessedTableManager = ProcessedTableManager<
    _$DriftChatDatabase,
    $ReactionsTable,
    ReactionEntity,
    $$ReactionsTableFilterComposer,
    $$ReactionsTableOrderingComposer,
    $$ReactionsTableAnnotationComposer,
    $$ReactionsTableCreateCompanionBuilder,
    $$ReactionsTableUpdateCompanionBuilder,
    (ReactionEntity, $$ReactionsTableReferences),
    ReactionEntity,
    PrefetchHooks Function({bool messageId})>;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  Value<String?> role,
  Value<String?> language,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<DateTime?> lastActive,
  Value<bool> online,
  Value<bool> banned,
  required Map<String, dynamic> extraData,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String?> role,
  Value<String?> language,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<DateTime?> lastActive,
  Value<bool> online,
  Value<bool> banned,
  Value<Map<String, dynamic>> extraData,
  Value<int> rowid,
});

class $$UsersTableFilterComposer
    extends Composer<_$DriftChatDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastActive => $composableBuilder(
      column: $table.lastActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get online => $composableBuilder(
      column: $table.online, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get banned => $composableBuilder(
      column: $table.banned, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get extraData => $composableBuilder(
          column: $table.extraData,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$DriftChatDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastActive => $composableBuilder(
      column: $table.lastActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get online => $composableBuilder(
      column: $table.online, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get banned => $composableBuilder(
      column: $table.banned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extraData => $composableBuilder(
      column: $table.extraData, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$DriftChatDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastActive => $composableBuilder(
      column: $table.lastActive, builder: (column) => column);

  GeneratedColumn<bool> get online =>
      $composableBuilder(column: $table.online, builder: (column) => column);

  GeneratedColumn<bool> get banned =>
      $composableBuilder(column: $table.banned, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      get extraData => $composableBuilder(
          column: $table.extraData, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$DriftChatDatabase,
    $UsersTable,
    UserEntity,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (UserEntity, BaseReferences<_$DriftChatDatabase, $UsersTable, UserEntity>),
    UserEntity,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$DriftChatDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> role = const Value.absent(),
            Value<String?> language = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime?> lastActive = const Value.absent(),
            Value<bool> online = const Value.absent(),
            Value<bool> banned = const Value.absent(),
            Value<Map<String, dynamic>> extraData = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            role: role,
            language: language,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastActive: lastActive,
            online: online,
            banned: banned,
            extraData: extraData,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> role = const Value.absent(),
            Value<String?> language = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime?> lastActive = const Value.absent(),
            Value<bool> online = const Value.absent(),
            Value<bool> banned = const Value.absent(),
            required Map<String, dynamic> extraData,
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            role: role,
            language: language,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastActive: lastActive,
            online: online,
            banned: banned,
            extraData: extraData,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$DriftChatDatabase,
    $UsersTable,
    UserEntity,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (UserEntity, BaseReferences<_$DriftChatDatabase, $UsersTable, UserEntity>),
    UserEntity,
    PrefetchHooks Function()>;
typedef $$MembersTableCreateCompanionBuilder = MembersCompanion Function({
  required String userId,
  required String channelCid,
  Value<String?> channelRole,
  Value<DateTime?> inviteAcceptedAt,
  Value<DateTime?> inviteRejectedAt,
  Value<bool> invited,
  Value<bool> banned,
  Value<bool> shadowBanned,
  Value<bool> isModerator,
  Value<Map<String, dynamic>?> extraData,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$MembersTableUpdateCompanionBuilder = MembersCompanion Function({
  Value<String> userId,
  Value<String> channelCid,
  Value<String?> channelRole,
  Value<DateTime?> inviteAcceptedAt,
  Value<DateTime?> inviteRejectedAt,
  Value<bool> invited,
  Value<bool> banned,
  Value<bool> shadowBanned,
  Value<bool> isModerator,
  Value<Map<String, dynamic>?> extraData,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$MembersTableReferences
    extends BaseReferences<_$DriftChatDatabase, $MembersTable, MemberEntity> {
  $$MembersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChannelsTable _channelCidTable(_$DriftChatDatabase db) =>
      db.channels.createAlias(
          $_aliasNameGenerator(db.members.channelCid, db.channels.cid));

  $$ChannelsTableProcessedTableManager get channelCid {
    final manager = $$ChannelsTableTableManager($_db, $_db.channels)
        .filter((f) => f.cid($_item.channelCid!));
    final item = $_typedResult.readTableOrNull(_channelCidTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MembersTableFilterComposer
    extends Composer<_$DriftChatDatabase, $MembersTable> {
  $$MembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get channelRole => $composableBuilder(
      column: $table.channelRole, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get inviteAcceptedAt => $composableBuilder(
      column: $table.inviteAcceptedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get inviteRejectedAt => $composableBuilder(
      column: $table.inviteRejectedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get invited => $composableBuilder(
      column: $table.invited, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get banned => $composableBuilder(
      column: $table.banned, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get shadowBanned => $composableBuilder(
      column: $table.shadowBanned, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isModerator => $composableBuilder(
      column: $table.isModerator, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>?, Map<String, dynamic>,
          String>
      get extraData => $composableBuilder(
          column: $table.extraData,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$ChannelsTableFilterComposer get channelCid {
    final $$ChannelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.channelCid,
        referencedTable: $db.channels,
        getReferencedColumn: (t) => t.cid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChannelsTableFilterComposer(
              $db: $db,
              $table: $db.channels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MembersTableOrderingComposer
    extends Composer<_$DriftChatDatabase, $MembersTable> {
  $$MembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get channelRole => $composableBuilder(
      column: $table.channelRole, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get inviteAcceptedAt => $composableBuilder(
      column: $table.inviteAcceptedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get inviteRejectedAt => $composableBuilder(
      column: $table.inviteRejectedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get invited => $composableBuilder(
      column: $table.invited, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get banned => $composableBuilder(
      column: $table.banned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get shadowBanned => $composableBuilder(
      column: $table.shadowBanned,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isModerator => $composableBuilder(
      column: $table.isModerator, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extraData => $composableBuilder(
      column: $table.extraData, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$ChannelsTableOrderingComposer get channelCid {
    final $$ChannelsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.channelCid,
        referencedTable: $db.channels,
        getReferencedColumn: (t) => t.cid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChannelsTableOrderingComposer(
              $db: $db,
              $table: $db.channels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MembersTableAnnotationComposer
    extends Composer<_$DriftChatDatabase, $MembersTable> {
  $$MembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get channelRole => $composableBuilder(
      column: $table.channelRole, builder: (column) => column);

  GeneratedColumn<DateTime> get inviteAcceptedAt => $composableBuilder(
      column: $table.inviteAcceptedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get inviteRejectedAt => $composableBuilder(
      column: $table.inviteRejectedAt, builder: (column) => column);

  GeneratedColumn<bool> get invited =>
      $composableBuilder(column: $table.invited, builder: (column) => column);

  GeneratedColumn<bool> get banned =>
      $composableBuilder(column: $table.banned, builder: (column) => column);

  GeneratedColumn<bool> get shadowBanned => $composableBuilder(
      column: $table.shadowBanned, builder: (column) => column);

  GeneratedColumn<bool> get isModerator => $composableBuilder(
      column: $table.isModerator, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      get extraData => $composableBuilder(
          column: $table.extraData, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ChannelsTableAnnotationComposer get channelCid {
    final $$ChannelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.channelCid,
        referencedTable: $db.channels,
        getReferencedColumn: (t) => t.cid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChannelsTableAnnotationComposer(
              $db: $db,
              $table: $db.channels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MembersTableTableManager extends RootTableManager<
    _$DriftChatDatabase,
    $MembersTable,
    MemberEntity,
    $$MembersTableFilterComposer,
    $$MembersTableOrderingComposer,
    $$MembersTableAnnotationComposer,
    $$MembersTableCreateCompanionBuilder,
    $$MembersTableUpdateCompanionBuilder,
    (MemberEntity, $$MembersTableReferences),
    MemberEntity,
    PrefetchHooks Function({bool channelCid})> {
  $$MembersTableTableManager(_$DriftChatDatabase db, $MembersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<String> channelCid = const Value.absent(),
            Value<String?> channelRole = const Value.absent(),
            Value<DateTime?> inviteAcceptedAt = const Value.absent(),
            Value<DateTime?> inviteRejectedAt = const Value.absent(),
            Value<bool> invited = const Value.absent(),
            Value<bool> banned = const Value.absent(),
            Value<bool> shadowBanned = const Value.absent(),
            Value<bool> isModerator = const Value.absent(),
            Value<Map<String, dynamic>?> extraData = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MembersCompanion(
            userId: userId,
            channelCid: channelCid,
            channelRole: channelRole,
            inviteAcceptedAt: inviteAcceptedAt,
            inviteRejectedAt: inviteRejectedAt,
            invited: invited,
            banned: banned,
            shadowBanned: shadowBanned,
            isModerator: isModerator,
            extraData: extraData,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required String channelCid,
            Value<String?> channelRole = const Value.absent(),
            Value<DateTime?> inviteAcceptedAt = const Value.absent(),
            Value<DateTime?> inviteRejectedAt = const Value.absent(),
            Value<bool> invited = const Value.absent(),
            Value<bool> banned = const Value.absent(),
            Value<bool> shadowBanned = const Value.absent(),
            Value<bool> isModerator = const Value.absent(),
            Value<Map<String, dynamic>?> extraData = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MembersCompanion.insert(
            userId: userId,
            channelCid: channelCid,
            channelRole: channelRole,
            inviteAcceptedAt: inviteAcceptedAt,
            inviteRejectedAt: inviteRejectedAt,
            invited: invited,
            banned: banned,
            shadowBanned: shadowBanned,
            isModerator: isModerator,
            extraData: extraData,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MembersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({channelCid = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (channelCid) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.channelCid,
                    referencedTable:
                        $$MembersTableReferences._channelCidTable(db),
                    referencedColumn:
                        $$MembersTableReferences._channelCidTable(db).cid,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MembersTableProcessedTableManager = ProcessedTableManager<
    _$DriftChatDatabase,
    $MembersTable,
    MemberEntity,
    $$MembersTableFilterComposer,
    $$MembersTableOrderingComposer,
    $$MembersTableAnnotationComposer,
    $$MembersTableCreateCompanionBuilder,
    $$MembersTableUpdateCompanionBuilder,
    (MemberEntity, $$MembersTableReferences),
    MemberEntity,
    PrefetchHooks Function({bool channelCid})>;
typedef $$ReadsTableCreateCompanionBuilder = ReadsCompanion Function({
  required DateTime lastRead,
  required String userId,
  required String channelCid,
  Value<int> unreadMessages,
  Value<String?> lastReadMessageId,
  Value<int> rowid,
});
typedef $$ReadsTableUpdateCompanionBuilder = ReadsCompanion Function({
  Value<DateTime> lastRead,
  Value<String> userId,
  Value<String> channelCid,
  Value<int> unreadMessages,
  Value<String?> lastReadMessageId,
  Value<int> rowid,
});

final class $$ReadsTableReferences
    extends BaseReferences<_$DriftChatDatabase, $ReadsTable, ReadEntity> {
  $$ReadsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChannelsTable _channelCidTable(_$DriftChatDatabase db) => db.channels
      .createAlias($_aliasNameGenerator(db.reads.channelCid, db.channels.cid));

  $$ChannelsTableProcessedTableManager get channelCid {
    final manager = $$ChannelsTableTableManager($_db, $_db.channels)
        .filter((f) => f.cid($_item.channelCid!));
    final item = $_typedResult.readTableOrNull(_channelCidTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ReadsTableFilterComposer
    extends Composer<_$DriftChatDatabase, $ReadsTable> {
  $$ReadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get lastRead => $composableBuilder(
      column: $table.lastRead, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unreadMessages => $composableBuilder(
      column: $table.unreadMessages,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastReadMessageId => $composableBuilder(
      column: $table.lastReadMessageId,
      builder: (column) => ColumnFilters(column));

  $$ChannelsTableFilterComposer get channelCid {
    final $$ChannelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.channelCid,
        referencedTable: $db.channels,
        getReferencedColumn: (t) => t.cid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChannelsTableFilterComposer(
              $db: $db,
              $table: $db.channels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReadsTableOrderingComposer
    extends Composer<_$DriftChatDatabase, $ReadsTable> {
  $$ReadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get lastRead => $composableBuilder(
      column: $table.lastRead, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unreadMessages => $composableBuilder(
      column: $table.unreadMessages,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastReadMessageId => $composableBuilder(
      column: $table.lastReadMessageId,
      builder: (column) => ColumnOrderings(column));

  $$ChannelsTableOrderingComposer get channelCid {
    final $$ChannelsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.channelCid,
        referencedTable: $db.channels,
        getReferencedColumn: (t) => t.cid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChannelsTableOrderingComposer(
              $db: $db,
              $table: $db.channels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReadsTableAnnotationComposer
    extends Composer<_$DriftChatDatabase, $ReadsTable> {
  $$ReadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get lastRead =>
      $composableBuilder(column: $table.lastRead, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get unreadMessages => $composableBuilder(
      column: $table.unreadMessages, builder: (column) => column);

  GeneratedColumn<String> get lastReadMessageId => $composableBuilder(
      column: $table.lastReadMessageId, builder: (column) => column);

  $$ChannelsTableAnnotationComposer get channelCid {
    final $$ChannelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.channelCid,
        referencedTable: $db.channels,
        getReferencedColumn: (t) => t.cid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChannelsTableAnnotationComposer(
              $db: $db,
              $table: $db.channels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReadsTableTableManager extends RootTableManager<
    _$DriftChatDatabase,
    $ReadsTable,
    ReadEntity,
    $$ReadsTableFilterComposer,
    $$ReadsTableOrderingComposer,
    $$ReadsTableAnnotationComposer,
    $$ReadsTableCreateCompanionBuilder,
    $$ReadsTableUpdateCompanionBuilder,
    (ReadEntity, $$ReadsTableReferences),
    ReadEntity,
    PrefetchHooks Function({bool channelCid})> {
  $$ReadsTableTableManager(_$DriftChatDatabase db, $ReadsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<DateTime> lastRead = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> channelCid = const Value.absent(),
            Value<int> unreadMessages = const Value.absent(),
            Value<String?> lastReadMessageId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReadsCompanion(
            lastRead: lastRead,
            userId: userId,
            channelCid: channelCid,
            unreadMessages: unreadMessages,
            lastReadMessageId: lastReadMessageId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required DateTime lastRead,
            required String userId,
            required String channelCid,
            Value<int> unreadMessages = const Value.absent(),
            Value<String?> lastReadMessageId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReadsCompanion.insert(
            lastRead: lastRead,
            userId: userId,
            channelCid: channelCid,
            unreadMessages: unreadMessages,
            lastReadMessageId: lastReadMessageId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ReadsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({channelCid = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (channelCid) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.channelCid,
                    referencedTable:
                        $$ReadsTableReferences._channelCidTable(db),
                    referencedColumn:
                        $$ReadsTableReferences._channelCidTable(db).cid,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ReadsTableProcessedTableManager = ProcessedTableManager<
    _$DriftChatDatabase,
    $ReadsTable,
    ReadEntity,
    $$ReadsTableFilterComposer,
    $$ReadsTableOrderingComposer,
    $$ReadsTableAnnotationComposer,
    $$ReadsTableCreateCompanionBuilder,
    $$ReadsTableUpdateCompanionBuilder,
    (ReadEntity, $$ReadsTableReferences),
    ReadEntity,
    PrefetchHooks Function({bool channelCid})>;
typedef $$ChannelQueriesTableCreateCompanionBuilder = ChannelQueriesCompanion
    Function({
  required String queryHash,
  required String channelCid,
  Value<int> rowid,
});
typedef $$ChannelQueriesTableUpdateCompanionBuilder = ChannelQueriesCompanion
    Function({
  Value<String> queryHash,
  Value<String> channelCid,
  Value<int> rowid,
});

class $$ChannelQueriesTableFilterComposer
    extends Composer<_$DriftChatDatabase, $ChannelQueriesTable> {
  $$ChannelQueriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get queryHash => $composableBuilder(
      column: $table.queryHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get channelCid => $composableBuilder(
      column: $table.channelCid, builder: (column) => ColumnFilters(column));
}

class $$ChannelQueriesTableOrderingComposer
    extends Composer<_$DriftChatDatabase, $ChannelQueriesTable> {
  $$ChannelQueriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get queryHash => $composableBuilder(
      column: $table.queryHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get channelCid => $composableBuilder(
      column: $table.channelCid, builder: (column) => ColumnOrderings(column));
}

class $$ChannelQueriesTableAnnotationComposer
    extends Composer<_$DriftChatDatabase, $ChannelQueriesTable> {
  $$ChannelQueriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get queryHash =>
      $composableBuilder(column: $table.queryHash, builder: (column) => column);

  GeneratedColumn<String> get channelCid => $composableBuilder(
      column: $table.channelCid, builder: (column) => column);
}

class $$ChannelQueriesTableTableManager extends RootTableManager<
    _$DriftChatDatabase,
    $ChannelQueriesTable,
    ChannelQueryEntity,
    $$ChannelQueriesTableFilterComposer,
    $$ChannelQueriesTableOrderingComposer,
    $$ChannelQueriesTableAnnotationComposer,
    $$ChannelQueriesTableCreateCompanionBuilder,
    $$ChannelQueriesTableUpdateCompanionBuilder,
    (
      ChannelQueryEntity,
      BaseReferences<_$DriftChatDatabase, $ChannelQueriesTable,
          ChannelQueryEntity>
    ),
    ChannelQueryEntity,
    PrefetchHooks Function()> {
  $$ChannelQueriesTableTableManager(
      _$DriftChatDatabase db, $ChannelQueriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelQueriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelQueriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelQueriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> queryHash = const Value.absent(),
            Value<String> channelCid = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChannelQueriesCompanion(
            queryHash: queryHash,
            channelCid: channelCid,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String queryHash,
            required String channelCid,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChannelQueriesCompanion.insert(
            queryHash: queryHash,
            channelCid: channelCid,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChannelQueriesTableProcessedTableManager = ProcessedTableManager<
    _$DriftChatDatabase,
    $ChannelQueriesTable,
    ChannelQueryEntity,
    $$ChannelQueriesTableFilterComposer,
    $$ChannelQueriesTableOrderingComposer,
    $$ChannelQueriesTableAnnotationComposer,
    $$ChannelQueriesTableCreateCompanionBuilder,
    $$ChannelQueriesTableUpdateCompanionBuilder,
    (
      ChannelQueryEntity,
      BaseReferences<_$DriftChatDatabase, $ChannelQueriesTable,
          ChannelQueryEntity>
    ),
    ChannelQueryEntity,
    PrefetchHooks Function()>;
typedef $$ConnectionEventsTableCreateCompanionBuilder
    = ConnectionEventsCompanion Function({
  Value<int> id,
  required String type,
  Value<Map<String, dynamic>?> ownUser,
  Value<int?> totalUnreadCount,
  Value<int?> unreadChannels,
  Value<DateTime?> lastEventAt,
  Value<DateTime?> lastSyncAt,
});
typedef $$ConnectionEventsTableUpdateCompanionBuilder
    = ConnectionEventsCompanion Function({
  Value<int> id,
  Value<String> type,
  Value<Map<String, dynamic>?> ownUser,
  Value<int?> totalUnreadCount,
  Value<int?> unreadChannels,
  Value<DateTime?> lastEventAt,
  Value<DateTime?> lastSyncAt,
});

class $$ConnectionEventsTableFilterComposer
    extends Composer<_$DriftChatDatabase, $ConnectionEventsTable> {
  $$ConnectionEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>?, Map<String, dynamic>,
          String>
      get ownUser => $composableBuilder(
          column: $table.ownUser,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get totalUnreadCount => $composableBuilder(
      column: $table.totalUnreadCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unreadChannels => $composableBuilder(
      column: $table.unreadChannels,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastEventAt => $composableBuilder(
      column: $table.lastEventAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => ColumnFilters(column));
}

class $$ConnectionEventsTableOrderingComposer
    extends Composer<_$DriftChatDatabase, $ConnectionEventsTable> {
  $$ConnectionEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownUser => $composableBuilder(
      column: $table.ownUser, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalUnreadCount => $composableBuilder(
      column: $table.totalUnreadCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unreadChannels => $composableBuilder(
      column: $table.unreadChannels,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastEventAt => $composableBuilder(
      column: $table.lastEventAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => ColumnOrderings(column));
}

class $$ConnectionEventsTableAnnotationComposer
    extends Composer<_$DriftChatDatabase, $ConnectionEventsTable> {
  $$ConnectionEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String> get ownUser =>
      $composableBuilder(column: $table.ownUser, builder: (column) => column);

  GeneratedColumn<int> get totalUnreadCount => $composableBuilder(
      column: $table.totalUnreadCount, builder: (column) => column);

  GeneratedColumn<int> get unreadChannels => $composableBuilder(
      column: $table.unreadChannels, builder: (column) => column);

  GeneratedColumn<DateTime> get lastEventAt => $composableBuilder(
      column: $table.lastEventAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => column);
}

class $$ConnectionEventsTableTableManager extends RootTableManager<
    _$DriftChatDatabase,
    $ConnectionEventsTable,
    ConnectionEventEntity,
    $$ConnectionEventsTableFilterComposer,
    $$ConnectionEventsTableOrderingComposer,
    $$ConnectionEventsTableAnnotationComposer,
    $$ConnectionEventsTableCreateCompanionBuilder,
    $$ConnectionEventsTableUpdateCompanionBuilder,
    (
      ConnectionEventEntity,
      BaseReferences<_$DriftChatDatabase, $ConnectionEventsTable,
          ConnectionEventEntity>
    ),
    ConnectionEventEntity,
    PrefetchHooks Function()> {
  $$ConnectionEventsTableTableManager(
      _$DriftChatDatabase db, $ConnectionEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConnectionEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConnectionEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConnectionEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<Map<String, dynamic>?> ownUser = const Value.absent(),
            Value<int?> totalUnreadCount = const Value.absent(),
            Value<int?> unreadChannels = const Value.absent(),
            Value<DateTime?> lastEventAt = const Value.absent(),
            Value<DateTime?> lastSyncAt = const Value.absent(),
          }) =>
              ConnectionEventsCompanion(
            id: id,
            type: type,
            ownUser: ownUser,
            totalUnreadCount: totalUnreadCount,
            unreadChannels: unreadChannels,
            lastEventAt: lastEventAt,
            lastSyncAt: lastSyncAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String type,
            Value<Map<String, dynamic>?> ownUser = const Value.absent(),
            Value<int?> totalUnreadCount = const Value.absent(),
            Value<int?> unreadChannels = const Value.absent(),
            Value<DateTime?> lastEventAt = const Value.absent(),
            Value<DateTime?> lastSyncAt = const Value.absent(),
          }) =>
              ConnectionEventsCompanion.insert(
            id: id,
            type: type,
            ownUser: ownUser,
            totalUnreadCount: totalUnreadCount,
            unreadChannels: unreadChannels,
            lastEventAt: lastEventAt,
            lastSyncAt: lastSyncAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConnectionEventsTableProcessedTableManager = ProcessedTableManager<
    _$DriftChatDatabase,
    $ConnectionEventsTable,
    ConnectionEventEntity,
    $$ConnectionEventsTableFilterComposer,
    $$ConnectionEventsTableOrderingComposer,
    $$ConnectionEventsTableAnnotationComposer,
    $$ConnectionEventsTableCreateCompanionBuilder,
    $$ConnectionEventsTableUpdateCompanionBuilder,
    (
      ConnectionEventEntity,
      BaseReferences<_$DriftChatDatabase, $ConnectionEventsTable,
          ConnectionEventEntity>
    ),
    ConnectionEventEntity,
    PrefetchHooks Function()>;

class $DriftChatDatabaseManager {
  final _$DriftChatDatabase _db;
  $DriftChatDatabaseManager(this._db);
  $$ChannelsTableTableManager get channels =>
      $$ChannelsTableTableManager(_db, _db.channels);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
  $$PinnedMessagesTableTableManager get pinnedMessages =>
      $$PinnedMessagesTableTableManager(_db, _db.pinnedMessages);
  $$PollsTableTableManager get polls =>
      $$PollsTableTableManager(_db, _db.polls);
  $$PollVotesTableTableManager get pollVotes =>
      $$PollVotesTableTableManager(_db, _db.pollVotes);
  $$PinnedMessageReactionsTableTableManager get pinnedMessageReactions =>
      $$PinnedMessageReactionsTableTableManager(
          _db, _db.pinnedMessageReactions);
  $$ReactionsTableTableManager get reactions =>
      $$ReactionsTableTableManager(_db, _db.reactions);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$MembersTableTableManager get members =>
      $$MembersTableTableManager(_db, _db.members);
  $$ReadsTableTableManager get reads =>
      $$ReadsTableTableManager(_db, _db.reads);
  $$ChannelQueriesTableTableManager get channelQueries =>
      $$ChannelQueriesTableTableManager(_db, _db.channelQueries);
  $$ConnectionEventsTableTableManager get connectionEvents =>
      $$ConnectionEventsTableTableManager(_db, _db.connectionEvents);
}
