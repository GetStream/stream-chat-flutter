import '../../core/models/message.dart';
import '../../core/models/scheduled_message.dart';
import 'attachment_uploader.dart';
import 'message_attachment_uploader.dart';

/// Signature for a callback that receives a scheduled message each time it is
/// updated.
typedef ScheduledMessageUpdatedCallback = void Function(ScheduledMessage scheduledMessage);

/// Scheduled-message-level uploads for a [ChannelAttachmentUploader].
extension ScheduledMessageAttachmentUploader on ChannelAttachmentUploader {
  /// Uploads the attachments of [scheduledMessage] that are not uploaded yet.
  ///
  /// Each time an attachment finishes or fails, [onUpdated] is called with
  /// the scheduled message as it stands. While files are sent, it is also
  /// called with their progress, at most every half second. An attachment
  /// whose upload is canceled is removed from its message.
  ///
  /// Completes with the scheduled message once every upload has settled.
  /// Never completes with an error, as long as [onUpdated] does not throw.
  Future<ScheduledMessage> uploadScheduledMessageAttachments(
    ScheduledMessage scheduledMessage, {
    ScheduledMessageUpdatedCallback? onUpdated,
  }) async {
    ScheduledMessage withMessage(Message message) {
      return scheduledMessage.copyWith(message: message);
    }

    final uploaded = await uploadMessageAttachments(
      scheduledMessage.message,
      onUpdated: switch (onUpdated) {
        final onUpdated? => (message) => onUpdated(withMessage(message)),
        null => null,
      },
    );

    return withMessage(uploaded);
  }
}
