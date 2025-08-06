import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Signature for a function that is called when a custom attachment picker
/// result is received.
typedef OnCustomAttachmentPickerResult
    = OnAttachmentPickerResult<CustomAttachmentPickerResult>;

/// Signature for a function that is called when a attachment picker result
/// is received.
typedef OnAttachmentPickerResult<T extends StreamAttachmentPickerResult> = void
    Function(T result);

/// {@template streamAttachmentPickerAction}
/// A sealed class that represents different results that can be returned
/// from the attachment picker.
/// {@endtemplate}
sealed class StreamAttachmentPickerResult {
  const StreamAttachmentPickerResult();
}

/// A result indicating that the attachment picker was met with an error.
final class AttachmentPickerError extends StreamAttachmentPickerResult {
  /// Create a new attachment picker error result
  const AttachmentPickerError({required this.error, this.stackTrace});

  /// The error that occurred in the attachment picker.
  final Object error;

  /// The stack trace associated with the error, if available.
  final StackTrace? stackTrace;
}

/// A result indicating that some attachments were picked using the media
/// related options in the attachment picker (e.g., camera, gallery).
final class AttachmentsPicked extends StreamAttachmentPickerResult {
  /// Create a new attachments picked result
  const AttachmentsPicked({required this.attachments});

  /// The list of attachments that were picked.
  final List<Attachment> attachments;
}

/// A result indicating that a poll was created using the create poll option
/// in the attachment picker.
final class PollCreated extends StreamAttachmentPickerResult {
  /// Create a new poll created result
  const PollCreated({required this.poll});

  /// The poll that was created.
  final Poll poll;
}

/// A custom attachment picker result that can be extended to support
/// custom type of results from the attachment picker.
class CustomAttachmentPickerResult extends StreamAttachmentPickerResult {
  /// Create a new custom attachment picker result
  const CustomAttachmentPickerResult();
}
