// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_draft_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateDraftResponse {
  DraftResponse get draft;
  String get duration;

  /// Create a copy of CreateDraftResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateDraftResponseCopyWith<CreateDraftResponse> get copyWith =>
      _$CreateDraftResponseCopyWithImpl<CreateDraftResponse>(
        this as CreateDraftResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateDraftResponse &&
            (identical(other.draft, draft) || other.draft == draft) &&
            (identical(other.duration, duration) || other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, draft, duration);

  @override
  String toString() {
    return 'CreateDraftResponse(draft: $draft, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $CreateDraftResponseCopyWith<$Res> {
  factory $CreateDraftResponseCopyWith(
    CreateDraftResponse value,
    $Res Function(CreateDraftResponse) _then,
  ) = _$CreateDraftResponseCopyWithImpl;
  @useResult
  $Res call({DraftResponse draft, String duration});
}

/// @nodoc
class _$CreateDraftResponseCopyWithImpl<$Res> implements $CreateDraftResponseCopyWith<$Res> {
  _$CreateDraftResponseCopyWithImpl(this._self, this._then);

  final CreateDraftResponse _self;
  final $Res Function(CreateDraftResponse) _then;

  /// Create a copy of CreateDraftResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? draft = null, Object? duration = null}) {
    return _then(
      CreateDraftResponse(
        draft: null == draft
            ? _self.draft
            : draft // ignore: cast_nullable_to_non_nullable
                  as DraftResponse,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
