// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unmute_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnmuteResponse {
  String get duration;
  List<String>? get nonExistingUsers;

  /// Create a copy of UnmuteResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnmuteResponseCopyWith<UnmuteResponse> get copyWith => _$UnmuteResponseCopyWithImpl<UnmuteResponse>(
    this as UnmuteResponse,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnmuteResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            const DeepCollectionEquality().equals(
              other.nonExistingUsers,
              nonExistingUsers,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(nonExistingUsers),
  );

  @override
  String toString() {
    return 'UnmuteResponse(duration: $duration, nonExistingUsers: $nonExistingUsers)';
  }
}

/// @nodoc
abstract mixin class $UnmuteResponseCopyWith<$Res> {
  factory $UnmuteResponseCopyWith(
    UnmuteResponse value,
    $Res Function(UnmuteResponse) _then,
  ) = _$UnmuteResponseCopyWithImpl;
  @useResult
  $Res call({String duration, List<String>? nonExistingUsers});
}

/// @nodoc
class _$UnmuteResponseCopyWithImpl<$Res> implements $UnmuteResponseCopyWith<$Res> {
  _$UnmuteResponseCopyWithImpl(this._self, this._then);

  final UnmuteResponse _self;
  final $Res Function(UnmuteResponse) _then;

  /// Create a copy of UnmuteResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? nonExistingUsers = freezed}) {
    return _then(
      UnmuteResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        nonExistingUsers: freezed == nonExistingUsers
            ? _self.nonExistingUsers
            : nonExistingUsers // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}
