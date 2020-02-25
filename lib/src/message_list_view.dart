import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:stream_chat/stream_chat.dart';

import 'message_widget.dart';
import 'stream_channel.dart';

typedef MessageBuilder = Widget Function(BuildContext, Message, int index);
typedef ParentMessageBuilder = Widget Function(BuildContext, Message);
typedef ThreadBuilder = Widget Function(BuildContext context, Message parent);
typedef ThreadTapCallback = void Function(Message, Widget);

class MessageListView extends StatefulWidget {
  MessageListView({
    Key key,
    this.messageBuilder,
    this.parentMessageBuilder,
    this.parentMessage,
    this.threadBuilder,
    this.onThreadTap,
  }) : super(key: key);

  final MessageBuilder messageBuilder;
  final ParentMessageBuilder parentMessageBuilder;
  final ThreadBuilder threadBuilder;
  final ThreadTapCallback onThreadTap;
  final Message parentMessage;

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
        physics: AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        reverse: true,
        childrenDelegate: SliverChildBuilderDelegate(
          (context, i) {
            if (i == _messages.length + 1) {
              if (widget.parentMessage != null) {
                if (widget.parentMessageBuilder != null) {
                  return widget.parentMessageBuilder(
                      context, widget.parentMessage);
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      MessageWidget(
                        key: ValueKey<String>(
                            'PARENT-MESSAGE-${widget.parentMessage.id}'),
                        previousMessage: null,
                        message: widget.parentMessage.copyWith(replyCount: 0),
                        nextMessage: null,
                        onThreadTap: _onThreadTap,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Start of a new thread',
                            textAlign: TextAlign.center,
                          ),
                          color: Theme.of(context).primaryColorLight,
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

            if (widget.messageBuilder != null) {
              return widget.messageBuilder(context, message, i);
            }

            final previousMessage =
                i < _messages.length - 1 ? _messages[i + 1] : null;
            final nextMessage = i > 0 ? _messages[i - 1] : null;

            if (i == 0) {
              return _buildBottomMessage(
                streamChannel,
                previousMessage,
                message,
                context,
              );
            }

            if (i == _messages.length - 1) {
              return _buildTopMessage(
                message,
                nextMessage,
                streamChannel,
                context,
              );
            }

            return MessageWidget(
              key: ValueKey<String>('MESSAGE-${message.id}'),
              previousMessage: previousMessage,
              message: message,
              nextMessage: nextMessage,
              onThreadTap: _onThreadTap,
            );
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
    return VisibilityDetector(
      key: ValueKey<String>('TOP-MESSAGE'),
      child: MessageWidget(
        key: ValueKey<String>('MESSAGE-${message.id}'),
        previousMessage: null,
        message: message,
        nextMessage: nextMessage,
        onThreadTap: _onThreadTap,
      ),
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
    StreamChannelState channelBloc,
    Message previousMessage,
    Message message,
    BuildContext context,
  ) {
    return VisibilityDetector(
      key: ValueKey<String>('BOTTOM-MESSAGE'),
      onVisibilityChanged: (visibility) {
        _isBottom = visibility.visibleBounds != Rect.zero;
        if (_isBottom) {
          if (channelBloc.channelClient.state.unreadCount > 0) {
            channelBloc.channelClient.markRead();
          }
        }
      },
      child: MessageWidget(
        key: ValueKey<String>('MESSAGE-${message.id}'),
        previousMessage: previousMessage,
        message: message,
        nextMessage: null,
        onThreadTap: _onThreadTap,
      ),
    );
  }

  StreamSubscription _streamListener;

  @override
  void initState() {
    super.initState();

    final streamChannel = StreamChannel.of(context);
    if (streamChannel.channelClient.state.unreadCount > 0) {
      streamChannel.channelClient.markRead();
    }

    Stream<List<Message>> stream;

    if (widget.parentMessage == null) {
      stream = streamChannel.channelStateStream.map((c) => c.messages);
    } else {
      streamChannel.getReplies(widget.parentMessage.id);
      stream = streamChannel.channelClient.state.threadsStream
          .where((threads) => threads.containsKey(widget.parentMessage.id))
          .map((threads) => threads[widget.parentMessage.id]);
    }

    _streamListener = stream.listen((newMessages) {
      newMessages = newMessages.reversed.toList();
      if (_messages.isEmpty || newMessages.first.id != _messages.first.id) {
        if (!_scrollController.hasClients ||
            _scrollController.offset < _newMessageLoadingOffset) {
          setState(() {
            _messages = newMessages;
          });
        } else if (newMessages.first.user.id ==
            streamChannel.channelClient.client.state.user.id) {
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
      _onThreadTap = (message) {
        widget.onThreadTap(
            message,
            widget.threadBuilder != null
                ? widget.threadBuilder(context, message)
                : null);
      };
    } else {
      _onThreadTap = (message) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) {
            return StreamChannel(
              channelClient: StreamChannel.of(context).channelClient,
              child: widget.threadBuilder(context, message),
            );
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
