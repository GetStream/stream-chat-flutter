import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/message_list_view.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

import '../stream_chat_flutter.dart';
import 'stream_channel.dart';

/// Inactive state
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/message_input.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/message_input_paint.png)
/// Focused state
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/message_input2.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/message_input2_paint.png)
///
/// Widget used to enter the message and add attachments
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
/// You usually put this widget in the same page of a [MessageListView] as the bottom widget.
///
/// The widget renders the ui based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget appearance.
class MessageInput extends StatefulWidget {
  MessageInput({
    Key key,
    this.onMessageSent,
    this.parentMessage,
    this.editMessage,
  }) : super(key: key);

  /// Message to edit
  final Message editMessage;

  /// Function called after sending the message
  final void Function(Message) onMessageSent;

  /// Parent message in case of a thread
  final Message parentMessage;

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  TextEditingController _textController;
  bool _messageIsPresent = false;
  bool _typingStarted = false;
  final List<_SendingAttachment> _attachments = [];

  final _focusNode = FocusNode();

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
                  gradient: _getGradient(context),
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
                        focusNode: _focusNode,
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

  Gradient _getGradient(BuildContext context) {
    if (_typingStarted) {
      if (widget.editMessage == null) {
        return StreamChatTheme.of(context).channelTheme.inputGradient;
      }
      return LinearGradient(
        colors: [Colors.lightGreen, Colors.green],
      );
    } else {
      return null;
    }
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
                      child: _buildAttachment(attachment),
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
                    attachment.uploaded
                        ? SizedBox()
                        : Positioned.fill(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
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

  Widget _buildAttachment(_SendingAttachment attachment) {
    switch (attachment.type) {
      case FileType.IMAGE:
        return attachment.file != null
            ? Image.file(
                attachment.file,
                fit: BoxFit.cover,
              )
            : Image.network(
                attachment.url,
                fit: BoxFit.cover,
              );
        break;
      case FileType.VIDEO:
        return Container(
          child: Icon(Icons.videocam),
          color: Colors.black26,
        );
        break;
      default:
        return Container(
          child: Icon(Icons.insert_drive_file),
          color: Colors.black26,
        );
    }
  }

  Material _buildAttachmentButton() {
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      color: Colors.transparent,
      child: IconButton(
        onPressed: () {
          showModalBottomSheet(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              context: context,
              builder: (_) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Add a file',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.image),
                      title: Text('Upload a photo'),
                      onTap: () {
                        _pickFile(FileType.IMAGE, false);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.video_library),
                      title: Text('Upload a video'),
                      onTap: () {
                        _pickFile(FileType.VIDEO, false);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text('Photo from camera'),
                      onTap: () {
                        ImagePicker.pickImage(source: ImageSource.camera);
                        _pickFile(FileType.IMAGE, true);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.videocam),
                      title: Text('Video from camera'),
                      onTap: () {
                        _pickFile(FileType.VIDEO, true);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.insert_drive_file),
                      title: Text('Upload a file'),
                      onTap: () {
                        _pickFile(FileType.ANY, false);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
        },
        icon: Icon(
          Icons.add_circle_outline,
        ),
      ),
    );
  }

  void _pickFile(FileType type, bool camera) async {
    File file;

    if (camera) {
      if (type == FileType.IMAGE) {
        file = await ImagePicker.pickImage(source: ImageSource.camera);
      } else if (type == FileType.VIDEO) {
        file = await ImagePicker.pickVideo(source: ImageSource.camera);
      }
    } else {
      file = await FilePicker.getFile(type: type);
    }

    final channel = StreamChannel.of(context).channel;

    final bytes = await file.readAsBytes();

    final attachment = _SendingAttachment(
      file: file,
      type: type,
    );

    setState(() {
      _attachments.add(attachment);
    });

    final res = await channel.sendFile(
      MultipartFile.fromBytes(
        bytes,
        filename: file.path.split('/').last,
      ),
    );

    attachment.url = res.file;

    setState(() {
      attachment.uploaded = true;
    });
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

    final attachments = List<_SendingAttachment>.from(_attachments);

    _textController.clear();
    _attachments.clear();

    setState(() {
      _messageIsPresent = false;
      _typingStarted = false;
    });
    FocusScope.of(context).unfocus();

    if (widget.editMessage != null) {
      final message = widget.editMessage.copyWith(
        parentId: widget.parentMessage?.id,
        text: text,
        attachments: _getAttachments(attachments).toList(),
      );
      StreamChat.of(context).client.updateMessage(message).then((_) {
        if (widget.onMessageSent != null) {
          widget.onMessageSent(message);
        }
      });
    } else {
      final message = Message(
        parentId: widget.parentMessage?.id,
        text: text,
        attachments: _getAttachments(attachments).toList(),
      );
      StreamChannel.of(context).channel.sendMessage(message).then((_) {
        if (widget.onMessageSent != null) {
          widget.onMessageSent(message);
        }
      });
    }
  }

  Iterable<Attachment> _getAttachments(List<_SendingAttachment> attachments) {
    return attachments.map((attachment) {
      String type;
      switch (attachment.type) {
        case FileType.IMAGE:
          type = 'image';
          break;
        case FileType.VIDEO:
          type = 'video';
          break;
        default:
          type = 'file';
      }
      return Attachment(
        imageUrl: attachment.type == FileType.IMAGE ? attachment.url : null,
        assetUrl: attachment.url,
        type: type,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.editMessage != null) {
      _textController = TextEditingController(text: widget.editMessage.text);

      _typingStarted = true;
      _messageIsPresent = true;

      widget.editMessage.attachments.forEach((attachment) {
        if (attachment.type == 'image') {
          _attachments.add(_SendingAttachment(
            type: FileType.IMAGE,
            url: attachment.imageUrl,
            uploaded: true,
          ));
        }
      });
    } else {
      _textController = TextEditingController();
    }
  }

  bool _focused = false;
  @override
  void didChangeDependencies() {
    if (widget.editMessage != null && !_focused) {
      FocusScope.of(context).requestFocus(_focusNode);
      _focused = true;
    }
    super.didChangeDependencies();
  }
}

class _SendingAttachment {
  final File file;
  final FileType type;
  String url;
  bool uploaded;

  _SendingAttachment({
    this.url,
    this.file,
    this.type,
    this.uploaded = false,
  });
}
