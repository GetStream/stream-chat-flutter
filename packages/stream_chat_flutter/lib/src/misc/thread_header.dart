import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamThreadHeader}
/// Shows information about the current message thread.
///
/// Renders a [StreamAppBar] with the thread's reply label as the title and a
/// live typing indicator (or reply count) as the subtitle. Inherits the
/// [StreamAppBar] auto-implied back button — pass [leading] to override.
///
/// The bar's chrome (background, padding, typography, divider) is themed via
/// [StreamChatThemeData.threadHeaderTheme]. Per-instance overrides go on
/// [style].
///
/// A [StreamChannel] ancestor is required so that the typing indicator can
/// observe the channel's typing events.
/// {@endtemplate}
class StreamThreadHeader extends StatelessWidget implements PreferredSizeWidget {
  /// {@macro streamThreadHeader}
  const StreamThreadHeader({
    super.key,
    required this.parent,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.subtitle,
    this.trailing,
    this.primary = true,
    this.style,
  });

  /// The message parent of this thread.
  final Message parent;

  /// {@macro StreamAppBar.leading}
  final Widget? leading;

  /// {@macro StreamAppBar.automaticallyImplyLeading}
  final bool automaticallyImplyLeading;

  /// {@macro StreamAppBar.title}
  ///
  /// Defaults to the localized "Thread reply" label.
  final Widget? title;

  /// {@macro StreamAppBar.subtitle}
  ///
  /// Defaults to a live [StreamTypingIndicator] that falls back to the
  /// thread's reply count when nobody is typing.
  final Widget? subtitle;

  /// {@macro StreamAppBar.trailing}
  final Widget? trailing;

  /// {@macro StreamAppBar.primary}
  final bool primary;

  /// {@macro StreamAppBar.style}
  ///
  /// Per-instance override; merges over
  /// [StreamChatThemeData.threadHeaderTheme].
  final StreamAppBarStyle? style;

  @override
  Size get preferredSize => const Size.fromHeight(kStreamToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.maybeOf(context)?.channel;
    final headerTheme = StreamChatTheme.of(context).threadHeaderTheme;

    var leading = this.leading;
    if (leading == null && automaticallyImplyLeading) {
      leading = StreamBackButton(channelId: channel?.cid, showUnreadCount: true);
    }

    Widget? fallbackSubtitle;
    if (parent.replyCount case final count? when count > 0) {
      fallbackSubtitle = Text(context.translations.threadReplyCountText(count));
    }

    var title = this.title;
    title ??= Text(context.translations.threadReplyLabel);

    var subtitle = this.subtitle;
    subtitle ??= StreamTypingIndicator(
      channel: channel,
      parentId: parent.id,
      alternativeWidget: fallbackSubtitle,
    );

    return StreamAppBarTheme(
      data: headerTheme,
      child: StreamAppBar(
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        primary: primary,
        style: style,
      ),
    );
  }
}
