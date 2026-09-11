// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unban_action_request_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnbanActionRequestPayload {
  String? get channelCid;
  String? get decisionReason;
  bool? get removeFutureChannelsBan;
  String? get targetUserId;

  /// Create a copy of UnbanActionRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnbanActionRequestPayloadCopyWith<UnbanActionRequestPayload> get copyWith =>
      _$UnbanActionRequestPayloadCopyWithImpl<UnbanActionRequestPayload>(
        this as UnbanActionRequestPayload,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnbanActionRequestPayload &&
            (identical(other.channelCid, channelCid) || other.channelCid == channelCid) &&
            (identical(other.decisionReason, decisionReason) || other.decisionReason == decisionReason) &&
            (identical(
                  other.removeFutureChannelsBan,
                  removeFutureChannelsBan,
                ) ||
                other.removeFutureChannelsBan == removeFutureChannelsBan) &&
            (identical(other.targetUserId, targetUserId) || other.targetUserId == targetUserId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelCid,
    decisionReason,
    removeFutureChannelsBan,
    targetUserId,
  );

  @override
  String toString() {
    return 'UnbanActionRequestPayload(channelCid: $channelCid, decisionReason: $decisionReason, removeFutureChannelsBan: $removeFutureChannelsBan, targetUserId: $targetUserId)';
  }
}

/// @nodoc
abstract mixin class $UnbanActionRequestPayloadCopyWith<$Res> {
  factory $UnbanActionRequestPayloadCopyWith(
    UnbanActionRequestPayload value,
    $Res Function(UnbanActionRequestPayload) _then,
  ) = _$UnbanActionRequestPayloadCopyWithImpl;
  @useResult
  $Res call({
    String? channelCid,
    String? decisionReason,
    bool? removeFutureChannelsBan,
    String? targetUserId,
  });
}

/// @nodoc
class _$UnbanActionRequestPayloadCopyWithImpl<$Res> implements $UnbanActionRequestPayloadCopyWith<$Res> {
  _$UnbanActionRequestPayloadCopyWithImpl(this._self, this._then);

  final UnbanActionRequestPayload _self;
  final $Res Function(UnbanActionRequestPayload) _then;

  /// Create a copy of UnbanActionRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelCid = freezed,
    Object? decisionReason = freezed,
    Object? removeFutureChannelsBan = freezed,
    Object? targetUserId = freezed,
  }) {
    return _then(
      UnbanActionRequestPayload(
        channelCid: freezed == channelCid
            ? _self.channelCid
            : channelCid // ignore: cast_nullable_to_non_nullable
                  as String?,
        decisionReason: freezed == decisionReason
            ? _self.decisionReason
            : decisionReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        removeFutureChannelsBan: freezed == removeFutureChannelsBan
            ? _self.removeFutureChannelsBan
            : removeFutureChannelsBan // ignore: cast_nullable_to_non_nullable
                  as bool?,
        targetUserId: freezed == targetUserId
            ? _self.targetUserId
            : targetUserId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
