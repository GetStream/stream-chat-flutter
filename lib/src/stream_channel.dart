import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';

class StreamChannel extends StatefulWidget {
  StreamChannel({
    Key key,
    @required this.child,
    @required this.channelClient,
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
  StreamChannelState createState() => StreamChannelState();
}

class StreamChannelState extends State<StreamChannel> {
  StreamChannelState();

  ChannelClient get channelClient => widget.channelClient;

  ChannelState get channelState => widget.channelClient.state.channelState;

  Stream<ChannelState> get channelStateStream =>
      widget.channelClient.state.channelStateStream;

  final BehaviorSubject<bool> _queryMessageController = BehaviorSubject();

  Stream<bool> get queryMessage => _queryMessageController.stream;

  void queryMessages() {
    _queryMessageController.add(true);

    String firstId;
    if (channelState.messages.isNotEmpty) {
      firstId = channelState.messages.first.id;
    }

    widget.channelClient
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
    if (widget.channelClient.state.threads.containsKey(parentId)) {
      firstId = widget.channelClient.state.threads[parentId].first.id;
    }

    return widget.channelClient
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.channelClient == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return FutureBuilder<bool>(
      future: widget.channelClient.initialized,
      initialData: widget.channelClient.state != null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
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
