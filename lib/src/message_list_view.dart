import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:stream_chat/stream_chat.dart';

import 'message_widget.dart';
import 'stream_channel.dart';

typedef MessageBuilder = Widget Function(BuildContext, Message, int index);
typedef ParentMessageBuilder = Widget Function(BuildContext, Message);
typedef ParentTapCallback = void Function(Message parent);

class MessageListView extends StatefulWidget {
  MessageListView({
    Key key,
    MessageBuilder messageBuilder,
    this.parentMessageBuilder,
    this.parentMessage,
    this.parentTapCallback,
  })  : _messageBuilder = messageBuilder,
        super(key: key);

  final MessageBuilder _messageBuilder;
  final ParentMessageBuilder parentMessageBuilder;
  final ParentTapCallback parentTapCallback;
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
            if (i == this._messages.length + 1) {
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
                        parentTapCallback: widget.parentTapCallback,
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
                return SizedBox.fromSize(
                  size: Size.zero,
                );
              }
            }

            if (i == this._messages.length) {
              return _buildLoadingIndicator(streamChannel);
            }
            final message = this._messages[i];

            if (widget._messageBuilder != null) {
              return widget._messageBuilder(context, message, i);
            }

            final previousMessage =
                i < this._messages.length - 1 ? this._messages[i + 1] : null;
            final nextMessage = i > 0 ? this._messages[i - 1] : null;

            if (i == 0) {
              return _buildBottomMessage(
                streamChannel,
                previousMessage,
                message,
                context,
              );
            }

            if (i == this._messages.length - 1) {
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
              parentTapCallback: widget.parentTapCallback,
            );
          },
          childCount: this._messages.length + 2,
          findChildIndexCallback: (key) {
            final ValueKey<String> valueKey = key;
            final index = this
                ._messages
                .indexWhere((m) => 'MESSAGE-${m.id}' == valueKey.value);
            return index != -1 ? index : null;
          },
        ),
      ),
    );
  }

  Container _buildLoadingIndicator(StreamChannel streamChannel) {
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
    StreamChannel channelBloc,
    BuildContext context,
  ) {
    return VisibilityDetector(
      key: ValueKey<String>('TOP-MESSAGE'),
      child: MessageWidget(
        key: ValueKey<String>('MESSAGE-${message.id}'),
        previousMessage: null,
        message: message,
        nextMessage: nextMessage,
        parentTapCallback: widget.parentTapCallback,
      ),
      onVisibilityChanged: (visibility) {
        final topIsVisible = visibility.visibleBounds != Rect.zero;
        if (topIsVisible && !_topWasVisible) {
          channelBloc.queryMessages();
        }
        _topWasVisible = topIsVisible;
      },
    );
  }

  Widget _buildBottomMessage(
    StreamChannel channelBloc,
    Message previousMessage,
    Message message,
    BuildContext context,
  ) {
    return VisibilityDetector(
      key: ValueKey<String>('BOTTOM-MESSAGE'),
      onVisibilityChanged: (visibility) {
        this._isBottom = visibility.visibleBounds != Rect.zero;
        if (this._isBottom) {
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
        parentTapCallback: widget.parentTapCallback,
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
            this._messages = newMessages;
          });
        } else if (newMessages.first.user.id ==
            streamChannel.channelClient.client.user.id) {
          _scrollController.jumpTo(0);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              this._messages = newMessages;
            });
          });
        } else {
          _newMessageList = newMessages;
        }
      } else {
        setState(() {
          this._messages = newMessages;
        });
      }
    });
  }

  @override
  void dispose() {
    _streamListener.cancel();
    super.dispose();
  }
}
