import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/client.dart';
import 'package:stream_chat/src/models/channel_model.dart';
import 'package:stream_chat/src/models/channel_state.dart';
import 'package:stream_chat/src/models/device.dart';
import 'package:stream_chat/src/models/event.dart';
import 'package:stream_chat/src/models/member.dart';
import 'package:stream_chat/src/models/message.dart';
import 'package:stream_chat/src/models/reaction.dart';
import 'package:stream_chat/src/models/read.dart';
import 'package:stream_chat/src/models/user.dart';

part 'responses.g.dart';

class _BaseResponse {
  String duration;
}

/// Model response for [StreamChatClient.resync] api call
@JsonSerializable(createToJson: false)
class SyncResponse extends _BaseResponse {
  /// The list of events
  List<Event> events;

  /// Create a new instance from a json
  static SyncResponse fromJson(Map<String, dynamic> json) =>
      _$SyncResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryChannels] api call
@JsonSerializable(createToJson: false)
class QueryChannelsResponse extends _BaseResponse {
  /// List of channels state returned by the query
  List<ChannelState> channels;

  /// Create a new instance from a json
  static QueryChannelsResponse fromJson(Map<String, dynamic> json) =>
      _$QueryChannelsResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryChannels] api call
@JsonSerializable(createToJson: false)
class TranslateMessageResponse extends _BaseResponse {
  /// List of channels state returned by the query
  TranslatedMessage message;

  /// Create a new instance from a json
  static TranslateMessageResponse fromJson(Map<String, dynamic> json) =>
      _$TranslateMessageResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryChannels] api call
@JsonSerializable(createToJson: false)
class QueryMembersResponse extends _BaseResponse {
  /// List of channels state returned by the query
  List<Member> members;

  /// Create a new instance from a json
  static QueryMembersResponse fromJson(Map<String, dynamic> json) =>
      _$QueryMembersResponseFromJson(json);
}

/// Model response for [StreamChatClient.queryUsers] api call
@JsonSerializable(createToJson: false)
class QueryUsersResponse extends _BaseResponse {
  /// List of users returned by the query
  List<User> users;

  /// Create a new instance from a json
  static QueryUsersResponse fromJson(Map<String, dynamic> json) =>
      _$QueryUsersResponseFromJson(json);
}

/// Model response for [channel.getReactions] api call
@JsonSerializable(createToJson: false)
class QueryReactionsResponse extends _BaseResponse {
  /// List of reactions returned by the query
  List<Reaction> reactions;

  /// Create a new instance from a json
  static QueryReactionsResponse fromJson(Map<String, dynamic> json) =>
      _$QueryReactionsResponseFromJson(json);
}

/// Model response for [Channel.getReplies] api call
@JsonSerializable(createToJson: false)
class QueryRepliesResponse extends _BaseResponse {
  /// List of messages returned by the api call
  List<Message> messages;

  /// Create a new instance from a json
  static QueryRepliesResponse fromJson(Map<String, dynamic> json) =>
      _$QueryRepliesResponseFromJson(json);
}

/// Model response for [StreamChatClient.getDevices] api call
@JsonSerializable(createToJson: false)
class ListDevicesResponse extends _BaseResponse {
  /// List of user devices
  List<Device> devices;

  /// Create a new instance from a json
  static ListDevicesResponse fromJson(Map<String, dynamic> json) =>
      _$ListDevicesResponseFromJson(json);
}

/// Model response for [Channel.sendFile] api call
@JsonSerializable(createToJson: false)
class SendFileResponse extends _BaseResponse {
  /// The url of the uploaded file
  String file;

  /// Create a new instance from a json
  static SendFileResponse fromJson(Map<String, dynamic> json) =>
      _$SendFileResponseFromJson(json);
}

/// Model response for [Channel.sendImage] api call
@JsonSerializable(createToJson: false)
class SendImageResponse extends _BaseResponse {
  /// The url of the uploaded file
  String file;

  /// Create a new instance from a json
  static SendImageResponse fromJson(Map<String, dynamic> json) =>
      _$SendImageResponseFromJson(json);
}

/// Model response for [Channel.sendReaction] api call
@JsonSerializable(createToJson: false)
class SendReactionResponse extends _BaseResponse {
  /// Message returned by the api call
  Message message;

  /// The reaction created by the api call
  Reaction reaction;

  /// Create a new instance from a json
  static SendReactionResponse fromJson(Map<String, dynamic> json) =>
      _$SendReactionResponseFromJson(json);
}

/// Model response for [StreamChatClient.connectGuestUser] api call
@JsonSerializable(createToJson: false)
class ConnectGuestUserResponse extends _BaseResponse {
  /// Guest user access token
  String accessToken;

  /// Guest user
  User user;

  /// Create a new instance from a json
  static ConnectGuestUserResponse fromJson(Map<String, dynamic> json) =>
      _$ConnectGuestUserResponseFromJson(json);
}

/// Model response for [StreamChatClient.updateUser] api call
@JsonSerializable(createToJson: false)
class UpdateUsersResponse extends _BaseResponse {
  /// Updated users
  Map<String, User> users;

  /// Create a new instance from a json
  static UpdateUsersResponse fromJson(Map<String, dynamic> json) =>
      _$UpdateUsersResponseFromJson(json);
}

/// Model response for [StreamChatClient.updateMessage] api call
@JsonSerializable(createToJson: false)
class UpdateMessageResponse extends _BaseResponse {
  /// Message returned by the api call
  Message message;

  /// Create a new instance from a json
  static UpdateMessageResponse fromJson(Map<String, dynamic> json) =>
      _$UpdateMessageResponseFromJson(json);
}

/// Model response for [Channel.sendMessage] api call
@JsonSerializable(createToJson: false)
class SendMessageResponse extends _BaseResponse {
  /// Message returned by the api call
  Message message;

  /// Create a new instance from a json
  static SendMessageResponse fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseFromJson(json);
}

/// Model response for [StreamChatClient.getMessage] api call
@JsonSerializable(createToJson: false)
class GetMessageResponse extends _BaseResponse {
  /// Message returned by the api call
  Message message;

  /// Channel of the message
  ChannelModel channel;

  /// Create a new instance from a json
  static GetMessageResponse fromJson(Map<String, dynamic> json) {
    final res = _$GetMessageResponseFromJson(json);
    final jsonChannel = res.message?.extraData?.remove('channel');
    if (jsonChannel != null) {
      res.channel = ChannelModel.fromJson(jsonChannel);
    }
    return res;
  }
}

/// Model response for [StreamChatClient.search] api call
@JsonSerializable(createToJson: false)
class SearchMessagesResponse extends _BaseResponse {
  /// List of messages returned by the api call
  List<GetMessageResponse> results;

  /// Create a new instance from a json
  static SearchMessagesResponse fromJson(Map<String, dynamic> json) =>
      _$SearchMessagesResponseFromJson(json);
}

/// Model response for [Channel.getMessagesById] api call
@JsonSerializable(createToJson: false)
class GetMessagesByIdResponse extends _BaseResponse {
  /// Message returned by the api call
  List<Message> messages;

  /// Create a new instance from a json
  static GetMessagesByIdResponse fromJson(Map<String, dynamic> json) =>
      _$GetMessagesByIdResponseFromJson(json);
}

/// Model response for [Channel.update] api call
@JsonSerializable(createToJson: false)
class UpdateChannelResponse extends _BaseResponse {
  /// Updated channel
  ChannelModel channel;

  /// Channel members
  List<Member> members;

  /// Message returned by the api call
  Message message;

  /// Create a new instance from a json
  static UpdateChannelResponse fromJson(Map<String, dynamic> json) =>
      _$UpdateChannelResponseFromJson(json);
}

/// Model response for [Channel.updatePartial] api call
@JsonSerializable(createToJson: false)
class PartialUpdateChannelResponse extends _BaseResponse {
  /// Updated channel
  ChannelModel channel;

  /// Channel members
  List<Member> members;

  /// Create a new instance from a json
  static PartialUpdateChannelResponse fromJson(Map<String, dynamic> json) =>
      _$PartialUpdateChannelResponseFromJson(json);
}

/// Model response for [Channel.inviteMembers] api call
@JsonSerializable(createToJson: false)
class InviteMembersResponse extends _BaseResponse {
  /// Updated channel
  ChannelModel channel;

  /// Channel members
  List<Member> members;

  /// Message returned by the api call
  Message message;

  /// Create a new instance from a json
  static InviteMembersResponse fromJson(Map<String, dynamic> json) =>
      _$InviteMembersResponseFromJson(json);
}

/// Model response for [Channel.removeMembers] api call
@JsonSerializable(createToJson: false)
class RemoveMembersResponse extends _BaseResponse {
  /// Updated channel
  ChannelModel channel;

  /// Channel members
  List<Member> members;

  /// Message returned by the api call
  Message message;

  /// Create a new instance from a json
  static RemoveMembersResponse fromJson(Map<String, dynamic> json) =>
      _$RemoveMembersResponseFromJson(json);
}

/// Model response for [Channel.sendAction] api call
@JsonSerializable(createToJson: false)
class SendActionResponse extends _BaseResponse {
  /// Message returned by the api call
  Message message;

  /// Create a new instance from a json
  static SendActionResponse fromJson(Map<String, dynamic> json) =>
      _$SendActionResponseFromJson(json);
}

/// Model response for [Channel.addMembers] api call
@JsonSerializable(createToJson: false)
class AddMembersResponse extends _BaseResponse {
  /// Updated channel
  ChannelModel channel;

  /// Channel members
  List<Member> members;

  /// Message returned by the api call
  Message message;

  /// Create a new instance from a json
  static AddMembersResponse fromJson(Map<String, dynamic> json) =>
      _$AddMembersResponseFromJson(json);
}

/// Model response for [Channel.acceptInvite] api call
@JsonSerializable(createToJson: false)
class AcceptInviteResponse extends _BaseResponse {
  /// Updated channel
  ChannelModel channel;

  /// Channel members
  List<Member> members;

  /// Message returned by the api call
  Message message;

  /// Create a new instance from a json
  static AcceptInviteResponse fromJson(Map<String, dynamic> json) =>
      _$AcceptInviteResponseFromJson(json);
}

/// Model response for [Channel.rejectInvite] api call
@JsonSerializable(createToJson: false)
class RejectInviteResponse extends _BaseResponse {
  /// Updated channel
  ChannelModel channel;

  /// Channel members
  List<Member> members;

  /// Message returned by the api call
  Message message;

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
  ChannelModel channel;

  /// List of messages returned by the api call
  List<Message> messages;

  /// Channel members
  List<Member> members;

  /// Number of users watching the channel
  int watcherCount;

  /// List of read states
  List<Read> read;

  /// Create a new instance from a json
  static ChannelStateResponse fromJson(Map<String, dynamic> json) =>
      _$ChannelStateResponseFromJson(json);
}
