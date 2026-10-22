import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';
import 'stream_state_scope.dart';

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
typedef ErrorWidgetBuilder =
    Widget Function(
      BuildContext context,
      Object error,
      StackTrace? stackTrace,
    );

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
    this.openAtFirstUnread = true,
    this.errorBuilder = _resolveErrorBuilder,
    this.loadingBuilder = _resolveLoadingBuilder,
  }) : _shouldPosition = true;

  /// Exposes a [channel] to descendants without repositioning the loaded
  /// window on mount.
  ///
  /// Use this when wrapping a channel in a sub-route or overlay for context
  /// access only — e.g. a thread page, channel info screen, long-press
  /// modal, or attachment viewer. The default constructor would otherwise
  /// re-run channel-page positioning and overwrite the parent route's
  /// loaded window.
  ///
  /// See also:
  ///
  ///  * [StreamChannel.new], which initializes the channel and positions it
  ///    on mount.
  const StreamChannel.value({
    super.key,
    required this.child,
    required this.channel,
  }) : showLoading = false,
       initialMessageId = null,
       openAtFirstUnread = true,
       errorBuilder = _resolveErrorBuilder,
       loadingBuilder = _resolveLoadingBuilder,
       _shouldPosition = false;

  /// The child of the widget
  final Widget child;

  /// [channel] specifies the channel with which child should be wrapped
  final Channel channel;

  /// Shows a loading indicator
  final bool showLoading;

  /// If passed the channel will load from this particular message.
  final String? initialMessageId;

  /// Whether the channel should open positioned at the first unread message
  /// when it has pre-existing unread messages.
  ///
  /// Defaults to `true`, preserving the SDK's existing behaviour. Set to
  /// `false` to always open at the latest message instead — the message
  /// list then surfaces pre-existing unread via its unread divider and
  /// jump-to-unread pill rather than by scrolling there automatically.
  ///
  /// Has no effect on [StreamChannel.value], which never repositions the
  /// loaded window.
  ///
  /// Only read once, during channel initialization — changing it after this
  /// widget has mounted does not reposition the current viewport.
  final bool openAtFirstUnread;

  /// Widget builder used while the channel is initialising.
  ///
  /// Defaults to a builder that resolves the nearest
  /// [DefaultStreamChannelBuilders], falling back to a built-in loading
  /// indicator.
  final WidgetBuilder loadingBuilder;

  /// Widget builder used when an error occurs while building the channel.
  ///
  /// Defaults to a builder that resolves the nearest
  /// [DefaultStreamChannelBuilders], falling back to a built-in error widget.
  final ErrorWidgetBuilder errorBuilder;

  // Whether to position the loaded window on mount (initialMessageId,
  // last-read, or latest). Only false for StreamChannel.value.
  final bool _shouldPosition;

  static Widget _resolveLoadingBuilder(BuildContext context) {
    final builder = DefaultStreamChannelBuilders.loadingBuilderOf(context);
    return builder(context);
  }

  static Widget _resolveErrorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    final builder = DefaultStreamChannelBuilders.errorBuilderOf(context);
    return builder(context, error, stackTrace);
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
    return StreamStateScope.maybeOf<StreamChannelState>(context);
  }

  @override
  StreamChannelState createState() => StreamChannelState();
}

// ignore: public_member_api_docs
class StreamChannelState extends State<StreamChannel> {
  // Anything before this is treated as the server's "never read" sentinel
  // (Go's zero `time.Time{}` → `DateTime.utc(1, 1, 1)`).
  static final _minValidLastRead = DateTime.utc(1970, 1, 1);

  /// Current channel
  Channel get channel => widget.channel;

  /// InitialMessageId
  String? get initialMessageId => widget.initialMessageId;

  /// Current channel state stream
  Stream<ChannelState>? get channelStateStream => widget.channel.state?.channelStateStream;

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

    final result = await queryBeforeMessage(
      oldestMessage.id,
      limit: limit,
      preferOffline: preferOffline,
    );

    result.fold(
      onSuccess: (state) {
        final messages = state.messages ?? [];
        final limitNotMatched = messages.length < limit;

        // If we didn't get enough messages before the oldest message, that
        // means there are no more messages before the oldest message.
        if (limitNotMatched) _topPaginationEnded = true;

        _queryTopMessagesController.safeAdd(false);
      },
      onFailure: _queryTopMessagesController.safeAddError,
    );
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

    final result = await queryAfterMessage(
      recentMessage.id,
      limit: limit,
      preferOffline: preferOffline,
    );

    result.fold(
      onSuccess: (state) {
        final messages = state.messages ?? [];
        final limitNotMatched = messages.length < limit;

        // If we didn't get enough messages after the recent message, that
        // means there are no more messages after the recent message.
        if (limitNotMatched) _bottomPaginationEnded = true;

        // Sync the channel upToDate state based on pagination status.
        channel.state?.isUpToDate = _bottomPaginationEnded;

        _queryBottomMessagesController.safeAdd(false);
      },
      onFailure: _queryBottomMessagesController.safeAddError,
    );
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

  /// Drops the oldest messages, keeping at most [maxMessages], and resets
  /// the top-pagination tracker so older messages can be re-fetched.
  ///
  /// Delegates to [ChannelClientState.pruneOldest].
  void pruneOldest(int maxMessages) {
    final state = channel.state;
    if (state == null) return;

    final lengthBefore = state.messages.length;
    state.pruneOldest(maxMessages);
    if (state.messages.length == lengthBefore) return;

    _topPaginationEnded = false;
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

    final result = await channel.getReplies(
      parentId,
      limit: limit,
      idLt: oldestReply.id,
      preferOffline: preferOffline,
    );

    result.fold(
      onSuccess: (response) {
        // If we didn't get enough messages in the response, that means there
        // are no more messages before the oldest reply.
        if (response.messages.length < limit) _topPaginationEnded = true;
        _queryTopMessagesController.safeAdd(false);
      },
      onFailure: _queryTopMessagesController.safeAddError,
    );
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

    final result = await channel.getReplies(
      parentId,
      limit: limit,
      idGt: recentReply.id,
      preferOffline: preferOffline,
    );

    result.fold(
      onSuccess: (response) {
        // If we didn't get enough messages in the response, that means there
        // are no more messages after the recent reply.
        if (response.messages.length < limit) _bottomPaginationEnded = true;
        _queryBottomMessagesController.safeAdd(false);
      },
      onFailure: _queryBottomMessagesController.safeAddError,
    );
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

  /// Fetches the latest replies to the message with the id [parentId].
  ///
  /// Up to [limit] replies are fetched, and the thread's pagination restarts
  /// from them.
  ///
  /// If [preferOffline] is true and the offline storage holds the replies,
  /// those are used instead of fetching them.
  ///
  /// A failure is returned and leaves the pagination as it was. If the channel
  /// is not initialized, nothing is fetched and the result is a success.
  Future<Result<void>> getReplies(
    String parentId, {
    int limit = 30,
    bool preferOffline = false,
  }) async {
    if (channel.state == null) return const Result.success(null);

    final result = await channel.getReplies(
      parentId,
      limit: limit,
      preferOffline: preferOffline,
    );

    return result.onSuccess((response) {
      // We can assume that the bottom pagination is ended as we are querying
      // latest replies, and if we didn't get enough messages, that means there
      // are no more messages to load in the top direction.
      _bottomPaginationEnded = true;
      _topPaginationEnded = response.messages.length < limit;
    });
  }

  /// Loads the next page of the channel's members and watchers.
  ///
  /// Succeeds without loading anything while the channel has no state.
  Future<Result<void>> queryMembersAndWatchers() async {
    final members = channel.state?.members;
    if (members == null) return const Result.success(null);

    final result = await widget.channel.query(
      membersPagination: PaginationParams(
        offset: members.length,
        limit: 100,
      ),
      watchersPagination: PaginationParams(
        offset: members.length,
        limit: 100,
      ),
    );
    return result.map((_) {});
  }

  /// Loads the channel's messages around the message with the id [messageId],
  /// or the latest ones when it is null.
  ///
  /// Succeeds without loading anything while the channel has no state.
  Future<Result<void>> loadChannelAtMessage(
    String? messageId, {
    int limit = 30,
    bool preferOffline = false,
  }) => _queryAtMessage(
    messageId: messageId,
    limit: limit,
    preferOffline: preferOffline,
  );

  /// Loads the channel's messages around [timestamp].
  ///
  /// Succeeds without loading anything while the channel has no state.
  Future<Result<void>> loadChannelAtTimestamp(
    DateTime timestamp, {
    int limit = 30,
    bool preferOffline = false,
  }) => _queryAtTimestamp(
    timestamp: timestamp,
    limit: limit,
    preferOffline: preferOffline,
  );

  // If we are jumping to a message we can determine if we loaded the oldest
  // page or the newest page, depending on where the aroundMessageId is located.
  ({
    bool endOfPrependReached,
    bool endOfAppendReached,
  })
  _inferBoundariesFromAnchorId(
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

  Future<Result<void>> _queryAtMessage({
    String? messageId,
    int limit = 30,
    bool preferOffline = false,
  }) async {
    if (channel.state == null) return const Result.success(null);
    channel.state?.isUpToDate = false;

    final pagination = PaginationParams(
      limit: limit,
      idAround: messageId,
    );

    final result = await channel.query(
      preferOffline: preferOffline,
      messagesPagination: pagination,
    );
    final ChannelState state;
    switch (result) {
      case Success(:final data):
        state = data.channelState;
      case final Failure failure:
        return failure;
    }

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

      return const Result.success(null);
    }

    // If the end of the pagination is not reached, we can infer if there are
    // more messages before or after the messageId based on the position
    // of the messageId in the loaded messages.
    final bound = _inferBoundariesFromAnchorId(messageId, messages);

    _topPaginationEnded = bound.endOfPrependReached;
    _bottomPaginationEnded = bound.endOfAppendReached;
    channel.state?.isUpToDate = _bottomPaginationEnded;

    return const Result.success(null);
  }

  // If we are jumping to a message we can determine if we loaded the oldest
  // page or the newest page, depending on where the aroundMessageId is located.
  ({
    bool endOfPrependReached,
    bool endOfAppendReached,
  })
  _inferBoundariesFromAnchorTimestamp(
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
      final messageTimestamps = loadedMessages
          .map((it) {
            return it.createdAt.millisecondsSinceEpoch;
          })
          .toList(growable: false);

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

  Future<Result<void>> _queryAtTimestamp({
    required DateTime timestamp,
    int limit = 30,
    bool preferOffline = false,
  }) async {
    if (channel.state == null) return const Result.success(null);
    channel.state?.isUpToDate = false;

    final pagination = PaginationParams(
      limit: limit,
      createdAtAround: timestamp.toUtc(),
    );

    final result = await channel.query(
      preferOffline: preferOffline,
      messagesPagination: pagination,
    );

    final ChannelState state;
    switch (result) {
      case Success(:final data):
        state = data.channelState;
      case final Failure failure:
        return failure;
    }

    final messages = state.messages ?? [];
    final limitNotMatched = messages.length < pagination.limit;

    // If we didn't get enough messages, that means there are no more
    // messages around that timestamp.
    if (limitNotMatched) {
      _topPaginationEnded = true;
      _bottomPaginationEnded = true;
      channel.state?.isUpToDate = _bottomPaginationEnded;

      return const Result.success(null);
    }

    // If the end of the pagination is not reached, we can infer if there are
    // more messages before or after the messageId based on the position
    // of the timestamp in the loaded messages.
    final bound = _inferBoundariesFromAnchorTimestamp(timestamp, messages);

    _topPaginationEnded = bound.endOfPrependReached;
    _bottomPaginationEnded = bound.endOfAppendReached;
    channel.state?.isUpToDate = _bottomPaginationEnded;

    return const Result.success(null);
  }

  /// Loads up to [limit] of the channel's messages before the message with
  /// the id [messageId].
  ///
  /// If [preferOffline] is true and the offline storage holds them, those are
  /// used instead of fetching them.
  Future<Result<ChannelState>> queryBeforeMessage(
    String messageId, {
    int limit = 30,
    bool preferOffline = false,
  }) async {
    final pagination = PaginationParams(
      limit: limit,
      lessThan: messageId,
    );

    final result = await channel.query(
      preferOffline: preferOffline,
      messagesPagination: pagination,
    );
    return result.map((response) => response.channelState);
  }

  /// Loads up to [limit] of the channel's messages after the message with the
  /// id [messageId].
  ///
  /// If [preferOffline] is true and the offline storage holds them, those are
  /// used instead of fetching them.
  Future<Result<ChannelState>> queryAfterMessage(
    String messageId, {
    int limit = 30,
    bool preferOffline = false,
  }) async {
    final pagination = PaginationParams(
      limit: limit,
      greaterThan: messageId,
    );

    final result = await channel.query(
      preferOffline: preferOffline,
      messagesPagination: pagination,
    );
    return result.map((response) => response.channelState);
  }

  /// Returns the message with the id [messageId].
  ///
  /// It comes from the channel state when it is loaded there, and is fetched
  /// otherwise. The result is a failure if fetching it fails or the message
  /// does not exist.
  Future<Result<Message>> getMessage(String messageId) async {
    if (_findCachedMessage(messageId) case final cached?) return Result.success(cached);

    final result = await channel.getManyMessages([messageId]);
    return result.flatMap(
      (response) => switch (response.messages.firstWhereOrNull((it) => it.id == messageId)) {
        final message? => Result.success(message),
        null => Result.failure(StreamClientException(message: 'Message "$messageId" not found')),
      },
    );
  }

  // Scans cached locations in decreasing hit-likelihood, returning on the
  // first match. Plain for-loops over `firstWhereOrNull`/`expand` to avoid
  // per-call closure and iterable allocations.
  Message? _findCachedMessage(String messageId) {
    final state = channel.state;
    if (state == null) return null;

    // Hot path: regular channel messages in the loaded window.
    for (final message in state.messages) {
      if (message.id == messageId) return message;
    }

    // Thread replies — only helps when `messageId` is itself a reply; thread
    // parents live in `state.messages`, not under `state.threads`.
    for (final replies in state.threads.values) {
      for (final message in replies) {
        if (message.id == messageId) return message;
      }
    }

    // Pinned messages can sit outside the loaded window, so check them last.
    for (final message in state.pinnedMessages) {
      if (message.id == messageId) return message;
    }

    return null;
  }

  /// Fetches one page of the channel's members that match [filter], ordered
  /// by [sort].
  ///
  /// The page holds up to [PaginationParams.limit] members after skipping
  /// [PaginationParams.offset], bounded by its `createdAt` dates.
  Future<Result<List<Member>>> queryMembers({
    MemberFilter? filter,
    List<MemberSort>? sort,
    PaginationParams? pagination,
  }) async {
    final result = await channel.queryMembers(
      filter: filter,
      sort: sort,
      pagination: pagination,
    );
    return result.map((response) => response.members);
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
    final lastReadIndex = messages.lastIndexWhere(
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

  /// Reloads the channel with latest messages, replacing the loaded window.
  Future<Result<void>> reloadChannel() {
    channel.state?.truncate();
    return _queryAtMessage();
  }

  /// Retries initializing the channel after a failure.
  ///
  /// Re-runs the channel initialization and rebuilds so a previously failed
  /// load (e.g. due to a network error) can recover. This is the retry action
  /// to wire into [StreamChannel.errorBuilder].
  void retry() {
    if (!mounted) return;
    setState(_initializeChannel); // Rebuild to show the loading state again.
  }

  void _initializeChannel() {
    // Order matters: `_maybeInitChannel()` triggers the (re)query that resets
    // `channel.initialized` after a failed init, so it must run before
    // `channel.initialized` is read here — otherwise a retry would await the
    // stale, already-errored completer.
    //
    // `..ignore()` avoids an unhandled error if the future fails before the
    // FutureBuilder resubscribes (e.g. on retry's deferred rebuild).
    _channelInitFuture = Future.wait([_maybeInitChannel(), channel.initialized])..ignore();
  }

  // Initializes the channel and positions it. The init future feeds a
  // FutureBuilder, so a failure fails it.
  Future<void> _maybeInitChannel() async {
    if (await _initChannel() case Failure(:final error, :final stackTrace)) {
      Error.throwWithStackTrace(error, stackTrace ?? StackTrace.current);
    }
  }

  Future<Result<void>> _initChannel() async {
    // If the channel doesn't have an CID yet, it hasn't been created on the
    // server so we don't need to initialize it.
    if (channel.cid == null) return const Result.success(null);

    // Otherwise, we first initialize the channel if it's not yet initialized.
    if (channel.state == null) {
      if (await channel.watch() case final Failure failure) return failure;
    }

    // If the widget was created using the StreamChannel.value constructor,
    // we skip positioning so the already-loaded channel state is kept intact.
    if (!widget._shouldPosition) return const Result.success(null);

    // First we try to load the channel at the initial message if
    // 'initialMessageId' is provided in the widget.
    if (widget.initialMessageId case final initialMessageId?) {
      return loadChannelAtMessage(initialMessageId);
    }

    // Otherwise, we should load the channel at the first unread message if
    // available — unless the caller opted out via
    // [StreamChannel.openAtFirstUnread], in which case we fall through to
    // load-latest below.
    if (widget.openAtFirstUnread) {
      if (channel.state case final state? when state.unreadCount > 0) {
        final currentUserRead = state.currentUserRead;

        // Skip if we don't have read state for the current user.
        if (currentUserRead == null) return const Result.success(null);

        // Load the channel at the last read message if available.
        if (currentUserRead.lastReadMessageId case final lastReadMessageId?) {
          final result = await loadChannelAtMessage(lastReadMessageId);
          if (result case Success()) return result;

          // If the loadChannelAtMessage for any reason fails, we fallback to
          // loading the channel at the last read date.
          //
          // One example of this is when the channel becomes too large and
          // exceeds a certain threshold (I believe it's a 1000 members) it
          // can't update the readstate anymore for each individual member.
        }

        // Skip the "never read" sentinel: the server ignores it as
        // `created_at_around` and returns the tail, which would mis-infer
        // `_topPaginationEnded = true`. Fall through to load-latest below.
        if (currentUserRead.lastRead.isAfter(_minValidLastRead)) {
          return loadChannelAtTimestamp(currentUserRead.lastRead);
        }
      }
    }

    // If nothing above applies, we just load the channel at the latest
    // messages if we are not already at the latest messages.
    if (channel.state?.isUpToDate == false) return loadChannelAtMessage(null);

    return const Result.success(null);
  }

  late Future<List<void>> _channelInitFuture;

  @override
  void initState() {
    super.initState();
    _initializeChannel();
  }

  @override
  void didUpdateWidget(StreamChannel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.channel.cid != widget.channel.cid || oldWidget.initialMessageId != widget.initialMessageId) {
      // Re-initialize channel if the channel CID or initial message ID changes.
      _initializeChannel();
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
    return StreamStateScope(
      state: this,
      child: FutureBuilder<void>(
        future: _channelInitFuture,
        builder: (context, snapshot) {
          // Gate the error on `done`: the snapshot keeps the stale error across
          // a retry, so checking it first would hide the loading state.
          if (snapshot.connectionState != ConnectionState.done) {
            if (widget.showLoading) return widget.loadingBuilder(context);
            return widget.child; // return child directly if loading is disabled
          }

          if (snapshot.hasError) {
            final error = snapshot.error!;
            final stackTrace = snapshot.stackTrace;
            return widget.errorBuilder(context, error, stackTrace);
          }

          return widget.child;
        },
      ),
    );
  }
}

/// Provides default builders to descendant [StreamChannel]s that don't
/// specify their own [StreamChannel.loadingBuilder] / [StreamChannel.errorBuilder].
///
/// Lets a higher layer (e.g. `stream_chat_flutter`'s `StreamChat`) supply
/// themed, localized loading and error states for every [StreamChannel]
/// beneath it, without each call site passing them.
class DefaultStreamChannelBuilders extends InheritedWidget {
  /// Creates a new instance of [DefaultStreamChannelBuilders].
  const DefaultStreamChannelBuilders({
    super.key,
    this.loadingBuilder,
    this.errorBuilder,
    required super.child,
  });

  /// Default builder for the channel-initializing state.
  final WidgetBuilder? loadingBuilder;

  /// Default builder for the channel-initialization error state.
  final ErrorWidgetBuilder? errorBuilder;

  /// Resolves the loading builder from the closest [DefaultStreamChannelBuilders]
  /// above [context], falling back to the built-in loading indicator.
  static WidgetBuilder loadingBuilderOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DefaultStreamChannelBuilders>();
    return scope?.loadingBuilder ?? _defaultLoadingBuilder;
  }

  /// Resolves the error builder from the closest [DefaultStreamChannelBuilders]
  /// above [context], falling back to the built-in error widget.
  static ErrorWidgetBuilder errorBuilderOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DefaultStreamChannelBuilders>();
    return scope?.errorBuilder ?? _defaultErrorBuilder;
  }

  @override
  bool updateShouldNotify(DefaultStreamChannelBuilders oldWidget) {
    return loadingBuilder != oldWidget.loadingBuilder || errorBuilder != oldWidget.errorBuilder;
  }

  static Color _getDefaultBackgroundColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return switch (brightness) {
      Brightness.light => const Color(0xfff7f7f8),
      Brightness.dark => const Color(0xff000000),
    };
  }

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

    // Raw, unlocalized fallback: this core widget has no design system or
    // translations, so copy/styling are hardcoded. Apps can override with
    // [StreamChannel.errorBuilder] for a themed, localized state.
    final (title, message) = switch (error) {
      StreamNetworkException(isTimeout: true) => (
        'Slow Internet Connection',
        'There seems to be a problem with your internet connection',
      ),
      StreamNetworkException() => (
        'No Internet Connection',
        'Please check your internet connection',
      ),
      _ => ('Error', 'Oops, something went wrong'),
    };

    return Material(
      color: backgroundColor,
      child: Center(
        child: Padding(
          padding: const .symmetric(horizontal: 16, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: .w600),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => StreamChannel.maybeOf(context)?.retry(),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
