import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'stream_channel.dart';

/// A signature for a callback which exposes an error and returns a function.
/// This Callback can be used in cases where an API failure occurs and the widget
/// is unable to render data.
typedef StreamErrorBuilder = Widget Function(
    BuildContext context, Object error);

/// [MessageListCore] is a simplified class that allows fetching a list of messages while exposing UI builders.
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
/// Make sure to have a [StreamChannel] ancestor in order to provide the information about the channels.
/// The widget uses a [ListView.custom] to render the list of channels.
///
/// The widget components render the ui based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget appearance.
class MessageListCore extends StatefulWidget {
  /// Instantiate a new MessageListView
  MessageListCore({
    Key key,
    this.showScrollToBottom = true,
    this.parentMessage,
    @required this.loadingBuilder,
    @required this.emptyBuilder,
    @required this.messageListBuilder,
    @required this.errorWidgetBuilder,
    this.messageListController,
  }) : super(key: key);

  /// A [MessageListController] allows pagination.
  /// Use [ChannelListController.paginateData] pagination.
  final MessageListController messageListController;

  /// Function called when messages are fetched
  final Widget Function(BuildContext, List<Message>) messageListBuilder;

  /// Function used to build a loading widget
  final WidgetBuilder loadingBuilder;

  /// Function used to build an empty widget
  final WidgetBuilder emptyBuilder;

  /// Callback triggered when an error occurs while performing the given request.
  /// This parameter can be used to display an error message to users in the event
  /// of a connection failure.
  final StreamErrorBuilder errorWidgetBuilder;

  /// If true will show a scroll to bottom message when there are new messages and the scroll offset is not zero
  final bool showScrollToBottom;

  /// Parent message in case of a thread
  final Message parentMessage;

  @override
  _MessageListCoreState createState() => _MessageListCoreState();
}

class _MessageListCoreState extends State<MessageListCore> {
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
        } else if (snapshot.hasError) {
          return widget.errorWidgetBuilder(context, snapshot.error);
        } else {
          final messageList = snapshot.data?.reversed?.toList() ?? [];
          if (messageList.isEmpty) {
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
