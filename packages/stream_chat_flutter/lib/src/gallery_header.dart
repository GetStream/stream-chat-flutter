import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment_actions_modal.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Header/AppBar widget for media display screen
class GalleryHeader extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a channel header
  const GalleryHeader({
    Key? key,
    required this.message,
    this.currentIndex = 0,
    this.showBackButton = true,
    this.onBackPressed,
    this.onShowMessage,
    this.onTitleTap,
    this.onImageTap,
    this.userName = '',
    this.sentAt = '',
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

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

  /// Message which attachments are attached to
  final Message message;

  /// Username of sender
  final String userName;

  /// Text which connotes the time the message was sent
  final String sentAt;

  /// Stores the current index of media shown
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final galleryHeaderThemeData = GalleryHeaderTheme.of(context);
    return AppBar(
      textTheme: Theme.of(context).textTheme,
      brightness: Theme.of(context).brightness,
      elevation: 1,
      leading: showBackButton
          ? IconButton(
              icon: StreamSvgIcon.close(
                color: galleryHeaderThemeData.closeButtonColor,
                size: 24,
              ),
              onPressed: onBackPressed,
            )
          : const SizedBox(),
      backgroundColor: galleryHeaderThemeData.backgroundColor,
      actions: <Widget>[
        if (message.type != 'ephemeral')
          IconButton(
            icon: StreamSvgIcon.iconMenuPoint(
              color: galleryHeaderThemeData.iconMenuPointColor,
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
              child: SizedBox(
                height: preferredSize.height,
                width: preferredSize.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      userName,
                      style: galleryHeaderThemeData.titleTextStyle,
                    ),
                    Text(
                      sentAt,
                      style: galleryHeaderThemeData.subtitleTextStyle,
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox(),
    );
  }

  @override
  final Size preferredSize;

  void _showMessageActionModalBottomSheet(BuildContext context) async {
    final channel = StreamChannel.of(context).channel;
    final galleryHeaderThemeData =
        StreamChatTheme.of(context).galleryHeaderTheme;

    final result = await showDialog(
      useRootNavigator: false,
      context: context,
      barrierColor: galleryHeaderThemeData.bottomSheetBarrierColor,
      builder: (context) => StreamChannel(
        channel: channel,
        child: AttachmentActionsModal(
          message: message,
          currentIndex: currentIndex,
          onShowMessage: onShowMessage,
        ),
      ),
    );

    if (result != null) {
      Navigator.pop(context, result);
    }
  }
}
