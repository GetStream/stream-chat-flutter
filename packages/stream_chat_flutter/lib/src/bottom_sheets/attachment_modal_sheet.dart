import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class AttachmentModalSheet extends StatelessWidget {
  const AttachmentModalSheet({
    Key? key,
    required this.onFileTap,
    required this.onPhotoTap,
    required this.onVideoTap,
  }) : super(key: key);

  final VoidCallback onFileTap;
  final VoidCallback onPhotoTap;
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
