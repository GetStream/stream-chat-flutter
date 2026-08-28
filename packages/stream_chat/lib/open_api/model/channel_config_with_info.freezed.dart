// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_config_with_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelConfigWithInfo {
  List<String>? get allowedFlagReasons;
  ChannelConfigWithInfoAutomod get automod;
  ChannelConfigWithInfoAutomodBehavior get automodBehavior;
  Thresholds? get automodThresholds;
  String? get blocklist;
  ChannelConfigWithInfoBlocklistBehavior? get blocklistBehavior;
  List<BlockListOptions>? get blocklists;
  ChatPreferences? get chatPreferences;
  List<Command> get commands;
  bool get connectEvents;
  bool get countMessages;
  DateTime get createdAt;
  bool get customEvents;
  bool get deliveryEvents;
  Map<String, List<String>>? get grants;
  bool get markMessagesPending;
  int get maxMessageLength;
  String get messageRetention;
  bool get mutes;
  String get name;
  int? get partitionSize;
  String? get partitionTtl;
  bool get polls;
  ChannelConfigWithInfoPushLevel? get pushLevel;
  bool get pushNotifications;
  bool get quotes;
  bool get reactions;
  bool get readEvents;
  bool get reminders;
  bool get replies;
  bool get search;
  bool get sharedLocations;
  bool get skipLastMsgUpdateForSystemMsgs;
  bool get typingEvents;
  DateTime get updatedAt;
  bool get uploads;
  bool get urlEnrichment;
  bool get userMessageReminders;

  /// Create a copy of ChannelConfigWithInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelConfigWithInfoCopyWith<ChannelConfigWithInfo> get copyWith =>
      _$ChannelConfigWithInfoCopyWithImpl<ChannelConfigWithInfo>(
        this as ChannelConfigWithInfo,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelConfigWithInfo &&
            const DeepCollectionEquality().equals(
              other.allowedFlagReasons,
              allowedFlagReasons,
            ) &&
            (identical(other.automod, automod) || other.automod == automod) &&
            (identical(other.automodBehavior, automodBehavior) || other.automodBehavior == automodBehavior) &&
            (identical(other.automodThresholds, automodThresholds) || other.automodThresholds == automodThresholds) &&
            (identical(other.blocklist, blocklist) || other.blocklist == blocklist) &&
            (identical(other.blocklistBehavior, blocklistBehavior) || other.blocklistBehavior == blocklistBehavior) &&
            const DeepCollectionEquality().equals(
              other.blocklists,
              blocklists,
            ) &&
            (identical(other.chatPreferences, chatPreferences) || other.chatPreferences == chatPreferences) &&
            const DeepCollectionEquality().equals(other.commands, commands) &&
            (identical(other.connectEvents, connectEvents) || other.connectEvents == connectEvents) &&
            (identical(other.countMessages, countMessages) || other.countMessages == countMessages) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.customEvents, customEvents) || other.customEvents == customEvents) &&
            (identical(other.deliveryEvents, deliveryEvents) || other.deliveryEvents == deliveryEvents) &&
            const DeepCollectionEquality().equals(other.grants, grants) &&
            (identical(other.markMessagesPending, markMessagesPending) ||
                other.markMessagesPending == markMessagesPending) &&
            (identical(other.maxMessageLength, maxMessageLength) || other.maxMessageLength == maxMessageLength) &&
            (identical(other.messageRetention, messageRetention) || other.messageRetention == messageRetention) &&
            (identical(other.mutes, mutes) || other.mutes == mutes) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.partitionSize, partitionSize) || other.partitionSize == partitionSize) &&
            (identical(other.partitionTtl, partitionTtl) || other.partitionTtl == partitionTtl) &&
            (identical(other.polls, polls) || other.polls == polls) &&
            (identical(other.pushLevel, pushLevel) || other.pushLevel == pushLevel) &&
            (identical(other.pushNotifications, pushNotifications) || other.pushNotifications == pushNotifications) &&
            (identical(other.quotes, quotes) || other.quotes == quotes) &&
            (identical(other.reactions, reactions) || other.reactions == reactions) &&
            (identical(other.readEvents, readEvents) || other.readEvents == readEvents) &&
            (identical(other.reminders, reminders) || other.reminders == reminders) &&
            (identical(other.replies, replies) || other.replies == replies) &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.sharedLocations, sharedLocations) || other.sharedLocations == sharedLocations) &&
            (identical(
                  other.skipLastMsgUpdateForSystemMsgs,
                  skipLastMsgUpdateForSystemMsgs,
                ) ||
                other.skipLastMsgUpdateForSystemMsgs == skipLastMsgUpdateForSystemMsgs) &&
            (identical(other.typingEvents, typingEvents) || other.typingEvents == typingEvents) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            (identical(other.uploads, uploads) || other.uploads == uploads) &&
            (identical(other.urlEnrichment, urlEnrichment) || other.urlEnrichment == urlEnrichment) &&
            (identical(other.userMessageReminders, userMessageReminders) ||
                other.userMessageReminders == userMessageReminders));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    const DeepCollectionEquality().hash(allowedFlagReasons),
    automod,
    automodBehavior,
    automodThresholds,
    blocklist,
    blocklistBehavior,
    const DeepCollectionEquality().hash(blocklists),
    chatPreferences,
    const DeepCollectionEquality().hash(commands),
    connectEvents,
    countMessages,
    createdAt,
    customEvents,
    deliveryEvents,
    const DeepCollectionEquality().hash(grants),
    markMessagesPending,
    maxMessageLength,
    messageRetention,
    mutes,
    name,
    partitionSize,
    partitionTtl,
    polls,
    pushLevel,
    pushNotifications,
    quotes,
    reactions,
    readEvents,
    reminders,
    replies,
    search,
    sharedLocations,
    skipLastMsgUpdateForSystemMsgs,
    typingEvents,
    updatedAt,
    uploads,
    urlEnrichment,
    userMessageReminders,
  ]);

  @override
  String toString() {
    return 'ChannelConfigWithInfo(allowedFlagReasons: $allowedFlagReasons, automod: $automod, automodBehavior: $automodBehavior, automodThresholds: $automodThresholds, blocklist: $blocklist, blocklistBehavior: $blocklistBehavior, blocklists: $blocklists, chatPreferences: $chatPreferences, commands: $commands, connectEvents: $connectEvents, countMessages: $countMessages, createdAt: $createdAt, customEvents: $customEvents, deliveryEvents: $deliveryEvents, grants: $grants, markMessagesPending: $markMessagesPending, maxMessageLength: $maxMessageLength, messageRetention: $messageRetention, mutes: $mutes, name: $name, partitionSize: $partitionSize, partitionTtl: $partitionTtl, polls: $polls, pushLevel: $pushLevel, pushNotifications: $pushNotifications, quotes: $quotes, reactions: $reactions, readEvents: $readEvents, reminders: $reminders, replies: $replies, search: $search, sharedLocations: $sharedLocations, skipLastMsgUpdateForSystemMsgs: $skipLastMsgUpdateForSystemMsgs, typingEvents: $typingEvents, updatedAt: $updatedAt, uploads: $uploads, urlEnrichment: $urlEnrichment, userMessageReminders: $userMessageReminders)';
  }
}

/// @nodoc
abstract mixin class $ChannelConfigWithInfoCopyWith<$Res> {
  factory $ChannelConfigWithInfoCopyWith(
    ChannelConfigWithInfo value,
    $Res Function(ChannelConfigWithInfo) _then,
  ) = _$ChannelConfigWithInfoCopyWithImpl;
  @useResult
  $Res call({
    List<String>? allowedFlagReasons,
    ChannelConfigWithInfoAutomod automod,
    ChannelConfigWithInfoAutomodBehavior automodBehavior,
    Thresholds? automodThresholds,
    String? blocklist,
    ChannelConfigWithInfoBlocklistBehavior? blocklistBehavior,
    List<BlockListOptions>? blocklists,
    ChatPreferences? chatPreferences,
    List<Command> commands,
    bool connectEvents,
    bool countMessages,
    DateTime createdAt,
    bool customEvents,
    bool deliveryEvents,
    Map<String, List<String>>? grants,
    bool markMessagesPending,
    int maxMessageLength,
    String messageRetention,
    bool mutes,
    String name,
    int? partitionSize,
    String? partitionTtl,
    bool polls,
    ChannelConfigWithInfoPushLevel? pushLevel,
    bool pushNotifications,
    bool quotes,
    bool reactions,
    bool readEvents,
    bool reminders,
    bool replies,
    bool search,
    bool sharedLocations,
    bool skipLastMsgUpdateForSystemMsgs,
    bool typingEvents,
    DateTime updatedAt,
    bool uploads,
    bool urlEnrichment,
    bool userMessageReminders,
  });
}

/// @nodoc
class _$ChannelConfigWithInfoCopyWithImpl<$Res> implements $ChannelConfigWithInfoCopyWith<$Res> {
  _$ChannelConfigWithInfoCopyWithImpl(this._self, this._then);

  final ChannelConfigWithInfo _self;
  final $Res Function(ChannelConfigWithInfo) _then;

  /// Create a copy of ChannelConfigWithInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowedFlagReasons = freezed,
    Object? automod = null,
    Object? automodBehavior = null,
    Object? automodThresholds = freezed,
    Object? blocklist = freezed,
    Object? blocklistBehavior = freezed,
    Object? blocklists = freezed,
    Object? chatPreferences = freezed,
    Object? commands = null,
    Object? connectEvents = null,
    Object? countMessages = null,
    Object? createdAt = null,
    Object? customEvents = null,
    Object? deliveryEvents = null,
    Object? grants = freezed,
    Object? markMessagesPending = null,
    Object? maxMessageLength = null,
    Object? messageRetention = null,
    Object? mutes = null,
    Object? name = null,
    Object? partitionSize = freezed,
    Object? partitionTtl = freezed,
    Object? polls = null,
    Object? pushLevel = freezed,
    Object? pushNotifications = null,
    Object? quotes = null,
    Object? reactions = null,
    Object? readEvents = null,
    Object? reminders = null,
    Object? replies = null,
    Object? search = null,
    Object? sharedLocations = null,
    Object? skipLastMsgUpdateForSystemMsgs = null,
    Object? typingEvents = null,
    Object? updatedAt = null,
    Object? uploads = null,
    Object? urlEnrichment = null,
    Object? userMessageReminders = null,
  }) {
    return _then(
      ChannelConfigWithInfo(
        allowedFlagReasons: freezed == allowedFlagReasons
            ? _self.allowedFlagReasons
            : allowedFlagReasons // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        automod: null == automod
            ? _self.automod
            : automod // ignore: cast_nullable_to_non_nullable
                  as ChannelConfigWithInfoAutomod,
        automodBehavior: null == automodBehavior
            ? _self.automodBehavior
            : automodBehavior // ignore: cast_nullable_to_non_nullable
                  as ChannelConfigWithInfoAutomodBehavior,
        automodThresholds: freezed == automodThresholds
            ? _self.automodThresholds
            : automodThresholds // ignore: cast_nullable_to_non_nullable
                  as Thresholds?,
        blocklist: freezed == blocklist
            ? _self.blocklist
            : blocklist // ignore: cast_nullable_to_non_nullable
                  as String?,
        blocklistBehavior: freezed == blocklistBehavior
            ? _self.blocklistBehavior
            : blocklistBehavior // ignore: cast_nullable_to_non_nullable
                  as ChannelConfigWithInfoBlocklistBehavior?,
        blocklists: freezed == blocklists
            ? _self.blocklists
            : blocklists // ignore: cast_nullable_to_non_nullable
                  as List<BlockListOptions>?,
        chatPreferences: freezed == chatPreferences
            ? _self.chatPreferences
            : chatPreferences // ignore: cast_nullable_to_non_nullable
                  as ChatPreferences?,
        commands: null == commands
            ? _self.commands
            : commands // ignore: cast_nullable_to_non_nullable
                  as List<Command>,
        connectEvents: null == connectEvents
            ? _self.connectEvents
            : connectEvents // ignore: cast_nullable_to_non_nullable
                  as bool,
        countMessages: null == countMessages
            ? _self.countMessages
            : countMessages // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        customEvents: null == customEvents
            ? _self.customEvents
            : customEvents // ignore: cast_nullable_to_non_nullable
                  as bool,
        deliveryEvents: null == deliveryEvents
            ? _self.deliveryEvents
            : deliveryEvents // ignore: cast_nullable_to_non_nullable
                  as bool,
        grants: freezed == grants
            ? _self.grants
            : grants // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<String>>?,
        markMessagesPending: null == markMessagesPending
            ? _self.markMessagesPending
            : markMessagesPending // ignore: cast_nullable_to_non_nullable
                  as bool,
        maxMessageLength: null == maxMessageLength
            ? _self.maxMessageLength
            : maxMessageLength // ignore: cast_nullable_to_non_nullable
                  as int,
        messageRetention: null == messageRetention
            ? _self.messageRetention
            : messageRetention // ignore: cast_nullable_to_non_nullable
                  as String,
        mutes: null == mutes
            ? _self.mutes
            : mutes // ignore: cast_nullable_to_non_nullable
                  as bool,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        partitionSize: freezed == partitionSize
            ? _self.partitionSize
            : partitionSize // ignore: cast_nullable_to_non_nullable
                  as int?,
        partitionTtl: freezed == partitionTtl
            ? _self.partitionTtl
            : partitionTtl // ignore: cast_nullable_to_non_nullable
                  as String?,
        polls: null == polls
            ? _self.polls
            : polls // ignore: cast_nullable_to_non_nullable
                  as bool,
        pushLevel: freezed == pushLevel
            ? _self.pushLevel
            : pushLevel // ignore: cast_nullable_to_non_nullable
                  as ChannelConfigWithInfoPushLevel?,
        pushNotifications: null == pushNotifications
            ? _self.pushNotifications
            : pushNotifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        quotes: null == quotes
            ? _self.quotes
            : quotes // ignore: cast_nullable_to_non_nullable
                  as bool,
        reactions: null == reactions
            ? _self.reactions
            : reactions // ignore: cast_nullable_to_non_nullable
                  as bool,
        readEvents: null == readEvents
            ? _self.readEvents
            : readEvents // ignore: cast_nullable_to_non_nullable
                  as bool,
        reminders: null == reminders
            ? _self.reminders
            : reminders // ignore: cast_nullable_to_non_nullable
                  as bool,
        replies: null == replies
            ? _self.replies
            : replies // ignore: cast_nullable_to_non_nullable
                  as bool,
        search: null == search
            ? _self.search
            : search // ignore: cast_nullable_to_non_nullable
                  as bool,
        sharedLocations: null == sharedLocations
            ? _self.sharedLocations
            : sharedLocations // ignore: cast_nullable_to_non_nullable
                  as bool,
        skipLastMsgUpdateForSystemMsgs: null == skipLastMsgUpdateForSystemMsgs
            ? _self.skipLastMsgUpdateForSystemMsgs
            : skipLastMsgUpdateForSystemMsgs // ignore: cast_nullable_to_non_nullable
                  as bool,
        typingEvents: null == typingEvents
            ? _self.typingEvents
            : typingEvents // ignore: cast_nullable_to_non_nullable
                  as bool,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        uploads: null == uploads
            ? _self.uploads
            : uploads // ignore: cast_nullable_to_non_nullable
                  as bool,
        urlEnrichment: null == urlEnrichment
            ? _self.urlEnrichment
            : urlEnrichment // ignore: cast_nullable_to_non_nullable
                  as bool,
        userMessageReminders: null == userMessageReminders
            ? _self.userMessageReminders
            : userMessageReminders // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
