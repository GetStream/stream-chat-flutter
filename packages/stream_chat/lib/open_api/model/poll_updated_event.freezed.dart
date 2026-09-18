// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll_updated_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PollUpdatedEvent {
  String? get activityId;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String? get messageId;
  PollResponseData get poll;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of PollUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollUpdatedEventCopyWith<PollUpdatedEvent> get copyWith => _$PollUpdatedEventCopyWithImpl<PollUpdatedEvent>(
    this as PollUpdatedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollUpdatedEvent &&
            (identical(other.activityId, activityId) || other.activityId == activityId) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.poll, poll) || other.poll == poll) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    activityId,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    messageId,
    poll,
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'PollUpdatedEvent(activityId: $activityId, cid: $cid, createdAt: $createdAt, custom: $custom, messageId: $messageId, poll: $poll, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $PollUpdatedEventCopyWith<$Res> {
  factory $PollUpdatedEventCopyWith(
    PollUpdatedEvent value,
    $Res Function(PollUpdatedEvent) _then,
  ) = _$PollUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    String? activityId,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    String? messageId,
    PollResponseData poll,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$PollUpdatedEventCopyWithImpl<$Res> implements $PollUpdatedEventCopyWith<$Res> {
  _$PollUpdatedEventCopyWithImpl(this._self, this._then);

  final PollUpdatedEvent _self;
  final $Res Function(PollUpdatedEvent) _then;

  /// Create a copy of PollUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? messageId = freezed,
    Object? poll = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      PollUpdatedEvent(
        activityId: freezed == activityId
            ? _self.activityId
            : activityId // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        poll: null == poll
            ? _self.poll
            : poll // ignore: cast_nullable_to_non_nullable
                  as PollResponseData,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
