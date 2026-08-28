// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_content_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoContentParameters {
  List<String>? get harmLabels;
  String? get labelOperator;

  /// Create a copy of VideoContentParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VideoContentParametersCopyWith<VideoContentParameters> get copyWith =>
      _$VideoContentParametersCopyWithImpl<VideoContentParameters>(
        this as VideoContentParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VideoContentParameters &&
            const DeepCollectionEquality().equals(
              other.harmLabels,
              harmLabels,
            ) &&
            (identical(other.labelOperator, labelOperator) ||
                other.labelOperator == labelOperator));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(harmLabels),
    labelOperator,
  );

  @override
  String toString() {
    return 'VideoContentParameters(harmLabels: $harmLabels, labelOperator: $labelOperator)';
  }
}

/// @nodoc
abstract mixin class $VideoContentParametersCopyWith<$Res> {
  factory $VideoContentParametersCopyWith(
    VideoContentParameters value,
    $Res Function(VideoContentParameters) _then,
  ) = _$VideoContentParametersCopyWithImpl;
  @useResult
  $Res call({List<String>? harmLabels, String? labelOperator});
}

/// @nodoc
class _$VideoContentParametersCopyWithImpl<$Res>
    implements $VideoContentParametersCopyWith<$Res> {
  _$VideoContentParametersCopyWithImpl(this._self, this._then);

  final VideoContentParameters _self;
  final $Res Function(VideoContentParameters) _then;

  /// Create a copy of VideoContentParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? harmLabels = freezed, Object? labelOperator = freezed}) {
    return _then(
      VideoContentParameters(
        harmLabels: freezed == harmLabels
            ? _self.harmLabels
            : harmLabels // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        labelOperator: freezed == labelOperator
            ? _self.labelOperator
            : labelOperator // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
