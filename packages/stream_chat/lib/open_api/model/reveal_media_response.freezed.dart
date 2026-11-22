// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reveal_media_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RevealMediaResponse {
  String get duration;
  MediaDisplayResponse get mediaDisplay;

  /// Create a copy of RevealMediaResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RevealMediaResponseCopyWith<RevealMediaResponse> get copyWith =>
      _$RevealMediaResponseCopyWithImpl<RevealMediaResponse>(
        this as RevealMediaResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RevealMediaResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.mediaDisplay, mediaDisplay) || other.mediaDisplay == mediaDisplay));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, mediaDisplay);

  @override
  String toString() {
    return 'RevealMediaResponse(duration: $duration, mediaDisplay: $mediaDisplay)';
  }
}

/// @nodoc
abstract mixin class $RevealMediaResponseCopyWith<$Res> {
  factory $RevealMediaResponseCopyWith(
    RevealMediaResponse value,
    $Res Function(RevealMediaResponse) _then,
  ) = _$RevealMediaResponseCopyWithImpl;
  @useResult
  $Res call({String duration, MediaDisplayResponse mediaDisplay});
}

/// @nodoc
class _$RevealMediaResponseCopyWithImpl<$Res> implements $RevealMediaResponseCopyWith<$Res> {
  _$RevealMediaResponseCopyWithImpl(this._self, this._then);

  final RevealMediaResponse _self;
  final $Res Function(RevealMediaResponse) _then;

  /// Create a copy of RevealMediaResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? mediaDisplay = null}) {
    return _then(
      RevealMediaResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        mediaDisplay: null == mediaDisplay
            ? _self.mediaDisplay
            : mediaDisplay // ignore: cast_nullable_to_non_nullable
                  as MediaDisplayResponse,
      ),
    );
  }
}
