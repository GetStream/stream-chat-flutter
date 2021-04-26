import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'attachment_actions_modal.dart';

class ImageHeader extends StatelessWidget implements PreferredSizeWidget {
  /// True if this header shows the leading back button
  final bool showBackButton;

  /// Callback to call when pressing the back button.
  /// By default it calls [Navigator.pop]
  final VoidCallback? onBackPressed;

  /// Callback to call when pressing the show message button.
  final VoidCallback? onShowMessage;

  /// Callback to call when the header is tapped.
  final VoidCallback? onTitleTap;

  /// Callback to call when the image is tapped.
  final VoidCallback? onImageTap;

  final Message message;

  final String userName;
  final String sentAt;

  final List<Attachment> urls;
  final currentIndex;

  /// Creates a channel header
  ImageHeader({
    Key? key,
    required this.message,
    this.urls = const [],
    this.currentIndex,
    this.showBackButton = true,
    this.onBackPressed,
    this.onShowMessage,
    this.onTitleTap,
    this.onImageTap,
    this.userName = '',
    this.sentAt = '',
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: Theme.of(context).brightness,
      elevation: 1,
      leading: showBackButton
          ? IconButton(
              icon: StreamSvgIcon.close(
                color: StreamChatTheme.of(context).colorTheme.black,
                size: 24.0,
              ),
              onPressed: onBackPressed,
            )
          : SizedBox(),
      backgroundColor:
          StreamChatTheme.of(context).channelTheme.channelHeaderTheme.color,
      actions: <Widget>[
        if (message.type != 'ephemeral')
          IconButton(
            icon: StreamSvgIcon.iconMenuPoint(
              color: StreamChatTheme.of(context).colorTheme.black,
            ),
            onPressed: () {
              _showMessageActionModalBottomSheet(context);
            },
          ),
      ],
      centerTitle: true,
      title: message.type != 'ephemeral'
          ? InkWell(
              onTap: onTitleTap,
              child: Container(
                height: preferredSize.height,
                width: preferredSize.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      userName,
                      style: StreamChatTheme.of(context).textTheme.headlineBold,
                    ),
                    Text(
                      sentAt,
                      style: StreamChatTheme.of(context)
                          .channelPreviewTheme
                          .subtitle,
                    ),
                  ],
                ),
              ),
            )
          : SizedBox(),
    );
  }

  @override
  final Size preferredSize;

  void _showMessageActionModalBottomSheet(BuildContext context) async {
    final channel = StreamChannel.of(context).channel;

    final result = await showDialog(
      context: context,
      barrierColor: StreamChatTheme.of(context).colorTheme.overlay,
      builder: (context) {
        return StreamChannel(
          channel: channel,
          child: AttachmentActionsModal(
            message: message,
            currentIndex: currentIndex,
            onShowMessage: onShowMessage,
          ),
        );
      },
    );

    if (result != null) {
      Navigator.pop(context, result);
    }
  }
}
