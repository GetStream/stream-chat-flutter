/// @docImport '../../client/client.dart';
/// @docImport '../../event_type.dart';
/// @docImport 'event.dart';
library;

import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../error/stream_chat_error.dart';
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
    this.failure,
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

    // A failed one without a reason failed to send.
    if (scheduled.status == .failed && scheduled.failure == null) {
      const failure = ScheduledMessageFailure.sendingFailed();
      return scheduled.copyWith(message: message, failure: failure);
    }

    return scheduled.copyWith(message: message);
  }

  static ScheduledMessageFailure? _failureFromJson(String? reason) {
    if (reason == null) return null;
    return .sendingFailed(reason: ScheduledMessageSendingFailureReason(reason));
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

  /// What stopped this message from being scheduled, changed or sent.
  ///
  /// Set when, and only when, [status] is [ScheduledMessageStatus.failed].
  @JsonKey(name: 'failure_reason', fromJson: _failureFromJson)
  final ScheduledMessageFailure? failure;

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
    Object? failure = _nullConst,
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
      failure: switch (failure) {
        _NullConst() => this.failure,
        _ => failure as ScheduledMessageFailure?,
      },
      createdAt: createdAt ?? remoteCreatedAt,
      localCreatedAt: localCreatedAt ?? this.localCreatedAt,
      updatedAt: updatedAt ?? remoteUpdatedAt,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
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
    failure,
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

  /// Could not be scheduled or sent, or a change to it could not be saved.
  ///
  /// The failure is [ScheduledMessage.failure]. One with a
  /// [ScheduledMessageUpdatingFailed] is still scheduled as it was. One whose
  /// failure [ScheduledMessageFailure.isRetriable] can be retried.
  static const failed = ScheduledMessageStatus('failed');

  /// Deleted before it was sent.
  static const canceled = ScheduledMessageStatus('canceled');

  /// Sent to its channel.
  static const sent = ScheduledMessageStatus('sent');

  /// Whether the message is still to be sent.
  ///
  /// It is while being scheduled or changed, waiting for its time, or being
  /// sent. A failed message is not, though one whose failure is a
  /// [ScheduledMessageUpdatingFailed] is still scheduled as it was.
  bool get isPending => this == preparingToSchedule || this == scheduled || this == sending;
}

/// What stopped a [ScheduledMessage] from being scheduled, changed or sent.
///
/// New kinds can be added, so a `switch` over it needs a default case.
///
/// See also:
///
///  * [ScheduledMessageSchedulingFailed], which can always be retried.
///  * [ScheduledMessageUpdatingFailed], which leaves the message scheduled as
///    it was.
///  * [ScheduledMessageSendingFailed], which can't be retried or changed.
abstract final class ScheduledMessageFailure extends Equatable {
  const ScheduledMessageFailure._();

  /// Scheduling the message failed.
  const factory ScheduledMessageFailure.schedulingFailed() = ScheduledMessageSchedulingFailed;

  /// Saving a change to the message failed.
  ///
  /// The message is still scheduled as it was.
  const factory ScheduledMessageFailure.updatingFailed({
    ScheduledMessageErrorReason? reason,
    required bool isRetriable,
  }) = ScheduledMessageUpdatingFailed;

  /// The message could not be sent at its time.
  const factory ScheduledMessageFailure.sendingFailed({
    ScheduledMessageSendingFailureReason? reason,
  }) = ScheduledMessageSendingFailed;

  /// Whether making the same request again, unchanged, can succeed.
  bool get isRetriable;
}

/// A failure to schedule a [ScheduledMessage].
///
/// Only a temporary error leaves one listed, so it can always be retried.
final class ScheduledMessageSchedulingFailed extends ScheduledMessageFailure {
  /// Creates a failure to schedule.
  const ScheduledMessageSchedulingFailed() : super._();

  @override
  bool get isRetriable => true;

  @override
  List<Object?> get props => [];
}

/// A failure to save a change to a [ScheduledMessage].
///
/// The message is still scheduled as it was.
final class ScheduledMessageUpdatingFailed extends ScheduledMessageFailure {
  /// Creates a failure to save a change, refused for [reason] if one is known.
  const ScheduledMessageUpdatingFailed({
    this.reason,
    required this.isRetriable,
  }) : super._();

  /// Why the change was refused, if known.
  final ScheduledMessageErrorReason? reason;

  @override
  final bool isRetriable;

  @override
  List<Object?> get props => [reason, isRetriable];
}

/// A failure to send a [ScheduledMessage] at its time.
final class ScheduledMessageSendingFailed extends ScheduledMessageFailure {
  /// Creates a failure to send, for [reason] if one is known.
  const ScheduledMessageSendingFailed({this.reason}) : super._();

  /// Why it couldn't be sent, if known.
  final ScheduledMessageSendingFailureReason? reason;

  @override
  bool get isRetriable => false;

  @override
  List<Object?> get props => [reason];
}

/// The reason a [ScheduledMessage] could not be sent at its time.
///
/// A reason without a constant here can still be named by wrapping its value:
/// `ScheduledMessageSendingFailureReason('rate_limited')`.
extension type const ScheduledMessageSendingFailureReason(String _) implements String {
  /// The user is banned from the channel.
  static const banned = ScheduledMessageSendingFailureReason('banned');

  /// The user is no longer allowed to send messages in the channel.
  static const noPermission = ScheduledMessageSendingFailureReason('no_permission');

  /// The channel is frozen.
  static const channelFrozen = ScheduledMessageSendingFailureReason('channel_frozen');

  /// The channel was deleted.
  static const channelDeleted = ScheduledMessageSendingFailureReason('channel_deleted');

  /// The user was deleted.
  static const userDeleted = ScheduledMessageSendingFailureReason('user_deleted');

  /// The message was blocked by moderation.
  static const moderationBlocked = ScheduledMessageSendingFailureReason('moderation_blocked');

  /// The message was rejected by the app.
  static const hookRejected = ScheduledMessageSendingFailureReason('hook_rejected');

  /// The message could not be sent in time.
  static const expired = ScheduledMessageSendingFailureReason('expired');

  /// The message no longer meets the app's limits, such as its length.
  static const invalidMessage = ScheduledMessageSendingFailureReason('invalid_message');

  /// The channel now holds new messages for approval.
  static const pendingNotSupported = ScheduledMessageSendingFailureReason('pending_not_supported');

  /// Something went wrong while sending.
  static const internalError = ScheduledMessageSendingFailureReason('internal_error');
}
