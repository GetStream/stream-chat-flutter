import '../../stream_chat_flutter.dart';
import '../localization/translations.dart';

/// The delivery state a message is in.
///
/// Resolved once, then mapped separately to an icon and to an announcement, so
/// the two are two readings of one answer instead of two independent walks over
/// the message. [StreamSendingIndicator] and [StreamMessageSendingStatus]
/// render it visually, while [StreamMessageItem] speaks it as part of the
/// composed row label.
///
/// A failed send outranks a read receipt because
/// [ReadIterableExtension.readsOf] only compares timestamps: every member whose
/// `lastRead` moves past a bounced message counts as having read it, even
/// though the moderation system rejected it and nobody else was ever shown it.
enum MessageDeliveryStatus {
  /// The send failed, or the moderation system bounced the message.
  failed,

  /// At least one other member has read the message.
  read,

  /// The message reached at least one other member, unread.
  delivered,

  /// The message reached the server.
  sent,

  /// The message is still on its way to the server.
  sending,

  /// The message has no delivery state to report.
  none;

  /// Resolves the state [message] is in.
  static MessageDeliveryStatus of(
    Message message, {
    required bool isMessageRead,
    required bool isMessageDelivered,
  }) {
    if (message.state.isFailed || message.isBouncedWithError) return failed;
    if (isMessageRead) return read;
    if (isMessageDelivered) return delivered;
    if (message.state.isCompleted) return sent;
    if (message.state.isOutgoing) return sending;
    return none;
  }

  /// The phrasing announced for this state, or null when there is none to
  /// announce.
  ///
  /// A failed send is shown as a badge on the bubble rather than a footer tick,
  /// and the badge is a bare icon with no text of its own, so the failure is
  /// reported here instead.
  String? label(Translations translations) {
    final a11y = translations.accessibility;

    return switch (this) {
      failed => a11y.messageFailedStatusLabel,
      read => a11y.messageReadStatusLabel,
      delivered => a11y.messageDeliveredStatusLabel,
      sent => a11y.messageSentStatusLabel,
      sending => a11y.messageSendingStatusLabel,
      none => null,
    };
  }
}

/// How many of [message]'s attachments have finished uploading, or null once
/// they all have.
///
/// While attachments upload, the footer shows this progress in place of a
/// delivery tick, so the announcement carries the same progress rather than
/// flattening it to "Sending".
String? attachmentUploadProgressLabel(Translations translations, Message message) {
  if (!message.state.isOutgoing) return null;

  // A url preview is generated rather than uploaded, so counting it would
  // report progress against an attachment the sender never picked.
  final attachments = message.attachments.where((it) => it.type != AttachmentType.urlPreview).toList();
  if (attachments.isEmpty) return null;

  final uploaded = attachments.where((it) => it.uploadState.isSuccess).length;
  if (uploaded >= attachments.length) return null;

  return translations.attachmentsUploadProgressText(
    completed: uploaded,
    total: attachments.length,
  );
}
