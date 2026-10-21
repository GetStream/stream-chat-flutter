// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelInput {
  bool? get autoTranslationEnabled;
  String? get autoTranslationLanguage;
  ChannelConfigOverrides? get configOverrides;
  UserRequest? get createdBy;
  String? get createdById;
  Map<String, Object?>? get custom;
  bool? get disabled;
  List<String>? get filterTags;
  bool? get frozen;
  List<ChannelMemberRequest>? get invites;
  List<ChannelMemberRequest>? get members;
  String? get team;
  String? get truncatedById;

  /// Create a copy of ChannelInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelInputCopyWith<ChannelInput> get copyWith => _$ChannelInputCopyWithImpl<ChannelInput>(
    this as ChannelInput,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelInput &&
            (identical(other.autoTranslationEnabled, autoTranslationEnabled) ||
                other.autoTranslationEnabled == autoTranslationEnabled) &&
            (identical(
                  other.autoTranslationLanguage,
                  autoTranslationLanguage,
                ) ||
                other.autoTranslationLanguage == autoTranslationLanguage) &&
            (identical(other.configOverrides, configOverrides) || other.configOverrides == configOverrides) &&
            (identical(other.createdBy, createdBy) || other.createdBy == createdBy) &&
            (identical(other.createdById, createdById) || other.createdById == createdById) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.disabled, disabled) || other.disabled == disabled) &&
            const DeepCollectionEquality().equals(
              other.filterTags,
              filterTags,
            ) &&
            (identical(other.frozen, frozen) || other.frozen == frozen) &&
            const DeepCollectionEquality().equals(other.invites, invites) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.truncatedById, truncatedById) || other.truncatedById == truncatedById));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    autoTranslationEnabled,
    autoTranslationLanguage,
    configOverrides,
    createdBy,
    createdById,
    const DeepCollectionEquality().hash(custom),
    disabled,
    const DeepCollectionEquality().hash(filterTags),
    frozen,
    const DeepCollectionEquality().hash(invites),
    const DeepCollectionEquality().hash(members),
    team,
    truncatedById,
  );

  @override
  String toString() {
    return 'ChannelInput(autoTranslationEnabled: $autoTranslationEnabled, autoTranslationLanguage: $autoTranslationLanguage, configOverrides: $configOverrides, createdBy: $createdBy, createdById: $createdById, custom: $custom, disabled: $disabled, filterTags: $filterTags, frozen: $frozen, invites: $invites, members: $members, team: $team, truncatedById: $truncatedById)';
  }
}

/// @nodoc
abstract mixin class $ChannelInputCopyWith<$Res> {
  factory $ChannelInputCopyWith(
    ChannelInput value,
    $Res Function(ChannelInput) _then,
  ) = _$ChannelInputCopyWithImpl;
  @useResult
  $Res call({
    bool? autoTranslationEnabled,
    String? autoTranslationLanguage,
    ChannelConfigOverrides? configOverrides,
    UserRequest? createdBy,
    String? createdById,
    Map<String, Object?>? custom,
    bool? disabled,
    List<String>? filterTags,
    bool? frozen,
    List<ChannelMemberRequest>? invites,
    List<ChannelMemberRequest>? members,
    String? team,
    String? truncatedById,
  });
}

/// @nodoc
class _$ChannelInputCopyWithImpl<$Res> implements $ChannelInputCopyWith<$Res> {
  _$ChannelInputCopyWithImpl(this._self, this._then);

  final ChannelInput _self;
  final $Res Function(ChannelInput) _then;

  /// Create a copy of ChannelInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoTranslationEnabled = freezed,
    Object? autoTranslationLanguage = freezed,
    Object? configOverrides = freezed,
    Object? createdBy = freezed,
    Object? createdById = freezed,
    Object? custom = freezed,
    Object? disabled = freezed,
    Object? filterTags = freezed,
    Object? frozen = freezed,
    Object? invites = freezed,
    Object? members = freezed,
    Object? team = freezed,
    Object? truncatedById = freezed,
  }) {
    return _then(
      ChannelInput(
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
                  as ChannelConfigOverrides?,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as UserRequest?,
        createdById: freezed == createdById
            ? _self.createdById
            : createdById // ignore: cast_nullable_to_non_nullable
                  as String?,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        disabled: freezed == disabled
            ? _self.disabled
            : disabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        filterTags: freezed == filterTags
            ? _self.filterTags
            : filterTags // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
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
        truncatedById: freezed == truncatedById
            ? _self.truncatedById
            : truncatedById // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
