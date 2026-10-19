// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_channel_ban_count_rule_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserChannelBanCountRuleParameters {
  String? get bannedBy;
  int? get threshold;
  String? get timeWindow;

  /// Create a copy of UserChannelBanCountRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserChannelBanCountRuleParametersCopyWith<UserChannelBanCountRuleParameters> get copyWith =>
      _$UserChannelBanCountRuleParametersCopyWithImpl<UserChannelBanCountRuleParameters>(
        this as UserChannelBanCountRuleParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserChannelBanCountRuleParameters &&
            (identical(other.bannedBy, bannedBy) || other.bannedBy == bannedBy) &&
            (identical(other.threshold, threshold) || other.threshold == threshold) &&
            (identical(other.timeWindow, timeWindow) || other.timeWindow == timeWindow));
  }

  @override
  int get hashCode => Object.hash(runtimeType, bannedBy, threshold, timeWindow);

  @override
  String toString() {
    return 'UserChannelBanCountRuleParameters(bannedBy: $bannedBy, threshold: $threshold, timeWindow: $timeWindow)';
  }
}

/// @nodoc
abstract mixin class $UserChannelBanCountRuleParametersCopyWith<$Res> {
  factory $UserChannelBanCountRuleParametersCopyWith(
    UserChannelBanCountRuleParameters value,
    $Res Function(UserChannelBanCountRuleParameters) _then,
  ) = _$UserChannelBanCountRuleParametersCopyWithImpl;
  @useResult
  $Res call({String? bannedBy, int? threshold, String? timeWindow});
}

/// @nodoc
class _$UserChannelBanCountRuleParametersCopyWithImpl<$Res>
    implements $UserChannelBanCountRuleParametersCopyWith<$Res> {
  _$UserChannelBanCountRuleParametersCopyWithImpl(this._self, this._then);

  final UserChannelBanCountRuleParameters _self;
  final $Res Function(UserChannelBanCountRuleParameters) _then;

  /// Create a copy of UserChannelBanCountRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bannedBy = freezed,
    Object? threshold = freezed,
    Object? timeWindow = freezed,
  }) {
    return _then(
      UserChannelBanCountRuleParameters(
        bannedBy: freezed == bannedBy
            ? _self.bannedBy
            : bannedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        threshold: freezed == threshold
            ? _self.threshold
            : threshold // ignore: cast_nullable_to_non_nullable
                  as int?,
        timeWindow: freezed == timeWindow
            ? _self.timeWindow
            : timeWindow // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
