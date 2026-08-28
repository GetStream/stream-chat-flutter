// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_config_overrides.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelConfigOverrides {
  String? get blocklist;
  ChannelConfigOverridesBlocklistBehavior? get blocklistBehavior;
  ChatPreferences? get chatPreferences;
  List<String>? get commands;
  bool? get countMessages;
  Map<String, List<String>>? get grants;
  int? get maxMessageLength;
  ChannelConfigOverridesPushLevel? get pushLevel;
  bool? get quotes;
  bool? get reactions;
  bool? get replies;
  bool? get sharedLocations;
  bool? get typingEvents;
  bool? get uploads;
  bool? get urlEnrichment;
  bool? get userMessageReminders;

  /// Create a copy of ChannelConfigOverrides
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelConfigOverridesCopyWith<ChannelConfigOverrides> get copyWith =>
      _$ChannelConfigOverridesCopyWithImpl<ChannelConfigOverrides>(
        this as ChannelConfigOverrides,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelConfigOverrides &&
            (identical(other.blocklist, blocklist) ||
                other.blocklist == blocklist) &&
            (identical(other.blocklistBehavior, blocklistBehavior) ||
                other.blocklistBehavior == blocklistBehavior) &&
            (identical(other.chatPreferences, chatPreferences) ||
                other.chatPreferences == chatPreferences) &&
            const DeepCollectionEquality().equals(other.commands, commands) &&
            (identical(other.countMessages, countMessages) ||
                other.countMessages == countMessages) &&
            const DeepCollectionEquality().equals(other.grants, grants) &&
            (identical(other.maxMessageLength, maxMessageLength) ||
                other.maxMessageLength == maxMessageLength) &&
            (identical(other.pushLevel, pushLevel) ||
                other.pushLevel == pushLevel) &&
            (identical(other.quotes, quotes) || other.quotes == quotes) &&
            (identical(other.reactions, reactions) ||
                other.reactions == reactions) &&
            (identical(other.replies, replies) || other.replies == replies) &&
            (identical(other.sharedLocations, sharedLocations) ||
                other.sharedLocations == sharedLocations) &&
            (identical(other.typingEvents, typingEvents) ||
                other.typingEvents == typingEvents) &&
            (identical(other.uploads, uploads) || other.uploads == uploads) &&
            (identical(other.urlEnrichment, urlEnrichment) ||
                other.urlEnrichment == urlEnrichment) &&
            (identical(other.userMessageReminders, userMessageReminders) ||
                other.userMessageReminders == userMessageReminders));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    blocklist,
    blocklistBehavior,
    chatPreferences,
    const DeepCollectionEquality().hash(commands),
    countMessages,
    const DeepCollectionEquality().hash(grants),
    maxMessageLength,
    pushLevel,
    quotes,
    reactions,
    replies,
    sharedLocations,
    typingEvents,
    uploads,
    urlEnrichment,
    userMessageReminders,
  );

  @override
  String toString() {
    return 'ChannelConfigOverrides(blocklist: $blocklist, blocklistBehavior: $blocklistBehavior, chatPreferences: $chatPreferences, commands: $commands, countMessages: $countMessages, grants: $grants, maxMessageLength: $maxMessageLength, pushLevel: $pushLevel, quotes: $quotes, reactions: $reactions, replies: $replies, sharedLocations: $sharedLocations, typingEvents: $typingEvents, uploads: $uploads, urlEnrichment: $urlEnrichment, userMessageReminders: $userMessageReminders)';
  }
}

/// @nodoc
abstract mixin class $ChannelConfigOverridesCopyWith<$Res> {
  factory $ChannelConfigOverridesCopyWith(
    ChannelConfigOverrides value,
    $Res Function(ChannelConfigOverrides) _then,
  ) = _$ChannelConfigOverridesCopyWithImpl;
  @useResult
  $Res call({
    String? blocklist,
    ChannelConfigOverridesBlocklistBehavior? blocklistBehavior,
    ChatPreferences? chatPreferences,
    List<String>? commands,
    bool? countMessages,
    Map<String, List<String>>? grants,
    int? maxMessageLength,
    ChannelConfigOverridesPushLevel? pushLevel,
    bool? quotes,
    bool? reactions,
    bool? replies,
    bool? sharedLocations,
    bool? typingEvents,
    bool? uploads,
    bool? urlEnrichment,
    bool? userMessageReminders,
  });
}

/// @nodoc
class _$ChannelConfigOverridesCopyWithImpl<$Res>
    implements $ChannelConfigOverridesCopyWith<$Res> {
  _$ChannelConfigOverridesCopyWithImpl(this._self, this._then);

  final ChannelConfigOverrides _self;
  final $Res Function(ChannelConfigOverrides) _then;

  /// Create a copy of ChannelConfigOverrides
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blocklist = freezed,
    Object? blocklistBehavior = freezed,
    Object? chatPreferences = freezed,
    Object? commands = freezed,
    Object? countMessages = freezed,
    Object? grants = freezed,
    Object? maxMessageLength = freezed,
    Object? pushLevel = freezed,
    Object? quotes = freezed,
    Object? reactions = freezed,
    Object? replies = freezed,
    Object? sharedLocations = freezed,
    Object? typingEvents = freezed,
    Object? uploads = freezed,
    Object? urlEnrichment = freezed,
    Object? userMessageReminders = freezed,
  }) {
    return _then(
      ChannelConfigOverrides(
        blocklist: freezed == blocklist
            ? _self.blocklist
            : blocklist // ignore: cast_nullable_to_non_nullable
                  as String?,
        blocklistBehavior: freezed == blocklistBehavior
            ? _self.blocklistBehavior
            : blocklistBehavior // ignore: cast_nullable_to_non_nullable
                  as ChannelConfigOverridesBlocklistBehavior?,
        chatPreferences: freezed == chatPreferences
            ? _self.chatPreferences
            : chatPreferences // ignore: cast_nullable_to_non_nullable
                  as ChatPreferences?,
        commands: freezed == commands
            ? _self.commands
            : commands // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        countMessages: freezed == countMessages
            ? _self.countMessages
            : countMessages // ignore: cast_nullable_to_non_nullable
                  as bool?,
        grants: freezed == grants
            ? _self.grants
            : grants // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<String>>?,
        maxMessageLength: freezed == maxMessageLength
            ? _self.maxMessageLength
            : maxMessageLength // ignore: cast_nullable_to_non_nullable
                  as int?,
        pushLevel: freezed == pushLevel
            ? _self.pushLevel
            : pushLevel // ignore: cast_nullable_to_non_nullable
                  as ChannelConfigOverridesPushLevel?,
        quotes: freezed == quotes
            ? _self.quotes
            : quotes // ignore: cast_nullable_to_non_nullable
                  as bool?,
        reactions: freezed == reactions
            ? _self.reactions
            : reactions // ignore: cast_nullable_to_non_nullable
                  as bool?,
        replies: freezed == replies
            ? _self.replies
            : replies // ignore: cast_nullable_to_non_nullable
                  as bool?,
        sharedLocations: freezed == sharedLocations
            ? _self.sharedLocations
            : sharedLocations // ignore: cast_nullable_to_non_nullable
                  as bool?,
        typingEvents: freezed == typingEvents
            ? _self.typingEvents
            : typingEvents // ignore: cast_nullable_to_non_nullable
                  as bool?,
        uploads: freezed == uploads
            ? _self.uploads
            : uploads // ignore: cast_nullable_to_non_nullable
                  as bool?,
        urlEnrichment: freezed == urlEnrichment
            ? _self.urlEnrichment
            : urlEnrichment // ignore: cast_nullable_to_non_nullable
                  as bool?,
        userMessageReminders: freezed == userMessageReminders
            ? _self.userMessageReminders
            : userMessageReminders // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
