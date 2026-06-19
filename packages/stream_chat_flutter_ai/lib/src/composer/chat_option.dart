import 'package:flutter/widgets.dart';

/// A suggested action that the user can tap to pre-fill the AI composer.
///
/// Rendered as a tappable chip above the input field. When selected, it is
/// displayed inline inside the input area with a dismiss button.
///
/// Mirrors the `ChatOption` type in the stream-chat-swift-ai library.
class ChatOption {
  /// Creates a [ChatOption].
  const ChatOption({
    required this.id,
    required this.text,
    this.icon,
  });

  /// A unique identifier for this option, used for equality and keying.
  final String id;

  /// The label displayed on the chip and passed to the send callback when this
  /// option is active.
  final String text;

  /// Optional icon shown to the left of [text] in the chip.
  final IconData? icon;

  @override
  bool operator ==(Object other) => other is ChatOption && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
