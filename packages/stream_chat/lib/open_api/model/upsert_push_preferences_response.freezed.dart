// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upsert_push_preferences_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpsertPushPreferencesResponse {
  String get duration;
  Map<String, Map<String, ChannelPushPreferencesResponse>>
  get userChannelPreferences;
  Map<String, PushPreferencesResponse> get userPreferences;

  /// Create a copy of UpsertPushPreferencesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpsertPushPreferencesResponseCopyWith<UpsertPushPreferencesResponse>
  get copyWith =>
      _$UpsertPushPreferencesResponseCopyWithImpl<
        UpsertPushPreferencesResponse
      >(this as UpsertPushPreferencesResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpsertPushPreferencesResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(
              other.userChannelPreferences,
              userChannelPreferences,
            ) &&
            const DeepCollectionEquality().equals(
              other.userPreferences,
              userPreferences,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(userChannelPreferences),
    const DeepCollectionEquality().hash(userPreferences),
  );

  @override
  String toString() {
    return 'UpsertPushPreferencesResponse(duration: $duration, userChannelPreferences: $userChannelPreferences, userPreferences: $userPreferences)';
  }
}

/// @nodoc
abstract mixin class $UpsertPushPreferencesResponseCopyWith<$Res> {
  factory $UpsertPushPreferencesResponseCopyWith(
    UpsertPushPreferencesResponse value,
    $Res Function(UpsertPushPreferencesResponse) _then,
  ) = _$UpsertPushPreferencesResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    Map<String, Map<String, ChannelPushPreferencesResponse>>
    userChannelPreferences,
    Map<String, PushPreferencesResponse> userPreferences,
  });
}

/// @nodoc
class _$UpsertPushPreferencesResponseCopyWithImpl<$Res>
    implements $UpsertPushPreferencesResponseCopyWith<$Res> {
  _$UpsertPushPreferencesResponseCopyWithImpl(this._self, this._then);

  final UpsertPushPreferencesResponse _self;
  final $Res Function(UpsertPushPreferencesResponse) _then;

  /// Create a copy of UpsertPushPreferencesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? userChannelPreferences = null,
    Object? userPreferences = null,
  }) {
    return _then(
      UpsertPushPreferencesResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        userChannelPreferences: null == userChannelPreferences
            ? _self.userChannelPreferences
            : userChannelPreferences // ignore: cast_nullable_to_non_nullable
                  as Map<String, Map<String, ChannelPushPreferencesResponse>>,
        userPreferences: null == userPreferences
            ? _self.userPreferences
            : userPreferences // ignore: cast_nullable_to_non_nullable
                  as Map<String, PushPreferencesResponse>,
      ),
    );
  }
}
