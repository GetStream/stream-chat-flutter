// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'intent_config_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IntentConfigRequest {
  List<IntentTopicRequest>? get topics;

  /// Create a copy of IntentConfigRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IntentConfigRequestCopyWith<IntentConfigRequest> get copyWith =>
      _$IntentConfigRequestCopyWithImpl<IntentConfigRequest>(
        this as IntentConfigRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IntentConfigRequest &&
            const DeepCollectionEquality().equals(other.topics, topics));
  }

  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(topics));

  @override
  String toString() {
    return 'IntentConfigRequest(topics: $topics)';
  }
}

/// @nodoc
abstract mixin class $IntentConfigRequestCopyWith<$Res> {
  factory $IntentConfigRequestCopyWith(
    IntentConfigRequest value,
    $Res Function(IntentConfigRequest) _then,
  ) = _$IntentConfigRequestCopyWithImpl;
  @useResult
  $Res call({List<IntentTopicRequest>? topics});
}

/// @nodoc
class _$IntentConfigRequestCopyWithImpl<$Res> implements $IntentConfigRequestCopyWith<$Res> {
  _$IntentConfigRequestCopyWithImpl(this._self, this._then);

  final IntentConfigRequest _self;
  final $Res Function(IntentConfigRequest) _then;

  /// Create a copy of IntentConfigRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? topics = freezed}) {
    return _then(
      IntentConfigRequest(
        topics: freezed == topics
            ? _self.topics
            : topics // ignore: cast_nullable_to_non_nullable
                  as List<IntentTopicRequest>?,
      ),
    );
  }
}
