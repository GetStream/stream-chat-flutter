// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'intent_config_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IntentConfigResponse {
  List<IntentTopicResponse> get topics;

  /// Create a copy of IntentConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IntentConfigResponseCopyWith<IntentConfigResponse> get copyWith =>
      _$IntentConfigResponseCopyWithImpl<IntentConfigResponse>(
        this as IntentConfigResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IntentConfigResponse &&
            const DeepCollectionEquality().equals(other.topics, topics));
  }

  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(topics));

  @override
  String toString() {
    return 'IntentConfigResponse(topics: $topics)';
  }
}

/// @nodoc
abstract mixin class $IntentConfigResponseCopyWith<$Res> {
  factory $IntentConfigResponseCopyWith(
    IntentConfigResponse value,
    $Res Function(IntentConfigResponse) _then,
  ) = _$IntentConfigResponseCopyWithImpl;
  @useResult
  $Res call({List<IntentTopicResponse> topics});
}

/// @nodoc
class _$IntentConfigResponseCopyWithImpl<$Res> implements $IntentConfigResponseCopyWith<$Res> {
  _$IntentConfigResponseCopyWithImpl(this._self, this._then);

  final IntentConfigResponse _self;
  final $Res Function(IntentConfigResponse) _then;

  /// Create a copy of IntentConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? topics = null}) {
    return _then(
      IntentConfigResponse(
        topics: null == topics
            ? _self.topics
            : topics // ignore: cast_nullable_to_non_nullable
                  as List<IntentTopicResponse>,
      ),
    );
  }
}
