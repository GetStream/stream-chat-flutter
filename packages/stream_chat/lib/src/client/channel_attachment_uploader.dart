import 'dart:async';

import 'package:collection/collection.dart';
import 'package:stream_chat/stream_chat.dart';

/// Manages attachment uploads for the messages of a [Channel].
///
/// Tracks one cancelable in-flight request per attachment and one pending
/// upload wait per message, so message operations can wait for the
/// attachments to finish uploading before hitting the API.
class ChannelAttachmentUploader {
  /// Creates an uploader working on the messages of the given [_channel].
  ChannelAttachmentUploader({required this._channel});

  final Channel _channel;

  final _cancelableAttachmentUploadRequest = <String, CancelToken>{};
  final _messageAttachmentsUploadCompleter = <String, Completer<Message>>{};

  /// Cancels [attachmentId] upload request. Throws exception if the request
  /// hasn't even started yet, Already completed or Already cancelled.
  ///
  /// Optionally, provide a [reason] for the cancellation.
  void cancelAttachmentUpload(
    String attachmentId, {
    String? reason,
  }) {
    final cancelToken = _cancelableAttachmentUploadRequest[attachmentId];
    if (cancelToken == null) {
      throw const StreamChatError(
        "Upload request for this Attachment hasn't started yet or maybe "
        'Already completed',
      );
    }
    if (cancelToken.isCancelled) {
      throw const StreamChatError('Upload request already cancelled');
    }
    cancelToken.cancel(reason);
  }

  /// Uploads every not-yet-successful attachment of [message] and returns
  /// the message as it looks once all the uploads settle.
  ///
  /// The returned message carries the per-attachment upload states, so
  /// callers can distinguish success from partial failure. The wait can be
  /// failed early with [abortPendingUpload].
  Future<Message> uploadMessageAttachments(Message message) {
    final completer = Completer<Message>();
    _messageAttachmentsUploadCompleter[message.id] = completer;

    uploadAttachments(message.id, message.attachments.map((it) => it.id));

    return completer.future;
  }

  /// Fails the pending upload wait for [messageId] with the given [reason],
  /// releasing the caller awaiting [uploadMessageAttachments].
  ///
  /// No-op when no upload wait is pending. In-flight upload requests are not
  /// affected; cancel those with [cancelAttachmentUpload].
  void abortPendingUpload(String messageId, {required String reason}) {
    final completer = _messageAttachmentsUploadCompleter.remove(messageId);
    completer?.completeError(StreamChatError(reason));
  }

  /// Uploads the [attachmentIds] of the message identified by [messageId],
  /// reflecting the upload progress and outcome of each attachment in the
  /// channel state.
  ///
  /// Completes the pending upload wait for the message, if any, once all
  /// the uploads settle. Throws a [StreamChatError] when the message is not
  /// found in the channel state.
  Future<void> uploadAttachments(
    String messageId,
    Iterable<String> attachmentIds,
  ) {
    var message = [
      ..._channel.state!.messages,
      ..._channel.state!.threads.values.expand((messages) => messages),
    ].firstWhereOrNull((it) => it.id == messageId);

    if (message == null) {
      throw const StreamChatError('Error, Message not found');
    }

    final attachments = message.attachments.where((it) {
      if (it.uploadState.isSuccess) return false;
      return attachmentIds.contains(it.id);
    });

    if (attachments.isEmpty) {
      _channel.client.logger.info('No attachments available to upload');
      if (message.attachments.every((it) => it.uploadState.isSuccess)) {
        _messageAttachmentsUploadCompleter.remove(messageId)?.complete(message);
      }
      return Future.value();
    }

    _channel.client.logger.info('Found ${attachments.length} attachments');

    void updateAttachment(Attachment attachment, {bool remove = false}) {
      final index = message!.attachments.indexWhere(
        (it) => it.id == attachment.id,
      );
      if (index != -1) {
        // update or remove attachment from message.
        final List<Attachment> newAttachments;
        if (remove) {
          newAttachments = [...message!.attachments]..removeAt(index);
        } else {
          newAttachments = [...message!.attachments]..[index] = attachment;
        }

        final updatedMessage = message!.copyWith(attachments: newAttachments);
        _channel.state?.updateMessage(updatedMessage);
        // updating original message for next iteration
        message = message!.merge(updatedMessage);
      }
    }

    return Future.wait(
      attachments.map((it) {
        _channel.client.logger.info('Uploading ${it.id} attachment...');

        final throttledUpdateAttachment = updateAttachment.throttled(
          const Duration(milliseconds: 500),
        );

        void onSendProgress(int sent, int total) {
          throttledUpdateAttachment([
            it.copyWith(
              uploadState: UploadState.inProgress(uploaded: sent, total: total),
            ),
          ]);
        }

        final isImage = it.type == AttachmentType.image;
        final cancelToken = CancelToken();
        Future<SendAttachmentResponse> future;
        if (isImage) {
          future = _channel.sendImage(
            it.file!,
            onSendProgress: onSendProgress,
            cancelToken: cancelToken,
            extraData: it.extraData,
          );
        } else {
          future = _channel.sendFile(
            it.file!,
            onSendProgress: onSendProgress,
            cancelToken: cancelToken,
            extraData: it.extraData,
          );
        }
        _cancelableAttachmentUploadRequest[it.id] = cancelToken;
        return future
            .then((response) {
              _channel.client.logger.info('Attachment ${it.id} uploaded successfully...');

              // If the response is SendFileResponse, then we might also be getting
              // thumbUrl in case of video. So we need to update the attachment with
              // both the assetUrl and thumbUrl.
              if (response is SendFileResponse) {
                updateAttachment(
                  it.copyWith(
                    assetUrl: response.file,
                    thumbUrl: response.thumbUrl,
                    uploadState: const UploadState.success(),
                  ),
                );
              } else {
                updateAttachment(
                  it.copyWith(
                    imageUrl: response.file,
                    uploadState: const UploadState.success(),
                  ),
                );
              }
            })
            .catchError((e, stk) {
              if (e is StreamChatNetworkError && e.type == .cancel) {
                _channel.client.logger.info('Attachment ${it.id} upload cancelled');

                // remove attachment from message if cancelled.
                updateAttachment(it, remove: true);
                return;
              }

              _channel.client.logger.severe('error uploading the attachment', e, stk);
              updateAttachment(
                it.copyWith(uploadState: UploadState.failed(error: e.toString())),
              );
            })
            .whenComplete(() {
              throttledUpdateAttachment.cancel();
              _cancelableAttachmentUploadRequest.remove(it.id);
            });
      }),
    ).whenComplete(() {
      final completer = _messageAttachmentsUploadCompleter.remove(messageId);
      if (completer == null || completer.isCompleted) return;

      // Always complete with the latest message view so callers can decide
      // success vs. partial failure by inspecting per-attachment upload
      // states. Cancellation is still surfaced via `completeError` from the
      // sendMessage/updateMessage/deleteMessage entry points.
      completer.complete(message);
    });
  }
}
