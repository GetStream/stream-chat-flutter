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
  DateTime get lastReadAt;
  DateTime? get lastThreadMessageAt;
  DateTime? get leftThreadAt;
  String? get threadId;
  String? get userId;
  User? get user;

  /// Create a copy of ThreadParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ThreadParticipantCopyWith<ThreadParticipant> get copyWith => _$ThreadParticipantCopyWithImpl<ThreadParticipant>(
    this as ThreadParticipant,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ThreadParticipant &&
            (identical(other.channelCid, channelCid) || other.channelCid == channelCid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.lastReadAt, lastReadAt) || other.lastReadAt == lastReadAt) &&
            (identical(other.lastThreadMessageAt, lastThreadMessageAt) ||
                other.lastThreadMessageAt == lastThreadMessageAt) &&
            (identical(other.leftThreadAt, leftThreadAt) || other.leftThreadAt == leftThreadAt) &&
            (identical(other.threadId, threadId) || other.threadId == threadId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelCid,
    createdAt,
    lastReadAt,
    lastThreadMessageAt,
    leftThreadAt,
    threadId,
    userId,
    user,
  );

  @override
  String toString() {
    return 'ThreadParticipant(channelCid: $channelCid, createdAt: $createdAt, lastReadAt: $lastReadAt, lastThreadMessageAt: $lastThreadMessageAt, leftThreadAt: $leftThreadAt, threadId: $threadId, userId: $userId, user: $user)';
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
    DateTime lastReadAt,
    DateTime? lastThreadMessageAt,
    DateTime? leftThreadAt,
    String? threadId,
    String? userId,
    User? user,
  });
}

/// @nodoc
class _$ThreadParticipantCopyWithImpl<$Res> implements $ThreadParticipantCopyWith<$Res> {
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
    Object? lastReadAt = null,
    Object? lastThreadMessageAt = freezed,
    Object? leftThreadAt = freezed,
    Object? threadId = freezed,
    Object? userId = freezed,
    Object? user = freezed,
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
        userId: freezed == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
      ),
    );
  }
}
