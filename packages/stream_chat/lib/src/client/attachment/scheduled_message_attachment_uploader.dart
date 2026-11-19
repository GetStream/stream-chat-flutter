import '../../core/models/scheduled_message.dart';
import 'attachment_uploader.dart';
import 'message_attachment_uploader.dart';

/// Signature for a callback that receives an updated scheduled message.
typedef ScheduledMessageUpdatedCallback = void Function(ScheduledMessage scheduledMessage);

/// Scheduled-message-level uploads for a [ChannelAttachmentUploader].
extension ScheduledMessageAttachmentUploader on ChannelAttachmentUploader {
  /// Starts uploading the attachments of [scheduledMessage] not uploaded yet.
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
