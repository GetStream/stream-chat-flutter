// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduled_message_deleted_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduledMessageDeletedEvent {
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  ScheduledMessageResponse? get scheduledMessage;
  String get type;
  UserResponseCommonFields get user;

  /// Create a copy of ScheduledMessageDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduledMessageDeletedEventCopyWith<ScheduledMessageDeletedEvent> get copyWith =>
      _$ScheduledMessageDeletedEventCopyWithImpl<ScheduledMessageDeletedEvent>(
        this as ScheduledMessageDeletedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScheduledMessageDeletedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.scheduledMessage, scheduledMessage) || other.scheduledMessage == scheduledMessage) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    scheduledMessage,
    type,
    user,
  );

  @override
  String toString() {
    return 'ScheduledMessageDeletedEvent(cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, scheduledMessage: $scheduledMessage, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $ScheduledMessageDeletedEventCopyWith<$Res> {
  factory $ScheduledMessageDeletedEventCopyWith(
    ScheduledMessageDeletedEvent value,
    $Res Function(ScheduledMessageDeletedEvent) _then,
  ) = _$ScheduledMessageDeletedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    ScheduledMessageResponse? scheduledMessage,
    String type,
    UserResponseCommonFields user,
  });
}

/// @nodoc
class _$ScheduledMessageDeletedEventCopyWithImpl<$Res> implements $ScheduledMessageDeletedEventCopyWith<$Res> {
  _$ScheduledMessageDeletedEventCopyWithImpl(this._self, this._then);

  final ScheduledMessageDeletedEvent _self;
  final $Res Function(ScheduledMessageDeletedEvent) _then;

  /// Create a copy of ScheduledMessageDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? scheduledMessage = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      ScheduledMessageDeletedEvent(
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
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        scheduledMessage: freezed == scheduledMessage
            ? _self.scheduledMessage
            : scheduledMessage // ignore: cast_nullable_to_non_nullable
                  as ScheduledMessageResponse?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields,
      ),
    );
  }
}
