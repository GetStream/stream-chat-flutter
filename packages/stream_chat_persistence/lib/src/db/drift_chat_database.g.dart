// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_chat_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class ChannelEntity extends DataClass implements Insertable<ChannelEntity> {
  /// The id of this channel
  final String id;

  /// The type of this channel
  final String type;

  /// The cid of this channel
  final String cid;

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
  final Map<String, Object?>? extraData;
  ChannelEntity(
      {required this.id,
      required this.type,
      required this.cid,
      required this.config,
      required this.frozen,
      this.lastMessageAt,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.memberCount,
      this.createdById,
      this.extraData});
  factory ChannelEntity.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ChannelEntity(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      type: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      cid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cid'])!,
      config: $ChannelsTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}config']))!,
      frozen: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}frozen'])!,
      lastMessageAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_message_at']),
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      deletedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted_at']),
      memberCount: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}member_count'])!,
      createdById: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_by_id']),
      extraData: $ChannelsTable.$converter1.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}extra_data'])),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['cid'] = Variable<String>(cid);
    {
      final converter = $ChannelsTable.$converter0;
      map['config'] = Variable<String>(converter.mapToSql(config)!);
    }
    map['frozen'] = Variable<bool>(frozen);
    if (!nullToAbsent || lastMessageAt != null) {
      map['last_message_at'] = Variable<DateTime?>(lastMessageAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime?>(deletedAt);
    }
    map['member_count'] = Variable<int>(memberCount);
    if (!nullToAbsent || createdById != null) {
      map['created_by_id'] = Variable<String?>(createdById);
    }
    if (!nullToAbsent || extraData != null) {
      final converter = $ChannelsTable.$converter1;
      map['extra_data'] = Variable<String?>(converter.mapToSql(extraData));
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
      config: serializer.fromJson<Map<String, dynamic>>(json['config']),
      frozen: serializer.fromJson<bool>(json['frozen']),
      lastMessageAt: serializer.fromJson<DateTime?>(json['lastMessageAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      memberCount: serializer.fromJson<int>(json['memberCount']),
      createdById: serializer.fromJson<String?>(json['createdById']),
      extraData: serializer.fromJson<Map<String, Object?>?>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'cid': serializer.toJson<String>(cid),
      'config': serializer.toJson<Map<String, dynamic>>(config),
      'frozen': serializer.toJson<bool>(frozen),
      'lastMessageAt': serializer.toJson<DateTime?>(lastMessageAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'memberCount': serializer.toJson<int>(memberCount),
      'createdById': serializer.toJson<String?>(createdById),
      'extraData': serializer.toJson<Map<String, Object?>?>(extraData),
    };
  }

  ChannelEntity copyWith(
          {String? id,
          String? type,
          String? cid,
          Map<String, dynamic>? config,
          bool? frozen,
          Value<DateTime?> lastMessageAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          int? memberCount,
          Value<String?> createdById = const Value.absent(),
          Value<Map<String, Object?>?> extraData = const Value.absent()}) =>
      ChannelEntity(
        id: id ?? this.id,
        type: type ?? this.type,
        cid: cid ?? this.cid,
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
  @override
  String toString() {
    return (StringBuffer('ChannelEntity(')
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
          ..write('createdById: $createdById, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, cid, config, frozen, lastMessageAt,
      createdAt, updatedAt, deletedAt, memberCount, createdById, extraData);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelEntity &&
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
          other.createdById == this.createdById &&
          other.extraData == this.extraData);
}

class ChannelsCompanion extends UpdateCompanion<ChannelEntity> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> cid;
  final Value<Map<String, dynamic>> config;
  final Value<bool> frozen;
  final Value<DateTime?> lastMessageAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> memberCount;
  final Value<String?> createdById;
  final Value<Map<String, Object?>?> extraData;
  const ChannelsCompanion({
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
    this.createdById = const Value.absent(),
    this.extraData = const Value.absent(),
  });
  ChannelsCompanion.insert({
    required String id,
    required String type,
    required String cid,
    required Map<String, dynamic> config,
    this.frozen = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.memberCount = const Value.absent(),
    this.createdById = const Value.absent(),
    this.extraData = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        cid = Value(cid),
        config = Value(config);
  static Insertable<ChannelEntity> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? cid,
    Expression<Map<String, dynamic>>? config,
    Expression<bool>? frozen,
    Expression<DateTime?>? lastMessageAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime?>? deletedAt,
    Expression<int>? memberCount,
    Expression<String?>? createdById,
    Expression<Map<String, Object?>?>? extraData,
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
      if (createdById != null) 'created_by_id': createdById,
      if (extraData != null) 'extra_data': extraData,
    });
  }

  ChannelsCompanion copyWith(
      {Value<String>? id,
      Value<String>? type,
      Value<String>? cid,
      Value<Map<String, dynamic>>? config,
      Value<bool>? frozen,
      Value<DateTime?>? lastMessageAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? memberCount,
      Value<String?>? createdById,
      Value<Map<String, Object?>?>? extraData}) {
    return ChannelsCompanion(
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
      createdById: createdById ?? this.createdById,
      extraData: extraData ?? this.extraData,
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
      final converter = $ChannelsTable.$converter0;
      map['config'] = Variable<String>(converter.mapToSql(config.value)!);
    }
    if (frozen.present) {
      map['frozen'] = Variable<bool>(frozen.value);
    }
    if (lastMessageAt.present) {
      map['last_message_at'] = Variable<DateTime?>(lastMessageAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime?>(deletedAt.value);
    }
    if (memberCount.present) {
      map['member_count'] = Variable<int>(memberCount.value);
    }
    if (createdById.present) {
      map['created_by_id'] = Variable<String?>(createdById.value);
    }
    if (extraData.present) {
      final converter = $ChannelsTable.$converter1;
      map['extra_data'] =
          Variable<String?>(converter.mapToSql(extraData.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelsCompanion(')
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
          ..write('createdById: $createdById, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }
}

class $ChannelsTable extends Channels
    with TableInfo<$ChannelsTable, ChannelEntity> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ChannelsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String?> type = GeneratedColumn<String?>(
      'type', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _cidMeta = const VerificationMeta('cid');
  @override
  late final GeneratedColumn<String?> cid = GeneratedColumn<String?>(
      'cid', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _configMeta = const VerificationMeta('config');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String?>
      config = GeneratedColumn<String?>('config', aliasedName, false,
              type: const StringType(), requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>($ChannelsTable.$converter0);
  final VerificationMeta _frozenMeta = const VerificationMeta('frozen');
  @override
  late final GeneratedColumn<bool?> frozen = GeneratedColumn<bool?>(
      'frozen', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (frozen IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _lastMessageAtMeta =
      const VerificationMeta('lastMessageAt');
  @override
  late final GeneratedColumn<DateTime?> lastMessageAt =
      GeneratedColumn<DateTime?>('last_message_at', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  final VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime?> deletedAt = GeneratedColumn<DateTime?>(
      'deleted_at', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _memberCountMeta =
      const VerificationMeta('memberCount');
  @override
  late final GeneratedColumn<int?> memberCount = GeneratedColumn<int?>(
      'member_count', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _createdByIdMeta =
      const VerificationMeta('createdById');
  @override
  late final GeneratedColumn<String?> createdById = GeneratedColumn<String?>(
      'created_by_id', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _extraDataMeta = const VerificationMeta('extraData');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String?>
      extraData = GeneratedColumn<String?>('extra_data', aliasedName, true,
              type: const StringType(), requiredDuringInsert: false)
          .withConverter<Map<String, Object?>>($ChannelsTable.$converter1);
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
        createdById,
        extraData
      ];
  @override
  String get aliasedName => _alias ?? 'channels';
  @override
  String get actualTableName => 'channels';
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
    return ChannelEntity.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ChannelsTable createAlias(String alias) {
    return $ChannelsTable(_db, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converter0 =
      MapConverter();
  static TypeConverter<Map<String, Object?>, String> $converter1 =
      MapConverter<Object?>();
}

class MessageEntity extends DataClass implements Insertable<MessageEntity> {
  /// The message id
  final String id;

  /// The text of this message
  final String? messageText;

  /// The list of attachments, either provided by the user
  /// or generated from a command or as a result of URL scraping.
  final List<String> attachments;

  /// The status of a sending message
  final MessageSendingStatus status;

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

  /// Number of replies for this message.
  final int? replyCount;

  /// Check if this message needs to show in the channel.
  final bool? showInChannel;

  /// If true the message is shadowed
  final bool shadowed;

  /// A used command name.
  final String? command;

  /// The DateTime when the message was created.
  final DateTime createdAt;

  /// The DateTime when the message was updated last time.
  final DateTime updatedAt;

  /// The DateTime when the message was deleted.
  final DateTime? deletedAt;

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

  /// Message custom extraData
  final Map<String, Object?>? extraData;
  MessageEntity(
      {required this.id,
      this.messageText,
      required this.attachments,
      required this.status,
      required this.type,
      required this.mentionedUsers,
      this.reactionCounts,
      this.reactionScores,
      this.parentId,
      this.quotedMessageId,
      this.replyCount,
      this.showInChannel,
      required this.shadowed,
      this.command,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      this.userId,
      required this.pinned,
      this.pinnedAt,
      this.pinExpires,
      this.pinnedByUserId,
      required this.channelCid,
      this.i18n,
      this.extraData});
  factory MessageEntity.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return MessageEntity(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      messageText: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}message_text']),
      attachments: $MessagesTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}attachments']))!,
      status: $MessagesTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status']))!,
      type: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      mentionedUsers: $MessagesTable.$converter2.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}mentioned_users']))!,
      reactionCounts: $MessagesTable.$converter3.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}reaction_counts'])),
      reactionScores: $MessagesTable.$converter4.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}reaction_scores'])),
      parentId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}parent_id']),
      quotedMessageId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}quoted_message_id']),
      replyCount: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}reply_count']),
      showInChannel: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}show_in_channel']),
      shadowed: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}shadowed'])!,
      command: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}command']),
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      deletedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted_at']),
      userId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      pinned: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pinned'])!,
      pinnedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pinned_at']),
      pinExpires: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pin_expires']),
      pinnedByUserId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pinned_by_user_id']),
      channelCid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_cid'])!,
      i18n: $MessagesTable.$converter5.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}i18n'])),
      extraData: $MessagesTable.$converter6.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}extra_data'])),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || messageText != null) {
      map['message_text'] = Variable<String?>(messageText);
    }
    {
      final converter = $MessagesTable.$converter0;
      map['attachments'] = Variable<String>(converter.mapToSql(attachments)!);
    }
    {
      final converter = $MessagesTable.$converter1;
      map['status'] = Variable<int>(converter.mapToSql(status)!);
    }
    map['type'] = Variable<String>(type);
    {
      final converter = $MessagesTable.$converter2;
      map['mentioned_users'] =
          Variable<String>(converter.mapToSql(mentionedUsers)!);
    }
    if (!nullToAbsent || reactionCounts != null) {
      final converter = $MessagesTable.$converter3;
      map['reaction_counts'] =
          Variable<String?>(converter.mapToSql(reactionCounts));
    }
    if (!nullToAbsent || reactionScores != null) {
      final converter = $MessagesTable.$converter4;
      map['reaction_scores'] =
          Variable<String?>(converter.mapToSql(reactionScores));
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String?>(parentId);
    }
    if (!nullToAbsent || quotedMessageId != null) {
      map['quoted_message_id'] = Variable<String?>(quotedMessageId);
    }
    if (!nullToAbsent || replyCount != null) {
      map['reply_count'] = Variable<int?>(replyCount);
    }
    if (!nullToAbsent || showInChannel != null) {
      map['show_in_channel'] = Variable<bool?>(showInChannel);
    }
    map['shadowed'] = Variable<bool>(shadowed);
    if (!nullToAbsent || command != null) {
      map['command'] = Variable<String?>(command);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime?>(deletedAt);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String?>(userId);
    }
    map['pinned'] = Variable<bool>(pinned);
    if (!nullToAbsent || pinnedAt != null) {
      map['pinned_at'] = Variable<DateTime?>(pinnedAt);
    }
    if (!nullToAbsent || pinExpires != null) {
      map['pin_expires'] = Variable<DateTime?>(pinExpires);
    }
    if (!nullToAbsent || pinnedByUserId != null) {
      map['pinned_by_user_id'] = Variable<String?>(pinnedByUserId);
    }
    map['channel_cid'] = Variable<String>(channelCid);
    if (!nullToAbsent || i18n != null) {
      final converter = $MessagesTable.$converter5;
      map['i18n'] = Variable<String?>(converter.mapToSql(i18n));
    }
    if (!nullToAbsent || extraData != null) {
      final converter = $MessagesTable.$converter6;
      map['extra_data'] = Variable<String?>(converter.mapToSql(extraData));
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
      status: serializer.fromJson<MessageSendingStatus>(json['status']),
      type: serializer.fromJson<String>(json['type']),
      mentionedUsers: serializer.fromJson<List<String>>(json['mentionedUsers']),
      reactionCounts:
          serializer.fromJson<Map<String, int>?>(json['reactionCounts']),
      reactionScores:
          serializer.fromJson<Map<String, int>?>(json['reactionScores']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      quotedMessageId: serializer.fromJson<String?>(json['quotedMessageId']),
      replyCount: serializer.fromJson<int?>(json['replyCount']),
      showInChannel: serializer.fromJson<bool?>(json['showInChannel']),
      shadowed: serializer.fromJson<bool>(json['shadowed']),
      command: serializer.fromJson<String?>(json['command']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      userId: serializer.fromJson<String?>(json['userId']),
      pinned: serializer.fromJson<bool>(json['pinned']),
      pinnedAt: serializer.fromJson<DateTime?>(json['pinnedAt']),
      pinExpires: serializer.fromJson<DateTime?>(json['pinExpires']),
      pinnedByUserId: serializer.fromJson<String?>(json['pinnedByUserId']),
      channelCid: serializer.fromJson<String>(json['channelCid']),
      i18n: serializer.fromJson<Map<String, String>?>(json['i18n']),
      extraData: serializer.fromJson<Map<String, Object?>?>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageText': serializer.toJson<String?>(messageText),
      'attachments': serializer.toJson<List<String>>(attachments),
      'status': serializer.toJson<MessageSendingStatus>(status),
      'type': serializer.toJson<String>(type),
      'mentionedUsers': serializer.toJson<List<String>>(mentionedUsers),
      'reactionCounts': serializer.toJson<Map<String, int>?>(reactionCounts),
      'reactionScores': serializer.toJson<Map<String, int>?>(reactionScores),
      'parentId': serializer.toJson<String?>(parentId),
      'quotedMessageId': serializer.toJson<String?>(quotedMessageId),
      'replyCount': serializer.toJson<int?>(replyCount),
      'showInChannel': serializer.toJson<bool?>(showInChannel),
      'shadowed': serializer.toJson<bool>(shadowed),
      'command': serializer.toJson<String?>(command),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'userId': serializer.toJson<String?>(userId),
      'pinned': serializer.toJson<bool>(pinned),
      'pinnedAt': serializer.toJson<DateTime?>(pinnedAt),
      'pinExpires': serializer.toJson<DateTime?>(pinExpires),
      'pinnedByUserId': serializer.toJson<String?>(pinnedByUserId),
      'channelCid': serializer.toJson<String>(channelCid),
      'i18n': serializer.toJson<Map<String, String>?>(i18n),
      'extraData': serializer.toJson<Map<String, Object?>?>(extraData),
    };
  }

  MessageEntity copyWith(
          {String? id,
          Value<String?> messageText = const Value.absent(),
          List<String>? attachments,
          MessageSendingStatus? status,
          String? type,
          List<String>? mentionedUsers,
          Value<Map<String, int>?> reactionCounts = const Value.absent(),
          Value<Map<String, int>?> reactionScores = const Value.absent(),
          Value<String?> parentId = const Value.absent(),
          Value<String?> quotedMessageId = const Value.absent(),
          Value<int?> replyCount = const Value.absent(),
          Value<bool?> showInChannel = const Value.absent(),
          bool? shadowed,
          Value<String?> command = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<String?> userId = const Value.absent(),
          bool? pinned,
          Value<DateTime?> pinnedAt = const Value.absent(),
          Value<DateTime?> pinExpires = const Value.absent(),
          Value<String?> pinnedByUserId = const Value.absent(),
          String? channelCid,
          Value<Map<String, String>?> i18n = const Value.absent(),
          Value<Map<String, Object?>?> extraData = const Value.absent()}) =>
      MessageEntity(
        id: id ?? this.id,
        messageText: messageText.present ? messageText.value : this.messageText,
        attachments: attachments ?? this.attachments,
        status: status ?? this.status,
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
        replyCount: replyCount.present ? replyCount.value : this.replyCount,
        showInChannel:
            showInChannel.present ? showInChannel.value : this.showInChannel,
        shadowed: shadowed ?? this.shadowed,
        command: command.present ? command.value : this.command,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        userId: userId.present ? userId.value : this.userId,
        pinned: pinned ?? this.pinned,
        pinnedAt: pinnedAt.present ? pinnedAt.value : this.pinnedAt,
        pinExpires: pinExpires.present ? pinExpires.value : this.pinExpires,
        pinnedByUserId:
            pinnedByUserId.present ? pinnedByUserId.value : this.pinnedByUserId,
        channelCid: channelCid ?? this.channelCid,
        i18n: i18n.present ? i18n.value : this.i18n,
        extraData: extraData.present ? extraData.value : this.extraData,
      );
  @override
  String toString() {
    return (StringBuffer('MessageEntity(')
          ..write('id: $id, ')
          ..write('messageText: $messageText, ')
          ..write('attachments: $attachments, ')
          ..write('status: $status, ')
          ..write('type: $type, ')
          ..write('mentionedUsers: $mentionedUsers, ')
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
          ..write('pinned: $pinned, ')
          ..write('pinnedAt: $pinnedAt, ')
          ..write('pinExpires: $pinExpires, ')
          ..write('pinnedByUserId: $pinnedByUserId, ')
          ..write('channelCid: $channelCid, ')
          ..write('i18n: $i18n, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        messageText,
        attachments,
        status,
        type,
        mentionedUsers,
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
        pinned,
        pinnedAt,
        pinExpires,
        pinnedByUserId,
        channelCid,
        i18n,
        extraData
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageEntity &&
          other.id == this.id &&
          other.messageText == this.messageText &&
          other.attachments == this.attachments &&
          other.status == this.status &&
          other.type == this.type &&
          other.mentionedUsers == this.mentionedUsers &&
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
          other.pinned == this.pinned &&
          other.pinnedAt == this.pinnedAt &&
          other.pinExpires == this.pinExpires &&
          other.pinnedByUserId == this.pinnedByUserId &&
          other.channelCid == this.channelCid &&
          other.i18n == this.i18n &&
          other.extraData == this.extraData);
}

class MessagesCompanion extends UpdateCompanion<MessageEntity> {
  final Value<String> id;
  final Value<String?> messageText;
  final Value<List<String>> attachments;
  final Value<MessageSendingStatus> status;
  final Value<String> type;
  final Value<List<String>> mentionedUsers;
  final Value<Map<String, int>?> reactionCounts;
  final Value<Map<String, int>?> reactionScores;
  final Value<String?> parentId;
  final Value<String?> quotedMessageId;
  final Value<int?> replyCount;
  final Value<bool?> showInChannel;
  final Value<bool> shadowed;
  final Value<String?> command;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> userId;
  final Value<bool> pinned;
  final Value<DateTime?> pinnedAt;
  final Value<DateTime?> pinExpires;
  final Value<String?> pinnedByUserId;
  final Value<String> channelCid;
  final Value<Map<String, String>?> i18n;
  final Value<Map<String, Object?>?> extraData;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.messageText = const Value.absent(),
    this.attachments = const Value.absent(),
    this.status = const Value.absent(),
    this.type = const Value.absent(),
    this.mentionedUsers = const Value.absent(),
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
    this.pinned = const Value.absent(),
    this.pinnedAt = const Value.absent(),
    this.pinExpires = const Value.absent(),
    this.pinnedByUserId = const Value.absent(),
    this.channelCid = const Value.absent(),
    this.i18n = const Value.absent(),
    this.extraData = const Value.absent(),
  });
  MessagesCompanion.insert({
    required String id,
    this.messageText = const Value.absent(),
    required List<String> attachments,
    this.status = const Value.absent(),
    this.type = const Value.absent(),
    required List<String> mentionedUsers,
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
    this.pinned = const Value.absent(),
    this.pinnedAt = const Value.absent(),
    this.pinExpires = const Value.absent(),
    this.pinnedByUserId = const Value.absent(),
    required String channelCid,
    this.i18n = const Value.absent(),
    this.extraData = const Value.absent(),
  })  : id = Value(id),
        attachments = Value(attachments),
        mentionedUsers = Value(mentionedUsers),
        channelCid = Value(channelCid);
  static Insertable<MessageEntity> custom({
    Expression<String>? id,
    Expression<String?>? messageText,
    Expression<List<String>>? attachments,
    Expression<MessageSendingStatus>? status,
    Expression<String>? type,
    Expression<List<String>>? mentionedUsers,
    Expression<Map<String, int>?>? reactionCounts,
    Expression<Map<String, int>?>? reactionScores,
    Expression<String?>? parentId,
    Expression<String?>? quotedMessageId,
    Expression<int?>? replyCount,
    Expression<bool?>? showInChannel,
    Expression<bool>? shadowed,
    Expression<String?>? command,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime?>? deletedAt,
    Expression<String?>? userId,
    Expression<bool>? pinned,
    Expression<DateTime?>? pinnedAt,
    Expression<DateTime?>? pinExpires,
    Expression<String?>? pinnedByUserId,
    Expression<String>? channelCid,
    Expression<Map<String, String>?>? i18n,
    Expression<Map<String, Object?>?>? extraData,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageText != null) 'message_text': messageText,
      if (attachments != null) 'attachments': attachments,
      if (status != null) 'status': status,
      if (type != null) 'type': type,
      if (mentionedUsers != null) 'mentioned_users': mentionedUsers,
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
      if (pinned != null) 'pinned': pinned,
      if (pinnedAt != null) 'pinned_at': pinnedAt,
      if (pinExpires != null) 'pin_expires': pinExpires,
      if (pinnedByUserId != null) 'pinned_by_user_id': pinnedByUserId,
      if (channelCid != null) 'channel_cid': channelCid,
      if (i18n != null) 'i18n': i18n,
      if (extraData != null) 'extra_data': extraData,
    });
  }

  MessagesCompanion copyWith(
      {Value<String>? id,
      Value<String?>? messageText,
      Value<List<String>>? attachments,
      Value<MessageSendingStatus>? status,
      Value<String>? type,
      Value<List<String>>? mentionedUsers,
      Value<Map<String, int>?>? reactionCounts,
      Value<Map<String, int>?>? reactionScores,
      Value<String?>? parentId,
      Value<String?>? quotedMessageId,
      Value<int?>? replyCount,
      Value<bool?>? showInChannel,
      Value<bool>? shadowed,
      Value<String?>? command,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<String?>? userId,
      Value<bool>? pinned,
      Value<DateTime?>? pinnedAt,
      Value<DateTime?>? pinExpires,
      Value<String?>? pinnedByUserId,
      Value<String>? channelCid,
      Value<Map<String, String>?>? i18n,
      Value<Map<String, Object?>?>? extraData}) {
    return MessagesCompanion(
      id: id ?? this.id,
      messageText: messageText ?? this.messageText,
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      type: type ?? this.type,
      mentionedUsers: mentionedUsers ?? this.mentionedUsers,
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
      pinned: pinned ?? this.pinned,
      pinnedAt: pinnedAt ?? this.pinnedAt,
      pinExpires: pinExpires ?? this.pinExpires,
      pinnedByUserId: pinnedByUserId ?? this.pinnedByUserId,
      channelCid: channelCid ?? this.channelCid,
      i18n: i18n ?? this.i18n,
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
      map['message_text'] = Variable<String?>(messageText.value);
    }
    if (attachments.present) {
      final converter = $MessagesTable.$converter0;
      map['attachments'] =
          Variable<String>(converter.mapToSql(attachments.value)!);
    }
    if (status.present) {
      final converter = $MessagesTable.$converter1;
      map['status'] = Variable<int>(converter.mapToSql(status.value)!);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (mentionedUsers.present) {
      final converter = $MessagesTable.$converter2;
      map['mentioned_users'] =
          Variable<String>(converter.mapToSql(mentionedUsers.value)!);
    }
    if (reactionCounts.present) {
      final converter = $MessagesTable.$converter3;
      map['reaction_counts'] =
          Variable<String?>(converter.mapToSql(reactionCounts.value));
    }
    if (reactionScores.present) {
      final converter = $MessagesTable.$converter4;
      map['reaction_scores'] =
          Variable<String?>(converter.mapToSql(reactionScores.value));
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String?>(parentId.value);
    }
    if (quotedMessageId.present) {
      map['quoted_message_id'] = Variable<String?>(quotedMessageId.value);
    }
    if (replyCount.present) {
      map['reply_count'] = Variable<int?>(replyCount.value);
    }
    if (showInChannel.present) {
      map['show_in_channel'] = Variable<bool?>(showInChannel.value);
    }
    if (shadowed.present) {
      map['shadowed'] = Variable<bool>(shadowed.value);
    }
    if (command.present) {
      map['command'] = Variable<String?>(command.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime?>(deletedAt.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String?>(userId.value);
    }
    if (pinned.present) {
      map['pinned'] = Variable<bool>(pinned.value);
    }
    if (pinnedAt.present) {
      map['pinned_at'] = Variable<DateTime?>(pinnedAt.value);
    }
    if (pinExpires.present) {
      map['pin_expires'] = Variable<DateTime?>(pinExpires.value);
    }
    if (pinnedByUserId.present) {
      map['pinned_by_user_id'] = Variable<String?>(pinnedByUserId.value);
    }
    if (channelCid.present) {
      map['channel_cid'] = Variable<String>(channelCid.value);
    }
    if (i18n.present) {
      final converter = $MessagesTable.$converter5;
      map['i18n'] = Variable<String?>(converter.mapToSql(i18n.value));
    }
    if (extraData.present) {
      final converter = $MessagesTable.$converter6;
      map['extra_data'] =
          Variable<String?>(converter.mapToSql(extraData.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('messageText: $messageText, ')
          ..write('attachments: $attachments, ')
          ..write('status: $status, ')
          ..write('type: $type, ')
          ..write('mentionedUsers: $mentionedUsers, ')
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
          ..write('pinned: $pinned, ')
          ..write('pinnedAt: $pinnedAt, ')
          ..write('pinExpires: $pinExpires, ')
          ..write('pinnedByUserId: $pinnedByUserId, ')
          ..write('channelCid: $channelCid, ')
          ..write('i18n: $i18n, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages
    with TableInfo<$MessagesTable, MessageEntity> {
  final GeneratedDatabase _db;
  final String? _alias;
  $MessagesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _messageTextMeta =
      const VerificationMeta('messageText');
  @override
  late final GeneratedColumn<String?> messageText = GeneratedColumn<String?>(
      'message_text', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _attachmentsMeta =
      const VerificationMeta('attachments');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String?>
      attachments = GeneratedColumn<String?>('attachments', aliasedName, false,
              type: const StringType(), requiredDuringInsert: true)
          .withConverter<List<String>>($MessagesTable.$converter0);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<MessageSendingStatus, int?>
      status = GeneratedColumn<int?>('status', aliasedName, false,
              type: const IntType(),
              requiredDuringInsert: false,
              defaultValue: const Constant(1))
          .withConverter<MessageSendingStatus>($MessagesTable.$converter1);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String?> type = GeneratedColumn<String?>(
      'type', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: const Constant('regular'));
  final VerificationMeta _mentionedUsersMeta =
      const VerificationMeta('mentionedUsers');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String?>
      mentionedUsers = GeneratedColumn<String?>(
              'mentioned_users', aliasedName, false,
              type: const StringType(), requiredDuringInsert: true)
          .withConverter<List<String>>($MessagesTable.$converter2);
  final VerificationMeta _reactionCountsMeta =
      const VerificationMeta('reactionCounts');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, int>, String?>
      reactionCounts = GeneratedColumn<String?>(
              'reaction_counts', aliasedName, true,
              type: const StringType(), requiredDuringInsert: false)
          .withConverter<Map<String, int>>($MessagesTable.$converter3);
  final VerificationMeta _reactionScoresMeta =
      const VerificationMeta('reactionScores');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, int>, String?>
      reactionScores = GeneratedColumn<String?>(
              'reaction_scores', aliasedName, true,
              type: const StringType(), requiredDuringInsert: false)
          .withConverter<Map<String, int>>($MessagesTable.$converter4);
  final VerificationMeta _parentIdMeta = const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String?> parentId = GeneratedColumn<String?>(
      'parent_id', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _quotedMessageIdMeta =
      const VerificationMeta('quotedMessageId');
  @override
  late final GeneratedColumn<String?> quotedMessageId =
      GeneratedColumn<String?>('quoted_message_id', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _replyCountMeta = const VerificationMeta('replyCount');
  @override
  late final GeneratedColumn<int?> replyCount = GeneratedColumn<int?>(
      'reply_count', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _showInChannelMeta =
      const VerificationMeta('showInChannel');
  @override
  late final GeneratedColumn<bool?> showInChannel = GeneratedColumn<bool?>(
      'show_in_channel', aliasedName, true,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (show_in_channel IN (0, 1))');
  final VerificationMeta _shadowedMeta = const VerificationMeta('shadowed');
  @override
  late final GeneratedColumn<bool?> shadowed = GeneratedColumn<bool?>(
      'shadowed', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (shadowed IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _commandMeta = const VerificationMeta('command');
  @override
  late final GeneratedColumn<String?> command = GeneratedColumn<String?>(
      'command', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  final VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime?> deletedAt = GeneratedColumn<DateTime?>(
      'deleted_at', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String?> userId = GeneratedColumn<String?>(
      'user_id', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _pinnedMeta = const VerificationMeta('pinned');
  @override
  late final GeneratedColumn<bool?> pinned = GeneratedColumn<bool?>(
      'pinned', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (pinned IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _pinnedAtMeta = const VerificationMeta('pinnedAt');
  @override
  late final GeneratedColumn<DateTime?> pinnedAt = GeneratedColumn<DateTime?>(
      'pinned_at', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _pinExpiresMeta = const VerificationMeta('pinExpires');
  @override
  late final GeneratedColumn<DateTime?> pinExpires = GeneratedColumn<DateTime?>(
      'pin_expires', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _pinnedByUserIdMeta =
      const VerificationMeta('pinnedByUserId');
  @override
  late final GeneratedColumn<String?> pinnedByUserId = GeneratedColumn<String?>(
      'pinned_by_user_id', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _channelCidMeta = const VerificationMeta('channelCid');
  @override
  late final GeneratedColumn<String?> channelCid = GeneratedColumn<String?>(
      'channel_cid', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES channels(cid) ON DELETE CASCADE');
  final VerificationMeta _i18nMeta = const VerificationMeta('i18n');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String?>
      i18n = GeneratedColumn<String?>('i18n', aliasedName, true,
              type: const StringType(), requiredDuringInsert: false)
          .withConverter<Map<String, String>>($MessagesTable.$converter5);
  final VerificationMeta _extraDataMeta = const VerificationMeta('extraData');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String?>
      extraData = GeneratedColumn<String?>('extra_data', aliasedName, true,
              type: const StringType(), requiredDuringInsert: false)
          .withConverter<Map<String, Object?>>($MessagesTable.$converter6);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        messageText,
        attachments,
        status,
        type,
        mentionedUsers,
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
        pinned,
        pinnedAt,
        pinExpires,
        pinnedByUserId,
        channelCid,
        i18n,
        extraData
      ];
  @override
  String get aliasedName => _alias ?? 'messages';
  @override
  String get actualTableName => 'messages';
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
    context.handle(_statusMeta, const VerificationResult.success());
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
    context.handle(_extraDataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    return MessageEntity.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(_db, alias);
  }

  static TypeConverter<List<String>, String> $converter0 =
      ListConverter<String>();
  static TypeConverter<MessageSendingStatus, int> $converter1 =
      MessageSendingStatusConverter();
  static TypeConverter<List<String>, String> $converter2 =
      ListConverter<String>();
  static TypeConverter<Map<String, int>, String> $converter3 =
      MapConverter<int>();
  static TypeConverter<Map<String, int>, String> $converter4 =
      MapConverter<int>();
  static TypeConverter<Map<String, String>, String> $converter5 =
      MapConverter<String>();
  static TypeConverter<Map<String, Object?>, String> $converter6 =
      MapConverter<Object?>();
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

  /// The status of a sending message
  final MessageSendingStatus status;

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

  /// Number of replies for this message.
  final int? replyCount;

  /// Check if this message needs to show in the channel.
  final bool? showInChannel;

  /// If true the message is shadowed
  final bool shadowed;

  /// A used command name.
  final String? command;

  /// The DateTime when the message was created.
  final DateTime createdAt;

  /// The DateTime when the message was updated last time.
  final DateTime updatedAt;

  /// The DateTime when the message was deleted.
  final DateTime? deletedAt;

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

  /// Message custom extraData
  final Map<String, Object?>? extraData;
  PinnedMessageEntity(
      {required this.id,
      this.messageText,
      required this.attachments,
      required this.status,
      required this.type,
      required this.mentionedUsers,
      this.reactionCounts,
      this.reactionScores,
      this.parentId,
      this.quotedMessageId,
      this.replyCount,
      this.showInChannel,
      required this.shadowed,
      this.command,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      this.userId,
      required this.pinned,
      this.pinnedAt,
      this.pinExpires,
      this.pinnedByUserId,
      required this.channelCid,
      this.i18n,
      this.extraData});
  factory PinnedMessageEntity.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return PinnedMessageEntity(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      messageText: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}message_text']),
      attachments: $PinnedMessagesTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}attachments']))!,
      status: $PinnedMessagesTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status']))!,
      type: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      mentionedUsers: $PinnedMessagesTable.$converter2.mapToDart(
          const StringType().mapFromDatabaseResponse(
              data['${effectivePrefix}mentioned_users']))!,
      reactionCounts: $PinnedMessagesTable.$converter3.mapToDart(
          const StringType().mapFromDatabaseResponse(
              data['${effectivePrefix}reaction_counts'])),
      reactionScores: $PinnedMessagesTable.$converter4.mapToDart(
          const StringType().mapFromDatabaseResponse(
              data['${effectivePrefix}reaction_scores'])),
      parentId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}parent_id']),
      quotedMessageId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}quoted_message_id']),
      replyCount: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}reply_count']),
      showInChannel: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}show_in_channel']),
      shadowed: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}shadowed'])!,
      command: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}command']),
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      deletedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted_at']),
      userId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      pinned: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pinned'])!,
      pinnedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pinned_at']),
      pinExpires: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pin_expires']),
      pinnedByUserId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pinned_by_user_id']),
      channelCid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_cid'])!,
      i18n: $PinnedMessagesTable.$converter5.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}i18n'])),
      extraData: $PinnedMessagesTable.$converter6.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}extra_data'])),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || messageText != null) {
      map['message_text'] = Variable<String?>(messageText);
    }
    {
      final converter = $PinnedMessagesTable.$converter0;
      map['attachments'] = Variable<String>(converter.mapToSql(attachments)!);
    }
    {
      final converter = $PinnedMessagesTable.$converter1;
      map['status'] = Variable<int>(converter.mapToSql(status)!);
    }
    map['type'] = Variable<String>(type);
    {
      final converter = $PinnedMessagesTable.$converter2;
      map['mentioned_users'] =
          Variable<String>(converter.mapToSql(mentionedUsers)!);
    }
    if (!nullToAbsent || reactionCounts != null) {
      final converter = $PinnedMessagesTable.$converter3;
      map['reaction_counts'] =
          Variable<String?>(converter.mapToSql(reactionCounts));
    }
    if (!nullToAbsent || reactionScores != null) {
      final converter = $PinnedMessagesTable.$converter4;
      map['reaction_scores'] =
          Variable<String?>(converter.mapToSql(reactionScores));
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String?>(parentId);
    }
    if (!nullToAbsent || quotedMessageId != null) {
      map['quoted_message_id'] = Variable<String?>(quotedMessageId);
    }
    if (!nullToAbsent || replyCount != null) {
      map['reply_count'] = Variable<int?>(replyCount);
    }
    if (!nullToAbsent || showInChannel != null) {
      map['show_in_channel'] = Variable<bool?>(showInChannel);
    }
    map['shadowed'] = Variable<bool>(shadowed);
    if (!nullToAbsent || command != null) {
      map['command'] = Variable<String?>(command);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime?>(deletedAt);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String?>(userId);
    }
    map['pinned'] = Variable<bool>(pinned);
    if (!nullToAbsent || pinnedAt != null) {
      map['pinned_at'] = Variable<DateTime?>(pinnedAt);
    }
    if (!nullToAbsent || pinExpires != null) {
      map['pin_expires'] = Variable<DateTime?>(pinExpires);
    }
    if (!nullToAbsent || pinnedByUserId != null) {
      map['pinned_by_user_id'] = Variable<String?>(pinnedByUserId);
    }
    map['channel_cid'] = Variable<String>(channelCid);
    if (!nullToAbsent || i18n != null) {
      final converter = $PinnedMessagesTable.$converter5;
      map['i18n'] = Variable<String?>(converter.mapToSql(i18n));
    }
    if (!nullToAbsent || extraData != null) {
      final converter = $PinnedMessagesTable.$converter6;
      map['extra_data'] = Variable<String?>(converter.mapToSql(extraData));
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
      status: serializer.fromJson<MessageSendingStatus>(json['status']),
      type: serializer.fromJson<String>(json['type']),
      mentionedUsers: serializer.fromJson<List<String>>(json['mentionedUsers']),
      reactionCounts:
          serializer.fromJson<Map<String, int>?>(json['reactionCounts']),
      reactionScores:
          serializer.fromJson<Map<String, int>?>(json['reactionScores']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      quotedMessageId: serializer.fromJson<String?>(json['quotedMessageId']),
      replyCount: serializer.fromJson<int?>(json['replyCount']),
      showInChannel: serializer.fromJson<bool?>(json['showInChannel']),
      shadowed: serializer.fromJson<bool>(json['shadowed']),
      command: serializer.fromJson<String?>(json['command']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      userId: serializer.fromJson<String?>(json['userId']),
      pinned: serializer.fromJson<bool>(json['pinned']),
      pinnedAt: serializer.fromJson<DateTime?>(json['pinnedAt']),
      pinExpires: serializer.fromJson<DateTime?>(json['pinExpires']),
      pinnedByUserId: serializer.fromJson<String?>(json['pinnedByUserId']),
      channelCid: serializer.fromJson<String>(json['channelCid']),
      i18n: serializer.fromJson<Map<String, String>?>(json['i18n']),
      extraData: serializer.fromJson<Map<String, Object?>?>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageText': serializer.toJson<String?>(messageText),
      'attachments': serializer.toJson<List<String>>(attachments),
      'status': serializer.toJson<MessageSendingStatus>(status),
      'type': serializer.toJson<String>(type),
      'mentionedUsers': serializer.toJson<List<String>>(mentionedUsers),
      'reactionCounts': serializer.toJson<Map<String, int>?>(reactionCounts),
      'reactionScores': serializer.toJson<Map<String, int>?>(reactionScores),
      'parentId': serializer.toJson<String?>(parentId),
      'quotedMessageId': serializer.toJson<String?>(quotedMessageId),
      'replyCount': serializer.toJson<int?>(replyCount),
      'showInChannel': serializer.toJson<bool?>(showInChannel),
      'shadowed': serializer.toJson<bool>(shadowed),
      'command': serializer.toJson<String?>(command),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'userId': serializer.toJson<String?>(userId),
      'pinned': serializer.toJson<bool>(pinned),
      'pinnedAt': serializer.toJson<DateTime?>(pinnedAt),
      'pinExpires': serializer.toJson<DateTime?>(pinExpires),
      'pinnedByUserId': serializer.toJson<String?>(pinnedByUserId),
      'channelCid': serializer.toJson<String>(channelCid),
      'i18n': serializer.toJson<Map<String, String>?>(i18n),
      'extraData': serializer.toJson<Map<String, Object?>?>(extraData),
    };
  }

  PinnedMessageEntity copyWith(
          {String? id,
          Value<String?> messageText = const Value.absent(),
          List<String>? attachments,
          MessageSendingStatus? status,
          String? type,
          List<String>? mentionedUsers,
          Value<Map<String, int>?> reactionCounts = const Value.absent(),
          Value<Map<String, int>?> reactionScores = const Value.absent(),
          Value<String?> parentId = const Value.absent(),
          Value<String?> quotedMessageId = const Value.absent(),
          Value<int?> replyCount = const Value.absent(),
          Value<bool?> showInChannel = const Value.absent(),
          bool? shadowed,
          Value<String?> command = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent(),
          Value<String?> userId = const Value.absent(),
          bool? pinned,
          Value<DateTime?> pinnedAt = const Value.absent(),
          Value<DateTime?> pinExpires = const Value.absent(),
          Value<String?> pinnedByUserId = const Value.absent(),
          String? channelCid,
          Value<Map<String, String>?> i18n = const Value.absent(),
          Value<Map<String, Object?>?> extraData = const Value.absent()}) =>
      PinnedMessageEntity(
        id: id ?? this.id,
        messageText: messageText.present ? messageText.value : this.messageText,
        attachments: attachments ?? this.attachments,
        status: status ?? this.status,
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
        replyCount: replyCount.present ? replyCount.value : this.replyCount,
        showInChannel:
            showInChannel.present ? showInChannel.value : this.showInChannel,
        shadowed: shadowed ?? this.shadowed,
        command: command.present ? command.value : this.command,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        userId: userId.present ? userId.value : this.userId,
        pinned: pinned ?? this.pinned,
        pinnedAt: pinnedAt.present ? pinnedAt.value : this.pinnedAt,
        pinExpires: pinExpires.present ? pinExpires.value : this.pinExpires,
        pinnedByUserId:
            pinnedByUserId.present ? pinnedByUserId.value : this.pinnedByUserId,
        channelCid: channelCid ?? this.channelCid,
        i18n: i18n.present ? i18n.value : this.i18n,
        extraData: extraData.present ? extraData.value : this.extraData,
      );
  @override
  String toString() {
    return (StringBuffer('PinnedMessageEntity(')
          ..write('id: $id, ')
          ..write('messageText: $messageText, ')
          ..write('attachments: $attachments, ')
          ..write('status: $status, ')
          ..write('type: $type, ')
          ..write('mentionedUsers: $mentionedUsers, ')
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
          ..write('pinned: $pinned, ')
          ..write('pinnedAt: $pinnedAt, ')
          ..write('pinExpires: $pinExpires, ')
          ..write('pinnedByUserId: $pinnedByUserId, ')
          ..write('channelCid: $channelCid, ')
          ..write('i18n: $i18n, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        messageText,
        attachments,
        status,
        type,
        mentionedUsers,
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
        pinned,
        pinnedAt,
        pinExpires,
        pinnedByUserId,
        channelCid,
        i18n,
        extraData
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PinnedMessageEntity &&
          other.id == this.id &&
          other.messageText == this.messageText &&
          other.attachments == this.attachments &&
          other.status == this.status &&
          other.type == this.type &&
          other.mentionedUsers == this.mentionedUsers &&
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
          other.pinned == this.pinned &&
          other.pinnedAt == this.pinnedAt &&
          other.pinExpires == this.pinExpires &&
          other.pinnedByUserId == this.pinnedByUserId &&
          other.channelCid == this.channelCid &&
          other.i18n == this.i18n &&
          other.extraData == this.extraData);
}

class PinnedMessagesCompanion extends UpdateCompanion<PinnedMessageEntity> {
  final Value<String> id;
  final Value<String?> messageText;
  final Value<List<String>> attachments;
  final Value<MessageSendingStatus> status;
  final Value<String> type;
  final Value<List<String>> mentionedUsers;
  final Value<Map<String, int>?> reactionCounts;
  final Value<Map<String, int>?> reactionScores;
  final Value<String?> parentId;
  final Value<String?> quotedMessageId;
  final Value<int?> replyCount;
  final Value<bool?> showInChannel;
  final Value<bool> shadowed;
  final Value<String?> command;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> userId;
  final Value<bool> pinned;
  final Value<DateTime?> pinnedAt;
  final Value<DateTime?> pinExpires;
  final Value<String?> pinnedByUserId;
  final Value<String> channelCid;
  final Value<Map<String, String>?> i18n;
  final Value<Map<String, Object?>?> extraData;
  const PinnedMessagesCompanion({
    this.id = const Value.absent(),
    this.messageText = const Value.absent(),
    this.attachments = const Value.absent(),
    this.status = const Value.absent(),
    this.type = const Value.absent(),
    this.mentionedUsers = const Value.absent(),
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
    this.pinned = const Value.absent(),
    this.pinnedAt = const Value.absent(),
    this.pinExpires = const Value.absent(),
    this.pinnedByUserId = const Value.absent(),
    this.channelCid = const Value.absent(),
    this.i18n = const Value.absent(),
    this.extraData = const Value.absent(),
  });
  PinnedMessagesCompanion.insert({
    required String id,
    this.messageText = const Value.absent(),
    required List<String> attachments,
    this.status = const Value.absent(),
    this.type = const Value.absent(),
    required List<String> mentionedUsers,
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
    this.pinned = const Value.absent(),
    this.pinnedAt = const Value.absent(),
    this.pinExpires = const Value.absent(),
    this.pinnedByUserId = const Value.absent(),
    required String channelCid,
    this.i18n = const Value.absent(),
    this.extraData = const Value.absent(),
  })  : id = Value(id),
        attachments = Value(attachments),
        mentionedUsers = Value(mentionedUsers),
        channelCid = Value(channelCid);
  static Insertable<PinnedMessageEntity> custom({
    Expression<String>? id,
    Expression<String?>? messageText,
    Expression<List<String>>? attachments,
    Expression<MessageSendingStatus>? status,
    Expression<String>? type,
    Expression<List<String>>? mentionedUsers,
    Expression<Map<String, int>?>? reactionCounts,
    Expression<Map<String, int>?>? reactionScores,
    Expression<String?>? parentId,
    Expression<String?>? quotedMessageId,
    Expression<int?>? replyCount,
    Expression<bool?>? showInChannel,
    Expression<bool>? shadowed,
    Expression<String?>? command,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime?>? deletedAt,
    Expression<String?>? userId,
    Expression<bool>? pinned,
    Expression<DateTime?>? pinnedAt,
    Expression<DateTime?>? pinExpires,
    Expression<String?>? pinnedByUserId,
    Expression<String>? channelCid,
    Expression<Map<String, String>?>? i18n,
    Expression<Map<String, Object?>?>? extraData,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageText != null) 'message_text': messageText,
      if (attachments != null) 'attachments': attachments,
      if (status != null) 'status': status,
      if (type != null) 'type': type,
      if (mentionedUsers != null) 'mentioned_users': mentionedUsers,
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
      if (pinned != null) 'pinned': pinned,
      if (pinnedAt != null) 'pinned_at': pinnedAt,
      if (pinExpires != null) 'pin_expires': pinExpires,
      if (pinnedByUserId != null) 'pinned_by_user_id': pinnedByUserId,
      if (channelCid != null) 'channel_cid': channelCid,
      if (i18n != null) 'i18n': i18n,
      if (extraData != null) 'extra_data': extraData,
    });
  }

  PinnedMessagesCompanion copyWith(
      {Value<String>? id,
      Value<String?>? messageText,
      Value<List<String>>? attachments,
      Value<MessageSendingStatus>? status,
      Value<String>? type,
      Value<List<String>>? mentionedUsers,
      Value<Map<String, int>?>? reactionCounts,
      Value<Map<String, int>?>? reactionScores,
      Value<String?>? parentId,
      Value<String?>? quotedMessageId,
      Value<int?>? replyCount,
      Value<bool?>? showInChannel,
      Value<bool>? shadowed,
      Value<String?>? command,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<String?>? userId,
      Value<bool>? pinned,
      Value<DateTime?>? pinnedAt,
      Value<DateTime?>? pinExpires,
      Value<String?>? pinnedByUserId,
      Value<String>? channelCid,
      Value<Map<String, String>?>? i18n,
      Value<Map<String, Object?>?>? extraData}) {
    return PinnedMessagesCompanion(
      id: id ?? this.id,
      messageText: messageText ?? this.messageText,
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      type: type ?? this.type,
      mentionedUsers: mentionedUsers ?? this.mentionedUsers,
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
      pinned: pinned ?? this.pinned,
      pinnedAt: pinnedAt ?? this.pinnedAt,
      pinExpires: pinExpires ?? this.pinExpires,
      pinnedByUserId: pinnedByUserId ?? this.pinnedByUserId,
      channelCid: channelCid ?? this.channelCid,
      i18n: i18n ?? this.i18n,
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
      map['message_text'] = Variable<String?>(messageText.value);
    }
    if (attachments.present) {
      final converter = $PinnedMessagesTable.$converter0;
      map['attachments'] =
          Variable<String>(converter.mapToSql(attachments.value)!);
    }
    if (status.present) {
      final converter = $PinnedMessagesTable.$converter1;
      map['status'] = Variable<int>(converter.mapToSql(status.value)!);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (mentionedUsers.present) {
      final converter = $PinnedMessagesTable.$converter2;
      map['mentioned_users'] =
          Variable<String>(converter.mapToSql(mentionedUsers.value)!);
    }
    if (reactionCounts.present) {
      final converter = $PinnedMessagesTable.$converter3;
      map['reaction_counts'] =
          Variable<String?>(converter.mapToSql(reactionCounts.value));
    }
    if (reactionScores.present) {
      final converter = $PinnedMessagesTable.$converter4;
      map['reaction_scores'] =
          Variable<String?>(converter.mapToSql(reactionScores.value));
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String?>(parentId.value);
    }
    if (quotedMessageId.present) {
      map['quoted_message_id'] = Variable<String?>(quotedMessageId.value);
    }
    if (replyCount.present) {
      map['reply_count'] = Variable<int?>(replyCount.value);
    }
    if (showInChannel.present) {
      map['show_in_channel'] = Variable<bool?>(showInChannel.value);
    }
    if (shadowed.present) {
      map['shadowed'] = Variable<bool>(shadowed.value);
    }
    if (command.present) {
      map['command'] = Variable<String?>(command.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime?>(deletedAt.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String?>(userId.value);
    }
    if (pinned.present) {
      map['pinned'] = Variable<bool>(pinned.value);
    }
    if (pinnedAt.present) {
      map['pinned_at'] = Variable<DateTime?>(pinnedAt.value);
    }
    if (pinExpires.present) {
      map['pin_expires'] = Variable<DateTime?>(pinExpires.value);
    }
    if (pinnedByUserId.present) {
      map['pinned_by_user_id'] = Variable<String?>(pinnedByUserId.value);
    }
    if (channelCid.present) {
      map['channel_cid'] = Variable<String>(channelCid.value);
    }
    if (i18n.present) {
      final converter = $PinnedMessagesTable.$converter5;
      map['i18n'] = Variable<String?>(converter.mapToSql(i18n.value));
    }
    if (extraData.present) {
      final converter = $PinnedMessagesTable.$converter6;
      map['extra_data'] =
          Variable<String?>(converter.mapToSql(extraData.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PinnedMessagesCompanion(')
          ..write('id: $id, ')
          ..write('messageText: $messageText, ')
          ..write('attachments: $attachments, ')
          ..write('status: $status, ')
          ..write('type: $type, ')
          ..write('mentionedUsers: $mentionedUsers, ')
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
          ..write('pinned: $pinned, ')
          ..write('pinnedAt: $pinnedAt, ')
          ..write('pinExpires: $pinExpires, ')
          ..write('pinnedByUserId: $pinnedByUserId, ')
          ..write('channelCid: $channelCid, ')
          ..write('i18n: $i18n, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }
}

class $PinnedMessagesTable extends PinnedMessages
    with TableInfo<$PinnedMessagesTable, PinnedMessageEntity> {
  final GeneratedDatabase _db;
  final String? _alias;
  $PinnedMessagesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _messageTextMeta =
      const VerificationMeta('messageText');
  @override
  late final GeneratedColumn<String?> messageText = GeneratedColumn<String?>(
      'message_text', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _attachmentsMeta =
      const VerificationMeta('attachments');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String?>
      attachments = GeneratedColumn<String?>('attachments', aliasedName, false,
              type: const StringType(), requiredDuringInsert: true)
          .withConverter<List<String>>($PinnedMessagesTable.$converter0);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<MessageSendingStatus, int?>
      status = GeneratedColumn<int?>('status', aliasedName, false,
              type: const IntType(),
              requiredDuringInsert: false,
              defaultValue: const Constant(1))
          .withConverter<MessageSendingStatus>(
              $PinnedMessagesTable.$converter1);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String?> type = GeneratedColumn<String?>(
      'type', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: const Constant('regular'));
  final VerificationMeta _mentionedUsersMeta =
      const VerificationMeta('mentionedUsers');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String?>
      mentionedUsers = GeneratedColumn<String?>(
              'mentioned_users', aliasedName, false,
              type: const StringType(), requiredDuringInsert: true)
          .withConverter<List<String>>($PinnedMessagesTable.$converter2);
  final VerificationMeta _reactionCountsMeta =
      const VerificationMeta('reactionCounts');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, int>, String?>
      reactionCounts = GeneratedColumn<String?>(
              'reaction_counts', aliasedName, true,
              type: const StringType(), requiredDuringInsert: false)
          .withConverter<Map<String, int>>($PinnedMessagesTable.$converter3);
  final VerificationMeta _reactionScoresMeta =
      const VerificationMeta('reactionScores');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, int>, String?>
      reactionScores = GeneratedColumn<String?>(
              'reaction_scores', aliasedName, true,
              type: const StringType(), requiredDuringInsert: false)
          .withConverter<Map<String, int>>($PinnedMessagesTable.$converter4);
  final VerificationMeta _parentIdMeta = const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String?> parentId = GeneratedColumn<String?>(
      'parent_id', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _quotedMessageIdMeta =
      const VerificationMeta('quotedMessageId');
  @override
  late final GeneratedColumn<String?> quotedMessageId =
      GeneratedColumn<String?>('quoted_message_id', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _replyCountMeta = const VerificationMeta('replyCount');
  @override
  late final GeneratedColumn<int?> replyCount = GeneratedColumn<int?>(
      'reply_count', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _showInChannelMeta =
      const VerificationMeta('showInChannel');
  @override
  late final GeneratedColumn<bool?> showInChannel = GeneratedColumn<bool?>(
      'show_in_channel', aliasedName, true,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (show_in_channel IN (0, 1))');
  final VerificationMeta _shadowedMeta = const VerificationMeta('shadowed');
  @override
  late final GeneratedColumn<bool?> shadowed = GeneratedColumn<bool?>(
      'shadowed', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (shadowed IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _commandMeta = const VerificationMeta('command');
  @override
  late final GeneratedColumn<String?> command = GeneratedColumn<String?>(
      'command', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  final VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime?> deletedAt = GeneratedColumn<DateTime?>(
      'deleted_at', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String?> userId = GeneratedColumn<String?>(
      'user_id', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _pinnedMeta = const VerificationMeta('pinned');
  @override
  late final GeneratedColumn<bool?> pinned = GeneratedColumn<bool?>(
      'pinned', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (pinned IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _pinnedAtMeta = const VerificationMeta('pinnedAt');
  @override
  late final GeneratedColumn<DateTime?> pinnedAt = GeneratedColumn<DateTime?>(
      'pinned_at', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _pinExpiresMeta = const VerificationMeta('pinExpires');
  @override
  late final GeneratedColumn<DateTime?> pinExpires = GeneratedColumn<DateTime?>(
      'pin_expires', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _pinnedByUserIdMeta =
      const VerificationMeta('pinnedByUserId');
  @override
  late final GeneratedColumn<String?> pinnedByUserId = GeneratedColumn<String?>(
      'pinned_by_user_id', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _channelCidMeta = const VerificationMeta('channelCid');
  @override
  late final GeneratedColumn<String?> channelCid = GeneratedColumn<String?>(
      'channel_cid', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES channels(cid) ON DELETE CASCADE');
  final VerificationMeta _i18nMeta = const VerificationMeta('i18n');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String?>
      i18n = GeneratedColumn<String?>('i18n', aliasedName, true,
              type: const StringType(), requiredDuringInsert: false)
          .withConverter<Map<String, String>>($PinnedMessagesTable.$converter5);
  final VerificationMeta _extraDataMeta = const VerificationMeta('extraData');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String?>
      extraData = GeneratedColumn<String?>('extra_data', aliasedName, true,
              type: const StringType(), requiredDuringInsert: false)
          .withConverter<Map<String, Object?>>(
              $PinnedMessagesTable.$converter6);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        messageText,
        attachments,
        status,
        type,
        mentionedUsers,
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
        pinned,
        pinnedAt,
        pinExpires,
        pinnedByUserId,
        channelCid,
        i18n,
        extraData
      ];
  @override
  String get aliasedName => _alias ?? 'pinned_messages';
  @override
  String get actualTableName => 'pinned_messages';
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
    context.handle(_statusMeta, const VerificationResult.success());
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
    context.handle(_extraDataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PinnedMessageEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    return PinnedMessageEntity.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PinnedMessagesTable createAlias(String alias) {
    return $PinnedMessagesTable(_db, alias);
  }

  static TypeConverter<List<String>, String> $converter0 =
      ListConverter<String>();
  static TypeConverter<MessageSendingStatus, int> $converter1 =
      MessageSendingStatusConverter();
  static TypeConverter<List<String>, String> $converter2 =
      ListConverter<String>();
  static TypeConverter<Map<String, int>, String> $converter3 =
      MapConverter<int>();
  static TypeConverter<Map<String, int>, String> $converter4 =
      MapConverter<int>();
  static TypeConverter<Map<String, String>, String> $converter5 =
      MapConverter<String>();
  static TypeConverter<Map<String, Object?>, String> $converter6 =
      MapConverter<Object?>();
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
  final Map<String, Object?>? extraData;
  PinnedMessageReactionEntity(
      {required this.userId,
      required this.messageId,
      required this.type,
      required this.createdAt,
      required this.score,
      this.extraData});
  factory PinnedMessageReactionEntity.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return PinnedMessageReactionEntity(
      userId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id'])!,
      messageId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}message_id'])!,
      type: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      score: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}score'])!,
      extraData: $PinnedMessageReactionsTable.$converter0.mapToDart(
          const StringType()
              .mapFromDatabaseResponse(data['${effectivePrefix}extra_data'])),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['message_id'] = Variable<String>(messageId);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['score'] = Variable<int>(score);
    if (!nullToAbsent || extraData != null) {
      final converter = $PinnedMessageReactionsTable.$converter0;
      map['extra_data'] = Variable<String?>(converter.mapToSql(extraData));
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
      extraData: serializer.fromJson<Map<String, Object?>?>(json['extraData']),
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
      'extraData': serializer.toJson<Map<String, Object?>?>(extraData),
    };
  }

  PinnedMessageReactionEntity copyWith(
          {String? userId,
          String? messageId,
          String? type,
          DateTime? createdAt,
          int? score,
          Value<Map<String, Object?>?> extraData = const Value.absent()}) =>
      PinnedMessageReactionEntity(
        userId: userId ?? this.userId,
        messageId: messageId ?? this.messageId,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        score: score ?? this.score,
        extraData: extraData.present ? extraData.value : this.extraData,
      );
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
  final Value<Map<String, Object?>?> extraData;
  const PinnedMessageReactionsCompanion({
    this.userId = const Value.absent(),
    this.messageId = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.score = const Value.absent(),
    this.extraData = const Value.absent(),
  });
  PinnedMessageReactionsCompanion.insert({
    required String userId,
    required String messageId,
    required String type,
    this.createdAt = const Value.absent(),
    this.score = const Value.absent(),
    this.extraData = const Value.absent(),
  })  : userId = Value(userId),
        messageId = Value(messageId),
        type = Value(type);
  static Insertable<PinnedMessageReactionEntity> custom({
    Expression<String>? userId,
    Expression<String>? messageId,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
    Expression<int>? score,
    Expression<Map<String, Object?>?>? extraData,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (messageId != null) 'message_id': messageId,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (score != null) 'score': score,
      if (extraData != null) 'extra_data': extraData,
    });
  }

  PinnedMessageReactionsCompanion copyWith(
      {Value<String>? userId,
      Value<String>? messageId,
      Value<String>? type,
      Value<DateTime>? createdAt,
      Value<int>? score,
      Value<Map<String, Object?>?>? extraData}) {
    return PinnedMessageReactionsCompanion(
      userId: userId ?? this.userId,
      messageId: messageId ?? this.messageId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      score: score ?? this.score,
      extraData: extraData ?? this.extraData,
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
      final converter = $PinnedMessageReactionsTable.$converter0;
      map['extra_data'] =
          Variable<String?>(converter.mapToSql(extraData.value));
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
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }
}

class $PinnedMessageReactionsTable extends PinnedMessageReactions
    with TableInfo<$PinnedMessageReactionsTable, PinnedMessageReactionEntity> {
  final GeneratedDatabase _db;
  final String? _alias;
  $PinnedMessageReactionsTable(this._db, [this._alias]);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String?> userId = GeneratedColumn<String?>(
      'user_id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _messageIdMeta = const VerificationMeta('messageId');
  @override
  late final GeneratedColumn<String?> messageId = GeneratedColumn<String?>(
      'message_id', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES pinned_messages(id) ON DELETE CASCADE');
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String?> type = GeneratedColumn<String?>(
      'type', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  final VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int?> score = GeneratedColumn<int?>(
      'score', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _extraDataMeta = const VerificationMeta('extraData');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String?>
      extraData = GeneratedColumn<String?>('extra_data', aliasedName, true,
              type: const StringType(), requiredDuringInsert: false)
          .withConverter<Map<String, Object?>>(
              $PinnedMessageReactionsTable.$converter0);
  @override
  List<GeneratedColumn> get $columns =>
      [userId, messageId, type, createdAt, score, extraData];
  @override
  String get aliasedName => _alias ?? 'pinned_message_reactions';
  @override
  String get actualTableName => 'pinned_message_reactions';
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
    return PinnedMessageReactionEntity.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PinnedMessageReactionsTable createAlias(String alias) {
    return $PinnedMessageReactionsTable(_db, alias);
  }

  static TypeConverter<Map<String, Object?>, String> $converter0 =
      MapConverter<Object?>();
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
  final Map<String, Object?>? extraData;
  ReactionEntity(
      {required this.userId,
      required this.messageId,
      required this.type,
      required this.createdAt,
      required this.score,
      this.extraData});
  factory ReactionEntity.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ReactionEntity(
      userId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id'])!,
      messageId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}message_id'])!,
      type: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      score: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}score'])!,
      extraData: $ReactionsTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}extra_data'])),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['message_id'] = Variable<String>(messageId);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['score'] = Variable<int>(score);
    if (!nullToAbsent || extraData != null) {
      final converter = $ReactionsTable.$converter0;
      map['extra_data'] = Variable<String?>(converter.mapToSql(extraData));
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
      extraData: serializer.fromJson<Map<String, Object?>?>(json['extraData']),
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
      'extraData': serializer.toJson<Map<String, Object?>?>(extraData),
    };
  }

  ReactionEntity copyWith(
          {String? userId,
          String? messageId,
          String? type,
          DateTime? createdAt,
          int? score,
          Value<Map<String, Object?>?> extraData = const Value.absent()}) =>
      ReactionEntity(
        userId: userId ?? this.userId,
        messageId: messageId ?? this.messageId,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        score: score ?? this.score,
        extraData: extraData.present ? extraData.value : this.extraData,
      );
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
  final Value<Map<String, Object?>?> extraData;
  const ReactionsCompanion({
    this.userId = const Value.absent(),
    this.messageId = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.score = const Value.absent(),
    this.extraData = const Value.absent(),
  });
  ReactionsCompanion.insert({
    required String userId,
    required String messageId,
    required String type,
    this.createdAt = const Value.absent(),
    this.score = const Value.absent(),
    this.extraData = const Value.absent(),
  })  : userId = Value(userId),
        messageId = Value(messageId),
        type = Value(type);
  static Insertable<ReactionEntity> custom({
    Expression<String>? userId,
    Expression<String>? messageId,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
    Expression<int>? score,
    Expression<Map<String, Object?>?>? extraData,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (messageId != null) 'message_id': messageId,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (score != null) 'score': score,
      if (extraData != null) 'extra_data': extraData,
    });
  }

  ReactionsCompanion copyWith(
      {Value<String>? userId,
      Value<String>? messageId,
      Value<String>? type,
      Value<DateTime>? createdAt,
      Value<int>? score,
      Value<Map<String, Object?>?>? extraData}) {
    return ReactionsCompanion(
      userId: userId ?? this.userId,
      messageId: messageId ?? this.messageId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      score: score ?? this.score,
      extraData: extraData ?? this.extraData,
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
      final converter = $ReactionsTable.$converter0;
      map['extra_data'] =
          Variable<String?>(converter.mapToSql(extraData.value));
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
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }
}

class $ReactionsTable extends Reactions
    with TableInfo<$ReactionsTable, ReactionEntity> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ReactionsTable(this._db, [this._alias]);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String?> userId = GeneratedColumn<String?>(
      'user_id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _messageIdMeta = const VerificationMeta('messageId');
  @override
  late final GeneratedColumn<String?> messageId = GeneratedColumn<String?>(
      'message_id', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES messages(id) ON DELETE CASCADE');
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String?> type = GeneratedColumn<String?>(
      'type', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  final VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int?> score = GeneratedColumn<int?>(
      'score', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _extraDataMeta = const VerificationMeta('extraData');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String?>
      extraData = GeneratedColumn<String?>('extra_data', aliasedName, true,
              type: const StringType(), requiredDuringInsert: false)
          .withConverter<Map<String, Object?>>($ReactionsTable.$converter0);
  @override
  List<GeneratedColumn> get $columns =>
      [userId, messageId, type, createdAt, score, extraData];
  @override
  String get aliasedName => _alias ?? 'reactions';
  @override
  String get actualTableName => 'reactions';
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
    return ReactionEntity.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ReactionsTable createAlias(String alias) {
    return $ReactionsTable(_db, alias);
  }

  static TypeConverter<Map<String, Object?>, String> $converter0 =
      MapConverter<Object?>();
}

class UserEntity extends DataClass implements Insertable<UserEntity> {
  /// User id
  final String id;

  /// User role
  final String? role;

  /// The language this user prefers.
  final String? language;

  /// Date of user creation
  final DateTime createdAt;

  /// Date of last user update
  final DateTime updatedAt;

  /// Date of last user connection
  final DateTime? lastActive;

  /// True if user is online
  final bool online;

  /// True if user is banned from the chat
  final bool banned;

  /// Map of custom user extraData
  final Map<String, Object?> extraData;
  UserEntity(
      {required this.id,
      this.role,
      this.language,
      required this.createdAt,
      required this.updatedAt,
      this.lastActive,
      required this.online,
      required this.banned,
      required this.extraData});
  factory UserEntity.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return UserEntity(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      role: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}role']),
      language: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}language']),
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      lastActive: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_active']),
      online: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}online'])!,
      banned: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}banned'])!,
      extraData: $UsersTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}extra_data']))!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || role != null) {
      map['role'] = Variable<String?>(role);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String?>(language);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastActive != null) {
      map['last_active'] = Variable<DateTime?>(lastActive);
    }
    map['online'] = Variable<bool>(online);
    map['banned'] = Variable<bool>(banned);
    {
      final converter = $UsersTable.$converter0;
      map['extra_data'] = Variable<String>(converter.mapToSql(extraData)!);
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
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastActive: serializer.fromJson<DateTime?>(json['lastActive']),
      online: serializer.fromJson<bool>(json['online']),
      banned: serializer.fromJson<bool>(json['banned']),
      extraData: serializer.fromJson<Map<String, Object?>>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'role': serializer.toJson<String?>(role),
      'language': serializer.toJson<String?>(language),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastActive': serializer.toJson<DateTime?>(lastActive),
      'online': serializer.toJson<bool>(online),
      'banned': serializer.toJson<bool>(banned),
      'extraData': serializer.toJson<Map<String, Object?>>(extraData),
    };
  }

  UserEntity copyWith(
          {String? id,
          Value<String?> role = const Value.absent(),
          Value<String?> language = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> lastActive = const Value.absent(),
          bool? online,
          bool? banned,
          Map<String, Object?>? extraData}) =>
      UserEntity(
        id: id ?? this.id,
        role: role.present ? role.value : this.role,
        language: language.present ? language.value : this.language,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastActive: lastActive.present ? lastActive.value : this.lastActive,
        online: online ?? this.online,
        banned: banned ?? this.banned,
        extraData: extraData ?? this.extraData,
      );
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
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastActive;
  final Value<bool> online;
  final Value<bool> banned;
  final Value<Map<String, Object?>> extraData;
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
    required Map<String, Object?> extraData,
  })  : id = Value(id),
        extraData = Value(extraData);
  static Insertable<UserEntity> custom({
    Expression<String>? id,
    Expression<String?>? role,
    Expression<String?>? language,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime?>? lastActive,
    Expression<bool>? online,
    Expression<bool>? banned,
    Expression<Map<String, Object?>>? extraData,
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
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String?>? role,
      Value<String?>? language,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? lastActive,
      Value<bool>? online,
      Value<bool>? banned,
      Value<Map<String, Object?>>? extraData}) {
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
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (role.present) {
      map['role'] = Variable<String?>(role.value);
    }
    if (language.present) {
      map['language'] = Variable<String?>(language.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastActive.present) {
      map['last_active'] = Variable<DateTime?>(lastActive.value);
    }
    if (online.present) {
      map['online'] = Variable<bool>(online.value);
    }
    if (banned.present) {
      map['banned'] = Variable<bool>(banned.value);
    }
    if (extraData.present) {
      final converter = $UsersTable.$converter0;
      map['extra_data'] =
          Variable<String>(converter.mapToSql(extraData.value)!);
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
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, UserEntity> {
  final GeneratedDatabase _db;
  final String? _alias;
  $UsersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String?> role = GeneratedColumn<String?>(
      'role', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _languageMeta = const VerificationMeta('language');
  @override
  late final GeneratedColumn<String?> language = GeneratedColumn<String?>(
      'language', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  final VerificationMeta _lastActiveMeta = const VerificationMeta('lastActive');
  @override
  late final GeneratedColumn<DateTime?> lastActive = GeneratedColumn<DateTime?>(
      'last_active', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _onlineMeta = const VerificationMeta('online');
  @override
  late final GeneratedColumn<bool?> online = GeneratedColumn<bool?>(
      'online', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (online IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _bannedMeta = const VerificationMeta('banned');
  @override
  late final GeneratedColumn<bool?> banned = GeneratedColumn<bool?>(
      'banned', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (banned IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _extraDataMeta = const VerificationMeta('extraData');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String?>
      extraData = GeneratedColumn<String?>('extra_data', aliasedName, false,
              type: const StringType(), requiredDuringInsert: true)
          .withConverter<Map<String, Object?>>($UsersTable.$converter0);
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
  String get aliasedName => _alias ?? 'users';
  @override
  String get actualTableName => 'users';
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
    return UserEntity.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(_db, alias);
  }

  static TypeConverter<Map<String, Object?>, String> $converter0 =
      MapConverter<Object?>();
}

class MemberEntity extends DataClass implements Insertable<MemberEntity> {
  /// The interested user id
  final String userId;

  /// The channel cid of which this user is part of
  final String channelCid;

  /// The role of the user in the channel
  final String? role;

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

  /// The date of creation
  final DateTime createdAt;

  /// The last date of update
  final DateTime updatedAt;
  MemberEntity(
      {required this.userId,
      required this.channelCid,
      this.role,
      this.inviteAcceptedAt,
      this.inviteRejectedAt,
      required this.invited,
      required this.banned,
      required this.shadowBanned,
      required this.isModerator,
      required this.createdAt,
      required this.updatedAt});
  factory MemberEntity.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return MemberEntity(
      userId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id'])!,
      channelCid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_cid'])!,
      role: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}role']),
      inviteAcceptedAt: const DateTimeType().mapFromDatabaseResponse(
          data['${effectivePrefix}invite_accepted_at']),
      inviteRejectedAt: const DateTimeType().mapFromDatabaseResponse(
          data['${effectivePrefix}invite_rejected_at']),
      invited: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}invited'])!,
      banned: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}banned'])!,
      shadowBanned: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}shadow_banned'])!,
      isModerator: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_moderator'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['channel_cid'] = Variable<String>(channelCid);
    if (!nullToAbsent || role != null) {
      map['role'] = Variable<String?>(role);
    }
    if (!nullToAbsent || inviteAcceptedAt != null) {
      map['invite_accepted_at'] = Variable<DateTime?>(inviteAcceptedAt);
    }
    if (!nullToAbsent || inviteRejectedAt != null) {
      map['invite_rejected_at'] = Variable<DateTime?>(inviteRejectedAt);
    }
    map['invited'] = Variable<bool>(invited);
    map['banned'] = Variable<bool>(banned);
    map['shadow_banned'] = Variable<bool>(shadowBanned);
    map['is_moderator'] = Variable<bool>(isModerator);
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
      role: serializer.fromJson<String?>(json['role']),
      inviteAcceptedAt:
          serializer.fromJson<DateTime?>(json['inviteAcceptedAt']),
      inviteRejectedAt:
          serializer.fromJson<DateTime?>(json['inviteRejectedAt']),
      invited: serializer.fromJson<bool>(json['invited']),
      banned: serializer.fromJson<bool>(json['banned']),
      shadowBanned: serializer.fromJson<bool>(json['shadowBanned']),
      isModerator: serializer.fromJson<bool>(json['isModerator']),
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
      'role': serializer.toJson<String?>(role),
      'inviteAcceptedAt': serializer.toJson<DateTime?>(inviteAcceptedAt),
      'inviteRejectedAt': serializer.toJson<DateTime?>(inviteRejectedAt),
      'invited': serializer.toJson<bool>(invited),
      'banned': serializer.toJson<bool>(banned),
      'shadowBanned': serializer.toJson<bool>(shadowBanned),
      'isModerator': serializer.toJson<bool>(isModerator),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MemberEntity copyWith(
          {String? userId,
          String? channelCid,
          Value<String?> role = const Value.absent(),
          Value<DateTime?> inviteAcceptedAt = const Value.absent(),
          Value<DateTime?> inviteRejectedAt = const Value.absent(),
          bool? invited,
          bool? banned,
          bool? shadowBanned,
          bool? isModerator,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MemberEntity(
        userId: userId ?? this.userId,
        channelCid: channelCid ?? this.channelCid,
        role: role.present ? role.value : this.role,
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
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('MemberEntity(')
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
  int get hashCode => Object.hash(
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
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemberEntity &&
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

class MembersCompanion extends UpdateCompanion<MemberEntity> {
  final Value<String> userId;
  final Value<String> channelCid;
  final Value<String?> role;
  final Value<DateTime?> inviteAcceptedAt;
  final Value<DateTime?> inviteRejectedAt;
  final Value<bool> invited;
  final Value<bool> banned;
  final Value<bool> shadowBanned;
  final Value<bool> isModerator;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MembersCompanion({
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
  MembersCompanion.insert({
    required String userId,
    required String channelCid,
    this.role = const Value.absent(),
    this.inviteAcceptedAt = const Value.absent(),
    this.inviteRejectedAt = const Value.absent(),
    this.invited = const Value.absent(),
    this.banned = const Value.absent(),
    this.shadowBanned = const Value.absent(),
    this.isModerator = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : userId = Value(userId),
        channelCid = Value(channelCid);
  static Insertable<MemberEntity> custom({
    Expression<String>? userId,
    Expression<String>? channelCid,
    Expression<String?>? role,
    Expression<DateTime?>? inviteAcceptedAt,
    Expression<DateTime?>? inviteRejectedAt,
    Expression<bool>? invited,
    Expression<bool>? banned,
    Expression<bool>? shadowBanned,
    Expression<bool>? isModerator,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
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

  MembersCompanion copyWith(
      {Value<String>? userId,
      Value<String>? channelCid,
      Value<String?>? role,
      Value<DateTime?>? inviteAcceptedAt,
      Value<DateTime?>? inviteRejectedAt,
      Value<bool>? invited,
      Value<bool>? banned,
      Value<bool>? shadowBanned,
      Value<bool>? isModerator,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return MembersCompanion(
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
      map['role'] = Variable<String?>(role.value);
    }
    if (inviteAcceptedAt.present) {
      map['invite_accepted_at'] = Variable<DateTime?>(inviteAcceptedAt.value);
    }
    if (inviteRejectedAt.present) {
      map['invite_rejected_at'] = Variable<DateTime?>(inviteRejectedAt.value);
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
    return (StringBuffer('MembersCompanion(')
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

class $MembersTable extends Members
    with TableInfo<$MembersTable, MemberEntity> {
  final GeneratedDatabase _db;
  final String? _alias;
  $MembersTable(this._db, [this._alias]);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String?> userId = GeneratedColumn<String?>(
      'user_id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _channelCidMeta = const VerificationMeta('channelCid');
  @override
  late final GeneratedColumn<String?> channelCid = GeneratedColumn<String?>(
      'channel_cid', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES channels(cid) ON DELETE CASCADE');
  final VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String?> role = GeneratedColumn<String?>(
      'role', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _inviteAcceptedAtMeta =
      const VerificationMeta('inviteAcceptedAt');
  @override
  late final GeneratedColumn<DateTime?> inviteAcceptedAt =
      GeneratedColumn<DateTime?>('invite_accepted_at', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _inviteRejectedAtMeta =
      const VerificationMeta('inviteRejectedAt');
  @override
  late final GeneratedColumn<DateTime?> inviteRejectedAt =
      GeneratedColumn<DateTime?>('invite_rejected_at', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _invitedMeta = const VerificationMeta('invited');
  @override
  late final GeneratedColumn<bool?> invited = GeneratedColumn<bool?>(
      'invited', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (invited IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _bannedMeta = const VerificationMeta('banned');
  @override
  late final GeneratedColumn<bool?> banned = GeneratedColumn<bool?>(
      'banned', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (banned IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _shadowBannedMeta =
      const VerificationMeta('shadowBanned');
  @override
  late final GeneratedColumn<bool?> shadowBanned = GeneratedColumn<bool?>(
      'shadow_banned', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (shadow_banned IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _isModeratorMeta =
      const VerificationMeta('isModerator');
  @override
  late final GeneratedColumn<bool?> isModerator = GeneratedColumn<bool?>(
      'is_moderator', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_moderator IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
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
  String get aliasedName => _alias ?? 'members';
  @override
  String get actualTableName => 'members';
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
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
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
    return MemberEntity.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $MembersTable createAlias(String alias) {
    return $MembersTable(_db, alias);
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
  ReadEntity(
      {required this.lastRead,
      required this.userId,
      required this.channelCid,
      required this.unreadMessages});
  factory ReadEntity.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ReadEntity(
      lastRead: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_read'])!,
      userId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id'])!,
      channelCid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_cid'])!,
      unreadMessages: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}unread_messages'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['last_read'] = Variable<DateTime>(lastRead);
    map['user_id'] = Variable<String>(userId);
    map['channel_cid'] = Variable<String>(channelCid);
    map['unread_messages'] = Variable<int>(unreadMessages);
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
    };
  }

  ReadEntity copyWith(
          {DateTime? lastRead,
          String? userId,
          String? channelCid,
          int? unreadMessages}) =>
      ReadEntity(
        lastRead: lastRead ?? this.lastRead,
        userId: userId ?? this.userId,
        channelCid: channelCid ?? this.channelCid,
        unreadMessages: unreadMessages ?? this.unreadMessages,
      );
  @override
  String toString() {
    return (StringBuffer('ReadEntity(')
          ..write('lastRead: $lastRead, ')
          ..write('userId: $userId, ')
          ..write('channelCid: $channelCid, ')
          ..write('unreadMessages: $unreadMessages')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lastRead, userId, channelCid, unreadMessages);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadEntity &&
          other.lastRead == this.lastRead &&
          other.userId == this.userId &&
          other.channelCid == this.channelCid &&
          other.unreadMessages == this.unreadMessages);
}

class ReadsCompanion extends UpdateCompanion<ReadEntity> {
  final Value<DateTime> lastRead;
  final Value<String> userId;
  final Value<String> channelCid;
  final Value<int> unreadMessages;
  const ReadsCompanion({
    this.lastRead = const Value.absent(),
    this.userId = const Value.absent(),
    this.channelCid = const Value.absent(),
    this.unreadMessages = const Value.absent(),
  });
  ReadsCompanion.insert({
    required DateTime lastRead,
    required String userId,
    required String channelCid,
    this.unreadMessages = const Value.absent(),
  })  : lastRead = Value(lastRead),
        userId = Value(userId),
        channelCid = Value(channelCid);
  static Insertable<ReadEntity> custom({
    Expression<DateTime>? lastRead,
    Expression<String>? userId,
    Expression<String>? channelCid,
    Expression<int>? unreadMessages,
  }) {
    return RawValuesInsertable({
      if (lastRead != null) 'last_read': lastRead,
      if (userId != null) 'user_id': userId,
      if (channelCid != null) 'channel_cid': channelCid,
      if (unreadMessages != null) 'unread_messages': unreadMessages,
    });
  }

  ReadsCompanion copyWith(
      {Value<DateTime>? lastRead,
      Value<String>? userId,
      Value<String>? channelCid,
      Value<int>? unreadMessages}) {
    return ReadsCompanion(
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
    return (StringBuffer('ReadsCompanion(')
          ..write('lastRead: $lastRead, ')
          ..write('userId: $userId, ')
          ..write('channelCid: $channelCid, ')
          ..write('unreadMessages: $unreadMessages')
          ..write(')'))
        .toString();
  }
}

class $ReadsTable extends Reads with TableInfo<$ReadsTable, ReadEntity> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ReadsTable(this._db, [this._alias]);
  final VerificationMeta _lastReadMeta = const VerificationMeta('lastRead');
  @override
  late final GeneratedColumn<DateTime?> lastRead = GeneratedColumn<DateTime?>(
      'last_read', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String?> userId = GeneratedColumn<String?>(
      'user_id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _channelCidMeta = const VerificationMeta('channelCid');
  @override
  late final GeneratedColumn<String?> channelCid = GeneratedColumn<String?>(
      'channel_cid', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES channels(cid) ON DELETE CASCADE');
  final VerificationMeta _unreadMessagesMeta =
      const VerificationMeta('unreadMessages');
  @override
  late final GeneratedColumn<int?> unreadMessages = GeneratedColumn<int?>(
      'unread_messages', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [lastRead, userId, channelCid, unreadMessages];
  @override
  String get aliasedName => _alias ?? 'reads';
  @override
  String get actualTableName => 'reads';
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, channelCid};
  @override
  ReadEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ReadEntity.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ReadsTable createAlias(String alias) {
    return $ReadsTable(_db, alias);
  }
}

class ChannelQueryEntity extends DataClass
    implements Insertable<ChannelQueryEntity> {
  /// The unique hash of this query
  final String queryHash;

  /// The channel cid of this query
  final String channelCid;
  ChannelQueryEntity({required this.queryHash, required this.channelCid});
  factory ChannelQueryEntity.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ChannelQueryEntity(
      queryHash: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}query_hash'])!,
      channelCid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_cid'])!,
    );
  }
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
  const ChannelQueriesCompanion({
    this.queryHash = const Value.absent(),
    this.channelCid = const Value.absent(),
  });
  ChannelQueriesCompanion.insert({
    required String queryHash,
    required String channelCid,
  })  : queryHash = Value(queryHash),
        channelCid = Value(channelCid);
  static Insertable<ChannelQueryEntity> custom({
    Expression<String>? queryHash,
    Expression<String>? channelCid,
  }) {
    return RawValuesInsertable({
      if (queryHash != null) 'query_hash': queryHash,
      if (channelCid != null) 'channel_cid': channelCid,
    });
  }

  ChannelQueriesCompanion copyWith(
      {Value<String>? queryHash, Value<String>? channelCid}) {
    return ChannelQueriesCompanion(
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
    return (StringBuffer('ChannelQueriesCompanion(')
          ..write('queryHash: $queryHash, ')
          ..write('channelCid: $channelCid')
          ..write(')'))
        .toString();
  }
}

class $ChannelQueriesTable extends ChannelQueries
    with TableInfo<$ChannelQueriesTable, ChannelQueryEntity> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ChannelQueriesTable(this._db, [this._alias]);
  final VerificationMeta _queryHashMeta = const VerificationMeta('queryHash');
  @override
  late final GeneratedColumn<String?> queryHash = GeneratedColumn<String?>(
      'query_hash', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _channelCidMeta = const VerificationMeta('channelCid');
  @override
  late final GeneratedColumn<String?> channelCid = GeneratedColumn<String?>(
      'channel_cid', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [queryHash, channelCid];
  @override
  String get aliasedName => _alias ?? 'channel_queries';
  @override
  String get actualTableName => 'channel_queries';
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
    return ChannelQueryEntity.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ChannelQueriesTable createAlias(String alias) {
    return $ChannelQueriesTable(_db, alias);
  }
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
  ConnectionEventEntity(
      {required this.id,
      required this.type,
      this.ownUser,
      this.totalUnreadCount,
      this.unreadChannels,
      this.lastEventAt,
      this.lastSyncAt});
  factory ConnectionEventEntity.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ConnectionEventEntity(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      type: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      ownUser: $ConnectionEventsTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}own_user'])),
      totalUnreadCount: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}total_unread_count']),
      unreadChannels: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}unread_channels']),
      lastEventAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_event_at']),
      lastSyncAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_sync_at']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || ownUser != null) {
      final converter = $ConnectionEventsTable.$converter0;
      map['own_user'] = Variable<String?>(converter.mapToSql(ownUser));
    }
    if (!nullToAbsent || totalUnreadCount != null) {
      map['total_unread_count'] = Variable<int?>(totalUnreadCount);
    }
    if (!nullToAbsent || unreadChannels != null) {
      map['unread_channels'] = Variable<int?>(unreadChannels);
    }
    if (!nullToAbsent || lastEventAt != null) {
      map['last_event_at'] = Variable<DateTime?>(lastEventAt);
    }
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime?>(lastSyncAt);
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
    Expression<Map<String, dynamic>?>? ownUser,
    Expression<int?>? totalUnreadCount,
    Expression<int?>? unreadChannels,
    Expression<DateTime?>? lastEventAt,
    Expression<DateTime?>? lastSyncAt,
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
      final converter = $ConnectionEventsTable.$converter0;
      map['own_user'] = Variable<String?>(converter.mapToSql(ownUser.value));
    }
    if (totalUnreadCount.present) {
      map['total_unread_count'] = Variable<int?>(totalUnreadCount.value);
    }
    if (unreadChannels.present) {
      map['unread_channels'] = Variable<int?>(unreadChannels.value);
    }
    if (lastEventAt.present) {
      map['last_event_at'] = Variable<DateTime?>(lastEventAt.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime?>(lastSyncAt.value);
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

class $ConnectionEventsTable extends ConnectionEvents
    with TableInfo<$ConnectionEventsTable, ConnectionEventEntity> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ConnectionEventsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String?> type = GeneratedColumn<String?>(
      'type', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _ownUserMeta = const VerificationMeta('ownUser');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String?>
      ownUser = GeneratedColumn<String?>('own_user', aliasedName, true,
              type: const StringType(), requiredDuringInsert: false)
          .withConverter<Map<String, dynamic>>(
              $ConnectionEventsTable.$converter0);
  final VerificationMeta _totalUnreadCountMeta =
      const VerificationMeta('totalUnreadCount');
  @override
  late final GeneratedColumn<int?> totalUnreadCount = GeneratedColumn<int?>(
      'total_unread_count', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _unreadChannelsMeta =
      const VerificationMeta('unreadChannels');
  @override
  late final GeneratedColumn<int?> unreadChannels = GeneratedColumn<int?>(
      'unread_channels', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _lastEventAtMeta =
      const VerificationMeta('lastEventAt');
  @override
  late final GeneratedColumn<DateTime?> lastEventAt =
      GeneratedColumn<DateTime?>('last_event_at', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _lastSyncAtMeta = const VerificationMeta('lastSyncAt');
  @override
  late final GeneratedColumn<DateTime?> lastSyncAt = GeneratedColumn<DateTime?>(
      'last_sync_at', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
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
  String get aliasedName => _alias ?? 'connection_events';
  @override
  String get actualTableName => 'connection_events';
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
    return ConnectionEventEntity.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ConnectionEventsTable createAlias(String alias) {
    return $ConnectionEventsTable(_db, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converter0 =
      MapConverter();
}

abstract class _$DriftChatDatabase extends GeneratedDatabase {
  _$DriftChatDatabase(QueryExecutor e)
      : super(SqlTypeSystem.defaultInstance, e);
  _$DriftChatDatabase.connect(DatabaseConnection c) : super.connect(c);
  late final $ChannelsTable channels = $ChannelsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $PinnedMessagesTable pinnedMessages = $PinnedMessagesTable(this);
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
  late final ReactionDao reactionDao = ReactionDao(this as DriftChatDatabase);
  late final ReadDao readDao = ReadDao(this as DriftChatDatabase);
  late final ChannelQueryDao channelQueryDao =
      ChannelQueryDao(this as DriftChatDatabase);
  late final ConnectionEventDao connectionEventDao =
      ConnectionEventDao(this as DriftChatDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        channels,
        messages,
        pinnedMessages,
        pinnedMessageReactions,
        reactions,
        users,
        members,
        reads,
        channelQueries,
        connectionEvents
      ];
}
