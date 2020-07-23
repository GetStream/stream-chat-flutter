import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/message_widget.dart';

class ImageGroup extends StatelessWidget {
  const ImageGroup({
    Key key,
    @required this.imageBuilder,
    @required this.images,
    @required this.message,
    this.size,
  }) : super(key: key);

  final AttachmentBuilder imageBuilder;
  final List<Attachment> images;
  final Message message;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(size),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.cover,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                imageBuilder(
                  context,
                  message,
                  images[0],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: imageBuilder(
                    context,
                    message,
                    images[1],
                  ),
                ),
              ],
            ),
          ),
          if (images.length >= 3)
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    imageBuilder(
                      context,
                      message,
                      images[2],
                    ),
                    if (images.length >= 4)
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Stack(
                          children: <Widget>[
                            imageBuilder(
                              context,
                              message,
                              images[3],
                            ),
                            if (images.length > 4)
                              Positioned.fill(
                                child: Material(
                                  color: Colors.black38,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Center(
                                      child: Text(
                                        '${images.length - 4} +',
                                        style: TextStyle(
                                          color: Colors.white,
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
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
