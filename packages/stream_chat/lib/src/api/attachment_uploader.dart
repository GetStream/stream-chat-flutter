import 'package:dio/dio.dart';
import 'package:stream_chat/src/models/attachment_file.dart';
import '../client.dart';
import '../extensions/string_extension.dart';

///
abstract class AttachmentUploader {
  ///
  Future<String> uploadImage(
    AttachmentFile file,
    String channelId,
    String channelType, {
    ProgressCallback onSendProgress,
    CancelToken cancelToken,
  });

  ///
  Future<String> uploadFile(
    AttachmentFile file,
    String channelId,
    String channelType, {
    ProgressCallback onSendProgress,
    CancelToken cancelToken,
  });
}

///
class StreamAttachmentUploader implements AttachmentUploader {
  final StreamChatClient _client;

  ///
  const StreamAttachmentUploader(this._client);

  @override
  Future<String> uploadImage(
    AttachmentFile file,
    String channelId,
    String channelType, {
    ProgressCallback onSendProgress,
    CancelToken cancelToken,
  }) async {
    final filename = file.path?.split('/')?.last;
    final mimeType = filename.mimeType;
    final res = await _client.sendImage(
      await MultipartFile.fromFile(
        file.path,
        filename: filename,
        contentType: mimeType,
      ),
      channelId,
      channelType,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
    return res.file;
  }

  @override
  Future<String> uploadFile(
    AttachmentFile file,
    String channelId,
    String channelType, {
    ProgressCallback onSendProgress,
    CancelToken cancelToken,
  }) async {
    final filename = file.path?.split('/')?.last;
    final mimeType = filename.mimeType;
    final res = await _client.sendFile(
      await MultipartFile.fromFile(
        file.path,
        filename: filename,
        contentType: mimeType,
      ),
      channelId,
      channelType,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
    return res.file;
  }
}
