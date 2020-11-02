import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/message_list_view.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/user_avatar.dart';

import '../stream_chat_flutter.dart';
import 'stream_channel.dart';

typedef FileUploader = Future<String> Function(PlatformFile, Channel);
typedef AttachmentThumbnailBuilder = Widget Function(
  BuildContext,
  _SendingAttachment,
);

enum ActionsLocation {
  left,
  right,
}

enum DefaultAttachmentTypes {
  image,
  video,
  file,
}

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
  /// Instantiate a new MessageInput
  MessageInput({
    Key key,
    this.onMessageSent,
    this.preMessageSending,
    this.parentMessage,
    this.editMessage,
    this.maxHeight = 150,
    this.keyboardType = TextInputType.multiline,
    this.disableAttachments = false,
    this.doImageUploadRequest,
    this.doFileUploadRequest,
    this.initialMessage,
    this.textEditingController,
    this.actions,
    this.actionsLocation = ActionsLocation.left,
    this.attachmentThumbnailBuilders,
  }) : super(key: key);

  /// Message to edit
  final Message editMessage;

  /// Message to start with
  final Message initialMessage;

  /// Function called after sending the message
  final void Function(Message) onMessageSent;

  /// Function called right before sending the message
  /// Use this to transform the message
  final FutureOr<Message> Function(Message) preMessageSending;

  /// Parent message in case of a thread
  final Message parentMessage;

  /// Maximum Height for the TextField to grow before it starts scrolling
  final double maxHeight;

  /// The keyboard type assigned to the TextField
  final TextInputType keyboardType;

  /// If true the attachments button will not be displayed
  final bool disableAttachments;

  /// Override image upload request
  final FileUploader doImageUploadRequest;

  /// Override file upload request
  final FileUploader doFileUploadRequest;

  /// The text controller of the TextField
  final TextEditingController textEditingController;

  /// List of action widgets
  final List<Widget> actions;

  /// The location of the custom actions
  final ActionsLocation actionsLocation;

  /// Map that defines a thumbnail builder for an attachment type
  final Map<String, AttachmentThumbnailBuilder> attachmentThumbnailBuilders;

  @override
  MessageInputState createState() => MessageInputState();

  /// Use this method to get the current [StreamChatState] instance
  static MessageInputState of(BuildContext context) {
    MessageInputState messageInputState;

    messageInputState = context.findAncestorStateOfType<MessageInputState>();

    if (messageInputState == null) {
      throw Exception(
          'You must have a MessageInput widget as anchestor of your widget tree');
    }

    return messageInputState;
  }
}

class MessageInputState extends State<MessageInput> {
  final List<_SendingAttachment> _attachments = [];
  final _focusNode = FocusNode();
  final List<User> _mentionedUsers = [];

  final _imagePicker = ImagePicker();
  bool _inputEnabled = true;
  bool _messageIsPresent = false;
  bool _typingStarted = false;
  bool _commandEnabled = false;
  OverlayEntry _commandsOverlay, _mentionsOverlay, _emojiOverlay;
  Fuzzy _emojiFuse;

  Command _chosenCommand;
  bool _actionsShrunk = false;
  bool _sendAsDm = false;

  /// The editing controller passed to the input TextField
  TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dy > 0) {
            _focusNode.unfocus();
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildTextField(context),
            ),
            if (widget.parentMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildDmCheckbox(),
              ),
          ],
        ),
      ),
    );
  }

  Flex _buildTextField(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (!_commandEnabled) _buildExpandActionsButton(),
        if (widget.actionsLocation == ActionsLocation.left)
          ...widget.actions ?? [],
        _buildTextInput(context),
        _animateSendButton(context),
        if (widget.actionsLocation == ActionsLocation.right)
          ...widget.actions ?? [],
      ],
    );
  }

  Widget _buildDmCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _sendAsDm,
          onChanged: (val) => setState(
            () {
              _sendAsDm = val;
            },
          ),
          activeColor: StreamChatTheme.of(context).accentColor,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('Send also as direct message'),
        ),
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
      secondChild: _buildIdleSendButton(context),
      duration: Duration(milliseconds: 300),
      alignment: Alignment.center,
    );
  }

  Widget _buildExpandActionsButton() {
    return AnimatedCrossFade(
      crossFadeState:
          _actionsShrunk ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: IconButton(
        onPressed: () {
          setState(() {
            _actionsShrunk = false;
          });
        },
        icon: Icon(
          StreamIcons.circle_left,
          color: StreamChatTheme.of(context).accentColor,
        ),
      ),
      secondChild: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (!widget.disableAttachments) _buildAttachmentButton(),
          if (widget.editMessage == null) _buildCommandButton(),
        ],
      ),
      duration: Duration(milliseconds: 300),
      alignment: Alignment.center,
    );
  }

  Expanded _buildTextInput(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.0),
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAttachments(),
              LimitedBox(
                maxHeight: widget.maxHeight,
                child: TextField(
                  key: Key('messageInputText'),
                  enabled: _inputEnabled,
                  minLines: null,
                  maxLines: null,
                  onSubmitted: (_) {
                    sendMessage();
                  },
                  keyboardType: widget.keyboardType,
                  controller: textEditingController,
                  focusNode: _focusNode,
                  onChanged: (s) {
                    StreamChannel.of(context).channel.keyStroke();

                    setState(() {
                      _messageIsPresent = s.trim().isNotEmpty;
                      _actionsShrunk = s.trim().isNotEmpty;
                    });

                    _commandsOverlay?.remove();
                    _commandsOverlay = null;
                    _mentionsOverlay?.remove();
                    _mentionsOverlay = null;
                    _emojiOverlay?.remove();
                    _emojiOverlay = null;

                    if (s.startsWith('/')) {
                      var matchedCommandsList = StreamChannel.of(context)
                          .channel
                          .config
                          .commands
                          .where((element) => element.name == s.substring(1))
                          .toList();

                      if (matchedCommandsList.length == 1) {
                        _chosenCommand = matchedCommandsList[0];
                        textEditingController.clear();
                        _messageIsPresent = false;
                        setState(() {
                          _commandEnabled = true;
                        });
                        _commandsOverlay.remove();
                        _commandsOverlay = null;
                      } else {
                        _commandsOverlay = _buildCommandsOverlayEntry();
                        Overlay.of(context).insert(_commandsOverlay);
                      }
                    }

                    if (textEditingController.selection.isCollapsed &&
                        (s[textEditingController.selection.start - 1] == '@' ||
                            textEditingController.text
                                .substring(
                                    0, textEditingController.selection.start)
                                .split(' ')
                                .last
                                .contains('@'))) {
                      _mentionsOverlay = _buildMentionsOverlayEntry();
                      Overlay.of(context).insert(_mentionsOverlay);
                    }

                    if (textEditingController.selection.isCollapsed &&
                        (s[textEditingController.selection.start - 1] == ':' ||
                            textEditingController.text
                                .substring(
                                  0,
                                  textEditingController.selection.start,
                                )
                                .split(' ')
                                .last
                                .contains(':'))) {
                      _emojiOverlay = _buildEmojiOverlay();

                      if (_emojiOverlay != null) {
                        Overlay.of(context).insert(_emojiOverlay);
                      }
                    }
                  },
                  onTap: () {
                    setState(() {
                      _typingStarted = true;
                    });
                  },
                  style: Theme.of(context).textTheme.bodyText2,
                  autofocus: false,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText:
                        (_commandEnabled && _chosenCommand.name == 'giphy')
                            ? 'Search GIFs'
                            : 'Write a message',
                    prefixText: _commandEnabled ? null : '   ',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    contentPadding: EdgeInsets.all(8),
                    prefixIcon: _commandEnabled
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Chip(
                              backgroundColor:
                                  StreamChatTheme.of(context).accentColor,
                              label: Text(
                                _chosenCommand?.name ?? "",
                                style: TextStyle(color: Colors.white),
                              ),
                              avatar: Icon(
                                StreamIcons.lightning,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : null,
                    suffixIcon: _commandEnabled
                        ? IconButton(
                            icon: Icon(Icons.cancel_outlined),
                            onPressed: () {
                              setState(() {
                                _commandEnabled = false;
                              });
                            },
                          )
                        : null,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  OverlayEntry _buildCommandsOverlayEntry() {
    final text = textEditingController.text;
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: StreamChatTheme.of(context).primaryColor,
            clipBehavior: Clip.antiAlias,
            child: Container(
              constraints: BoxConstraints.loose(Size.fromHeight(400)),
              decoration: BoxDecoration(
                  color: StreamChatTheme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8.0)),
              child: ListView(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                children: [
                  if (commands.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(StreamIcons.lightning,
                                color: StreamChatTheme.of(context).accentColor),
                          ),
                          Text('Instant Commands')
                        ],
                      ),
                    ),
                  ...commands
                      .map(
                        (c) => ListTile(
                          leading: c.name == 'giphy'
                              ? CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Image.asset(
                                    'images/giphy_icon.png',
                                    package: 'stream_chat_flutter',
                                    width: 16.0,
                                    height: 16.0,
                                  ),
                                  maxRadius: 12.0,
                                )
                              : null,
                          title: Text.rich(
                            TextSpan(
                              text: '${c.name.capitalize()}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: ' /${c.name} ${c.args}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: CircleAvatar(
                            backgroundColor:
                                StreamChatTheme.of(context).accentColor,
                            child: Icon(
                              StreamIcons.lightning,
                              color: Colors.white,
                              size: 12.5,
                            ),
                            maxRadius: 12,
                          ),
                          //subtitle: Text(c.description),
                          onTap: () {
                            _setCommand(c);
                          },
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  OverlayEntry _buildMentionsOverlayEntry() {
    final splits = textEditingController.text
        .substring(0, textEditingController.value.selection.start)
        .split('@');
    final query = splits.last.toLowerCase();

    Future<List<Member>> queryMembers;

    if (query.isNotEmpty) {
      queryMembers = StreamChannel.of(context).channel.queryMembers(filter: {
        'name': {
          '\$autocomplete': query,
        },
      }).then((res) => res.members);
    }

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
        child: Card(
          margin: EdgeInsets.all(8.0),
          elevation: 2.0,
          color: StreamChatTheme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          clipBehavior: Clip.antiAlias,
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
            child: FutureBuilder<List<Member>>(
                future: queryMembers ?? Future.value(members),
                initialData: members,
                builder: (context, snapshot) {
                  return ListView(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    children: snapshot.data
                        .map((m) => ListTile(
                              leading: UserAvatar(
                                user: m.user,
                              ),
                              title: Text(
                                '${m.user.name}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('@${m.userId}'),
                              trailing: Icon(
                                StreamIcons.at_mention,
                                color: StreamChatTheme.of(context).accentColor,
                              ),
                              onTap: () {
                                _mentionedUsers.add(m.user);

                                splits[splits.length - 1] = m.user.name;
                                final rejoin = splits.join('@');

                                textEditingController.value = TextEditingValue(
                                  text: rejoin +
                                      textEditingController.text.substring(
                                          textEditingController
                                              .selection.start),
                                  selection: TextSelection.collapsed(
                                    offset: rejoin.length,
                                  ),
                                );

                                _mentionsOverlay?.remove();
                                _mentionsOverlay = null;
                              },
                            ))
                        .toList(),
                  );
                }),
          ),
        ),
      );
    });
  }

  OverlayEntry _buildEmojiOverlay() {
    final splits = textEditingController.text
        .substring(0, textEditingController.value.selection.start)
        .split(':');
    final query = splits.last.toLowerCase();

    if (query.isEmpty) {
      return null;
    }

    final parser = EmojiParser();
    final emojis =
        _emojiFuse.search(query).map((e) => parser.get(e.item)).toList();

    RenderBox renderBox = context.findRenderObject();
    final size = renderBox.size;

    return OverlayEntry(builder: (context) {
      return Positioned(
        bottom: size.height + MediaQuery.of(context).viewInsets.bottom,
        left: 0,
        right: 0,
        child: Card(
          margin: EdgeInsets.all(8.0),
          elevation: 2.0,
          color: StreamChatTheme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            constraints: BoxConstraints.loose(Size.fromHeight(200)),
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
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          StreamIcons.smile,
                          color: StreamChatTheme.of(context).accentColor,
                        ),
                      ),
                      Text(
                        'Emoji matching "$query"',
                        style: TextStyle(
                          color: Colors.black.withOpacity(.5),
                        ),
                      )
                    ],
                  ),
                ),
                ...emojis.map((emoji) => ListTile(
                      title: Text(
                        "${emoji.code} ${emoji.name.replaceAll('_', ' ')}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                        ),
                      ),
                      onTap: () {
                        splits[splits.length - 1] = emoji.code;
                        final rejoin = splits.join('');

                        textEditingController.value = TextEditingValue(
                          text: rejoin +
                              textEditingController.text.substring(
                                  textEditingController.selection.start),
                          selection: TextSelection.collapsed(
                            offset: rejoin.length,
                          ),
                        );

                        _emojiOverlay?.remove();
                        _emojiOverlay = null;
                      },
                    ))
              ],
            ),
          ),
        ),
      );
    });
  }

  void _setCommand(Command c) {
    textEditingController.clear();
    setState(() {
      _chosenCommand = c;
      _commandEnabled = true;
      _messageIsPresent = false;
    });
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
    return _attachments.isEmpty
        ? Container()
        : LimitedBox(
            maxHeight: 76.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _attachments
                  .map(
                    (attachment) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 1.0,
                              child: Container(
                                height: 50,
                                width: 50,
                                child: _buildAttachment(attachment),
                              ),
                            ),
                            _buildRemoveButton(attachment),
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
            ),
          );
  }

  Positioned _buildRemoveButton(_SendingAttachment attachment) {
    return Positioned(
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
          ),
        ),
      ),
    );
  }

  Widget _buildAttachment(_SendingAttachment attachment) {
    if (widget.attachmentThumbnailBuilders
            ?.containsKey(attachment.attachment.type) ==
        true) {
      return widget.attachmentThumbnailBuilders[attachment.attachment.type](
        context,
        attachment,
      );
    }

    switch (attachment.attachment.type) {
      case 'image':
      case 'giphy':
        return attachment.file != null
            ? Image.memory(
                attachment.file.bytes,
                fit: BoxFit.cover,
              )
            : Image.network(
                attachment.attachment.imageUrl ??
                    attachment.attachment.thumbUrl,
                fit: BoxFit.cover,
              );
        break;
      case 'video':
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

  Widget _buildCommandButton() {
    return Center(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 4.0, right: 8.0, top: 8.0, bottom: 8.0),
          child: Icon(
            StreamIcons.lightning,
            color: Color(0xFF000000).withAlpha(128),
          ),
        ),
        onTap: () {
          if (_commandsOverlay == null) {
            _commandsOverlay = _buildCommandsOverlayEntry();
            Overlay.of(context).insert(_commandsOverlay);
          } else {
            _commandsOverlay?.remove();
            _commandsOverlay = null;
          }
        },
      ),
    );
  }

  Widget _buildAttachmentButton() {
    var padding = widget.editMessage == null ? 4.0 : 8.0;
    return Center(
      child: InkWell(
        child: Padding(
          padding:
              EdgeInsets.only(left: 8.0, right: padding, top: 8.0, bottom: 8.0),
          child: Icon(
            StreamIcons.attach,
            color: Color(0xFF000000).withAlpha(128),
          ),
        ),
        onTap: () {
          showAttachmentModal();
        },
      ),
    );
  }

  /// Show the attachment modal, making the user choose where to pick a media from
  void showAttachmentModal() {
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
                  pickFile(DefaultAttachmentTypes.image, false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.video_library),
                title: Text('Upload a video'),
                onTap: () {
                  pickFile(DefaultAttachmentTypes.video, false);
                  Navigator.pop(context);
                },
              ),
              if (!kIsWeb)
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Photo from camera'),
                  onTap: () {
                    pickFile(DefaultAttachmentTypes.image, true);
                    Navigator.pop(context);
                  },
                ),
              if (!kIsWeb)
                ListTile(
                  leading: Icon(Icons.videocam),
                  title: Text('Video from camera'),
                  onTap: () {
                    pickFile(DefaultAttachmentTypes.video, true);
                    Navigator.pop(context);
                  },
                ),
              ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text('Upload a file'),
                onTap: () {
                  pickFile(DefaultAttachmentTypes.file, false);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  /// Add an attachment to the sending message
  /// Use this to add custom type attachments
  void addAttachment(Attachment attachment) {
    setState(() {
      _attachments.add(_SendingAttachment(
        attachment: attachment,
        uploaded: true,
      ));
    });
  }

  /// Pick a file from the device
  /// If [camera] is true then the camera will open
  void pickFile(DefaultAttachmentTypes fileType, [bool camera = false]) async {
    setState(() {
      _inputEnabled = false;
    });

    PlatformFile file;
    String attachmentType;

    if (fileType == DefaultAttachmentTypes.image) {
      attachmentType = 'image';
    } else if (fileType == DefaultAttachmentTypes.video) {
      attachmentType = 'video';
    } else if (fileType == DefaultAttachmentTypes.file) {
      attachmentType = 'file';
    }

    if (camera) {
      PickedFile pickedFile;
      if (fileType == DefaultAttachmentTypes.image) {
        pickedFile = await _imagePicker.getImage(source: ImageSource.camera);
      } else if (fileType == DefaultAttachmentTypes.video) {
        pickedFile = await _imagePicker.getVideo(source: ImageSource.camera);
      }
      final bytes = await pickedFile.readAsBytes();
      file = PlatformFile(
        path: pickedFile.path,
        bytes: bytes,
      );
    } else {
      FileType type;
      if (fileType == DefaultAttachmentTypes.image) {
        type = FileType.image;
      } else if (fileType == DefaultAttachmentTypes.video) {
        type = FileType.video;
      } else if (fileType == DefaultAttachmentTypes.file) {
        type = FileType.any;
      }
      final res = await FilePicker.platform.pickFiles(
        type: type,
        withData: true,
      );
      if (res?.files?.isNotEmpty == true) {
        file = res.files.single;
        print('file.bytes?.length: ${file.bytes?.length}');
      }
    }

    setState(() {
      _inputEnabled = true;
    });

    if (file == null) {
      return;
    }

    final channel = StreamChannel.of(context).channel;
    final attachment = _SendingAttachment(
      file: file,
      attachment: Attachment(
        localUri: file.path != null ? Uri.parse(file.path) : null,
        type: attachmentType,
      ),
    );

    setState(() {
      _attachments.add(attachment);
    });

    final url = await _uploadAttachment(file, fileType, channel);

    if (fileType == DefaultAttachmentTypes.image) {
      attachment.attachment = attachment.attachment.copyWith(
        imageUrl: url,
      );
    } else {
      attachment.attachment = attachment.attachment.copyWith(
        assetUrl: url,
      );
    }

    setState(() {
      attachment.uploaded = true;
    });
  }

  Future<String> _uploadAttachment(
    PlatformFile file,
    DefaultAttachmentTypes type,
    Channel channel,
  ) async {
    String url;
    if (type == DefaultAttachmentTypes.image) {
      if (widget.doImageUploadRequest != null) {
        url = await widget.doImageUploadRequest(file, channel);
      } else {
        url = await _uploadImage(file, channel);
      }
    } else {
      if (widget.doFileUploadRequest != null) {
        url = await widget.doFileUploadRequest(file, channel);
      } else {
        url = await _uploadFile(file, channel);
      }
    }
    return url;
  }

  Future<String> _uploadImage(PlatformFile file, Channel channel) async {
    final filename = file.name ?? file.path?.split('/')?.last;
    final bytes = file.bytes;
    final res = await channel.sendImage(
      MultipartFile.fromBytes(
        bytes,
        filename: filename,
        contentType: MediaType.parse(lookupMimeType(filename)),
      ),
    );
    return res.file;
  }

  Future<String> _uploadFile(PlatformFile file, Channel channel) async {
    final filename = file.name ?? file.path?.split('/')?.last;
    final bytes = file.bytes;
    final res = await channel.sendFile(
      MultipartFile.fromBytes(
        bytes,
        filename: filename,
        contentType: MediaType.parse(lookupMimeType(filename)),
      ),
    );
    return res.file;
  }

  Widget _buildIdleSendButton(BuildContext context) {
    return IconTheme(
      data:
          StreamChatTheme.of(context).channelTheme.messageInputButtonIconTheme,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: InkWell(
          onTap: () {
            sendMessage();
          },
          child: Icon(
            _getIdleSendIcon(),
            color: Colors.grey,
          ),
        )),
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return IconTheme(
      data:
          StreamChatTheme.of(context).channelTheme.messageInputButtonIconTheme,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              sendMessage();
            },
            child: _getSendIcon(),
          ),
        ),
      ),
    );
  }

  IconData _getIdleSendIcon() {
    if (_commandEnabled) {
      return StreamIcons.search;
    } else {
      return StreamIcons.send_message;
    }
  }

  Widget _getSendIcon() {
    if (widget.editMessage != null) {
      return Icon(
        StreamIcons.check_send,
        color: StreamChatTheme.of(context).accentColor,
      );
    } else if (_commandEnabled) {
      return Icon(
        StreamIcons.search,
        color: StreamChatTheme.of(context).accentColor,
      );
    } else {
      return Transform.rotate(
          angle: -pi / 2,
          child: Icon(
            StreamIcons.send_message,
            color: StreamChatTheme.of(context).accentColor,
          ));
    }
  }

  /// Sends the current message
  void sendMessage() async {
    var text = textEditingController.text.trim();
    if (text.isEmpty && _attachments.isEmpty) {
      return;
    }

    if (_commandEnabled) {
      text = '/${_chosenCommand.name} ' + text;
    }

    final attachments = List<_SendingAttachment>.from(_attachments);

    textEditingController.clear();
    _attachments.clear();

    setState(() {
      _messageIsPresent = false;
      _typingStarted = false;
      _commandEnabled = false;
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
        text: text,
        attachments: _getAttachments(attachments).toList(),
        mentionedUsers:
            _mentionedUsers.where((u) => text.contains('@${u.name}')).toList(),
      );
    } else {
      message = (widget.initialMessage ?? Message()).copyWith(
        parentId: widget.parentMessage?.id,
        text: text,
        attachments: _getAttachments(attachments).toList(),
        mentionedUsers:
            _mentionedUsers.where((u) => text.contains('@${u.name}')).toList(),
        showInChannel: widget.parentMessage != null ? _sendAsDm : null,
      );
    }

    if (widget.preMessageSending != null) {
      message = await widget.preMessageSending(message);
    }

    if (widget.editMessage == null ||
        widget.editMessage.status == MessageSendingStatus.FAILED) {
      sendingFuture = channel.sendMessage(message);
    } else {
      sendingFuture = StreamChat.of(context).client.updateMessage(
            message,
            channel.cid,
          );
    }

    return sendingFuture.then((resp) {
      if (widget.onMessageSent != null) {
        widget.onMessageSent(resp.message);
      } else {
        if (widget.editMessage != null) {
          Navigator.pop(context);
        }
      }
    });
  }

  Iterable<Attachment> _getAttachments(List<_SendingAttachment> attachments) {
    return attachments.map((attachment) {
      return attachment.attachment;
    });
  }

  StreamSubscription _keyboardListener;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> emojiMap = jsonDecode(EmojiParser.JSON_EMOJI);

    _emojiFuse = Fuzzy<String>(emojiMap.keys.toList(),
        options: FuzzyOptions(
          matchAllTokens: true,
          tokenize: true,
        ));

    if (!kIsWeb) {
      _keyboardListener = KeyboardVisibility.onChange.listen((visible) {
        if (visible) {
          if (_commandsOverlay != null) {
            if (textEditingController.text.startsWith('/')) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _commandsOverlay = _buildCommandsOverlayEntry();
                Overlay.of(context).insert(_commandsOverlay);
              });
            }
          }

          if (_mentionsOverlay != null) {
            if (textEditingController.text.contains('@')) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _mentionsOverlay = _buildCommandsOverlayEntry();
                Overlay.of(context).insert(_mentionsOverlay);
              });
            }
          }

          if (_emojiOverlay != null) {
            if (textEditingController.text.contains('@')) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _emojiOverlay = _buildEmojiOverlay();
                Overlay.of(context).insert(_emojiOverlay);
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
          if (_emojiOverlay != null) {
            _emojiOverlay.remove();
          }
        }
      });
    }

    textEditingController =
        widget.textEditingController ?? TextEditingController();
    if (widget.editMessage != null || widget.initialMessage != null) {
      _parseExistingMessage(widget.editMessage ?? widget.initialMessage);
    }
  }

  void _parseExistingMessage(Message message) {
    textEditingController.text = message.text;

    _typingStarted = true;
    _messageIsPresent = true;

    message.attachments?.forEach((attachment) {
      _attachments.add(_SendingAttachment(
        attachment: attachment,
        uploaded: true,
      ));
    });
  }

  @override
  void dispose() {
    _commandsOverlay?.remove();
    _emojiOverlay?.remove();
    _mentionsOverlay?.remove();
    _keyboardListener?.cancel();
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
  PlatformFile file;
  Attachment attachment;
  bool uploaded;

  _SendingAttachment({
    this.file,
    this.attachment,
    this.uploaded = false,
  });
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
