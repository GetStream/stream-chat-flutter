import 'dart:async';

import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// An abstract class for creating utility classes appropriate for various
/// platforms.
///
/// TODO(Groovin): consider a "downloadMultiple()" function.
abstract class AttachmentHandler {
  /// Uploads an attachment.
  ///
  /// [fileType] and [camera] should only be passed to this function in mobile
  /// implementations of this class.
  Future<List<Attachment>> upload({
    DefaultAttachmentTypes? fileType,
    bool camera = false,
  });

  /// Downloads an attachment.
  Future<dynamic> download(
    Attachment attachment, {
    String? suggestedName,
  });
}
