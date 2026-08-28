// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thread_participant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ThreadParticipant {
  String get channelCid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime get lastReadAt;
  DateTime? get lastThreadMessageAt;
  DateTime? get leftThreadAt;
  String? get threadId;
  UserResponse? get user;
  String? get userId;

  /// Create a copy of ThreadParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ThreadParticipantCopyWith<ThreadParticipant> get copyWith =>
      _$ThreadParticipantCopyWithImpl<ThreadParticipant>(
        this as ThreadParticipant,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ThreadParticipant &&
            (identical(other.channelCid, channelCid) ||
                other.channelCid == channelCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.lastReadAt, lastReadAt) ||
                other.lastReadAt == lastReadAt) &&
            (identical(other.lastThreadMessageAt, lastThreadMessageAt) ||
                other.lastThreadMessageAt == lastThreadMessageAt) &&
            (identical(other.leftThreadAt, leftThreadAt) ||
                other.leftThreadAt == leftThreadAt) &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelCid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    lastReadAt,
    lastThreadMessageAt,
    leftThreadAt,
    threadId,
    user,
    userId,
  );

  @override
  String toString() {
    return 'ThreadParticipant(channelCid: $channelCid, createdAt: $createdAt, custom: $custom, lastReadAt: $lastReadAt, lastThreadMessageAt: $lastThreadMessageAt, leftThreadAt: $leftThreadAt, threadId: $threadId, user: $user, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $ThreadParticipantCopyWith<$Res> {
  factory $ThreadParticipantCopyWith(
    ThreadParticipant value,
    $Res Function(ThreadParticipant) _then,
  ) = _$ThreadParticipantCopyWithImpl;
  @useResult
  $Res call({
    String channelCid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime lastReadAt,
    DateTime? lastThreadMessageAt,
    DateTime? leftThreadAt,
    String? threadId,
    UserResponse? user,
    String? userId,
  });
}

/// @nodoc
class _$ThreadParticipantCopyWithImpl<$Res>
    implements $ThreadParticipantCopyWith<$Res> {
  _$ThreadParticipantCopyWithImpl(this._self, this._then);

  final ThreadParticipant _self;
  final $Res Function(ThreadParticipant) _then;

  /// Create a copy of ThreadParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelCid = null,
    Object? createdAt = null,
    Object? custom = null,
    Object? lastReadAt = null,
    Object? lastThreadMessageAt = freezed,
    Object? leftThreadAt = freezed,
    Object? threadId = freezed,
    Object? user = freezed,
    Object? userId = freezed,
  }) {
    return _then(
      ThreadParticipant(
        channelCid: null == channelCid
            ? _self.channelCid
            : channelCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        lastReadAt: null == lastReadAt
            ? _self.lastReadAt
            : lastReadAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastThreadMessageAt: freezed == lastThreadMessageAt
            ? _self.lastThreadMessageAt
            : lastThreadMessageAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        leftThreadAt: freezed == leftThreadAt
            ? _self.leftThreadAt
            : leftThreadAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        threadId: freezed == threadId
            ? _self.threadId
            : threadId // ignore: cast_nullable_to_non_nullable
                  as String?,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
        userId: freezed == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
