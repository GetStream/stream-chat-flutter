// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_preference_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushPreferenceInput {
  String? get channelCid;
  PushPreferenceInputChatLevel? get chatLevel;
  ChatPreferencesInput? get chatPreferences;
  DateTime? get disabledUntil;
  bool? get removeDisable;
  bool? get removeSchedule;
  PushScheduleInput? get schedule;
  String? get userId;

  /// Create a copy of PushPreferenceInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PushPreferenceInputCopyWith<PushPreferenceInput> get copyWith =>
      _$PushPreferenceInputCopyWithImpl<PushPreferenceInput>(
        this as PushPreferenceInput,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PushPreferenceInput &&
            (identical(other.channelCid, channelCid) || other.channelCid == channelCid) &&
            (identical(other.chatLevel, chatLevel) || other.chatLevel == chatLevel) &&
            (identical(other.chatPreferences, chatPreferences) || other.chatPreferences == chatPreferences) &&
            (identical(other.disabledUntil, disabledUntil) || other.disabledUntil == disabledUntil) &&
            (identical(other.removeDisable, removeDisable) || other.removeDisable == removeDisable) &&
            (identical(other.removeSchedule, removeSchedule) || other.removeSchedule == removeSchedule) &&
            (identical(other.schedule, schedule) || other.schedule == schedule) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelCid,
    chatLevel,
    chatPreferences,
    disabledUntil,
    removeDisable,
    removeSchedule,
    schedule,
    userId,
  );

  @override
  String toString() {
    return 'PushPreferenceInput(channelCid: $channelCid, chatLevel: $chatLevel, chatPreferences: $chatPreferences, disabledUntil: $disabledUntil, removeDisable: $removeDisable, removeSchedule: $removeSchedule, schedule: $schedule, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $PushPreferenceInputCopyWith<$Res> {
  factory $PushPreferenceInputCopyWith(
    PushPreferenceInput value,
    $Res Function(PushPreferenceInput) _then,
  ) = _$PushPreferenceInputCopyWithImpl;
  @useResult
  $Res call({
    String? channelCid,
    PushPreferenceInputChatLevel? chatLevel,
    ChatPreferencesInput? chatPreferences,
    DateTime? disabledUntil,
    bool? removeDisable,
    bool? removeSchedule,
    PushScheduleInput? schedule,
    String? userId,
  });
}

/// @nodoc
class _$PushPreferenceInputCopyWithImpl<$Res> implements $PushPreferenceInputCopyWith<$Res> {
  _$PushPreferenceInputCopyWithImpl(this._self, this._then);

  final PushPreferenceInput _self;
  final $Res Function(PushPreferenceInput) _then;

  /// Create a copy of PushPreferenceInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelCid = freezed,
    Object? chatLevel = freezed,
    Object? chatPreferences = freezed,
    Object? disabledUntil = freezed,
    Object? removeDisable = freezed,
    Object? removeSchedule = freezed,
    Object? schedule = freezed,
    Object? userId = freezed,
  }) {
    return _then(
      PushPreferenceInput(
        channelCid: freezed == channelCid
            ? _self.channelCid
            : channelCid // ignore: cast_nullable_to_non_nullable
                  as String?,
        chatLevel: freezed == chatLevel
            ? _self.chatLevel
            : chatLevel // ignore: cast_nullable_to_non_nullable
                  as PushPreferenceInputChatLevel?,
        chatPreferences: freezed == chatPreferences
            ? _self.chatPreferences
            : chatPreferences // ignore: cast_nullable_to_non_nullable
                  as ChatPreferencesInput?,
        disabledUntil: freezed == disabledUntil
            ? _self.disabledUntil
            : disabledUntil // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        removeDisable: freezed == removeDisable
            ? _self.removeDisable
            : removeDisable // ignore: cast_nullable_to_non_nullable
                  as bool?,
        removeSchedule: freezed == removeSchedule
            ? _self.removeSchedule
            : removeSchedule // ignore: cast_nullable_to_non_nullable
                  as bool?,
        schedule: freezed == schedule
            ? _self.schedule
            : schedule // ignore: cast_nullable_to_non_nullable
                  as PushScheduleInput?,
        userId: freezed == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
