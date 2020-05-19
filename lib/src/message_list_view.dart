import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/message_widget.dart';
import 'package:stream_chat_flutter/src/system_message.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../stream_chat_flutter.dart';
import 'date_divider.dart';
import 'stream_channel.dart';

typedef MessageBuilder = Widget Function(
  BuildContext,
  MessageDetails,
  List<Message>,
);
typedef ParentMessageBuilder = Widget Function(
  BuildContext,
  Message,
);
typedef ThreadBuilder = Widget Function(BuildContext context, Message parent);
typedef ThreadTapCallback = void Function(Message, Widget);

class MessageDetails {
  /// True if the message belongs to the current user
  bool isMyMessage;

  /// True if the user message is the same of the previous message
  bool isLastUser;

  /// True if the user message is the same of the next message
  bool isNextUser;

  /// The message
  Message message;

  /// The index of the message
  int index;

  MessageDetails(
    BuildContext context,
    this.message,
    List<Message> messages,
    this.index,
  ) {
    isMyMessage = message.user.id == StreamChat.of(context).user.id;
    isLastUser = index + 1 < messages.length &&
        message.user.id == messages[index + 1]?.user?.id;
    isNextUser =
        index - 1 >= 0 && message.user.id == messages[index - 1]?.user?.id;
  }
}

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
    this.messageBuilder,
    this.parentMessageBuilder,
    this.parentMessage,
    this.threadBuilder,
    this.onThreadTap,
    this.dateDividerBuilder,
    this.scrollPhysics = const AlwaysScrollableScrollPhysics(),
  }) : super(key: key);

  /// Function used to build a custom message widget
  final MessageBuilder messageBuilder;

  /// Function used to build a custom parent message widget
  final ParentMessageBuilder parentMessageBuilder;

  /// Function used to build a custom thread widget
  final ThreadBuilder threadBuilder;

  /// Function called when tapping on a thread
  /// By default it calls [Navigator.push] using the widget built using [threadBuilder]
  final ThreadTapCallback onThreadTap;

  /// Parent message in case of a thread
  final Message parentMessage;

  /// Builder used to render date dividers
  final Widget Function(DateTime) dateDividerBuilder;

  /// The ScrollPhysics used by the ListView
  final ScrollPhysics scrollPhysics;

  @override
  _MessageListViewState createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  static const _newMessageLoadingOffset = 100;
  final ScrollController _scrollController = ScrollController();
  bool _isBottom = true;
  bool _topWasVisible = false;
  List<Message> _messages = [];
  List<Message> _newMessageList = [];
  Function _onThreadTap;

  @override
  Widget build(BuildContext context) {
    final streamChannel = StreamChannel.of(context);

    /// TODO: find a better solution when (https://github.com/flutter/flutter/issues/21023) is fixed
    return NotificationListener<ScrollNotification>(
      onNotification: (_) {
        if (_scrollController.offset < 150 && _newMessageList.isNotEmpty) {
          setState(() {
            _messages.insertAll(0, _newMessageList);
            _newMessageList.clear();
          });
        }
        return true;
      },
      child: ListView.custom(
        key: Key('messageListView'),
        physics: widget.scrollPhysics,
        controller: _scrollController,
        reverse: true,
        childrenDelegate: SliverChildBuilderDelegate(
          (context, i) {
            if (i == _messages.length + 1) {
              if (widget.parentMessage != null) {
                if (widget.parentMessageBuilder != null) {
                  return widget.parentMessageBuilder(
                    context,
                    widget.parentMessage,
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      buildParentMessage(widget.parentMessage),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Start of thread',
                            textAlign: TextAlign.center,
                          ),
                          color: Theme.of(context).accentColor.withAlpha(50),
                        ),
                      ),
                    ],
                  );
                }
              } else {
                return SizedBox();
              }
            }

            if (i == _messages.length) {
              return _buildLoadingIndicator(streamChannel);
            }
            final message = _messages[i];
            final nextMessage = i > 0 ? _messages[i - 1] : null;

            Widget messageWidget;

            if (i == 0) {
              messageWidget = _buildBottomMessage(
                context,
                message,
                _messages,
                streamChannel,
              );
            } else if (i == _messages.length - 1) {
              messageWidget = _buildTopMessage(
                context,
                message,
                _messages,
                streamChannel,
              );
            } else {
              if (widget.messageBuilder != null) {
                messageWidget = Builder(
                  key: ValueKey<String>('MESSAGE-${message.id}'),
                  builder: (_) => widget.messageBuilder(
                      context,
                      MessageDetails(
                        context,
                        message,
                        _messages,
                        i,
                      ),
                      _messages),
                );
              } else {
                messageWidget = buildMessage(message, _messages, i);
              }
            }

            if (nextMessage != null &&
                !Jiffy(message.createdAt.toLocal())
                    .isSame(nextMessage.createdAt.toLocal(), Units.DAY)) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  messageWidget,
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: widget.dateDividerBuilder != null
                        ? widget
                            .dateDividerBuilder(nextMessage.createdAt.toLocal())
                        : DateDivider(
                            dateTime: nextMessage.createdAt.toLocal(),
                          ),
                  ),
                ],
              );
            }

            return messageWidget;
          },
          childCount: _messages.length + 2,
          findChildIndexCallback: (key) {
            final ValueKey<String> valueKey = key;
            final index = _messages
                .indexWhere((m) => 'MESSAGE-${m.id}' == valueKey.value);
            return index != -1 ? index : null;
          },
        ),
      ),
    );
  }

  Container _buildLoadingIndicator(StreamChannelState streamChannel) {
    return Container(
      height: 50,
      child: StreamBuilder<bool>(
          stream: streamChannel.queryMessage,
          initialData: false,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container(
                color: Color(0xffd0021B).withAlpha(26),
                child: Center(
                  child: Text('Error loading messages'),
                ),
              );
            }
            if (!snapshot.data) {
              return Container();
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }),
    );
  }

  Widget _buildTopMessage(
    BuildContext context,
    Message message,
    List<Message> messages,
    StreamChannelState streamChannel,
  ) {
    Widget messageWidget;
    if (widget.messageBuilder != null) {
      messageWidget = Builder(
        key: ValueKey<String>('TOP-MESSAGE'),
        builder: (_) => widget.messageBuilder(
          context,
          MessageDetails(
            context,
            message,
            _messages,
            _messages.length - 1,
          ),
          _messages,
        ),
      );
    } else {
      messageWidget = buildMessage(message, messages, _messages.length - 1);
    }

    return VisibilityDetector(
      key: ValueKey<String>('TOP-MESSAGE'),
      child: messageWidget,
      onVisibilityChanged: (visibility) {
        final topIsVisible = visibility.visibleBounds != Rect.zero;
        if (topIsVisible && !_topWasVisible) {
          streamChannel.queryMessages();
        }
        _topWasVisible = topIsVisible;
      },
    );
  }

  Widget _buildBottomMessage(
    BuildContext context,
    Message message,
    List<Message> messages,
    StreamChannelState streamChannel,
  ) {
    Widget messageWidget;
    if (widget.messageBuilder != null) {
      messageWidget = Builder(
        key: ValueKey<String>('BOTTOM-MESSAGE'),
        builder: (_) => widget.messageBuilder(
          context,
          MessageDetails(
            context,
            message,
            _messages,
            0,
          ),
          _messages,
        ),
      );
    } else {
      messageWidget = buildMessage(message, messages, 0);
    }

    return VisibilityDetector(
      key: ValueKey<String>('BOTTOM-MESSAGE'),
      onVisibilityChanged: (visibility) {
        _isBottom = visibility.visibleBounds != Rect.zero;
        if (_isBottom && streamChannel.channel.config?.readEvents == true) {
          if (streamChannel.channel.state.unreadCount > 0) {
            streamChannel.channel.markRead();
          }
        }
      },
      child: messageWidget,
    );
  }

  Widget buildParentMessage(
    Message message,
  ) {
    final isMyMessage = message.user.id == StreamChat.of(context).user.id;

    return MessageWidget(
      showReplyIndicator: false,
      message: message,
      reverse: isMyMessage,
      showUsername: !isMyMessage,
      padding: EdgeInsets.only(
        top: 8.0,
        left: 8.0,
        right: 8.0,
        bottom: 16.0,
      ),
      showSendingIndicator: DisplayWidget.hide,
      onThreadTap: _onThreadTap,
      showEditMessage: false,
      showDeleteMessage: false,
      borderRadiusGeometry: BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomLeft: Radius.circular(2),
        topRight: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      borderSide: isMyMessage ? BorderSide.none : null,
      showUserAvatar: DisplayWidget.show,
      messageTheme: isMyMessage
          ? StreamChatTheme.of(context).ownMessageTheme
          : StreamChatTheme.of(context).otherMessageTheme,
    );
  }

  Widget buildMessage(
    Message message,
    List<Message> messages,
    int index,
  ) {
    if (message.type == 'system' && message.text?.isNotEmpty == true) {
      return SystemMessage(
        message: message,
      );
    }

    final isMyMessage = message.user.id == StreamChat.of(context).user.id;
    final isLastUser = index + 1 < messages.length &&
        message.user.id == messages[index + 1]?.user?.id;
    final isNextUser =
        index - 1 >= 0 && message.user.id == messages[index - 1]?.user?.id;

    return MessageWidget(
      message: message,
      reverse: isMyMessage,
      showReactions: !message.isDeleted,
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: index == 0 ? 30 : (isNextUser ? 5 : 10),
      ),
      showUsername: !isMyMessage && !isNextUser,
      showSendingIndicator: isMyMessage &&
              (index == 0 || message.status != MessageSendingStatus.SENT)
          ? DisplayWidget.show
          : DisplayWidget.hide,
      showTimestamp: !isNextUser,
      showEditMessage: isMyMessage,
      showDeleteMessage: isMyMessage,
      borderSide: isMyMessage ? BorderSide.none : null,
      onThreadTap: _onThreadTap,
      attachmentBorderRadiusGeometry: BorderRadius.circular(16),
      borderRadiusGeometry: BorderRadius.only(
        topLeft: Radius.circular(isLastUser ? 2 : 16),
        bottomLeft: Radius.circular(2),
        topRight: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      showUserAvatar: isNextUser ? DisplayWidget.hide : DisplayWidget.show,
      messageTheme: isMyMessage
          ? StreamChatTheme.of(context).ownMessageTheme
          : StreamChatTheme.of(context).otherMessageTheme,
    );
  }

  StreamSubscription _streamListener;

  @override
  void initState() {
    super.initState();

    final streamChannel = StreamChannel.of(context);
    if (streamChannel.channel.state.unreadCount > 0) {
      streamChannel.channel.markRead();
    }

    Stream<List<Message>> stream;

    if (widget.parentMessage == null) {
      stream = streamChannel.channel.state.messagesStream;
    } else {
      streamChannel.getReplies(widget.parentMessage.id);
      stream = streamChannel.channel.state.threadsStream
          .where((threads) => threads.containsKey(widget.parentMessage.id))
          .map((threads) => threads[widget.parentMessage.id]);
    }

    _streamListener = stream
        .map((messages) =>
            messages
                ?.where((m) =>
                    !(m.status == MessageSendingStatus.FAILED && m.isDeleted))
                ?.toList() ??
            [])
        .listen((newMessages) {
      newMessages = newMessages.reversed.toList();
      if (_messages.isEmpty ||
          newMessages.isEmpty ||
          newMessages.first.id != _messages.first.id) {
        if (!_scrollController.hasClients ||
            _scrollController.offset < _newMessageLoadingOffset) {
          if (streamChannel.channel.state.unreadCount > 0) {
            streamChannel.channel.markRead();
          }
          setState(() {
            _messages = newMessages;
          });
        } else if (newMessages.first.user.id ==
            streamChannel.channel.client.state.user.id) {
          _scrollController.jumpTo(0);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _messages = newMessages;
            });
          });
        } else {
          _newMessageList = newMessages;
        }
      } else {
        setState(() {
          _messages = newMessages;
        });
      }
    });

    _getOnThreadTap();
  }

  void _getOnThreadTap() {
    if (widget.onThreadTap != null) {
      _onThreadTap = (Message message) {
        widget.onThreadTap(
            message,
            widget.threadBuilder != null
                ? widget.threadBuilder(context, message)
                : null);
      };
    } else if (widget.threadBuilder != null) {
      _onThreadTap = (Message message) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) {
            return StreamBuilder<Message>(
                stream: StreamChannel.of(context)
                    .channel
                    .state
                    .messagesStream
                    .map((messages) =>
                        messages.firstWhere((m) => m.id == message.id)),
                initialData: message,
                builder: (_, snapshot) {
                  return StreamChannel(
                    channel: StreamChannel.of(context).channel,
                    child: widget.threadBuilder(context, snapshot.data),
                  );
                });
          }),
        );
      };
    }
  }

  @override
  void dispose() {
    _streamListener.cancel();
    super.dispose();
  }
}
