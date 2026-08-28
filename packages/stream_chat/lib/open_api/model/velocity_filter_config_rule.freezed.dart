// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'velocity_filter_config_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VelocityFilterConfigRule {
  VelocityFilterConfigRuleAction get action;
  int get banDuration;
  VelocityFilterConfigRuleCascadingAction get cascadingAction;
  int get cascadingThreshold;
  bool get checkMessageContext;
  int get fastSpamThreshold;
  int get fastSpamTtl;
  bool get ipBan;
  int get probationPeriod;
  bool get shadowBan;
  int? get slowSpamBanDuration;
  int get slowSpamThreshold;
  int get slowSpamTtl;
  bool get urlOnly;

  /// Create a copy of VelocityFilterConfigRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VelocityFilterConfigRuleCopyWith<VelocityFilterConfigRule> get copyWith =>
      _$VelocityFilterConfigRuleCopyWithImpl<VelocityFilterConfigRule>(
        this as VelocityFilterConfigRule,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VelocityFilterConfigRule &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.banDuration, banDuration) ||
                other.banDuration == banDuration) &&
            (identical(other.cascadingAction, cascadingAction) ||
                other.cascadingAction == cascadingAction) &&
            (identical(other.cascadingThreshold, cascadingThreshold) ||
                other.cascadingThreshold == cascadingThreshold) &&
            (identical(other.checkMessageContext, checkMessageContext) ||
                other.checkMessageContext == checkMessageContext) &&
            (identical(other.fastSpamThreshold, fastSpamThreshold) ||
                other.fastSpamThreshold == fastSpamThreshold) &&
            (identical(other.fastSpamTtl, fastSpamTtl) ||
                other.fastSpamTtl == fastSpamTtl) &&
            (identical(other.ipBan, ipBan) || other.ipBan == ipBan) &&
            (identical(other.probationPeriod, probationPeriod) ||
                other.probationPeriod == probationPeriod) &&
            (identical(other.shadowBan, shadowBan) ||
                other.shadowBan == shadowBan) &&
            (identical(other.slowSpamBanDuration, slowSpamBanDuration) ||
                other.slowSpamBanDuration == slowSpamBanDuration) &&
            (identical(other.slowSpamThreshold, slowSpamThreshold) ||
                other.slowSpamThreshold == slowSpamThreshold) &&
            (identical(other.slowSpamTtl, slowSpamTtl) ||
                other.slowSpamTtl == slowSpamTtl) &&
            (identical(other.urlOnly, urlOnly) || other.urlOnly == urlOnly));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    action,
    banDuration,
    cascadingAction,
    cascadingThreshold,
    checkMessageContext,
    fastSpamThreshold,
    fastSpamTtl,
    ipBan,
    probationPeriod,
    shadowBan,
    slowSpamBanDuration,
    slowSpamThreshold,
    slowSpamTtl,
    urlOnly,
  );

  @override
  String toString() {
    return 'VelocityFilterConfigRule(action: $action, banDuration: $banDuration, cascadingAction: $cascadingAction, cascadingThreshold: $cascadingThreshold, checkMessageContext: $checkMessageContext, fastSpamThreshold: $fastSpamThreshold, fastSpamTtl: $fastSpamTtl, ipBan: $ipBan, probationPeriod: $probationPeriod, shadowBan: $shadowBan, slowSpamBanDuration: $slowSpamBanDuration, slowSpamThreshold: $slowSpamThreshold, slowSpamTtl: $slowSpamTtl, urlOnly: $urlOnly)';
  }
}

/// @nodoc
abstract mixin class $VelocityFilterConfigRuleCopyWith<$Res> {
  factory $VelocityFilterConfigRuleCopyWith(
    VelocityFilterConfigRule value,
    $Res Function(VelocityFilterConfigRule) _then,
  ) = _$VelocityFilterConfigRuleCopyWithImpl;
  @useResult
  $Res call({
    VelocityFilterConfigRuleAction action,
    int banDuration,
    VelocityFilterConfigRuleCascadingAction cascadingAction,
    int cascadingThreshold,
    bool checkMessageContext,
    int fastSpamThreshold,
    int fastSpamTtl,
    bool ipBan,
    int probationPeriod,
    bool shadowBan,
    int? slowSpamBanDuration,
    int slowSpamThreshold,
    int slowSpamTtl,
    bool urlOnly,
  });
}

/// @nodoc
class _$VelocityFilterConfigRuleCopyWithImpl<$Res>
    implements $VelocityFilterConfigRuleCopyWith<$Res> {
  _$VelocityFilterConfigRuleCopyWithImpl(this._self, this._then);

  final VelocityFilterConfigRule _self;
  final $Res Function(VelocityFilterConfigRule) _then;

  /// Create a copy of VelocityFilterConfigRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? banDuration = null,
    Object? cascadingAction = null,
    Object? cascadingThreshold = null,
    Object? checkMessageContext = null,
    Object? fastSpamThreshold = null,
    Object? fastSpamTtl = null,
    Object? ipBan = null,
    Object? probationPeriod = null,
    Object? shadowBan = null,
    Object? slowSpamBanDuration = freezed,
    Object? slowSpamThreshold = null,
    Object? slowSpamTtl = null,
    Object? urlOnly = null,
  }) {
    return _then(
      VelocityFilterConfigRule(
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as VelocityFilterConfigRuleAction,
        banDuration: null == banDuration
            ? _self.banDuration
            : banDuration // ignore: cast_nullable_to_non_nullable
                  as int,
        cascadingAction: null == cascadingAction
            ? _self.cascadingAction
            : cascadingAction // ignore: cast_nullable_to_non_nullable
                  as VelocityFilterConfigRuleCascadingAction,
        cascadingThreshold: null == cascadingThreshold
            ? _self.cascadingThreshold
            : cascadingThreshold // ignore: cast_nullable_to_non_nullable
                  as int,
        checkMessageContext: null == checkMessageContext
            ? _self.checkMessageContext
            : checkMessageContext // ignore: cast_nullable_to_non_nullable
                  as bool,
        fastSpamThreshold: null == fastSpamThreshold
            ? _self.fastSpamThreshold
            : fastSpamThreshold // ignore: cast_nullable_to_non_nullable
                  as int,
        fastSpamTtl: null == fastSpamTtl
            ? _self.fastSpamTtl
            : fastSpamTtl // ignore: cast_nullable_to_non_nullable
                  as int,
        ipBan: null == ipBan
            ? _self.ipBan
            : ipBan // ignore: cast_nullable_to_non_nullable
                  as bool,
        probationPeriod: null == probationPeriod
            ? _self.probationPeriod
            : probationPeriod // ignore: cast_nullable_to_non_nullable
                  as int,
        shadowBan: null == shadowBan
            ? _self.shadowBan
            : shadowBan // ignore: cast_nullable_to_non_nullable
                  as bool,
        slowSpamBanDuration: freezed == slowSpamBanDuration
            ? _self.slowSpamBanDuration
            : slowSpamBanDuration // ignore: cast_nullable_to_non_nullable
                  as int?,
        slowSpamThreshold: null == slowSpamThreshold
            ? _self.slowSpamThreshold
            : slowSpamThreshold // ignore: cast_nullable_to_non_nullable
                  as int,
        slowSpamTtl: null == slowSpamTtl
            ? _self.slowSpamTtl
            : slowSpamTtl // ignore: cast_nullable_to_non_nullable
                  as int,
        urlOnly: null == urlOnly
            ? _self.urlOnly
            : urlOnly // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
