import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';

class StreamChannel extends StatefulWidget {
  StreamChannel({
    Key key,
    @required this.child,
    @required this.channel,
  }) : super(
          key: key,
        );

  final Widget child;
  final Channel channel;

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

  Channel get channel => widget.channel;

  Stream<ChannelState> get channelStateStream =>
      widget.channel.state.channelStateStream;

  final BehaviorSubject<bool> _queryMessageController = BehaviorSubject();

  Stream<bool> get queryMessage => _queryMessageController.stream;

  void queryMessages() {
    _queryMessageController.add(true);

    String firstId;
    if (channel.state.messages.isNotEmpty) {
      firstId = channel.state.messages.first.id;
    }

    widget.channel
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
    print('PARENT $parentId');

    String firstId;
    if (widget.channel.state.threads.containsKey(parentId)) {
      final thread = widget.channel.state.threads[parentId];

      if (thread != null && thread.isNotEmpty) {
        firstId = thread?.first?.id;
      }
    }

    return widget.channel
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
    if (widget.channel == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return FutureBuilder<bool>(
      future: widget.channel.initialized,
      initialData: widget.channel.state != null,
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data) {
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
