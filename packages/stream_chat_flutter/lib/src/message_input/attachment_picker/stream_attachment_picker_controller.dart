import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_chat_flutter/src/attachment/handler/stream_attachment_handler.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/stream_attachment_picker_result.dart';
import 'package:stream_chat_flutter/src/message_input/stream_attachment_validator.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

export 'package:stream_chat_flutter/src/message_input/stream_attachment_validator.dart';

/// Controller class for [StreamAttachmentPicker].
class StreamAttachmentPickerController extends ValueNotifier<AttachmentPickerValue>
    with DisposeAwareValueNotifier<AttachmentPickerValue> {
  /// Creates a new instance of [StreamAttachmentPickerController].
  ///
  /// The provided [validator] enforces per-attachment upload rules (size,
  /// extension, MIME) on every [addAttachment] call, and the count limit on
  /// every value write.
  factory StreamAttachmentPickerController({
    Poll? initialPoll,
    List<Attachment>? initialAttachments,
    Map<String, Object?>? initialExtraData,
    StreamAttachmentValidator validator = const StreamAttachmentValidator(),
  }) {
    final initialValue = AttachmentPickerValue(
      poll: initialPoll,
      attachments: initialAttachments ?? const [],
      extraData: initialExtraData ?? const {},
    );

    return StreamAttachmentPickerController._fromValue(
      initialValue,
      validator: validator,
    );
  }

  StreamAttachmentPickerController._fromValue(
    this.initialValue, {
    required this.validator,
  }) : assert(
         validator.validateCount(initialValue.attachments.length) == null,
         'The initial attachments count must not exceed validator.maxAttachmentCount',
       ),
       super(initialValue);

  /// Initial value for the controller.
  final AttachmentPickerValue initialValue;

  /// Validator used to enforce per-attachment upload rules and the
  /// attachment-count limit.
  final StreamAttachmentValidator validator;

  /// Sets the value, throwing [AttachmentLimitReachedError] when the new
  /// attachment count exceeds the validator's configured limit.
  @override
  set value(AttachmentPickerValue newValue) {
    final error = validator.validateCount(newValue.attachments.length);
    if (error != null) throw error;

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

  /// A stream of custom attachment picker results emitted via [notifyCustomResult].
  Stream<CustomAttachmentPickerResult> get customResults => _customResultController.stream;
  final _customResultController = StreamController<CustomAttachmentPickerResult>.broadcast();

  /// Emits a [CustomAttachmentPickerResult] to notify the parent widget
  /// (e.g. [StreamMessageComposer]) that a custom attachment has been picked.
  ///
  /// Use this from a [TabbedAttachmentPickerOption.optionViewBuilder] instead
  /// of calling `Navigator.pop` — the picker is an inline widget, not a modal
  /// route, so popping the navigator would close the wrong page.
  void notifyCustomResult(CustomAttachmentPickerResult result) {
    return _customResultController.safeAdd(result);
  }

  @override
  void dispose() {
    _customResultController.close();
    super.dispose();
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
    final file = attachment.file;
    if (validator.validate(attachment) case final error?) throw error;

    final uploadState = attachment.uploadState;

    // No need to cache the attachment if it's already uploaded
    // or we are on web.
    if (file == null || uploadState.isSuccess || CurrentPlatform.isWeb) {
      value = value.copyWith(attachments: [...value.attachments, attachment]);
      return;
    }

    // Cache the attachment in a temporary file.
    final tempFilePath = await _saveToCache(file);

    value = value.copyWith(
      attachments: [
        ...value.attachments,
        attachment.copyWith(
          file: file.copyWith(
            path: tempFilePath,
          ),
        ),
      ],
    );
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
