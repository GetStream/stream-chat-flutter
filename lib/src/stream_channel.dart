import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';

enum QueryDirection { top, bottom }

/// Widget used to provide information about the channel to the widget tree
///
/// Use [StreamChannel.of] to get the current [StreamChannelState] instance.
class StreamChannel extends StatefulWidget {
  StreamChannel({
    Key key,
    @required this.child,
    @required this.channel,
    this.showLoading = true,
  }) : super(
          key: key,
        );

  final Widget child;
  final Channel channel;
  final bool showLoading;

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

  bool _topPaginationEnded = false;
  bool _bottomPaginationEnded = false;

  /// Calls [channel.query] updating [queryMessage] stream
  void queryMessages({QueryDirection direction = QueryDirection.top}) {
    if (_queryMessageController.value == true ||
        (_topPaginationEnded && _bottomPaginationEnded)) {
      return;
    }

    _queryMessageController.add(true);

    String id;
    PaginationParams params;

    final messageLimit = 25;

    if (channel.state.messages.isNotEmpty) {
      switch (direction) {
        case QueryDirection.top:
          id = channel.state.messages.first.id;
          params = PaginationParams(
            lessThan: id,
            limit: messageLimit,
          );
          break;
        case QueryDirection.bottom:
          id = channel.state.messages.last.id;
          params = PaginationParams(
            greaterThan: id,
            limit: messageLimit,
          );
          break;
      }
    }

    widget.channel
        .query(
      messagesPagination: params,
      preferOffline: true,
    )
        .then((res) {
      if (res.messages.isEmpty || res.messages.length < messageLimit) {
        switch (direction) {
          case QueryDirection.top:
            _topPaginationEnded = true;
            break;
          case QueryDirection.bottom:
            _bottomPaginationEnded = true;
            break;
        }
      }
      _queryMessageController.add(false);
    }).catchError((e, stack) {
      if (!_queryMessageController.isClosed) {
        _queryMessageController.addError(e, stack);
      }
    });
  }

  /// Calls [channel.getReplies] updating [queryMessage] stream
  Future<void> getReplies(
    String parentId, {
    QueryDirection direction = QueryDirection.top,
  }) async {
    if (_queryMessageController.value == true ||
        (_topPaginationEnded && _bottomPaginationEnded)) {
      return;
    }

    _queryMessageController.add(true);

    String id;
    PaginationParams params;

    final messageLimit = 50;

    if (widget.channel.state.threads.containsKey(parentId)) {
      final thread = widget.channel.state.threads[parentId];
      if (thread != null && thread.isNotEmpty) {
        switch (direction) {
          case QueryDirection.top:
            id = thread?.first?.id;
            params = PaginationParams(
              lessThan: id,
              limit: messageLimit,
            );
            break;
          case QueryDirection.bottom:
            id = thread?.last?.id;
            params = PaginationParams(
              greaterThan: id,
              limit: messageLimit,
            );
            break;
        }
      }
    }

    return widget.channel
        .getReplies(
      parentId,
      params,
      preferOffline: true,
    )
        .then((res) {
      if (res.messages.isEmpty || res.messages.length < messageLimit) {
        switch (direction) {
          case QueryDirection.top:
            _topPaginationEnded = true;
            break;
          case QueryDirection.bottom:
            _bottomPaginationEnded = true;
            break;
        }
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
        if (widget.showLoading && (!snapshot.hasData || !snapshot.data)) {
          return Container(
            height: 30,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            height: 30,
            child: Center(
              child: Text(snapshot.error),
            ),
          );
        } else {
          return widget.child;
        }
      },
    );
  }
}
