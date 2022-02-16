import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:http/http.dart' as http;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// An abstract class for creating utility classes appropriate for various
/// platforms.
abstract class AttachmentHandler {
  /// Uploads an attachment
  void upload();

  /// Downloads an attachment.
  void download(
    Attachment attachment, {
    String? suggestedName,
  });
}

/// A utility class for handling the uploading and downloading of attachments
/// on desktop platforms.
class DesktopAttachmentHandler extends AttachmentHandler {
  @override
  Future<void> download(
    Attachment attachment, {
    String? suggestedName,
  }) async {
    late http.Response response;
    String? fileName;

    /* ---IMAGES/GIFS--- */
    if (attachment.type == 'image') {
      response = await http.get(Uri.parse(attachment.imageUrl!));
      fileName = suggestedName ??
          attachment.title ??
          'attachment.${attachment.mimeType ?? 'png'}';
    }

    /* ---GIPHY's--- */
    if (attachment.type == 'giphy') {
      response = await http.get(Uri.parse((attachment.extraData.entries.first
          .value! as Map<String, dynamic>)['original']['url']));
      fileName = '${suggestedName ?? attachment.title}.gif';
    }

    /* ---FILES AND VIDEOS--- */
    if (attachment.type == 'file' || attachment.type == 'video') {
      response = await http.get(Uri.parse(attachment.assetUrl!));
      fileName = attachment.title;
    }

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
  }

  @override
  void upload() {
    // TODO: implement upload()
    throw UnimplementedError();
  }
}
