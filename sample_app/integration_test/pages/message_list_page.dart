import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Selectors for the message list screen. Mirrors the Android `MessageListPage`.
///
/// Reuses identifiers the SDK already exposes (widget types / existing keys)
/// rather than adding test-only keys to the source.
abstract final class MessageListPage {
  static const composer = _Composer();
}

final class _Composer {
  const _Composer();

  /// The composer text field — matched by its exported widget type.
  Type get inputField => StreamMessageComposerInputField;

  /// The send button — reuses the key the SDK already sets for its
  /// `AnimatedSwitcher`.
  Key get sendButton => const ValueKey('send_key');
}
