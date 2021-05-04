import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/upload_progress_indicator.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Widget to build in progress
typedef InProgressBuilder = Widget Function(BuildContext, int, int);

/// Widget to build on failure
typedef FailedBuilder = Widget Function(BuildContext, String);

/// Widget to display attachment upload state
class AttachmentUploadStateBuilder extends StatelessWidget {
  final Message message;
  final Attachment attachment;
  final FailedBuilder? failedBuilder;
  final WidgetBuilder? successBuilder;
  final InProgressBuilder? inProgressBuilder;
  final WidgetBuilder? preparingBuilder;

  const AttachmentUploadStateBuilder({
    Key? key,
    required this.message,
    required this.attachment,
    this.failedBuilder,
    this.successBuilder,
    this.inProgressBuilder,
    this.preparingBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.status == MessageSendingStatus.sent) {
      return Offstage();
    }

    final messageId = message.id;
    final attachmentId = attachment.id;

    final inProgress = inProgressBuilder ??
        (context, int sent, int total) {
          return _InProgressState(
            sent: sent,
            total: total,
            attachmentId: attachmentId,
          );
        };

    final failed = failedBuilder ??
        (context, error) {
          return _FailedState(
            error: error,
            messageId: messageId,
            attachmentId: attachmentId,
          );
        };

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
  final Widget? icon;
  final double iconSize;
  final VoidCallback? onPressed;
  final Color? fillColor;

  const _IconButton({
    Key? key,
    this.icon,
    this.iconSize = 24.0,
    this.onPressed,
    this.fillColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: iconSize,
      width: iconSize,
      child: RawMaterialButton(
        elevation: 0,
        highlightElevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        onPressed: onPressed,
        fillColor:
            fillColor ?? StreamChatTheme.of(context).colorTheme.overlayDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: icon,
      ),
    );
  }
}

class _PreparingState extends StatelessWidget {
  final String attachmentId;

  const _PreparingState({
    Key? key,
    required this.attachmentId,
  }) : super(key: key);

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
              color: StreamChatTheme.of(context).colorTheme.white,
            ),
            onPressed: () => channel.cancelAttachmentUpload(attachmentId),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: UploadProgressIndicator(
            uploaded: 0,
            total: double.maxFinite.toInt(),
          ),
        )
      ],
    );
  }
}

class _InProgressState extends StatelessWidget {
  final int sent;
  final int total;
  final String attachmentId;

  const _InProgressState({
    Key? key,
    required this.sent,
    required this.total,
    required this.attachmentId,
  }) : super(key: key);

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
              color: StreamChatTheme.of(context).colorTheme.white,
            ),
            onPressed: () => channel.cancelAttachmentUpload(attachmentId),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: UploadProgressIndicator(
            uploaded: sent,
            total: total,
          ),
        )
      ],
    );
  }
}

class _FailedState extends StatelessWidget {
  final String? error;
  final String messageId;
  final String attachmentId;

  const _FailedState({
    Key? key,
    this.error,
    required this.messageId,
    required this.attachmentId,
  }) : super(key: key);

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
            color: theme.colorTheme.white,
          ),
          onPressed: () {
            channel.retryAttachmentUpload(messageId, attachmentId);
          },
        ),
        Center(
          child: Container(
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
                'UPLOAD ERROR',
                style: theme.textTheme.footnote.copyWith(
                  color: theme.colorTheme.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _SuccessState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: CircleAvatar(
        backgroundColor: StreamChatTheme.of(context).colorTheme.overlayDark,
        maxRadius: 12,
        child: StreamSvgIcon.check(
          color: StreamChatTheme.of(context).colorTheme.white,
        ),
      ),
    );
  }
}
