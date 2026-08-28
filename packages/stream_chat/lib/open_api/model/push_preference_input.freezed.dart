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
  PushPreferenceInputCallLevel? get callLevel;
  String? get channelCid;
  PushPreferenceInputChatLevel? get chatLevel;
  ChatPreferencesInput? get chatPreferences;
  DateTime? get disabledUntil;
  PushPreferenceInputFeedsLevel? get feedsLevel;
  FeedsPreferences? get feedsPreferences;
  bool? get removeDisable;
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
            (identical(other.callLevel, callLevel) ||
                other.callLevel == callLevel) &&
            (identical(other.channelCid, channelCid) ||
                other.channelCid == channelCid) &&
            (identical(other.chatLevel, chatLevel) ||
                other.chatLevel == chatLevel) &&
            (identical(other.chatPreferences, chatPreferences) ||
                other.chatPreferences == chatPreferences) &&
            (identical(other.disabledUntil, disabledUntil) ||
                other.disabledUntil == disabledUntil) &&
            (identical(other.feedsLevel, feedsLevel) ||
                other.feedsLevel == feedsLevel) &&
            (identical(other.feedsPreferences, feedsPreferences) ||
                other.feedsPreferences == feedsPreferences) &&
            (identical(other.removeDisable, removeDisable) ||
                other.removeDisable == removeDisable) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callLevel,
    channelCid,
    chatLevel,
    chatPreferences,
    disabledUntil,
    feedsLevel,
    feedsPreferences,
    removeDisable,
    userId,
  );

  @override
  String toString() {
    return 'PushPreferenceInput(callLevel: $callLevel, channelCid: $channelCid, chatLevel: $chatLevel, chatPreferences: $chatPreferences, disabledUntil: $disabledUntil, feedsLevel: $feedsLevel, feedsPreferences: $feedsPreferences, removeDisable: $removeDisable, userId: $userId)';
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
    PushPreferenceInputCallLevel? callLevel,
    String? channelCid,
    PushPreferenceInputChatLevel? chatLevel,
    ChatPreferencesInput? chatPreferences,
    DateTime? disabledUntil,
    PushPreferenceInputFeedsLevel? feedsLevel,
    FeedsPreferences? feedsPreferences,
    bool? removeDisable,
    String? userId,
  });
}

/// @nodoc
class _$PushPreferenceInputCopyWithImpl<$Res>
    implements $PushPreferenceInputCopyWith<$Res> {
  _$PushPreferenceInputCopyWithImpl(this._self, this._then);

  final PushPreferenceInput _self;
  final $Res Function(PushPreferenceInput) _then;

  /// Create a copy of PushPreferenceInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callLevel = freezed,
    Object? channelCid = freezed,
    Object? chatLevel = freezed,
    Object? chatPreferences = freezed,
    Object? disabledUntil = freezed,
    Object? feedsLevel = freezed,
    Object? feedsPreferences = freezed,
    Object? removeDisable = freezed,
    Object? userId = freezed,
  }) {
    return _then(
      PushPreferenceInput(
        callLevel: freezed == callLevel
            ? _self.callLevel
            : callLevel // ignore: cast_nullable_to_non_nullable
                  as PushPreferenceInputCallLevel?,
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
        feedsLevel: freezed == feedsLevel
            ? _self.feedsLevel
            : feedsLevel // ignore: cast_nullable_to_non_nullable
                  as PushPreferenceInputFeedsLevel?,
        feedsPreferences: freezed == feedsPreferences
            ? _self.feedsPreferences
            : feedsPreferences // ignore: cast_nullable_to_non_nullable
                  as FeedsPreferences?,
        removeDisable: freezed == removeDisable
            ? _self.removeDisable
            : removeDisable // ignore: cast_nullable_to_non_nullable
                  as bool?,
        userId: freezed == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
