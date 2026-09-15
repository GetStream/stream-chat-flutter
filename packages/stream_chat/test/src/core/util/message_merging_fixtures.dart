import 'package:stream_chat/stream_chat.dart';

Message message(
  String id, {
  DateTime? createdAt,
  String? text,
  String? parentId,
  bool? showInChannel,
  String? quotedMessageId,
  Message? quotedMessage,
  bool pinned = false,
  DateTime? pinExpires,
  String type = MessageType.regular,
  Location? sharedLocation,
}) {
  return Message(
    id: id,
    createdAt: createdAt ?? DateTime(2024),
    text: text,
    parentId: parentId,
    showInChannel: showInChannel,
    quotedMessageId: quotedMessageId,
    quotedMessage: quotedMessage,
    pinned: pinned,
    pinExpires: pinExpires,
    type: type,
    sharedLocation: sharedLocation,
  );
}

Location sharedLocation({
  String? messageId,
  String? userId = 'user-id',
  String? channelCid = 'messaging:channel-id',
  String? createdByDeviceId = 'device-id',
  DateTime? endAt,
  double latitude = 0,
  double longitude = 0,
}) {
  return Location(
    messageId: messageId,
    userId: userId,
    channelCid: channelCid,
    createdByDeviceId: createdByDeviceId,
    endAt: endAt,
    latitude: latitude,
    longitude: longitude,
  );
}

Iterable<String?> ids(Iterable<Message> messages) => messages.map((it) => it.id);
