import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart' show PatternMatching, Result, UploadedFile, runSafely;

import '../../cdn/cdn_api.dart';
import '../../client/client.dart';
import '../../repository/mapper/result_mapper.dart';
import '../../repository/mapper/uploads_mapper.dart';
import '../models/attachment_file.dart';

/// Signature for a function that builds an [AttachmentFileUploader] from the client's [Dio].
typedef AttachmentFileUploaderProvider = AttachmentFileUploader Function(Dio dio);

/// Uploads and deletes of files and images, in a channel or standalone.
///
/// [StreamChatClient] builds one and calls it from its upload methods. To replace it, consider implementing
/// this class and returning it from the `attachmentFileUploaderProvider` passed to [StreamChatClient.new].
abstract class AttachmentFileUploader {
  /// Uploads [image] to the channel [channelId] of type [channelType].
  ///
  /// Progress is reported to [onSendProgress], and a [cancelToken] cancels the upload.
  Future<Result<UploadedFile>> sendImage(
    AttachmentFile image,
    String channelId,
    String channelType, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  });

  /// Uploads [file] to the channel [channelId] of type [channelType].
  ///
  /// Progress is reported to [onSendProgress], and a [cancelToken] cancels the upload.
  Future<Result<UploadedFile>> sendFile(
    AttachmentFile file,
    String channelId,
    String channelType, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  });

  /// Deletes the image at [url] from the channel [channelId] of type
  /// [channelType].
  Future<Result<void>> deleteImage(
    String url,
    String channelId,
    String channelType, {
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  });

  /// Deletes the file at [url] from the channel [channelId] of type
  /// [channelType].
  Future<Result<void>> deleteFile(
    String url,
    String channelId,
    String channelType, {
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  });

  // region Standalone upload methods

  /// Uploads [image] outside of any channel.
  ///
  /// Progress is reported to [onSendProgress], and a [cancelToken] cancels the upload.
  Future<Result<UploadedFile>> uploadImage(
    AttachmentFile image, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  });

  /// Uploads [file] outside of any channel.
  ///
  /// Progress is reported to [onSendProgress], and a [cancelToken] cancels the upload.
  Future<Result<UploadedFile>> uploadFile(
    AttachmentFile file, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  });

  /// Deletes the image at [url], uploaded outside of any channel.
  Future<Result<void>> removeImage(
    String url, {
    CancelToken? cancelToken,
  });

  /// Deletes the file at [url], uploaded outside of any channel.
  Future<Result<void>> removeFile(
    String url, {
    CancelToken? cancelToken,
  });

  // endregion
}

/// The default [AttachmentFileUploader], which uploads to Stream's CDN.
class StreamAttachmentFileUploader implements AttachmentFileUploader {
  /// Creates an uploader that sends its requests through [dio].
  StreamAttachmentFileUploader(Dio dio) : this.fromApi(CdnApi(dio));

  /// Creates an uploader that sends its requests through an existing [CdnApi].
  @internal
  const StreamAttachmentFileUploader.fromApi(this._api);

  final CdnApi _api;

  @override
  Future<Result<UploadedFile>> sendImage(
    AttachmentFile image,
    String channelId,
    String channelType, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  }) async {
    final multipart = await runSafely(image.toMultipartFile);
    return multipart.flatMapAsync((multipartFile) async {
      final result = await _api.uploadChannelImage(
        type: channelType,
        id: channelId,
        file: multipartFile,
        onUploadProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      return result.map((it) => it.toModel());
    });
  }

  @override
  Future<Result<UploadedFile>> sendFile(
    AttachmentFile file,
    String channelId,
    String channelType, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  }) async {
    final multipart = await runSafely(file.toMultipartFile);
    return multipart.flatMapAsync((multipartFile) async {
      final result = await _api.uploadChannelFile(
        type: channelType,
        id: channelId,
        file: multipartFile,
        onUploadProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      return result.map((it) => it.toModel());
    });
  }

  @override
  Future<Result<void>> deleteImage(
    String url,
    String channelId,
    String channelType, {
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  }) async {
    final result = await _api.deleteChannelImage(
      type: channelType,
      id: channelId,
      url: url,
      cancelToken: cancelToken,
    );

    return result.ignoreValue();
  }

  @override
  Future<Result<void>> deleteFile(
    String url,
    String channelId,
    String channelType, {
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  }) async {
    final result = await _api.deleteChannelFile(
      type: channelType,
      id: channelId,
      url: url,
      cancelToken: cancelToken,
    );

    return result.ignoreValue();
  }

  @override
  Future<Result<UploadedFile>> uploadImage(
    AttachmentFile image, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    final multipart = await runSafely(image.toMultipartFile);
    return multipart.flatMapAsync((multipartFile) async {
      final result = await _api.uploadImage(
        file: multipartFile,
        onUploadProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      return result.map((it) => it.toModel());
    });
  }

  @override
  Future<Result<UploadedFile>> uploadFile(
    AttachmentFile file, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    final multipart = await runSafely(file.toMultipartFile);
    return multipart.flatMapAsync((multipartFile) async {
      final result = await _api.uploadFile(
        file: multipartFile,
        onUploadProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      return result.map((it) => it.toModel());
    });
  }

  @override
  Future<Result<void>> removeImage(
    String url, {
    CancelToken? cancelToken,
  }) async {
    final result = await _api.deleteImage(
      url: url,
      cancelToken: cancelToken,
    );

    return result.ignoreValue();
  }

  @override
  Future<Result<void>> removeFile(
    String url, {
    CancelToken? cancelToken,
  }) async {
    final result = await _api.deleteFile(
      url: url,
      cancelToken: cancelToken,
    );

    return result.ignoreValue();
  }
}
