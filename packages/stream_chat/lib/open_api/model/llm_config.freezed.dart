// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'llm_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LLMConfig {
  String? get appContext;
  bool? get async;
  bool get enabled;
  List<LLMRule> get rules;
  Map<String, String>? get severityDescriptions;

  /// Create a copy of LLMConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LLMConfigCopyWith<LLMConfig> get copyWith =>
      _$LLMConfigCopyWithImpl<LLMConfig>(this as LLMConfig, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LLMConfig &&
            (identical(other.appContext, appContext) ||
                other.appContext == appContext) &&
            (identical(other.async, async) || other.async == async) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            const DeepCollectionEquality().equals(other.rules, rules) &&
            const DeepCollectionEquality().equals(
              other.severityDescriptions,
              severityDescriptions,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    appContext,
    async,
    enabled,
    const DeepCollectionEquality().hash(rules),
    const DeepCollectionEquality().hash(severityDescriptions),
  );

  @override
  String toString() {
    return 'LLMConfig(appContext: $appContext, async: $async, enabled: $enabled, rules: $rules, severityDescriptions: $severityDescriptions)';
  }
}

/// @nodoc
abstract mixin class $LLMConfigCopyWith<$Res> {
  factory $LLMConfigCopyWith(LLMConfig value, $Res Function(LLMConfig) _then) =
      _$LLMConfigCopyWithImpl;
  @useResult
  $Res call({
    String? appContext,
    bool? async,
    bool enabled,
    List<LLMRule> rules,
    Map<String, String>? severityDescriptions,
  });
}

/// @nodoc
class _$LLMConfigCopyWithImpl<$Res> implements $LLMConfigCopyWith<$Res> {
  _$LLMConfigCopyWithImpl(this._self, this._then);

  final LLMConfig _self;
  final $Res Function(LLMConfig) _then;

  /// Create a copy of LLMConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appContext = freezed,
    Object? async = freezed,
    Object? enabled = null,
    Object? rules = null,
    Object? severityDescriptions = freezed,
  }) {
    return _then(
      LLMConfig(
        appContext: freezed == appContext
            ? _self.appContext
            : appContext // ignore: cast_nullable_to_non_nullable
                  as String?,
        async: freezed == async
            ? _self.async
            : async // ignore: cast_nullable_to_non_nullable
                  as bool?,
        enabled: null == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        rules: null == rules
            ? _self.rules
            : rules // ignore: cast_nullable_to_non_nullable
                  as List<LLMRule>,
        severityDescriptions: freezed == severityDescriptions
            ? _self.severityDescriptions
            : severityDescriptions // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
      ),
    );
  }
}
