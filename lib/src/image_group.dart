import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/full_screen_media.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ImageGroup extends StatelessWidget {
  const ImageGroup({
    Key key,
    @required this.images,
    @required this.message,
    @required this.size,
  }) : super(key: key);

  final List<Attachment> images;
  final Message message;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(size),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Flex(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              direction: Axis.horizontal,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: _buildImage(context, 0),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: _buildImage(context, 1),
                  ),
                ),
              ],
            ),
          ),
          if (images.length >= 3)
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: _buildImage(context, 2),
                    ),
                    if (images.length >= 4)
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              _buildImage(context, 3),
                              if (images.length > 4)
                                Positioned.fill(
                                  child: GestureDetector(
                                    onTap: () => _onTap(context, 3),
                                    child: Material(
                                      color: Colors.black38,
                                      child: Center(
                                        child: Text(
                                          '${images.length - 4} +',
                                          style: TextStyle(
                                            color: StreamChatTheme.of(context)
                                                .colorTheme
                                                .white,
                                            fontSize: 28,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onTap(
    BuildContext context, [
    int index,
  ]) {
    final channel = StreamChannel.of(context).channel;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StreamChannel(
          channel: channel,
          child: FullScreenMedia(
            mediaAttachments: images,
            startIndex: index,
            userName: message.user.name,
            sentAt: message.createdAt,
            message: message,
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _onTap(context, index),
      child: CachedNetworkImage(
        imageUrl: images[index].imageUrl ??
            images[index].thumbUrl ??
            images[index].assetUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
