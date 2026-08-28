// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submit_action_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubmitActionResponse {
  AppealItemResponse? get appealItem;
  String? get autoRestoreWarning;
  String get duration;
  ReviewQueueItemResponse? get item;

  /// Create a copy of SubmitActionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SubmitActionResponseCopyWith<SubmitActionResponse> get copyWith =>
      _$SubmitActionResponseCopyWithImpl<SubmitActionResponse>(
        this as SubmitActionResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SubmitActionResponse &&
            (identical(other.appealItem, appealItem) ||
                other.appealItem == appealItem) &&
            (identical(other.autoRestoreWarning, autoRestoreWarning) ||
                other.autoRestoreWarning == autoRestoreWarning) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.item, item) || other.item == item));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, appealItem, autoRestoreWarning, duration, item);

  @override
  String toString() {
    return 'SubmitActionResponse(appealItem: $appealItem, autoRestoreWarning: $autoRestoreWarning, duration: $duration, item: $item)';
  }
}

/// @nodoc
abstract mixin class $SubmitActionResponseCopyWith<$Res> {
  factory $SubmitActionResponseCopyWith(
    SubmitActionResponse value,
    $Res Function(SubmitActionResponse) _then,
  ) = _$SubmitActionResponseCopyWithImpl;
  @useResult
  $Res call({
    AppealItemResponse? appealItem,
    String? autoRestoreWarning,
    String duration,
    ReviewQueueItemResponse? item,
  });
}

/// @nodoc
class _$SubmitActionResponseCopyWithImpl<$Res>
    implements $SubmitActionResponseCopyWith<$Res> {
  _$SubmitActionResponseCopyWithImpl(this._self, this._then);

  final SubmitActionResponse _self;
  final $Res Function(SubmitActionResponse) _then;

  /// Create a copy of SubmitActionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appealItem = freezed,
    Object? autoRestoreWarning = freezed,
    Object? duration = null,
    Object? item = freezed,
  }) {
    return _then(
      SubmitActionResponse(
        appealItem: freezed == appealItem
            ? _self.appealItem
            : appealItem // ignore: cast_nullable_to_non_nullable
                  as AppealItemResponse?,
        autoRestoreWarning: freezed == autoRestoreWarning
            ? _self.autoRestoreWarning
            : autoRestoreWarning // ignore: cast_nullable_to_non_nullable
                  as String?,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        item: freezed == item
            ? _self.item
            : item // ignore: cast_nullable_to_non_nullable
                  as ReviewQueueItemResponse?,
      ),
    );
  }
}
