// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ban_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BanRequest {
  UserRequest? get bannedBy;
  String? get bannedById;
  String? get channelCid;
  BanRequestDeleteMessages? get deleteMessages;
  bool? get ipBan;
  String? get reason;
  bool? get shadow;
  String get targetUserId;
  int? get timeout;

  /// Create a copy of BanRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BanRequestCopyWith<BanRequest> get copyWith =>
      _$BanRequestCopyWithImpl<BanRequest>(this as BanRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BanRequest &&
            (identical(other.bannedBy, bannedBy) ||
                other.bannedBy == bannedBy) &&
            (identical(other.bannedById, bannedById) ||
                other.bannedById == bannedById) &&
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
    bannedBy,
    bannedById,
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
    return 'BanRequest(bannedBy: $bannedBy, bannedById: $bannedById, channelCid: $channelCid, deleteMessages: $deleteMessages, ipBan: $ipBan, reason: $reason, shadow: $shadow, targetUserId: $targetUserId, timeout: $timeout)';
  }
}

/// @nodoc
abstract mixin class $BanRequestCopyWith<$Res> {
  factory $BanRequestCopyWith(
    BanRequest value,
    $Res Function(BanRequest) _then,
  ) = _$BanRequestCopyWithImpl;
  @useResult
  $Res call({
    UserRequest? bannedBy,
    String? bannedById,
    String? channelCid,
    BanRequestDeleteMessages? deleteMessages,
    bool? ipBan,
    String? reason,
    bool? shadow,
    String targetUserId,
    int? timeout,
  });
}

/// @nodoc
class _$BanRequestCopyWithImpl<$Res> implements $BanRequestCopyWith<$Res> {
  _$BanRequestCopyWithImpl(this._self, this._then);

  final BanRequest _self;
  final $Res Function(BanRequest) _then;

  /// Create a copy of BanRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bannedBy = freezed,
    Object? bannedById = freezed,
    Object? channelCid = freezed,
    Object? deleteMessages = freezed,
    Object? ipBan = freezed,
    Object? reason = freezed,
    Object? shadow = freezed,
    Object? targetUserId = null,
    Object? timeout = freezed,
  }) {
    return _then(
      BanRequest(
        bannedBy: freezed == bannedBy
            ? _self.bannedBy
            : bannedBy // ignore: cast_nullable_to_non_nullable
                  as UserRequest?,
        bannedById: freezed == bannedById
            ? _self.bannedById
            : bannedById // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelCid: freezed == channelCid
            ? _self.channelCid
            : channelCid // ignore: cast_nullable_to_non_nullable
                  as String?,
        deleteMessages: freezed == deleteMessages
            ? _self.deleteMessages
            : deleteMessages // ignore: cast_nullable_to_non_nullable
                  as BanRequestDeleteMessages?,
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
        targetUserId: null == targetUserId
            ? _self.targetUserId
            : targetUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        timeout: freezed == timeout
            ? _self.timeout
            : timeout // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
