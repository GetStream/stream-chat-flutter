import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_neumorphic_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'stream_chat.dart';

typedef _TitleBuilder = Widget Function(
  BuildContext context,
  ConnectionStatus status,
  Client client,
);

///
/// It shows the current [Client] status.
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   final Client client;
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
/// The widget components render the ui based on the first ancestor of type [StreamChatTheme] and on its [ChannelTheme.channelHeaderTheme] property.
/// Modify it to change the widget appearance.
class ChannelListHeader extends StatelessWidget implements PreferredSizeWidget {
  /// Instantiates a ChannelListHeader
  const ChannelListHeader({
    Key key,
    this.client,
    this.titleBuilder,
    this.onUserAvatarTap,
    this.onNewChatButtonTap,
  }) : super(key: key);

  final Client client;

  final _TitleBuilder titleBuilder;

  final Function(User) onUserAvatarTap;

  final VoidCallback onNewChatButtonTap;

  @override
  Widget build(BuildContext context) {
    final _client = client ?? StreamChat.of(context).client;
    final user = _client.state.user;
    return AppBar(
      brightness: Theme.of(context).brightness,
      elevation: 1,
      backgroundColor:
          StreamChatTheme.of(context).channelTheme.channelHeaderTheme.color,
      centerTitle: true,
      leading: Center(
        child: UserAvatar(
          user: user,
          onTap: onUserAvatarTap ?? (_) => Scaffold.of(context).openDrawer(),
          borderRadius: BorderRadius.circular(20),
          constraints: BoxConstraints.tightFor(
            height: 40,
            width: 40,
          ),
        ),
      ),
      actions: [
        StreamNeumorphicButton(
          child: IconButton(
            icon: ValueListenableBuilder<ConnectionStatus>(
              valueListenable: _client.wsConnectionStatus,
              builder: (context, status, child) {
                var color;
                switch (status) {
                  case ConnectionStatus.connected:
                    color = Color(0xFF006CFF);
                    break;
                  case ConnectionStatus.connecting:
                    color = Colors.grey;
                    break;
                  case ConnectionStatus.disconnected:
                    color = Colors.grey;
                    break;
                }
                return Icon(
                  StreamIcons.pen_write,
                  color: color,
                );
              },
            ),
            onPressed: onNewChatButtonTap,
          ),
        )
      ],
      title: ValueListenableBuilder<ConnectionStatus>(
        valueListenable: _client.wsConnectionStatus,
        builder: (context, status, child) {
          if (titleBuilder != null) {
            return titleBuilder(context, status, _client);
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
    );
  }

  Widget _buildConnectedTitleState(BuildContext context) => Text(
        'Stream Chat',
        style: StreamChatTheme.of(context)
            .channelTheme
            .channelHeaderTheme
            .title
            .copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
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
              .channelTheme
              .channelHeaderTheme
              .title
              .copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildDisconnectedTitleState(BuildContext context, Client client) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Offline...',
          style: StreamChatTheme.of(context)
              .channelTheme
              .channelHeaderTheme
              .title
              .copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
        ),
        TextButton(
          onPressed: () => client.connect(),
          child: Text(
            'Try Again',
            style: StreamChatTheme.of(context)
                .channelTheme
                .channelHeaderTheme
                .title
                .copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF006CFF),
                ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
