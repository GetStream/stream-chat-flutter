// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moderation_custom_action_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ModerationCustomActionEvent {
  String get actionId;
  Map<String, Object?>? get actionOptions;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  MessageResponse? get message;
  DateTime? get receivedAt;
  ReviewQueueItemResponse get reviewQueueItem;
  String get type;

  /// Create a copy of ModerationCustomActionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModerationCustomActionEventCopyWith<ModerationCustomActionEvent>
  get copyWith =>
      _$ModerationCustomActionEventCopyWithImpl<ModerationCustomActionEvent>(
        this as ModerationCustomActionEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ModerationCustomActionEvent &&
            (identical(other.actionId, actionId) ||
                other.actionId == actionId) &&
            const DeepCollectionEquality().equals(
              other.actionOptions,
              actionOptions,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.reviewQueueItem, reviewQueueItem) ||
                other.reviewQueueItem == reviewQueueItem) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    actionId,
    const DeepCollectionEquality().hash(actionOptions),
    createdAt,
    const DeepCollectionEquality().hash(custom),
    message,
    receivedAt,
    reviewQueueItem,
    type,
  );

  @override
  String toString() {
    return 'ModerationCustomActionEvent(actionId: $actionId, actionOptions: $actionOptions, createdAt: $createdAt, custom: $custom, message: $message, receivedAt: $receivedAt, reviewQueueItem: $reviewQueueItem, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ModerationCustomActionEventCopyWith<$Res> {
  factory $ModerationCustomActionEventCopyWith(
    ModerationCustomActionEvent value,
    $Res Function(ModerationCustomActionEvent) _then,
  ) = _$ModerationCustomActionEventCopyWithImpl;
  @useResult
  $Res call({
    String actionId,
    Map<String, Object?>? actionOptions,
    DateTime createdAt,
    Map<String, Object?> custom,
    MessageResponse? message,
    DateTime? receivedAt,
    ReviewQueueItemResponse reviewQueueItem,
    String type,
  });
}

/// @nodoc
class _$ModerationCustomActionEventCopyWithImpl<$Res>
    implements $ModerationCustomActionEventCopyWith<$Res> {
  _$ModerationCustomActionEventCopyWithImpl(this._self, this._then);

  final ModerationCustomActionEvent _self;
  final $Res Function(ModerationCustomActionEvent) _then;

  /// Create a copy of ModerationCustomActionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actionId = null,
    Object? actionOptions = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? message = freezed,
    Object? receivedAt = freezed,
    Object? reviewQueueItem = null,
    Object? type = null,
  }) {
    return _then(
      ModerationCustomActionEvent(
        actionId: null == actionId
            ? _self.actionId
            : actionId // ignore: cast_nullable_to_non_nullable
                  as String,
        actionOptions: freezed == actionOptions
            ? _self.actionOptions
            : actionOptions // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reviewQueueItem: null == reviewQueueItem
            ? _self.reviewQueueItem
            : reviewQueueItem // ignore: cast_nullable_to_non_nullable
                  as ReviewQueueItemResponse,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
