import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mock_server/data_types.dart';

abstract final class MessageListPage {
  static const composer = _Composer();
  static const reactions = _Reactions();

  /// The widget that renders a single message row. Long-pressing it opens the
  /// message actions modal (which hosts the reaction picker).
  static Type get messageItem => StreamMessageItem;
}

final class _Composer {
  const _Composer();

  Type get inputField => StreamMessageComposerInputField;
  Key get sendButton => const ValueKey('send_key');
}

final class _Reactions {
  const _Reactions();

  /// Key of a reaction in the reaction picker (message actions modal).
  /// The SDK keys each picker button by its reaction type string.
  Key pickerReaction(ReactionType type) => ValueKey(type.reaction);
}
