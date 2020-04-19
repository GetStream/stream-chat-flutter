import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/message_list_view.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/user_avatar.dart';

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
    this.maxHeight = 150,
    this.keyboardType = TextInputType.multiline,
    this.disableAttachments = false,
  }) : super(key: key);

  /// Message to edit
  final Message editMessage;

  /// Function called after sending the message
  final void Function(Message) onMessageSent;

  /// Parent message in case of a thread
  final Message parentMessage;

  /// Maximum Height for the TextField to grow before it starts scrolling
  final double maxHeight;

  /// The keyboard type assigned to the TextField
  final TextInputType keyboardType;

  /// If true the attachments button will not be displayed
  final bool disableAttachments;

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final List<_SendingAttachment> _attachments = [];
  final _focusNode = FocusNode();
  final List<User> _mentionedUsers = [];

  TextEditingController _textController;
  bool _inputEnabled = true;
  bool _messageIsPresent = false;
  bool _typingStarted = false;
  OverlayEntry _commandsOverlay, _mentionsOverlay;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dy > 0) {
            _focusNode.unfocus();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              _buildBorder(context),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAttachments(),
                  _buildTextField(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Flex _buildTextField(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (!widget.disableAttachments) _buildAttachmentButton(),
        _buildTextInput(context),
        _animateSendButton(context),
      ],
    );
  }

  AnimatedCrossFade _animateSendButton(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState: ((_messageIsPresent || _attachments.isNotEmpty) &&
              _attachments.every((a) => a.uploaded == true))
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: _buildSendButton(context),
      secondChild: SizedBox(),
      duration: Duration(milliseconds: 300),
      alignment: Alignment.center,
    );
  }

  Expanded _buildTextInput(BuildContext context) {
    return Expanded(
      child: LimitedBox(
        maxHeight: widget.maxHeight,
        child: TextField(
          key: Key('messageInputText'),
          enabled: _inputEnabled,
          minLines: null,
          maxLines: null,
          onSubmitted: (_) {
            _sendMessage(context);
          },
          keyboardType: widget.keyboardType,
          controller: _textController,
          focusNode: _focusNode,
          onChanged: (s) {
            StreamChannel.of(context).channel.keyStroke();

            setState(() {
              _messageIsPresent = s.trim().isNotEmpty;
            });

            _commandsOverlay?.remove();
            _commandsOverlay = null;
            _mentionsOverlay?.remove();
            _mentionsOverlay = null;

            if (s.startsWith('/')) {
              _commandsOverlay = _buildCommandsOverlayEntry();
              Overlay.of(context).insert(_commandsOverlay);
            }

            if (_textController.selection.isCollapsed &&
                (s[_textController.selection.start - 1] == '@' ||
                    _textController.text
                        .substring(0, _textController.selection.start)
                        .split(' ')
                        .last
                        .contains('@'))) {
              _mentionsOverlay = _buildMentionsOverlayEntry();
              Overlay.of(context).insert(_mentionsOverlay);
            }
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
    );
  }

  Positioned _buildBorder(BuildContext context) {
    return Positioned.fill(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: _getGradient(context),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: StreamChatTheme.of(context)
                .channelTheme
                .inputBackground
                .withAlpha(255),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: StreamChatTheme.of(context).channelTheme.inputBackground,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                  color: _typingStarted
                      ? Colors.transparent
                      : Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(.2)
                          : Colors.black.withOpacity(.2)),
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry _buildCommandsOverlayEntry() {
    final text = _textController.text;
    final commands = StreamChannel.of(context)
        .channel
        .config
        .commands
        .where((c) => c.name.contains(text.replaceFirst('/', '')))
        .toList();

    RenderBox renderBox = context.findRenderObject();
    final size = renderBox.size;

    return OverlayEntry(builder: (context) {
      return Positioned(
        bottom: size.height + MediaQuery.of(context).viewInsets.bottom,
        left: 0,
        right: 0,
        child: Material(
          color: StreamChatTheme.of(context).primaryColor,
          child: Container(
            constraints: BoxConstraints.loose(Size.fromHeight(400)),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  spreadRadius: -8,
                  blurRadius: 5.0,
                  offset: Offset(0, -4),
                ),
              ],
              color: StreamChatTheme.of(context).primaryColor,
            ),
            child: ListView(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              children: commands
                  .map(
                    (c) => ListTile(
                      title: Text.rich(
                        TextSpan(
                          text: '${c.name}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: ' ${c.args}',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Text(c.description),
                      onTap: () {
                        _setCommand(c);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );
    });
  }

  OverlayEntry _buildMentionsOverlayEntry() {
    final splits = _textController.text
        .substring(0, _textController.value.selection.start)
        .split('@');
    final query = splits.last.toLowerCase();

    final members = StreamChannel.of(context).channel.state.members?.where((m) {
          return m.user.name.toLowerCase().contains(query);
        })?.toList() ??
        [];

    RenderBox renderBox = context.findRenderObject();
    final size = renderBox.size;

    return OverlayEntry(builder: (context) {
      return Positioned(
        bottom: size.height + MediaQuery.of(context).viewInsets.bottom,
        left: 0,
        right: 0,
        child: Material(
          color: StreamChatTheme.of(context).primaryColor,
          child: Container(
            constraints: BoxConstraints.loose(Size.fromHeight(400)),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  spreadRadius: -8,
                  blurRadius: 5.0,
                  offset: Offset(0, -4),
                ),
              ],
              color: StreamChatTheme.of(context).primaryColor,
            ),
            child: ListView(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              children: members
                  .map((m) => ListTile(
                        leading: UserAvatar(
                          user: m.user,
                        ),
                        title: Text('${m.user.name}'),
                        onTap: () {
                          _mentionedUsers.add(m.user);

                          splits[splits.length - 1] = m.user.name;
                          final rejoin = splits.join('@');

                          _textController.value = TextEditingValue(
                            text: rejoin +
                                _textController.text
                                    .substring(_textController.selection.start),
                            selection: TextSelection.collapsed(
                              offset: rejoin.length,
                            ),
                          );

                          _mentionsOverlay?.remove();
                          _mentionsOverlay = null;
                        },
                      ))
                  .toList(),
            ),
          ),
        ),
      );
    });
  }

  void _setCommand(Command c) {
    _textController.value = TextEditingValue(
      text: '/${c.name} ',
      selection: TextSelection.collapsed(
        offset: c.name.length + 2,
      ),
    );
    _commandsOverlay?.remove();
    _commandsOverlay = null;
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
      case FileType.image:
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
      case FileType.video:
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
          _showAttachmentModal();
        },
        icon: Icon(
          Icons.add_circle_outline,
        ),
      ),
    );
  }

  void _showAttachmentModal() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }

    showModalBottomSheet(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        context: context,
        isScrollControlled: true,
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
                  _pickFile(FileType.image, false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.video_library),
                title: Text('Upload a video'),
                onTap: () {
                  _pickFile(FileType.video, false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Photo from camera'),
                onTap: () {
                  _pickFile(FileType.image, true);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Video from camera'),
                onTap: () {
                  _pickFile(FileType.video, true);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text('Upload a file'),
                onTap: () {
                  _pickFile(FileType.any, false);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _pickFile(FileType type, bool camera) async {
    setState(() {
      _inputEnabled = false;
    });

    File file;

    if (camera) {
      if (type == FileType.image) {
        file = await ImagePicker.pickImage(source: ImageSource.camera);
      } else if (type == FileType.video) {
        file = await ImagePicker.pickVideo(source: ImageSource.camera);
      }
    } else {
      file = await FilePicker.getFile(type: type);
    }

    setState(() {
      _inputEnabled = true;
    });

    if (file == null) {
      return;
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

    String url;
    final filename = file.path.split('/').last;

    if (type == FileType.image) {
      final res = await channel.sendImage(
        MultipartFile.fromBytes(
          bytes,
          filename: filename,
          contentType: MediaType.parse(lookupMimeType(filename)),
        ),
      );
      url = res.file;
    } else {
      final res = await channel.sendFile(
        MultipartFile.fromBytes(
          bytes,
          filename: filename,
          contentType: MediaType.parse(lookupMimeType(filename)),
        ),
      );
      url = res.file;
    }

    attachment.url = url;

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
          key: Key('sendButton'),
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

    _commandsOverlay?.remove();
    _commandsOverlay = null;
    _mentionsOverlay?.remove();
    _mentionsOverlay = null;

    final channel = StreamChannel.of(context).channel;

    Future sendingFuture;
    Message message;
    if (widget.editMessage != null) {
      message = widget.editMessage.copyWith(
        parentId: widget.parentMessage?.id,
        text: text,
        attachments: widget.editMessage.attachments
                .where((attachment) => attachment.type == 'giphy')
                .toList() +
            _getAttachments(attachments).toList(),
        mentionedUsers:
            _mentionedUsers.where((u) => text.contains('@${u.name}')).toList(),
      );

      if (widget.editMessage.status == MessageSendingStatus.FAILED) {
        sendingFuture = channel.sendMessage(message);
      }

      sendingFuture = StreamChat.of(context).client.updateMessage(message);
    } else {
      message = Message(
        parentId: widget.parentMessage?.id,
        text: text,
        attachments: _getAttachments(attachments).toList(),
        mentionedUsers:
            _mentionedUsers.where((u) => text.contains('@${u.name}')).toList(),
      );
      sendingFuture = channel.sendMessage(message);
    }

    sendingFuture.whenComplete(() {
      if (widget.onMessageSent != null) {
        widget.onMessageSent(message);
      }
    });
  }

  Iterable<Attachment> _getAttachments(List<_SendingAttachment> attachments) {
    return attachments.map((attachment) {
      String type;
      switch (attachment.type) {
        case FileType.image:
          type = 'image';
          break;
        case FileType.video:
          type = 'video';
          break;
        default:
          type = 'file';
      }
      return Attachment(
        imageUrl: attachment.type == FileType.image ? attachment.url : null,
        assetUrl: attachment.url,
        type: type,
      );
    });
  }

  StreamSubscription _keyboardListener;

  @override
  void initState() {
    super.initState();

    StreamChannel.of(context).queryMembersAndWatchers();

    _keyboardListener = KeyboardVisibility.onChange.listen((visible) {
      if (visible) {
        if (_commandsOverlay != null) {
          if (_textController.text.startsWith('/')) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _commandsOverlay = _buildCommandsOverlayEntry();
              Overlay.of(context).insert(_commandsOverlay);
            });
          }
        }

        if (_mentionsOverlay != null) {
          if (_textController.text.contains('@')) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _mentionsOverlay = _buildCommandsOverlayEntry();
              Overlay.of(context).insert(_mentionsOverlay);
            });
          }
        }
      } else {
        if (_commandsOverlay != null) {
          _commandsOverlay.remove();
        }
        if (_mentionsOverlay != null) {
          _mentionsOverlay.remove();
        }
      }
    });

    if (widget.editMessage != null) {
      _textController = TextEditingController(text: widget.editMessage.text);

      _typingStarted = true;
      _messageIsPresent = true;

      widget.editMessage.attachments.forEach((attachment) {
        if (attachment.type == 'image') {
          _attachments.add(_SendingAttachment(
            type: FileType.image,
            url: attachment.imageUrl ??
                attachment.assetUrl ??
                attachment.thumbUrl ??
                attachment.ogScrapeUrl,
            uploaded: true,
          ));
        } else if (attachment.type == 'video') {
          _attachments.add(_SendingAttachment(
            type: FileType.video,
            url: attachment.assetUrl,
            uploaded: true,
          ));
        } else if (attachment.type != 'giphy') {
          _attachments.add(_SendingAttachment(
            type: FileType.any,
            url: attachment.assetUrl,
            uploaded: true,
          ));
        }
      });
    } else {
      _textController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _commandsOverlay?.remove();
    _mentionsOverlay?.remove();
    _keyboardListener.cancel();
    super.dispose();
  }

  bool _initialized = false;
  @override
  void didChangeDependencies() {
    if (widget.editMessage != null && !_initialized) {
      FocusScope.of(context).requestFocus(_focusNode);
      _initialized = true;
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
