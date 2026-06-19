import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_ai/src/composer/ai_composer_controller.dart';

/// Factory that produces the composable regions of [StreamAIComposer].
///
/// Subclass and override any method to swap out individual slots without
/// rebuilding the entire widget:
///
/// ```dart
/// class MyFactory extends StreamAIComposerFactory {
///   @override
///   Widget buildLeading(BuildContext context, AiComposerController controller) {
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

  /// The widget placed to the left of the input container.
  ///
  /// Returns [SizedBox.shrink] by default (no leading widget).
  Widget buildLeading(BuildContext context, AiComposerController controller) {
    return const SizedBox.shrink();
  }

  /// The widget placed to the right of the input container.
  ///
  /// Returns [SizedBox.shrink] by default (no trailing widget).
  Widget buildTrailing(BuildContext context, AiComposerController controller) {
    return const SizedBox.shrink();
  }
}
