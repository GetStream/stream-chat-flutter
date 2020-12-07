import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../stream_chat_flutter.dart';
import 'package:path_provider/path_provider.dart';

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
                icon: StreamSvgIcon.close(
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
                        _buildButton(
                            context,
                            'Reply',
                            StreamSvgIcon.Icon_curve_line_left_up(
                              size: 24.0,
                              color: Colors.black.withOpacity(0.5),
                            ),
                            () {}),
                        _buildButton(
                            context,
                            'Show in Chat',
                            StreamSvgIcon.eye(
                              size: 24.0,
                              color: Colors.black,
                            ), () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }),
                        _buildButton(
                            context,
                            'Save ${urls[currentIndex].type == 'video' ? 'Video' : 'Image'}',
                            StreamSvgIcon.Icon_save(
                              size: 24.0,
                              color: Colors.black.withOpacity(0.5),
                            ), () async {
                          var url = urls[currentIndex].imageUrl ??
                              urls[currentIndex].assetUrl ??
                              urls[currentIndex].thumbUrl;

                          if (urls[currentIndex].type == 'video') {
                            await _saveVideo(url);
                            Navigator.pop(context);
                          } else {
                            await _saveImage(url);
                            Navigator.pop(context);
                          }
                        }),
                        if (StreamChat.of(context).user.id == message.user.id)
                          _buildButton(
                            context,
                            'Delete',
                            StreamSvgIcon.delete(
                              size: 24.0,
                              color: Color(0xffFF3742),
                            ),
                            () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              StreamChat.of(context).client.deleteMessage(
                                    message,
                                    StreamChannel.of(context).channel.cid,
                                  );
                            },
                            color: Color(0xffFF3742),
                          ),
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
      context, String title, StreamSvgIcon icon, VoidCallback onTap,
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
          leading: icon,
        ),
      ),
    );
  }

  Future<void> _saveImage(String url) async {
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "${DateTime.now().millisecondsSinceEpoch}");
    return result;
  }

  Future<void> _saveVideo(String url) async {
    var appDocDir = await getTemporaryDirectory();
    var savePath =
        appDocDir.path + "/${DateTime.now().millisecondsSinceEpoch}.mp4";
    await Dio().download(url, savePath);
    final result = await ImageGallerySaver.saveFile(savePath);
    print(result);
  }
}
