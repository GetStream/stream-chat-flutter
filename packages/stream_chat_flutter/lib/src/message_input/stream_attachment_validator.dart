import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template streamAttachmentValidator}
/// The rule set applied to attachments before they enter the message
/// composer.
///
/// Wraps the per-category [UploadConfig] for files and images and the
/// total attachment-count limit, exposing two pure checks:
///
///  * [validateCount] — checks that the total attachment count fits
///    within [maxAttachmentCount].
///  * [validate] — checks a single [Attachment] against the size,
///    extension, and MIME-type rules from [fileUploadConfig] or
///    [imageUploadConfig].
///
/// Both return `null` on success and a typed [StreamChatError] subtype
/// on failure — neither ever throws.
///
/// See also:
///
///  * [UploadConfig], for the per-category rules consumed here.
///  * [AttachmentLimitReachedError], [AttachmentTooLargeError], and
///    [AttachmentBlockedError], for the returned error types.
/// {@endtemplate}
class StreamAttachmentValidator {
  /// {@macro streamAttachmentValidator}
  const StreamAttachmentValidator({
    this.fileUploadConfig = const UploadConfig(),
    this.imageUploadConfig = const UploadConfig(),
    this.maxAttachmentCount = defaultMaxAttachmentCount,
  });

  /// The backend-enforced maximum number of attachments per message.
  ///
  /// Used as the default value for [maxAttachmentCount].
  static const defaultMaxAttachmentCount = 30;

  /// The maximum number of attachments allowed in a single message.
  ///
  /// Defaults to [defaultMaxAttachmentCount].
  final int maxAttachmentCount;

  /// The rules applied to non-image attachments.
  final UploadConfig fileUploadConfig;

  /// The rules applied to image attachments.
  final UploadConfig imageUploadConfig;

  /// Checks that [total] attachments would not exceed [maxAttachmentCount].
  ///
  /// Returns `null` when within the limit, otherwise an
  /// [AttachmentLimitReachedError].
  StreamChatError? validateCount(int total) {
    if (total <= maxAttachmentCount) return null;
    return AttachmentLimitReachedError(maxCount: maxAttachmentCount);
  }

  /// Checks [attachment] against the matching [UploadConfig].
  ///
  /// The four lists (allowed/blocked × extension/MIME) are enforced
  /// independently — the attachment must pass every populated list to be
  /// accepted.
  ///
  /// Returns `null` when the attachment passes — or when [attachment]
  /// has no file. Otherwise returns:
  ///
  ///  * [AttachmentBlockedError] when the extension or MIME type is
  ///    rejected. The error carries both raw values regardless of which
  ///    list triggered the failure.
  ///  * [AttachmentTooLargeError] when the file exceeds the per-category
  ///    [UploadConfig.sizeLimit].
  StreamChatError? validate(Attachment attachment) {
    final file = attachment.file;
    if (file == null) return null;

    final isImage = attachment.type == AttachmentType.image;
    final config = isImage ? imageUploadConfig : fileUploadConfig;
    final filename = file.name?.toLowerCase();
    final mime = file.mediaType?.mimeType.toLowerCase();

    if (_extensionRejected(filename, config) || _mimeRejected(mime, config)) {
      return AttachmentBlockedError(fileExtension: file.extension, mimeType: mime);
    }

    final size = attachment.fileSize ?? 0;
    final maxSize = config.sizeLimit > 0 ? config.sizeLimit : UploadConfig.defaultSizeLimit;
    if (size > maxSize) return AttachmentTooLargeError(fileSize: size, maxSize: maxSize);

    return null;
  }

  // True when [filename] is rejected by the file-extension lists.
  //
  // Matching is suffix-based on the filename, which supports compound
  // extensions like `.tar.gz`.
  //
  // Precondition: [filename] is already lowercased. List entries are
  // lowercased here for comparison.
  //
  // An empty filename is rejected only when an allow-list is present (the
  // file can't satisfy the whitelist); when no allow-list is configured it
  // passes.
  static bool _extensionRejected(String? filename, UploadConfig config) {
    if (filename == null || filename.isEmpty) return config.allowedFileExtensions.isNotEmpty;
    bool matches(String entry) => filename.endsWith(entry.toLowerCase());
    if (config.blockedFileExtensions.any(matches)) return true;
    if (config.allowedFileExtensions.isEmpty) return false;
    return !config.allowedFileExtensions.any(matches);
  }

  // True when [mime] is rejected by the MIME-type lists.
  //
  // Precondition: [mime] is already lowercased. List entries are lowercased
  // here for comparison.
  //
  // A null/empty MIME is rejected only when an allow-list is present.
  static bool _mimeRejected(String? mime, UploadConfig config) {
    if (mime == null || mime.isEmpty) return config.allowedMimeTypes.isNotEmpty;
    bool matches(String entry) => entry.toLowerCase() == mime;
    if (config.blockedMimeTypes.any(matches)) return true;
    if (config.allowedMimeTypes.isEmpty) return false;
    return !config.allowedMimeTypes.any(matches);
  }
}

/// Returned by [StreamAttachmentValidator.validateCount] when the
/// attachment count exceeds [StreamAttachmentValidator.maxAttachmentCount].
///
/// See also:
///
///  * [AttachmentTooLargeError], [AttachmentBlockedError], for the other
///    validator failures.
class AttachmentLimitReachedError extends StreamChatError {
  /// Creates a new [AttachmentLimitReachedError].
  const AttachmentLimitReachedError({
    required this.maxCount,
  }) : super('Attachment count exceeds the configured maximum of $maxCount.');

  /// The maximum number of attachments allowed in a single message.
  final int maxCount;

  @override
  List<Object?> get props => [...super.props, maxCount];

  @override
  String toString() => 'AttachmentLimitReachedError: $message';
}

/// Returned by [StreamAttachmentValidator.validate] when an attachment
/// exceeds the per-category [UploadConfig.sizeLimit].
///
/// See also:
///
///  * [AttachmentBlockedError], [AttachmentLimitReachedError], for the
///    other validator failures.
class AttachmentTooLargeError extends StreamChatError {
  /// Creates a new [AttachmentTooLargeError].
  const AttachmentTooLargeError({
    required this.fileSize,
    required this.maxSize,
  }) : super('Attachment size $fileSize exceeds the configured limit of $maxSize bytes.');

  /// The size of the attachment, in bytes.
  final int fileSize;

  /// The maximum upload size, in bytes.
  final int maxSize;

  @override
  List<Object?> get props => [...super.props, fileSize, maxSize];

  @override
  String toString() => 'AttachmentTooLargeError: $message';
}

/// Returned by [StreamAttachmentValidator.validate] when the file's
/// extension or MIME type is not permitted by the matching [UploadConfig].
///
/// Both [fileExtension] and [mimeType] are populated regardless of which
/// list triggered the failure.
///
/// See also:
///
///  * [AttachmentTooLargeError], [AttachmentLimitReachedError], for the
///    other validator failures.
class AttachmentBlockedError extends StreamChatError {
  /// Creates a new [AttachmentBlockedError].
  const AttachmentBlockedError({
    this.fileExtension,
    this.mimeType,
  }) : super('Attachment blocked by the upload configuration.');

  /// The extension of the blocked attachment, if known.
  final String? fileExtension;

  /// The MIME type of the blocked attachment, if known.
  final String? mimeType;

  @override
  List<Object?> get props => [...super.props, fileExtension, mimeType];

  @override
  String toString() {
    final parts = <String>[
      if (fileExtension case final ext? when ext.isNotEmpty) 'extension: $ext',
      if (mimeType case final mime? when mime.isNotEmpty) 'mime: $mime',
    ];
    final suffix = parts.isEmpty ? '' : ' (${parts.join(', ')})';
    return 'AttachmentBlockedError: $message$suffix';
  }
}
