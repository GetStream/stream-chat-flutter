import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/better_stream_builder.dart';
import 'package:stream_chat_flutter_core/src/stream_channel.dart';
import 'package:stream_chat_flutter_core/src/typedef.dart';

/// Default filter for the message list
bool Function(Message) defaultMessageFilter([
  String? currentUserId,
]) {
  return (Message m) {
    final isMyMessage = currentUserId != null && m.user?.id == currentUserId;
    if (m.shadowed && !isMyMessage) return false;
    return true;
  };
}

/// [MessageListCore] is a simplified class that allows fetching a list of
/// messages while exposing UI builders.
///
/// A [MessageListController] is used to paginate data.
///
/// ```dart
/// class ChannelPage extends StatelessWidget {
///   const ChannelPage({
///     Key key,
///   }) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Column(
///         children: <Widget>[
///           Expanded(
///             child: MessageListCore(
///         emptyBuilder: (context) {
///           return Center(
///             child: Text('Nothing here...'),
///           );
///         },
///         loadingBuilder: (context) {
///           return Center(
///             child: CircularProgressIndicator.adaptive(),
///           );
///         },
///         messageListBuilder: (context, list) {
///           return MessagesPage(list);
///         },
///         errorBuilder: (context, err) {
///           return Center(
///             child: Text('Error'),
///           );
///         },
///             ),
///           ),
///         ],
///       ),
///     );
///   }
/// }
/// ```
///
///
/// Make sure to have a [StreamChannel] ancestor in order to provide the
/// information about the channels.
///
/// The widget uses a [ListView.custom] to render the list of channels.
///
class MessageListCore extends StatefulWidget {
  /// Instantiate a new [MessageListView].
  const MessageListCore({
    super.key,
    required this.loadingBuilder,
    required this.emptyBuilder,
    required this.messageListBuilder,
    required this.errorBuilder,
    this.parentMessage,
    this.messageListController,
    this.messageFilter,
    this.paginationLimit = 20,
    this.maximumMessageLimit,
    this.retentionTrimBuffer = MessageRetentionGate.defaultTrimBuffer,
  });

  /// A [MessageListController] allows pagination.
  /// Use [ChannelListController.paginateData] pagination.
  final MessageListController? messageListController;

  /// Function called when messages are fetched
  final Widget Function(BuildContext, List<Message>) messageListBuilder;

  /// Function used to build a loading widget
  final WidgetBuilder loadingBuilder;

  /// Function used to build an empty widget
  final WidgetBuilder emptyBuilder;

  /// Limit used to paginate messages
  final int paginationLimit;

  /// Callback triggered when an error occurs while performing the given
  /// request.
  ///
  /// This parameter can be used to display an error message to users in the
  /// event of a connection failure.
  final ErrorBuilder errorBuilder;

  /// If the current message belongs to a `thread`, this property represents the
  /// first message or the parent of the conversation.
  final Message? parentMessage;

  /// Predicate used to filter messages
  final bool Function(Message)? messageFilter;

  /// Maximum number of messages kept in [ChannelClientState] while the
  /// user is viewing the latest messages.
  ///
  /// Trimming fires when a new message arrives or the user paginates
  /// bottom and the count exceeds the limit plus [retentionTrimBuffer].
  /// Top pagination, edits, reactions, deletions, jump-to-message, and
  /// threads do not trigger trimming.
  ///
  /// When `null` (default), no pruning is performed.
  final int? maximumMessageLimit;

  /// Slack over [maximumMessageLimit] before trimming is triggered.
  ///
  /// Defaults to 30. Has no effect when [maximumMessageLimit] is `null`.
  final int retentionTrimBuffer;

  @override
  MessageListCoreState createState() => MessageListCoreState();
}

/// The current state of the [MessageListCore].
class MessageListCoreState extends State<MessageListCore> {
  StreamChannelState? _streamChannel;

  List<Message>? _initialMessages;
  Stream<List<Message>>? _messagesStream;

  bool get _isThreadConversation => widget.parentMessage != null;
  bool get _upToDate => _streamChannel?.channel.state?.isUpToDate ?? true;

  late MessageRetentionGate _retentionGate;

  @override
  Widget build(BuildContext context) {
    return BetterStreamBuilder<List<Message>>(
      stream: _messagesStream,
      initialData: _initialMessages,
      errorBuilder: widget.errorBuilder,
      noDataBuilder: widget.loadingBuilder,
      builder: (context, data) {
        final messageList = _filterAndReverse(data);
        if (messageList.isEmpty && _upToDate && !_isThreadConversation) {
          return widget.emptyBuilder(context);
        }
        return widget.messageListBuilder(context, messageList);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _retentionGate = MessageRetentionGate(
      limit: widget.maximumMessageLimit,
      trimBuffer: widget.retentionTrimBuffer,
    );
    _setupController(widget.messageListController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newStreamChannel = StreamChannel.of(context);
    if (newStreamChannel != _streamChannel) _setupChannel(newStreamChannel);
  }

  @override
  void didUpdateWidget(covariant MessageListCore oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messageListController != oldWidget.messageListController) {
      _teardownController(oldWidget.messageListController);
      _setupController(widget.messageListController);
    }

    if (widget.parentMessage?.id != oldWidget.parentMessage?.id) {
      _resolveMessagesStream(widget.parentMessage);
      _loadThreadReplies(widget.parentMessage);
      _retentionGate.seed(_initialMessages ?? const []);
    }

    if (widget.maximumMessageLimit != oldWidget.maximumMessageLimit ||
        widget.retentionTrimBuffer != oldWidget.retentionTrimBuffer) {
      _retentionGate.configure(
        limit: widget.maximumMessageLimit,
        trimBuffer: widget.retentionTrimBuffer,
      );
    }
  }

  /// Fetches more messages with updated pagination and updates the widget.
  ///
  /// Optionally pass the fetch direction, defaults to [QueryDirection.top]
  /// Optionally pass a limit, defaults to 20
  Future<void> paginateData({
    QueryDirection direction = QueryDirection.top,
  }) {
    if (widget.parentMessage?.id case final parentMessageId?) {
      return _streamChannel!.queryReplies(
        parentMessageId,
        direction: direction,
        limit: widget.paginationLimit,
      );
    }

    return _streamChannel!.queryMessages(
      direction: direction,
      limit: widget.paginationLimit,
    );
  }

  void _setupController(MessageListController? controller) {
    if (controller == null) return;
    controller.paginateData = paginateData;
  }

  void _teardownController(MessageListController? controller) {
    if (controller == null) return;
    if (controller.paginateData != paginateData) return;
    controller.paginateData = null;
  }

  void _setupChannel(StreamChannelState channel) {
    final isFirstAttach = _streamChannel == null;
    _streamChannel = channel;
    _resolveMessagesStream(widget.parentMessage);
    _retentionGate.seed(_initialMessages ?? const []);
    if (isFirstAttach) _loadThreadReplies(widget.parentMessage);
  }

  void _loadThreadReplies(Message? parentMessage) {
    if (parentMessage == null) return;
    _streamChannel?.getReplies(parentMessage.id, limit: widget.paginationLimit);
  }

  // Cached so [BetterStreamBuilder] doesn't resubscribe on every parent
  // rebuild.
  void _resolveMessagesStream(Message? parentMessage) {
    final state = _streamChannel?.channel.state;

    if (parentMessage?.id case final parentMessageId?) {
      _initialMessages = state?.threads[parentMessageId];
      _messagesStream =
          state?.threadsStream.mapNotNull((it) => it[parentMessageId]);
      return;
    }

    _initialMessages = state?.messages;
    _messagesStream = state?.messagesStream
        .where((it) => it.isNotEmpty || _upToDate)
        .doOnData(_pruneIfNeeded);
  }

  void _pruneIfNeeded(List<Message> data) {
    final streamChannel = _streamChannel;
    final state = streamChannel?.channel.state;
    final shouldPrune = _retentionGate.evaluate(
      data: data,
      isUpToDate: state?.isUpToDate ?? true,
    );
    if (!shouldPrune || streamChannel == null || state == null) return;
    streamChannel.pruneOldest(widget.maximumMessageLimit!);
  }

  List<Message> _filterAndReverse(List<Message> source) {
    if (source.isEmpty) return const [];

    final currentUser = _streamChannel?.channel.client.state.currentUser;
    final filter =
        widget.messageFilter ?? defaultMessageFilter(currentUser?.id);

    return source.reversed.where(filter).toList();
  }

  Future<void> _reloadChannelIfNeeded() async {
    // If the channel is up to date, we don't need to reload it.
    if (_upToDate) return;

    try {
      return await _streamChannel?.reloadChannel();
    } catch (_) {
      // We just ignore the error here, as we can't do anything about it.
      // The reload might fail for various reasons, such as user already
      // left the channel, or the channel is deleted.
    }
  }

  @override
  void dispose() {
    _teardownController(widget.messageListController);
    _reloadChannelIfNeeded();
    super.dispose();
  }
}

/// Controller used for paginating data in [ChannelListView]
class MessageListController {
  /// Call this function to load further data
  Future<void> Function({QueryDirection direction})? paginateData;
}

/// Decides when [MessageListCore] should auto-prune.
///
/// Pruning fires when the list grows past `limit + trimBuffer` and the
/// most recent message id changes — i.e. a new message arrived or the
/// user paginated bottom. Top pagination, edits, reactions, deletions,
/// and jump-to-message do not trigger it.
@visibleForTesting
class MessageRetentionGate {
  /// Creates a new retention gate.
  MessageRetentionGate({
    required int? limit,
    int trimBuffer = defaultTrimBuffer,
  })  : assert(limit == null || limit >= 0, '`limit` must be non-negative'),
        assert(trimBuffer >= 0, '`trimBuffer` must be non-negative'),
        _limit = limit,
        _trimBuffer = trimBuffer;

  /// Default trim buffer.
  static const defaultTrimBuffer = 30;

  int? _limit;
  int _trimBuffer;
  String? _lastSeenTailId;
  int _lastSeenCount = 0;

  /// Configured cap, or `null` if pruning is disabled.
  int? get limit => _limit;

  /// Configured trim buffer.
  int get trimBuffer => _trimBuffer;

  /// Updates the cap and trim buffer. Does not clear the cached tail.
  void configure({
    required int? limit,
    required int trimBuffer,
  }) {
    assert(limit == null || limit >= 0, '`limit` must be non-negative');
    assert(trimBuffer >= 0, '`trimBuffer` must be non-negative');
    _limit = limit;
    _trimBuffer = trimBuffer;
  }

  /// Primes the cached tail without evaluating whether a prune should fire.
  ///
  /// Call on mount and on channel/thread transitions so the first stream
  /// emission compares against itself and cached history isn't pruned.
  void seed(List<Message> messages) {
    _lastSeenTailId = messages.isEmpty ? null : messages.last.id;
    _lastSeenCount = messages.length;
  }

  /// Whether [data] should be auto-pruned. Updates the cached tail.
  bool evaluate({
    required List<Message> data,
    required bool isUpToDate,
  }) {
    final newTailId = data.isEmpty ? null : data.last.id;
    final previousTailId = _lastSeenTailId;
    final previousCount = _lastSeenCount;
    _lastSeenTailId = newTailId;
    _lastSeenCount = data.length;

    final limit = _limit;
    if (limit == null || !isUpToDate || data.length <= limit + _trimBuffer) {
      return false;
    }

    // Require both a new tail and a longer list so deletions and edits
    // at the tail can't masquerade as "new data" and trigger a prune.
    return newTailId != previousTailId && data.length > previousCount;
  }
}
