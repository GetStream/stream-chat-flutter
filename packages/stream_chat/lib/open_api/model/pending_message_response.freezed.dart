// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_message_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PendingMessageResponse {
  ChannelResponse? get channel;
  MessageResponse? get message;
  UserResponse? get user;

  /// Create a copy of PendingMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PendingMessageResponseCopyWith<PendingMessageResponse> get copyWith =>
      _$PendingMessageResponseCopyWithImpl<PendingMessageResponse>(
        this as PendingMessageResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PendingMessageResponse &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, channel, message, user);

  @override
  String toString() {
    return 'PendingMessageResponse(channel: $channel, message: $message, user: $user)';
  }
}

/// @nodoc
abstract mixin class $PendingMessageResponseCopyWith<$Res> {
  factory $PendingMessageResponseCopyWith(
    PendingMessageResponse value,
    $Res Function(PendingMessageResponse) _then,
  ) = _$PendingMessageResponseCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse? channel,
    MessageResponse? message,
    UserResponse? user,
  });
}

/// @nodoc
class _$PendingMessageResponseCopyWithImpl<$Res>
    implements $PendingMessageResponseCopyWith<$Res> {
  _$PendingMessageResponseCopyWithImpl(this._self, this._then);

  final PendingMessageResponse _self;
  final $Res Function(PendingMessageResponse) _then;

  /// Create a copy of PendingMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = freezed,
    Object? message = freezed,
    Object? user = freezed,
  }) {
    return _then(
      PendingMessageResponse(
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse?,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
      ),
    );
  }
}
