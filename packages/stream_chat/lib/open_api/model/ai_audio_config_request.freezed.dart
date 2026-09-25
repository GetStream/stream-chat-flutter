// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_audio_config_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AIAudioConfigRequest {
  String? get profile;
  List<BodyguardRule>? get rules;

  /// Create a copy of AIAudioConfigRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AIAudioConfigRequestCopyWith<AIAudioConfigRequest> get copyWith =>
      _$AIAudioConfigRequestCopyWithImpl<AIAudioConfigRequest>(
        this as AIAudioConfigRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AIAudioConfigRequest &&
            (identical(other.profile, profile) || other.profile == profile) &&
            const DeepCollectionEquality().equals(other.rules, rules));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    profile,
    const DeepCollectionEquality().hash(rules),
  );

  @override
  String toString() {
    return 'AIAudioConfigRequest(profile: $profile, rules: $rules)';
  }
}

/// @nodoc
abstract mixin class $AIAudioConfigRequestCopyWith<$Res> {
  factory $AIAudioConfigRequestCopyWith(
    AIAudioConfigRequest value,
    $Res Function(AIAudioConfigRequest) _then,
  ) = _$AIAudioConfigRequestCopyWithImpl;
  @useResult
  $Res call({String? profile, List<BodyguardRule>? rules});
}

/// @nodoc
class _$AIAudioConfigRequestCopyWithImpl<$Res> implements $AIAudioConfigRequestCopyWith<$Res> {
  _$AIAudioConfigRequestCopyWithImpl(this._self, this._then);

  final AIAudioConfigRequest _self;
  final $Res Function(AIAudioConfigRequest) _then;

  /// Create a copy of AIAudioConfigRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profile = freezed, Object? rules = freezed}) {
    return _then(
      AIAudioConfigRequest(
        profile: freezed == profile
            ? _self.profile
            : profile // ignore: cast_nullable_to_non_nullable
                  as String?,
        rules: freezed == rules
            ? _self.rules
            : rules // ignore: cast_nullable_to_non_nullable
                  as List<BodyguardRule>?,
      ),
    );
  }
}
