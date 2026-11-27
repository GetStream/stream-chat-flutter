// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_push_preferences_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpsertPushPreferencesRequest _$UpsertPushPreferencesRequestFromJson(
  Map<String, dynamic> json,
) => UpsertPushPreferencesRequest(
  preferences: (json['preferences'] as List<dynamic>)
      .map((e) => PushPreferenceInput.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UpsertPushPreferencesRequestToJson(
  UpsertPushPreferencesRequest instance,
) => <String, dynamic>{
  'preferences': instance.preferences.map((e) => e.toJson()).toList(),
};
