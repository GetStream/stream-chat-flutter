// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_input_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelInputRequest {
  bool? get autoTranslationEnabled;
  String? get autoTranslationLanguage;
  ConfigOverridesRequest? get configOverrides;
  UserRequest? get createdBy;
  Map<String, Object?>? get custom;
  bool? get disabled;
  bool? get frozen;
  List<ChannelMemberRequest>? get invites;
  List<ChannelMemberRequest>? get members;
  String? get team;

  /// Create a copy of ChannelInputRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelInputRequestCopyWith<ChannelInputRequest> get copyWith =>
      _$ChannelInputRequestCopyWithImpl<ChannelInputRequest>(
        this as ChannelInputRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelInputRequest &&
            (identical(other.autoTranslationEnabled, autoTranslationEnabled) ||
                other.autoTranslationEnabled == autoTranslationEnabled) &&
            (identical(
                  other.autoTranslationLanguage,
                  autoTranslationLanguage,
                ) ||
                other.autoTranslationLanguage == autoTranslationLanguage) &&
            (identical(other.configOverrides, configOverrides) ||
                other.configOverrides == configOverrides) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.disabled, disabled) ||
                other.disabled == disabled) &&
            (identical(other.frozen, frozen) || other.frozen == frozen) &&
            const DeepCollectionEquality().equals(other.invites, invites) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.team, team) || other.team == team));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    autoTranslationEnabled,
    autoTranslationLanguage,
    configOverrides,
    createdBy,
    const DeepCollectionEquality().hash(custom),
    disabled,
    frozen,
    const DeepCollectionEquality().hash(invites),
    const DeepCollectionEquality().hash(members),
    team,
  );

  @override
  String toString() {
    return 'ChannelInputRequest(autoTranslationEnabled: $autoTranslationEnabled, autoTranslationLanguage: $autoTranslationLanguage, configOverrides: $configOverrides, createdBy: $createdBy, custom: $custom, disabled: $disabled, frozen: $frozen, invites: $invites, members: $members, team: $team)';
  }
}

/// @nodoc
abstract mixin class $ChannelInputRequestCopyWith<$Res> {
  factory $ChannelInputRequestCopyWith(
    ChannelInputRequest value,
    $Res Function(ChannelInputRequest) _then,
  ) = _$ChannelInputRequestCopyWithImpl;
  @useResult
  $Res call({
    bool? autoTranslationEnabled,
    String? autoTranslationLanguage,
    ConfigOverridesRequest? configOverrides,
    UserRequest? createdBy,
    Map<String, Object?>? custom,
    bool? disabled,
    bool? frozen,
    List<ChannelMemberRequest>? invites,
    List<ChannelMemberRequest>? members,
    String? team,
  });
}

/// @nodoc
class _$ChannelInputRequestCopyWithImpl<$Res>
    implements $ChannelInputRequestCopyWith<$Res> {
  _$ChannelInputRequestCopyWithImpl(this._self, this._then);

  final ChannelInputRequest _self;
  final $Res Function(ChannelInputRequest) _then;

  /// Create a copy of ChannelInputRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoTranslationEnabled = freezed,
    Object? autoTranslationLanguage = freezed,
    Object? configOverrides = freezed,
    Object? createdBy = freezed,
    Object? custom = freezed,
    Object? disabled = freezed,
    Object? frozen = freezed,
    Object? invites = freezed,
    Object? members = freezed,
    Object? team = freezed,
  }) {
    return _then(
      ChannelInputRequest(
        autoTranslationEnabled: freezed == autoTranslationEnabled
            ? _self.autoTranslationEnabled
            : autoTranslationEnabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        autoTranslationLanguage: freezed == autoTranslationLanguage
            ? _self.autoTranslationLanguage
            : autoTranslationLanguage // ignore: cast_nullable_to_non_nullable
                  as String?,
        configOverrides: freezed == configOverrides
            ? _self.configOverrides
            : configOverrides // ignore: cast_nullable_to_non_nullable
                  as ConfigOverridesRequest?,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as UserRequest?,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        disabled: freezed == disabled
            ? _self.disabled
            : disabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        frozen: freezed == frozen
            ? _self.frozen
            : frozen // ignore: cast_nullable_to_non_nullable
                  as bool?,
        invites: freezed == invites
            ? _self.invites
            : invites // ignore: cast_nullable_to_non_nullable
                  as List<ChannelMemberRequest>?,
        members: freezed == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<ChannelMemberRequest>?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
