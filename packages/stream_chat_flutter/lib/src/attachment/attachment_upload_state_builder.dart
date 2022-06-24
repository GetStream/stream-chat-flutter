import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/upload_progress_indicator.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Widget to build in progress
typedef InProgressBuilder = Widget Function(BuildContext, int, int);

/// Widget to build on failure
typedef FailedBuilder = Widget Function(BuildContext, String);

/// {@macro attachment_upload_state_builder}
@Deprecated("Use 'StreamAttachmentsUploadStateBuilder' instead")
typedef AttachmentUploadStateBuilder = StreamAttachmentUploadStateBuilder;

/// {@template attachment_upload_state_builder}
/// Widget to display attachment upload state
/// {@endtemplate}
class StreamAttachmentUploadStateBuilder extends StatelessWidget {
  /// Constructor for creating an [StreamAttachmentUploadStateBuilder] widget
  const StreamAttachmentUploadStateBuilder({
    super.key,
    required this.message,
    required this.attachment,
    this.failedBuilder,
    this.successBuilder,
    this.inProgressBuilder,
    this.preparingBuilder,
  });

  /// Message which attachment is added to
  final Message message;

  /// Attachment in concern
  final Attachment attachment;

  /// Widget to display when failed
  final FailedBuilder? failedBuilder;

  /// Widget to display when succeeded
  final WidgetBuilder? successBuilder;

  /// Widget to display when in progress
  final InProgressBuilder? inProgressBuilder;

  /// Widget to display when in prep
  final WidgetBuilder? preparingBuilder;

  @override
  Widget build(BuildContext context) {
    if (message.status == MessageSendingStatus.sent) {
      return const Offstage();
    }

    final messageId = message.id;
    final attachmentId = attachment.id;

    final inProgress = inProgressBuilder ??
        (context, int sent, int total) => _InProgressState(
              sent: sent,
              total: total,
              attachmentId: attachmentId,
            );

    final failed = failedBuilder ??
        (context, error) => _FailedState(
              error: error,
              messageId: messageId,
              attachmentId: attachmentId,
            );

    final success = successBuilder ?? (context) => _SuccessState();

    final preparing = preparingBuilder ??
        (context) => _PreparingState(attachmentId: attachmentId);

    return attachment.uploadState.when(
      preparing: () => preparing(context),
      inProgress: (sent, total) => inProgress(context, sent, total),
      success: () => success(context),
      failed: (error) => failed(context, error),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    this.icon,
    this.onPressed,
  });

  final Widget? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 24,
        width: 24,
        child: RawMaterialButton(
          elevation: 0,
          highlightElevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          onPressed: onPressed,
          fillColor: StreamChatTheme.of(context).colorTheme.overlayDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: icon,
        ),
      );
}

class _PreparingState extends StatelessWidget {
  const _PreparingState({required this.attachmentId});

  final String attachmentId;

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: _IconButton(
            icon: StreamSvgIcon.close(
              color: StreamChatTheme.of(context).colorTheme.barsBg,
            ),
            onPressed: () => channel.cancelAttachmentUpload(attachmentId),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: StreamUploadProgressIndicator(
            uploaded: 0,
            total: double.maxFinite.toInt(),
          ),
        ),
      ],
    );
  }
}

class _InProgressState extends StatelessWidget {
  const _InProgressState({
    required this.sent,
    required this.total,
    required this.attachmentId,
  });

  final int sent;
  final int total;
  final String attachmentId;

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: _IconButton(
            icon: StreamSvgIcon.close(
              color: StreamChatTheme.of(context).colorTheme.barsBg,
            ),
            onPressed: () => channel.cancelAttachmentUpload(attachmentId),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: StreamUploadProgressIndicator(
            uploaded: sent,
            total: total,
          ),
        ),
      ],
    );
  }
}

class _FailedState extends StatelessWidget {
  const _FailedState({
    this.error,
    required this.messageId,
    required this.attachmentId,
  });

  final String? error;
  final String messageId;
  final String attachmentId;

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    final theme = StreamChatTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _IconButton(
          icon: StreamSvgIcon.retry(
            color: theme.colorTheme.barsBg,
          ),
          onPressed: () {
            channel.retryAttachmentUpload(messageId, attachmentId);
          },
        ),
        Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.colorTheme.overlayDark.withOpacity(0.6),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 12,
              ),
              child: Text(
                context.translations.uploadErrorLabel,
                style: theme.textTheme.footnote.copyWith(
                  color: theme.colorTheme.barsBg,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SuccessState extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topRight,
        child: CircleAvatar(
          backgroundColor: StreamChatTheme.of(context).colorTheme.overlayDark,
          maxRadius: 12,
          child: StreamSvgIcon.check(
            color: StreamChatTheme.of(context).colorTheme.barsBg,
          ),
        ),
      );
}
