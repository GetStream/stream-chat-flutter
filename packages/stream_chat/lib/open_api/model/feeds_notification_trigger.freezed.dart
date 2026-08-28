// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feeds_notification_trigger.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedsNotificationTrigger {
  FeedsNotificationComment? get comment;
  Map<String, Object?>? get custom;
  String get text;
  String get type;

  /// Create a copy of FeedsNotificationTrigger
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedsNotificationTriggerCopyWith<FeedsNotificationTrigger> get copyWith =>
      _$FeedsNotificationTriggerCopyWithImpl<FeedsNotificationTrigger>(
        this as FeedsNotificationTrigger,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedsNotificationTrigger &&
            (identical(other.comment, comment) || other.comment == comment) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    comment,
    const DeepCollectionEquality().hash(custom),
    text,
    type,
  );

  @override
  String toString() {
    return 'FeedsNotificationTrigger(comment: $comment, custom: $custom, text: $text, type: $type)';
  }
}

/// @nodoc
abstract mixin class $FeedsNotificationTriggerCopyWith<$Res> {
  factory $FeedsNotificationTriggerCopyWith(
    FeedsNotificationTrigger value,
    $Res Function(FeedsNotificationTrigger) _then,
  ) = _$FeedsNotificationTriggerCopyWithImpl;
  @useResult
  $Res call({
    FeedsNotificationComment? comment,
    Map<String, Object?>? custom,
    String text,
    String type,
  });
}

/// @nodoc
class _$FeedsNotificationTriggerCopyWithImpl<$Res>
    implements $FeedsNotificationTriggerCopyWith<$Res> {
  _$FeedsNotificationTriggerCopyWithImpl(this._self, this._then);

  final FeedsNotificationTrigger _self;
  final $Res Function(FeedsNotificationTrigger) _then;

  /// Create a copy of FeedsNotificationTrigger
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comment = freezed,
    Object? custom = freezed,
    Object? text = null,
    Object? type = null,
  }) {
    return _then(
      FeedsNotificationTrigger(
        comment: freezed == comment
            ? _self.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as FeedsNotificationComment?,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        text: null == text
            ? _self.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
