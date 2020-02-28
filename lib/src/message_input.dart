import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
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
  final List<_SendingAttachment> _attachments = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned.fill(
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
                      color: StreamChatTheme.of(context)
                          .channelTheme
                          .inputBackground,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: _typingStarted
                              ? Colors.transparent
                              : Colors.black.withOpacity(.2)),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAttachments(),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    _buildAttachmentButton(),
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
                      crossFadeState:
                          (_messageIsPresent || _attachments.isNotEmpty)
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                      firstChild: _buildSendButton(context),
                      secondChild: SizedBox(),
                      duration: Duration(milliseconds: 300),
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachments() {
    return Wrap(
      direction: Axis.horizontal,
      children: _attachments
          .map(
            (attachment) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      child: Image.file(attachment.file),
                    ),
                    Positioned(
                      height: 16,
                      width: 16,
                      top: 4,
                      right: 4,
                      child: RawMaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        highlightElevation: 0,
                        focusElevation: 0,
                        disabledElevation: 0,
                        hoverElevation: 0,
                        onPressed: () {
                          setState(() {
                            _attachments.remove(attachment);
                          });
                        },
                        fillColor: Colors.white.withOpacity(.5),
                        child: Center(
                          child: Icon(
                            Icons.close,
                            size: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Material _buildAttachmentButton() {
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      color: Colors.transparent,
      child: IconButton(
        onPressed: () async {
          final file = await FilePicker.getFile(type: FileType.IMAGE);
          print(file.path);

          final channel = StreamChannel.of(context).channel;

          final bytes = await file.readAsBytes();
          final res = await channel.sendFile(MultipartFile.fromBytes(
            bytes,
            filename: file.path.split('/').last,
          ));

          setState(() {
            _attachments.add(_SendingAttachment(
              url: res.file,
              extension: file.path.split('.').last,
              file: file,
            ));
          });
        },
        icon: Icon(
          Icons.add_circle_outline,
        ),
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return IconTheme(
      data:
          StreamChatTheme.of(context).channelTheme.messageInputButtonIconTheme,
      child: Material(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        color: Colors.transparent,
        child: IconButton(
          onPressed: () {
            _sendMessage(context);
          },
          icon: Icon(
            Icons.send,
          ),
        ),
      ),
    );
  }

  void _sendMessage(BuildContext context) {
    final text = _textController.text.trim();
    if (text.isEmpty && _attachments.isEmpty) {
      return;
    }

    final attachments = List.from(_attachments);

    _textController.clear();
    _attachments.clear();

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
            attachments: attachments.map((attachment) {
              return Attachment(
                imageUrl: attachment.url,
                assetUrl: attachment.url,
                type: 'image',
              );
            }).toList(),
          ),
        )
        .then((_) {
      if (widget.onMessageSent != null) {
        widget.onMessageSent(Message(text: text));
      }
    });
  }
}

class _SendingAttachment {
  final String url;
  final String extension;
  final File file;

  _SendingAttachment({
    this.url,
    this.extension,
    this.file,
  });
}
