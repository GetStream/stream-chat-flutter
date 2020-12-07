import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/utils.dart';

class FileAttachment extends StatelessWidget {
  final Attachment attachment;
  final Size size;
  final Widget trailing;

  const FileAttachment({
    Key key,
    @required this.attachment,
    this.size,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: size?.width ?? 100,
        height: 56.0,
        margin: trailing != null ? EdgeInsets.only(top: 4.0) : null,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: trailing != null ? BorderRadius.circular(16.0) : null,
          border: trailing != null
              ? Border.fromBorderSide(BorderSide(color: Color(0xFFE6E6E6)))
              : null,
        ),
        child: Row(
          children: [
            Container(
              child: getFileTypeImage(attachment.extraData['mime_type']),
              height: 40.0,
              width: 33.33,
              margin: EdgeInsets.all(8.0),
            ),
            SizedBox(
              width: 6.0,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attachment?.title ?? 'File',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                  Text(
                    '${attachment.extraData['file_size'] ?? 'N/A'} bytes',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                trailing ??
                    IconButton(
                      icon: StreamSvgIcon.cloud_download(
                        color: Colors.black,
                      ),
                      onPressed: () {
                        launchURL(context, attachment.assetUrl);
                      },
                    ),
              ],
            ),
          ],
        ),

        // ListTile(
        //   dense: true,
        //   leading: Container(
        //     child: _getFileTypeImage(attachment.extraData['mime_type']),
        //     height: 40.0,
        //     width: 33.33,
        //   ),
        //   title: Text(
        //     attachment?.title ?? 'File',
        //     style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //     ),
        //     maxLines: 3,
        //   ),
        //   subtitle: Text(
        //     '${attachment.extraData['file_size'] ?? 'N/A'} bytes',
        //     style: TextStyle(
        //       color: Colors.black.withOpacity(0.5),
        //     ),
        //   ),
        //   trailing: trailing ??
        //       IconButton(
        //         icon: StreamSvgIcon.cloud_download(
        //           color: Colors.black,
        //         ),
        //         onPressed: () {
        //           launchURL(context, attachment.assetUrl);
        //         },
        //       ),
        // ),
      ),
    );
  }
}
