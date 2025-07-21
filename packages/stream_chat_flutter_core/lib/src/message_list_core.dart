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

  @override
  Widget build(BuildContext context) {
    final messagesStream = _isThreadConversation
        ? _streamChannel!.channel.state?.threadsStream
            .where((threads) => threads.containsKey(widget.parentMessage!.id))
            .map((threads) => threads[widget.parentMessage!.id])
        : _streamChannel!.channel.state?.messagesStream;

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
        final messageList = data
            .where(
              widget.messageFilter ?? defaultMessageFilter(_currentUser!.id),
            )
            .toList(growable: false)
            .reversed
            .toList(growable: false);
        if (messageList.isEmpty && !_isThreadConversation) {
          if (_upToDate) {
            return widget.emptyBuilder(context);
          }
        } else {
          _messages = messageList;
        }
        return widget.messageListBuilder(context, _messages);
      },
    );
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
      return _streamChannel!.getReplies(
        widget.parentMessage!.id,
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
    }
  }

  @override
  void initState() {
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
