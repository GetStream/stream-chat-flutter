/// @docImport '../../client/client.dart';
/// @docImport '../../event_type.dart';
/// @docImport 'event.dart';
library;

import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'channel_model.dart';
import 'message.dart';
import 'user.dart';

part 'scheduled_message.g.dart';

class _NullConst {
  const _NullConst();
}

const _nullConst = _NullConst();

/// A message that is sent to its channel at [scheduledAt].
///
/// Until then, only its author sees it, and it can be edited, rescheduled,
/// sent right away or deleted. Once sent, it is a normal message in the
/// channel, with an ID of its own.
///
/// Obtained from [ClientState.scheduledMessages] or
/// [StreamChatClient.scheduleMessage].
@JsonSerializable(createToJson: false)
final class ScheduledMessage extends Equatable {
  /// Creates a scheduled [message] for the channel [cid].
  ///
  /// The [id] defaults to the ID of [message]. The [localCreatedAt] and
  /// [localUpdatedAt] are used until [remoteCreatedAt] and [remoteUpdatedAt]
  /// are known.
  ScheduledMessage({
    String? id,
    required this.cid,
    this.channel,
    required this.user,
    required this.message,
    required this.scheduledAt,
    required this.status,
    this.failureReason,
    DateTime? createdAt,
    this.localCreatedAt,
    DateTime? updatedAt,
    this.localUpdatedAt,
  }) : id = id ?? message.id,
       remoteCreatedAt = createdAt,
       remoteUpdatedAt = updatedAt;

  /// Creates a scheduled message from [json].
  factory ScheduledMessage.fromJson(Map<String, dynamic> json) {
    final scheduled = _$ScheduledMessageFromJson(json);

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
  /// [EventType.scheduledMessageSent] when it is known.
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
  ///
  /// [remoteCreatedAt] when set, otherwise [localCreatedAt]. If both are null,
  /// the current time.
  DateTime get createdAt => remoteCreatedAt ?? localCreatedAt ?? clock.now();

  /// The time this message was scheduled on this device.
  @JsonKey(includeFromJson: false)
  final DateTime? localCreatedAt;

  /// The time this message was scheduled, as returned by the API.
  @JsonKey(includeFromJson: false)
  final DateTime? remoteCreatedAt;

  /// The time this scheduled message last changed.
  ///
  /// [remoteUpdatedAt] when set, otherwise [localUpdatedAt]. If both are null,
  /// [createdAt].
  DateTime get updatedAt => remoteUpdatedAt ?? localUpdatedAt ?? createdAt;

  /// The time this scheduled message last changed on this device.
  @JsonKey(includeFromJson: false)
  final DateTime? localUpdatedAt;

  /// The time this scheduled message last changed, as returned by the API.
  @JsonKey(includeFromJson: false)
  final DateTime? remoteUpdatedAt;

  /// Returns a copy of this scheduled message with the given fields replaced.
  ScheduledMessage copyWith({
    String? id,
    String? cid,
    ChannelModel? channel,
    User? user,
    Message? message,
    DateTime? scheduledAt,
    ScheduledMessageStatus? status,
    Object? failureReason = _nullConst,
    DateTime? createdAt,
    DateTime? localCreatedAt,
    DateTime? updatedAt,
    DateTime? localUpdatedAt,
  }) {
    return ScheduledMessage(
      id: id ?? this.id,
      cid: cid ?? this.cid,
      channel: channel ?? this.channel,
      user: user ?? this.user,
      message: message ?? this.message,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      failureReason: switch (failureReason) {
        _NullConst() => this.failureReason,
        _ => failureReason as ScheduledMessageFailureReason?,
      },
      createdAt: createdAt ?? remoteCreatedAt,
      localCreatedAt: localCreatedAt ?? this.localCreatedAt,
      updatedAt: updatedAt ?? remoteUpdatedAt,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
    );
  }

  /// Its [message], as a draft to edit.
  ///
  /// Its [Message.mentionedUsers] can have only their [User.id] set, and its
  /// quoted message is identified by [Message.quotedMessageId] only.
  Message toMessage() {
    return Message(
      id: id,
      text: message.text,
      attachments: message.attachments,
      mentionedUsers: message.mentionedUsers,
      quotedMessageId: message.quotedMessageId,
      parentId: message.parentId,
      showInChannel: message.showInChannel,
      extraData: message.extraData,
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
    localCreatedAt,
    remoteCreatedAt,
    localUpdatedAt,
    remoteUpdatedAt,
  ];
}

/// The stage of a [ScheduledMessage]'s lifecycle.
///
/// A status without a constant here can still be named by wrapping its value:
/// `ScheduledMessageStatus('paused')`.
extension type const ScheduledMessageStatus(String _) implements String {
  /// Being scheduled, edited or rescheduled from this device.
  ///
  /// Only set until the request completes.
  static const preparingToSchedule = ScheduledMessageStatus('preparing_to_schedule');

  /// Waiting for its time.
  static const scheduled = ScheduledMessageStatus('scheduled');

  /// Being sent.
  ///
  /// It can stay so for a while if sending is retried.
  ///
  /// It cannot be edited, sent now or deleted until it is sent or fails.
  static const sending = ScheduledMessageStatus('sending');

  /// Could not be sent.
  ///
  /// The reason is [ScheduledMessage.failureReason]. One whose reason
  /// [ScheduledMessageFailureReason.isRetriable] can be retried; any other can
  /// only be deleted.
  static const failed = ScheduledMessageStatus('failed');

  /// Deleted before it was sent.
  static const canceled = ScheduledMessageStatus('canceled');

  /// Sent to its channel.
  static const sent = ScheduledMessageStatus('sent');

  /// Whether the message is still to be sent: being scheduled or changed,
  /// waiting for its time, or being sent.
  bool get isPending => this == preparingToSchedule || this == scheduled || this == sending;
}

/// The reason a [ScheduledMessage] could not be sent.
///
/// A reason without a constant here can still be named by wrapping its value:
/// `ScheduledMessageFailureReason('rate_limited')`.
extension type const ScheduledMessageFailureReason(String _) implements String {
  /// The request to schedule it failed in a way that can be retried.
  static const requestFailed = ScheduledMessageFailureReason('request_failed');

  /// The request to edit it failed.
  ///
  /// The message is still scheduled as it was before the edit.
  static const updateFailed = ScheduledMessageFailureReason('update_failed');

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

  /// Whether the failed request can be made again.
  bool get isRetriable => this == requestFailed || this == updateFailed;
}
