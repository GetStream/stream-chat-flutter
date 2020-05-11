import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

class DeletedMessage extends StatelessWidget {
  const DeletedMessage({
    Key key,
    @required this.messageTheme,
  }) : super(key: key);

  final MessageTheme messageTheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      'This message was deleted...',
      style: messageTheme.messageText.copyWith(
        fontStyle: FontStyle.italic,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
      ),
    );
  }
}
