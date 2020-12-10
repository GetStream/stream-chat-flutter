import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/utils.dart';
import 'media_utils.dart';

enum FileAttachmentType { local, online }

class FileAttachment extends StatelessWidget {
  final Attachment attachment;
  final Size size;
  final Widget trailing;
  final FileAttachmentType attachmentType;
  final PlatformFile file;

  const FileAttachment({
    Key key,
    @required this.attachment,
    this.size,
    this.trailing,
    this.attachmentType = FileAttachmentType.online,
    this.file,
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
              child: _getFileTypeImage(),
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

  Widget _getFileTypeImage() {
    if ((MediaUtils.getMimeType(attachment.title).type == 'image')) {
      switch (attachmentType) {
        case FileAttachmentType.local:
          return Image.memory(
            file.bytes,
            fit: BoxFit.cover,
          );
          break;
        case FileAttachmentType.online:
          return CachedNetworkImage(
            imageUrl: attachment.imageUrl ??
                attachment.assetUrl ??
                attachment.thumbUrl,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, _, progress) {
              return Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    backgroundColor: StreamChatTheme.of(context).accentColor,
                  ),
                ),
              );
            },
          );
          break;
      }
    }

    switch (attachment.extraData['mime_type']) {
      case '7z':
        return StreamSvgIcon.filetype_7z();
        break;
      case 'csv':
        return StreamSvgIcon.filetype_csv();
        break;
      case 'doc':
        return StreamSvgIcon.filetype_doc();
        break;
      case 'docx':
        return StreamSvgIcon.filetype_docx();
        break;
      case 'html':
        return StreamSvgIcon.filetype_html();
        break;
      case 'md':
        return StreamSvgIcon.filetype_md();
        break;
      case 'odt':
        return StreamSvgIcon.filetype_odt();
        break;
      case 'pdf':
        return StreamSvgIcon.filetype_pdf();
        break;
      case 'ppt':
        return StreamSvgIcon.filetype_ppt();
        break;
      case 'pptx':
        return StreamSvgIcon.filetype_pptx();
        break;
      case 'rar':
        return StreamSvgIcon.filetype_rar();
        break;
      case 'rtf':
        return StreamSvgIcon.filetype_rtf();
        break;
      case 'tar':
        return StreamSvgIcon.filetype_tar();
        break;
      case 'txt':
        return StreamSvgIcon.filetype_txt();
        break;
      case 'xls':
        return StreamSvgIcon.filetype_xls();
        break;
      case 'xlsx':
        return StreamSvgIcon.filetype_xlsx();
        break;
      case 'zip':
        return StreamSvgIcon.filetype_zip();
        break;
      default:
        return StreamSvgIcon.filetype_Generic();
        break;
    }
  }
}
