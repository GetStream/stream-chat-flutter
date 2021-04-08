import 'package:dio/dio.dart';
import 'package:stream_chat/src/api/responses.dart';
import 'package:stream_chat/src/client.dart';
import 'package:stream_chat/src/models/attachment_file.dart';
import 'package:stream_chat/src/extensions/string_extension.dart';

/// Class responsible for uploading images and files to a given channel
abstract class AttachmentFileUploader {
  /// Uploads a [image] to the given channel.
  /// Returns [SendImageResponse] once sent successfully.
  ///
  /// Optionally, access upload progress using [onSendProgress]
  /// and cancel the request using [cancelToken]
  Future<SendImageResponse?> sendImage(
    AttachmentFile? image,
    String? channelId,
    String? channelType, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  });

  /// Uploads a [file] to the given channel.
  /// Returns [SendFileResponse] once sent successfully.
  ///
  /// Optionally, access upload progress using [onSendProgress]
  /// and cancel the request using [cancelToken]
  Future<SendFileResponse?> sendFile(
    AttachmentFile? file,
    String? channelId,
    String? channelType, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  });

  /// Deletes a image using its [url] from the given channel.
  /// Returns [EmptyResponse] once deleted successfully.
  ///
  /// Optionally, cancel the request using [cancelToken]
  Future<EmptyResponse?> deleteImage(
    String url,
    String? channelId,
    String? channelType, {
    CancelToken? cancelToken,
  });

  /// Deletes a file using its [url] from the given channel.
  /// Returns [EmptyResponse] once deleted successfully.
  ///
  /// Optionally, cancel the request using [cancelToken]
  Future<EmptyResponse?> deleteFile(
    String url,
    String? channelId,
    String? channelType, {
    CancelToken? cancelToken,
  });
}

/// Stream's default implementation of [AttachmentFileUploader]
class StreamAttachmentFileUploader implements AttachmentFileUploader {
  /// Creates a new [StreamAttachmentFileUploader] instance.
  const StreamAttachmentFileUploader(this._client);

  final StreamChatClient _client;

  @override
  Future<SendImageResponse?> sendImage(
    AttachmentFile? file,
    String? channelId,
    String? channelType, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    final filename = file!.path?.split('/')?.last ?? file.name;
    final mimeType = filename.mimeType;

    MultipartFile? multiPartFile;
    if (file.path != null) {
      multiPartFile = await MultipartFile.fromFile(
        file.path!,
        filename: filename,
        contentType: mimeType,
      );
    } else if (file.bytes != null) {
      multiPartFile = MultipartFile.fromBytes(
        file.bytes!,
        filename: filename,
        contentType: mimeType,
      );
    }

    final response = await _client.post(
      '/channels/$channelType/$channelId/image',
      data: FormData.fromMap({
        'file': multiPartFile,
      }),
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
    return _client.decode(response.data, SendImageResponse.fromJson);
  }

  @override
  Future<SendFileResponse?> sendFile(
    AttachmentFile? file,
    String? channelId,
    String? channelType, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    final filename = file!.path?.split('/')?.last ?? file.name;
    final mimeType = filename.mimeType;

    MultipartFile? multiPartFile;
    if (file.path != null) {
      multiPartFile = await MultipartFile.fromFile(
        file.path!,
        filename: filename,
        contentType: mimeType,
      );
    } else if (file.bytes != null) {
      multiPartFile = MultipartFile.fromBytes(
        file.bytes!,
        filename: filename,
        contentType: mimeType,
      );
    }

    final response = await _client.post(
      '/channels/$channelType/$channelId/file',
      data: FormData.fromMap({
        'file': multiPartFile,
      }),
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
    return _client.decode(response.data, SendFileResponse.fromJson);
  }

  @override
  Future<EmptyResponse?> deleteImage(
    String url,
    String? channelId,
    String? channelType, {
    CancelToken? cancelToken,
  }) async {
    final response = await _client.delete(
      '/channels/$channelType/$channelId/image',
      queryParameters: {'url': url},
      cancelToken: cancelToken,
    );
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  @override
  Future<EmptyResponse?> deleteFile(
    String url,
    String? channelId,
    String? channelType, {
    CancelToken? cancelToken,
  }) async {
    final response = await _client.delete(
      '/channels/$channelType/$channelId/file',
      queryParameters: {'url': url},
      cancelToken: cancelToken,
    );
    return _client.decode(response.data, EmptyResponse.fromJson);
  }
}
