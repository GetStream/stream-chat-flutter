// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelState {
  ChannelModel? get channel;
  List<Message>? get messages;
  List<Member>? get members;
  List<Message>? get pinnedMessages;
  int? get watcherCount;
  List<User>? get watchers;
  List<Read>? get read;
  Member? get membership;
  Draft? get draft;
  List<Message>? get pendingMessages;
  ChannelPushPreference? get pushPreferences;
  List<Location>? get activeLiveLocations;

  /// Create a copy of ChannelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelStateCopyWith<ChannelState> get copyWith =>
      _$ChannelStateCopyWithImpl<ChannelState>(this as ChannelState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelState &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(other.messages, messages) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            const DeepCollectionEquality().equals(other.pinnedMessages, pinnedMessages) &&
            (identical(other.watcherCount, watcherCount) || other.watcherCount == watcherCount) &&
            const DeepCollectionEquality().equals(other.watchers, watchers) &&
            const DeepCollectionEquality().equals(other.read, read) &&
            (identical(other.membership, membership) || other.membership == membership) &&
            (identical(other.draft, draft) || other.draft == draft) &&
            const DeepCollectionEquality().equals(other.pendingMessages, pendingMessages) &&
            (identical(other.pushPreferences, pushPreferences) || other.pushPreferences == pushPreferences) &&
            const DeepCollectionEquality().equals(other.activeLiveLocations, activeLiveLocations));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(messages),
    const DeepCollectionEquality().hash(members),
    const DeepCollectionEquality().hash(pinnedMessages),
    watcherCount,
    const DeepCollectionEquality().hash(watchers),
    const DeepCollectionEquality().hash(read),
    membership,
    draft,
    const DeepCollectionEquality().hash(pendingMessages),
    pushPreferences,
    const DeepCollectionEquality().hash(activeLiveLocations),
  );

  @override
  String toString() {
    return 'ChannelState(channel: $channel, messages: $messages, members: $members, pinnedMessages: $pinnedMessages, watcherCount: $watcherCount, watchers: $watchers, read: $read, membership: $membership, draft: $draft, pendingMessages: $pendingMessages, pushPreferences: $pushPreferences, activeLiveLocations: $activeLiveLocations)';
  }
}

/// @nodoc
abstract mixin class $ChannelStateCopyWith<$Res> {
  factory $ChannelStateCopyWith(ChannelState value, $Res Function(ChannelState) _then) = _$ChannelStateCopyWithImpl;
  @useResult
  $Res call({
    ChannelModel? channel,
    List<Message>? messages,
    List<Member>? members,
    List<Message>? pinnedMessages,
    int? watcherCount,
    List<User>? watchers,
    List<Read>? read,
    Member? membership,
    Draft? draft,
    List<Message>? pendingMessages,
    ChannelPushPreference? pushPreferences,
    List<Location>? activeLiveLocations,
  });
}

/// @nodoc
class _$ChannelStateCopyWithImpl<$Res> implements $ChannelStateCopyWith<$Res> {
  _$ChannelStateCopyWithImpl(this._self, this._then);

  final ChannelState _self;
  final $Res Function(ChannelState) _then;

  /// Create a copy of ChannelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = freezed,
    Object? messages = freezed,
    Object? members = freezed,
    Object? pinnedMessages = freezed,
    Object? watcherCount = freezed,
    Object? watchers = freezed,
    Object? read = freezed,
    Object? membership = freezed,
    Object? draft = freezed,
    Object? pendingMessages = freezed,
    Object? pushPreferences = freezed,
    Object? activeLiveLocations = freezed,
  }) {
    return _then(
      ChannelState(
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelModel?,
        messages: freezed == messages
            ? _self.messages
            : messages // ignore: cast_nullable_to_non_nullable
                  as List<Message>?,
        members: freezed == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<Member>?,
        pinnedMessages: freezed == pinnedMessages
            ? _self.pinnedMessages
            : pinnedMessages // ignore: cast_nullable_to_non_nullable
                  as List<Message>?,
        watcherCount: freezed == watcherCount
            ? _self.watcherCount
            : watcherCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        watchers: freezed == watchers
            ? _self.watchers
            : watchers // ignore: cast_nullable_to_non_nullable
                  as List<User>?,
        read: freezed == read
            ? _self.read
            : read // ignore: cast_nullable_to_non_nullable
                  as List<Read>?,
        membership: freezed == membership
            ? _self.membership
            : membership // ignore: cast_nullable_to_non_nullable
                  as Member?,
        draft: freezed == draft
            ? _self.draft
            : draft // ignore: cast_nullable_to_non_nullable
                  as Draft?,
        pendingMessages: freezed == pendingMessages
            ? _self.pendingMessages
            : pendingMessages // ignore: cast_nullable_to_non_nullable
                  as List<Message>?,
        pushPreferences: freezed == pushPreferences
            ? _self.pushPreferences
            : pushPreferences // ignore: cast_nullable_to_non_nullable
                  as ChannelPushPreference?,
        activeLiveLocations: freezed == activeLiveLocations
            ? _self.activeLiveLocations
            : activeLiveLocations // ignore: cast_nullable_to_non_nullable
                  as List<Location>?,
      ),
    );
  }
}
