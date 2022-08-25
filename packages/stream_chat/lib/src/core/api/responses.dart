import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/client/client.dart';
import 'package:stream_chat/src/core/api/call_api.dart';
import 'package:stream_chat/src/core/error/error.dart';
import 'package:stream_chat/src/core/models/banned_user.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/channel_state.dart';
import 'package:stream_chat/src/core/models/device.dart';
import 'package:stream_chat/src/core/models/event.dart';
import 'package:stream_chat/src/core/models/member.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/reaction.dart';
import 'package:stream_chat/src/core/models/read.dart';
import 'package:stream_chat/src/core/models/user.dart';

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
class TranslateMessageResponse extends _BaseResponse {
  /// Translated message
  late Message message;

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

/// Model response for [Channel.sendFile] api call
@JsonSerializable(createToJson: false)
class SendFileResponse extends _BaseResponse {
  /// The url of the uploaded file
  late String file;

  /// Create a new instance from a json
  static SendFileResponse fromJson(Map<String, dynamic> json) =>
      _$SendFileResponseFromJson(json);
}

/// Model response for [Channel.sendImage] api call
@JsonSerializable(createToJson: false)
class SendImageResponse extends _BaseResponse {
  /// The url of the uploaded file
  late String file;

  /// Create a new instance from a json
  static SendImageResponse fromJson(Map<String, dynamic> json) =>
      _$SendImageResponseFromJson(json);
}

/// Model response for [Channel.sendReaction] api call
@JsonSerializable(createToJson: false)
class SendReactionResponse extends _BaseResponse {
  /// Message returned by the api call
  late Message message;

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

/// Model response for [StreamChatClient.updateMessage] api call
@JsonSerializable(createToJson: false)
class UpdateMessageResponse extends _BaseResponse {
  /// Message returned by the api call
  late Message message;

  /// Create a new instance from a json
  static UpdateMessageResponse fromJson(Map<String, dynamic> json) =>
      _$UpdateMessageResponseFromJson(json);
}

/// Model response for [Channel.sendMessage] api call
@JsonSerializable(createToJson: false)
class SendMessageResponse extends _BaseResponse {
  /// Message returned by the api call
  late Message message;

  /// Create a new instance from a json
  static SendMessageResponse fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseFromJson(json);
}

/// Model response for [StreamChatClient.getMessage] api call
@JsonSerializable(createToJson: false)
class GetMessageResponse extends _BaseResponse {
  /// Message returned by the api call
  late Message message;

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

/// Payload for Agora call.
@JsonSerializable(createToJson: false)
class AgoraPayload {
  /// Create a new instance.
  const AgoraPayload({required this.channel});

  /// Create a new instance from a [json].
  factory AgoraPayload.fromJson(Map<String, dynamic> json) =>
      _$AgoraPayloadFromJson(json);

  /// The Agora channel.
  final String channel;
}

/// Model containing the information about a call.
@JsonSerializable(createToJson: false)
class CallPayload extends Equatable {
  /// Create a new instance.
  const CallPayload({
    required this.id,
    required this.provider,
    this.agora,
    this.hms,
  });

  /// Create a new instance from a [json].
  factory CallPayload.fromJson(Map<String, dynamic> json) =>
      _$CallPayloadFromJson(json);

  /// The call id.
  final String id;

  /// The call provider.
  final String provider;

  /// The payload specific to Agora.
  final AgoraPayload? agora;

  /// The payload specific to 100ms.
  final HMSPayload? hms;

  @override
  List<Object?> get props => [id, provider, agora, hms];
}

/// The response to [CallApi.getCallToken]
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
@JsonSerializable(createToJson: false)
class CreateCallPayload extends _BaseResponse {
  /// Create a new instance from a [json].
  static CreateCallPayload fromJson(Map<String, dynamic> json) =>
      _$CreateCallPayloadFromJson(json);

  /// The call object.
  CallPayload? call;
}

/// Payload for 100ms call.
@JsonSerializable(createToJson: false)
class HMSPayload extends Equatable {
  /// Create a new instance.
  const HMSPayload({required this.roomId, required this.roomName});

  /// Create a new instance from a [json].
  factory HMSPayload.fromJson(Map<String, dynamic> json) =>
      _$HMSPayloadFromJson(json);

  /// The id of the 100ms room.
  final String roomId;

  /// The name of the 100ms room.
  final String roomName;

  @override
  List<Object?> get props => [roomId, roomName];
}
