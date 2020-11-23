import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_neumorphic_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'stream_chat.dart';

typedef TitleBuilder = Widget Function(
  BuildContext context,
  ConnectionStatus status,
  Client client,
);

class ChannelListHeader extends StatelessWidget implements PreferredSizeWidget {
  const ChannelListHeader({
    Key key,
    this.client,
    this.titleBuilder,
  }) : super(key: key);

  final Client client;

  final TitleBuilder titleBuilder;

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
          onTap: (_) => Scaffold.of(context).openDrawer(),
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
            onPressed: () {},
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
              return _buildConnectedTitleState();
            case ConnectionStatus.connecting:
              return _buildConnectingTitleState();
            case ConnectionStatus.disconnected:
              return _buildDisconnectedTitleState(_client);
            default:
              return Offstage();
          }
        },
      ),
    );
  }

  Widget _buildConnectedTitleState() => Text(
        'Stream Chat',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );

  Widget _buildConnectingTitleState() {
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        )
      ],
    );
  }

  Widget _buildDisconnectedTitleState(Client client) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Offline...',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: () => client.connect(),
          child: Text(
            'Try Again',
            style: TextStyle(
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
