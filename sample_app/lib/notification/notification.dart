import 'package:sample_app/utils/serializer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A push notification delivered by Stream Chat.
///
/// All Stream Chat push events share a single flat payload shape — a
/// discriminator [type] plus the fields below. Branch on [type] (or the
/// `isMessageNew` / `isReactionNew` / … getters) when you need event-specific
/// behaviour; otherwise just read [cid], [messageId], [title], [body].
class ChatNotification {
  const ChatNotification({
    required this.sender,
    required this.type,
    required this.cid,
    this.messageId,
    this.receiverId,
    this.title,
    this.body,
    this.custom = const {},
  });

  /// Parses a Stream Chat push payload into a [ChatNotification].
  ///
  /// Unknown keys are collected into [custom]. Missing required fields
  /// default to empty strings so a malformed payload doesn't throw — use
  /// [isStreamChat] to filter out non-Stream pushes before acting on them.
  factory ChatNotification.fromJson(Map<String, dynamic> json) {
    final processed = Serializer.moveToExtraData(json, _topLevelFields);
    return ChatNotification(
      sender: processed['sender'] as String? ?? '',
      type: processed['type'] as String? ?? '',
      cid: processed['cid'] as String? ?? '',
      // Stream v2 push templates use `id`; older payloads used `message_id`.
      messageId: (processed['id'] ?? processed['message_id']) as String?,
      receiverId: processed['receiver_id'] as String?,
      title: processed['title'] as String?,
      body: processed['body'] as String?,
      custom: (processed[Serializer.defaultExtraDataKey] as Map?)?.cast<String, Object?>() ?? const {},
    );
  }

  /// Usually `"stream.chat"`. Use [isStreamChat] to filter.
  final String sender;

  /// Event type string, e.g. `"message.new"`, `"reaction.new"`,
  /// `"notification.reminder_due"`.
  final String type;

  /// Channel identifier (`"channel_type:channel_id"`).
  final String cid;

  /// ID of the message the event relates to, or `null` if not applicable.
  final String? messageId;

  /// Recipient user id as resolved by Stream at send time.
  final String? receiverId;

  /// Display title from the APNs/FCM alert payload.
  final String? title;

  /// Display body from the APNs/FCM alert payload.
  final String? body;

  /// Any payload fields not explicitly modeled above.
  final Map<String, Object?> custom;

  bool get isStreamChat => sender == 'stream.chat';

  bool get isMessageNew => type == EventType.messageNew || type == EventType.notificationMessageNew;

  bool get isMessageUpdated => type == EventType.messageUpdated;

  bool get isReactionNew => type == EventType.reactionNew;

  bool get isReminderDue => type == EventType.notificationReminderDue;

  /// Inverse of [fromJson]: emits the push payload shape, with any entries
  /// from [custom] flattened back into the root. This way
  /// `ChatNotification.fromJson(n.toJson())` round-trips cleanly.
  Map<String, Object?> toJson() => Serializer.moveFromExtraData({
    'sender': sender,
    'type': type,
    'cid': cid,
    if (messageId != null) 'id': messageId,
    if (receiverId != null) 'receiver_id': receiverId,
    if (title != null) 'title': title,
    if (body != null) 'body': body,
    Serializer.defaultExtraDataKey: custom,
  });

  static const _topLevelFields = [
    'sender',
    'type',
    'cid',
    'id',
    'message_id',
    'receiver_id',
    'title',
    'body',
  ];
}
