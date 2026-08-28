// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_application_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetApplicationResponse {
  AppResponseFields get app;
  String get duration;

  /// Create a copy of GetApplicationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GetApplicationResponseCopyWith<GetApplicationResponse> get copyWith =>
      _$GetApplicationResponseCopyWithImpl<GetApplicationResponse>(
        this as GetApplicationResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GetApplicationResponse &&
            (identical(other.app, app) || other.app == app) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, app, duration);

  @override
  String toString() {
    return 'GetApplicationResponse(app: $app, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $GetApplicationResponseCopyWith<$Res> {
  factory $GetApplicationResponseCopyWith(
    GetApplicationResponse value,
    $Res Function(GetApplicationResponse) _then,
  ) = _$GetApplicationResponseCopyWithImpl;
  @useResult
  $Res call({AppResponseFields app, String duration});
}

/// @nodoc
class _$GetApplicationResponseCopyWithImpl<$Res>
    implements $GetApplicationResponseCopyWith<$Res> {
  _$GetApplicationResponseCopyWithImpl(this._self, this._then);

  final GetApplicationResponse _self;
  final $Res Function(GetApplicationResponse) _then;

  /// Create a copy of GetApplicationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? app = null, Object? duration = null}) {
    return _then(
      GetApplicationResponse(
        app: null == app
            ? _self.app
            : app // ignore: cast_nullable_to_non_nullable
                  as AppResponseFields,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
