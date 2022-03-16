import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/utils/typedefs.dart';

/// {@template messageAction}
/// Class describing a message action
/// {@endtemplate}
class MessageAction {
  /// {@macro messageAction}
  MessageAction({
    this.leading,
    this.title,
    this.onTap,
  });

  /// leading widget
  final Widget? leading;

  /// title widget
  final Widget? title;

  /// {@macro onMessageTap}
  final OnMessageTap? onTap;
}
