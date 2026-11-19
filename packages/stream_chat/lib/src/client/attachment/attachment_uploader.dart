import 'package:dio/dio.dart';

import '../../core/api/responses.dart';
import '../../core/error/error.dart';
import '../../core/models/attachment.dart';
import '../../core/models/attachment_file.dart';
import '../client.dart';

/// An uploader of attachment files to one channel.
///
/// It turns attachment files into remote URLs. Keeping the attachments and
/// their progress somewhere is up to the caller.
class ChannelAttachmentUploader {
  /// Creates an uploader that sends files to the channel `channelId` of
  /// `channelType` through `client`.
  ChannelAttachmentUploader({
    required this._client,
    required this._channelId,
    required this._channelType,
  });

  final StreamChatClient _client;
  final String _channelId;
  final String _channelType;

  final _cancelTokens = <String, CancelToken>{};

  /// Uploads the file of [attachment].
  ///
  /// While the [Attachment.file] is sent, [onProgress] is called with the
  /// bytes sent so far and the total. An [attachment] already uploaded is
  /// returned as it is.
  ///
  /// Completes with [attachment] in an [UploadState.success], its remote URL
  /// set: [Attachment.imageUrl] for an image, otherwise [Attachment.assetUrl],
  /// along with [Attachment.thumbUrl] when the file has a thumbnail. Completes
  /// with [attachment] in an [UploadState.failed] if the upload failed or it
  /// has no file, and with null if it was canceled. Never completes with an
  /// error.
  Future<Attachment?> upload(
    Attachment attachment, {
    ProgressCallback? onProgress,
  }) async {
    if (attachment.uploadState.isSuccess) return attachment;

    final file = attachment.file;
    if (file == null) {
      const failed = UploadState.failed(error: 'The attachment has no file');
      return attachment.copyWith(uploadState: failed);
    }

    final cancelToken = _cancelTokens[attachment.id] = CancelToken();

    try {
      final send = switch (attachment.type) {
        AttachmentType.image => _client.sendImage,
        _ => _client.sendFile,
      };

      final response = await send(
        file,
        _channelId,
        _channelType,
        onSendProgress: onProgress,
        cancelToken: cancelToken,
        extraData: attachment.extraData,
      );

      final uploaded = switch (response) {
        SendFileResponse(:final thumbUrl) => attachment.copyWith(
          assetUrl: response.file,
          thumbUrl: thumbUrl,
        ),
        _ => attachment.copyWith(imageUrl: response.file),
      };

      return uploaded.copyWith(uploadState: const UploadState.success());
    } catch (error, stackTrace) {
      if (error is StreamChatNetworkError && error.type == .cancel) {
        _client.logger.info('Attachment ${attachment.id} upload canceled');
        return null;
      }

      final message = 'Failed to upload attachment ${attachment.id}';
      _client.logger.severe(message, error, stackTrace);

      final failed = UploadState.failed(error: error.toString());
      return attachment.copyWith(uploadState: failed);
    } finally {
      if (_cancelTokens[attachment.id] == cancelToken) {
        _cancelTokens.remove(attachment.id);
      }
    }
  }

  /// Cancels the upload of the attachment [attachmentId], for [reason] if
  /// given.
  ///
  /// Its [upload] then completes with null.
  ///
  /// Returns false if the attachment was not uploading, or its upload was
  /// already canceled.
  bool cancel(String attachmentId, {String? reason}) {
    final cancelToken = _cancelTokens.remove(attachmentId);
    if (cancelToken == null) return false;

    cancelToken.cancel(reason);
    return true;
  }
}
