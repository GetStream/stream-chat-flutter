import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:native_context_menu/native_context_menu.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A [MenuItem] that will allow a user to copy the text of a message.
///
/// Used only for desktop and web platforms.
class CopyMessageMenuItem extends MenuItem {
  /// Builds a [CopyMessageMenuItem].
  CopyMessageMenuItem({
    String title = 'Copy Message',
    required this.message,
  }) : super(title: title);

  /// The message to copy.
  final Message message;

  @override
  VoidCallback? get onPin =>
      () => Clipboard.setData(ClipboardData(text: message.text));
}
