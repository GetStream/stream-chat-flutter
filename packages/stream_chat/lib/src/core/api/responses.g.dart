// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) => ErrorResponse()
  ..duration = json['duration'] as String?
  ..code = (json['code'] as num?)?.toInt()
  ..message = json['message'] as String?
  ..statusCode = (json['StatusCode'] as num?)?.toInt()
  ..moreInfo = json['more_info'] as String?;

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) => <String, dynamic>{
  'duration': instance.duration,
  'code': instance.code,
  'message': instance.message,
  'StatusCode': instance.statusCode,
  'more_info': instance.moreInfo,
};

SyncResponse _$SyncResponseFromJson(Map<String, dynamic> json) => SyncResponse()
  ..duration = json['duration'] as String?
  ..events = (json['events'] as List<dynamic>?)?.map((e) => Event.fromJson(e as Map<String, dynamic>)).toList() ?? [];

QueryUsersResponse _$QueryUsersResponseFromJson(Map<String, dynamic> json) => QueryUsersResponse()
  ..duration = json['duration'] as String?
  ..users = (json['users'] as List<dynamic>?)?.map((e) => User.fromJson(e as Map<String, dynamic>)).toList() ?? [];

QueryBannedUsersResponse _$QueryBannedUsersResponseFromJson(Map<String, dynamic> json) => QueryBannedUsersResponse()
  ..duration = json['duration'] as String?
  ..bans = (json['bans'] as List<dynamic>?)?.map((e) => BannedUser.fromJson(e as Map<String, dynamic>)).toList() ?? [];

EmptyResponse _$EmptyResponseFromJson(Map<String, dynamic> json) =>
    EmptyResponse()..duration = json['duration'] as String?;

UpsertPushPreferencesResponse _$UpsertPushPreferencesResponseFromJson(Map<String, dynamic> json) =>
    UpsertPushPreferencesResponse()
      ..duration = json['duration'] as String?
      ..userPreferences = _userPreferencesFromJson(json['user_preferences'] as Map<String, dynamic>?)
      ..userChannelPreferences =
          (json['user_channel_preferences'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, ChannelPushPreference.fromJson(e as Map<String, dynamic>)),
              ),
            ),
          ) ??
          {};

GetActiveLiveLocationsResponse _$GetActiveLiveLocationsResponseFromJson(Map<String, dynamic> json) =>
    GetActiveLiveLocationsResponse()
      ..duration = json['duration'] as String?
      ..activeLiveLocations = (json['active_live_locations'] as List<dynamic>)
          .map((e) => const LocationV1JsonConverter().fromJson(e as Map<String, dynamic>))
          .toList();
