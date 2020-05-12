import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/utils.dart';

class FileAttachment extends StatelessWidget {
  final Attachment attachment;
  final Size size;

  const FileAttachment({
    Key key,
    @required this.attachment,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          launchURL(context, attachment.assetUrl);
        },
        child: Container(
          width: size?.width ?? 100,
          height: size?.height ?? 100,
          child: Center(
            child: Icon(Icons.attach_file),
          ),
        ),
      ),
    );
  }
}
