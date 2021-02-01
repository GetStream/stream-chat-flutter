import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import '../stream_chat_flutter.dart';

class AttachmentError extends StatelessWidget {
  final Attachment attachment;
  final Size size;

  const AttachmentError({
    Key key,
    @required this.attachment,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (attachment.localUri != null) {
      return Image.file(
        File(attachment.localUri.path),
      );
    }
    return Center(
      child: Container(
        width: size?.width,
        height: size?.height ?? 200,
        color: StreamChatTheme.of(context).colorTheme.accentRed.withOpacity(.1),
        child: Center(
          child: Icon(
            Icons.error_outline,
            color: StreamChatTheme.of(context).colorTheme.black,
          ),
        ),
      ),
    );
  }
}
