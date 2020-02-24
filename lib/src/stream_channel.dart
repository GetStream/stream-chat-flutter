import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';

class StreamChannel extends StatefulWidget {
  StreamChannel({
    Key key,
    @required this.child,
    this.channelClient,
  }) : super(
          key: key,
        );

  final Widget child;
  final ChannelClient channelClient;

  static StreamChannelState of(BuildContext context) {
    StreamChannelState streamChannelState;

    streamChannelState = context.findAncestorStateOfType<StreamChannelState>();

    if (streamChannelState == null) {
      throw Exception(
          'You must have a StreamChannel widget at the top of your widget tree');
    }

    return streamChannelState;
  }

  @override
  StreamChannelState createState() => StreamChannelState(channelClient);
}

class StreamChannelState extends State<StreamChannel> {
  final ChannelClient channelClient;

  StreamChannelState(this.channelClient);

  ChannelState get channelState => channelClient.state.channelState;

  Stream<ChannelState> get channelStateStream =>
      channelClient.state.channelStateStream;

  final BehaviorSubject<bool> _queryMessageController = BehaviorSubject();

  Stream<bool> get queryMessage => _queryMessageController.stream;

  void queryMessages() {
    _queryMessageController.add(true);

    String firstId;
    if (channelState.messages.isNotEmpty) {
      firstId = channelState.messages.first.id;
    }

    channelClient
        .query(
      messagesPagination: PaginationParams(
        lessThan: firstId,
        limit: 100,
      ),
    )
        .then((res) {
      _queryMessageController.add(false);
    }).catchError((e, stack) {
      _queryMessageController.addError(e, stack);
    });
  }

  Future<void> getReplies(String parentId) async {
    _queryMessageController.add(true);

    String firstId;
    if (channelClient.state.threads.containsKey(parentId)) {
      firstId = channelClient.state.threads[parentId].first.id;
    }

    return channelClient
        .getReplies(
      parentId,
      PaginationParams(
        lessThan: firstId,
        limit: 100,
      ),
    )
        .then((res) {
      _queryMessageController.add(false);
    }).catchError((e, stack) {
      _queryMessageController.addError(e, stack);
    });
  }

  @override
  void dispose() {
    _queryMessageController.close();
    channelClient.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (channelClient == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return FutureBuilder<bool>(
      future: channelClient.initialized,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error),
          );
        } else {
          return widget.child;
        }
      },
    );
  }
}
