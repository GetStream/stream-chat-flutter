import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'stream_channel.dart';

/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/message_listview.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/message_listview_paint.png)
///
/// It shows the list of messages of the current channel.
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
///       appBar: ChannelHeader(),
///       body: Column(
///         children: <Widget>[
///           Expanded(
///             child: MessageListView(
///               threadBuilder: (_, parentMessage) {
///                 return ThreadPage(
///                   parent: parentMessage,
///                 );
///               },
///             ),
///           ),
///           MessageInput(),
///         ],
///       ),
///     );
///   }
/// }
/// ```
///
///
/// Make sure to have a [StreamChannel] ancestor in order to provide the information about the channels.
/// The widget uses a [ListView.custom] to render the list of channels.
///
/// The widget components render the ui based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget appearance.
class MessageListView extends StatefulWidget {
  /// Instantiate a new MessageListView
  MessageListView({
    Key key,
    this.showScrollToBottom = true,
    this.parentMessage,
    this.dateDividerBuilder,
    @required this.loadingBuilder,
    @required this.emptyBuilder,
    @required this.messageListBuilder,
    this.messageListController,
  }) : super(key: key);

  final MessageListController messageListController;

  final Widget Function(BuildContext, List<Message>) messageListBuilder;

  /// Function used to build a loading widget
  final WidgetBuilder loadingBuilder;

  /// Function used to build an empty widget
  final WidgetBuilder emptyBuilder;

  /// If true will show a scroll to bottom message when there are new messages and the scroll offset is not zero
  final bool showScrollToBottom;

  /// Parent message in case of a thread
  final Message parentMessage;

  /// Builder used to render date dividers
  final Widget Function(DateTime) dateDividerBuilder;

  @override
  _MessageListViewState createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  StreamChannelState streamChannel;

  bool get _upToDate => streamChannel.channel.state.isUpToDate;

  bool get _isThreadConversation => widget.parentMessage != null;

  int initialIndex;
  double initialAlignment;

  List<Message> messages = <Message>[];

  bool initialMessageHighlightComplete = false;

  @override
  Widget build(BuildContext context) {
    final messagesStream = _isThreadConversation
        ? streamChannel.channel.state.threadsStream
            .where((threads) => threads.containsKey(widget.parentMessage.id))
            .map((threads) => threads[widget.parentMessage.id])
        : streamChannel.channel.state?.messagesStream;

    return StreamBuilder<List<Message>>(
        stream: messagesStream?.map((messages) => messages
            ?.where((e) =>
                (!e.isDeleted && e.shadowed != true) ||
                (e.isDeleted &&
                    e.user.id == streamChannel.channel.client.state.user.id))
            ?.toList()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return widget.loadingBuilder(context);
          }

          final messageList = snapshot.data?.reversed?.toList() ?? [];
          if (messageList.isEmpty) {
            if (_upToDate) {
              return widget.emptyBuilder(context);
            }
          } else {
            messages = messageList;
          }

          return widget.messageListBuilder(context, messages);
        });
  }

  Future<void> paginateData(QueryDirection direction) {
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
  Function(QueryDirection direction) paginateData;
}
