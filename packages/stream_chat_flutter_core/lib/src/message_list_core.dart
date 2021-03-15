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
    Key key,
    @required this.loadingBuilder,
    @required this.emptyBuilder,
    @required this.messageListBuilder,
    @required this.errorWidgetBuilder,
    this.showScrollToBottom = true,
    this.parentMessage,
    this.messageListController,
    this.messageFilter,
  })  : assert(loadingBuilder != null, 'loadingBuilder should not be null'),
        assert(emptyBuilder != null, 'emptyBuilder should not be null'),
        assert(
          messageListBuilder != null,
          'messageListBuilder should not be null',
        ),
        assert(
          errorWidgetBuilder != null,
          'errorWidgetBuilder should not be null',
        ),
        super(key: key);

  /// A [MessageListController] allows pagination.
  /// Use [ChannelListController.paginateData] pagination.
  final MessageListController messageListController;

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
  final Message parentMessage;

  /// Predicate used to filter messages
  final bool Function(Message) messageFilter;

  @override
  _MessageListCoreState createState() => _MessageListCoreState();
}

class _MessageListCoreState extends State<MessageListCore> {
  StreamChannelState streamChannel;

  bool get _upToDate => streamChannel.channel.state.isUpToDate;

  bool get _isThreadConversation => widget.parentMessage != null;

  OwnUser get _currentUser => streamChannel.channel.client.state.user;

  List<Message> messages = <Message>[];
  bool initialMessageHighlightComplete = false;

  @override
  Widget build(BuildContext context) {
    final messagesStream = _isThreadConversation
        ? streamChannel.channel.state.threadsStream
            .where((threads) => threads.containsKey(widget.parentMessage.id))
            .map((threads) => threads[widget.parentMessage.id])
        : streamChannel.channel.state?.messagesStream;

    bool defaultFilter(Message m) {
      final isMyMessage = m.user.id == _currentUser.id;
      final isDeletedOrShadowed = m.isDeleted == true || m.shadowed == true;
      if (isDeletedOrShadowed && !isMyMessage) return false;
      return true;
    }

    return StreamBuilder<List<Message>>(
      stream: messagesStream?.map((messages) =>
          messages?.where(widget.messageFilter ?? defaultFilter)?.toList()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return widget.loadingBuilder(context);
        } else if (snapshot.hasError) {
          return widget.errorWidgetBuilder(context, snapshot.error);
        } else {
          final messageList = snapshot.data?.reversed?.toList() ?? [];
          if (messageList.isEmpty && !_isThreadConversation) {
            if (_upToDate) {
              return widget.emptyBuilder(context);
            }
          } else {
            messages = messageList;
          }
          return widget.messageListBuilder(context, messages);
        }
      },
    );
  }

  Future<void> paginateData(
      {QueryDirection direction = QueryDirection.bottom}) {
    if (!_isThreadConversation) {
      return streamChannel.queryMessages(direction: direction);
    } else {
      return streamChannel.getReplies(widget.parentMessage.id);
    }
  }

  @override
  void initState() {
    streamChannel = StreamChannel.of(context);

    if (_isThreadConversation) {
      streamChannel.getReplies(widget.parentMessage.id);
    }

    if (widget.messageListController != null) {
      widget.messageListController.paginateData = paginateData;
    }

    super.initState();
  }

  @override
  void dispose() {
    if (!_upToDate) {
      streamChannel.reloadChannel();
    }
    super.dispose();
  }
}

/// Controller used for paginating data in [ChannelListView]
class MessageListController {
  /// Call this function to load further data
  Function({QueryDirection direction}) paginateData;
}
