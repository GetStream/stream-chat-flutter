import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Widget for constructing a group of images
class GroupImage extends StatelessWidget {
  /// Constructor for creating a [GroupImage]
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

  /// List of images to display
  final List<String> images;

  /// Constraints on the widget
  final BoxConstraints? constraints;

  /// Callback when widget is tapped
  final VoidCallback? onTap;

  /// Highlights if selected
  final bool selected;

  /// [BorderRadius] to pass to the widget
  final BorderRadius? borderRadius;

  /// Color of selection if selected
  final Color? selectionColor;

  /// Thickness with which color of selection is shown
  final double selectionThickness;

  @override
  Widget build(BuildContext context) {
    Widget? avatar;
    final streamChatTheme = StreamChatTheme.of(context);

    avatar = GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: borderRadius ??
            streamChatTheme.ownMessageTheme.avatarTheme?.borderRadius,
        child: Container(
          constraints: constraints ??
              streamChatTheme.ownMessageTheme.avatarTheme?.constraints,
          decoration: BoxDecoration(
            color: streamChatTheme.colorTheme.accentBlue,
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
          color: selectionColor ?? streamChatTheme.colorTheme.accentBlue,
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
