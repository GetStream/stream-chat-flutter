import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

import 'stream_channel.dart';

class MessageInput extends StatefulWidget {
  MessageInput({
    Key key,
    this.onMessageSent,
    this.parentMessage,
  }) : super(key: key);

  final void Function(Message) onMessageSent;
  final Message parentMessage;

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _textController = TextEditingController();
  bool _messageIsPresent = false;
  bool _typingStarted = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            gradient: _typingStarted
                ? StreamChatTheme.of(context).channelTheme.inputGradient
                : null,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: StreamChatTheme.of(context).channelTheme.inputBackground,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                    color: _typingStarted
                        ? Colors.transparent
                        : Colors.black.withOpacity(.2)),
              ),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      minLines: null,
                      maxLines: null,
                      onSubmitted: (_) {
                        _sendMessage(context);
                      },
                      controller: _textController,
                      onChanged: (s) {
                        StreamChannel.of(context).channel.keyStroke();
                        setState(() {
                          _messageIsPresent = s.trim().isNotEmpty;
                        });
                      },
                      onTap: () {
                        setState(() {
                          _typingStarted = true;
                        });
                      },
                      style: Theme.of(context).textTheme.body1,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Write a message',
                        prefixText: '   ',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    crossFadeState: _messageIsPresent
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: _buildSendButton(context),
                    secondChild: SizedBox(),
                    duration: Duration(milliseconds: 300),
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return IconTheme(
      data:
          StreamChatTheme.of(context).channelTheme.messageInputButtonIconTheme,
      child: IconButton(
        onPressed: () {
          _sendMessage(context);
        },
        icon: Icon(
          Icons.send,
        ),
      ),
    );
  }

  void _sendMessage(BuildContext context) {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      return;
    }

    _textController.clear();
    setState(() {
      _messageIsPresent = false;
      _typingStarted = false;
    });
    FocusScope.of(context).unfocus();

    StreamChannel.of(context)
        .channel
        .sendMessage(
          Message(
            parentId: widget.parentMessage?.id,
            text: text,
          ),
        )
        .then((_) {
      if (widget.onMessageSent != null) {
        widget.onMessageSent(Message(text: text));
      }
    });
  }
}
