import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

/// Widget to show the current list of typing users
class TypingIndicator extends StatelessWidget {
  const TypingIndicator({
    Key key,
    @required this.typings,
    this.style,
  }) : super(key: key);

  /// Style of the text widget
  final TextStyle style;

  /// List of typing users
  final List<User> typings;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${typings.map((u) => u.name).join(',')} ${typings.length == 1 ? 'is' : 'are'} typing...',
      maxLines: 1,
      style: style,
    );
  }
}
