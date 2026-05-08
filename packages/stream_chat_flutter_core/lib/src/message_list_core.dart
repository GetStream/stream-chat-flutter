import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/better_stream_builder.dart';
import 'package:stream_chat_flutter_core/src/stream_channel.dart';
import 'package:stream_chat_flutter_core/src/typedef.dart';

/// Default filter for the message list
bool Function(Message) defaultMessageFilter(String currentUserId) =>
    (Message m) {
      final isMyMessage = m.user?.id == currentUserId;
      if (m.shadowed && !isMyMessage) return false;
      return true;
    };

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
    this.retentionTrimBuffer = _MessageRetentionGate.defaultTrimBuffer,
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

  bool get _upToDate => _streamChannel!.channel.state?.isUpToDate ?? true;

  bool get _isThreadConversation => widget.parentMessage != null;

  OwnUser? get _currentUser => _streamChannel!.channel.client.state.currentUser;

  var _messages = <Message>[];

  late _MessageRetentionGate _retentionGate;

  @override
  Widget build(BuildContext context) {
    final messagesStream = _isThreadConversation
        ? _streamChannel!.channel.state?.threadsStream
            .where((threads) => threads.containsKey(widget.parentMessage!.id))
            .map((threads) => threads[widget.parentMessage!.id])
        : _streamChannel!.channel.state?.messagesStream.map(_pruneIfNeeded);

    final initialData = _isThreadConversation
        ? _streamChannel!.channel.state?.threads[widget.parentMessage!.id]
        : _streamChannel!.channel.state?.messages;

    return BetterStreamBuilder<List<Message>>(
      initialData: initialData,
      comparator: const ListEquality().equals,
      stream: messagesStream,
      errorBuilder: widget.errorBuilder,
      noDataBuilder: widget.loadingBuilder,
      builder: (context, data) {
        final messageList = _filterAndReverse(data);
        if (messageList.isEmpty && !_isThreadConversation) {
          if (_upToDate) return widget.emptyBuilder(context);
        } else {
          _messages = messageList;
        }
        return widget.messageListBuilder(context, _messages);
      },
    );
  }

  List<Message> _pruneIfNeeded(List<Message> data) {
    final streamChannel = _streamChannel;
    final state = streamChannel?.channel.state;
    final shouldPrune = _retentionGate.shouldPrune(
      data: data,
      isUpToDate: state?.isUpToDate ?? true,
    );

    if (!shouldPrune || streamChannel == null || state == null) return data;

    streamChannel.pruneOldest(widget.maximumMessageLimit!);
    final pruned = state.messages;
    _retentionGate.noteEmission(pruned);
    return pruned;
  }

  List<Message> _filterAndReverse(List<Message> source) {
    if (source.isEmpty) return const <Message>[];
    final filter =
        widget.messageFilter ?? defaultMessageFilter(_currentUser!.id);
    return source.reversed.where(filter).toList(growable: false);
  }

  /// Fetches more messages with updated pagination and updates the widget.
  ///
  /// Optionally pass the fetch direction, defaults to [QueryDirection.top]
  /// Optionally pass a limit, defaults to 20
  Future<void> paginateData({
    QueryDirection direction = QueryDirection.top,
  }) {
    if (!_isThreadConversation) {
      return _streamChannel!.queryMessages(
        direction: direction,
        limit: widget.paginationLimit,
      );
    } else {
      return _streamChannel!.queryReplies(
        widget.parentMessage!.id,
        direction: direction,
        limit: widget.paginationLimit,
      );
    }
  }

  @override
  void didChangeDependencies() {
    final newStreamChannel = StreamChannel.of(context);

    if (newStreamChannel != _streamChannel) {
      if (_streamChannel == null /*only first time*/ && _isThreadConversation) {
        newStreamChannel.getReplies(
          widget.parentMessage!.id,
          limit: widget.paginationLimit,
        );
      }
      _streamChannel = newStreamChannel;
      _retentionGate.reset();
    }

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant MessageListCore oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.messageListController != oldWidget.messageListController) {
      _setupController();
    }

    if (widget.parentMessage?.id != oldWidget.parentMessage?.id) {
      if (_isThreadConversation) {
        _streamChannel!.getReplies(
          widget.parentMessage!.id,
          limit: widget.paginationLimit,
        );
      }
      _retentionGate.reset();
    }

    if (widget.maximumMessageLimit != oldWidget.maximumMessageLimit ||
        widget.retentionTrimBuffer != oldWidget.retentionTrimBuffer) {
      _retentionGate.configure(
        limit: widget.maximumMessageLimit,
        trimBuffer: widget.retentionTrimBuffer,
      );
      // Defer to post-frame to avoid mutating channel state during build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _evaluateLimitChange();
      });
    }
  }

  void _evaluateLimitChange() {
    if (_isThreadConversation) return;
    final limit = widget.maximumMessageLimit;
    if (limit == null) return;
    final streamChannel = _streamChannel;
    final state = streamChannel?.channel.state;
    if (streamChannel == null || state == null || !state.isUpToDate) return;
    if (state.messages.length <= limit + widget.retentionTrimBuffer) return;

    streamChannel.pruneOldest(limit);
    _retentionGate.noteEmission(state.messages);
  }

  @override
  void initState() {
    _retentionGate = _MessageRetentionGate(
      limit: widget.maximumMessageLimit,
      trimBuffer: widget.retentionTrimBuffer,
    );
    _setupController();

    super.initState();
  }

  void _setupController() {
    if (widget.messageListController != null) {
      widget.messageListController!.paginateData = paginateData;
    }
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
  })  : _limit = limit,
        _trimBuffer = trimBuffer;

  /// Default trim buffer.
  static const defaultTrimBuffer = 30;

  int? _limit;
  int _trimBuffer;
  String? _lastSeenTailId;

  /// Configured cap, or `null` if pruning is disabled.
  int? get limit => _limit;

  /// Configured trim buffer.
  int get trimBuffer => _trimBuffer;

  /// Updates the cap and trim buffer. Does not clear the cached tail.
  void configure({required int? limit, required int trimBuffer}) {
    _limit = limit;
    _trimBuffer = trimBuffer;
  }

  /// Clears the cached tail.
  void reset() => _lastSeenTailId = null;

  /// Records the tail of [messages] as the most recently observed one.
  void noteEmission(List<Message> messages) {
    _lastSeenTailId = messages.isEmpty ? null : messages.last.id;
  }

  /// Whether [data] should be auto-pruned. Updates the cached tail.
  bool shouldPrune({
    required List<Message> data,
    required bool isUpToDate,
  }) {
    final newTailId = data.isEmpty ? null : data.last.id;
    final limit = _limit;

    if (limit == null || !isUpToDate || data.length <= limit + _trimBuffer) {
      _lastSeenTailId = newTailId;
      return false;
    }

    final tailUnchanged =
        _lastSeenTailId != null && _lastSeenTailId == newTailId;
    _lastSeenTailId = newTailId;
    return !tailUnchanged;
  }
}

typedef _MessageRetentionGate = MessageRetentionGate;
