// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_message_count_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppMessageCountParameters {
  int? get threshold;
  String? get timeWindow;

  /// Create a copy of AppMessageCountParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppMessageCountParametersCopyWith<AppMessageCountParameters> get copyWith =>
      _$AppMessageCountParametersCopyWithImpl<AppMessageCountParameters>(
        this as AppMessageCountParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppMessageCountParameters &&
            (identical(other.threshold, threshold) || other.threshold == threshold) &&
            (identical(other.timeWindow, timeWindow) || other.timeWindow == timeWindow));
  }

  @override
  int get hashCode => Object.hash(runtimeType, threshold, timeWindow);

  @override
  String toString() {
    return 'AppMessageCountParameters(threshold: $threshold, timeWindow: $timeWindow)';
  }
}

/// @nodoc
abstract mixin class $AppMessageCountParametersCopyWith<$Res> {
  factory $AppMessageCountParametersCopyWith(
    AppMessageCountParameters value,
    $Res Function(AppMessageCountParameters) _then,
  ) = _$AppMessageCountParametersCopyWithImpl;
  @useResult
  $Res call({int? threshold, String? timeWindow});
}

/// @nodoc
class _$AppMessageCountParametersCopyWithImpl<$Res> implements $AppMessageCountParametersCopyWith<$Res> {
  _$AppMessageCountParametersCopyWithImpl(this._self, this._then);

  final AppMessageCountParameters _self;
  final $Res Function(AppMessageCountParameters) _then;

  /// Create a copy of AppMessageCountParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? threshold = freezed, Object? timeWindow = freezed}) {
    return _then(
      AppMessageCountParameters(
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
