import 'dart:async';

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
final class ChannelAttachmentUploader {
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

  /// Starts uploading the file of [attachment], and returns the upload.
  ///
  /// While the [Attachment.file] is sent, [onProgress] is called with the
  /// bytes of the file sent so far and its size. An [attachment] already
  /// uploaded is not sent again.
  ChannelAttachmentUpload upload(
    Attachment attachment, {
    ProgressCallback? onProgress,
  }) {
    final cancelToken = CancelToken();
    final upload = ChannelAttachmentUpload._(attachment, cancelToken);
    _upload(attachment, cancelToken, onProgress).then(upload._settle).ignore();

    return upload;
  }

  Future<Attachment?> _upload(
    Attachment attachment,
    CancelToken cancelToken,
    ProgressCallback? onProgress,
  ) async {
    if (attachment.uploadState.isSuccess) return attachment;

    final file = attachment.file;
    if (file == null) {
      const failed = UploadState.failed(error: 'The attachment has no file');
      return attachment.copyWith(uploadState: failed);
    }

    try {
      final send = switch (attachment.type) {
        AttachmentType.image => _client.sendImage,
        _ => _client.sendFile,
      };

      // The request also sends the framing around the file, so its counts are
      // scaled to the file's own size.
      void onSendProgress(int sent, int total) {
        final fileSize = file.size;
        if (fileSize == null || total <= 0) {
          onProgress?.call(sent, total);
        } else {
          final fileSent = (sent / total * fileSize).round().clamp(0, fileSize);
          onProgress?.call(fileSent, fileSize);
        }
      }

      final response = await send(
        file,
        _channelId,
        _channelType,
        onSendProgress: onSendProgress,
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
    }
  }
}

/// The upload of one attachment's file, started by
/// [ChannelAttachmentUploader.upload].
final class ChannelAttachmentUpload {
  ChannelAttachmentUpload._(this.attachment, this._cancelToken);

  /// The attachment as it was when its upload started.
  final Attachment attachment;

  /// The [attachment] once its upload has settled.
  ///
  /// It is in an [UploadState.success] with its remote URL set:
  /// [Attachment.imageUrl] for an image, otherwise [Attachment.assetUrl],
  /// along with [Attachment.thumbUrl] when the file has a thumbnail. It is in
  /// an [UploadState.failed] if the upload failed or it has no file, and null
  /// if the upload was canceled. Never completes with an error.
  Future<Attachment?> get result => _result.future;

  final CancelToken _cancelToken;
  final _result = Completer<Attachment?>();

  /// The ID of the attachment being uploaded.
  String get id => attachment.id;

  /// Cancels the upload, for [reason] if given.
  ///
  /// Its [result] completes with null right away. Can be called more than
  /// once. An upload that has already settled keeps its [result].
  ///
  /// Returns false if the upload had already settled.
  bool cancel({String? reason}) {
    if (_result.isCompleted) return false;

    _cancelToken.cancel(reason);
    _settle(null);
    return true;
  }

  void _settle(Attachment? attachment) {
    if (_result.isCompleted) return;
    _result.complete(attachment);
  }
}
