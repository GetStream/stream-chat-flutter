// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hide_channel_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HideChannelResponse {
  String get duration;

  /// Create a copy of HideChannelResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HideChannelResponseCopyWith<HideChannelResponse> get copyWith =>
      _$HideChannelResponseCopyWithImpl<HideChannelResponse>(
        this as HideChannelResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HideChannelResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration);

  @override
  String toString() {
    return 'HideChannelResponse(duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $HideChannelResponseCopyWith<$Res> {
  factory $HideChannelResponseCopyWith(
    HideChannelResponse value,
    $Res Function(HideChannelResponse) _then,
  ) = _$HideChannelResponseCopyWithImpl;
  @useResult
  $Res call({String duration});
}

/// @nodoc
class _$HideChannelResponseCopyWithImpl<$Res>
    implements $HideChannelResponseCopyWith<$Res> {
  _$HideChannelResponseCopyWithImpl(this._self, this._then);

  final HideChannelResponse _self;
  final $Res Function(HideChannelResponse) _then;

  /// Create a copy of HideChannelResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null}) {
    return _then(
      HideChannelResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
