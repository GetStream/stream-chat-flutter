import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/utils.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'media_utils.dart';

enum FileAttachmentType { local, online }

class FileAttachment extends StatefulWidget {
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
  _FileAttachmentState createState() => _FileAttachmentState();
}

class _FileAttachmentState extends State<FileAttachment> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    if (MediaUtils.getMimeType(widget.attachment.title).type == 'video') {
      if (widget.attachmentType == FileAttachmentType.online) {
        _controller = VideoPlayerController.network(
          widget.attachment.assetUrl,
        );
      } else {
        _controller = VideoPlayerController.file(
          File.fromRawPath(widget.file.bytes),
        );
      }

      _initializeVideoPlayerFuture = _controller.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: widget.size?.width ?? 100,
        height: 56.0,
        margin: widget.trailing != null ? EdgeInsets.only(top: 4.0) : null,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              widget.trailing != null ? BorderRadius.circular(16.0) : null,
          border: widget.trailing != null
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
                    widget.attachment?.title ?? 'File',
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
                    '${_getSizeText(widget.attachment.extraData['file_size'])}',
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
                widget.trailing ??
                    IconButton(
                      icon: StreamSvgIcon.cloud_download(
                        color: Colors.black,
                      ),
                      onPressed: () {
                        launchURL(context, widget.attachment.assetUrl);
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
    if ((MediaUtils.getMimeType(widget.attachment.title).type == 'image')) {
      switch (widget.attachmentType) {
        case FileAttachmentType.local:
          return Image.memory(
            widget.file.bytes,
            fit: BoxFit.cover,
          );
          break;
        case FileAttachmentType.online:
          return CachedNetworkImage(
            imageUrl: widget.attachment.imageUrl ??
                widget.attachment.assetUrl ??
                widget.attachment.thumbUrl,
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

    if ((MediaUtils.getMimeType(widget.attachment.title).type == 'video')) {
      switch (widget.attachmentType) {
        case FileAttachmentType.local:
          return FutureBuilder<File>(
            future: VideoCompress.getFileThumbnail(widget.file.path),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Image.asset(
                  'images/placeholder.png',
                  package: 'stream_chat_flutter',
                );
              }

              return Image.file(
                snapshot.data,
                fit: BoxFit.cover,
              );
            },
          );
          break;
        case FileAttachmentType.online:
          return FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
          break;
      }
    }

    switch (widget.attachment.extraData['mime_type']) {
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

  String _getSizeText(int bytes) {
    if (bytes == null) {
      return 'Size N/A';
    }

    if (bytes <= 1000) {
      return '${bytes} bytes';
    } else if (bytes <= 100000) {
      return '${(bytes / 1000).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / 1000000).toStringAsFixed(2)} MB';
    }
  }
}
