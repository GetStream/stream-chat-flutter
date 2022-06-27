import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/dialogs/message_dialog.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';

/// Handles errors related to file upload errors on desktop platforms.
void handleFileUploadError(
  BuildContext context,
  dynamic error,
  int maxAttachmentSize,
) {
  if (error.runtimeType == FileSystemException) {
    switch (error.message) {
      case 'Could not read bytes from file':
        showDialog(
          context: context,
          builder: (_) => MessageDialog(
            messageText: context.translations.couldNotReadBytesFromFileError,
          ),
        );
        break;
      case 'File size too large after compression and exceeds maximum '
          'attachment size':
        showDialog(
          context: context,
          builder: (_) => MessageDialog(
            messageText: context.translations.fileTooLargeAfterCompressionError(
              maxAttachmentSize / (1024 * 1024),
            ),
          ),
        );
        break;
      case 'File size exceeds maximum attachment size':
        showDialog(
          context: context,
          builder: (_) => MessageDialog(
            messageText: context.translations.fileTooLargeError(
              maxAttachmentSize / (1024 * 1024),
            ),
          ),
        );
        break;
      default:
        showDialog(
          context: context,
          builder: (_) => const MessageDialog(),
        );
        break;
    }
  }
}
