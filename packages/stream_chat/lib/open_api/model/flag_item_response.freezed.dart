// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flag_item_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlagItemResponse {
  String get duration;
  String get itemId;

  /// Create a copy of FlagItemResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FlagItemResponseCopyWith<FlagItemResponse> get copyWith => _$FlagItemResponseCopyWithImpl<FlagItemResponse>(
    this as FlagItemResponse,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FlagItemResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.itemId, itemId) || other.itemId == itemId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, itemId);

  @override
  String toString() {
    return 'FlagItemResponse(duration: $duration, itemId: $itemId)';
  }
}

/// @nodoc
abstract mixin class $FlagItemResponseCopyWith<$Res> {
  factory $FlagItemResponseCopyWith(
    FlagItemResponse value,
    $Res Function(FlagItemResponse) _then,
  ) = _$FlagItemResponseCopyWithImpl;
  @useResult
  $Res call({String duration, String itemId});
}

/// @nodoc
class _$FlagItemResponseCopyWithImpl<$Res> implements $FlagItemResponseCopyWith<$Res> {
  _$FlagItemResponseCopyWithImpl(this._self, this._then);

  final FlagItemResponse _self;
  final $Res Function(FlagItemResponse) _then;

  /// Create a copy of FlagItemResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? itemId = null}) {
    return _then(
      FlagItemResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        itemId: null == itemId
            ? _self.itemId
            : itemId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
