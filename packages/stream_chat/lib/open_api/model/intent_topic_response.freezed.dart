// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'intent_topic_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IntentTopicResponse {
  String? get description;
  String get label;

  /// Create a copy of IntentTopicResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IntentTopicResponseCopyWith<IntentTopicResponse> get copyWith =>
      _$IntentTopicResponseCopyWithImpl<IntentTopicResponse>(
        this as IntentTopicResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IntentTopicResponse &&
            (identical(other.description, description) || other.description == description) &&
            (identical(other.label, label) || other.label == label));
  }

  @override
  int get hashCode => Object.hash(runtimeType, description, label);

  @override
  String toString() {
    return 'IntentTopicResponse(description: $description, label: $label)';
  }
}

/// @nodoc
abstract mixin class $IntentTopicResponseCopyWith<$Res> {
  factory $IntentTopicResponseCopyWith(
    IntentTopicResponse value,
    $Res Function(IntentTopicResponse) _then,
  ) = _$IntentTopicResponseCopyWithImpl;
  @useResult
  $Res call({String? description, String label});
}

/// @nodoc
class _$IntentTopicResponseCopyWithImpl<$Res> implements $IntentTopicResponseCopyWith<$Res> {
  _$IntentTopicResponseCopyWithImpl(this._self, this._then);

  final IntentTopicResponse _self;
  final $Res Function(IntentTopicResponse) _then;

  /// Create a copy of IntentTopicResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? description = freezed, Object? label = null}) {
    return _then(
      IntentTopicResponse(
        description: freezed == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        label: null == label
            ? _self.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
