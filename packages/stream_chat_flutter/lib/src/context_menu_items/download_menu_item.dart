import 'dart:ui' show VoidCallback;

import 'package:native_context_menu/native_context_menu.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_handler.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A [MenuItem] that will allow a user to download an attachment from a chat.
///
/// Used only for desktop and web platforms.
class DownloadMenuItem extends MenuItem {
  /// Builds a [DownloadMenuItem].
  DownloadMenuItem({
    String title = 'Download',
    required this.attachment,
    this.onDownloadSuccess,
  }) : super(title: title);

  /// The [Attachment] to download.
  final Attachment attachment;

  /// An action that can be performed after a successful download, such as
  /// showing a message to the user.
  final VoidCallback? onDownloadSuccess;

  @override
  VoidCallback? get onSelected {
    return () async {
      final attachmentHandler = DesktopAttachmentHandler();
      final success = await attachmentHandler.download(attachment);
      if (success && onDownloadSuccess != null) {
        onDownloadSuccess!.call();
      }
    };
  }
}
