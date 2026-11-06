/// @docImport '../../client/channel/channel_client_state.dart';
/// @docImport '../../client/client.dart';
/// @docImport '../../event_type.dart';
/// @docImport 'event.dart';
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'channel_model.dart';
import 'message.dart';
import 'user.dart';

part 'scheduled_message.g.dart';

/// A message that is sent to its channel at [scheduledAt].
///
/// Until then, only its author sees it, and it can be edited, rescheduled,
/// sent right away or deleted. Once sent, it is a normal message in the
/// channel, with an ID of its own.
///
/// Obtained from [ChannelClientState.scheduledMessages],
/// [StreamChatClient.queryScheduledMessages] or
/// [StreamChatClient.scheduleMessage].
@JsonSerializable(createToJson: false)
class ScheduledMessage extends Equatable {
  /// Creates a scheduled [message] for the channel [cid].
  ///
  /// The [id] defaults to the ID of [message].
  ScheduledMessage({
    String? id,
    required this.cid,
    this.channel,
    required this.user,
    required this.message,
    required this.scheduledAt,
    required this.status,
    this.failureReason,
    required this.createdAt,
    required this.updatedAt,
  }) : id = id ?? message.id;

  /// Creates a scheduled message from [json].
  factory ScheduledMessage.fromJson(Map<String, dynamic> json) {
    final scheduled = _$ScheduledMessageFromJson(json);

    // The message takes its ID, author and dates from the scheduled message.
    final message = scheduled.message.copyWith(
      id: scheduled.id,
      user: scheduled.user,
      createdAt: scheduled.scheduledAt,
      updatedAt: scheduled.updatedAt,
    );

    return scheduled.copyWith(message: message);
  }

  /// The ID of this scheduled message.
  ///
  /// The sent message gets an ID of its own, given by [Event.messageId] on
  /// [EventType.scheduledMessageSent].
  final String id;

  /// The ID of the channel this message is sent to, in the form `type:id`.
  final String cid;

  /// A summary of the channel this message is sent to.
  ///
  /// Only set on scheduled messages returned by
  /// [StreamChatClient.queryScheduledMessages].
  final ChannelModel? channel;

  /// The user this message is sent as.
  final User user;

  /// The message as it will be sent.
  ///
  /// Its [Message.id] is [id], not the ID the message is sent with.
  ///
  /// Its [Message.mentionedUsers] can have only their [User.id] set. Consider
  /// resolving them, for example from [ClientState.users], before editing it.
  ///
  /// Its quoted message is identified by [Message.quotedMessageId] only.
  final Message message;

  /// The time this message is sent at.
  final DateTime scheduledAt;

  /// The stage of this scheduled message's lifecycle.
  final ScheduledMessageStatus status;

  /// The reason this message could not be sent.
  ///
  /// Only set when [status] is [ScheduledMessageStatus.failed].
  final ScheduledMessageFailureReason? failureReason;

  /// The time this message was scheduled.
  final DateTime createdAt;

  /// The time this scheduled message last changed.
  final DateTime updatedAt;

  /// Orders scheduled messages the way they are listed.
  ///
  /// Failed ones come after all others. Within each group they go by
  /// [scheduledAt], earliest first, then by [id].
  static int compareByListOrder(ScheduledMessage a, ScheduledMessage b) {
    final isAFailed = a.status == ScheduledMessageStatus.failed;
    final isBFailed = b.status == ScheduledMessageStatus.failed;
    if (isAFailed != isBFailed) return isAFailed ? 1 : -1;

    final byScheduledAt = a.scheduledAt.compareTo(b.scheduledAt);
    if (byScheduledAt != 0) return byScheduledAt;

    return a.id.compareTo(b.id);
  }

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

/// The stage of a [ScheduledMessage]'s lifecycle.
///
/// A status without a constant here can still be named by wrapping its value:
/// `ScheduledMessageStatus('paused')`.
extension type const ScheduledMessageStatus(String _) implements String {
  /// Waiting for its time.
  static const scheduled = ScheduledMessageStatus('scheduled');

  /// Being sent.
  ///
  /// It stays so while a failed attempt waits to be retried.
  ///
  /// It cannot be edited, sent now or deleted until it is sent or fails.
  static const sending = ScheduledMessageStatus('sending');

  /// Could not be sent.
  ///
  /// The reason is [ScheduledMessage.failureReason].
  ///
  /// It can only be deleted.
  static const failed = ScheduledMessageStatus('failed');

  /// Deleted before it was sent.
  static const canceled = ScheduledMessageStatus('canceled');

  /// Sent to its channel.
  static const sent = ScheduledMessageStatus('sent');
}

/// The reason a [ScheduledMessage] could not be sent.
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
