// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'max_streak_changed_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MaxStreakChangedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of MaxStreakChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MaxStreakChangedEventCopyWith<MaxStreakChangedEvent> get copyWith =>
      _$MaxStreakChangedEventCopyWithImpl<MaxStreakChangedEvent>(
        this as MaxStreakChangedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MaxStreakChangedEvent &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'MaxStreakChangedEvent(createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $MaxStreakChangedEventCopyWith<$Res> {
  factory $MaxStreakChangedEventCopyWith(
    MaxStreakChangedEvent value,
    $Res Function(MaxStreakChangedEvent) _then,
  ) = _$MaxStreakChangedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$MaxStreakChangedEventCopyWithImpl<$Res> implements $MaxStreakChangedEventCopyWith<$Res> {
  _$MaxStreakChangedEventCopyWithImpl(this._self, this._then);

  final MaxStreakChangedEvent _self;
  final $Res Function(MaxStreakChangedEvent) _then;

  /// Create a copy of MaxStreakChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      MaxStreakChangedEvent(
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
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
