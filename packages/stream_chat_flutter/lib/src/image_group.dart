import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_chat_flutter/src/full_screen_media.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ImageGroup extends StatelessWidget {
  const ImageGroup({
    Key key,
    @required this.images,
    @required this.message,
    @required this.messageTheme,
    @required this.size,
    this.onShowMessage,
  }) : super(key: key);

  final List<Attachment> images;
  final Message message;
  final MessageTheme messageTheme;
  final Size size;
  final ShowMessageCallback onShowMessage;

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
                                          '+ ${images.length - 4}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26,
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
            onShowMessage: onShowMessage,
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, int index) {
    return ImageAttachment(
      attachment: images[index],
      size: size,
      message: message,
      messageTheme: messageTheme,
      onAttachmentTap: () => _onTap(context, index),
    );
  }
}
