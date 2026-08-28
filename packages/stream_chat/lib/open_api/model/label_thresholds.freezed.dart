// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'label_thresholds.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LabelThresholds {
  double? get block;
  double? get flag;

  /// Create a copy of LabelThresholds
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LabelThresholdsCopyWith<LabelThresholds> get copyWith =>
      _$LabelThresholdsCopyWithImpl<LabelThresholds>(
        this as LabelThresholds,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LabelThresholds &&
            (identical(other.block, block) || other.block == block) &&
            (identical(other.flag, flag) || other.flag == flag));
  }

  @override
  int get hashCode => Object.hash(runtimeType, block, flag);

  @override
  String toString() {
    return 'LabelThresholds(block: $block, flag: $flag)';
  }
}

/// @nodoc
abstract mixin class $LabelThresholdsCopyWith<$Res> {
  factory $LabelThresholdsCopyWith(
    LabelThresholds value,
    $Res Function(LabelThresholds) _then,
  ) = _$LabelThresholdsCopyWithImpl;
  @useResult
  $Res call({double? block, double? flag});
}

/// @nodoc
class _$LabelThresholdsCopyWithImpl<$Res>
    implements $LabelThresholdsCopyWith<$Res> {
  _$LabelThresholdsCopyWithImpl(this._self, this._then);

  final LabelThresholds _self;
  final $Res Function(LabelThresholds) _then;

  /// Create a copy of LabelThresholds
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? block = freezed, Object? flag = freezed}) {
    return _then(
      LabelThresholds(
        block: freezed == block
            ? _self.block
            : block // ignore: cast_nullable_to_non_nullable
                  as double?,
        flag: freezed == flag
            ? _self.flag
            : flag // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}
