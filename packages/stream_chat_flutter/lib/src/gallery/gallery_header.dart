import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/src/attachment_actions_modal/attachment_actions_modal.dart';
import 'package:stream_chat_flutter/src/misc/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/theme/themes.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@macro streamGalleryHeader}
/// Header/AppBar widget for media display screen
/// {@endtemplate}
class StreamGalleryHeader extends StatelessWidget
    implements PreferredSizeWidget {
  /// {@macro streamGalleryHeader}
  const StreamGalleryHeader({
    super.key,
    required this.message,
    required this.attachment,
    this.showBackButton = true,
    this.onBackPressed,
    this.onShowMessage,
    this.onReplyMessage,
    this.onTitleTap,
    this.onImageTap,
    this.userName = '',
    this.sentAt = '',
    this.backgroundColor,
    this.attachmentActionsModalBuilder,
    this.elevation = 1.0,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  /// Whether to show the leading back button.
  ///
  /// Defaults to `true`.
  final bool showBackButton;

  /// Callback to call when pressing the back button.
  /// By default it calls [Navigator.pop]
  final VoidCallback? onBackPressed;

  /// Callback to call when pressing the show message button.
  final VoidCallback? onShowMessage;

  /// Callback to call when pressing the reply message button.
  final VoidCallback? onReplyMessage;

  /// Callback to call when the header is tapped.
  final VoidCallback? onTitleTap;

  /// Callback to call when the image is tapped.
  final VoidCallback? onImageTap;

  /// Message which attachments are attached to
  final Message message;

  /// The attachment that's currently in focus
  final Attachment attachment;

  /// Username of sender
  final String userName;

  /// Text which connotes the time the message was sent
  final String sentAt;

  /// The background color of this [StreamGalleryHeader].
  final Color? backgroundColor;

  /// {@macro attachmentActionsBuilder}
  final AttachmentActionsBuilder? attachmentActionsModalBuilder;

  /// The elevation of this [StreamGalleryHeader].
  ///
  /// Defaults to `1.0`. When used for desktop & web platforms, it should
  /// be set to `0.0`.
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final galleryHeaderThemeData = StreamGalleryHeaderTheme.of(context);
    final theme = Theme.of(context);
    return AppBar(
      toolbarTextStyle: theme.textTheme.bodyText2,
      titleTextStyle: theme.textTheme.headline6,
      systemOverlayStyle: theme.brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      elevation: elevation,
      leading: showBackButton
          ? IconButton(
              icon: StreamSvgIcon.close(
                color: galleryHeaderThemeData.closeButtonColor,
                size: 24,
              ),
              onPressed: onBackPressed,
            )
          : const SizedBox(),
      backgroundColor:
          backgroundColor ?? galleryHeaderThemeData.backgroundColor,
      actions: <Widget>[
        if (!message.isEphemeral)
          IconButton(
            icon: StreamSvgIcon.iconMenuPoint(
              color: galleryHeaderThemeData.iconMenuPointColor,
            ),
            onPressed: () => _showMessageActionModalBottomSheet(context),
          ),
      ],
      centerTitle: true,
      title: !message.isEphemeral
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

  Future<void> _showMessageActionModalBottomSheet(BuildContext context) async {
    final channel = StreamChannel.of(context).channel;
    final galleryHeaderThemeData =
        StreamChatTheme.of(context).galleryHeaderTheme;

    final defaultModal = AttachmentActionsModal(
      attachment: attachment,
      message: message,
      onShowMessage: onShowMessage,
      onReply: onReplyMessage,
    );

    final effectiveModal = attachmentActionsModalBuilder?.call(
          context,
          attachment,
          defaultModal,
        ) ??
        defaultModal;

    final result = await showDialog(
      useRootNavigator: false,
      context: context,
      barrierColor: galleryHeaderThemeData.bottomSheetBarrierColor,
      builder: (context) => StreamChannel(
        channel: channel,
        child: effectiveModal,
      ),
    );

    if (result != null) {
      Navigator.of(context).pop(result);
    }
  }
}
