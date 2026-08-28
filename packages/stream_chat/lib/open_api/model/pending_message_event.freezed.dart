// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_message_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PendingMessageEvent {
  ChannelResponse? get channel;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  MessageResponse? get message;
  Map<String, String>? get metadata;
  String get method;
  DateTime? get receivedAt;
  String get type;
  UserResponse? get user;

  /// Create a copy of PendingMessageEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PendingMessageEventCopyWith<PendingMessageEvent> get copyWith =>
      _$PendingMessageEventCopyWithImpl<PendingMessageEvent>(
        this as PendingMessageEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PendingMessageEvent &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.metadata, metadata) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    message,
    const DeepCollectionEquality().hash(metadata),
    method,
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'PendingMessageEvent(channel: $channel, createdAt: $createdAt, custom: $custom, message: $message, metadata: $metadata, method: $method, receivedAt: $receivedAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $PendingMessageEventCopyWith<$Res> {
  factory $PendingMessageEventCopyWith(
    PendingMessageEvent value,
    $Res Function(PendingMessageEvent) _then,
  ) = _$PendingMessageEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse? channel,
    DateTime createdAt,
    Map<String, Object?> custom,
    MessageResponse? message,
    Map<String, String>? metadata,
    String method,
    DateTime? receivedAt,
    String type,
    UserResponse? user,
  });
}

/// @nodoc
class _$PendingMessageEventCopyWithImpl<$Res>
    implements $PendingMessageEventCopyWith<$Res> {
  _$PendingMessageEventCopyWithImpl(this._self, this._then);

  final PendingMessageEvent _self;
  final $Res Function(PendingMessageEvent) _then;

  /// Create a copy of PendingMessageEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? message = freezed,
    Object? metadata = freezed,
    Object? method = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      PendingMessageEvent(
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
        metadata: freezed == metadata
            ? _self.metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        method: null == method
            ? _self.method
            : method // ignore: cast_nullable_to_non_nullable
                  as String,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
      ),
    );
  }
}
