import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamChannelHeader}
/// A top-of-screen header for a single channel.
///
/// [StreamChannelHeader] renders a [StreamAppBar] whose default title is
/// the channel's name (via [StreamChannelName]) and whose default subtitle
/// is the channel's typing / member status (via [StreamChannelInfo]).
///
/// The default leading is a [StreamBackButton] that pops the route when
/// tapped, gated by [automaticallyImplyLeading] — set it to `false` to
/// suppress the default, or pass [leading] to replace it entirely.
///
/// The default trailing is the channel avatar (via [StreamChannelAvatar]).
/// Tap behaviour is wired through [onChannelAvatarPressed]; when the
/// callback is null the avatar is rendered non-interactive. Pass [trailing]
/// to replace the avatar with a custom action — the callback is then
/// ignored.
///
/// A [StreamChannel] ancestor is required so the title and subtitle can
/// observe the channel's stream of updates. When [showConnectionStateTile]
/// is true, a [StreamInfoTile] banner is rendered above the bar while the
/// client is reconnecting or offline.
///
/// [StreamChannelHeader] implements [PreferredSizeWidget] so it can be
/// passed directly to [Scaffold.appBar].
///
/// {@tool snippet}
///
/// Basic usage as a [Scaffold.appBar] — the back button and channel
/// avatar are auto-populated from the enclosing [StreamChannel]:
///
/// ```dart
/// Scaffold(
///   appBar: const StreamChannelHeader(),
///   body: const StreamMessageListView(),
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// With a tap handler that opens a channel-detail screen:
///
/// ```dart
/// StreamChannelHeader(
///   onChannelAvatarPressed: (channel) => GoRouter.of(context).pushNamed(
///     'channel-detail',
///     extra: channel,
///   ),
/// )
/// ```
/// {@end-tool}
///
/// ## Theming
///
/// [StreamChannelHeader] reads its chrome (background, padding, typography,
/// divider) from [StreamChatThemeData.channelHeaderTheme], which is a
/// [StreamAppBarThemeData]. Per-instance overrides go on [style].
///
/// See also:
///
///  * [StreamAppBar], the underlying app bar component.
///  * [StreamAppBarThemeData], for customizing appearance globally.
///  * [StreamChannelListHeader], the equivalent header for the channel
///    list.
///  * [StreamThreadHeader], the equivalent header for a thread.
/// {@endtemplate}
class StreamChannelHeader extends StatelessWidget implements PreferredSizeWidget {
  /// {@macro streamChannelHeader}
  const StreamChannelHeader({
    super.key,
    this.onChannelAvatarPressed,
    this.showConnectionStateTile = false,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.subtitle,
    this.trailing,
    this.primary = true,
    this.style,
    this.floating = false,
  });

  /// Called when the default channel-avatar trailing is pressed.
  ///
  /// Ignored when [trailing] is provided. When null, the avatar is rendered
  /// non-interactive.
  final void Function(Channel channel)? onChannelAvatarPressed;

  /// Whether to show the connection-state banner above the bar.
  final bool showConnectionStateTile;

  /// {@macro StreamAppBar.leading}
  ///
  /// Defaults to a [StreamBackButton] when [automaticallyImplyLeading] is
  /// `true`.
  final Widget? leading;

  /// Whether to render a default [StreamBackButton] as the leading when
  /// [leading] is null.
  ///
  /// Defaults to `true`. Set to `false` to suppress the back button.
  final bool automaticallyImplyLeading;

  /// {@macro StreamAppBar.title}
  ///
  /// Defaults to a [StreamChannelName] for the enclosing channel.
  final Widget? title;

  /// {@macro StreamAppBar.subtitle}
  ///
  /// Defaults to a [StreamChannelInfo] showing typing / member status.
  final Widget? subtitle;

  /// {@macro StreamAppBar.trailing}
  ///
  /// Defaults to a [StreamChannelAvatar] for the enclosing channel wired to
  /// [onChannelAvatarPressed].
  final Widget? trailing;

  /// {@macro StreamAppBar.primary}
  final bool primary;

  /// {@macro StreamAppBar.style}
  ///
  /// Per-instance override; merges over
  /// [StreamChatThemeData.channelHeaderTheme].
  final StreamAppBarStyle? style;

  /// Whether the header is floating.
  final bool floating;

  @override
  Size get preferredSize => const Size.fromHeight(kStreamToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    final headerTheme = StreamChatTheme.of(context).channelHeaderTheme;

    var leading = this.leading;
    if (leading == null && automaticallyImplyLeading) {
      leading = StreamBackButton(showUnreadCount: true, floating: floating);
    }

    var title = this.title;
    title ??= StreamChannelName(channel: channel);

    var subtitle = this.subtitle;
    subtitle ??= StreamChannelInfo(channel: channel);

    var trailing = this.trailing;
    trailing ??= _DefaultChannelAvatar(channel: channel, onPressed: onChannelAvatarPressed);

    return Portal(
      child: StreamConnectionStatusBuilder(
        statusBuilder: (context, status) {
          var statusString = '';
          var showStatus = true;

          switch (status) {
            case ConnectionStatus.connected:
              statusString = context.translations.connectedLabel;
              showStatus = false;
              break;
            case ConnectionStatus.connecting:
              statusString = context.translations.reconnectingLabel;
              break;
            case ConnectionStatus.disconnected:
              statusString = context.translations.disconnectedLabel;
              break;
          }

          return StreamInfoTile(
            showMessage: showConnectionStateTile && showStatus,
            message: statusString,
            // Wrap the bar in a [StreamAppBarTheme] so the per-header chat
            // theme drives all default styling (background, padding,
            // typography, divider) — the bar internally merges in any
            // [style] override the caller passed.
            child: StreamAppBarTheme(
              data: headerTheme,
              child: StreamAppBar(
                leading: leading,
                automaticallyImplyLeading: false,
                title: title,
                subtitle: subtitle,
                trailing: trailing,
                primary: primary,
                style: style,
                floating: floating,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DefaultChannelAvatar extends StatelessWidget {
  const _DefaultChannelAvatar({required this.channel, this.onPressed});

  final Channel channel;
  final void Function(Channel channel)? onPressed;

  @override
  Widget build(BuildContext context) {
    final effectiveOnTap = switch (onPressed) {
      final cb? => () => cb(channel),
      _ => null,
    };

    // Match the 48×48 tap target StreamAppBar's auto-implied leading uses
    // (StreamButton.icon medium = 40 visible + Material padded tap target),
    // so the avatar slot sizes and hit-tests consistently with other bars.
    return SizedBox.square(
      dimension: 48,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: effectiveOnTap,
        child: Center(
          child: StreamChannelAvatar(
            size: .lg,
            channel: channel,
          ),
        ),
      ),
    );
  }
}
