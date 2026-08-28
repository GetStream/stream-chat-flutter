// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_preferences_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushPreferencesResponse {
  String? get callLevel;
  String? get chatLevel;
  ChatPreferencesResponse? get chatPreferences;
  DateTime? get disabledUntil;
  String? get feedsLevel;
  FeedsPreferencesResponse? get feedsPreferences;

  /// Create a copy of PushPreferencesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PushPreferencesResponseCopyWith<PushPreferencesResponse> get copyWith =>
      _$PushPreferencesResponseCopyWithImpl<PushPreferencesResponse>(
        this as PushPreferencesResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PushPreferencesResponse &&
            (identical(other.callLevel, callLevel) ||
                other.callLevel == callLevel) &&
            (identical(other.chatLevel, chatLevel) ||
                other.chatLevel == chatLevel) &&
            (identical(other.chatPreferences, chatPreferences) ||
                other.chatPreferences == chatPreferences) &&
            (identical(other.disabledUntil, disabledUntil) ||
                other.disabledUntil == disabledUntil) &&
            (identical(other.feedsLevel, feedsLevel) ||
                other.feedsLevel == feedsLevel) &&
            (identical(other.feedsPreferences, feedsPreferences) ||
                other.feedsPreferences == feedsPreferences));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callLevel,
    chatLevel,
    chatPreferences,
    disabledUntil,
    feedsLevel,
    feedsPreferences,
  );

  @override
  String toString() {
    return 'PushPreferencesResponse(callLevel: $callLevel, chatLevel: $chatLevel, chatPreferences: $chatPreferences, disabledUntil: $disabledUntil, feedsLevel: $feedsLevel, feedsPreferences: $feedsPreferences)';
  }
}

/// @nodoc
abstract mixin class $PushPreferencesResponseCopyWith<$Res> {
  factory $PushPreferencesResponseCopyWith(
    PushPreferencesResponse value,
    $Res Function(PushPreferencesResponse) _then,
  ) = _$PushPreferencesResponseCopyWithImpl;
  @useResult
  $Res call({
    String? callLevel,
    String? chatLevel,
    ChatPreferencesResponse? chatPreferences,
    DateTime? disabledUntil,
    String? feedsLevel,
    FeedsPreferencesResponse? feedsPreferences,
  });
}

/// @nodoc
class _$PushPreferencesResponseCopyWithImpl<$Res>
    implements $PushPreferencesResponseCopyWith<$Res> {
  _$PushPreferencesResponseCopyWithImpl(this._self, this._then);

  final PushPreferencesResponse _self;
  final $Res Function(PushPreferencesResponse) _then;

  /// Create a copy of PushPreferencesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callLevel = freezed,
    Object? chatLevel = freezed,
    Object? chatPreferences = freezed,
    Object? disabledUntil = freezed,
    Object? feedsLevel = freezed,
    Object? feedsPreferences = freezed,
  }) {
    return _then(
      PushPreferencesResponse(
        callLevel: freezed == callLevel
            ? _self.callLevel
            : callLevel // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        feedsLevel: freezed == feedsLevel
            ? _self.feedsLevel
            : feedsLevel // ignore: cast_nullable_to_non_nullable
                  as String?,
        feedsPreferences: freezed == feedsPreferences
            ? _self.feedsPreferences
            : feedsPreferences // ignore: cast_nullable_to_non_nullable
                  as FeedsPreferencesResponse?,
      ),
    );
  }
}
