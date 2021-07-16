import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Widget for constructing a group of images
class GroupImage extends StatelessWidget {
  /// Constructor for creating a [GroupImage]
  const GroupImage({
    Key? key,
    required this.members,
    this.constraints,
    this.onTap,
    this.borderRadius,
    this.selected = false,
    this.selectionColor,
    this.selectionThickness = 4,
  }) : super(key: key);

  /// List of images to display
  final List<Member> members;

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
    final channel = StreamChannel.of(context).channel;

    assert(channel.state != null, 'Channel ${channel.id} is not initialized');

    final streamChatTheme = StreamChatTheme.of(context);
    final colorTheme = streamChatTheme.colorTheme;
    final previewTheme = streamChatTheme.channelPreviewTheme.avatarTheme;

    Widget avatar = GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: borderRadius ?? previewTheme?.borderRadius,
        child: Container(
          constraints: constraints ?? previewTheme?.constraints,
          decoration: BoxDecoration(color: colorTheme.accentPrimary),
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: members
                      .take(2)
                      .map(
                        (member) => Flexible(
                          fit: FlexFit.tight,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            clipBehavior: Clip.antiAlias,
                            child: Transform.scale(
                              scale: 1.2,
                              child: BetterStreamBuilder<Member>(
                                stream: channel.state!.membersStream.map(
                                  (members) => members.firstWhere(
                                    (it) => it.userId == member.userId,
                                    orElse: () => member,
                                  ),
                                ),
                                initialData: member,
                                builder: (context, member) => UserAvatar(
                                  user: member.user!,
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              if (members.length > 2)
                Flexible(
                  fit: FlexFit.tight,
                  child: Flex(
                    direction: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: members
                        .skip(2)
                        .take(2)
                        .map(
                          (member) => Flexible(
                            fit: FlexFit.tight,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              clipBehavior: Clip.antiAlias,
                              child: Transform.scale(
                                scale: 1.2,
                                child: BetterStreamBuilder<Member>(
                                  stream: channel.state!.membersStream.map(
                                    (members) => members.firstWhere(
                                      (it) => it.userId == member.userId,
                                      orElse: () => member,
                                    ),
                                  ),
                                  initialData: member,
                                  builder: (context, member) => UserAvatar(
                                    user: member.user!,
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
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
        borderRadius: BorderRadius.circular(selectionThickness) +
            (borderRadius ?? previewTheme?.borderRadius ?? BorderRadius.zero),
        child: Container(
          constraints: constraints ?? previewTheme?.constraints,
          color: selectionColor ?? colorTheme.accentPrimary,
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
