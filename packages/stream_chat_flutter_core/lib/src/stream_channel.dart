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

    Object? unwrapParallelError(Object error) {
      if (error case ParallelWaitError(:final List<AsyncError?> errors)) {
        return errors.firstWhereOrNull((it) => it != null)?.error;
      }

      return error;
    }

    final exception = unwrapParallelError(error);
    return Material(
      color: backgroundColor,
      child: Center(
        child: switch (exception) {
          DioException(type: DioExceptionType.badResponse) =>
            Text(exception.message ?? 'Bad response'),
          DioException() => const Text('Check your connection and retry'),
          _ => Text(exception.toString()),
        },
      ),
    );
  }

  /// Finds the [StreamChannelState] from the closest [StreamChannel] ancestor
  /// that encloses the given [context].
  ///
  /// This will throw a [FlutterError] if no [StreamChannel] is found in the
  /// widget tree above the given context.
  ///
  /// Typical usage:
  ///
  /// ```dart
  /// final channelState = StreamChannel.of(context);
  /// ```
  ///
  /// If you're calling this in the same `build()` method that creates the
  /// `StreamChannel`, consider using a `Builder` or refactoring into a separate
  /// widget to obtain a context below the [StreamChannel].
  ///
  /// If you want to return null instead of throwing, use [maybeOf].
  static StreamChannelState of(BuildContext context) {
    final result = maybeOf(context);
    if (result != null) return result;

    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'StreamChannel.of() called with a context that does not contain a '
        'StreamChannel.',
      ),
      ErrorDescription(
        'No StreamChannel ancestor could be found starting from the context '
        'that was passed to StreamChannel.of(). This usually happens when the '
        'context used comes from the widget that creates the StreamChannel '
        'itself.',
      ),
      ErrorHint(
        'To fix this, ensure that you are using a context that is a descendant '
        'of the StreamChannel. You can use a Builder to get a new context that '
        'is under the StreamChannel:\n\n'
        '  Builder(\n'
        '    builder: (context) {\n'
        '      final channelState = StreamChannel.of(context);\n'
        '      ...\n'
        '    },\n'
        '  )',
      ),
      ErrorHint(
        'Alternatively, split your build method into smaller widgets so that '
        'you get a new BuildContext that is below the StreamChannel in the '
        'widget tree.',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  /// Finds the [StreamChannelState] from the closest [StreamChannel] ancestor
  /// that encloses the given context.
  ///
  /// Returns null if no such ancestor exists.
  ///
  /// See also:
  ///  * [of], which throws if no [StreamChannel] is found.
  static StreamChannelState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<StreamChannelState>();
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
    int limit = 30,
    bool preferOffline = false,
  }) async {
    if (channel.state == null) return;
    if (_topPaginationEnded) return;
    if (_queryTopMessagesController.value) return;

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

      final messages = state.messages ?? [];
      final limitNotMatched = messages.length < limit;

      // If we didn't get enough messages before the oldest message, that means
      // there are no more messages before the oldest message.
      if (limitNotMatched) _topPaginationEnded = true;

      _queryTopMessagesController.safeAdd(false);
    } catch (e, stk) {
      _queryTopMessagesController.safeAddError(e, stk);
    }
  }

  Future<void> _queryBottomMessages({
    int limit = 30,
    bool preferOffline = false,
  }) async {
    if (channel.state == null) return;
    if (_bottomPaginationEnded) return;
    if (_queryBottomMessagesController.value) return;

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

      final messages = state.messages ?? [];
      final limitNotMatched = messages.length < limit;

      // If we didn't get enough messages after the recent message, that means
      // there are no more messages after the recent message.
      if (limitNotMatched) _bottomPaginationEnded = true;

      // Sync the channel upToDate state based on pagination status.
      channel.state?.isUpToDate = _bottomPaginationEnded;

      _queryBottomMessagesController.safeAdd(false);
    } catch (e, stk) {
      _queryBottomMessagesController.safeAddError(e, stk);
    }
  }

  /// Calls [channel.query] updating [queryMessage] stream
  Future<void> queryMessages({
    QueryDirection? direction = QueryDirection.top,
    int limit = 30,
  }) {
    if (direction == QueryDirection.top) {
      return _queryTopMessages(limit: limit);
    }
    return _queryBottomMessages(limit: limit);
  }

  Future<void> _queryTopReplies(
    String parentId, {
    int limit = 30,
    bool preferOffline = false,
  }) async {
    if (channel.state == null) return;
    if (_topPaginationEnded) return;
    if (_queryTopMessagesController.value) return;

    _queryTopMessagesController.safeAdd(true);

    final threadReplies = channel.state!.threads[parentId];
    if (threadReplies == null || threadReplies.isEmpty) {
      return _queryTopMessagesController.safeAdd(false);
    }

    final oldestReply = threadReplies.first;

    try {
      final pagination = PaginationParams(
        limit: limit,
        lessThan: oldestReply.id,
      );

      final response = await channel.getReplies(
        parentId,
        options: pagination,
        preferOffline: preferOffline,
      );

      final messages = response.messages;
      final limitNotMatched = messages.length < pagination.limit;

      // If we didn't get enough messages in the response, that means there are
      // no more messages before the oldest reply.
      if (limitNotMatched) _topPaginationEnded = true;

      _queryTopMessagesController.safeAdd(false);
    } catch (e, stk) {
      _queryTopMessagesController.safeAddError(e, stk);
    }
  }

  Future<void> _queryBottomReplies(
    String parentId, {
    int limit = 30,
    bool preferOffline = false,
  }) async {
    if (channel.state == null) return;
    if (_bottomPaginationEnded) return;
    if (_queryBottomMessagesController.value) return;

    _queryBottomMessagesController.safeAdd(true);

    final threadReplies = channel.state!.threads[parentId];
    if (threadReplies == null || threadReplies.isEmpty) {
      return _queryBottomMessagesController.safeAdd(false);
    }

    final recentReply = threadReplies.last;

    try {
      final pagination = PaginationParams(
        limit: limit,
        greaterThan: recentReply.id,
      );

      final response = await channel.getReplies(
        parentId,
        options: pagination,
        preferOffline: preferOffline,
      );

      final messages = response.messages;
      final limitNotMatched = messages.length < pagination.limit;

      // If we didn't get enough messages in the response, that means there are
      // no more messages after the recent reply.
      if (limitNotMatched) _bottomPaginationEnded = true;

      _queryBottomMessagesController.safeAdd(false);
    } catch (e, stk) {
      _queryBottomMessagesController.safeAddError(e, stk);
    }
  }

  /// Calls [channel.getReplies] updating [queryMessage] stream
  Future<void> queryReplies(
    String parentId, {
    int limit = 30,
    QueryDirection direction = QueryDirection.top,
  }) async {
    if (direction == QueryDirection.top) {
      return _queryTopReplies(parentId, limit: limit);
    }
    return _queryBottomReplies(parentId, limit: limit);
  }

  /// Calls [channel.getReplies] updating [queryMessage] stream
  Future<void> getReplies(
    String parentId, {
    int limit = 30,
    bool preferOffline = false,
  }) async {
    if (channel.state == null) return;

    final pagination = PaginationParams(limit: limit);

    final response = await channel.getReplies(
      parentId,
      options: pagination,
      preferOffline: preferOffline,
    );

    final messages = response.messages;
    final limitNotMatched = messages.length < pagination.limit;

    // We can assume that the bottom pagination is ended as we are querying
    // latest replies, and if we didn't get enough messages, that means
    // there are no more messages to load in the top direction.
    _bottomPaginationEnded = true;
    _topPaginationEnded = limitNotMatched;
  }

  /// Query the channel members and watchers
  Future<void> queryMembersAndWatchers() async {
    final members = channel.state?.members;
    if (members == null) return;

    await widget.channel.query(
      membersPagination: PaginationParams(
        offset: members.length,
        limit: 100,
      ),
      watchersPagination: PaginationParams(
        offset: members.length,
        limit: 100,
      ),
    );
  }

  /// Loads channel at specific message
  Future<void> loadChannelAtMessage(
    String? messageId, {
    int limit = 30,
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
    int limit = 30,
    bool preferOffline = false,
  }) =>
      _queryAtTimestamp(
        timestamp: timestamp,
        limit: limit,
        preferOffline: preferOffline,
      );

  // If we are jumping to a message we can determine if we loaded the oldest
  // page or the newest page, depending on where the aroundMessageId is located.
  ({
    bool endOfPrependReached,
    bool endOfAppendReached,
  }) _inferBoundariesFromAnchorId(
    String anchorId,
    List<Message> loadedMessages,
  ) {
    // If the loaded messages are empty, we assume we have loaded all messages.
    if (loadedMessages.isEmpty) {
      return (endOfPrependReached: true, endOfAppendReached: true);
    }

    final midIndex = loadedMessages.length ~/ 2;
    final midMessage = loadedMessages[midIndex];

    // If the midMessage is the anchor message, it means there are still
    // messages before and after it.
    if (midMessage.id == anchorId) {
      return (endOfPrependReached: false, endOfAppendReached: false);
    }

    final firstHalf = loadedMessages.sublist(0, midIndex);
    final secondHalf = loadedMessages.sublist(midIndex + 1);

    // If the anchor message is in the first half of the loaded messages,
    // it means we have loaded the oldest page.
    if (firstHalf.any((m) => m.id == anchorId)) {
      return (endOfPrependReached: true, endOfAppendReached: false);
    }

    // If the anchor message is in the second half of the loaded messages,
    // it means we have loaded the latest page.
    if (secondHalf.any((m) => m.id == anchorId)) {
      return (endOfPrependReached: false, endOfAppendReached: true);
    }

    // If we reach here, it means the anchor message is not in the loaded
    // messages, which can happen if the message is part of a thread.
    return (endOfPrependReached: true, endOfAppendReached: true);
  }

  Future<ChannelState?> _queryAtMessage({
    String? messageId,
    int limit = 30,
    bool preferOffline = false,
  }) async {
    if (channel.state == null) return null;
    channel.state?.isUpToDate = false;

    final pagination = PaginationParams(
      limit: limit,
      idAround: messageId,
    );

    final state = await channel.query(
      preferOffline: preferOffline,
      messagesPagination: pagination,
    );

    final messages = state.messages ?? [];
    final limitNotMatched = messages.length < pagination.limit;

    // If the messageId is null, it means we are loading the latest messages
    // therefore we can assume that the bottom pagination is ended, and if we
    // didn't get enough messages, that means there are no more messages
    // to load in the top direction.
    if (messageId == null || limitNotMatched) {
      _bottomPaginationEnded = true;
      channel.state?.isUpToDate = _bottomPaginationEnded;
      _topPaginationEnded = limitNotMatched;

      return state;
    }

    // If the end of the pagination is not reached, we can infer if there are
    // more messages before or after the messageId based on the position
    // of the messageId in the loaded messages.
    final bound = _inferBoundariesFromAnchorId(messageId, messages);

    _topPaginationEnded = bound.endOfPrependReached;
    _bottomPaginationEnded = bound.endOfAppendReached;
    channel.state?.isUpToDate = _bottomPaginationEnded;

    return state;
  }

  // If we are jumping to a message we can determine if we loaded the oldest
  // page or the newest page, depending on where the aroundMessageId is located.
  ({
    bool endOfPrependReached,
    bool endOfAppendReached,
  }) _inferBoundariesFromAnchorTimestamp(
    DateTime anchorTimestamp,
    List<Message> loadedMessages,
  ) {
    // If the loaded messages are empty, we assume we have loaded all messages.
    if (loadedMessages.isEmpty) {
      return (endOfPrependReached: true, endOfAppendReached: true);
    }

    final [firstMessage, ..., lastMessage] = loadedMessages;

    if (anchorTimestamp.isBefore(firstMessage.createdAt)) {
      // The anchor is before the first message — no more messages to PREPEND
      return (endOfPrependReached: true, endOfAppendReached: false);
    }

    if (anchorTimestamp.isAfter(lastMessage.createdAt)) {
      // The anchor is after the last message — no more messages to APPEND
      return (endOfPrependReached: false, endOfAppendReached: true);
    }

    int anchorPositionIndex(
      DateTime anchorTimestamp,
      List<Message> loadedMessages,
    ) {
      final messageTimestamps = loadedMessages.map((it) {
        return it.createdAt.millisecondsSinceEpoch;
      }).toList(growable: false);

      return messageTimestamps.lowerBoundBy<num>(
        anchorTimestamp.millisecondsSinceEpoch,
        (messageCreatedAt) => messageCreatedAt,
      );
    }

    final midIndex = loadedMessages.length ~/ 2;
    final anchorIndex = anchorPositionIndex(anchorTimestamp, loadedMessages);

    return (
      endOfPrependReached: midIndex > anchorIndex,
      endOfAppendReached: midIndex < anchorIndex,
    );
  }

  Future<ChannelState?> _queryAtTimestamp({
    required DateTime timestamp,
    int limit = 30,
    bool preferOffline = false,
  }) async {
    if (channel.state == null) return null;
    channel.state?.isUpToDate = false;

    final pagination = PaginationParams(
      limit: limit,
      createdAtAround: timestamp.toUtc(),
    );

    final state = await channel.query(
      preferOffline: preferOffline,
      messagesPagination: pagination,
    );

    final messages = state.messages ?? [];
    final limitNotMatched = messages.length < pagination.limit;

    // If we didn't get enough messages, that means there are no more
    // messages around that timestamp.
    if (limitNotMatched) {
      _topPaginationEnded = true;
      _bottomPaginationEnded = true;
      channel.state?.isUpToDate = _bottomPaginationEnded;

      return state;
    }

    // If the end of the pagination is not reached, we can infer if there are
    // more messages before or after the messageId based on the position
    // of the timestamp in the loaded messages.
    final bound = _inferBoundariesFromAnchorTimestamp(timestamp, messages);

    _topPaginationEnded = bound.endOfPrependReached;
    _bottomPaginationEnded = bound.endOfAppendReached;
    channel.state?.isUpToDate = _bottomPaginationEnded;

    return state;
  }

  ///
  Future<ChannelState> queryBeforeMessage(
    String messageId, {
    int limit = 30,
    bool preferOffline = false,
  }) {
    final pagination = PaginationParams(
      limit: limit,
      lessThan: messageId,
    );

    return channel.query(
      preferOffline: preferOffline,
      messagesPagination: pagination,
    );
  }

  ///
  Future<ChannelState> queryAfterMessage(
    String messageId, {
    int limit = 30,
    bool preferOffline = false,
  }) {
    final pagination = PaginationParams(
      limit: limit,
      greaterThan: messageId,
    );

    return channel.query(
      preferOffline: preferOffline,
      messagesPagination: pagination,
    );
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

  /// Returns the first unread message for the current user in the channel.
  ///
  /// This method determines which message should be considered as the first
  /// unread message based on the user's read state.
  ///
  /// Returns null if:
  /// - The current user's read state is null
  /// - The channel has no unread messages
  /// - The last read message is the most recent message in the channel
  /// - The last read message can't be found in the current message list
  ///
  /// If there's no last read message ID (all messages are unread), it returns
  /// the oldest regular message when pagination is complete.
  Message? getFirstUnreadMessage([Read? currentUserRead]) {
    final messages = channel.state?.messages;
    if (messages == null || messages.isEmpty) return null;

    Message? getOldestRegularMessage() {
      // Only return a message if we've loaded all previous messages.
      if (!_topPaginationEnded) return null;

      return messages.firstWhereOrNull(
        (it) => it.type == MessageType.regular || it.type == MessageType.reply,
      );
    }

    final userRead = currentUserRead ?? channel.state?.currentUserRead;

    // No read state available, consider oldest message as unread.
    if (userRead == null) {
      return getOldestRegularMessage();
    }

    // No unread messages.
    if (userRead.unreadMessages <= 0) {
      return null;
    }

    final lastReadMessageId = userRead.lastReadMessageId;
    // No last read message ID, consider all messages unread.
    if (lastReadMessageId == null) {
      return getOldestRegularMessage();
    }

    // If the last read message is the last message in the channel, there are no
    // unread messages
    if (lastReadMessageId == messages.lastOrNull?.id) {
      return null;
    }

    // Find the index of the last read message
    final lastReadIndex = messages.indexWhere(
      (message) => message.id == lastReadMessageId,
    );

    if (lastReadIndex == -1) {
      // If there is a lastReadMessageId, and we loaded all messages, but can't
      // find firstUnreadMessageId, then it means the lastReadMessageId is not
      // reachable because the channel was truncated or hidden. So we return the
      // oldest regular message already fetched.
      return getOldestRegularMessage();
    }

    // Return the first valid unread message after the last read message
    // Skip messages from the current user and deleted messages
    return messages.sublist(lastReadIndex + 1).firstWhereOrNull((message) {
      // Skip deleted messages
      if (message.isDeleted) return false;
      // Skip messages from the current user
      if (message.user?.id == userRead.user.id) return false;

      return true;
    });
  }

  /// Reloads the channel with latest message
  Future<void> reloadChannel() => _queryAtMessage();

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
      final currentUserRead = state.currentUserRead;

      // Skip if we don't have read state for the current user.
      if (currentUserRead == null) return;

      // Load the channel at the last read message if available.
      if (currentUserRead.lastReadMessageId case final lastReadMessageId?) {
        try {
          return await loadChannelAtMessage(lastReadMessageId);
        } catch (e) {
          // If the loadChannelAtMessage for any reason fails, we fallback to
          // loading the channel at the last read date.
          //
          // One example of this is when the channel becomes too large and
          // exceeds a certain threshold (I believe it's a 1000 members) it
          // can't update the readstate anymore for each individual member.
        }
      }

      // Otherwise, load the channel at the last read date.
      return loadChannelAtTimestamp(currentUserRead.lastRead);
    }

    // If nothing above applies, we just load the channel at the latest
    // messages if we are not already at the latest messages.
    if (channel.state?.isUpToDate == false) return loadChannelAtMessage(null);
  }

  late Future<List<void>> _channelInitFuture;

  @override
  void initState() {
    super.initState();
    _channelInitFuture = [_maybeInitChannel(), channel.initialized].wait;
  }

  @override
  void didUpdateWidget(StreamChannel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.channel.cid != widget.channel.cid ||
        oldWidget.initialMessageId != widget.initialMessageId) {
      // Re-initialize channel if the channel CID or initial message ID changes.
      _channelInitFuture = [_maybeInitChannel(), channel.initialized].wait;
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
