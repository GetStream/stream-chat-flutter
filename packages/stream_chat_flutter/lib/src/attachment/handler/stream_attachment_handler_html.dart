import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:stream_chat_flutter/src/attachment/handler/stream_attachment_handler_base.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// StreamAttachmentHandler implementation for html.
class StreamAttachmentHandler extends StreamAttachmentHandlerBase {
  StreamAttachmentHandler._();

  static StreamAttachmentHandler? _instance;

  /// Returns the singleton instance of [StreamAttachmentHandler].
  // ignore: prefer_constructors_over_static_methods
  static StreamAttachmentHandler get instance =>
      _instance ??= StreamAttachmentHandler._();

  late final _filePicker = FilePicker.platform;

  @override
  Future<Attachment?> pickFile({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = true,
    bool withData = true,
    bool withReadStream = false,
    bool lockParentWindow = true,
  }) async {
    final result = await _filePicker.pickFiles(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      type: type,
      allowedExtensions: allowedExtensions,
      onFileLoading: onFileLoading,
      allowCompression: allowCompression,
      withData: withData,
      withReadStream: withReadStream,
      lockParentWindow: lockParentWindow,
    );

    return result?.files.first.toAttachment(type: type.toAttachmentType());
  }

  @override
  Future<String?> downloadAttachment(
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

    // Create an XFile for proper file saving
    final file = XFile.fromData(
      Uint8List.fromList(response.data!),
      mimeType: attachment.mimeType,
      name: fileName,
    );

    // Save the file to the user's selected path.
    // The parameter is ignored in web implementation.
    await file.saveTo('');
    return null;
  }
}
