import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

import './channel_header.dart';
import 'connection_indicator.dart';
import 'message_input.dart';
import 'message_list_view.dart';
import 'stream_channel.dart';
import 'stream_chat.dart';

class MessagePage extends StatefulWidget {
  final PreferredSizeWidget _channelHeader;

  const MessagePage({
    Key key,
    PreferredSizeWidget channelHeader,
    this.parentMessage,
  })  : _channelHeader = channelHeader,
        super(key: key);

  final Message parentMessage;

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  IndicatorController _indicatorController = IndicatorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: widget._channelHeader ?? ChannelHeader(),
      body: Column(
        children: <Widget>[
          ConnectionIndicator(
            indicatorController: _indicatorController,
          ),
          Expanded(
            child: MessageListView(
              parentMessage: widget.parentMessage,
              onThreadSelect: (message) {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => StreamChannel(
                      channelClient: StreamChannel.of(context).channelClient,
                      child: MessagePage(
                        parentMessage: message,
                        channelHeader: widget._channelHeader,
                      ),
                    ),
                    transitionsBuilder: (
                      _,
                      animation,
                      secondaryAnimation,
                      child,
                    ) =>
                        SharedAxisTransition(
                      child: child,
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                    ),
                  ),
                );
              },
            ),
          ),
          MessageInput(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    final streamChat = StreamChat.of(context);
    streamChat.client.wsConnectionStatus.addListener(() {
      if (streamChat.client.wsConnectionStatus.value ==
          ConnectionStatus.disconnected) {
        _indicatorController.showIndicator(
          duration: Duration(minutes: 1),
          color: Colors.red,
          text: 'Disconnected',
        );
      } else if (streamChat.client.wsConnectionStatus.value ==
          ConnectionStatus.connecting) {
        _indicatorController.showIndicator(
          duration: Duration(minutes: 1),
          color: Colors.yellow,
          text: 'Reconnecting',
        );
      } else if (streamChat.client.wsConnectionStatus.value ==
          ConnectionStatus.connected) {
        _indicatorController.showIndicator(
          duration: Duration(seconds: 5),
          color: Colors.green,
          text: 'Connected',
        );

        final streamChat = StreamChannel.of(context);
        streamChat.queryMessages();
      }
    });
  }
}
