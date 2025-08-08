import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/client/client.dart';
import 'package:stream_chat/src/core/api/call_api.dart';
import 'package:stream_chat/src/core/error/error.dart';
import 'package:stream_chat/src/core/models/banned_user.dart';
import 'package:stream_chat/src/core/models/call_payload.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/channel_state.dart';
import 'package:stream_chat/src/core/models/device.dart';
import 'package:stream_chat/src/core/models/draft.dart';
import 'package:stream_chat/src/core/models/event.dart';
import 'package:stream_chat/src/core/models/member.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/message_reminder.dart';
import 'package:stream_chat/src/core/models/poll.dart';
import 'package:stream_chat/src/core/models/poll_option.dart';
import 'package:stream_chat/src/core/models/poll_vote.dart';
import 'package:stream_chat/src/core/models/push_preference.dart';
import 'package:stream_chat/src/core/models/reaction.dart';
import 'package:stream_chat/src/core/models/read.dart';
import 'package:stream_chat/src/core/models/thread.dart';
import 'package:stream_chat/src/core/models/unread_counts.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/models/user_block.dart';

part 'responses.g.dart';

class _BaseResponse {
  String? duration;
}

/// Model response for [StreamChatNetworkError] data
@JsonSerializable()
class ErrorResponse extends _BaseResponse {
  /// The http error code
  int? code;

  /// The message associated to the error code
  String? message;

  /// The backend error code
  @JsonKey(name: 'StatusCode')
  int? statusCode;

  /// A detailed message about the error
  String? moreInfo;

  /// Create a new instance from a json
  static ErrorResponse fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @override
  String toString() => 'ErrorResponse(code: $code, '
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
  static SyncResponse fromJson(Map<String, dynamic> json) =>
      _$SyncResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryChannels] api call
@JsonSerializable(createToJson: false)
class QueryChannelsResponse extends _BaseResponse {
  /// List of channels state returned by the query
  @JsonKey(defaultValue: [])
  late List<ChannelState> channels;

  /// Create a new instance from a json
  static QueryChannelsResponse fromJson(Map<String, dynamic> json) =>
      _$QueryChannelsResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryChannels] api call
@JsonSerializable(createToJson: false)
class TranslateMessageResponse extends MessageResponse {
  /// Create a new instance from a json
  static TranslateMessageResponse fromJson(Map<String, dynamic> json) =>
      _$TranslateMessageResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryChannels] api call
@JsonSerializable(createToJson: false)
class QueryMembersResponse extends _BaseResponse {
  /// List of channels state returned by the query
  @JsonKey(defaultValue: [])
  late List<Member> members;

  /// Create a new instance from a json
  static QueryMembersResponse fromJson(Map<String, dynamic> json) =>
      _$QueryMembersResponseFromJson(json);
}

/// Model response for update member API calls, such as
/// [StreamChatClient.updateMemberPartial]
@JsonSerializable(createToJson: false)
class PartialUpdateMemberResponse extends _BaseResponse {
  /// The updated member state
  late Member channelMember;

  /// Create a new instance from a json
  static PartialUpdateMemberResponse fromJson(Map<String, dynamic> json) =>
      _$PartialUpdateMemberResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryUsers] api call
@JsonSerializable(createToJson: false)
class QueryUsersResponse extends _BaseResponse {
  /// List of users returned by the query
  @JsonKey(defaultValue: [])
  late List<User> users;

  /// Create a new instance from a json
  static QueryUsersResponse fromJson(Map<String, dynamic> json) =>
      _$QueryUsersResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryBannedUsers] api call
@JsonSerializable(createToJson: false)
class QueryBannedUsersResponse extends _BaseResponse {
  /// List of users returned by the query
  @JsonKey(defaultValue: [])
  late List<BannedUser> bans;

  /// Create a new instance from a json
  static QueryBannedUsersResponse fromJson(Map<String, dynamic> json) =>
      _$QueryBannedUsersResponseFromJson(json);
}

/// Model response for [channel.getReactions] api call
@JsonSerializable(createToJson: false)
class QueryReactionsResponse extends _BaseResponse {
  /// List of reactions returned by the query
  @JsonKey(defaultValue: [])
  late List<Reaction> reactions;

  /// Create a new instance from a json
  static QueryReactionsResponse fromJson(Map<String, dynamic> json) =>
      _$QueryReactionsResponseFromJson(json);
}

/// Model response for [Channel.getReplies] api call
@JsonSerializable(createToJson: false)
class QueryRepliesResponse extends _BaseResponse {
  /// List of messages returned by the api call
  @JsonKey(defaultValue: [])
  late List<Message> messages;

  /// Create a new instance from a json
  static QueryRepliesResponse fromJson(Map<String, dynamic> json) =>
      _$QueryRepliesResponseFromJson(json);
}

/// Model response for [StreamChatClient.getDevices] api call
@JsonSerializable(createToJson: false)
class ListDevicesResponse extends _BaseResponse {
  /// List of user devices
  @JsonKey(defaultValue: [])
  late List<Device> devices;

  /// Create a new instance from a json
  static ListDevicesResponse fromJson(Map<String, dynamic> json) =>
      _$ListDevicesResponseFromJson(json);
}

/// Base Model response for [Channel.sendImage] and [Channel.sendFile] api call.
@JsonSerializable(createToJson: false)
class SendAttachmentResponse extends _BaseResponse {
  /// The url of the uploaded attachment.
  late String? file;

  /// Create a new instance from a json
  static SendAttachmentResponse fromJson(Map<String, dynamic> json) =>
      _$SendAttachmentResponseFromJson(json);
}

/// Model response for [Channel.sendFile] api call
@JsonSerializable(createToJson: false)
class SendFileResponse extends SendAttachmentResponse {
  /// The url of the uploaded video file.
  ///
  /// This is only present if the file is a video.
  String? thumbUrl;

  /// Create a new instance from a json
  static SendFileResponse fromJson(Map<String, dynamic> json) =>
      _$SendFileResponseFromJson(json);
}

/// Model response for [Channel.sendImage] api call
typedef SendImageResponse = SendAttachmentResponse;

/// Model response for [Channel.sendReaction] api call
@JsonSerializable(createToJson: false)
class SendReactionResponse extends MessageResponse {
  /// The reaction created by the api call
  late Reaction reaction;

  /// Create a new instance from a json
  static SendReactionResponse fromJson(Map<String, dynamic> json) =>
      _$SendReactionResponseFromJson(json);
}

/// Model response for [StreamChatClient.connectGuestUser] api call
@JsonSerializable(createToJson: false)
class ConnectGuestUserResponse extends _BaseResponse {
  /// Guest user access token
  late String accessToken;

  /// Guest user
  late User user;

  /// Create a new instance from a json
  static ConnectGuestUserResponse fromJson(Map<String, dynamic> json) =>
      _$ConnectGuestUserResponseFromJson(json);
}

/// Model response for [StreamChatClient.updateUser] api call
@JsonSerializable(createToJson: false)
class UpdateUsersResponse extends _BaseResponse {
  /// Updated users
  @JsonKey(defaultValue: {})
  late Map<String, User> users;

  /// Create a new instance from a json
  static UpdateUsersResponse fromJson(Map<String, dynamic> json) =>
      _$UpdateUsersResponseFromJson(json);
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
  static UpdateMessageResponse fromJson(Map<String, dynamic> json) =>
      _$UpdateMessageResponseFromJson(json);
}

/// Model response for [Channel.sendMessage] api call
@JsonSerializable(createToJson: false)
class SendMessageResponse extends MessageResponse {
  /// Create a new instance from a json
  static SendMessageResponse fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseFromJson(json);
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
  static SearchMessagesResponse fromJson(Map<String, dynamic> json) =>
      _$SearchMessagesResponseFromJson(json);
}

/// Model response for [Channel.getMessagesById] api call
@JsonSerializable(createToJson: false)
class GetMessagesByIdResponse extends _BaseResponse {
  /// Message returned by the api call
  @JsonKey(defaultValue: [])
  late List<Message> messages;

  /// Create a new instance from a json
  static GetMessagesByIdResponse fromJson(Map<String, dynamic> json) =>
      _$GetMessagesByIdResponseFromJson(json);
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
  static UpdateChannelResponse fromJson(Map<String, dynamic> json) =>
      _$UpdateChannelResponseFromJson(json);
}

/// Model response for [Channel.updatePartial] api call
@JsonSerializable(createToJson: false)
class PartialUpdateChannelResponse extends _BaseResponse {
  /// Updated channel
  late ChannelModel channel;

  /// Channel members
  List<Member>? members;

  /// Create a new instance from a json
  static PartialUpdateChannelResponse fromJson(Map<String, dynamic> json) =>
      _$PartialUpdateChannelResponseFromJson(json);
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
  static InviteMembersResponse fromJson(Map<String, dynamic> json) =>
      _$InviteMembersResponseFromJson(json);
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
  static RemoveMembersResponse fromJson(Map<String, dynamic> json) =>
      _$RemoveMembersResponseFromJson(json);
}

/// Model response for [Channel.sendAction] api call
@JsonSerializable(createToJson: false)
class SendActionResponse extends _BaseResponse {
  /// Message returned by the api call
  Message? message;

  /// Create a new instance from a json
  static SendActionResponse fromJson(Map<String, dynamic> json) =>
      _$SendActionResponseFromJson(json);
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
  static AddMembersResponse fromJson(Map<String, dynamic> json) =>
      _$AddMembersResponseFromJson(json);
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
  static AcceptInviteResponse fromJson(Map<String, dynamic> json) =>
      _$AcceptInviteResponseFromJson(json);
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
  static RejectInviteResponse fromJson(Map<String, dynamic> json) =>
      _$RejectInviteResponseFromJson(json);
}

/// Model response for empty responses
@JsonSerializable(createToJson: false)
class EmptyResponse extends _BaseResponse {
  /// Create a new instance from a json
  static EmptyResponse fromJson(Map<String, dynamic> json) =>
      _$EmptyResponseFromJson(json);
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
  static ChannelStateResponse fromJson(Map<String, dynamic> json) =>
      _$ChannelStateResponseFromJson(json);
}

/// Model response for [Client.enrichUrl] api call.
@JsonSerializable(createToJson: false)
class OGAttachmentResponse extends _BaseResponse {
  /// The URL of the page that was scraped.
  late String ogScrapeUrl;

  /// The URL of the asset.
  String? assetUrl;

  /// The URL of the author.
  String? authorLink;

  /// The name of the author.
  String? authorName;

  /// The URL of the image.
  String? imageUrl;

  /// The text of the attachment.
  String? text;

  /// The URL of the thumbnail.
  String? thumbUrl;

  /// The title of the attachment.
  String? title;

  /// The URL of the title.
  String? titleLink;

  /// The type of the attachment.
  ///
  /// 'video' | 'audio' | 'image'
  String? type;

  /// Create a new instance from a [json].
  static OGAttachmentResponse fromJson(Map<String, dynamic> json) =>
      _$OGAttachmentResponseFromJson(json);
}

/// The response to [CallApi.getCallToken]
@Deprecated('Will be removed in the next major version')
@JsonSerializable(createToJson: false)
class CallTokenPayload extends _BaseResponse {
  /// Create a new instance from a [json].
  static CallTokenPayload fromJson(Map<String, dynamic> json) =>
      _$CallTokenPayloadFromJson(json);

  /// The token to use for the call.
  String? token;

  /// The user id specific to Agora.
  int? agoraUid;

  /// The appId specific to Agora.
  String? agoraAppId;
}

/// The response to [CallApi.createCall]
@Deprecated('Will be removed in the next major version')
@JsonSerializable(createToJson: false)
class CreateCallPayload extends _BaseResponse {
  /// Create a new instance from a [json].
  static CreateCallPayload fromJson(Map<String, dynamic> json) =>
      _$CreateCallPayloadFromJson(json);

  /// The call object.
  CallPayload? call;
}

/// Contains information about a [User] that was banned from a [Channel] or App.
@JsonSerializable(createToJson: false)
class UserBlockResponse extends _BaseResponse {
  /// User that banned the [user].
  @JsonKey(defaultValue: '')
  late String blockedByUserId;

  /// Reason for the ban.
  @JsonKey(defaultValue: '')
  late String blockedUserId;

  /// Timestamp when the [user] was banned.
  late DateTime createdAt;

  /// Create a new instance from a json
  static UserBlockResponse fromJson(Map<String, dynamic> json) =>
      _$UserBlockResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryBlockedUsers] api call
@JsonSerializable(createToJson: false)
class BlockedUsersResponse extends _BaseResponse {
  /// Updated users
  @JsonKey(defaultValue: [])
  late List<UserBlock> blocks;

  /// Create a new instance from a json
  static BlockedUsersResponse fromJson(Map<String, dynamic> json) =>
      _$BlockedUsersResponseFromJson(json);
}

/// Model response for [StreamChatClient.createPoll] api call
@JsonSerializable(createToJson: false)
class CreatePollResponse extends _BaseResponse {
  /// Created poll
  late Poll poll;

  /// Create a new instance from a json
  static CreatePollResponse fromJson(Map<String, dynamic> json) =>
      _$CreatePollResponseFromJson(json);
}

/// Model response for [StreamChatClient.getPoll] api call
@JsonSerializable(createToJson: false)
class GetPollResponse extends _BaseResponse {
  /// Fetched poll
  late Poll poll;

  /// Create a new instance from a json
  static GetPollResponse fromJson(Map<String, dynamic> json) =>
      _$GetPollResponseFromJson(json);
}

/// Model response for [StreamChatClient.updatePoll] api call
@JsonSerializable(createToJson: false)
class UpdatePollResponse extends _BaseResponse {
  /// Updated poll
  late Poll poll;

  /// Create a new instance from a json
  static UpdatePollResponse fromJson(Map<String, dynamic> json) =>
      _$UpdatePollResponseFromJson(json);
}

/// Model response for [StreamChatClient.createPollOption] api call
@JsonSerializable(createToJson: false)
class CreatePollOptionResponse extends _BaseResponse {
  /// Created poll option
  late PollOption pollOption;

  /// Create a new instance from a json
  static CreatePollOptionResponse fromJson(Map<String, dynamic> json) =>
      _$CreatePollOptionResponseFromJson(json);
}

/// Model response for [StreamChatClient.getPollOption] api call
@JsonSerializable(createToJson: false)
class GetPollOptionResponse extends _BaseResponse {
  /// Fetched poll option
  late PollOption pollOption;

  /// Create a new instance from a json
  static GetPollOptionResponse fromJson(Map<String, dynamic> json) =>
      _$GetPollOptionResponseFromJson(json);
}

/// Model response for [StreamChatClient.updatePollOption] api call
@JsonSerializable(createToJson: false)
class UpdatePollOptionResponse extends _BaseResponse {
  /// Updated poll option
  late PollOption pollOption;

  /// Create a new instance from a json
  static UpdatePollOptionResponse fromJson(Map<String, dynamic> json) =>
      _$UpdatePollOptionResponseFromJson(json);
}

/// Model response for [StreamChatClient.castPollVote] api call
@JsonSerializable(createToJson: false)
class CastPollVoteResponse extends _BaseResponse {
  /// Casted vote
  late PollVote vote;

  /// Create a new instance from a json
  static CastPollVoteResponse fromJson(Map<String, dynamic> json) =>
      _$CastPollVoteResponseFromJson(json);
}

/// Model response for [StreamChatClient.removePollVote] api call
@JsonSerializable(createToJson: false)
class RemovePollVoteResponse extends EmptyResponse {
  /// Deleted vote
  late PollVote vote;

  /// Create a new instance from a json
  static RemovePollVoteResponse fromJson(Map<String, dynamic> json) =>
      _$RemovePollVoteResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryPolls] api call
@JsonSerializable(createToJson: false)
class QueryPollsResponse extends _BaseResponse {
  /// List of polls returned by the query
  @JsonKey(defaultValue: [])
  late List<Poll> polls;

  /// Poll id of where to start searching from for next [results]
  late String? next;

  /// Create a new instance from a json
  static QueryPollsResponse fromJson(Map<String, dynamic> json) =>
      _$QueryPollsResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryPollVotes] api call
@JsonSerializable(createToJson: false)
class QueryPollVotesResponse extends _BaseResponse {
  /// List of poll votes returned by the query
  @JsonKey(defaultValue: [])
  late List<PollVote> votes;

  /// Poll vote id of where to start searching from for next [results]
  late String? next;

  /// Create a new instance from a json
  static QueryPollVotesResponse fromJson(Map<String, dynamic> json) =>
      _$QueryPollVotesResponseFromJson(json);
}

/// Model response for [StreamChatClient.getThread] api call
@JsonSerializable(createToJson: false)
class GetThreadResponse extends _BaseResponse {
  /// The thread returned by the api call
  late Thread thread;

  /// Create a new instance from a json
  static GetThreadResponse fromJson(Map<String, dynamic> json) =>
      _$GetThreadResponseFromJson(json);
}

/// Model response for [StreamChatClient.updateThread] api call
@JsonSerializable(createToJson: false)
class UpdateThreadResponse extends _BaseResponse {
  /// The thread returned by the api call
  late Thread thread;

  /// Create a new instance from a json
  static UpdateThreadResponse fromJson(Map<String, dynamic> json) =>
      _$UpdateThreadResponseFromJson(json);
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
  static QueryThreadsResponse fromJson(Map<String, dynamic> json) =>
      _$QueryThreadsResponseFromJson(json);
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
  static CreateDraftResponse fromJson(Map<String, dynamic> json) =>
      _$CreateDraftResponseFromJson(json);
}

/// Model response for [StreamChatClient.getDraft] api call
@JsonSerializable(createToJson: false)
class GetDraftResponse extends DraftResponse {
  /// Create a new instance from a json
  static GetDraftResponse fromJson(Map<String, dynamic> json) =>
      _$GetDraftResponseFromJson(json);
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
  static QueryDraftsResponse fromJson(Map<String, dynamic> json) =>
      _$QueryDraftsResponseFromJson(json);
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
  static CreateReminderResponse fromJson(Map<String, dynamic> json) =>
      _$CreateReminderResponseFromJson(json);
}

/// Model response for [StreamChatClient.updateReminder] api call
@JsonSerializable(createToJson: false)
class UpdateReminderResponse extends MessageReminderResponse {
  /// Create a new instance from a json
  static UpdateReminderResponse fromJson(Map<String, dynamic> json) =>
      _$UpdateReminderResponseFromJson(json);
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
  static QueryRemindersResponse fromJson(Map<String, dynamic> json) =>
      _$QueryRemindersResponseFromJson(json);
}

/// Model response for [StreamChatClient.getUnreadCount] api call
@JsonSerializable(createToJson: false)
class GetUnreadCountResponse extends _BaseResponse {
  /// Total number of unread messages across all channels
  late int totalUnreadCount;

  /// Total number of threads with unread replies
  late int totalUnreadThreadsCount;

  /// Total number of unread messages grouped by team
  late Map<String, int>? totalUnreadCountByTeam;

  /// List of channels with unread messages
  late List<UnreadCountsChannel> channels;

  /// Summary of unread counts grouped by channel type
  late List<UnreadCountsChannelType> channelType;

  /// List of threads with unread replies
  late List<UnreadCountsThread> threads;

  /// Create a new instance from a json
  static GetUnreadCountResponse fromJson(Map<String, dynamic> json) =>
      _$GetUnreadCountResponseFromJson(json);
}

/// Model response for [DeviceApi.setPushPreferences] api call
@JsonSerializable(createToJson: false)
class UpsertPushPreferencesResponse extends _BaseResponse {
  /// Mapping of user IDs to their push preferences
  late Map<String, PushPreference> userPreferences;

  /// Mapping of user IDs to their channel-specific push preferences
  late Map<String, Map<String, ChannelPushPreference>> userChannelPreferences;

  /// Create a new instance from a json
  static UpsertPushPreferencesResponse fromJson(Map<String, dynamic> json) =>
      _$UpsertPushPreferencesResponseFromJson(json);
}
