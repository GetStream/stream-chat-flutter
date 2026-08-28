// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'aws_rekognition_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AWSRekognitionRule {
  AWSRekognitionRuleAction get action;
  String get label;
  double get minConfidence;
  Map<String, Object?>? get subclassifications;

  /// Create a copy of AWSRekognitionRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AWSRekognitionRuleCopyWith<AWSRekognitionRule> get copyWith =>
      _$AWSRekognitionRuleCopyWithImpl<AWSRekognitionRule>(
        this as AWSRekognitionRule,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AWSRekognitionRule &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.minConfidence, minConfidence) ||
                other.minConfidence == minConfidence) &&
            const DeepCollectionEquality().equals(
              other.subclassifications,
              subclassifications,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    action,
    label,
    minConfidence,
    const DeepCollectionEquality().hash(subclassifications),
  );

  @override
  String toString() {
    return 'AWSRekognitionRule(action: $action, label: $label, minConfidence: $minConfidence, subclassifications: $subclassifications)';
  }
}

/// @nodoc
abstract mixin class $AWSRekognitionRuleCopyWith<$Res> {
  factory $AWSRekognitionRuleCopyWith(
    AWSRekognitionRule value,
    $Res Function(AWSRekognitionRule) _then,
  ) = _$AWSRekognitionRuleCopyWithImpl;
  @useResult
  $Res call({
    AWSRekognitionRuleAction action,
    String label,
    double minConfidence,
    Map<String, Object?>? subclassifications,
  });
}

/// @nodoc
class _$AWSRekognitionRuleCopyWithImpl<$Res>
    implements $AWSRekognitionRuleCopyWith<$Res> {
  _$AWSRekognitionRuleCopyWithImpl(this._self, this._then);

  final AWSRekognitionRule _self;
  final $Res Function(AWSRekognitionRule) _then;

  /// Create a copy of AWSRekognitionRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? label = null,
    Object? minConfidence = null,
    Object? subclassifications = freezed,
  }) {
    return _then(
      AWSRekognitionRule(
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as AWSRekognitionRuleAction,
        label: null == label
            ? _self.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        minConfidence: null == minConfidence
            ? _self.minConfidence
            : minConfidence // ignore: cast_nullable_to_non_nullable
                  as double,
        subclassifications: freezed == subclassifications
            ? _self.subclassifications
            : subclassifications // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
      ),
    );
  }
}
