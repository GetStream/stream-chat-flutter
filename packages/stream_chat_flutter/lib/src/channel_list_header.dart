import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_chat_flutter/src/stream_neumorphic_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Widget builder for title
typedef TitleBuilder = Widget Function(
  BuildContext context,
  ConnectionStatus status,
  StreamChatClient client,
);

///
/// It shows the current [StreamChatClient] status.
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
/// However you can also use it as a normal widget.
///
/// The widget by default uses the inherited [StreamChatClient]
/// to fetch information about the status.
/// However you can also pass your own [StreamChatClient]
/// if you don't have it in the widget tree.
///
/// The widget components render the ui based on the first ancestor of type
/// [StreamChatTheme] and on its [ChannelListHeaderThemeData] property.
/// Modify it to change the widget appearance.
class ChannelListHeader extends StatelessWidget implements PreferredSizeWidget {
  /// Instantiates a ChannelListHeader
  const ChannelListHeader({
    Key? key,
    this.client,
    this.titleBuilder,
    this.onUserAvatarTap,
    this.onNewChatButtonTap,
    this.showConnectionStateTile = false,
    this.preNavigationCallback,
    this.subtitle,
    this.leading,
    this.actions,
  }) : super(key: key);

  /// Pass this if you don't have a [StreamChatClient] in your widget tree.
  final StreamChatClient? client;

  /// Use this to build your own title as per different [ConnectionStatus]
  final TitleBuilder? titleBuilder;

  /// Callback to call when pressing the user avatar button.
  /// By default it calls Scaffold.of(context).openDrawer()
  final Function(User)? onUserAvatarTap;

  /// Callback to call when pressing the new chat button.
  final VoidCallback? onNewChatButtonTap;

  /// Show connection state tile
  final bool showConnectionStateTile;

  /// Callback before navigation is performed
  final VoidCallback? preNavigationCallback;

  /// Subtitle widget
  final Widget? subtitle;

  /// Leading widget
  /// By default it shows the logged in user avatar
  final Widget? leading;

  /// AppBar actions
  /// By default it shows the new chat button
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final _client = client ?? StreamChat.of(context).client;
    final user = _client.state.currentUser;
    return ConnectionStatusBuilder(
      statusBuilder: (context, status) {
        var statusString = '';
        var showStatus = true;

        switch (status) {
          case ConnectionStatus.connected:
            statusString = 'Connected';
            showStatus = false;
            break;
          case ConnectionStatus.connecting:
            statusString = 'Reconnecting...';
            break;
          case ConnectionStatus.disconnected:
            statusString = 'Disconnected';
            break;
        }

        final chatThemeData = StreamChatTheme.of(context);
        final channelListHeaderThemeData = ChannelListHeaderTheme.of(context);
        return InfoTile(
          // ignore: avoid_bool_literals_in_conditional_expressions
          showMessage: showConnectionStateTile ? showStatus : false,
          message: statusString,
          child: AppBar(
            textTheme: Theme.of(context).textTheme,
            brightness: Theme.of(context).brightness,
            elevation: 1,
            backgroundColor: channelListHeaderThemeData.color,
            centerTitle: true,
            leading: leading ??
                Center(
                  child: user != null
                      ? UserAvatar(
                          user: user,
                          showOnlineStatus: false,
                          onTap: onUserAvatarTap ??
                              (_) {
                                if (preNavigationCallback != null) {
                                  preNavigationCallback!();
                                }
                                Scaffold.of(context).openDrawer();
                              },
                          borderRadius: channelListHeaderThemeData
                              .avatarTheme?.borderRadius,
                          constraints: channelListHeaderThemeData
                              .avatarTheme?.constraints,
                        )
                      : const Offstage(),
                ),
            actions: actions ??
                [
                  StreamNeumorphicButton(
                    child: IconButton(
                      icon: ConnectionStatusBuilder(
                        statusBuilder: (context, status) {
                          Color? color;
                          switch (status) {
                            case ConnectionStatus.connected:
                              color = chatThemeData.colorTheme.accentPrimary;
                              break;
                            case ConnectionStatus.connecting:
                              color = Colors.grey;
                              break;
                            case ConnectionStatus.disconnected:
                              color = Colors.grey;
                              break;
                          }
                          return SvgPicture.asset(
                            'svgs/icon_pen_write.svg',
                            package: 'stream_chat_flutter',
                            width: 24,
                            height: 24,
                            color: color,
                          );
                        },
                      ),
                      onPressed: onNewChatButtonTap,
                    ),
                  )
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
                        return _buildConnectedTitleState(context);
                      case ConnectionStatus.connecting:
                        return _buildConnectingTitleState(context);
                      case ConnectionStatus.disconnected:
                        return _buildDisconnectedTitleState(context, _client);
                      default:
                        return const Offstage();
                    }
                  },
                ),
                subtitle ?? const Offstage(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConnectedTitleState(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    return Text(
      'Stream Chat',
      style: chatThemeData.textTheme.headlineBold.copyWith(
        color: chatThemeData.colorTheme.textHighEmphasis,
      ),
    );
  }

  Widget _buildConnectingTitleState(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 16,
            width: 16,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Searching for Network',
            style: ChannelListHeaderTheme.of(context).titleStyle?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      );

  Widget _buildDisconnectedTitleState(
    BuildContext context,
    StreamChatClient client,
  ) {
    final chatThemeData = StreamChatTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Offline...',
          style: chatThemeData.channelListHeaderTheme.titleStyle?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () => client
            ..closeConnection()
            ..openConnection(),
          child: Text(
            'Try Again',
            style: chatThemeData.channelListHeaderTheme.titleStyle?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: chatThemeData.colorTheme.accentPrimary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
