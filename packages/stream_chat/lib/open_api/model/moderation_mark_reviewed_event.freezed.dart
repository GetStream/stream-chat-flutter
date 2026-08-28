// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moderation_mark_reviewed_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ModerationMarkReviewedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  ReviewQueueItemResponse get item;
  MessageResponse? get message;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of ModerationMarkReviewedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModerationMarkReviewedEventCopyWith<ModerationMarkReviewedEvent>
  get copyWith =>
      _$ModerationMarkReviewedEventCopyWithImpl<ModerationMarkReviewedEvent>(
        this as ModerationMarkReviewedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ModerationMarkReviewedEvent &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.item, item) || other.item == item) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    item,
    message,
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'ModerationMarkReviewedEvent(createdAt: $createdAt, custom: $custom, item: $item, message: $message, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ModerationMarkReviewedEventCopyWith<$Res> {
  factory $ModerationMarkReviewedEventCopyWith(
    ModerationMarkReviewedEvent value,
    $Res Function(ModerationMarkReviewedEvent) _then,
  ) = _$ModerationMarkReviewedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    ReviewQueueItemResponse item,
    MessageResponse? message,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$ModerationMarkReviewedEventCopyWithImpl<$Res>
    implements $ModerationMarkReviewedEventCopyWith<$Res> {
  _$ModerationMarkReviewedEventCopyWithImpl(this._self, this._then);

  final ModerationMarkReviewedEvent _self;
  final $Res Function(ModerationMarkReviewedEvent) _then;

  /// Create a copy of ModerationMarkReviewedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? item = null,
    Object? message = freezed,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      ModerationMarkReviewedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        item: null == item
            ? _self.item
            : item // ignore: cast_nullable_to_non_nullable
                  as ReviewQueueItemResponse,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
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
