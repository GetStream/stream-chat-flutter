// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ban_action_request_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BanActionRequestPayload {
  bool? get banFromFutureChannels;
  bool? get channelBanOnly;
  String? get channelCid;
  BanActionRequestPayloadDeleteMessages? get deleteMessages;
  bool? get ipBan;
  String? get reason;
  bool? get shadow;
  String? get targetUserId;
  int? get timeout;

  /// Create a copy of BanActionRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BanActionRequestPayloadCopyWith<BanActionRequestPayload> get copyWith =>
      _$BanActionRequestPayloadCopyWithImpl<BanActionRequestPayload>(
        this as BanActionRequestPayload,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BanActionRequestPayload &&
            (identical(other.banFromFutureChannels, banFromFutureChannels) ||
                other.banFromFutureChannels == banFromFutureChannels) &&
            (identical(other.channelBanOnly, channelBanOnly) ||
                other.channelBanOnly == channelBanOnly) &&
            (identical(other.channelCid, channelCid) ||
                other.channelCid == channelCid) &&
            (identical(other.deleteMessages, deleteMessages) ||
                other.deleteMessages == deleteMessages) &&
            (identical(other.ipBan, ipBan) || other.ipBan == ipBan) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.shadow, shadow) || other.shadow == shadow) &&
            (identical(other.targetUserId, targetUserId) ||
                other.targetUserId == targetUserId) &&
            (identical(other.timeout, timeout) || other.timeout == timeout));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    banFromFutureChannels,
    channelBanOnly,
    channelCid,
    deleteMessages,
    ipBan,
    reason,
    shadow,
    targetUserId,
    timeout,
  );

  @override
  String toString() {
    return 'BanActionRequestPayload(banFromFutureChannels: $banFromFutureChannels, channelBanOnly: $channelBanOnly, channelCid: $channelCid, deleteMessages: $deleteMessages, ipBan: $ipBan, reason: $reason, shadow: $shadow, targetUserId: $targetUserId, timeout: $timeout)';
  }
}

/// @nodoc
abstract mixin class $BanActionRequestPayloadCopyWith<$Res> {
  factory $BanActionRequestPayloadCopyWith(
    BanActionRequestPayload value,
    $Res Function(BanActionRequestPayload) _then,
  ) = _$BanActionRequestPayloadCopyWithImpl;
  @useResult
  $Res call({
    bool? banFromFutureChannels,
    bool? channelBanOnly,
    String? channelCid,
    BanActionRequestPayloadDeleteMessages? deleteMessages,
    bool? ipBan,
    String? reason,
    bool? shadow,
    String? targetUserId,
    int? timeout,
  });
}

/// @nodoc
class _$BanActionRequestPayloadCopyWithImpl<$Res>
    implements $BanActionRequestPayloadCopyWith<$Res> {
  _$BanActionRequestPayloadCopyWithImpl(this._self, this._then);

  final BanActionRequestPayload _self;
  final $Res Function(BanActionRequestPayload) _then;

  /// Create a copy of BanActionRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? banFromFutureChannels = freezed,
    Object? channelBanOnly = freezed,
    Object? channelCid = freezed,
    Object? deleteMessages = freezed,
    Object? ipBan = freezed,
    Object? reason = freezed,
    Object? shadow = freezed,
    Object? targetUserId = freezed,
    Object? timeout = freezed,
  }) {
    return _then(
      BanActionRequestPayload(
        banFromFutureChannels: freezed == banFromFutureChannels
            ? _self.banFromFutureChannels
            : banFromFutureChannels // ignore: cast_nullable_to_non_nullable
                  as bool?,
        channelBanOnly: freezed == channelBanOnly
            ? _self.channelBanOnly
            : channelBanOnly // ignore: cast_nullable_to_non_nullable
                  as bool?,
        channelCid: freezed == channelCid
            ? _self.channelCid
            : channelCid // ignore: cast_nullable_to_non_nullable
                  as String?,
        deleteMessages: freezed == deleteMessages
            ? _self.deleteMessages
            : deleteMessages // ignore: cast_nullable_to_non_nullable
                  as BanActionRequestPayloadDeleteMessages?,
        ipBan: freezed == ipBan
            ? _self.ipBan
            : ipBan // ignore: cast_nullable_to_non_nullable
                  as bool?,
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        shadow: freezed == shadow
            ? _self.shadow
            : shadow // ignore: cast_nullable_to_non_nullable
                  as bool?,
        targetUserId: freezed == targetUserId
            ? _self.targetUserId
            : targetUserId // ignore: cast_nullable_to_non_nullable
                  as String?,
        timeout: freezed == timeout
            ? _self.timeout
            : timeout // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
