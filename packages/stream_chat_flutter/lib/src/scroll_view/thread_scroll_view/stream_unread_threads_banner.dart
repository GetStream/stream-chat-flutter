import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';

/// {@template unreadThreadsBanner}
/// A widget that shows a banner with the number of unread threads.
///
/// This widget can be used to show a banner with the number of unread threads
/// on the top of the [ThreadListView].
/// {@endtemplate}
class StreamUnreadThreadsBanner extends StatelessWidget {
  /// {@macro unreadThreadsBanner}
  const StreamUnreadThreadsBanner({
    super.key,
    required this.unreadThreads,
    this.onTap,
    this.minHeight = 52,
    this.margin = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  /// The set of all the unread threads.
  final Set<String> unreadThreads;

  /// Optional callback to handle tap events.
  final VoidCallback? onTap;

  /// The minimum height of the banner.
  ///
  /// Defaults to 52.
  final double minHeight;

  /// The margin applied to the banner.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 8, vertical: 6)`.
  final EdgeInsetsGeometry? margin;

  /// The padding applied to the banner.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 16)`.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (unreadThreads.isEmpty) {
      return const Empty();
    }

    final theme = StreamChatTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: padding,
        constraints: BoxConstraints(minHeight: minHeight),
        decoration: BoxDecoration(
          color: theme.colorTheme.textHighEmphasis,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                context.translations.newThreadsLabel(
                  count: unreadThreads.length,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headline.copyWith(
                  color: theme.colorTheme.barsBg,
                ),
              ),
            ),
            StreamSvgIcon(
              icon: StreamSvgIcons.reload,
              color: theme.colorTheme.barsBg,
            ),
          ],
        ),
      ),
    );
  }
}
