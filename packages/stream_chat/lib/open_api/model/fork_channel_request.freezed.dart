// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fork_channel_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ForkChannelRequest {
  ForkChannelTarget get channel;
  bool? get excludeAttachments;
  String get messageId;

  /// Create a copy of ForkChannelRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ForkChannelRequestCopyWith<ForkChannelRequest> get copyWith => _$ForkChannelRequestCopyWithImpl<ForkChannelRequest>(
    this as ForkChannelRequest,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ForkChannelRequest &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.excludeAttachments, excludeAttachments) ||
                other.excludeAttachments == excludeAttachments) &&
            (identical(other.messageId, messageId) || other.messageId == messageId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, channel, excludeAttachments, messageId);

  @override
  String toString() {
    return 'ForkChannelRequest(channel: $channel, excludeAttachments: $excludeAttachments, messageId: $messageId)';
  }
}

/// @nodoc
abstract mixin class $ForkChannelRequestCopyWith<$Res> {
  factory $ForkChannelRequestCopyWith(
    ForkChannelRequest value,
    $Res Function(ForkChannelRequest) _then,
  ) = _$ForkChannelRequestCopyWithImpl;
  @useResult
  $Res call({
    ForkChannelTarget channel,
    bool? excludeAttachments,
    String messageId,
  });
}

/// @nodoc
class _$ForkChannelRequestCopyWithImpl<$Res> implements $ForkChannelRequestCopyWith<$Res> {
  _$ForkChannelRequestCopyWithImpl(this._self, this._then);

  final ForkChannelRequest _self;
  final $Res Function(ForkChannelRequest) _then;

  /// Create a copy of ForkChannelRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? excludeAttachments = freezed,
    Object? messageId = null,
  }) {
    return _then(
      ForkChannelRequest(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ForkChannelTarget,
        excludeAttachments: freezed == excludeAttachments
            ? _self.excludeAttachments
            : excludeAttachments // ignore: cast_nullable_to_non_nullable
                  as bool?,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
