import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';

/// Specifies query direction for pagination
enum QueryDirection {
  /// Query earlier messages
  top,

  /// Query later messages
  bottom,
}

/// Signature used by [StreamChannel.errorBuilder] to create a replacement
/// widget for an error that occurs while asynchronously building the channel.
// TODO: Remove once ErrorBuilder supports passing stacktrace.
typedef ErrorWidgetBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
);

Color _getDefaultBackgroundColor(BuildContext context) {
  final brightness = Theme.of(context).brightness;
  return switch (brightness) {
    Brightness.light => const Color(0xfff7f7f8),
    Brightness.dark => const Color(0xff000000),
  };
}

/// Widget used to provide information about the channel to the widget tree
///
/// Use [StreamChannel.of] to get the current [StreamChannelState] instance.
class StreamChannel extends StatefulWidget {
  /// Creates a new instance of [StreamChannel]. Both [child] and [channel] must
  /// be supplied and not null.
  const StreamChannel({
    super.key,
    required this.child,
    required this.channel,
    this.showLoading = true,
    this.initialMessageId,
    this.errorBuilder = _defaultErrorBuilder,
    this.loadingBuilder = _defaultLoadingBuilder,
  });

  /// The child of the widget
  final Widget child;

  /// [channel] specifies the channel with which child should be wrapped
  final Channel channel;

  /// Shows a loading indicator
  final bool showLoading;

  /// If passed the channel will load from this particular message.
  final String? initialMessageId;

  /// Widget builder used in case the channel is initialising.
  final WidgetBuilder loadingBuilder;

  /// Widget builder used in case an error occurs while building the channel.
  final ErrorWidgetBuilder errorBuilder;

  static Widget _defaultLoadingBuilder(BuildContext context) {
    final backgroundColor = _getDefaultBackgroundColor(context);
    return Material(
      color: backgroundColor,
      child: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  static Widget _defaultErrorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    final backgroundColor = _getDefaultBackgroundColor(context);
    return Material(
      color: backgroundColor,
      child: Center(
        child: switch (error) {
          DioException(type: DioExceptionType.badResponse) =>
            Text(error.message ?? 'Bad response'),
          DioException() => const Text('Check your connection and retry'),
          _ => Text(error.toString()),
        },
      ),
    );
  }

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
        channel.state!.isUpToDate) {
      return;
    }
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
        channel.state == null) {
      return;
    }
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
    int limit = 20,
    bool preferOffline = false,
  }) =>
      _queryAtMessage(
        messageId: messageId,
        limit: limit,
        preferOffline: preferOffline,
      );

  /// Loads channel at specific message
  Future<void> loadChannelAtTimestamp(
    DateTime timestamp, {
    int limit = 40,
    bool preferOffline = false,
  }) =>
      _queryAtTimestamp(
        timestamp: timestamp,
        limit: limit,
        preferOffline: preferOffline,
      );

  Future<ChannelState?> _queryAtMessage({
    String? messageId,
    int limit = 40,
    bool preferOffline = false,
  }) async {
    if (channel.state == null) return null;
    channel.state!.isUpToDate = false;
    channel.state!.truncate();

    if (messageId == null) {
      final state = await channel.query(
        messagesPagination: PaginationParams(
          limit: limit,
        ),
        preferOffline: preferOffline,
      );
      channel.state!.isUpToDate = true;
      return state;
    }

    return channel.query(
      messagesPagination: PaginationParams(
        idAround: messageId,
        limit: limit,
      ),
      preferOffline: preferOffline,
    );
  }

  Future<ChannelState?> _queryAtTimestamp({
    required DateTime timestamp,
    int limit = 40,
    bool preferOffline = false,
  }) async {
    if (channel.state == null) return null;
    channel.state!.isUpToDate = false;
    channel.state!.truncate();

    return channel.query(
      messagesPagination: PaginationParams(
        createdAtAround: timestamp.toUtc(),
        limit: limit,
      ),
      preferOffline: preferOffline,
    );
  }

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
    SortOrder<Member>? sort,
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

  Future<void> _maybeInitChannel() async {
    // If the channel doesn't have an CID yet, it hasn't been created on the
    // server so we don't need to initialize it.
    if (channel.cid == null) return;

    // Otherwise, we first initialize the channel if it's not yet initialized.
    if (channel.state == null) await channel.watch();

    // First we try to load the channel at the initial message if
    // 'initialMessageId' is provided in the widget.
    if (widget.initialMessageId case final initialMessageId?) {
      return loadChannelAtMessage(initialMessageId);
    }

    // Otherwise, we should load the channel at the first unread
    // message if available.
    if (channel.state case final state? when state.unreadCount > 0) {
      final currentUserRead = state.read.firstWhereOrNull(
        (it) => it.user.id == channel.client.state.currentUser?.id,
      );

      // Skip if we don't have read state for the current user.
      if (currentUserRead == null) return;

      // Load the channel at the last read message if available.
      if (currentUserRead.lastReadMessageId case final lastReadMessageId?) {
        return loadChannelAtMessage(lastReadMessageId);
      }

      // Otherwise, load the channel at the last read date.
      return loadChannelAtTimestamp(currentUserRead.lastRead);
    }
  }

  late Future<void> _channelInitFuture;

  @override
  void initState() {
    super.initState();
    _channelInitFuture = _maybeInitChannel();
  }

  @override
  void didUpdateWidget(StreamChannel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.channel.cid != widget.channel.cid ||
        oldWidget.initialMessageId != widget.initialMessageId) {
      // Re-initialize channel if the channel CID or initial message ID changes.
      _channelInitFuture = _maybeInitChannel();
    }
  }

  @override
  void dispose() {
    _queryTopMessagesController.close();
    _queryBottomMessagesController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _channelInitFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error!;
          final stackTrace = snapshot.stackTrace;
          return widget.errorBuilder(context, error, stackTrace);
        }

        if (snapshot.connectionState != ConnectionState.done) {
          if (widget.showLoading) return widget.loadingBuilder(context);
        }

        return widget.child;
      },
    );
  }
}
