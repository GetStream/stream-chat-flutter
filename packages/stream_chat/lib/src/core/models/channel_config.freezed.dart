// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelConfig {
  String get automod;
  List<Command> get commands;
  bool get connectEvents;
  DateTime get createdAt;
  DateTime get updatedAt;
  int get maxMessageLength;
  String get messageRetention;
  bool get mutes;
  bool get reactions;
  bool get readEvents;
  bool get replies;
  bool get search;
  bool get polls;
  PushLevel? get pushLevel;
  bool get pushNotifications;
  ChatPreferences? get chatPreferences;
  bool get typingEvents;
  bool get uploads;
  bool get urlEnrichment;
  bool get skipLastMsgUpdateForSystemMsgs;
  bool get userMessageReminders;
  bool get markMessagesPending;
  bool get deliveryEvents;
  bool get sharedLocations;

  /// Create a copy of ChannelConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelConfigCopyWith<ChannelConfig> get copyWith =>
      _$ChannelConfigCopyWithImpl<ChannelConfig>(this as ChannelConfig, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelConfig &&
            (identical(other.automod, automod) || other.automod == automod) &&
            const DeepCollectionEquality().equals(other.commands, commands) &&
            (identical(other.connectEvents, connectEvents) || other.connectEvents == connectEvents) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            (identical(other.maxMessageLength, maxMessageLength) || other.maxMessageLength == maxMessageLength) &&
            (identical(other.messageRetention, messageRetention) || other.messageRetention == messageRetention) &&
            (identical(other.mutes, mutes) || other.mutes == mutes) &&
            (identical(other.reactions, reactions) || other.reactions == reactions) &&
            (identical(other.readEvents, readEvents) || other.readEvents == readEvents) &&
            (identical(other.replies, replies) || other.replies == replies) &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.polls, polls) || other.polls == polls) &&
            (identical(other.pushLevel, pushLevel) || other.pushLevel == pushLevel) &&
            (identical(other.pushNotifications, pushNotifications) || other.pushNotifications == pushNotifications) &&
            (identical(other.chatPreferences, chatPreferences) || other.chatPreferences == chatPreferences) &&
            (identical(other.typingEvents, typingEvents) || other.typingEvents == typingEvents) &&
            (identical(other.uploads, uploads) || other.uploads == uploads) &&
            (identical(other.urlEnrichment, urlEnrichment) || other.urlEnrichment == urlEnrichment) &&
            (identical(other.skipLastMsgUpdateForSystemMsgs, skipLastMsgUpdateForSystemMsgs) ||
                other.skipLastMsgUpdateForSystemMsgs == skipLastMsgUpdateForSystemMsgs) &&
            (identical(other.userMessageReminders, userMessageReminders) ||
                other.userMessageReminders == userMessageReminders) &&
            (identical(other.markMessagesPending, markMessagesPending) ||
                other.markMessagesPending == markMessagesPending) &&
            (identical(other.deliveryEvents, deliveryEvents) || other.deliveryEvents == deliveryEvents) &&
            (identical(other.sharedLocations, sharedLocations) || other.sharedLocations == sharedLocations));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    automod,
    const DeepCollectionEquality().hash(commands),
    connectEvents,
    createdAt,
    updatedAt,
    maxMessageLength,
    messageRetention,
    mutes,
    reactions,
    readEvents,
    replies,
    search,
    polls,
    pushLevel,
    pushNotifications,
    chatPreferences,
    typingEvents,
    uploads,
    urlEnrichment,
    skipLastMsgUpdateForSystemMsgs,
    userMessageReminders,
    markMessagesPending,
    deliveryEvents,
    sharedLocations,
  ]);

  @override
  String toString() {
    return 'ChannelConfig(automod: $automod, commands: $commands, connectEvents: $connectEvents, createdAt: $createdAt, updatedAt: $updatedAt, maxMessageLength: $maxMessageLength, messageRetention: $messageRetention, mutes: $mutes, reactions: $reactions, readEvents: $readEvents, replies: $replies, search: $search, polls: $polls, pushLevel: $pushLevel, pushNotifications: $pushNotifications, chatPreferences: $chatPreferences, typingEvents: $typingEvents, uploads: $uploads, urlEnrichment: $urlEnrichment, skipLastMsgUpdateForSystemMsgs: $skipLastMsgUpdateForSystemMsgs, userMessageReminders: $userMessageReminders, markMessagesPending: $markMessagesPending, deliveryEvents: $deliveryEvents, sharedLocations: $sharedLocations)';
  }
}

/// @nodoc
abstract mixin class $ChannelConfigCopyWith<$Res> {
  factory $ChannelConfigCopyWith(ChannelConfig value, $Res Function(ChannelConfig) _then) = _$ChannelConfigCopyWithImpl;
  @useResult
  $Res call({
    String automod,
    List<Command> commands,
    bool connectEvents,
    DateTime? createdAt,
    DateTime? updatedAt,
    int maxMessageLength,
    String messageRetention,
    bool mutes,
    bool reactions,
    bool readEvents,
    bool replies,
    bool search,
    bool polls,
    PushLevel? pushLevel,
    bool pushNotifications,
    ChatPreferences? chatPreferences,
    bool typingEvents,
    bool uploads,
    bool urlEnrichment,
    bool skipLastMsgUpdateForSystemMsgs,
    bool userMessageReminders,
    bool markMessagesPending,
    bool deliveryEvents,
    bool sharedLocations,
  });
}

/// @nodoc
class _$ChannelConfigCopyWithImpl<$Res> implements $ChannelConfigCopyWith<$Res> {
  _$ChannelConfigCopyWithImpl(this._self, this._then);

  final ChannelConfig _self;
  final $Res Function(ChannelConfig) _then;

  /// Create a copy of ChannelConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? automod = null,
    Object? commands = null,
    Object? connectEvents = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? maxMessageLength = null,
    Object? messageRetention = null,
    Object? mutes = null,
    Object? reactions = null,
    Object? readEvents = null,
    Object? replies = null,
    Object? search = null,
    Object? polls = null,
    Object? pushLevel = freezed,
    Object? pushNotifications = null,
    Object? chatPreferences = freezed,
    Object? typingEvents = null,
    Object? uploads = null,
    Object? urlEnrichment = null,
    Object? skipLastMsgUpdateForSystemMsgs = null,
    Object? userMessageReminders = null,
    Object? markMessagesPending = null,
    Object? deliveryEvents = null,
    Object? sharedLocations = null,
  }) {
    return _then(
      ChannelConfig(
        automod: null == automod
            ? _self.automod
            : automod // ignore: cast_nullable_to_non_nullable
                  as String,
        commands: null == commands
            ? _self.commands
            : commands // ignore: cast_nullable_to_non_nullable
                  as List<Command>,
        connectEvents: null == connectEvents
            ? _self.connectEvents
            : connectEvents // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _self.updatedAt!
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
        reactions: null == reactions
            ? _self.reactions
            : reactions // ignore: cast_nullable_to_non_nullable
                  as bool,
        readEvents: null == readEvents
            ? _self.readEvents
            : readEvents // ignore: cast_nullable_to_non_nullable
                  as bool,
        replies: null == replies
            ? _self.replies
            : replies // ignore: cast_nullable_to_non_nullable
                  as bool,
        search: null == search
            ? _self.search
            : search // ignore: cast_nullable_to_non_nullable
                  as bool,
        polls: null == polls
            ? _self.polls
            : polls // ignore: cast_nullable_to_non_nullable
                  as bool,
        pushLevel: freezed == pushLevel
            ? _self.pushLevel
            : pushLevel // ignore: cast_nullable_to_non_nullable
                  as PushLevel?,
        pushNotifications: null == pushNotifications
            ? _self.pushNotifications
            : pushNotifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        chatPreferences: freezed == chatPreferences
            ? _self.chatPreferences
            : chatPreferences // ignore: cast_nullable_to_non_nullable
                  as ChatPreferences?,
        typingEvents: null == typingEvents
            ? _self.typingEvents
            : typingEvents // ignore: cast_nullable_to_non_nullable
                  as bool,
        uploads: null == uploads
            ? _self.uploads
            : uploads // ignore: cast_nullable_to_non_nullable
                  as bool,
        urlEnrichment: null == urlEnrichment
            ? _self.urlEnrichment
            : urlEnrichment // ignore: cast_nullable_to_non_nullable
                  as bool,
        skipLastMsgUpdateForSystemMsgs: null == skipLastMsgUpdateForSystemMsgs
            ? _self.skipLastMsgUpdateForSystemMsgs
            : skipLastMsgUpdateForSystemMsgs // ignore: cast_nullable_to_non_nullable
                  as bool,
        userMessageReminders: null == userMessageReminders
            ? _self.userMessageReminders
            : userMessageReminders // ignore: cast_nullable_to_non_nullable
                  as bool,
        markMessagesPending: null == markMessagesPending
            ? _self.markMessagesPending
            : markMessagesPending // ignore: cast_nullable_to_non_nullable
                  as bool,
        deliveryEvents: null == deliveryEvents
            ? _self.deliveryEvents
            : deliveryEvents // ignore: cast_nullable_to_non_nullable
                  as bool,
        sharedLocations: null == sharedLocations
            ? _self.sharedLocations
            : sharedLocations // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
