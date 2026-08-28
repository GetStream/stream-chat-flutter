// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_appeal_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetAppealResponse {
  String get duration;
  AppealItemResponse? get item;

  /// Create a copy of GetAppealResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GetAppealResponseCopyWith<GetAppealResponse> get copyWith =>
      _$GetAppealResponseCopyWithImpl<GetAppealResponse>(
        this as GetAppealResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GetAppealResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.item, item) || other.item == item));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, item);

  @override
  String toString() {
    return 'GetAppealResponse(duration: $duration, item: $item)';
  }
}

/// @nodoc
abstract mixin class $GetAppealResponseCopyWith<$Res> {
  factory $GetAppealResponseCopyWith(
    GetAppealResponse value,
    $Res Function(GetAppealResponse) _then,
  ) = _$GetAppealResponseCopyWithImpl;
  @useResult
  $Res call({String duration, AppealItemResponse? item});
}

/// @nodoc
class _$GetAppealResponseCopyWithImpl<$Res>
    implements $GetAppealResponseCopyWith<$Res> {
  _$GetAppealResponseCopyWithImpl(this._self, this._then);

  final GetAppealResponse _self;
  final $Res Function(GetAppealResponse) _then;

  /// Create a copy of GetAppealResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? item = freezed}) {
    return _then(
      GetAppealResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        item: freezed == item
            ? _self.item
            : item // ignore: cast_nullable_to_non_nullable
                  as AppealItemResponse?,
      ),
    );
  }
}
