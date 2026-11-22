// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_display_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaDisplayResponse {
  bool get auditReveal;
  MediaDisplayResponseMode get mode;
  bool get revealRestricted;

  /// Create a copy of MediaDisplayResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MediaDisplayResponseCopyWith<MediaDisplayResponse> get copyWith =>
      _$MediaDisplayResponseCopyWithImpl<MediaDisplayResponse>(
        this as MediaDisplayResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MediaDisplayResponse &&
            (identical(other.auditReveal, auditReveal) || other.auditReveal == auditReveal) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.revealRestricted, revealRestricted) || other.revealRestricted == revealRestricted));
  }

  @override
  int get hashCode => Object.hash(runtimeType, auditReveal, mode, revealRestricted);

  @override
  String toString() {
    return 'MediaDisplayResponse(auditReveal: $auditReveal, mode: $mode, revealRestricted: $revealRestricted)';
  }
}

/// @nodoc
abstract mixin class $MediaDisplayResponseCopyWith<$Res> {
  factory $MediaDisplayResponseCopyWith(
    MediaDisplayResponse value,
    $Res Function(MediaDisplayResponse) _then,
  ) = _$MediaDisplayResponseCopyWithImpl;
  @useResult
  $Res call({
    bool auditReveal,
    MediaDisplayResponseMode mode,
    bool revealRestricted,
  });
}

/// @nodoc
class _$MediaDisplayResponseCopyWithImpl<$Res> implements $MediaDisplayResponseCopyWith<$Res> {
  _$MediaDisplayResponseCopyWithImpl(this._self, this._then);

  final MediaDisplayResponse _self;
  final $Res Function(MediaDisplayResponse) _then;

  /// Create a copy of MediaDisplayResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? auditReveal = null,
    Object? mode = null,
    Object? revealRestricted = null,
  }) {
    return _then(
      MediaDisplayResponse(
        auditReveal: null == auditReveal
            ? _self.auditReveal
            : auditReveal // ignore: cast_nullable_to_non_nullable
                  as bool,
        mode: null == mode
            ? _self.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as MediaDisplayResponseMode,
        revealRestricted: null == revealRestricted
            ? _self.revealRestricted
            : revealRestricted // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
