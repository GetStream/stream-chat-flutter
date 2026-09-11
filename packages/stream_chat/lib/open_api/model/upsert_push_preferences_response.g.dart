// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_push_preferences_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpsertPushPreferencesResponse _$UpsertPushPreferencesResponseFromJson(
  Map<String, dynamic> json,
) => UpsertPushPreferencesResponse(
  duration: json['duration'] as String,
  userChannelPreferences: (json['user_channel_preferences'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      (e as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          k,
          ChannelPushPreferencesResponse.fromJson(
            e as Map<String, dynamic>,
          ),
        ),
      ),
    ),
  ),
  userPreferences: (json['user_preferences'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      PushPreferencesResponse.fromJson(e as Map<String, dynamic>),
    ),
  ),
);

Map<String, dynamic> _$UpsertPushPreferencesResponseToJson(
  UpsertPushPreferencesResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'user_channel_preferences': instance.userChannelPreferences.map(
    (k, e) => MapEntry(k, e.map((k, e) => MapEntry(k, e.toJson()))),
  ),
  'user_preferences': instance.userPreferences.map(
    (k, e) => MapEntry(k, e.toJson()),
  ),
};
