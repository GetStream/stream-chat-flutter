import 'package:json_annotation/json_annotation.dart';
import '../../client/client.dart';
import '../../ws/events/event.dart';
import '../models/banned_user.dart';
import '../models/converters/v1_json_converters.dart';
import '../models/location.dart';
import '../models/push_preference.dart';
import '../models/user.dart';

part 'responses.g.dart';

class _BaseResponse {
  String? duration;
}

/// The error payload the API returns on a failed request.
@JsonSerializable()
class ErrorResponse extends _BaseResponse {
  /// The error code identifying why the request failed.
  int? code;

  /// The message associated to the error code
  String? message;

  /// The HTTP status of the failed request.
  @JsonKey(name: 'StatusCode')
  int? statusCode;

  /// A detailed message about the error
  String? moreInfo;

  /// Create a new instance from a json
  static ErrorResponse fromJson(Map<String, dynamic> json) => _$ErrorResponseFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @override
  String toString() =>
      'ErrorResponse(code: $code, '
      'message: $message, '
      'statusCode: $statusCode, '
      'moreInfo: $moreInfo)';
}

/// Model response for [StreamChatClient.sync] api call
@JsonSerializable(createToJson: false)
class SyncResponse extends _BaseResponse {
  /// The list of events
  @JsonKey(defaultValue: [])
  late List<Event> events;

  /// Create a new instance from a json
  static SyncResponse fromJson(Map<String, dynamic> json) => _$SyncResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryUsers] api call
@JsonSerializable(createToJson: false)
class QueryUsersResponse extends _BaseResponse {
  /// List of users returned by the query
  @JsonKey(defaultValue: [])
  late List<User> users;

  /// Create a new instance from a json
  static QueryUsersResponse fromJson(Map<String, dynamic> json) => _$QueryUsersResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryBannedUsers] api call
@JsonSerializable(createToJson: false)
class QueryBannedUsersResponse extends _BaseResponse {
  /// List of users returned by the query
  @JsonKey(defaultValue: [])
  late List<BannedUser> bans;

  /// Create a new instance from a json
  static QueryBannedUsersResponse fromJson(Map<String, dynamic> json) => _$QueryBannedUsersResponseFromJson(json);
}

/// Model response for empty responses
@JsonSerializable(createToJson: false)
class EmptyResponse extends _BaseResponse {
  /// Create a new instance from a json
  static EmptyResponse fromJson(Map<String, dynamic> json) => _$EmptyResponseFromJson(json);
}

/// Model response for [StreamChatClient.setPushPreferences] api call
@JsonSerializable(createToJson: false)
class UpsertPushPreferencesResponse extends _BaseResponse {
  /// Mapping of user IDs to their push preferences.
  ///
  /// Users whose user-global preferences were not touched by the upsert call
  /// are omitted from this map.
  @JsonKey(fromJson: _userPreferencesFromJson)
  late Map<String, PushPreference> userPreferences;

  /// Mapping of user IDs to their channel-specific push preferences
  @JsonKey(defaultValue: {})
  late Map<String, Map<String, ChannelPushPreference>> userChannelPreferences;

  /// Create a new instance from a json
  static UpsertPushPreferencesResponse fromJson(Map<String, dynamic> json) =>
      _$UpsertPushPreferencesResponseFromJson(json);
}

Map<String, PushPreference> _userPreferencesFromJson(Map<String, dynamic>? json) {
  if (json == null) return {};
  return {
    for (final MapEntry(:key, :value) in json.entries)
      if (value != null) key: PushPreference.fromJson(value as Map<String, dynamic>),
  };
}

/// Model response for [StreamChatClient.getActiveLiveLocations] api call
@JsonSerializable(createToJson: false)
class GetActiveLiveLocationsResponse extends _BaseResponse {
  /// List of active live locations returned by the api call
  @LocationV1JsonConverter()
  late List<Location> activeLiveLocations;

  /// Create a new instance from a json
  static GetActiveLiveLocationsResponse fromJson(Map<String, dynamic> json) =>
      _$GetActiveLiveLocationsResponseFromJson(json);
}
