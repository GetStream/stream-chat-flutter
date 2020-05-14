import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';

/// Widget used to provide information about the channel to the widget tree
///
/// Use [StreamChannel.of] to get the current [StreamChannelState] instance.
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

  /// Use this method to get the current [StreamChannelState] instance
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
  /// Current channel
  Channel get channel => widget.channel;

  /// Current channel state stream
  Stream<ChannelState> get channelStateStream =>
      widget.channel.state.channelStateStream;

  final BehaviorSubject<bool> _queryMessageController = BehaviorSubject();

  /// The stream notifying the state of queryMessage call
  Stream<bool> get queryMessage => _queryMessageController.stream;

  bool _paginationEnded = false;

  /// Calls [channel.query] updating [queryMessage] stream
  void queryMessages() {
    if (_paginationEnded) {
      return;
    }

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
      if (res.messages.isEmpty) {
        _paginationEnded = true;
      }
      _queryMessageController.add(false);
    }).catchError((e, stack) {
      _queryMessageController.addError(e, stack);
    });
  }

  /// Calls [channel.getReplies] updating [queryMessage] stream
  Future<void> getReplies(String parentId) async {
    if (_paginationEnded) {
      return;
    }

    _queryMessageController.add(true);

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
      if (res.messages.isEmpty) {
        _paginationEnded = true;
      }
      _queryMessageController.add(false);
    }).catchError((e, stack) {
      _queryMessageController.addError(e, stack);
    });
  }

  /// Query the channel members and watchers
  Future<void> queryMembersAndWatchers() async {
    await widget.channel.query(
      membersPagination: PaginationParams(
        offset: channel.state.members?.length,
        limit: 100,
      ),
      watchersPagination: PaginationParams(
        offset: channel.state.watchers?.length,
        limit: 100,
      ),
    );
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
