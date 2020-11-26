import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../stream_chat_flutter.dart';
import 'stream_icons.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ImageActionsModal extends StatelessWidget {
  final Message message;
  final String userName;
  final String sentAt;
  final List<Attachment> urls;
  final currentIndex;

  ImageActionsModal(
      {this.message, this.userName, this.sentAt, this.urls, this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pop(context);
      },
      child: Stack(
        children: [
          Positioned.fill(
              child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.transparent,
              ],
              stops: [0.0, 0.4],
            )),
          )),
          _buildPage(context),
        ],
      ),
    );
  }

  Widget _buildPage(context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 40.0,
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      userName,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    sentAt,
                    style: StreamChatTheme.of(context)
                        .channelPreviewTheme
                        .subtitle
                        .copyWith(color: Colors.white.withOpacity(0.5)),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  StreamIcons.close,
                  size: 24.0,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width / 1.8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Color(0xffe5e5e5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                        _buildButton(context, 'Reply',
                            StreamIcons.curve_line_down_left, () {}),
                        _buildButton(context, 'Show in Chat', StreamIcons.eye,
                            () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }),
                        _buildButton(context, 'Save Image', StreamIcons.save_1,
                            () async {
                          var url = urls[currentIndex].imageUrl ??
                              urls[currentIndex].assetUrl ??
                              urls[currentIndex].thumbUrl;
                          var file = await _downloadFile(url);

                          Navigator.pop(context);
                        }),
                        if (StreamChat.of(context).user.id == message.user.id)
                          _buildButton(context, 'Delete', StreamIcons.delete,
                              () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            StreamChat.of(context).client.deleteMessage(
                                  message,
                                  StreamChannel.of(context).channel.cid,
                                );
                          }, color: Colors.red),
                      ],
                    ).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      context, String title, IconData iconData, VoidCallback onTap,
      {Color color}) {
    var titleStyle = TextStyle(
      fontSize: 14.5,
      color: Colors.black,
    );

    return Material(
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          dense: true,
          title: Text(
            title,
            style:
                color == null ? titleStyle : titleStyle.copyWith(color: color),
          ),
          leading: Icon(
            iconData,
            color: color ?? StreamChatTheme.of(context).primaryIconTheme.color,
            size: 24.0,
          ),
        ),
      ),
    );
  }

  static Future<File> _downloadFile(String url) async {
    var _client = http.Client();
    var req = await _client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    var dir = (await getTemporaryDirectory()).path;
    var file = File('$dir/${basename(url)}');
    await file.writeAsBytes(bytes);
    return file;
  }
}
