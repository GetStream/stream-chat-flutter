// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_identical_image_count_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserIdenticalImageCountParameters {
  String? get match;
  int? get similarityDistance;
  int? get threshold;
  String? get timeWindow;

  /// Create a copy of UserIdenticalImageCountParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserIdenticalImageCountParametersCopyWith<UserIdenticalImageCountParameters> get copyWith =>
      _$UserIdenticalImageCountParametersCopyWithImpl<UserIdenticalImageCountParameters>(
        this as UserIdenticalImageCountParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserIdenticalImageCountParameters &&
            (identical(other.match, match) || other.match == match) &&
            (identical(other.similarityDistance, similarityDistance) ||
                other.similarityDistance == similarityDistance) &&
            (identical(other.threshold, threshold) || other.threshold == threshold) &&
            (identical(other.timeWindow, timeWindow) || other.timeWindow == timeWindow));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    match,
    similarityDistance,
    threshold,
    timeWindow,
  );

  @override
  String toString() {
    return 'UserIdenticalImageCountParameters(match: $match, similarityDistance: $similarityDistance, threshold: $threshold, timeWindow: $timeWindow)';
  }
}

/// @nodoc
abstract mixin class $UserIdenticalImageCountParametersCopyWith<$Res> {
  factory $UserIdenticalImageCountParametersCopyWith(
    UserIdenticalImageCountParameters value,
    $Res Function(UserIdenticalImageCountParameters) _then,
  ) = _$UserIdenticalImageCountParametersCopyWithImpl;
  @useResult
  $Res call({
    String? match,
    int? similarityDistance,
    int? threshold,
    String? timeWindow,
  });
}

/// @nodoc
class _$UserIdenticalImageCountParametersCopyWithImpl<$Res>
    implements $UserIdenticalImageCountParametersCopyWith<$Res> {
  _$UserIdenticalImageCountParametersCopyWithImpl(this._self, this._then);

  final UserIdenticalImageCountParameters _self;
  final $Res Function(UserIdenticalImageCountParameters) _then;

  /// Create a copy of UserIdenticalImageCountParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? match = freezed,
    Object? similarityDistance = freezed,
    Object? threshold = freezed,
    Object? timeWindow = freezed,
  }) {
    return _then(
      UserIdenticalImageCountParameters(
        match: freezed == match
            ? _self.match
            : match // ignore: cast_nullable_to_non_nullable
                  as String?,
        similarityDistance: freezed == similarityDistance
            ? _self.similarityDistance
            : similarityDistance // ignore: cast_nullable_to_non_nullable
                  as int?,
        threshold: freezed == threshold
            ? _self.threshold
            : threshold // ignore: cast_nullable_to_non_nullable
                  as int?,
        timeWindow: freezed == timeWindow
            ? _self.timeWindow
            : timeWindow // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
