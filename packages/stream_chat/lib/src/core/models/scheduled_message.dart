import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'channel_model.dart';
import 'message.dart';
import 'user.dart';

part 'scheduled_message.g.dart';

/// A message that is sent to its channel at [scheduledAt].
///
/// Until then, only its author sees it, and it can be edited, rescheduled,
/// sent right away or deleted. Once sent, it arrives in the channel as a
/// normal message with an ID of its own.
@JsonSerializable()
class ScheduledMessage extends Equatable {
  /// Creates a scheduled [message] for the channel [cid].
  const ScheduledMessage({
    required this.id,
    required this.cid,
    this.channel,
    required this.user,
    required this.message,
    required this.scheduledAt,
    required this.status,
    this.failureReason,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a scheduled message from [json].
  factory ScheduledMessage.fromJson(Map<String, dynamic> json) {
    final scheduled = _$ScheduledMessageFromJson(json);
    final content = json['message'] as Map<String, dynamic>? ?? const {};

    return scheduled.copyWith(
      message: _messageFromContent(content, id: scheduled.id, user: scheduled.user),
    );
  }

  /// The ID of the scheduled message.
  ///
  /// It is not the ID of the message once sent.
  final String id;

  /// The CID of the channel the message is sent to.
  final String cid;

  /// A summary of the channel the message is sent to.
  ///
  /// Only set on scheduled messages returned by
  /// [StreamChatClient.queryScheduledMessages].
  final ChannelModel? channel;

  /// The user the message is sent as.
  final User user;

  /// The message as it will be sent.
  ///
  /// Its [Message.id] is [id], not the ID the message is sent with.
  @JsonKey(fromJson: _messagePlaceholder, toJson: _messageToContent)
  final Message message;

  /// When the message is sent.
  final DateTime scheduledAt;

  /// Where the scheduled message is in its lifecycle.
  final ScheduledMessageStatus status;

  /// Why the message could not be sent.
  ///
  /// Only set when [status] is [ScheduledMessageStatus.failed].
  final ScheduledMessageFailureReason? failureReason;

  /// When the message was scheduled.
  final DateTime createdAt;

  /// When the scheduled message last changed.
  final DateTime updatedAt;

  /// Serializes this scheduled message to JSON.
  Map<String, dynamic> toJson() => _$ScheduledMessageToJson(this);

  /// Returns a copy of this scheduled message with the given fields replaced.
  ScheduledMessage copyWith({
    String? id,
    String? cid,
    ChannelModel? channel,
    User? user,
    Message? message,
    DateTime? scheduledAt,
    ScheduledMessageStatus? status,
    ScheduledMessageFailureReason? failureReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ScheduledMessage(
      id: id ?? this.id,
      cid: cid ?? this.cid,
      channel: channel ?? this.channel,
      user: user ?? this.user,
      message: message ?? this.message,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      failureReason: failureReason ?? this.failureReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Only the channel's custom data, which holds its name and image, is
  // compared: two reads of the same channel model never compare equal.
  @override
  List<Object?> get props => [
    id,
    cid,
    channel?.extraData,
    user,
    message,
    scheduledAt,
    status,
    failureReason,
    createdAt,
    updatedAt,
  ];
}

// The message is built in ScheduledMessage.fromJson, once the scheduled ID and
// user it takes are known.
Message _messagePlaceholder(Object? _) => Message();

// Keeps every mentioned user as an ID, whether or not the text mentions them by
// name.
Map<String, dynamic> _messageToContent(Message message) => {
  ...message.toJson(),
  'mentioned_users': [for (final user in message.mentionedUsers) user.id],
};

// Builds a message from a scheduled message's content: mentioned users arrive
// as IDs and custom data is nested under `custom`.
Message _messageFromContent(
  Map<String, dynamic> content, {
  required String id,
  required User user,
}) {
  final custom = content['custom'] as Map<String, dynamic>? ?? const {};
  final mentionedUserIds = content['mentioned_users'] as List<dynamic>? ?? const [];

  return Message.fromJson({
    ...custom,
    ...{...content}..remove('custom'),
    'id': id,
    'user': user.toJson(),
    'mentioned_users': [
      for (final userId in mentionedUserIds) {'id': userId},
    ],
  });
}

/// Where a [ScheduledMessage] is in its lifecycle.
///
/// A status without a constant here can still be named by wrapping its value:
/// `ScheduledMessageStatus('paused')`.
extension type const ScheduledMessageStatus(String _) implements String {
  /// Waiting for its time.
  static const scheduled = ScheduledMessageStatus('scheduled');

  /// Being sent, including while a failed attempt waits to be retried.
  ///
  /// It cannot be edited, sent now or deleted until it is sent or fails.
  static const sending = ScheduledMessageStatus('sending');

  /// Could not be sent; see [ScheduledMessage.failureReason].
  ///
  /// It can only be deleted.
  static const failed = ScheduledMessageStatus('failed');

  /// Deleted before it was sent.
  static const canceled = ScheduledMessageStatus('canceled');

  /// Sent to its channel.
  static const sent = ScheduledMessageStatus('sent');
}

/// Why a [ScheduledMessage] could not be sent.
///
/// A reason without a constant here can still be named by wrapping its value:
/// `ScheduledMessageFailureReason('rate_limited')`.
extension type const ScheduledMessageFailureReason(String _) implements String {
  /// The user is banned from the channel.
  static const banned = ScheduledMessageFailureReason('banned');

  /// The user is no longer allowed to send messages in the channel.
  static const noPermission = ScheduledMessageFailureReason('no_permission');

  /// The channel is frozen.
  static const channelFrozen = ScheduledMessageFailureReason('channel_frozen');

  /// The channel was deleted.
  static const channelDeleted = ScheduledMessageFailureReason('channel_deleted');

  /// The user was deleted.
  static const userDeleted = ScheduledMessageFailureReason('user_deleted');

  /// The message was blocked by moderation.
  static const moderationBlocked = ScheduledMessageFailureReason('moderation_blocked');

  /// The message was rejected by the app.
  static const hookRejected = ScheduledMessageFailureReason('hook_rejected');

  /// The message could not be sent in time.
  static const expired = ScheduledMessageFailureReason('expired');

  /// The message no longer meets the app's limits, such as its length.
  static const invalidMessage = ScheduledMessageFailureReason('invalid_message');

  /// The channel now holds new messages for approval.
  static const pendingNotSupported = ScheduledMessageFailureReason('pending_not_supported');

  /// Something went wrong while sending.
  static const internalError = ScheduledMessageFailureReason('internal_error');
}
