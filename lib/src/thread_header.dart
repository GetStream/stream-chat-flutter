import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

class ThreadHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback onBackPressed;
  final Message parent;

  ThreadHeader({
    Key key,
    @required this.parent,
    this.showBackButton = true,
    this.onBackPressed,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 1,
      backgroundColor:
          StreamChatTheme.of(context).channelTheme.channelHeaderTheme.color,
      actions: <Widget>[
        Container(
          child: showBackButton ? _buildBackButton(context) : Container(),
        ),
      ],
      centerTitle: false,
      title: Text.rich(
        TextSpan(
          text: 'Thread',
          children: [
            TextSpan(
              text:
                  '   ${parent.replyCount} ${parent.replyCount == 1 ? 'reply' : 'replies'}',
              style: StreamChatTheme.of(context)
                  .channelTheme
                  .channelHeaderTheme
                  .lastMessageAt,
            ),
          ],
        ),
        style:
            StreamChatTheme.of(context).channelTheme.channelHeaderTheme.title,
      ),
    );
  }

  Padding _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: RawMaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          elevation: 0,
          highlightElevation: 0,
          focusElevation: 0,
          disabledElevation: 0,
          hoverElevation: 0,
          onPressed: () {
            if (onBackPressed != null) {
              onBackPressed();
            } else {
              Navigator.of(context).pop();
            }
          },
          fillColor: Colors.black.withOpacity(.1),
          padding: EdgeInsets.all(4),
          child: Icon(
            Icons.close,
            size: 15,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  final Size preferredSize;
}
