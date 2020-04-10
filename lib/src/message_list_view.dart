import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../stream_chat_flutter.dart';
import 'message_widget.dart';
import 'stream_channel.dart';

typedef MessageBuilder = Widget Function(BuildContext, Message, int index);
typedef ParentMessageBuilder = Widget Function(BuildContext, Message);
typedef ThreadBuilder = Widget Function(BuildContext context, Message parent);
typedef ThreadTapCallback = void Function(Message, Widget);

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
  MessageListView({
    Key key,
    this.messageBuilder,
    this.parentMessageBuilder,
    this.parentMessage,
    this.threadBuilder,
    this.onThreadTap,
    this.showOtherMessageUsername = false,
    this.showVideoFullScreen = true,
    this.onMentionTap,
    this.onMessageActions,
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

  /// If true show the other users username next to the timestamp of the message
  final bool showOtherMessageUsername;

  /// True if the video player will allow fullscreen mode
  final bool showVideoFullScreen;

  /// Function called on message mention tap
  final void Function(User) onMentionTap;

  /// Function called on message long press
  final Function(BuildContext, Message) onMessageActions;

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
        physics: AlwaysScrollableScrollPhysics(),
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
                      MessageWidget(
                        key: ValueKey<String>(
                            'PARENT-MESSAGE-${widget.parentMessage.id}'),
                        previousMessage: null,
                        message: widget.parentMessage,
                        nextMessage: null,
                        onThreadTap: _onThreadTap,
                        isParent: true,
                        showVideoFullScreen: widget.showVideoFullScreen,
                        showOtherMessageUsername:
                            widget.showOtherMessageUsername,
                        onMentionTap: widget.onMentionTap,
                        onMessageActions: widget.onMessageActions,
                      ),
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

            final previousMessage =
                i < _messages.length - 1 ? _messages[i + 1] : null;
            final nextMessage = i > 0 ? _messages[i - 1] : null;

            Widget messageWidget;

            if (i == 0) {
              messageWidget = _buildBottomMessage(
                streamChannel,
                previousMessage,
                message,
                context,
              );
            } else if (i == _messages.length - 1) {
              messageWidget = _buildTopMessage(
                message,
                nextMessage,
                streamChannel,
                context,
              );
            } else {
              if (widget.messageBuilder != null) {
                messageWidget = Builder(
                  key: ValueKey<String>('MESSAGE-${message.id}'),
                  builder: (_) => widget.messageBuilder(context, message, i),
                );
              } else {
                messageWidget = MessageWidget(
                  key: ValueKey<String>('MESSAGE-${message.id}'),
                  previousMessage: previousMessage,
                  message: message,
                  nextMessage: nextMessage,
                  onThreadTap: _onThreadTap,
                  showOtherMessageUsername: widget.showOtherMessageUsername,
                  showVideoFullScreen: widget.showVideoFullScreen,
                  onMentionTap: widget.onMentionTap,
                  onMessageActions: widget.onMessageActions,
                );
              }
            }

            if (nextMessage != null &&
                !Jiffy(message.createdAt.toLocal())
                    .isSame(nextMessage.createdAt.toLocal(), Units.DAY)) {
              final divider = Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Divider(),
                ),
              );

              final createdAt = Jiffy(nextMessage.createdAt.toLocal());
              final now = DateTime.now();
              final hourInfo = createdAt.format('h:mm a');

              String dayInfo;
              if (Jiffy(createdAt).isSame(now, Units.DAY)) {
                dayInfo = 'TODAY';
              } else if (Jiffy(createdAt)
                  .isSame(now.subtract(Duration(days: 1)), Units.DAY)) {
                dayInfo = 'YESTERDAY';
              } else {
                dayInfo = createdAt.format('EEEE').toUpperCase();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  messageWidget,
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        divider,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: dayInfo,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: ' AT'),
                                TextSpan(text: ' $hourInfo'),
                              ],
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context)
                                  .textTheme
                                  .title
                                  .color
                                  .withOpacity(.5),
                            ),
                          ),
                        ),
                        divider,
                      ],
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
              print((snapshot.error as Error).stackTrace.toString());
              return Center(
                child: Text(snapshot.error.toString()),
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
    Message message,
    Message nextMessage,
    StreamChannelState streamChannelState,
    BuildContext context,
  ) {
    Widget messageWidget;
    if (widget.messageBuilder != null) {
      messageWidget = Builder(
        key: ValueKey<String>('MESSAGE-${message.id}'),
        builder: (_) => widget.messageBuilder(context, message, 0),
      );
    } else {
      messageWidget = MessageWidget(
        key: ValueKey<String>('MESSAGE-${message.id}'),
        previousMessage: null,
        message: message,
        nextMessage: nextMessage,
        onThreadTap: _onThreadTap,
        showVideoFullScreen: widget.showVideoFullScreen,
        showOtherMessageUsername: widget.showOtherMessageUsername,
        onMentionTap: widget.onMentionTap,
        onMessageActions: widget.onMessageActions,
      );
    }

    return VisibilityDetector(
      key: ValueKey<String>('TOP-MESSAGE'),
      child: messageWidget,
      onVisibilityChanged: (visibility) {
        final topIsVisible = visibility.visibleBounds != Rect.zero;
        if (topIsVisible && !_topWasVisible) {
          streamChannelState.queryMessages();
        }
        _topWasVisible = topIsVisible;
      },
    );
  }

  Widget _buildBottomMessage(
    StreamChannelState streamChannel,
    Message previousMessage,
    Message message,
    BuildContext context,
  ) {
    Widget messageWidget;
    if (widget.messageBuilder != null) {
      messageWidget = Builder(
        key: ValueKey<String>('MESSAGE-${message.id}'),
        builder: (_) => widget.messageBuilder(context, message, 0),
      );
    } else {
      messageWidget = MessageWidget(
        key: ValueKey<String>('MESSAGE-${message.id}'),
        previousMessage: previousMessage,
        message: message,
        nextMessage: null,
        onThreadTap: _onThreadTap,
        showVideoFullScreen: widget.showVideoFullScreen,
        showOtherMessageUsername: widget.showOtherMessageUsername,
        onMentionTap: widget.onMentionTap,
        onMessageActions: widget.onMessageActions,
      );
    }

    return VisibilityDetector(
      key: ValueKey<String>('BOTTOM-MESSAGE'),
      onVisibilityChanged: (visibility) {
        _isBottom = visibility.visibleBounds != Rect.zero;
        if (_isBottom && streamChannel.channel.config.readEvents) {
          if (streamChannel.channel.state.unreadCount > 0) {
            streamChannel.channel.markRead();
          }
        }
      },
      child: messageWidget,
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
      stream = streamChannel.channel.state.messagesStream.map((messages) =>
          messages
              .where((m) =>
                  !(m.status == MessageSendingStatus.FAILED && m.isDeleted))
              .toList());
    } else {
      streamChannel.getReplies(widget.parentMessage.id);
      stream = streamChannel.channel.state.threadsStream
          .where((threads) => threads.containsKey(widget.parentMessage.id))
          .map((threads) => threads[widget.parentMessage.id]);
    }

    _streamListener = stream.listen((newMessages) {
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
