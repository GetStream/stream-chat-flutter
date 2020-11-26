import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelInfo extends StatelessWidget {
  final Channel channel;

  /// The style of the text displayed
  final TextStyle textStyle;

  /// If true the typing indicator will be rendered if a user is typing
  final bool showTypingIndicator;

  const ChannelInfo({
    Key key,
    @required this.channel,
    this.textStyle,
    this.showTypingIndicator = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context).client;
    return StreamBuilder<List<Member>>(
      stream: channel.state.membersStream,
      initialData: channel.state.members,
      builder: (context, snapshot) {
        return ValueListenableBuilder(
          valueListenable: client.wsConnectionStatus,
          builder: (context, status, child) {
            switch (status) {
              case ConnectionStatus.connected:
                return _buildConnectedTitleState(context, snapshot.data);
              case ConnectionStatus.connecting:
                return _buildConnectingTitleState(context);
              case ConnectionStatus.disconnected:
                return _buildDisconnectedTitleState(context, client);
              default:
                return Offstage();
            }
          },
        );
      },
    );
  }

  Widget _buildConnectedTitleState(BuildContext context, List<Member> members) {
    var alternativeWidget;

    if (channel.memberCount != null && channel.memberCount > 2) {
      alternativeWidget = Text(
        '${channel.memberCount} Members, ${channel.state.watcherCount} Online',
        style: StreamChatTheme.of(context)
            .channelTheme
            .channelHeaderTheme
            .lastMessageAt,
      );
    } else {
      final otherMember = members.firstWhere(
        (element) => element.userId != StreamChat.of(context).user.id,
        orElse: () => null,
      );

      if (otherMember != null) {
        if (otherMember.user.online) {
          alternativeWidget = Text(
            'Online',
            style: StreamChatTheme.of(context)
                .channelTheme
                .channelHeaderTheme
                .lastMessageAt,
          );
        } else {
          alternativeWidget = Text(
            'Last seen ${Jiffy(otherMember.user.lastActive).fromNow()}',
            style: textStyle,
          );
        }
      }
    }

    if (!showTypingIndicator) {
      return alternativeWidget;
    }

    return TypingIndicator(
      alignment: Alignment.center,
      alternativeWidget: alternativeWidget,
      style: textStyle,
    );
  }

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
          style: textStyle,
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
          style: textStyle,
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
          ),
          onPressed: () async {
            await client.disconnect();
            return client.connect();
          },
          child: Text(
            'Try Again',
            style: textStyle.copyWith(
              color: Color(0xFF006CFF),
            ),
          ),
        ),
      ],
    );
  }
}
