import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/stream_channel.dart';
import 'package:stream_chat_flutter_core/src/typedef.dart';

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
///             child: CircularProgressIndicator(),
///           );
///         },
///         messageListBuilder: (context, list) {
///           return MessagesPage(list);
///         },
///         errorWidgetBuilder: (context, err) {
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
    Key? key,
    required this.loadingBuilder,
    required this.emptyBuilder,
    required this.messageListBuilder,
    required this.errorWidgetBuilder,
    this.showScrollToBottom = true,
    this.parentMessage,
    this.messageListController,
    this.messageFilter,
  }) : super(key: key);

  /// A [MessageListController] allows pagination.
  /// Use [ChannelListController.paginateData] pagination.
  final MessageListController? messageListController;

  /// Function called when messages are fetched
  final Widget Function(BuildContext, List<Message>) messageListBuilder;

  /// Function used to build a loading widget
  final WidgetBuilder loadingBuilder;

  /// Function used to build an empty widget
  final WidgetBuilder emptyBuilder;

  /// Callback triggered when an error occurs while performing the given
  /// request.
  ///
  /// This parameter can be used to display an error message to users in the
  /// event of a connection failure.
  final ErrorBuilder errorWidgetBuilder;

  /// If true will show a scroll to bottom message when there are new messages
  /// and the scroll offset is not zero.
  final bool showScrollToBottom;

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

  OwnUser? get _currentUser => _streamChannel!.channel.client.state.user;

  var _messages = <Message>[];

  @override
  Widget build(BuildContext context) {
    final messagesStream = _isThreadConversation
        ? _streamChannel!.channel.state?.threadsStream
            .where((threads) => threads.containsKey(widget.parentMessage!.id))
            .map((threads) => threads[widget.parentMessage!.id])
        : _streamChannel!.channel.state?.messagesStream;

    bool defaultFilter(Message m) {
      final isMyMessage = m.user?.id == _currentUser?.id;
      final isDeletedOrShadowed = m.isDeleted == true || m.shadowed == true;
      if (isDeletedOrShadowed && !isMyMessage) return false;
      return true;
    }

    return StreamBuilder<List<Message>?>(
      stream: messagesStream?.map((messages) =>
          messages?.where(widget.messageFilter ?? defaultFilter).toList(
                growable: false,
              )),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return widget.errorWidgetBuilder(context, snapshot.error!);
        } else if (!snapshot.hasData) {
          return widget.loadingBuilder(context);
        } else {
          final messageList =
              snapshot.data?.reversed.toList(growable: false) ?? [];
          if (messageList.isEmpty && !_isThreadConversation) {
            if (_upToDate) {
              return widget.emptyBuilder(context);
            }
          } else {
            _messages = messageList;
          }
          return widget.messageListBuilder(context, _messages);
        }
      },
    );
  }

  /// Fetches more messages with updated pagination and updates the widget.
  ///
  /// Optionally pass the fetch direction, defaults to [QueryDirection.top]
  Future<void> paginateData({
    QueryDirection direction = QueryDirection.top,
  }) {
    if (!_isThreadConversation) {
      return _streamChannel!.queryMessages(direction: direction);
    } else {
      return _streamChannel!.getReplies(widget.parentMessage!.id);
    }
  }

  @override
  void didChangeDependencies() {
    final newStreamChannel = StreamChannel.of(context);

    if (newStreamChannel != _streamChannel) {
      if (_streamChannel == null /*only first time*/ && _isThreadConversation) {
        newStreamChannel.getReplies(widget.parentMessage!.id);
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

    if (widget.parentMessage?.id != widget.parentMessage?.id) {
      if (_isThreadConversation) {
        _streamChannel!.getReplies(widget.parentMessage!.id);
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

  @override
  void dispose() {
    if (!_upToDate) {
      _streamChannel!.reloadChannel();
    }
    super.dispose();
  }
}

/// Controller used for paginating data in [ChannelListView]
class MessageListController {
  /// Call this function to load further data
  Future<void> Function({QueryDirection direction})? paginateData;
}
