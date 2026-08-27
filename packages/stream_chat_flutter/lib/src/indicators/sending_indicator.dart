import 'package:flutter/material.dart';

import '../../stream_chat_flutter.dart';
import '../localization/translations.dart';
import '../misc/empty_widget.dart';

/// {@template streamSendingIndicator}
/// Shows the sending status of a message.
/// {@endtemplate}
class StreamSendingIndicator extends StatelessWidget {
  /// {@macro streamSendingIndicator}
  const StreamSendingIndicator({
    super.key,
    required this.message,
    this.isMessageRead = false,
    this.isMessageDelivered = false,
    this.size,
    this.color,
  });

  /// The message whose sending status is to be shown.
  final Message message;

  /// Whether the message is read by the recipient.
  final bool isMessageRead;

  /// Whether the message is delivered to the recipient.
  final bool isMessageDelivered;

  /// The size of the indicator icon.
  final double? size;

  /// The color of the indicator icon.
  ///
  /// When null, read messages use `StreamColorScheme.accentPrimary` and every
  /// other state uses `StreamColorScheme.textSecondary`.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    // Resolved once and reused by every branch below, so the icon a reader
    // sees and the label a screen reader hears can never describe different
    // states.
    final semanticLabel = context.translations.messageDeliveryStatusLabel(
      message,
      isMessageRead: isMessageRead,
      isMessageDelivered: isMessageDelivered,
    );

    if (isMessageRead) {
      return Icon(
        context.streamIcons.checks,
        size: size,
        color: color ?? colorScheme.accentPrimary,
        semanticLabel: semanticLabel,
      );
    }

    if (isMessageDelivered) {
      return Icon(
        context.streamIcons.checks,
        size: size,
        color: color ?? colorScheme.textSecondary,
        semanticLabel: semanticLabel,
      );
    }

    if (message.state.isCompleted) {
      return Icon(
        context.streamIcons.checkmark,
        size: size,
        color: color ?? colorScheme.textSecondary,
        semanticLabel: semanticLabel,
      );
    }

    if (message.state.isOutgoing) {
      return Icon(
        context.streamIcons.clock,
        size: size,
        color: color ?? colorScheme.textSecondary,
        semanticLabel: semanticLabel,
      );
    }

    return const Empty();
  }
}

/// The status labels a message announces, shared by the widgets that render
/// that status and by the composed message row announcement.
///
/// [StreamSendingIndicator] and [StreamMessageSendingStatus] render the status
/// visually, while [StreamMessageItem] speaks it as part of the row label.
/// Both read the state through these two members, so a change to what counts
/// as sent, delivered or read lands in one place instead of drifting between
/// the icon and the announcement.
extension StreamMessageStatusLabels on Translations {
  /// How many of [message]'s attachments have finished uploading, or null once
  /// they all have.
  ///
  /// While attachments upload, the footer shows this progress in place of a
  /// delivery tick, so the announcement carries the same progress rather than
  /// flattening it to "Sending".
  String? attachmentUploadProgressLabel(Message message) {
    if (!message.state.isOutgoing) return null;

    // A url preview is generated rather than uploaded, so counting it would
    // report progress against an attachment the sender never picked.
    final attachments = message.attachments;
    if (!attachments.any((it) => it.type != AttachmentType.urlPreview)) return null;

    final uploaded = attachments.where((it) => it.uploadState.isSuccess).length;
    if (uploaded >= attachments.length) return null;

    return attachmentsUploadProgressText(
      completed: uploaded,
      total: attachments.length,
    );
  }

  /// The delivery status announced for [message], or null when it has none.
  ///
  /// A failed send is shown as a badge on the bubble rather than a footer tick,
  /// and the badge is a bare icon with no text of its own, so the failure is
  /// reported here instead.
  String? messageDeliveryStatusLabel(
    Message message, {
    required bool isMessageRead,
    required bool isMessageDelivered,
  }) {
    final a11y = accessibility;

    if (message.state.isFailed || message.isBouncedWithError) {
      return a11y.messageFailedStatusLabel;
    }

    if (isMessageRead) return a11y.messageReadStatusLabel;
    if (isMessageDelivered) return a11y.messageDeliveredStatusLabel;
    if (message.state.isCompleted) return a11y.messageSentStatusLabel;
    if (message.state.isOutgoing) return a11y.messageSendingStatusLabel;
    return null;
  }
}
