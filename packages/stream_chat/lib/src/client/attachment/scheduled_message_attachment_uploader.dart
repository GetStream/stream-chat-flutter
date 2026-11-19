import '../../core/models/scheduled_message.dart';
import 'attachment_uploader.dart';
import 'message_attachment_uploader.dart';

/// Signature for a callback that receives a scheduled message each time it is
/// updated.
typedef ScheduledMessageUpdatedCallback = void Function(ScheduledMessage scheduledMessage);

/// Scheduled-message-level uploads for a [ChannelAttachmentUploader].
extension ScheduledMessageAttachmentUploader on ChannelAttachmentUploader {
  /// Starts uploading the attachments of [scheduledMessage] that are not
  /// uploaded yet, and returns the upload.
  ///
  /// Works as [uploadMessageAttachments] does for its message, with
  /// [onUpdated] called with the scheduled message as it stands.
  MessageAttachmentsUpload uploadScheduledMessageAttachments(
    ScheduledMessage scheduledMessage, {
    ScheduledMessageUpdatedCallback? onUpdated,
  }) {
    return uploadMessageAttachments(
      scheduledMessage.message,
      onUpdated: switch (onUpdated) {
        final onUpdated? => (message) => onUpdated(scheduledMessage.copyWith(message: message)),
        null => null,
      },
    );
  }
}
