// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_channel_mutes_updated_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationChannelMutesUpdatedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  OwnUserResponse get me;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of NotificationChannelMutesUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationChannelMutesUpdatedEventCopyWith<
    NotificationChannelMutesUpdatedEvent
  >
  get copyWith =>
      _$NotificationChannelMutesUpdatedEventCopyWithImpl<
        NotificationChannelMutesUpdatedEvent
      >(this as NotificationChannelMutesUpdatedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationChannelMutesUpdatedEvent &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.me, me) || other.me == me) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    me,
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'NotificationChannelMutesUpdatedEvent(createdAt: $createdAt, custom: $custom, me: $me, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $NotificationChannelMutesUpdatedEventCopyWith<$Res> {
  factory $NotificationChannelMutesUpdatedEventCopyWith(
    NotificationChannelMutesUpdatedEvent value,
    $Res Function(NotificationChannelMutesUpdatedEvent) _then,
  ) = _$NotificationChannelMutesUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    OwnUserResponse me,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$NotificationChannelMutesUpdatedEventCopyWithImpl<$Res>
    implements $NotificationChannelMutesUpdatedEventCopyWith<$Res> {
  _$NotificationChannelMutesUpdatedEventCopyWithImpl(this._self, this._then);

  final NotificationChannelMutesUpdatedEvent _self;
  final $Res Function(NotificationChannelMutesUpdatedEvent) _then;

  /// Create a copy of NotificationChannelMutesUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? me = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      NotificationChannelMutesUpdatedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        me: null == me
            ? _self.me
            : me // ignore: cast_nullable_to_non_nullable
                  as OwnUserResponse,
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
