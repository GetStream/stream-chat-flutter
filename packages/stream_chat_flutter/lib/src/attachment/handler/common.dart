import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Represents the url and bytes of an attachment.
class AttachmentData {
  /// Creates a new [AttachmentData] instance.
  const AttachmentData({
    required this.bytes,
    required this.downloadUrl,
    required this.fileName,
    this.mimeType,
  });

  /// The data downloaded from the [downloadUrl].
  final Uint8List bytes;

  /// The url of the attachment that was used to download the [bytes].
  final String downloadUrl;

  /// The name of the file to use when saving the [bytes].
  final String fileName;

  /// The mime type of the attachment.
  final String? mimeType;

  /// Creates an [XFile] from the [AttachmentData].
  XFile toXFile({String? path}) {
    return XFile.fromData(
      bytes,
      mimeType: mimeType,
      name: fileName,
      path: path,
    );
  }
}

/// Downloads the [attachment] and returns the [AttachmentData].
Future<AttachmentData> downloadAttachmentData(
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
  if (type == AttachmentType.image) {
    downloadUrl = attachment.imageUrl ?? attachment.assetUrl;
    fileName = attachment.title;
    fileName ??= 'attachment.${attachment.mimeType ?? 'png'}';
  }
  /* ---GIPHY's--- */
  else if (type == AttachmentType.giphy) {
    downloadUrl = attachment.thumbUrl;
    fileName = '${attachment.title}.gif';
  }
  /* ---FILES AND VIDEOS--- */
  else if (type == AttachmentType.file || type == AttachmentType.video) {
    downloadUrl = attachment.assetUrl;
    fileName = attachment.title;
  }

  if (downloadUrl == null) {
    throw ArgumentError(
      'Attachment must have an assetUrl or imageUrl or thumbUrl',
    );
  }

  final response = await Dio().get<List<int>>(
    downloadUrl,
    onReceiveProgress: onReceiveProgress,
    queryParameters: queryParameters,
    cancelToken: cancelToken,
    // set responseType to `bytes`
    options: options?.copyWith(responseType: ResponseType.bytes) ??
        Options(responseType: ResponseType.bytes),
  );

  final bytes = Uint8List.fromList(response.data!);

  return AttachmentData(
    bytes: bytes,
    downloadUrl: downloadUrl,
    fileName: fileName!,
    mimeType: attachment.mimeType,
  );
}
