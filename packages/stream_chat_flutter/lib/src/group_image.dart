import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../stream_chat_flutter.dart';

class GroupImage extends StatelessWidget {
  const GroupImage({
    Key? key,
    required this.images,
    this.constraints,
    this.onTap,
    this.borderRadius,
    this.selected = false,
    this.selectionColor,
    this.selectionThickness = 4,
  }) : super(key: key);

  final List<String> images;
  final BoxConstraints? constraints;
  final VoidCallback? onTap;
  final bool selected;
  final BorderRadius? borderRadius;
  final Color? selectionColor;
  final double selectionThickness;

  @override
  Widget build(BuildContext context) {
    var avatar;
    final streamChatTheme = StreamChatTheme.of(context);

    avatar = GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: borderRadius ??
            StreamChatTheme.of(context)
                .ownMessageTheme
                .avatarTheme
                ?.borderRadius,
        child: Container(
          constraints: constraints ??
              StreamChatTheme.of(context)
                  .ownMessageTheme
                  .avatarTheme
                  ?.constraints,
          decoration: BoxDecoration(
            color: StreamChatTheme.of(context).colorTheme.accentBlue,
          ),
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: images
                      .take(2)
                      .map((url) => Flexible(
                            fit: FlexFit.tight,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              clipBehavior: Clip.antiAlias,
                              child: Transform.scale(
                                scale: 1.2,
                                child: CachedNetworkImage(
                                  imageUrl: url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              if (images.length > 2)
                Flexible(
                  fit: FlexFit.tight,
                  child: Flex(
                    direction: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: images
                        .skip(2)
                        .map((url) => Flexible(
                              fit: FlexFit.tight,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                clipBehavior: Clip.antiAlias,
                                child: Transform.scale(
                                  scale: 1.2,
                                  child: CachedNetworkImage(
                                    imageUrl: url,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (selected) {
      avatar = ClipRRect(
        borderRadius: (borderRadius ??
                streamChatTheme.ownMessageTheme.avatarTheme?.borderRadius ??
                BorderRadius.zero) +
            BorderRadius.circular(selectionThickness),
        child: Container(
          color: selectionColor ??
              StreamChatTheme.of(context).colorTheme.accentBlue,
          height: 64,
          width: 64,
          child: Padding(
            padding: EdgeInsets.all(selectionThickness),
            child: avatar,
          ),
        ),
      );
    }

    return avatar;
  }
}
