import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:file_selector/file_selector.dart';
import 'package:http/http.dart' as http;
import 'package:native_context_menu/native_context_menu.dart';
import 'package:stream_chat_flutter/src/attachment/AttachmentHandler.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A [MenuItem] that will allow a user to download an attachment from a chat.
///
/// Used only for desktop and web platforms.
class DownloadMenuItem extends MenuItem {
  /// Builds a [DownloadMenuItem].
  DownloadMenuItem({
    String title = 'Download',
    required this.attachment,
  }) : super(title: title);

  /// The [Attachment] to download.
  final Attachment attachment;

  @override
  VoidCallback? get onSelected => () async {
        final attachmentHandler = DesktopAttachmentHandler();
        await attachmentHandler.download(attachment);
      };
}
