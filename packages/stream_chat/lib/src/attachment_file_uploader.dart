import 'package:dio/dio.dart';
import 'package:stream_chat/src/api/responses.dart';
import 'package:stream_chat/src/models/attachment_file.dart';
import 'client.dart';
import 'extensions/string_extension.dart';

/// Class responsible for uploading images and files to a given channel
abstract class AttachmentFileUploader {
  /// Uploads a [image] to the given channel.
  /// Returns [SendImageResponse] once sent successfully.
  ///
  /// Optionally, access upload progress using [onSendProgress]
  /// and cancel the request using [cancelToken]
  Future<SendImageResponse> sendImage(
    AttachmentFile image,
    String channelId,
    String channelType, {
    ProgressCallback onSendProgress,
    CancelToken cancelToken,
  });

  /// Uploads a [file] to the given channel.
  /// Returns [SendFileResponse] once sent successfully.
  ///
  /// Optionally, access upload progress using [onSendProgress]
  /// and cancel the request using [cancelToken]
  Future<SendFileResponse> sendFile(
    AttachmentFile file,
    String channelId,
    String channelType, {
    ProgressCallback onSendProgress,
    CancelToken cancelToken,
  });
}

/// Stream's default implementation of [AttachmentFileUploader]
class StreamAttachmentUploader implements AttachmentFileUploader {
  final StreamChatClient _client;

  /// Creates a new [StreamAttachmentUploader] instance.
  const StreamAttachmentUploader(this._client);

  @override
  Future<SendImageResponse> sendImage(
    AttachmentFile file,
    String channelId,
    String channelType, {
    ProgressCallback onSendProgress,
    CancelToken cancelToken,
  }) async {
    final filename = file.path?.split('/')?.last;
    final mimeType = filename.mimeType;
    final response = await _client.post(
      '/channels/$channelType/$channelId/image',
      data: FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: filename,
          contentType: mimeType,
        ),
      }),
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
    return _client.decode(response.data, SendImageResponse.fromJson);
  }

  @override
  Future<SendFileResponse> sendFile(
    AttachmentFile file,
    String channelId,
    String channelType, {
    ProgressCallback onSendProgress,
    CancelToken cancelToken,
  }) async {
    final filename = file.path?.split('/')?.last;
    final mimeType = filename.mimeType;
    final response = await _client.post(
      '/channels/$channelType/$channelId/file',
      data: FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: filename,
          contentType: mimeType,
        ),
      }),
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
    return _client.decode(response.data, SendFileResponse.fromJson);
  }
}
