// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'intent_topic_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IntentTopicRequest {
  String? get description;
  String get label;

  /// Create a copy of IntentTopicRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IntentTopicRequestCopyWith<IntentTopicRequest> get copyWith => _$IntentTopicRequestCopyWithImpl<IntentTopicRequest>(
    this as IntentTopicRequest,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IntentTopicRequest &&
            (identical(other.description, description) || other.description == description) &&
            (identical(other.label, label) || other.label == label));
  }

  @override
  int get hashCode => Object.hash(runtimeType, description, label);

  @override
  String toString() {
    return 'IntentTopicRequest(description: $description, label: $label)';
  }
}

/// @nodoc
abstract mixin class $IntentTopicRequestCopyWith<$Res> {
  factory $IntentTopicRequestCopyWith(
    IntentTopicRequest value,
    $Res Function(IntentTopicRequest) _then,
  ) = _$IntentTopicRequestCopyWithImpl;
  @useResult
  $Res call({String? description, String label});
}

/// @nodoc
class _$IntentTopicRequestCopyWithImpl<$Res> implements $IntentTopicRequestCopyWith<$Res> {
  _$IntentTopicRequestCopyWithImpl(this._self, this._then);

  final IntentTopicRequest _self;
  final $Res Function(IntentTopicRequest) _then;

  /// Create a copy of IntentTopicRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? description = freezed, Object? label = null}) {
    return _then(
      IntentTopicRequest(
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
