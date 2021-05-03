import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_chat_flutter/src/stream_neumorphic_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'connection_status_builder.dart';
import 'info_tile.dart';
import 'stream_chat.dart';

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
/// The widget by default uses the inherited [StreamChatClient] to fetch information about the status.
/// However you can also pass your own [StreamChatClient] if you don't have it in the widget tree.
///
/// The widget components render the ui based on the first ancestor of type [StreamChatTheme] and on its [ChannelListHeaderTheme] property.
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

  final bool showConnectionStateTile;

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
    final user = _client.state.user;
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

        return InfoTile(
          showMessage: showConnectionStateTile ? showStatus : false,
          message: statusString,
          child: AppBar(
            brightness: Theme.of(context).brightness,
            elevation: 1,
            backgroundColor:
                StreamChatTheme.of(context).channelListHeaderTheme.color,
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
                          borderRadius: StreamChatTheme.of(context)
                              .channelListHeaderTheme
                              .avatarTheme
                              ?.borderRadius,
                          constraints: StreamChatTheme.of(context)
                              .channelListHeaderTheme
                              .avatarTheme
                              ?.constraints,
                        )
                      : Offstage(),
                ),
            actions: actions ??
                [
                  StreamNeumorphicButton(
                    child: IconButton(
                      icon: ConnectionStatusBuilder(
                        statusBuilder: (context, status) {
                          var color;
                          switch (status) {
                            case ConnectionStatus.connected:
                              color = StreamChatTheme.of(context)
                                  .colorTheme
                                  .accentBlue;
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
                            width: 24.0,
                            height: 24.0,
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
                        return Offstage();
                    }
                  },
                ),
                subtitle ?? Offstage(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConnectedTitleState(BuildContext context) => Text(
        'Stream Chat',
        style: StreamChatTheme.of(context).textTheme.headlineBold.copyWith(
              color: StreamChatTheme.of(context).colorTheme.black,
            ),
      );

  Widget _buildConnectingTitleState(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 16,
          width: 16,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        SizedBox(width: 10),
        Text(
          'Searching for Network',
          style: StreamChatTheme.of(context)
              .channelListHeaderTheme
              .title
              ?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildDisconnectedTitleState(
    BuildContext context,
    StreamChatClient client,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Offline...',
          style: StreamChatTheme.of(context)
              .channelListHeaderTheme
              .title
              ?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
        ),
        TextButton(
          onPressed: () async {
            await client.disconnect();
            await client.connect();
          },
          child: Text(
            'Try Again',
            style: StreamChatTheme.of(context)
                .channelListHeaderTheme
                .title
                ?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: StreamChatTheme.of(context).colorTheme.accentBlue,
                ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
