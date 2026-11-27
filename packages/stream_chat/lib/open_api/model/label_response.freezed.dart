// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'label_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LabelResponse {
  List<String>? get harmLabels;
  String get name;
  List<int>? get phraseListIds;

  /// Create a copy of LabelResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LabelResponseCopyWith<LabelResponse> get copyWith => _$LabelResponseCopyWithImpl<LabelResponse>(
    this as LabelResponse,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LabelResponse &&
            const DeepCollectionEquality().equals(
              other.harmLabels,
              harmLabels,
            ) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(
              other.phraseListIds,
              phraseListIds,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(harmLabels),
    name,
    const DeepCollectionEquality().hash(phraseListIds),
  );

  @override
  String toString() {
    return 'LabelResponse(harmLabels: $harmLabels, name: $name, phraseListIds: $phraseListIds)';
  }
}

/// @nodoc
abstract mixin class $LabelResponseCopyWith<$Res> {
  factory $LabelResponseCopyWith(
    LabelResponse value,
    $Res Function(LabelResponse) _then,
  ) = _$LabelResponseCopyWithImpl;
  @useResult
  $Res call({List<String>? harmLabels, String name, List<int>? phraseListIds});
}

/// @nodoc
class _$LabelResponseCopyWithImpl<$Res> implements $LabelResponseCopyWith<$Res> {
  _$LabelResponseCopyWithImpl(this._self, this._then);

  final LabelResponse _self;
  final $Res Function(LabelResponse) _then;

  /// Create a copy of LabelResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? harmLabels = freezed,
    Object? name = null,
    Object? phraseListIds = freezed,
  }) {
    return _then(
      LabelResponse(
        harmLabels: freezed == harmLabels
            ? _self.harmLabels
            : harmLabels // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        phraseListIds: freezed == phraseListIds
            ? _self.phraseListIds
            : phraseListIds // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
      ),
    );
  }
}
