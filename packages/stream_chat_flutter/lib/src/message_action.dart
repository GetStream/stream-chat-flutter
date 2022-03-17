import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@macro message_action}
@Deprecated("Use 'StreamMessageActions' instead")
typedef MessageAction = StreamMessageAction;

/// {@template message_action}
/// Class describing a message action
/// {@endtemplate}
class StreamMessageAction {
  /// returns a new instance of a [StreamMessageAction]
  StreamMessageAction({
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
