import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_chat_flutter/src/attachment/handler/stream_attachment_handler.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// The default maximum size for media attachments.
const kDefaultMaxAttachmentSize = 100 * 1024 * 1024; // 100MB in Bytes

/// The default maximum number of media attachments.
const kDefaultMaxAttachmentCount = 10;

/// Controller class for [StreamAttachmentPicker].
class StreamAttachmentPickerController
    extends ValueNotifier<AttachmentPickerValue> {
  /// Creates a new instance of [StreamAttachmentPickerController].
  factory StreamAttachmentPickerController({
    Poll? initialPoll,
    List<Attachment>? initialAttachments,
    Map<String, Object?>? initialExtraData,
    int maxAttachmentSize = kDefaultMaxAttachmentSize,
    int maxAttachmentCount = kDefaultMaxAttachmentCount,
  }) {
    return StreamAttachmentPickerController._fromValue(
      AttachmentPickerValue(
        poll: initialPoll,
        attachments: initialAttachments ?? const [],
        extraData: initialExtraData ?? const {},
      ),
      maxAttachmentSize: maxAttachmentSize,
      maxAttachmentCount: maxAttachmentCount,
    );
  }

  StreamAttachmentPickerController._fromValue(
    this.initialValue, {
    this.maxAttachmentSize = kDefaultMaxAttachmentSize,
    this.maxAttachmentCount = kDefaultMaxAttachmentCount,
  })  : assert(
          (initialValue.attachments.length) <= maxAttachmentCount,
          '''The initial attachments count must be less than or equal to maxAttachmentCount''',
        ),
        super(initialValue);

  /// Initial value for the controller.
  final AttachmentPickerValue initialValue;

  /// The max attachment size allowed in bytes.
  final int maxAttachmentSize;

  /// The max attachment count allowed.
  final int maxAttachmentCount;

  @override
  set value(AttachmentPickerValue newValue) {
    if (newValue.attachments.length > maxAttachmentCount) {
      throw AttachmentLimitReachedError(maxCount: maxAttachmentCount);
    }
    super.value = newValue;
  }

  /// Adds a new [poll] to the message.
  set poll(Poll? poll) => value = value.copyWith(poll: poll);

  /// Sets the extra data value for the controller.
  ///
  /// This can be used to store custom attachment values in case a custom
  /// attachment picker option is used.
  set extraData(Map<String, Object?>? extraData) {
    value = value.copyWith(extraData: extraData);
  }

  Future<String> _saveToCache(AttachmentFile file) async {
    // Cache the attachment in a temporary file.
    return StreamAttachmentHandler.instance.saveAttachmentFile(
      attachmentFile: file,
    );
  }

  Future<void> _removeFromCache(AttachmentFile file) {
    // Remove the cached attachment file.
    return StreamAttachmentHandler.instance.deleteAttachmentFile(
      attachmentFile: file,
    );
  }

  /// Adds a new attachment to the message.
  Future<void> addAttachment(Attachment attachment) async {
    assert(attachment.fileSize != null, '');
    if (attachment.fileSize! > maxAttachmentSize) {
      throw AttachmentTooLargeError(
        fileSize: attachment.fileSize!,
        maxSize: maxAttachmentSize,
      );
    }

    final file = attachment.file;
    final uploadState = attachment.uploadState;

    // No need to cache the attachment if it's already uploaded
    // or we are on web.
    if (file == null || uploadState.isSuccess || CurrentPlatform.isWeb) {
      value = value.copyWith(attachments: [...value.attachments, attachment]);
      return;
    }

    // Cache the attachment in a temporary file.
    final tempFilePath = await _saveToCache(file);

    value = value.copyWith(attachments: [
      ...value.attachments,
      attachment.copyWith(
        file: file.copyWith(
          path: tempFilePath,
        ),
      ),
    ]);
  }

  /// Removes the specified [attachment] from the message.
  Future<void> removeAttachment(Attachment attachment) async {
    final file = attachment.file;
    final uploadState = attachment.uploadState;

    if (file == null || uploadState.isSuccess || CurrentPlatform.isWeb) {
      final updatedAttachments = [...value.attachments]..remove(attachment);
      value = value.copyWith(attachments: updatedAttachments);
      return;
    }

    // Remove the cached attachment file.
    await _removeFromCache(file);

    final updatedAttachments = [...value.attachments]..remove(attachment);
    value = value.copyWith(attachments: updatedAttachments);
  }

  /// Remove the attachment with the given [attachmentId].
  void removeAttachmentById(String attachmentId) {
    final attachment = value.attachments.firstWhereOrNull(
      (attachment) => attachment.id == attachmentId,
    );

    if (attachment == null) return;

    removeAttachment(attachment);
  }

  /// Clears all the attachments.
  Future<void> clear() async {
    final attachments = [...value.attachments];
    for (final attachment in attachments) {
      final file = attachment.file;
      final uploadState = attachment.uploadState;

      if (file == null || uploadState.isSuccess || CurrentPlatform.isWeb) {
        continue;
      }

      await _removeFromCache(file);
    }
    value = const AttachmentPickerValue();
  }

  /// Resets the controller to its initial state.
  Future<void> reset() async {
    final attachments = [...value.attachments];
    for (final attachment in attachments) {
      final file = attachment.file;
      final uploadState = attachment.uploadState;

      if (file == null || uploadState.isSuccess || CurrentPlatform.isWeb) {
        continue;
      }

      await _removeFromCache(file);
    }

    value = initialValue;
  }
}

const _nullConst = Object();

/// Value class for [AttachmentPickerController].
///
/// This class holds the list of [Poll] and [Attachment] objects.
class AttachmentPickerValue {
  /// Creates a new instance of [AttachmentPickerValue].
  const AttachmentPickerValue({
    this.poll,
    this.attachments = const [],
    this.extraData = const {},
  });

  /// The poll object.
  final Poll? poll;

  /// The list of [Attachment] objects.
  final List<Attachment> attachments;

  /// Extra data that can be used to store custom attachment values.
  final Map<String, Object?> extraData;

  /// Returns true if the value is empty, meaning it has no poll,
  /// no attachments and no extra data set.
  bool get isEmpty {
    if (poll != null) return false;
    if (attachments.isNotEmpty) return false;
    if (extraData.isNotEmpty) return false;

    return true;
  }

  /// Returns a copy of this object with the provided values.
  AttachmentPickerValue copyWith({
    Object? poll = _nullConst,
    List<Attachment>? attachments,
    Map<String, Object?>? extraData,
  }) {
    return AttachmentPickerValue(
      poll: poll == _nullConst ? this.poll : poll as Poll?,
      attachments: attachments ?? this.attachments,
      extraData: extraData ?? this.extraData,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is! AttachmentPickerValue) return false;

    final isPollEqual = other.poll == poll;

    final areAttachmentsEqual = UnorderedIterableEquality<Attachment>(
      EqualityBy((attachment) => attachment.id),
    ).equals(other.attachments, attachments);

    final isExtraDataEqual = const DeepCollectionEquality.unordered().equals(
      other.extraData,
      extraData,
    );

    return isPollEqual && areAttachmentsEqual && isExtraDataEqual;
  }

  @override
  int get hashCode {
    final attachmentsHash = UnorderedIterableEquality<Attachment>(
      EqualityBy((attachment) => attachment.id),
    ).hash(attachments);

    final extraDataHash = const DeepCollectionEquality.unordered().hash(
      extraData,
    );

    return poll.hashCode ^ attachmentsHash ^ extraDataHash;
  }
}

/// Error thrown when an attachment exceeds the maximum allowed file size.
///
/// This occurs when calling [StreamAttachmentPickerController.addAttachment]
/// with a file whose size is greater than [maxAttachmentSize].
///
/// The error includes both the actual file size and the configured limit,
/// allowing you to provide specific feedback about the size violation.
class AttachmentTooLargeError extends StreamChatError {
  /// Creates a new [AttachmentTooLargeError].
  const AttachmentTooLargeError({
    required this.fileSize,
    required this.maxSize,
  }) : super(
          'The size of the attachment is $fileSize bytes, '
          'but the maximum size allowed is $maxSize bytes.',
        );

  /// The actual size of the attachment in bytes.
  final int fileSize;

  /// The maximum allowed size in bytes.
  final int maxSize;

  @override
  List<Object?> get props => [...super.props, fileSize, maxSize];

  @override
  String toString() => 'AttachmentTooLargeError: '
      'The size of the attachment is $fileSize bytes, '
      'but the maximum size allowed is $maxSize bytes.';
}

/// Error thrown when the attachment count exceeds the maximum allowed.
///
/// This occurs when setting [StreamAttachmentPickerController.value] with
/// more attachments than [maxAttachmentCount] allows.
///
/// The error includes the configured attachment limit.
class AttachmentLimitReachedError extends StreamChatError {
  /// Creates a new [AttachmentLimitReachedError].
  const AttachmentLimitReachedError({
    required this.maxCount,
  }) : super('The maximum number of attachments is $maxCount.');

  /// The maximum allowed number of attachments.
  final int maxCount;

  @override
  List<Object?> get props => [...super.props, maxCount];

  @override
  String toString() => 'AttachmentLimitReachedError: '
      'The maximum number of attachments is $maxCount.';
}
