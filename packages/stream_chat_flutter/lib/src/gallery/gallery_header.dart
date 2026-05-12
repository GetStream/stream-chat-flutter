import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamGalleryHeader}
/// Header bar for the gallery / media display screen.
///
/// Renders a [StreamAppBar] whose default title is the sender's [userName]
/// and whose default subtitle is the [sentAt] timestamp. The default
/// trailing action opens an [AttachmentActionsModal] for the focused
/// [attachment].
///
/// The bar's chrome (background, padding, typography, divider) is themed via
/// `StreamChatThemeData.galleryHeaderTheme`. Per-instance overrides go on
/// [style].
/// {@endtemplate}
class StreamGalleryHeader extends StatelessWidget implements PreferredSizeWidget {
  /// {@macro streamGalleryHeader}
  const StreamGalleryHeader({
    super.key,
    required this.message,
    required this.attachment,
    this.onShowMessage,
    this.onReplyMessage,
    this.userName = '',
    this.sentAt = '',
    this.attachmentActionsModalBuilder,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.subtitle,
    this.trailing,
    this.primary = true,
    this.style,
  });

  /// Callback to call when pressing the show message button.
  final VoidCallback? onShowMessage;

  /// Callback to call when pressing the reply message button.
  final VoidCallback? onReplyMessage;

  /// Message which attachments are attached to.
  final Message message;

  /// The attachment that's currently in focus.
  final Attachment attachment;

  /// Username of sender.
  final String userName;

  /// Text which connotes the time the message was sent.
  final String sentAt;

  /// {@macro attachmentActionsBuilder}
  final AttachmentActionsBuilder? attachmentActionsModalBuilder;

  /// {@macro StreamAppBar.leading}
  final Widget? leading;

  /// {@macro StreamAppBar.automaticallyImplyLeading}
  final bool automaticallyImplyLeading;

  /// {@macro StreamAppBar.title}
  ///
  /// Defaults to a [Text] showing [userName].
  final Widget? title;

  /// {@macro StreamAppBar.subtitle}
  ///
  /// Defaults to a [Text] showing [sentAt].
  final Widget? subtitle;

  /// {@macro StreamAppBar.trailing}
  ///
  /// Defaults to an icon button that opens the attachment actions modal.
  final Widget? trailing;

  /// {@macro StreamAppBar.primary}
  final bool primary;

  /// {@macro StreamAppBar.style}
  ///
  /// Per-instance override; merges over
  /// `StreamChatThemeData.galleryHeaderTheme`.
  final StreamAppBarStyle? style;

  @override
  Size get preferredSize => const Size.fromHeight(kStreamHeaderHeight);

  @override
  Widget build(BuildContext context) {
    final headerTheme = StreamChatTheme.of(context).galleryHeaderTheme;

    // Ephemeral messages (e.g. previews of unsent attachments) don't have
    // sender / timestamp metadata to surface, so the title / subtitle /
    // overflow-action defaults are suppressed — caller-provided slots
    // still flow through.
    var title = this.title;
    if (title == null && !message.isEphemeral) {
      title = Text(userName);
    }

    var subtitle = this.subtitle;
    if (subtitle == null && !message.isEphemeral) {
      subtitle = Text(sentAt);
    }

    var trailing = this.trailing;
    if (trailing == null && !message.isEphemeral) {
      trailing = IconButton(
        icon: Icon(context.streamIcons.more),
        onPressed: () => _showMessageActionModalBottomSheet(context),
      );
    }

    return StreamAppBarTheme(
      data: headerTheme,
      child: StreamAppBar(
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        primary: primary,
        style: style,
      ),
    );
  }

  Future<void> _showMessageActionModalBottomSheet(BuildContext context) async {
    final channel = StreamChannel.of(context).channel;
    final colorTheme = StreamChatTheme.of(context).colorTheme;

    final defaultModal = AttachmentActionsModal(
      attachment: attachment,
      message: message,
      onShowMessage: onShowMessage,
      onReply: onReplyMessage,
    );

    final effectiveModal =
        attachmentActionsModalBuilder?.call(
          context,
          attachment,
          defaultModal,
        ) ??
        defaultModal;

    final result = await showDialog(
      useRootNavigator: false,
      context: context,
      barrierColor: colorTheme.overlay,
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
