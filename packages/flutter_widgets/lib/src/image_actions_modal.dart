import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import '../stream_chat_flutter.dart';

class ImageActionsModal extends StatelessWidget {
  final Message message;
  final String userName;
  final String sentAt;
  final List<Attachment> urls;
  final currentIndex;
  final VoidCallback onShowMessage;

  ImageActionsModal(
      {this.message,
      this.userName,
      this.sentAt,
      this.urls,
      this.currentIndex,
      this.onShowMessage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.maybePop(context),
      child: _buildPage(context),
    );
  }

  Widget _buildPage(context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: kToolbarHeight,
            child: IconButton(
              icon: StreamSvgIcon.close(),
              onPressed: () => Navigator.maybePop(context),
            ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: ListTile.divideTiles(
                      color: StreamChatTheme.of(context).colorTheme.greyWhisper,
                      context: context,
                      tiles: [
                        _buildButton(
                            context,
                            'Reply',
                            StreamSvgIcon.Icon_curve_line_left_up(
                              size: 24.0,
                              color:
                                  StreamChatTheme.of(context).colorTheme.grey,
                            ),
                            () {}),
                        _buildButton(
                            context,
                            'Show in Chat',
                            StreamSvgIcon.eye(
                              size: 24.0,
                              color:
                                  StreamChatTheme.of(context).colorTheme.black,
                            ),
                            onShowMessage),
                        _buildButton(
                            context,
                            'Save ${urls[currentIndex].type == 'video' ? 'Video' : 'Image'}',
                            StreamSvgIcon.Icon_save(
                              size: 24.0,
                              color:
                                  StreamChatTheme.of(context).colorTheme.grey,
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
                              color: StreamChatTheme.of(context)
                                  .colorTheme
                                  .accentRed,
                            ),
                            () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              StreamChat.of(context).client.deleteMessage(
                                    message,
                                    StreamChannel.of(context).channel.cid,
                                  );
                            },
                            color: StreamChatTheme.of(context)
                                .colorTheme
                                .accentRed,
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
      color: StreamChatTheme.of(context).colorTheme.black,
    );

    return Material(
      color: StreamChatTheme.of(context).colorTheme.white,
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
