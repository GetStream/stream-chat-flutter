import 'package:rate_limiter/rate_limiter.dart';

import '../../core/models/attachment.dart';
import '../../core/models/attachment_file.dart';
import '../../core/models/message.dart';
import 'attachment_uploader.dart';

/// Signature for a callback that receives a message each time it is updated.
typedef MessageUpdatedCallback = void Function(Message message);

/// Message-level uploads for a [ChannelAttachmentUploader].
extension MessageAttachmentUploader on ChannelAttachmentUploader {
  /// Uploads the attachments of [message] that are not uploaded yet.
  ///
  /// If [attachmentIds] is given, only those attachments are uploaded.
  ///
  /// Each time an attachment finishes or fails, [onUpdated] is called with
  /// the message as it stands. While files are sent, it is also called with
  /// their progress, at most every half second. An attachment whose upload is
  /// canceled is removed from the message.
  ///
  /// Completes with the message once every upload has settled. Never
  /// completes with an error, as long as [onUpdated] does not throw.
  Future<Message> uploadMessageAttachments(
    Message message, {
    Iterable<String>? attachmentIds,
    MessageUpdatedCallback? onUpdated,
  }) async {
    final pending = message.attachments.where((it) {
      if (it.uploadState.isSuccess) return false;
      return attachmentIds?.contains(it.id) ?? true;
    }).toList();

    if (pending.isEmpty) return message;

    var current = message;

    // Replaces the attachment [id] with [attachment], or removes it if null.
    void setAttachment(String id, Attachment? attachment) {
      final attachments = [
        for (final it in current.attachments)
          if (it.id != id) it else if (attachment != null) attachment,
      ];

      current = current.copyWith(attachments: attachments);
    }

    void notify() => onUpdated?.call(current);
    final notifyProgress = notify.throttled(const Duration(milliseconds: 500));

    Future<void> uploadOne(Attachment attachment) async {
      var isSettled = false;
      void onProgress(int sent, int total) {
        if (isSettled) return;

        final state = UploadState.inProgress(uploaded: sent, total: total);
        setAttachment(attachment.id, attachment.copyWith(uploadState: state));
        notifyProgress();
      }

      final uploaded = await upload(attachment, onProgress: onProgress);
      isSettled = true;

      // A canceled upload completes with null, which removes the attachment.
      setAttachment(attachment.id, uploaded);
      notify();
    }

    await Future.wait(pending.map(uploadOne));

    notifyProgress.cancel();
    return current;
  }
}
