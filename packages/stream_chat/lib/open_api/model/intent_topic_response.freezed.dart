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
  int get analysisCooldownSeconds;
  String? get description;
  bool get enabled;
  String get label;
  int get maxCapturedItems;
  int? get refireCooldownSeconds;
  double get scoreThreshold;

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
            (identical(
                  other.analysisCooldownSeconds,
                  analysisCooldownSeconds,
                ) ||
                other.analysisCooldownSeconds == analysisCooldownSeconds) &&
            (identical(other.description, description) || other.description == description) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.maxCapturedItems, maxCapturedItems) || other.maxCapturedItems == maxCapturedItems) &&
            (identical(other.refireCooldownSeconds, refireCooldownSeconds) ||
                other.refireCooldownSeconds == refireCooldownSeconds) &&
            (identical(other.scoreThreshold, scoreThreshold) || other.scoreThreshold == scoreThreshold));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    analysisCooldownSeconds,
    description,
    enabled,
    label,
    maxCapturedItems,
    refireCooldownSeconds,
    scoreThreshold,
  );

  @override
  String toString() {
    return 'IntentTopicResponse(analysisCooldownSeconds: $analysisCooldownSeconds, description: $description, enabled: $enabled, label: $label, maxCapturedItems: $maxCapturedItems, refireCooldownSeconds: $refireCooldownSeconds, scoreThreshold: $scoreThreshold)';
  }
}

/// @nodoc
abstract mixin class $IntentTopicResponseCopyWith<$Res> {
  factory $IntentTopicResponseCopyWith(
    IntentTopicResponse value,
    $Res Function(IntentTopicResponse) _then,
  ) = _$IntentTopicResponseCopyWithImpl;
  @useResult
  $Res call({
    int analysisCooldownSeconds,
    String? description,
    bool enabled,
    String label,
    int maxCapturedItems,
    int? refireCooldownSeconds,
    double scoreThreshold,
  });
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
  $Res call({
    Object? analysisCooldownSeconds = null,
    Object? description = freezed,
    Object? enabled = null,
    Object? label = null,
    Object? maxCapturedItems = null,
    Object? refireCooldownSeconds = freezed,
    Object? scoreThreshold = null,
  }) {
    return _then(
      IntentTopicResponse(
        analysisCooldownSeconds: null == analysisCooldownSeconds
            ? _self.analysisCooldownSeconds
            : analysisCooldownSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        description: freezed == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        enabled: null == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        label: null == label
            ? _self.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        maxCapturedItems: null == maxCapturedItems
            ? _self.maxCapturedItems
            : maxCapturedItems // ignore: cast_nullable_to_non_nullable
                  as int,
        refireCooldownSeconds: freezed == refireCooldownSeconds
            ? _self.refireCooldownSeconds
            : refireCooldownSeconds // ignore: cast_nullable_to_non_nullable
                  as int?,
        scoreThreshold: null == scoreThreshold
            ? _self.scoreThreshold
            : scoreThreshold // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}
