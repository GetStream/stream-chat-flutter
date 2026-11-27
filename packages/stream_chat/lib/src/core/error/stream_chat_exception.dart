/// @docImport '../models/channel_config.dart';
/// @docImport '../models/scheduled_message.dart';
/// @docImport '../util/scheduled_message_rules.dart';
library;

import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart';

/// An alias of [StreamException], so code written against either name catches
/// the same failures.
///
/// Every failure the SDK reports is one of four kinds:
///
/// - [StreamApiException] — the server answered, and the answer was an error.
/// - [StreamNetworkException] — the server was never heard from, so the
///   outcome of the request is unknown.
/// - [StreamAuthenticationException] — credentials could not be produced or
///   sent.
/// - [StreamClientException] — the SDK itself failed.
///
/// The root is sealed, so a `switch` over the four kinds is exhaustive.
typedef StreamChatException = StreamException;

/// Whether a failed operation is worth attempting again.
extension StreamChatExceptionRetries on StreamChatException {
  /// Whether retrying the operation could succeed.
  ///
  /// Answers from the failure alone, which is necessary but not sufficient: a
  /// write is only safe to retry through an idempotent path, because a
  /// [StreamNetworkException] leaves the outcome unknown — the server may have
  /// performed the operation before the connection failed. Sending a message
  /// is idempotent here, since the id is client-generated.
  ///
  /// A `true` says nothing about *when*. Honour
  /// [StreamApiException.retryAfter] where the failure names a wait, and back
  /// off otherwise.
  bool get isRetriable => switch (this) {
    // The failure is marked unrecoverable, and that verdict is authoritative.
    StreamApiException(unrecoverable: true) => false,

    // About the moment rather than the request: the wait heals it.
    StreamApiException(isRateLimited: true) => true,

    // Clock skew on the token's `nbf`/`iat` claims heals on its own, and a
    // fresh token minted by the same skewed clock would not help.
    StreamApiException(isTokenNotYetValid: true) => true,

    // A refused token that reached here is one a refresh already failed to
    // fix, so resending cannot help either.
    StreamApiException(isTokenExpired: true) => false,

    // 5xx is the server failing to answer rather than a verdict on the
    // request, and 408 says the request did not complete in time. Every other
    // 4xx is a verdict: the same request earns the same answer.
    StreamApiException(:final statusCode) => statusCode >= 500 || statusCode == 408,

    // The caller stopped it, so there is nothing to retry.
    StreamNetworkException(isCancelled: true) => false,

    // The request never reached a verdict. Prefer a connectivity signal over
    // blind backoff where one is available.
    StreamNetworkException() => true,

    // Credentials have to be fixed before the operation is worth attempting.
    StreamAuthenticationException() => false,

    // A bug does not heal on resend.
    StreamClientException() => false,
  };
}

/// Rejections of a message request that leave nothing to retry.
@internal
extension StreamChatExceptionMessageRejections on StreamChatException {
  /// Whether the server rejected a send because it already stored a message
  /// with the same id.
  bool get isMessageAlreadyExistsError {
    final exception = this;
    if (exception is! StreamApiException) return false;
    if (exception.code != StreamErrorCode.inputError) return false;
    if (!exception.message.contains('a message with ID')) return false;
    return exception.message.contains('already exists');
  }

  /// Whether the server rejected a request because the message no longer
  /// exists, such as one already deleted.
  bool get isMessageGoneError {
    final exception = this;
    if (exception is! StreamApiException) return false;
    if (exception.statusCode != 404) return false;
    return exception.code == StreamErrorCode.notFound;
  }
}

/// The reason a request to schedule or change a scheduled message was refused.
///
/// Read from
/// [StreamChatExceptionScheduledMessages.scheduledMessageErrorReason] for
/// a refusal by the server, or [ScheduledMessageRefusedError.reason] for one
/// on this device. A change that failed keeps it in
/// [ScheduledMessageUpdatingFailed.reason].
extension type const ScheduledMessageErrorReason(String _) implements String {
  /// Scheduled messages are turned off for the app.
  static const scheduledMessagesDisabled = ScheduledMessageErrorReason('scheduled_messages_disabled');

  /// The new time of a change to a scheduled message is not in the future.
  static const scheduledAtTooSoon = ScheduledMessageErrorReason('scheduled_at_too_soon');

  /// The time is too far ahead.
  ///
  /// The limit is [ChannelConfig.scheduledMessagesMaxLeadTime].
  static const scheduledAtTooFar = ScheduledMessageErrorReason('scheduled_at_too_far');

  /// The user has reached the limit of scheduled messages in the channel.
  ///
  /// The limit is [ChannelConfig.scheduledMessagesMaxPerChannel].
  static const scheduledLimitChannel = ScheduledMessageErrorReason('scheduled_limit_channel');

  /// The user has reached the limit of scheduled messages across channels.
  ///
  /// The limit is [ChannelConfig.scheduledMessagesMaxPerUser].
  static const scheduledLimitUser = ScheduledMessageErrorReason('scheduled_limit_user');

  /// The ID already belongs to another scheduled message.
  static const scheduledMessageIdTaken = ScheduledMessageErrorReason('scheduled_message_id_taken');

  /// The scheduled message failed and can only be deleted.
  static const scheduledMessageNotEditable = ScheduledMessageErrorReason('scheduled_message_not_editable');

  /// The scheduled message is being sent.
  static const scheduledMessageSending = ScheduledMessageErrorReason('scheduled_message_sending');

  /// The scheduled message was changed by another request at the same time.
  static const scheduledMessageConflict = ScheduledMessageErrorReason('scheduled_message_conflict');

  /// The scheduled message was already sent.
  static const scheduledMessageAlreadySent = ScheduledMessageErrorReason('scheduled_message_already_sent');

  /// The scheduled message was deleted.
  static const scheduledMessageCanceled = ScheduledMessageErrorReason('scheduled_message_canceled');

  /// The message is a command, such as `/giphy`.
  ///
  /// A command runs when the message is sent, so it can't be scheduled.
  static const scheduledMessageIsCommand = ScheduledMessageErrorReason('scheduled_message_is_command');

  /// The message quotes a message that was deleted.
  static const scheduledMessageQuoteDeleted = ScheduledMessageErrorReason('scheduled_message_quote_deleted');

  /// Sending the message right away, as its time had passed, was refused.
  ///
  /// This happens in a frozen channel, for example.
  static const scheduledMessageSendRefused = ScheduledMessageErrorReason('scheduled_message_send_refused');
}

/// A refused request about a scheduled message.
///
/// The message isn't scheduled or changed, and its [reason] says why.
///
/// See also:
///
///  * [ScheduledMessageRules], which tells up front whether some of these
///    requests would be refused.
final class ScheduledMessageRefusedError extends StreamClientException {
  /// Creates an error refusing a request for [reason].
  const ScheduledMessageRefusedError(this.reason, String message) : super(message: message);

  /// Why the request was refused.
  final ScheduledMessageErrorReason reason;

  @override
  List<Object?> get props => [...super.props, reason];

  @override
  String toString() => 'ScheduledMessageRefusedError(reason: $reason, message: $message)';
}

const _scheduledMessageErrorReasons = {
  114: ScheduledMessageErrorReason.scheduledMessagesDisabled,
  115: ScheduledMessageErrorReason.scheduledAtTooSoon,
  116: ScheduledMessageErrorReason.scheduledAtTooFar,
  117: ScheduledMessageErrorReason.scheduledLimitChannel,
  118: ScheduledMessageErrorReason.scheduledLimitUser,
  119: ScheduledMessageErrorReason.scheduledMessageIdTaken,
  120: ScheduledMessageErrorReason.scheduledMessageNotEditable,
  121: ScheduledMessageErrorReason.scheduledMessageSending,
  122: ScheduledMessageErrorReason.scheduledMessageConflict,
  123: ScheduledMessageErrorReason.scheduledMessageAlreadySent,
  124: ScheduledMessageErrorReason.scheduledMessageCanceled,
};

/// Scheduled message refusal reasons of a [StreamChatException].
extension StreamChatExceptionScheduledMessages on StreamChatException {
  /// The reason a scheduled message request was refused.
  ///
  /// Null when this failure has another cause.
  ScheduledMessageErrorReason? get scheduledMessageErrorReason => switch (this) {
    StreamApiException(:final code) => _scheduledMessageErrorReasons[code],
    _ => null,
  };

  /// Whether the scheduled message the request was for no longer exists.
  ///
  /// Other failures that something was not found, such as a quoted message
  /// that was deleted, are false.
  bool get isScheduledMessageNotFound => switch (this) {
    StreamApiException(statusCode: 404, :final message) => _scheduledMessageNotFound.hasMatch(message),
    _ => false,
  };
}

final _scheduledMessageNotFound = RegExp('scheduled message .* not found');
