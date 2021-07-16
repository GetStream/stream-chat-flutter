import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Class describing a message action
class MessageAction {
  /// returns a new instance of a [MessageAction]
  MessageAction({
    this.leading,
    this.title,
    this.onTap,
  });

  /// leading widget
  final Widget? leading;

  /// title widget
  final Widget? title;

  /// callback called on tap
  final OnMessageTap? onTap;
}
