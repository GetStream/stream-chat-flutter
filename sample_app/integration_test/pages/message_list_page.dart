import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

abstract final class MessageListPage {
  static const composer = _Composer();
}

final class _Composer {
  const _Composer();

  Type get inputField => StreamMessageComposerInputField;
  Key get sendButton => const ValueKey('send_key');
}
