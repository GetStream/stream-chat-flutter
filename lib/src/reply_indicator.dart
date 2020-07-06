import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A reply button indicator
class ReplyIndicator extends StatelessWidget {
  final Message message;
  final VoidCallback onTap;
  final bool reversed;
  final MessageTheme messageTheme;

  const ReplyIndicator({
    Key key,
    this.message,
    this.onTap,
    this.reversed = false,
    this.messageTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var row = [
      Text(
        'Replies: ${message.replyCount}',
        style: messageTheme?.replies,
      ),
      Transform(
        transform: Matrix4.rotationY(reversed ? 0 : pi),
        alignment: Alignment.center,
        child: Icon(
          Icons.subdirectory_arrow_left,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white12
              : Colors.black12,
        ),
      ),
    ];

    if (!reversed) {
      row = row.reversed.toList();
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: row,
        ),
      ),
    );
  }
}
