import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template attachmentModalSheet}
/// The modalBottomSheet that appears when a mobile user attempts to add
/// attachments to a chat.
///
/// Should not be used on desktop or web.
/// {@endtemplate}
class AttachmentModalSheet extends StatelessWidget {
  /// {@macro attachmentModalSheet}
  const AttachmentModalSheet({
    super.key,
    required this.onFileTap,
    required this.onPhotoTap,
    required this.onVideoTap,
  });

  /// The action to perform when the "file" button is tapped.
  final VoidCallback onFileTap;

  /// The action to perform when the "photo" button is tapped.
  final VoidCallback onPhotoTap;

  /// The action to perform when the "video" button is tapped.
  final VoidCallback onVideoTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(
            context.translations.addAFileLabel,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.image),
          title: Text(context.translations.uploadAPhotoLabel),
          onTap: () {
            onPhotoTap.call();
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.video_library),
          title: Text(context.translations.uploadAVideoLabel),
          onTap: () {
            onVideoTap.call();
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.insert_drive_file),
          title: Text(context.translations.uploadAFileLabel),
          onTap: () {
            onFileTap.call();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
