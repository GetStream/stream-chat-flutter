import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/utils.dart';

class FileAttachment extends StatelessWidget {
  final Attachment attachment;

  const FileAttachment({
    Key key,
    @required this.attachment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          launchURL(context, attachment.assetUrl);
        },
        child: Container(
          width: 100,
          height: 100,
          child: Center(
            child: Icon(Icons.attach_file),
          ),
        ),
      ),
    );
  }
}
