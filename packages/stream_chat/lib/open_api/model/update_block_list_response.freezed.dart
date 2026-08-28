// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_block_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateBlockListResponse {
  BlockListResponse? get blocklist;
  String get duration;

  /// Create a copy of UpdateBlockListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateBlockListResponseCopyWith<UpdateBlockListResponse> get copyWith =>
      _$UpdateBlockListResponseCopyWithImpl<UpdateBlockListResponse>(
        this as UpdateBlockListResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateBlockListResponse &&
            (identical(other.blocklist, blocklist) ||
                other.blocklist == blocklist) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, blocklist, duration);

  @override
  String toString() {
    return 'UpdateBlockListResponse(blocklist: $blocklist, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $UpdateBlockListResponseCopyWith<$Res> {
  factory $UpdateBlockListResponseCopyWith(
    UpdateBlockListResponse value,
    $Res Function(UpdateBlockListResponse) _then,
  ) = _$UpdateBlockListResponseCopyWithImpl;
  @useResult
  $Res call({BlockListResponse? blocklist, String duration});
}

/// @nodoc
class _$UpdateBlockListResponseCopyWithImpl<$Res>
    implements $UpdateBlockListResponseCopyWith<$Res> {
  _$UpdateBlockListResponseCopyWithImpl(this._self, this._then);

  final UpdateBlockListResponse _self;
  final $Res Function(UpdateBlockListResponse) _then;

  /// Create a copy of UpdateBlockListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? blocklist = freezed, Object? duration = null}) {
    return _then(
      UpdateBlockListResponse(
        blocklist: freezed == blocklist
            ? _self.blocklist
            : blocklist // ignore: cast_nullable_to_non_nullable
                  as BlockListResponse?,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
