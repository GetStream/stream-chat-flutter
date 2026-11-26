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

QueryUsersResponse _$QueryUsersResponseFromJson(Map<String, dynamic> json) => QueryUsersResponse()
  ..duration = json['duration'] as String?
  ..users = (json['users'] as List<dynamic>?)?.map((e) => User.fromJson(e as Map<String, dynamic>)).toList() ?? [];

QueryBannedUsersResponse _$QueryBannedUsersResponseFromJson(Map<String, dynamic> json) => QueryBannedUsersResponse()
  ..duration = json['duration'] as String?
  ..bans = (json['bans'] as List<dynamic>?)?.map((e) => BannedUser.fromJson(e as Map<String, dynamic>)).toList() ?? [];

EmptyResponse _$EmptyResponseFromJson(Map<String, dynamic> json) =>
    EmptyResponse()..duration = json['duration'] as String?;

QueryScheduledMessagesResponse _$QueryScheduledMessagesResponseFromJson(
  Map<String, dynamic> json,
) => QueryScheduledMessagesResponse()
  ..duration = json['duration'] as String?
  ..scheduledMessages =
      (json['scheduled_messages'] as List<dynamic>?)
          ?.map((e) => ScheduledMessage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..next = json['next'] as String?;

ScheduleMessageResponse _$ScheduleMessageResponseFromJson(
  Map<String, dynamic> json,
) => ScheduleMessageResponse()
  ..duration = json['duration'] as String?
  ..message = Message.fromJson(json['message'] as Map<String, dynamic>)
  ..scheduledMessage = json['scheduled_message'] == null
      ? null
      : ScheduledMessage.fromJson(
          json['scheduled_message'] as Map<String, dynamic>,
        );

UpdateScheduledMessageResponse _$UpdateScheduledMessageResponseFromJson(
  Map<String, dynamic> json,
) => UpdateScheduledMessageResponse()
  ..duration = json['duration'] as String?
  ..scheduledMessage = ScheduledMessage.fromJson(
    json['scheduled_message'] as Map<String, dynamic>,
  );

DeleteScheduledMessageResponse _$DeleteScheduledMessageResponseFromJson(
  Map<String, dynamic> json,
) => DeleteScheduledMessageResponse()
  ..duration = json['duration'] as String?
  ..scheduledMessage = ScheduledMessage.fromJson(
    json['scheduled_message'] as Map<String, dynamic>,
  );

SendScheduledMessageNowResponse _$SendScheduledMessageNowResponseFromJson(
  Map<String, dynamic> json,
) => SendScheduledMessageNowResponse()
  ..duration = json['duration'] as String?
  ..scheduledMessage = ScheduledMessage.fromJson(
    json['scheduled_message'] as Map<String, dynamic>,
  );

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
