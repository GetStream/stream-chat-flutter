import 'package:flutter/widgets.dart';

/// A suggested action that the user can select from the composer's
/// attachment sheet (see `ComposerAttachmentSheet`).
///
/// Once selected, it is displayed inline inside the input area as a dismissible
/// chip, and passed to the send callback when the option is active.
///
/// Mirrors the `ChatOption` type in the stream-chat-swift-ai library.
class ChatOption {
  /// Creates a [ChatOption].
  const ChatOption({
    required this.id,
    required this.text,
    this.icon,
    this.description,
  });

  /// A unique identifier for this option, used for equality and keying.
  final String id;

  /// The label displayed for this option, and passed to the send callback
  /// when this option is active.
  final String text;

  /// Optional icon shown to the left of [text].
  final IconData? icon;

  /// Optional subtitle shown below [text] in the attachment sheet's option
  /// list (e.g. `"Visualize anything"` under `"Create image"`).
  final String? description;

  @override
  bool operator ==(Object other) => other is ChatOption && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
