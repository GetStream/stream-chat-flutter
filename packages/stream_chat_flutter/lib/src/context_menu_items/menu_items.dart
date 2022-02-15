import 'dart:typed_data';
import 'dart:ui';

import 'package:file_selector/file_selector.dart';
import 'package:http/http.dart' as http;
import 'package:native_context_menu/native_context_menu.dart';
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
        /* TODO(Groovin): Account for other file types and perform operations
            accordingly */
        // Download the image
        final response = await http.get(Uri.parse(attachment.imageUrl!));
        // Create the file name
        /* TODO(Groovin): Create a title if attachment.title is null */
        final fileName = '${attachment.title}.${attachment.mimeType}';
        // Open the native file browser so the user can select the download
        // path
        final path = await getSavePath(
          suggestedName: fileName,
        );

        // Account for canceled operation.
        if (path == null) {
          return;
        }

        // Create an XFile for proper file saving
        final file = XFile.fromData(
          Uint8List.fromList(response.body.codeUnits),
          mimeType: attachment.mimeType,
          name: fileName,
          path: path,
        );
        // Save the file to the user's selected path.
        await file.saveTo(path);
      };
}
