import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamUserMentionTile}
/// Shows user tiles for mentions.
///
/// Use [title], [subtitle], [leading], [trailing] for
/// substituting widgets in respective positions
/// {@endtemplate}
class StreamUserMentionTile extends StatelessWidget {
  /// {@macro streamUserMentionTile}
  const StreamUserMentionTile(
    this.user, {
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
  });

  /// User to display in the tile
  final User user;

  /// Widget to display as title
  final Widget? title;

  /// Widget to display below [title]
  final Widget? subtitle;

  /// Widget at the start of the tile
  final Widget? leading;

  /// Widget at the end of tile
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          const SizedBox(
            width: 16,
          ),
          leading ??
              StreamUserAvatar(
                user: user,
                constraints: BoxConstraints.tight(const Size(40, 40)),
              ),
          const SizedBox(width: 8),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title ??
                      Text(
                        user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: chatThemeData.textTheme.bodyBold,
                      ),
                  const SizedBox(height: 2),
                  subtitle ??
                      Text(
                        '@${user.id}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: chatThemeData.textTheme.footnoteBold.copyWith(
                          color: chatThemeData.colorTheme.textLowEmphasis,
                        ),
                      ),
                ],
              ),
            ),
          ),
          trailing ??
              Padding(
                padding: const EdgeInsets.only(
                  right: 18,
                  left: 8,
                ),
                child: StreamSvgIcon(
                  icon: StreamSvgIcons.mentions,
                  color: chatThemeData.colorTheme.accentPrimary,
                ),
              ),
        ],
      ),
    );
  }
}
