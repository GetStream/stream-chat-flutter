// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse()
      ..duration = json['duration'] as String?
      ..code = json['code'] as int?
      ..message = json['message'] as String?
      ..statusCode = json['StatusCode'] as int?
      ..moreInfo = json['more_info'] as String?;

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'code': instance.code,
      'message': instance.message,
      'StatusCode': instance.statusCode,
      'more_info': instance.moreInfo,
    };

SyncResponse _$SyncResponseFromJson(Map<String, dynamic> json) => SyncResponse()
  ..duration = json['duration'] as String?
  ..events = (json['events'] as List<dynamic>?)
          ?.map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [];

QueryChannelsResponse _$QueryChannelsResponseFromJson(
        Map<String, dynamic> json) =>
    QueryChannelsResponse()
      ..duration = json['duration'] as String?
      ..channels = (json['channels'] as List<dynamic>?)
              ?.map((e) => ChannelState.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

TranslateMessageResponse _$TranslateMessageResponseFromJson(
        Map<String, dynamic> json) =>
    TranslateMessageResponse()
      ..duration = json['duration'] as String?
      ..message = Message.fromJson(json['message'] as Map<String, dynamic>);

QueryMembersResponse _$QueryMembersResponseFromJson(
        Map<String, dynamic> json) =>
    QueryMembersResponse()
      ..duration = json['duration'] as String?
      ..members = (json['members'] as List<dynamic>?)
              ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

QueryUsersResponse _$QueryUsersResponseFromJson(Map<String, dynamic> json) =>
    QueryUsersResponse()
      ..duration = json['duration'] as String?
      ..users = (json['users'] as List<dynamic>?)
              ?.map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

QueryBannedUsersResponse _$QueryBannedUsersResponseFromJson(
        Map<String, dynamic> json) =>
    QueryBannedUsersResponse()
      ..duration = json['duration'] as String?
      ..bans = (json['bans'] as List<dynamic>?)
              ?.map((e) => BannedUser.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

QueryReactionsResponse _$QueryReactionsResponseFromJson(
        Map<String, dynamic> json) =>
    QueryReactionsResponse()
      ..duration = json['duration'] as String?
      ..reactions = (json['reactions'] as List<dynamic>?)
              ?.map((e) => Reaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

QueryRepliesResponse _$QueryRepliesResponseFromJson(
        Map<String, dynamic> json) =>
    QueryRepliesResponse()
      ..duration = json['duration'] as String?
      ..messages = (json['messages'] as List<dynamic>?)
              ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

ListDevicesResponse _$ListDevicesResponseFromJson(Map<String, dynamic> json) =>
    ListDevicesResponse()
      ..duration = json['duration'] as String?
      ..devices = (json['devices'] as List<dynamic>?)
              ?.map((e) => Device.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

SendFileResponse _$SendFileResponseFromJson(Map<String, dynamic> json) =>
    SendFileResponse()
      ..duration = json['duration'] as String?
      ..file = json['file'] as String;

SendImageResponse _$SendImageResponseFromJson(Map<String, dynamic> json) =>
    SendImageResponse()
      ..duration = json['duration'] as String?
      ..file = json['file'] as String;

SendReactionResponse _$SendReactionResponseFromJson(
        Map<String, dynamic> json) =>
    SendReactionResponse()
      ..duration = json['duration'] as String?
      ..message = Message.fromJson(json['message'] as Map<String, dynamic>)
      ..reaction = Reaction.fromJson(json['reaction'] as Map<String, dynamic>);

ConnectGuestUserResponse _$ConnectGuestUserResponseFromJson(
        Map<String, dynamic> json) =>
    ConnectGuestUserResponse()
      ..duration = json['duration'] as String?
      ..accessToken = json['access_token'] as String
      ..user = User.fromJson(json['user'] as Map<String, dynamic>);

UpdateUsersResponse _$UpdateUsersResponseFromJson(Map<String, dynamic> json) =>
    UpdateUsersResponse()
      ..duration = json['duration'] as String?
      ..users = (json['users'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, User.fromJson(e as Map<String, dynamic>)),
          ) ??
          {};

UpdateMessageResponse _$UpdateMessageResponseFromJson(
        Map<String, dynamic> json) =>
    UpdateMessageResponse()
      ..duration = json['duration'] as String?
      ..message = Message.fromJson(json['message'] as Map<String, dynamic>);

SendMessageResponse _$SendMessageResponseFromJson(Map<String, dynamic> json) =>
    SendMessageResponse()
      ..duration = json['duration'] as String?
      ..message = Message.fromJson(json['message'] as Map<String, dynamic>);

GetMessageResponse _$GetMessageResponseFromJson(Map<String, dynamic> json) =>
    GetMessageResponse()
      ..duration = json['duration'] as String?
      ..message = Message.fromJson(json['message'] as Map<String, dynamic>)
      ..channel = json['channel'] == null
          ? null
          : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>);

SearchMessagesResponse _$SearchMessagesResponseFromJson(
        Map<String, dynamic> json) =>
    SearchMessagesResponse()
      ..duration = json['duration'] as String?
      ..results = (json['results'] as List<dynamic>?)
              ?.map(
                  (e) => GetMessageResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..next = json['next'] as String?
      ..previous = json['previous'] as String?;

GetMessagesByIdResponse _$GetMessagesByIdResponseFromJson(
        Map<String, dynamic> json) =>
    GetMessagesByIdResponse()
      ..duration = json['duration'] as String?
      ..messages = (json['messages'] as List<dynamic>?)
              ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

UpdateChannelResponse _$UpdateChannelResponseFromJson(
        Map<String, dynamic> json) =>
    UpdateChannelResponse()
      ..duration = json['duration'] as String?
      ..channel = ChannelModel.fromJson(json['channel'] as Map<String, dynamic>)
      ..members = (json['members'] as List<dynamic>?)
          ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList()
      ..message = json['message'] == null
          ? null
          : Message.fromJson(json['message'] as Map<String, dynamic>);

PartialUpdateChannelResponse _$PartialUpdateChannelResponseFromJson(
        Map<String, dynamic> json) =>
    PartialUpdateChannelResponse()
      ..duration = json['duration'] as String?
      ..channel = ChannelModel.fromJson(json['channel'] as Map<String, dynamic>)
      ..members = (json['members'] as List<dynamic>?)
          ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList();

InviteMembersResponse _$InviteMembersResponseFromJson(
        Map<String, dynamic> json) =>
    InviteMembersResponse()
      ..duration = json['duration'] as String?
      ..channel = ChannelModel.fromJson(json['channel'] as Map<String, dynamic>)
      ..members = (json['members'] as List<dynamic>?)
              ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..message = json['message'] == null
          ? null
          : Message.fromJson(json['message'] as Map<String, dynamic>);

RemoveMembersResponse _$RemoveMembersResponseFromJson(
        Map<String, dynamic> json) =>
    RemoveMembersResponse()
      ..duration = json['duration'] as String?
      ..channel = ChannelModel.fromJson(json['channel'] as Map<String, dynamic>)
      ..members = (json['members'] as List<dynamic>?)
              ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..message = json['message'] == null
          ? null
          : Message.fromJson(json['message'] as Map<String, dynamic>);

SendActionResponse _$SendActionResponseFromJson(Map<String, dynamic> json) =>
    SendActionResponse()
      ..duration = json['duration'] as String?
      ..message = json['message'] == null
          ? null
          : Message.fromJson(json['message'] as Map<String, dynamic>);

AddMembersResponse _$AddMembersResponseFromJson(Map<String, dynamic> json) =>
    AddMembersResponse()
      ..duration = json['duration'] as String?
      ..channel = ChannelModel.fromJson(json['channel'] as Map<String, dynamic>)
      ..members = (json['members'] as List<dynamic>?)
              ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..message = json['message'] == null
          ? null
          : Message.fromJson(json['message'] as Map<String, dynamic>);

AcceptInviteResponse _$AcceptInviteResponseFromJson(
        Map<String, dynamic> json) =>
    AcceptInviteResponse()
      ..duration = json['duration'] as String?
      ..channel = ChannelModel.fromJson(json['channel'] as Map<String, dynamic>)
      ..members = (json['members'] as List<dynamic>?)
              ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..message = json['message'] == null
          ? null
          : Message.fromJson(json['message'] as Map<String, dynamic>);

RejectInviteResponse _$RejectInviteResponseFromJson(
        Map<String, dynamic> json) =>
    RejectInviteResponse()
      ..duration = json['duration'] as String?
      ..channel = ChannelModel.fromJson(json['channel'] as Map<String, dynamic>)
      ..members = (json['members'] as List<dynamic>?)
              ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..message = json['message'] == null
          ? null
          : Message.fromJson(json['message'] as Map<String, dynamic>);

EmptyResponse _$EmptyResponseFromJson(Map<String, dynamic> json) =>
    EmptyResponse()..duration = json['duration'] as String?;

ChannelStateResponse _$ChannelStateResponseFromJson(
        Map<String, dynamic> json) =>
    ChannelStateResponse()
      ..duration = json['duration'] as String?
      ..channel = ChannelModel.fromJson(json['channel'] as Map<String, dynamic>)
      ..messages = (json['messages'] as List<dynamic>?)
              ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..members = (json['members'] as List<dynamic>?)
              ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..watcherCount = json['watcher_count'] as int? ?? 0
      ..read = (json['read'] as List<dynamic>?)
              ?.map((e) => Read.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

OGAttachmentResponse _$OGAttachmentResponseFromJson(
        Map<String, dynamic> json) =>
    OGAttachmentResponse()
      ..duration = json['duration'] as String?
      ..ogScrapeUrl = json['og_scrape_url'] as String
      ..assetUrl = json['asset_url'] as String?
      ..authorLink = json['author_link'] as String?
      ..authorName = json['author_name'] as String?
      ..imageUrl = json['image_url'] as String?
      ..text = json['text'] as String?
      ..thumbUrl = json['thumb_url'] as String?
      ..title = json['title'] as String?
      ..titleLink = json['title_link'] as String?
      ..type = json['type'] as String?;

CallTokenPayload _$CallTokenPayloadFromJson(Map<String, dynamic> json) =>
    CallTokenPayload()
      ..duration = json['duration'] as String?
      ..token = json['token'] as String?
      ..agoraUid = json['agora_uid'] as int?
      ..agoraAppId = json['agora_app_id'] as String?;

CreateCallPayload _$CreateCallPayloadFromJson(Map<String, dynamic> json) =>
    CreateCallPayload()
      ..duration = json['duration'] as String?
      ..call = json['call'] == null
          ? null
          : CallPayload.fromJson(json['call'] as Map<String, dynamic>);
