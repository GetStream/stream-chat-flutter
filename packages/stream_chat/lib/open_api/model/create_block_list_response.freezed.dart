// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_block_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateBlockListResponse {
  BlockListResponse? get blocklist;
  String get duration;

  /// Create a copy of CreateBlockListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateBlockListResponseCopyWith<CreateBlockListResponse> get copyWith =>
      _$CreateBlockListResponseCopyWithImpl<CreateBlockListResponse>(
        this as CreateBlockListResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateBlockListResponse &&
            (identical(other.blocklist, blocklist) ||
                other.blocklist == blocklist) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, blocklist, duration);

  @override
  String toString() {
    return 'CreateBlockListResponse(blocklist: $blocklist, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $CreateBlockListResponseCopyWith<$Res> {
  factory $CreateBlockListResponseCopyWith(
    CreateBlockListResponse value,
    $Res Function(CreateBlockListResponse) _then,
  ) = _$CreateBlockListResponseCopyWithImpl;
  @useResult
  $Res call({BlockListResponse? blocklist, String duration});
}

/// @nodoc
class _$CreateBlockListResponseCopyWithImpl<$Res>
    implements $CreateBlockListResponseCopyWith<$Res> {
  _$CreateBlockListResponseCopyWithImpl(this._self, this._then);

  final CreateBlockListResponse _self;
  final $Res Function(CreateBlockListResponse) _then;

  /// Create a copy of CreateBlockListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? blocklist = freezed, Object? duration = null}) {
    return _then(
      CreateBlockListResponse(
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
