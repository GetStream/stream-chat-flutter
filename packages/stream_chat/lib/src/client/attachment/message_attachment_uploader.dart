import 'dart:math';

import 'package:rate_limiter/rate_limiter.dart';

import '../../core/models/attachment.dart';
import '../../core/models/attachment_file.dart';
import '../../core/models/message.dart';
import 'attachment_uploader.dart';

/// Signature for a callback that receives a message each time it is updated.
typedef MessageUpdatedCallback = void Function(Message message);

/// Message-level uploads for a [ChannelAttachmentUploader].
extension MessageAttachmentUploader on ChannelAttachmentUploader {
  /// Starts uploading the attachments of [message] that are not uploaded yet,
  /// and returns the upload.
  ///
  /// If [attachmentIds] is given, only those attachments are uploaded. Up to
  /// three are uploaded at a time, in the order of the message. A message
  /// with nothing to upload gets an upload that has already completed.
  ///
  /// Each time an attachment finishes or fails, [onUpdated] is called with
  /// the message as it stands. While files are sent, it is also called with
  /// their progress, at most every half second. It is not called once the
  /// upload is canceled.
  MessageAttachmentsUpload uploadMessageAttachments(
    Message message, {
    Iterable<String>? attachmentIds,
    MessageUpdatedCallback? onUpdated,
  }) {
    final pending = message.attachments.where((it) {
      if (it.uploadState.isSuccess) return false;
      return attachmentIds?.contains(it.id) ?? true;
    });

    return MessageAttachmentsUpload._(
      this,
      message,
      pending.toList(),
      onUpdated,
    );
  }
}

/// The upload of a message's attachments, started by
/// [MessageAttachmentUploader.uploadMessageAttachments].
final class MessageAttachmentsUpload {
  MessageAttachmentsUpload._(
    this._uploader,
    this._message,
    this._queued,
    this._onUpdated,
  ) {
    _result = _settle();
  }

  static const _maxConcurrentUploads = 3;

  final ChannelAttachmentUploader _uploader;
  Message _message;
  final MessageUpdatedCallback? _onUpdated;

  // The attachments waiting for their turn, and the uploads started.
  final List<Attachment> _queued;
  final _uploads = <String, ChannelAttachmentUpload>{};
  final _settled = <String>{};
  var _isCanceled = false;
  Object? _cancelReason;

  late final _notifyProgress = _notify.throttled(
    const Duration(milliseconds: 500),
  );

  /// How the upload ended, once every attachment's upload has settled.
  ///
  /// Never completes with an error, as long as the `onUpdated` callback does
  /// not throw.
  Future<MessageAttachmentsUploadResult> get result => _result;
  late final Future<MessageAttachmentsUploadResult> _result;

  /// Cancels the upload of the attachment [attachmentId], which is then
  /// removed from the message. The rest keep uploading.
  ///
  /// Returns false if the attachment isn't uploading.
  bool cancelAttachment(String attachmentId, {String? reason}) {
    if (_isCanceled || _settled.contains(attachmentId)) return false;

    final queued = _queued.indexWhere((it) => it.id == attachmentId);
    if (queued != -1) {
      _queued.removeAt(queued);
      _setAttachment(attachmentId, null);
      _notify();
      return true;
    }

    return _uploads[attachmentId]?.cancel(reason: reason) ?? false;
  }

  /// Cancels every attachment upload that hasn't settled, for [reason] if
  /// given.
  ///
  /// Returns at once, and can be called more than once. Uploads that already
  /// settled keep their outcome, and the attachments still waiting for their
  /// turn are left as they were. The upload ends as
  /// [MessageAttachmentsUploadCanceled] with [reason], unless it had already
  /// completed.
  void cancel({Object? reason}) {
    if (_isCanceled) return;
    _isCanceled = true;
    _cancelReason = reason;

    _notifyProgress.cancel();
    for (final upload in _uploads.values) {
      upload.cancel();
    }
  }

  Future<MessageAttachmentsUploadResult> _settle() async {
    final workers = min(_maxConcurrentUploads, _queued.length);
    await Future.wait([for (var i = 0; i < workers; i++) _uploadQueued()]);
    _notifyProgress.cancel();

    if (_isCanceled) {
      return MessageAttachmentsUploadCanceled._(_message, _cancelReason);
    }

    return MessageAttachmentsUploadCompleted._(_message);
  }

  // Uploads the queued attachments one after another, until none are left or
  // the upload is canceled.
  Future<void> _uploadQueued() async {
    while (_queued.isNotEmpty && !_isCanceled) {
      final attachment = _queued.removeAt(0);
      final upload = _uploads[attachment.id] = _uploader.upload(
        attachment,
        onProgress: (sent, total) => _onProgress(attachment, sent, total),
      );

      await _settleOne(upload);
    }
  }

  Future<void> _settleOne(ChannelAttachmentUpload upload) async {
    final uploaded = await upload.result;
    _settled.add(upload.id);

    // One canceled on its own is removed. One canceled with the whole upload
    // is left as it was.
    if (uploaded == null && _isCanceled) return;

    _setAttachment(upload.id, uploaded);
    _notify();
  }

  void _onProgress(Attachment attachment, int sent, int total) {
    if (_settled.contains(attachment.id)) return;

    final state = UploadState.inProgress(uploaded: sent, total: total);
    _setAttachment(attachment.id, attachment.copyWith(uploadState: state));
    _notifyProgress();
  }

  // Replaces the attachment [id] with [attachment], or removes it if null.
  void _setAttachment(String id, Attachment? attachment) {
    final attachments = [
      for (final it in _message.attachments)
        if (it.id != id) it else if (attachment != null) attachment,
    ];

    _message = _message.copyWith(attachments: attachments);
  }

  void _notify() {
    if (_isCanceled) return;
    _onUpdated?.call(_message);
  }
}

/// How a [MessageAttachmentsUpload] ended.
sealed class MessageAttachmentsUploadResult {
  const MessageAttachmentsUploadResult._(this.message);

  /// The message with the outcome of each attachment's upload.
  ///
  /// An attachment is uploaded or failed, and one canceled on its own is
  /// removed. After [MessageAttachmentsUpload.cancel], the ones that hadn't
  /// settled are left as they were.
  final Message message;
}

/// Every attachment's upload settled on its own.
///
/// Some can have failed, or been canceled one by one.
final class MessageAttachmentsUploadCompleted extends MessageAttachmentsUploadResult {
  const MessageAttachmentsUploadCompleted._(super.message) : super._();
}

/// The upload was canceled with [MessageAttachmentsUpload.cancel].
final class MessageAttachmentsUploadCanceled extends MessageAttachmentsUploadResult {
  const MessageAttachmentsUploadCanceled._(super.message, this.reason) : super._();

  /// The reason given to [MessageAttachmentsUpload.cancel], if any.
  final Object? reason;
}
