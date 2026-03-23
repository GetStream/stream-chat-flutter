import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// {@template streamChannelListHeader}
/// Shows the current [StreamChatClient] status.
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   final StreamChatClient client;
///
///   MyApp(this.client);
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: StreamChat(
///         client: client,
///         child: Scaffold(
///             appBar: ChannelListHeader(),
///           ),
///         ),
///     );
///   }
/// }
/// ```
///
/// Usually you would use this widget as an [AppBar] inside a [Scaffold].
/// However, you can also use it as a normal widget.
///
/// Uses the inherited [StreamChatClient], by default, to fetch information
/// about the status of the [client]. You can also pass your own
/// [StreamChatClient] if you don't have it in the widget tree.
///
/// Renders the UI based on the first ancestor of type [StreamChatTheme] and
/// the [StreamChannelListHeaderThemeData] property. Modify it to change the
/// widget's appearance.
/// {@endtemplate}
class StreamChannelListHeader extends StatelessWidget implements PreferredSizeWidget {
  /// {@macro streamChannelListHeader}
  const StreamChannelListHeader({
    super.key,
    this.client,
    this.titleBuilder,
    this.onUserAvatarTap,
    this.onNewChatButtonTap,
    this.showConnectionStateTile = false,
    this.preNavigationCallback,
    this.subtitle,
    this.centerTitle,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.elevation = 0,
    this.scrolledUnderElevation = 0,
  });

  /// Use this if you don't have a [StreamChatClient] in your widget tree.
  final StreamChatClient? client;

  /// {@macro channelListHeaderTitleBuilder}
  final ChannelListHeaderTitleBuilder? titleBuilder;

  /// The action to perform when pressing the user avatar button.
  ///
  /// By default it calls `Scaffold.of(context).openDrawer()`.
  final Function(User)? onUserAvatarTap;

  /// The action to perform when pressing the "new chat" button.
  final VoidCallback? onNewChatButtonTap;

  /// Whether to show the connection state tile
  final bool showConnectionStateTile;

  /// The function to execute before navigation is performed
  final VoidCallback? preNavigationCallback;

  /// Subtitle widget
  final Widget? subtitle;

  /// Whether the title should be centered
  final bool? centerTitle;

  /// Leading widget
  ///
  /// By default it shows the logged in user's avatar
  final Widget? leading;

  /// {@macro flutter.material.appbar.actions}
  ///
  /// The "new chat" button is shown by default.
  final List<Widget>? actions;

  /// The background color for this [StreamChannelListHeader].
  final Color? backgroundColor;

  /// The elevation for this [StreamChannelListHeader].
  final double elevation;

  /// The scrolled under elevation for this [StreamChannelListHeader].
  final double scrolledUnderElevation;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final _client = client ?? StreamChat.of(context).client;
    final user = _client.state.currentUser;
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

          final channelListHeaderThemeData = StreamChannelListHeaderTheme.of(context);

          return StreamInfoTile(
            showMessage: showConnectionStateTile && showStatus,
            message: statusString,
            child: StreamAppBar(
              elevation: elevation,
              scrolledUnderElevation: scrolledUnderElevation,
              backgroundColor: backgroundColor ?? channelListHeaderThemeData.color,
              centerTitle: centerTitle,
              leading: switch ((leading, user)) {
                (final leading?, _) => leading,
                (_, final user?) => Padding(
                  padding: EdgeInsets.only(left: context.streamSpacing.sm),
                  child: Center(
                    child: GestureDetector(
                      onTap: switch (onUserAvatarTap) {
                        final onTap? => () => onTap(user),
                        _ => () {
                          preNavigationCallback?.call();
                          Scaffold.of(context).openDrawer();
                        },
                      },
                      child: StreamUserAvatar(
                        size: .lg,
                        user: user,
                        showOnlineIndicator: false,
                      ),
                    ),
                  ),
                ),
                _ => const Empty(),
              },
              actionsPadding: EdgeInsets.only(right: context.streamSpacing.sm),
              actions:
                  actions ??
                  [
                    StreamConnectionStatusBuilder(
                      statusBuilder: (context, status) {
                        final callback = switch (status) {
                          ConnectionStatus.connected => onNewChatButtonTap,
                          ConnectionStatus.connecting => null,
                          ConnectionStatus.disconnected => null,
                        };

                        return StreamButton.icon(
                          icon: context.streamIcons.plusLarge,
                          onTap: callback,
                        );
                      },
                    ),
                  ],
              title: Column(
                children: [
                  Builder(
                    builder: (context) {
                      if (titleBuilder != null) {
                        return titleBuilder!(context, status, _client);
                      }
                      switch (status) {
                        case ConnectionStatus.connected:
                          return _ConnectedTitleState();
                        case ConnectionStatus.connecting:
                          return _ConnectingTitleState();
                        case ConnectionStatus.disconnected:
                          return _DisconnectedTitleState(client: _client);
                      }
                    },
                  ),
                  subtitle ?? const Empty(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ConnectedTitleState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.streamTextTheme;
    return Text(
      context.translations.streamChatLabel,
      style: textTheme.headingSm,
    );
  }
}

class _ConnectingTitleState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 16,
          width: 16,
          child: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          context.translations.searchingForNetworkText,
          style: StreamChannelListHeaderTheme.of(context).titleStyle?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _DisconnectedTitleState extends StatelessWidget {
  const _DisconnectedTitleState({
    required this.client,
  });

  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    final channelListHeaderTheme = StreamChannelListHeaderTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.translations.offlineLabel,
          style: channelListHeaderTheme.titleStyle?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: client.maybeReconnect,
          child: Text(
            context.translations.tryAgainLabel,
            style: channelListHeaderTheme.titleStyle?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: chatThemeData.colorTheme.accentPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
