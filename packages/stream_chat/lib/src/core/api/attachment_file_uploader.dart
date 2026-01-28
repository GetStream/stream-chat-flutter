import 'package:dio/dio.dart';
import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/core/models/attachment_file.dart';

/// Signature for a function which provides instance of [AttachmentFileUploader]
typedef AttachmentFileUploaderProvider = AttachmentFileUploader Function(
  StreamHttpClient httpClient,
);

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
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
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
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  });

  /// Deletes a image using its [url] from the given channel.
  /// Returns [EmptyResponse] once deleted successfully.
  ///
  /// Optionally, cancel the request using [cancelToken]
  Future<EmptyResponse> deleteImage(
    String url,
    String channelId,
    String channelType, {
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  });

  /// Deletes a file using its [url] from the given channel.
  /// Returns [EmptyResponse] once deleted successfully.
  ///
  /// Optionally, cancel the request using [cancelToken]
  Future<EmptyResponse> deleteFile(
    String url,
    String channelId,
    String channelType, {
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  });

  // region Standalone upload methods

  /// Uploads an image file to the CDN.
  ///
  /// Upload progress can be tracked using [onSendProgress], and the operation
  /// can be cancelled using [cancelToken].
  ///
  /// Returns a [UploadImageResponse] once uploaded successfully.
  Future<UploadImageResponse> uploadImage(
    AttachmentFile image, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  });

  /// Uploads a file to the CDN.
  ///
  /// Upload progress can be tracked using [onSendProgress], and the operation
  /// can be cancelled using [cancelToken].
  ///
  /// Returns a [UploadFileResponse] once uploaded successfully.
  Future<UploadFileResponse> uploadFile(
    AttachmentFile file, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  });

  /// Removes an image from the CDN using its [url].
  ///
  /// The operation can be cancelled using [cancelToken] if needed.
  ///
  /// Returns a [EmptyResponse] once removed successfully.
  Future<EmptyResponse> removeImage(
    String url, {
    CancelToken? cancelToken,
  });

  /// Removes a file from the CDN using its [url].
  ///
  /// The operation can be cancelled using [cancelToken] if needed.
  ///
  /// Returns a [EmptyResponse] once removed successfully.
  Future<EmptyResponse> removeFile(
    String url, {
    CancelToken? cancelToken,
  });

  // endregion
}

/// Stream's default implementation of [AttachmentFileUploader]
class StreamAttachmentFileUploader implements AttachmentFileUploader {
  /// Creates a new [StreamAttachmentFileUploader] instance.
  const StreamAttachmentFileUploader(this._client);

  final StreamHttpClient _client;

  @override
  Future<SendImageResponse> sendImage(
    AttachmentFile file,
    String channelId,
    String channelType, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  }) async {
    final multiPartFile = await file.toMultipartFile();
    final response = await _client.postFile(
      '/channels/$channelType/$channelId/image',
      multiPartFile,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
    return SendImageResponse.fromJson(response.data);
  }

  @override
  Future<SendFileResponse> sendFile(
    AttachmentFile file,
    String channelId,
    String channelType, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  }) async {
    final multiPartFile = await file.toMultipartFile();
    final response = await _client.postFile(
      '/channels/$channelType/$channelId/file',
      multiPartFile,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
    return SendFileResponse.fromJson(response.data);
  }

  @override
  Future<EmptyResponse> deleteImage(
    String url,
    String channelId,
    String channelType, {
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  }) async {
    final response = await _client.delete(
      '/channels/$channelType/$channelId/image',
      queryParameters: {'url': url},
      cancelToken: cancelToken,
    );
    return EmptyResponse.fromJson(response.data);
  }

  @override
  Future<EmptyResponse> deleteFile(
    String url,
    String channelId,
    String channelType, {
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  }) async {
    final response = await _client.delete(
      '/channels/$channelType/$channelId/file',
      queryParameters: {'url': url},
      cancelToken: cancelToken,
    );
    return EmptyResponse.fromJson(response.data);
  }

  @override
  Future<UploadImageResponse> uploadImage(
    AttachmentFile image, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    final multiPartFile = await image.toMultipartFile();
    final response = await _client.postFile(
      '/uploads/image',
      multiPartFile,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
    return UploadImageResponse.fromJson(response.data);
  }

  @override
  Future<UploadFileResponse> uploadFile(
    AttachmentFile file, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    final multiPartFile = await file.toMultipartFile();
    final response = await _client.postFile(
      '/uploads/file',
      multiPartFile,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
    return UploadFileResponse.fromJson(response.data);
  }

  @override
  Future<EmptyResponse> removeImage(
    String url, {
    CancelToken? cancelToken,
  }) async {
    final response = await _client.delete(
      '/uploads/image',
      queryParameters: {'url': url},
      cancelToken: cancelToken,
    );
    return EmptyResponse.fromJson(response.data);
  }

  @override
  Future<EmptyResponse> removeFile(
    String url, {
    CancelToken? cancelToken,
  }) async {
    final response = await _client.delete(
      '/uploads/file',
      queryParameters: {'url': url},
      cancelToken: cancelToken,
    );
    return EmptyResponse.fromJson(response.data);
  }
}
