import 'package:dio/dio.dart';
import 'package:stream_chat/src/models/attachment_file.dart';
import '../client.dart';
import '../extensions/string_extension.dart';

/// Class responsible for uploading images and files from a given channel
abstract class AttachmentUploader {
  /// Uploads a image [file] to the given channel.
  /// Returns image [file] URL once sent successfully.
  ///
  /// Optionally, access upload progress using [onSendProgress]
  /// and cancel the request using [cancelToken]
  Future<String> uploadImage(
    AttachmentFile file,
    String channelId,
    String channelType, {
    ProgressCallback onSendProgress,
    CancelToken cancelToken,
  });

  /// Uploads a [file] to the given channel.
  /// Returns [file] URL once sent successfully.
  ///
  /// Optionally, access upload progress using [onSendProgress]
  /// and cancel the request using [cancelToken]
  Future<String> uploadFile(
    AttachmentFile file,
    String channelId,
    String channelType, {
    ProgressCallback onSendProgress,
    CancelToken cancelToken,
  });
}

/// Stream's default implementation of [AttachmentUploader]
class StreamAttachmentUploader implements AttachmentUploader {
  final StreamChatClient _client;

  /// Creates a new [StreamAttachmentUploader] instance.
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
