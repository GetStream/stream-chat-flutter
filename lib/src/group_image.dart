import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../stream_chat_flutter.dart';

class GroupImage extends StatelessWidget {
  const GroupImage({
    Key key,
    @required this.images,
    this.constraints,
    this.onTap,
  }) : super(key: key);

  final List<String> images;
  final BoxConstraints constraints;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final secondRow = images
        .skip(2)
        .map((url) => Flexible(
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
              ),
            ))
        .toList();

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: StreamChatTheme.of(context)
            .ownMessageTheme
            .avatarTheme
            .borderRadius,
        child: Container(
          constraints: constraints ??
              StreamChatTheme.of(context)
                  .ownMessageTheme
                  .avatarTheme
                  .constraints,
          decoration: BoxDecoration(
            color: StreamChatTheme.of(context).accentColor,
          ),
          child: Flex(
            direction: Axis.vertical,
            children: [
              Flexible(
                child: Flex(
                  direction: Axis.horizontal,
                  children: images
                      .take(2)
                      .map((url) => Flexible(
                            fit: FlexFit.tight,
                            child: CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.cover,
                            ),
                          ))
                      .toList(),
                ),
              ),
              Flexible(
                child: Flex(
                  direction: Axis.horizontal,
                  children: images
                      .skip(2)
                      .map((url) => Flexible(
                            fit: FlexFit.tight,
                            child: CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.cover,
                            ),
                          ))
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
