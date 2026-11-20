// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_channel_count_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppChannelCountParameters {
  int? get threshold;
  String? get timeWindow;

  /// Create a copy of AppChannelCountParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppChannelCountParametersCopyWith<AppChannelCountParameters> get copyWith =>
      _$AppChannelCountParametersCopyWithImpl<AppChannelCountParameters>(
        this as AppChannelCountParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppChannelCountParameters &&
            (identical(other.threshold, threshold) || other.threshold == threshold) &&
            (identical(other.timeWindow, timeWindow) || other.timeWindow == timeWindow));
  }

  @override
  int get hashCode => Object.hash(runtimeType, threshold, timeWindow);

  @override
  String toString() {
    return 'AppChannelCountParameters(threshold: $threshold, timeWindow: $timeWindow)';
  }
}

/// @nodoc
abstract mixin class $AppChannelCountParametersCopyWith<$Res> {
  factory $AppChannelCountParametersCopyWith(
    AppChannelCountParameters value,
    $Res Function(AppChannelCountParameters) _then,
  ) = _$AppChannelCountParametersCopyWithImpl;
  @useResult
  $Res call({int? threshold, String? timeWindow});
}

/// @nodoc
class _$AppChannelCountParametersCopyWithImpl<$Res> implements $AppChannelCountParametersCopyWith<$Res> {
  _$AppChannelCountParametersCopyWithImpl(this._self, this._then);

  final AppChannelCountParameters _self;
  final $Res Function(AppChannelCountParameters) _then;

  /// Create a copy of AppChannelCountParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? threshold = freezed, Object? timeWindow = freezed}) {
    return _then(
      AppChannelCountParameters(
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
