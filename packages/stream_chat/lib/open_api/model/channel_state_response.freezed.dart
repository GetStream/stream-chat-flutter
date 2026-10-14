// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_state_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelStateResponse {
  List<SharedLocationResponseData>? get activeLiveLocations;
  ChannelResponse? get channel;
  DraftResponse? get draft;
  String get duration;
  bool? get hidden;
  DateTime? get hideMessagesBefore;
  List<ChannelMemberResponse> get members;
  ChannelMemberResponse? get membership;
  List<MessageResponse> get messages;
  List<PendingMessageResponse>? get pendingMessages;
  List<MessageResponse> get pinnedMessages;
  ChannelPushPreferencesResponse? get pushPreferences;
  List<ReadStateResponse>? get read;
  List<ThreadStateResponse> get threads;
  int? get watcherCount;
  List<UserResponse>? get watchers;

  /// Create a copy of ChannelStateResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelStateResponseCopyWith<ChannelStateResponse> get copyWith =>
      _$ChannelStateResponseCopyWithImpl<ChannelStateResponse>(
        this as ChannelStateResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelStateResponse &&
            const DeepCollectionEquality().equals(
              other.activeLiveLocations,
              activeLiveLocations,
            ) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.draft, draft) || other.draft == draft) &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            (identical(other.hideMessagesBefore, hideMessagesBefore) ||
                other.hideMessagesBefore == hideMessagesBefore) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.membership, membership) || other.membership == membership) &&
            const DeepCollectionEquality().equals(other.messages, messages) &&
            const DeepCollectionEquality().equals(
              other.pendingMessages,
              pendingMessages,
            ) &&
            const DeepCollectionEquality().equals(
              other.pinnedMessages,
              pinnedMessages,
            ) &&
            (identical(other.pushPreferences, pushPreferences) || other.pushPreferences == pushPreferences) &&
            const DeepCollectionEquality().equals(other.read, read) &&
            const DeepCollectionEquality().equals(other.threads, threads) &&
            (identical(other.watcherCount, watcherCount) || other.watcherCount == watcherCount) &&
            const DeepCollectionEquality().equals(other.watchers, watchers));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(activeLiveLocations),
    channel,
    draft,
    duration,
    hidden,
    hideMessagesBefore,
    const DeepCollectionEquality().hash(members),
    membership,
    const DeepCollectionEquality().hash(messages),
    const DeepCollectionEquality().hash(pendingMessages),
    const DeepCollectionEquality().hash(pinnedMessages),
    pushPreferences,
    const DeepCollectionEquality().hash(read),
    const DeepCollectionEquality().hash(threads),
    watcherCount,
    const DeepCollectionEquality().hash(watchers),
  );

  @override
  String toString() {
    return 'ChannelStateResponse(activeLiveLocations: $activeLiveLocations, channel: $channel, draft: $draft, duration: $duration, hidden: $hidden, hideMessagesBefore: $hideMessagesBefore, members: $members, membership: $membership, messages: $messages, pendingMessages: $pendingMessages, pinnedMessages: $pinnedMessages, pushPreferences: $pushPreferences, read: $read, threads: $threads, watcherCount: $watcherCount, watchers: $watchers)';
  }
}

/// @nodoc
abstract mixin class $ChannelStateResponseCopyWith<$Res> {
  factory $ChannelStateResponseCopyWith(
    ChannelStateResponse value,
    $Res Function(ChannelStateResponse) _then,
  ) = _$ChannelStateResponseCopyWithImpl;
  @useResult
  $Res call({
    List<SharedLocationResponseData>? activeLiveLocations,
    ChannelResponse? channel,
    DraftResponse? draft,
    String duration,
    bool? hidden,
    DateTime? hideMessagesBefore,
    List<ChannelMemberResponse> members,
    ChannelMemberResponse? membership,
    List<MessageResponse> messages,
    List<PendingMessageResponse>? pendingMessages,
    List<MessageResponse> pinnedMessages,
    ChannelPushPreferencesResponse? pushPreferences,
    List<ReadStateResponse>? read,
    List<ThreadStateResponse> threads,
    int? watcherCount,
    List<UserResponse>? watchers,
  });
}

/// @nodoc
class _$ChannelStateResponseCopyWithImpl<$Res> implements $ChannelStateResponseCopyWith<$Res> {
  _$ChannelStateResponseCopyWithImpl(this._self, this._then);

  final ChannelStateResponse _self;
  final $Res Function(ChannelStateResponse) _then;

  /// Create a copy of ChannelStateResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeLiveLocations = freezed,
    Object? channel = freezed,
    Object? draft = freezed,
    Object? duration = null,
    Object? hidden = freezed,
    Object? hideMessagesBefore = freezed,
    Object? members = null,
    Object? membership = freezed,
    Object? messages = null,
    Object? pendingMessages = freezed,
    Object? pinnedMessages = null,
    Object? pushPreferences = freezed,
    Object? read = freezed,
    Object? threads = null,
    Object? watcherCount = freezed,
    Object? watchers = freezed,
  }) {
    return _then(
      ChannelStateResponse(
        activeLiveLocations: freezed == activeLiveLocations
            ? _self.activeLiveLocations
            : activeLiveLocations // ignore: cast_nullable_to_non_nullable
                  as List<SharedLocationResponseData>?,
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse?,
        draft: freezed == draft
            ? _self.draft
            : draft // ignore: cast_nullable_to_non_nullable
                  as DraftResponse?,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        hidden: freezed == hidden
            ? _self.hidden
            : hidden // ignore: cast_nullable_to_non_nullable
                  as bool?,
        hideMessagesBefore: freezed == hideMessagesBefore
            ? _self.hideMessagesBefore
            : hideMessagesBefore // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        members: null == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<ChannelMemberResponse>,
        membership: freezed == membership
            ? _self.membership
            : membership // ignore: cast_nullable_to_non_nullable
                  as ChannelMemberResponse?,
        messages: null == messages
            ? _self.messages
            : messages // ignore: cast_nullable_to_non_nullable
                  as List<MessageResponse>,
        pendingMessages: freezed == pendingMessages
            ? _self.pendingMessages
            : pendingMessages // ignore: cast_nullable_to_non_nullable
                  as List<PendingMessageResponse>?,
        pinnedMessages: null == pinnedMessages
            ? _self.pinnedMessages
            : pinnedMessages // ignore: cast_nullable_to_non_nullable
                  as List<MessageResponse>,
        pushPreferences: freezed == pushPreferences
            ? _self.pushPreferences
            : pushPreferences // ignore: cast_nullable_to_non_nullable
                  as ChannelPushPreferencesResponse?,
        read: freezed == read
            ? _self.read
            : read // ignore: cast_nullable_to_non_nullable
                  as List<ReadStateResponse>?,
        threads: null == threads
            ? _self.threads
            : threads // ignore: cast_nullable_to_non_nullable
                  as List<ThreadStateResponse>,
        watcherCount: freezed == watcherCount
            ? _self.watcherCount
            : watcherCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        watchers: freezed == watchers
            ? _self.watchers
            : watchers // ignore: cast_nullable_to_non_nullable
                  as List<UserResponse>?,
      ),
    );
  }
}
