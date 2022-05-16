import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/stream_controller_extension.dart';

/// Specifies query direction for pagination
enum QueryDirection {
  /// Query earlier messages
  top,

  /// Query later messages
  bottom,
}

/// Widget used to provide information about the channel to the widget tree
///
/// Use [StreamChannel.of] to get the current [StreamChannelState] instance.
class StreamChannel extends StatefulWidget {
  /// Creates a new instance of [StreamChannel]. Both [child] and [client] must
  /// be supplied and not null.
  const StreamChannel({
    super.key,
    required this.child,
    required this.channel,
    this.showLoading = true,
    this.initialMessageId,
  });

  /// The child of the widget
  final Widget child;

  /// [channel] specifies the channel with which child should be wrapped
  final Channel channel;

  /// Shows a loading indicator
  final bool showLoading;

  /// If passed the channel will load from this particular message.
  final String? initialMessageId;

  /// Use this method to get the current [StreamChannelState] instance
  static StreamChannelState of(BuildContext context) {
    StreamChannelState? streamChannelState;

    streamChannelState = context.findAncestorStateOfType<StreamChannelState>();

    assert(
      streamChannelState != null,
      'You must have a StreamChannel widget at the top of your widget tree',
    );

    return streamChannelState!;
  }

  @override
  StreamChannelState createState() => StreamChannelState();
}

// ignore: public_member_api_docs
class StreamChannelState extends State<StreamChannel> {
  /// Current channel
  Channel get channel => widget.channel;

  /// InitialMessageId
  String? get initialMessageId => widget.initialMessageId;

  /// Current channel state stream
  Stream<ChannelState>? get channelStateStream =>
      widget.channel.state?.channelStateStream;

  final _queryTopMessagesController = BehaviorSubject.seeded(false);
  final _queryBottomMessagesController = BehaviorSubject.seeded(false);

  /// The stream notifying the state of [_queryTopMessages] call
  Stream<bool> get queryTopMessages => _queryTopMessagesController.stream;

  /// The stream notifying the state of [_queryBottomMessages] call
  Stream<bool> get queryBottomMessages => _queryBottomMessagesController.stream;

  bool _topPaginationEnded = false;
  bool _bottomPaginationEnded = false;

  Future<void> _queryTopMessages({
    int limit = 20,
    bool preferOffline = false,
  }) async {
    if (_topPaginationEnded ||
        _queryTopMessagesController.value ||
        channel.state == null) {
      return;
    }
    _queryTopMessagesController.safeAdd(true);

    if (channel.state!.messages.isEmpty) {
      return _queryTopMessagesController.safeAdd(false);
    }

    final oldestMessage = channel.state!.messages.first;

    try {
      final state = await queryBeforeMessage(
        oldestMessage.id,
        limit: limit,
        preferOffline: preferOffline,
      );
      if (state.messages == null ||
          state.messages!.isEmpty ||
          state.messages!.length < limit) {
        _topPaginationEnded = true;
      }
      _queryTopMessagesController.safeAdd(false);
    } catch (e, stk) {
      _queryTopMessagesController.safeAddError(e, stk);
    }
  }

  Future<void> _queryBottomMessages({
    int limit = 20,
    bool preferOffline = false,
  }) async {
    if (_bottomPaginationEnded ||
        _queryBottomMessagesController.value ||
        channel.state == null ||
        channel.state!.isUpToDate) return;
    _queryBottomMessagesController.safeAdd(true);

    if (channel.state!.messages.isEmpty) {
      return _queryBottomMessagesController.safeAdd(false);
    }

    final recentMessage = channel.state!.messages.last;

    try {
      final state = await queryAfterMessage(
        recentMessage.id,
        limit: limit,
        preferOffline: preferOffline,
      );
      if (state.messages == null ||
          state.messages!.isEmpty ||
          state.messages!.length < limit) {
        _bottomPaginationEnded = true;
      }
      _queryBottomMessagesController.safeAdd(false);
    } catch (e, stk) {
      _queryBottomMessagesController.safeAddError(e, stk);
    }
  }

  /// Calls [channel.query] updating [queryMessage] stream
  Future<void> queryMessages({
    QueryDirection? direction = QueryDirection.top,
    int limit = 20,
  }) {
    if (direction == QueryDirection.top) {
      return _queryTopMessages(limit: limit);
    }
    return _queryBottomMessages(limit: limit);
  }

  /// Calls [channel.getReplies] updating [queryMessage] stream
  Future<void> getReplies(
    String parentId, {
    int limit = 50,
    bool preferOffline = false,
  }) async {
    if (_topPaginationEnded ||
        _queryTopMessagesController.value ||
        channel.state == null) return;
    _queryTopMessagesController.safeAdd(true);

    Message? message;
    if (channel.state!.threads.containsKey(parentId)) {
      final thread = channel.state!.threads[parentId]!;
      if (thread.isNotEmpty) {
        message = thread.first;
      }
    }

    try {
      final response = await channel.getReplies(
        parentId,
        options: PaginationParams(
          lessThan: message?.id,
          limit: limit,
        ),
        preferOffline: preferOffline,
      );
      if (response.messages.isEmpty || response.messages.length < limit) {
        _topPaginationEnded = true;
      }
      _queryTopMessagesController.safeAdd(false);
    } catch (e, stk) {
      _queryTopMessagesController.safeAddError(e, stk);
    }
  }

  /// Query the channel members and watchers
  Future<void> queryMembersAndWatchers() async {
    final _members = channel.state?.members;
    if (_members != null) {
      await widget.channel.query(
        membersPagination: PaginationParams(
          offset: _members.length,
          limit: 100,
        ),
        watchersPagination: PaginationParams(
          offset: _members.length,
          limit: 100,
        ),
      );
    } else {
      return;
    }
  }

  /// Loads channel at specific message
  Future<void> loadChannelAtMessage(
    String? messageId, {
    @Deprecated('before is deprecated, use limit instead') int before = 20,
    @Deprecated('before is deprecated, use limit instead') int after = 20,
    int limit = 20,
    bool preferOffline = false,
  }) =>
      _queryAtMessage(
        messageId: messageId,
        limit: limit,
        preferOffline: preferOffline,
      );

  Future<ChannelState?> _queryAtMessage({
    String? messageId,
    int limit = 20,
    bool preferOffline = false,
  }) async {
    if (channel.state == null) return null;
    channel.state!.isUpToDate = false;
    channel.state!.truncate();

    if (messageId == null) {
      await channel.query(
        messagesPagination: PaginationParams(
          limit: limit,
        ),
        preferOffline: preferOffline,
      );
      channel.state!.isUpToDate = true;
      return null;
    }

    return queryAroundMessage(
      messageId,
      limit: limit,
      preferOffline: preferOffline,
    );
  }

  ///
  Future<ChannelState> queryAroundMessage(
    String messageId, {
    @Deprecated('before is deprecated, use limit instead') int before = 20,
    @Deprecated('after is deprecated, use limit instead') int after = 20,
    int limit = 20,
    bool preferOffline = false,
  }) =>
      channel.query(
        messagesPagination: PaginationParams(
          idAround: messageId,
          limit: limit,
        ),
        preferOffline: preferOffline,
      );

  ///
  Future<ChannelState> queryBeforeMessage(
    String messageId, {
    int limit = 20,
    bool preferOffline = false,
  }) =>
      channel.query(
        messagesPagination: PaginationParams(
          lessThan: messageId,
          limit: limit,
        ),
        preferOffline: preferOffline,
      );

  ///
  Future<ChannelState> queryAfterMessage(
    String messageId, {
    int limit = 20,
    bool preferOffline = false,
  }) async {
    final state = await channel.query(
      messagesPagination: PaginationParams(
        greaterThanOrEqual: messageId,
        limit: limit,
      ),
      preferOffline: preferOffline,
    );
    if (state.messages == null ||
        state.messages!.isEmpty ||
        state.messages!.length < limit) {
      channel.state?.isUpToDate = true;
    }
    return state;
  }

  ///
  Future<Message> getMessage(String messageId) async {
    var message = channel.state?.messages.firstWhereOrNull(
      (it) => it.id == messageId,
    );
    if (message == null) {
      final response = await channel.getMessagesById([messageId]);
      message = response.messages.first;
    }
    return message;
  }

  /// Query channel members.
  Future<List<Member>> queryMembers({
    Filter? filter,
    List<SortOption>? sort,
    PaginationParams? pagination,
  }) async {
    final response = await channel.queryMembers(
      filter: filter,
      sort: sort,
      pagination: pagination,
    );
    return response.members;
  }

  /// Reloads the channel with latest message
  Future<void> reloadChannel() => _queryAtMessage(limit: 30);

  late List<Future<bool>> _futures;

  Future<bool> get _loadChannelAtMessage async {
    try {
      await loadChannelAtMessage(initialMessageId);
      return true;
    } catch (_) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _populateFutures();
  }

  void _populateFutures() {
    _futures = [widget.channel.initialized];
    if (initialMessageId != null) {
      _futures.add(_loadChannelAtMessage);
    }
  }

  @override
  void didUpdateWidget(covariant StreamChannel oldWidget) {
    if (oldWidget.initialMessageId != initialMessageId) {
      _populateFutures();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _queryTopMessagesController.close();
    _queryBottomMessagesController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = FutureBuilder<List<bool>>(
      future: Future.wait(_futures),
      initialData: [
        channel.state != null,
        if (initialMessageId != null) false,
      ],
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          var message = snapshot.error.toString();
          if (snapshot.error is DioError) {
            final dioError = snapshot.error as DioError?;
            if (dioError?.type == DioErrorType.response) {
              message = dioError!.message;
            } else {
              message = 'Check your connection and retry';
            }
          }
          return Center(child: Text(message));
        }
        final initialized = snapshot.data![0];
        // ignore: avoid_bool_literals_in_conditional_expressions
        final dataLoaded = initialMessageId == null ? true : snapshot.data![1];
        if (widget.showLoading && (!initialized || !dataLoaded)) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return widget.child;
      },
    );
    if (initialMessageId != null) {
      child = Material(child: child);
    }
    return child;
  }
}
