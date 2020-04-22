import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

class AttachmentError extends StatelessWidget {
  final Attachment attachment;

  const AttachmentError({
    Key key,
    @required this.attachment,
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
        width: 200,
        height: 140,
        color: Color(0xffd0021B).withOpacity(.1),
        child: Center(
          child: Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
