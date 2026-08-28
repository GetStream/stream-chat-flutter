// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_image_label_definition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AIImageLabelDefinition {
  String get description;
  String get group;
  String get key;
  String get label;

  /// Create a copy of AIImageLabelDefinition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AIImageLabelDefinitionCopyWith<AIImageLabelDefinition> get copyWith =>
      _$AIImageLabelDefinitionCopyWithImpl<AIImageLabelDefinition>(
        this as AIImageLabelDefinition,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AIImageLabelDefinition &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label));
  }

  @override
  int get hashCode => Object.hash(runtimeType, description, group, key, label);

  @override
  String toString() {
    return 'AIImageLabelDefinition(description: $description, group: $group, key: $key, label: $label)';
  }
}

/// @nodoc
abstract mixin class $AIImageLabelDefinitionCopyWith<$Res> {
  factory $AIImageLabelDefinitionCopyWith(
    AIImageLabelDefinition value,
    $Res Function(AIImageLabelDefinition) _then,
  ) = _$AIImageLabelDefinitionCopyWithImpl;
  @useResult
  $Res call({String description, String group, String key, String label});
}

/// @nodoc
class _$AIImageLabelDefinitionCopyWithImpl<$Res>
    implements $AIImageLabelDefinitionCopyWith<$Res> {
  _$AIImageLabelDefinitionCopyWithImpl(this._self, this._then);

  final AIImageLabelDefinition _self;
  final $Res Function(AIImageLabelDefinition) _then;

  /// Create a copy of AIImageLabelDefinition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? group = null,
    Object? key = null,
    Object? label = null,
  }) {
    return _then(
      AIImageLabelDefinition(
        description: null == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        group: null == group
            ? _self.group
            : group // ignore: cast_nullable_to_non_nullable
                  as String,
        key: null == key
            ? _self.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _self.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
