import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Downloads the [attachment] to the device and returns
/// the path to the file.
Future<String?> downloadWebOrDesktopAttachment(
  Attachment attachment, {
  ProgressCallback? onReceiveProgress,
  Map<String, dynamic>? queryParameters,
  CancelToken? cancelToken,
  Options? options,
}) async {
  final type = attachment.type;

  String? downloadUrl;
  String? fileName;
  /* ---IMAGES/GIFS--- */
  if (type == 'image') {
    downloadUrl = attachment.imageUrl ?? attachment.assetUrl;
    fileName = attachment.title;
    fileName ??= 'attachment.${attachment.mimeType ?? 'png'}';
  }
  /* ---GIPHY's--- */
  else if (type == 'giphy') {
    downloadUrl = attachment.thumbUrl;
    fileName = '${attachment.title}.gif';
  }
  /* ---FILES AND VIDEOS--- */
  else if (type == 'file' || type == 'video') {
    downloadUrl = attachment.assetUrl;
    fileName = attachment.title;
  }

  assert(
    downloadUrl != null,
    'Attachment must have an assetUrl or imageUrl or thumbUrl',
  );

  final response = await Dio().get<List<int>>(
    downloadUrl!,
    onReceiveProgress: onReceiveProgress,
    queryParameters: queryParameters,
    cancelToken: cancelToken,
    // set responseType to `bytes`
    options: options?.copyWith(responseType: ResponseType.bytes) ??
        Options(responseType: ResponseType.bytes),
  );

  // Open the native file browser so the user can select the download path.
  final path = await getSavePath(suggestedName: fileName);

  if (path == null) {
    // Operation was canceled by the user.
    return null;
  }

  // Create an XFile for proper file saving
  final file = XFile.fromData(
    Uint8List.fromList(response.data!),
    mimeType: attachment.mimeType,
    name: fileName,
    path: path,
  );

  // Save the file to the user's selected path.
  await file.saveTo(path);
  return path;
}
