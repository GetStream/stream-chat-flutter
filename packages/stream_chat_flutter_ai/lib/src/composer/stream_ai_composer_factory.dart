import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_ai/src/composer/ai_composer_controller.dart';
import 'package:stream_chat_flutter_ai/src/composer/composer_attachment_sheet.dart';

/// Factory that produces the composable regions of [StreamAIComposer].
///
/// Subclass and override any method to swap out individual slots without
/// rebuilding the entire widget:
///
/// ```dart
/// class MyFactory extends StreamAIComposerFactory {
///   @override
///   Widget buildLeading(BuildContext context, AIComposerController controller) {
///     return IconButton(
///       icon: const Icon(Icons.attach_file),
///       onPressed: () { /* pick attachments */ },
///     );
///   }
/// }
/// ```
class StreamAIComposerFactory {
  /// Creates a [StreamAIComposerFactory].
  const StreamAIComposerFactory();

  /// The maximum number of images the default [buildLeading] button lets the
  /// user pick in one go.
  static const int maxAttachments = 3;

  /// The widget placed to the left of the input container, or `null` for
  /// none.
  ///
  /// Defaults to an outlined circular "+" button that opens a
  /// [ComposerAttachmentSheet] — a combined photo picker and, if
  /// [AIComposerController.chatOptions] is non-empty, chat-option list. The
  /// button is disabled while [AIComposerController.isGenerating] is `true`.
  ///
  /// Override to replace it, or return `null` to hide it — [StreamAIComposer]
  /// only reserves layout space (and the gap to the input container) for a
  /// non-`null` result.
  Widget? buildLeading(BuildContext context, AIComposerController controller) {
    return _AttachmentButton(controller: controller);
  }

  /// The widget placed to the right of the input container, or `null` for
  /// none.
  ///
  /// Returns `null` by default (no trailing widget). See [buildLeading] for
  /// how `null` affects layout.
  Widget? buildTrailing(BuildContext context, AIComposerController controller) {
    return null;
  }
}

/// The default leading "+" attachment button — opens a
/// [ComposerAttachmentSheet] for [controller].
class _AttachmentButton extends StatelessWidget {
  const _AttachmentButton({required this.controller});

  final AIComposerController controller;

  Future<void> _openAttachmentSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => ComposerAttachmentSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = !controller.isGenerating;
    final iconColor = enabled ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.3);

    return Tooltip(
      message: 'Add photos',
      child: InkWell(
        onTap: enabled ? () => _openAttachmentSheet(context) : null,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            // Same fill/border tokens as the input pill (see
            // `_InputContainer` in stream_ai_composer.dart) so the two read
            // as one connected surface rather than mismatched colors.
            color: colorScheme.surfaceContainerHigh,
            shape: BoxShape.circle,
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.add, size: 22, color: iconColor),
        ),
      ),
    );
  }
}
