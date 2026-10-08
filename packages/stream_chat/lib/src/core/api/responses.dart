import 'package:json_annotation/json_annotation.dart';
import '../../client/client.dart';
import '../../ws/events/event.dart';
import '../models/banned_user.dart';
import '../models/channel_model.dart';
import '../models/channel_state.dart';
import '../models/converters/v1_json_converters.dart';
import '../models/draft.dart';
import '../models/location.dart';
import '../models/member.dart';
import '../models/message.dart';
import '../models/message_reminder.dart';
import '../models/predefined_filter.dart';
import '../models/push_preference.dart';
import '../models/reaction.dart';
import '../models/read.dart';
import '../models/thread.dart';
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

/// Model response for [StreamChatClient.queryChannels] api call
@JsonSerializable(createToJson: false)
class QueryChannelsResponse extends _BaseResponse {
  /// List of channels state returned by the query
  @JsonKey(defaultValue: [])
  late List<ChannelState> channels;

  /// The predefined filter the query named, as resolved for it.
  ///
  /// Null when the query named no predefined filter.
  @JsonKey(name: 'predefined_filter')
  PredefinedFilter? predefinedFilter;

  /// Create a new instance from a json
  static QueryChannelsResponse fromJson(Map<String, dynamic> json) => _$QueryChannelsResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryChannels] api call
@JsonSerializable(createToJson: false)
class TranslateMessageResponse extends MessageResponse {
  /// Create a new instance from a json
  static TranslateMessageResponse fromJson(Map<String, dynamic> json) => _$TranslateMessageResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryChannels] api call
@JsonSerializable(createToJson: false)
class QueryMembersResponse extends _BaseResponse {
  /// List of channels state returned by the query
  @JsonKey(defaultValue: [])
  late List<Member> members;

  /// Create a new instance from a json
  static QueryMembersResponse fromJson(Map<String, dynamic> json) => _$QueryMembersResponseFromJson(json);
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

/// Model response for [channel.getReactions] or [channel.queryReactions] api call
@JsonSerializable(createToJson: false)
class QueryReactionsResponse extends _BaseResponse {
  /// List of reactions returned by the query
  @JsonKey(defaultValue: [])
  @ReactionV1JsonConverter()
  late List<Reaction> reactions;

  /// The cursor for the next page of results.
  ///
  /// Will be `null` if there are no more results.
  late String? next;

  /// Create a new instance from a json
  static QueryReactionsResponse fromJson(Map<String, dynamic> json) => _$QueryReactionsResponseFromJson(json);
}

/// Model response for [Channel.getReplies] api call
@JsonSerializable(createToJson: false)
class QueryRepliesResponse extends _BaseResponse {
  /// List of messages returned by the api call
  @JsonKey(defaultValue: [])
  late List<Message> messages;

  /// Create a new instance from a json
  static QueryRepliesResponse fromJson(Map<String, dynamic> json) => _$QueryRepliesResponseFromJson(json);
}

/// Model response for [Channel.sendReaction] api call
@JsonSerializable(createToJson: false)
class SendReactionResponse extends MessageResponse {
  /// The reaction created by the api call
  @ReactionV1JsonConverter()
  late Reaction reaction;

  /// Create a new instance from a json
  static SendReactionResponse fromJson(Map<String, dynamic> json) => _$SendReactionResponseFromJson(json);
}

/// Base Model response for message based api calls.
class MessageResponse extends _BaseResponse {
  /// Message returned by the api call
  late Message message;
}

/// Model response for [StreamChatClient.updateMessage] api call
@JsonSerializable(createToJson: false)
class UpdateMessageResponse extends MessageResponse {
  /// Create a new instance from a json
  static UpdateMessageResponse fromJson(Map<String, dynamic> json) => _$UpdateMessageResponseFromJson(json);
}

/// Model response for [Channel.sendMessage] api call
@JsonSerializable(createToJson: false)
class SendMessageResponse extends MessageResponse {
  /// Create a new instance from a json
  static SendMessageResponse fromJson(Map<String, dynamic> json) => _$SendMessageResponseFromJson(json);
}

/// Model response for [StreamChatClient.getMessage] api call
@JsonSerializable(createToJson: false)
class GetMessageResponse extends MessageResponse {
  /// Channel of the message
  ChannelModel? channel;

  /// Create a new instance from a json
  static GetMessageResponse fromJson(Map<String, dynamic> json) {
    final res = _$GetMessageResponseFromJson(json);
    final jsonChannel = res.message.extraData.remove('channel');
    if (jsonChannel != null) {
      res.channel = ChannelModel.fromJson(jsonChannel as Map<String, dynamic>);
    }
    return res;
  }
}

/// Model response for [StreamChatClient.search] api call
@JsonSerializable(createToJson: false)
class SearchMessagesResponse extends _BaseResponse {
  /// List of messages returned by the api call
  @JsonKey(defaultValue: [])
  late List<GetMessageResponse> results;

  /// Message id of where to start searching from for next [results]
  late String? next;

  /// Message id of where to start searching from for previous [results]
  late String? previous;

  /// Create a new instance from a json
  static SearchMessagesResponse fromJson(Map<String, dynamic> json) => _$SearchMessagesResponseFromJson(json);
}

/// Model response for [Channel.getMessagesById] api call
@JsonSerializable(createToJson: false)
class GetMessagesByIdResponse extends _BaseResponse {
  /// Message returned by the api call
  @JsonKey(defaultValue: [])
  late List<Message> messages;

  /// Create a new instance from a json
  static GetMessagesByIdResponse fromJson(Map<String, dynamic> json) => _$GetMessagesByIdResponseFromJson(json);
}

/// Model response for [Channel.update] api call
@JsonSerializable(createToJson: false)
class UpdateChannelResponse extends _BaseResponse {
  /// Updated channel
  late ChannelModel channel;

  /// Channel members
  List<Member>? members;

  /// Message returned by the api call
  Message? message;

  /// Create a new instance from a json
  static UpdateChannelResponse fromJson(Map<String, dynamic> json) => _$UpdateChannelResponseFromJson(json);
}

/// Model response for [Channel.inviteMembers] api call
@JsonSerializable(createToJson: false)
class InviteMembersResponse extends _BaseResponse {
  /// Updated channel
  late ChannelModel channel;

  /// Channel members
  @JsonKey(defaultValue: [])
  late List<Member> members;

  /// Message returned by the api call
  Message? message;

  /// Create a new instance from a json
  static InviteMembersResponse fromJson(Map<String, dynamic> json) => _$InviteMembersResponseFromJson(json);
}

/// Model response for [Channel.removeMembers] api call
@JsonSerializable(createToJson: false)
class RemoveMembersResponse extends _BaseResponse {
  /// Updated channel
  late ChannelModel channel;

  /// Channel members
  @JsonKey(defaultValue: [])
  late List<Member> members;

  /// Message returned by the api call
  Message? message;

  /// Create a new instance from a json
  static RemoveMembersResponse fromJson(Map<String, dynamic> json) => _$RemoveMembersResponseFromJson(json);
}

/// Model response for [Channel.sendAction] api call
@JsonSerializable(createToJson: false)
class SendActionResponse extends _BaseResponse {
  /// Message returned by the api call
  Message? message;

  /// Create a new instance from a json
  static SendActionResponse fromJson(Map<String, dynamic> json) => _$SendActionResponseFromJson(json);
}

/// Model response for [Channel.addMembers] api call
@JsonSerializable(createToJson: false)
class AddMembersResponse extends _BaseResponse {
  /// Updated channel
  late ChannelModel channel;

  /// Channel members
  @JsonKey(defaultValue: [])
  late List<Member> members;

  /// Message returned by the api call
  Message? message;

  /// Create a new instance from a json
  static AddMembersResponse fromJson(Map<String, dynamic> json) => _$AddMembersResponseFromJson(json);
}

/// Model response for [Channel.acceptInvite] api call
@JsonSerializable(createToJson: false)
class AcceptInviteResponse extends _BaseResponse {
  /// Updated channel
  late ChannelModel channel;

  /// Channel members
  @JsonKey(defaultValue: [])
  late List<Member> members;

  /// Message returned by the api call
  Message? message;

  /// Create a new instance from a json
  static AcceptInviteResponse fromJson(Map<String, dynamic> json) => _$AcceptInviteResponseFromJson(json);
}

/// Model response for [Channel.rejectInvite] api call
@JsonSerializable(createToJson: false)
class RejectInviteResponse extends _BaseResponse {
  /// Updated channel
  late ChannelModel channel;

  /// Channel members
  @JsonKey(defaultValue: [])
  late List<Member> members;

  /// Message returned by the api call
  Message? message;

  /// Create a new instance from a json
  static RejectInviteResponse fromJson(Map<String, dynamic> json) => _$RejectInviteResponseFromJson(json);
}

/// Model response for empty responses
@JsonSerializable(createToJson: false)
class EmptyResponse extends _BaseResponse {
  /// Create a new instance from a json
  static EmptyResponse fromJson(Map<String, dynamic> json) => _$EmptyResponseFromJson(json);
}

/// Model response for [Channel.query] api call
@JsonSerializable(createToJson: false)
class ChannelStateResponse extends _BaseResponse {
  /// Updated channel
  late ChannelModel channel;

  /// List of messages returned by the api call
  @JsonKey(defaultValue: [])
  late List<Message> messages;

  /// Channel members
  @JsonKey(defaultValue: [])
  late List<Member> members;

  /// Number of users watching the channel
  @JsonKey(defaultValue: 0)
  late int watcherCount;

  /// List of read states
  @JsonKey(defaultValue: [])
  late List<Read> read;

  /// Create a new instance from a json
  static ChannelStateResponse fromJson(Map<String, dynamic> json) => _$ChannelStateResponseFromJson(json);
}

/// Model response for [StreamChatClient.getThread] api call
@JsonSerializable(createToJson: false)
class GetThreadResponse extends _BaseResponse {
  /// The thread returned by the api call
  late Thread thread;

  /// Create a new instance from a json
  static GetThreadResponse fromJson(Map<String, dynamic> json) => _$GetThreadResponseFromJson(json);
}

/// Model response for [StreamChatClient.updateThread] api call
@JsonSerializable(createToJson: false)
class UpdateThreadResponse extends _BaseResponse {
  /// The thread returned by the api call
  late Thread thread;

  /// Create a new instance from a json
  static UpdateThreadResponse fromJson(Map<String, dynamic> json) => _$UpdateThreadResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryThreads] api call
@JsonSerializable(createToJson: false)
class QueryThreadsResponse extends _BaseResponse {
  /// List of threads returned by the query
  @JsonKey(defaultValue: [])
  late List<Thread> threads;

  /// The next page token
  late String? next;

  /// Create a new instance from a json
  static QueryThreadsResponse fromJson(Map<String, dynamic> json) => _$QueryThreadsResponseFromJson(json);
}

/// Base Model response for draft based api calls.
class DraftResponse extends _BaseResponse {
  /// Draft returned by the api call
  late Draft draft;
}

/// Model response for [StreamChatClient.createDraft] api call
@JsonSerializable(createToJson: false)
class CreateDraftResponse extends DraftResponse {
  /// Create a new instance from a json
  static CreateDraftResponse fromJson(Map<String, dynamic> json) => _$CreateDraftResponseFromJson(json);
}

/// Model response for [StreamChatClient.getDraft] api call
@JsonSerializable(createToJson: false)
class GetDraftResponse extends DraftResponse {
  /// Create a new instance from a json
  static GetDraftResponse fromJson(Map<String, dynamic> json) => _$GetDraftResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryDrafts] api call
@JsonSerializable(createToJson: false)
class QueryDraftsResponse extends _BaseResponse {
  /// List of draft messages returned by the query
  @JsonKey(defaultValue: [])
  late List<Draft> drafts;

  /// The next page token
  late String? next;

  /// Create a new instance from a json
  static QueryDraftsResponse fromJson(Map<String, dynamic> json) => _$QueryDraftsResponseFromJson(json);
}

/// Base Model response for draft based api calls.
class MessageReminderResponse extends _BaseResponse {
  /// Draft returned by the api call
  late MessageReminder reminder;
}

/// Model response for [StreamChatClient.createReminder] api call
@JsonSerializable(createToJson: false)
class CreateReminderResponse extends MessageReminderResponse {
  /// Create a new instance from a json
  static CreateReminderResponse fromJson(Map<String, dynamic> json) => _$CreateReminderResponseFromJson(json);
}

/// Model response for [StreamChatClient.updateReminder] api call
@JsonSerializable(createToJson: false)
class UpdateReminderResponse extends MessageReminderResponse {
  /// Create a new instance from a json
  static UpdateReminderResponse fromJson(Map<String, dynamic> json) => _$UpdateReminderResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryReminders] api call
@JsonSerializable(createToJson: false)
class QueryRemindersResponse extends _BaseResponse {
  /// List of reminders returned by the query
  @JsonKey(defaultValue: [])
  late List<MessageReminder> reminders;

  /// The next page token
  late String? next;

  /// Create a new instance from a json
  static QueryRemindersResponse fromJson(Map<String, dynamic> json) => _$QueryRemindersResponseFromJson(json);
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
