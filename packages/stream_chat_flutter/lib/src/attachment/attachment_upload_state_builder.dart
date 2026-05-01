import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// {@template streamAttachmentUploadStateBuilder}
/// Widget to display attachment upload state
/// {@endtemplate}
class StreamAttachmentUploadStateBuilder extends StatelessWidget {
  /// {@macro streamAttachmentUploadStateBuilder}
  const StreamAttachmentUploadStateBuilder({
    super.key,
    required this.message,
    required this.attachment,
    this.preparingBuilder = _defaultPreparingBuilder,
    this.inProgressBuilder = _defaultInProgressBuilder,
    this.failedBuilder = _defaultFailedBuilder,
  });

  /// The message that [attachment] is associated with
  final Message message;

  /// The attachment currently being handled
  final Attachment attachment;

  /// Widget to display when preparing to upload the [attachment]
  final PreparingBuilder preparingBuilder;

  /// {@macro inProgressBuilder}
  final InProgressBuilder inProgressBuilder;

  /// {@macro failedBuilder}
  final FailedBuilder failedBuilder;

  static Widget _defaultPreparingBuilder(BuildContext context) => StreamLoadingSpinner(size: .md);

  static Widget _defaultInProgressBuilder(BuildContext context, int sent, int total) {
    // Fall back to an indeterminate spinner when the total size is unknown
    // (e.g. `total` reported as `-1` or `0`) instead of rendering a fake 0%.
    final progress = total > 0 ? sent / total : null;
    return StreamLoadingSpinner(value: progress, size: .md);
  }

  static Widget _defaultFailedBuilder(BuildContext context, String? error) => StreamErrorBadge(size: .sm);

  @override
  Widget build(BuildContext context) {
    // Hide the overlay once this individual attachment is done uploading
    // or the whole message has been delivered.
    if (attachment.uploadState.isSuccess || message.state.isCompleted) return const Empty();

    final colorScheme = context.streamColorScheme;

    return ColoredBox(
      color: colorScheme.backgroundOverlayLight,
      child: Center(
        child: attachment.uploadState.when(
          preparing: () => preparingBuilder(context),
          inProgress: (sent, total) => inProgressBuilder(context, sent, total),
          // Unreachable — the early-return above already covers success.
          success: () => const Empty(),
          failed: (error) => failedBuilder(context, error),
        ),
      ),
    );
  }
}
