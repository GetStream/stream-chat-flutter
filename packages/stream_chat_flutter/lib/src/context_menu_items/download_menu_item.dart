import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_handler.dart';
import 'package:stream_chat_flutter/src/context_menu_items/stream_chat_context_menu_item.dart';
import 'package:stream_chat_flutter/src/dialogs/message_dialog.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template downloadMenuItem}
/// Defines a "download" context menu item that allows a user to download
/// a given attachment.
///
/// Used in [DesktopFullscreenMedia].
/// {@endtemplate}
class DownloadMenuItem extends StatelessWidget {
  /// {@macro downloadMenuItem}
  const DownloadMenuItem({
    Key? key,
    required this.attachment,
  }) : super(key: key);

  /// The attachment to download.
  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    return StreamChatContextMenuItem(
      leading: StreamSvgIcon.download(),
      title: Text(context.translations.downloadLabel),
      onClick: () async {
        Navigator.of(context).pop();
        final attachmentHandler = DesktopAttachmentHandler();
        final success = await attachmentHandler.download(attachment);
        if (success && !kIsWeb) {
          showDialog(
            context: context,
            builder: (_) => const MessageDialog(
              titleText: 'Download Successful!',
              showMessage: false,
            ),
          );
        }
      },
    );
  }
}
