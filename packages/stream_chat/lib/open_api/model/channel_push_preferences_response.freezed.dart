// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_push_preferences_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelPushPreferencesResponse {
  String? get chatLevel;
  ChatPreferencesResponse? get chatPreferences;
  DateTime? get disabledUntil;

  /// Create a copy of ChannelPushPreferencesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelPushPreferencesResponseCopyWith<ChannelPushPreferencesResponse>
  get copyWith =>
      _$ChannelPushPreferencesResponseCopyWithImpl<
        ChannelPushPreferencesResponse
      >(this as ChannelPushPreferencesResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelPushPreferencesResponse &&
            (identical(other.chatLevel, chatLevel) ||
                other.chatLevel == chatLevel) &&
            (identical(other.chatPreferences, chatPreferences) ||
                other.chatPreferences == chatPreferences) &&
            (identical(other.disabledUntil, disabledUntil) ||
                other.disabledUntil == disabledUntil));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, chatLevel, chatPreferences, disabledUntil);

  @override
  String toString() {
    return 'ChannelPushPreferencesResponse(chatLevel: $chatLevel, chatPreferences: $chatPreferences, disabledUntil: $disabledUntil)';
  }
}

/// @nodoc
abstract mixin class $ChannelPushPreferencesResponseCopyWith<$Res> {
  factory $ChannelPushPreferencesResponseCopyWith(
    ChannelPushPreferencesResponse value,
    $Res Function(ChannelPushPreferencesResponse) _then,
  ) = _$ChannelPushPreferencesResponseCopyWithImpl;
  @useResult
  $Res call({
    String? chatLevel,
    ChatPreferencesResponse? chatPreferences,
    DateTime? disabledUntil,
  });
}

/// @nodoc
class _$ChannelPushPreferencesResponseCopyWithImpl<$Res>
    implements $ChannelPushPreferencesResponseCopyWith<$Res> {
  _$ChannelPushPreferencesResponseCopyWithImpl(this._self, this._then);

  final ChannelPushPreferencesResponse _self;
  final $Res Function(ChannelPushPreferencesResponse) _then;

  /// Create a copy of ChannelPushPreferencesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chatLevel = freezed,
    Object? chatPreferences = freezed,
    Object? disabledUntil = freezed,
  }) {
    return _then(
      ChannelPushPreferencesResponse(
        chatLevel: freezed == chatLevel
            ? _self.chatLevel
            : chatLevel // ignore: cast_nullable_to_non_nullable
                  as String?,
        chatPreferences: freezed == chatPreferences
            ? _self.chatPreferences
            : chatPreferences // ignore: cast_nullable_to_non_nullable
                  as ChatPreferencesResponse?,
        disabledUntil: freezed == disabledUntil
            ? _self.disabledUntil
            : disabledUntil // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}
