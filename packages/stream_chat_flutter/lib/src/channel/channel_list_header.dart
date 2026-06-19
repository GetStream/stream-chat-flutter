import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamChannelListHeader}
/// A top-of-screen header for the channel list, surfacing the current
/// [StreamChatClient] connection status.
///
/// [StreamChannelListHeader] renders a [StreamAppBar] whose default title
/// reflects the connection state — _Stream Chat_ when connected, a
/// loading spinner + _Searching for network…_ when connecting, and an
/// _Offline_ label with a _try again_ affordance when disconnected.
///
/// The leading slot is always the signed-in user's avatar. Tap behaviour
/// is wired through [onUserAvatarPressed]; when the callback is null the
/// avatar mirrors Material [AppBar]'s auto-implied leading by opening the
/// enclosing [Scaffold]'s drawer if one exists, and is otherwise rendered
/// non-interactive.
///
/// The trailing slot is empty by default — pass [trailing] to wire up an
/// action such as a _new chat_ button.
///
/// When [showConnectionStateTile] is true, a [StreamInfoTile] banner is
/// rendered above the bar while the client is reconnecting or offline.
///
/// [StreamChannelListHeader] implements [PreferredSizeWidget] so it can
/// be passed directly to [Scaffold.appBar].
///
/// {@tool snippet}
///
/// Basic usage as a [Scaffold.appBar] — the avatar opens the [Scaffold]'s
/// drawer automatically when one is provided:
///
/// ```dart
/// Scaffold(
///   appBar: const StreamChannelListHeader(),
///   drawer: MyDrawer(user: currentUser),
///   body: const StreamChannelListView(),
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// With a custom avatar tap and a trailing _new chat_ button:
///
/// ```dart
/// StreamChannelListHeader(
///   onUserAvatarPressed: (user) => showProfile(context, user),
///   trailing: StreamButton.icon(
///     icon: Icon(context.streamIcons.plus),
///     onPressed: () => GoRouter.of(context).pushNamed('new-chat'),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// ## Theming
///
/// [StreamChannelListHeader] reads its chrome (background, padding,
/// typography, divider) from [StreamChatThemeData.channelListHeaderTheme],
/// which is a [StreamAppBarThemeData]. Per-instance overrides go on
/// [style].
///
/// See also:
///
///  * [StreamAppBar], the underlying app bar component.
///  * [StreamAppBarThemeData], for customizing appearance globally.
///  * [StreamChannelHeader], the equivalent header for a single channel.
/// {@endtemplate}
class StreamChannelListHeader extends StatelessWidget implements PreferredSizeWidget {
  /// {@macro streamChannelListHeader}
  const StreamChannelListHeader({
    super.key,
    this.client,
    this.onUserAvatarPressed,
    this.showConnectionStateTile = false,
    this.title,
    this.subtitle,
    this.trailing,
    this.primary = true,
    this.style,
  });

  /// Use this if you don't have a [StreamChatClient] in your widget tree.
  final StreamChatClient? client;

  /// Called when the user-avatar leading is pressed.
  ///
  /// When null, the avatar opens the enclosing [Scaffold]'s drawer if one
  /// exists (matching Material [AppBar]); otherwise it's rendered
  /// non-interactive.
  final void Function(User user)? onUserAvatarPressed;

  /// Whether to show the connection-state banner above the bar.
  final bool showConnectionStateTile;

  /// {@macro StreamAppBar.title}
  ///
  /// Defaults to a connection-state-aware title — see the class docs.
  final Widget? title;

  /// {@macro StreamAppBar.subtitle}
  final Widget? subtitle;

  /// {@macro StreamAppBar.trailing}
  ///
  /// No default — pass a widget to wire up an action.
  final Widget? trailing;

  /// {@macro StreamAppBar.primary}
  final bool primary;

  /// {@macro StreamAppBar.style}
  ///
  /// Per-instance override; merges over
  /// [StreamChatThemeData.channelListHeaderTheme].
  final StreamAppBarStyle? style;

  @override
  Size get preferredSize => const Size.fromHeight(kStreamToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final _client = client ?? StreamChat.of(context).client;
    final headerTheme = StreamChatTheme.of(context).channelListHeaderTheme;

    final effectiveAppBarBehavior =
        style?.behavior ??
        StreamAppBarTheme.of(context).style?.behavior ??
        (StreamTheme.of(context).appStyle.isFloating ? .floating : .regular);
    final hasAvatarShadow = switch (effectiveAppBarBehavior) {
      .floating => true,
      .regular => false,
    };

    final leading = _DefaultUserAvatar(client: _client, onPressed: onUserAvatarPressed, isFloating: hasAvatarShadow);

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

          final title =
              this.title ??
              switch (status) {
                ConnectionStatus.connected => _ConnectedTitleState(),
                ConnectionStatus.connecting => _ConnectingTitleState(),
                ConnectionStatus.disconnected => _DisconnectedTitleState(client: _client),
              };

          return StreamInfoTile(
            showMessage: showConnectionStateTile && showStatus,
            message: statusString,
            // Wrap the bar in a [StreamAppBarTheme] so the per-header chat
            // theme drives all default styling — the bar internally merges
            // in any [style] override the caller passed.
            child: StreamAppBarTheme(
              data: headerTheme,
              child: StreamAppBar(
                leading: leading,
                title: title,
                subtitle: subtitle,
                trailing: trailing,
                primary: primary,
                style: style,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DefaultUserAvatar extends StatelessWidget {
  const _DefaultUserAvatar({required this.client, this.onPressed, this.isFloating = false});

  final StreamChatClient client;
  final void Function(User user)? onPressed;
  final bool isFloating;

  @override
  Widget build(BuildContext context) {
    final user = client.state.currentUser;
    if (user == null) return const SizedBox.shrink();

    // Caller-provided handler wins; otherwise mirror Material AppBar and
    // open the enclosing Scaffold's drawer if one exists. With no callback
    // and no drawer, the avatar is non-interactive.
    final scaffold = Scaffold.maybeOf(context);
    final effectiveOnTap = switch (onPressed) {
      final cb? => () => cb(user),
      _ => scaffold?.openDrawer,
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
          child: StreamUserAvatar(
            size: .lg,
            user: user,
            showOnlineIndicator: false,
            isFloating: isFloating,
          ),
        ),
      ),
    );
  }
}

class _ConnectedTitleState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      context.translations.streamChatLabel,
      style: context.streamTextTheme.headingSm,
    );
  }
}

class _ConnectingTitleState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamLoadingSpinner(size: .sm),
        const SizedBox(width: 10),
        Text(
          context.translations.searchingForNetworkText,
          style: textTheme.headingSm.copyWith(color: colorScheme.textPrimary),
        ),
      ],
    );
  }
}

class _DisconnectedTitleState extends StatelessWidget {
  const _DisconnectedTitleState({required this.client});

  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.translations.offlineLabel,
          style: textTheme.headingSm.copyWith(color: colorScheme.textPrimary),
        ),
        StreamButton(
          type: .ghost,
          style: .primary,
          size: .small,
          onPressed: client.maybeReconnect,
          child: Text(context.translations.tryAgainLabel),
        ),
      ],
    );
  }
}
