import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emojis/emoji.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/src/media_list_view.dart';
import 'package:stream_chat_flutter/src/message_list_view.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/user_avatar.dart';
import 'package:stream_chat_flutter/src/video_service.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../stream_chat_flutter.dart';
import 'attachment/attachment.dart';
import 'extension.dart';
import 'quoted_message_widget.dart';
import 'video_thumbnail_image.dart';

typedef AttachmentThumbnailBuilder = Widget Function(
  BuildContext,
  Attachment,
);

enum ActionsLocation {
  left,
  right,
  leftInside,
  rightInside,
}

enum DefaultAttachmentTypes {
  image,
  video,
  file,
}

/// Available locations for the sendMessage button relative to the textField
enum SendButtonLocation {
  /// inside the textField
  inside,

  /// outside the textField
  outside,
}

const _kMinMediaPickerSize = 360.0;

const _kMaxAttachmentSize = 20971520; // 20MB in Bytes

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
    this.initialMessage,
    this.textEditingController,
    this.actions,
    this.actionsLocation = ActionsLocation.left,
    this.attachmentThumbnailBuilders,
    this.focusNode,
    this.quotedMessage,
    this.onQuotedMessageCleared,
    this.sendButtonLocation = SendButtonLocation.outside,
    this.autofocus = false,
    this.hideSendAsDm = false,
    this.idleSendButton,
    this.activeSendButton,
    this.showCommandsButton = true,
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

  /// Use this property to hide/show the commands button
  final bool showCommandsButton;

  /// Hide send as dm checkbox
  final bool hideSendAsDm;

  /// The text controller of the TextField
  final TextEditingController textEditingController;

  /// List of action widgets
  final List<Widget> actions;

  /// The location of the custom actions
  final ActionsLocation actionsLocation;

  /// Map that defines a thumbnail builder for an attachment type
  final Map<String, AttachmentThumbnailBuilder> attachmentThumbnailBuilders;

  /// The focus node associated to the TextField
  final FocusNode focusNode;

  ///
  final Message quotedMessage;

  ///
  final VoidCallback onQuotedMessageCleared;

  /// The location of the send button
  final SendButtonLocation sendButtonLocation;

  /// Autofocus property passed to the TextField
  final bool autofocus;

  /// Send button widget in an idle state
  final Widget idleSendButton;

  /// Send button widget in an active state
  final Widget activeSendButton;

  @override
  MessageInputState createState() => MessageInputState();

  /// Use this method to get the current [StreamChatState] instance
  static MessageInputState of(BuildContext context) {
    MessageInputState messageInputState;

    messageInputState = context.findAncestorStateOfType<MessageInputState>();

    if (messageInputState == null) {
      throw Exception(
          'You must have a MessageInput widget as ancestor of your widget tree');
    }

    return messageInputState;
  }
}

class MessageInputState extends State<MessageInput> {
  final _attachments = <String, Attachment>{};
  final List<User> _mentionedUsers = [];

  final _imagePicker = ImagePicker();
  FocusNode _focusNode;
  bool _inputEnabled = true;
  bool _messageIsPresent = false;
  bool _animateContainer = true;
  bool _commandEnabled = false;
  OverlayEntry _commandsOverlay, _mentionsOverlay, _emojiOverlay;
  Iterable<String> _emojiNames;

  Command _chosenCommand;
  bool _actionsShrunk = false;
  bool _sendAsDm = false;
  bool _openFilePickerSection = false;
  int _filePickerIndex = 0;
  double _filePickerSize = _kMinMediaPickerSize;
  final KeyboardVisibilityController _keyboardVisibilityController =
      KeyboardVisibilityController();

  /// The editing controller passed to the input TextField
  TextEditingController textEditingController;

  bool get _hasQuotedMessage => widget.quotedMessage != null;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _emojiNames = Emoji.all().map((e) => e.name);

    if (!kIsWeb) {
      _keyboardListener =
          _keyboardVisibilityController.onChange.listen((visible) {
        if (_focusNode.hasFocus) {
          _onChanged(context, textEditingController.text);
        }
      });
    }

    textEditingController =
        widget.textEditingController ?? TextEditingController();
    if (widget.editMessage != null || widget.initialMessage != null) {
      _parseExistingMessage(widget.editMessage ?? widget.initialMessage);
    }

    textEditingController.addListener(() {
      _onChanged(context, textEditingController.text);
    });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _openFilePickerSection = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      color: StreamChatTheme.of(context).messageInputTheme.inputBackground,
      child: SafeArea(
        child: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dy > 0) {
              _focusNode.unfocus();
              if (_openFilePickerSection) {
                setState(() {
                  _openFilePickerSection = false;
                });
              }
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_hasQuotedMessage)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StreamSvgIcon.reply(
                          color: StreamChatTheme.of(context)
                              .colorTheme
                              .greyGainsboro,
                        ),
                      ),
                      Text(
                        'Reply to Message',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: StreamSvgIcon.closeSmall(),
                        onPressed: widget.onQuotedMessageCleared,
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildTextField(context),
              ),
              if (widget.parentMessage != null && !widget.hideSendAsDm)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 12.0,
                    left: 12.0,
                    bottom: 12.0,
                  ),
                  child: _buildDmCheckbox(),
                ),
              _buildFilePickerSection(),
            ],
          ),
        ),
      ),
    );
    if (widget.editMessage == null) {
      child = Material(
        elevation: 8,
        child: child,
      );
    }
    return child;
  }

  Flex _buildTextField(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (!_commandEnabled && widget.actionsLocation == ActionsLocation.left)
          _buildExpandActionsButton(),
        _buildTextInput(context),
        if (!_commandEnabled && widget.actionsLocation == ActionsLocation.right)
          _buildExpandActionsButton(),
        if (widget.sendButtonLocation == SendButtonLocation.outside)
          _animateSendButton(context),
      ],
    );
  }

  Widget _buildDmCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 16,
          width: 16,
          foregroundDecoration: BoxDecoration(
            border: _sendAsDm
                ? null
                : Border.all(
                    color: StreamChatTheme.of(context)
                        .colorTheme
                        .black
                        .withOpacity(.5),
                    width: 2,
                  ),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Center(
            child: Material(
              borderRadius: BorderRadius.circular(3),
              color: _sendAsDm
                  ? StreamChatTheme.of(context).colorTheme.accentBlue
                  : StreamChatTheme.of(context).colorTheme.white,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _sendAsDm = !_sendAsDm;
                  });
                },
                child: AnimatedCrossFade(
                  duration: Duration(milliseconds: 300),
                  reverseDuration: Duration(milliseconds: 300),
                  crossFadeState: _sendAsDm
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: StreamSvgIcon.check(
                    size: 16.0,
                    color: StreamChatTheme.of(context).colorTheme.white,
                  ),
                  secondChild: SizedBox(
                    height: 16,
                    width: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'Also send as direct message',
            style: StreamChatTheme.of(context).textTheme.footnote.copyWith(
                  color: StreamChatTheme.of(context)
                      .colorTheme
                      .black
                      .withOpacity(0.5),
                ),
          ),
        ),
      ],
    );
  }

  Widget _animateSendButton(BuildContext context) {
    final sendButton = widget.activeSendButton != null
        ? InkWell(
            onTap: sendMessage,
            child: widget.activeSendButton,
          )
        : _buildSendButton(context);
    return AnimatedCrossFade(
      crossFadeState: (_messageIsPresent || _attachments.isNotEmpty)
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: sendButton,
      secondChild: widget.idleSendButton ?? _buildIdleSendButton(context),
      duration:
          StreamChatTheme.of(context).messageInputTheme.sendAnimationDuration,
      alignment: Alignment.center,
    );
  }

  Widget _buildExpandActionsButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AnimatedCrossFade(
        crossFadeState: _actionsShrunk
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstChild: IconButton(
          onPressed: () => setState(() => _actionsShrunk = false),
          icon: Transform.rotate(
            alignment: Alignment.center,
            angle: (widget.actionsLocation == ActionsLocation.right ||
                    widget.actionsLocation == ActionsLocation.rightInside)
                ? pi
                : 0,
            child: StreamSvgIcon.emptyCircleLeft(
              color: StreamChatTheme.of(context).colorTheme.accentBlue,
            ),
          ),
          padding: const EdgeInsets.all(0),
          constraints: BoxConstraints.tightFor(
            height: 24,
            width: 24,
          ),
          splashRadius: 24,
        ),
        secondChild: FittedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              if (!widget.disableAttachments) _buildAttachmentButton(),
              if (widget.showCommandsButton &&
                  widget.editMessage == null &&
                  StreamChannel.of(context)
                          .channel
                          ?.config
                          ?.commands
                          ?.isNotEmpty ==
                      true)
                _buildCommandButton(),
              ...widget.actions ?? [],
            ].insertBetween(const SizedBox(width: 8)),
          ),
        ),
        duration: Duration(milliseconds: 300),
        alignment: Alignment.center,
      ),
    );
  }

  Expanded _buildTextInput(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    return Expanded(
      child: Center(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: theme.messageInputTheme.borderRadius,
            gradient: _focusNode.hasFocus
                ? theme.messageInputTheme.activeBorderGradient
                : theme.messageInputTheme.idleBorderGradient,
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.5),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: theme.messageInputTheme.borderRadius,
                color: theme.messageInputTheme.inputBackground,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReplyToMessage(),
                  _buildAttachments(),
                  LimitedBox(
                    maxHeight: widget.maxHeight,
                    child: TextField(
                      key: Key('messageInputText'),
                      enabled: _inputEnabled,
                      minLines: null,
                      maxLines: null,
                      onSubmitted: (_) => sendMessage(),
                      keyboardType: widget.keyboardType,
                      controller: textEditingController,
                      focusNode: _focusNode,
                      style: theme.messageInputTheme.inputTextStyle,
                      autofocus: widget.autofocus,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: _getInputDecoration(),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _getInputDecoration() {
    final theme = StreamChatTheme.of(context);
    final passedDecoration = theme.messageInputTheme.inputDecoration;
    return InputDecoration(
      isDense: true,
      hintText: _getHint(),
      hintStyle: theme.messageInputTheme.inputTextStyle.copyWith(
        color: theme.colorTheme.grey,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 13, 11),
      prefixIcon: _commandEnabled
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    constraints: BoxConstraints.tight(Size(64, 24)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: theme.colorTheme.accentBlue,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StreamSvgIcon.lightning(
                          color: Colors.white,
                          size: 16.0,
                        ),
                        Text(
                          _chosenCommand?.name?.toUpperCase() ?? '',
                          style: StreamChatTheme.of(context)
                              .textTheme
                              .footnoteBold
                              .copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : (widget.actionsLocation == ActionsLocation.leftInside
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildExpandActionsButton(),
                  ],
                )
              : null),
      suffixIconConstraints: BoxConstraints.tightFor(height: 40),
      prefixIconConstraints: BoxConstraints.tightFor(height: 40),
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_commandEnabled)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: StreamSvgIcon.closeSmall(),
                splashRadius: 24,
                padding: const EdgeInsets.all(0),
                constraints: BoxConstraints.tightFor(
                  height: 24,
                  width: 24,
                ),
                onPressed: () {
                  setState(() => _commandEnabled = false);
                },
              ),
            ),
          if (!_commandEnabled &&
              widget.actionsLocation == ActionsLocation.rightInside)
            _buildExpandActionsButton(),
          if (widget.sendButtonLocation == SendButtonLocation.inside)
            _animateSendButton(context),
        ],
      ),
    ).merge(passedDecoration);
  }

  Timer _debounce;

  String _previousValue;

  void _onChanged(BuildContext context, String s) {
    if (s == _previousValue) {
      return;
    }
    _previousValue = s;

    if (_debounce?.isActive == true) _debounce.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 350),
      () {
        if (!mounted) {
          return;
        }
        StreamChannel.of(context).channel.keyStroke().catchError((e) {});

        setState(() {
          _messageIsPresent = s.trim().isNotEmpty;
          _actionsShrunk = s.trim().isNotEmpty &&
              ((widget.actions?.length ?? 0) +
                      (widget.showCommandsButton ? 1 : 0) +
                      (widget.disableAttachments ? 0 : 1) >
                  1);
        });

        _commandsOverlay?.remove();
        _commandsOverlay = null;
        _mentionsOverlay?.remove();
        _mentionsOverlay = null;
        _emojiOverlay?.remove();
        _emojiOverlay = null;

        _checkCommands(s.trim(), context);

        _checkMentions(s, context);

        _checkEmoji(s, context);
      },
    );
  }

  String _getHint() {
    if (_commandEnabled && _chosenCommand.name == 'giphy') {
      return 'Search GIFs';
    }
    if (_attachments.isNotEmpty) {
      return 'Add a comment or send';
    }
    return 'Write a message';
  }

  void _checkEmoji(String s, BuildContext context) {
    if (s.isNotEmpty &&
        textEditingController.selection.baseOffset > 0 &&
        textEditingController.text
            .substring(
              0,
              textEditingController.selection.baseOffset,
            )
            .contains(':')) {
      final textToSelection = textEditingController.text
          .substring(0, textEditingController.value.selection.start);
      final splits = textToSelection.split(':');
      final query = splits[splits.length - 2]?.toLowerCase();
      final emoji = Emoji.byName(query);

      if (textToSelection.endsWith(':') && emoji != null) {
        _chooseEmoji(splits.sublist(0, splits.length - 1), emoji);
      } else {
        _emojiOverlay = _buildEmojiOverlay();

        if (_emojiOverlay != null) {
          Overlay.of(context).insert(_emojiOverlay);
        }
      }
    }
  }

  void _checkMentions(String s, BuildContext context) {
    if (s.isNotEmpty &&
        textEditingController.selection.baseOffset > 0 &&
        textEditingController.text
            .substring(0, textEditingController.selection.baseOffset)
            .split(' ')
            .last
            .contains('@')) {
      _mentionsOverlay = _buildMentionsOverlayEntry();
      if (_mentionsOverlay != null) {
        Overlay.of(context).insert(_mentionsOverlay);
      }
    }
  }

  void _checkCommands(String s, BuildContext context) {
    if (s.startsWith('/')) {
      var matchedCommandsList = StreamChannel.of(context)
              .channel
              .config
              ?.commands
              ?.where((element) => element.name == s.substring(1))
              ?.toList() ??
          [];

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
        if (_commandsOverlay != null) {
          Overlay.of(context).insert(_commandsOverlay);
        }
      }
    }
  }

  OverlayEntry _buildCommandsOverlayEntry() {
    final text = textEditingController.text.trimLeft();
    final commands = StreamChannel.of(context)
            .channel
            .config
            ?.commands
            ?.where((c) => c.name.contains(text.replaceFirst('/', '')))
            ?.toList() ??
        [];

    if (commands.isEmpty) {
      return null;
    }

    RenderBox renderBox = context.findRenderObject();
    final size = renderBox.size;

    return OverlayEntry(builder: (context) {
      return Positioned(
        bottom: size.height + MediaQuery.of(context).viewInsets.bottom,
        left: 0,
        right: 0,
        child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOutExpo,
            builder: (context, val, wid) {
              return Transform.scale(
                alignment: Alignment.center,
                scale: val,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: StreamChatTheme.of(context).colorTheme.white,
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      constraints: BoxConstraints.loose(Size.fromHeight(400)),
                      decoration: BoxDecoration(
                          color: StreamChatTheme.of(context).colorTheme.white,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: ListView(
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        children: [
                          if (commands.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 0.0, top: 8.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: StreamSvgIcon.lightning(
                                      color: StreamChatTheme.of(context)
                                          .colorTheme
                                          .accentBlue,
                                    ),
                                  ),
                                  Text(
                                    'Instant Commands',
                                    style: TextStyle(
                                      color: StreamChatTheme.of(context)
                                          .colorTheme
                                          .black
                                          .withOpacity(.5),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          SizedBox(
                            height: 10.0,
                          ),
                          ...commands
                              .map(
                                (c) => InkWell(
                                  onTap: () {
                                    _setCommand(c);
                                  },
                                  child: Container(
                                    height: 40.0,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 16.0,
                                        ),
                                        _buildCommandIcon(c.name),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            text: '${c.name.capitalize()}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            children: [
                                              TextSpan(
                                                text: '   /${c.name} ${c.args}',
                                                style:
                                                    StreamChatTheme.of(context)
                                                        .textTheme
                                                        .body
                                                        .copyWith(
                                                          color: StreamChatTheme
                                                                  .of(context)
                                                              .colorTheme
                                                              .grey,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      );
    });
  }

  Widget _buildFilePickerSection() {
    final _attachmentContainsFile = _attachments.values.any((it) {
      return it.type == 'file';
    });

    Color _getIconColor(int index) {
      switch (index) {
        case 0:
          return _attachments.isEmpty
              ? StreamChatTheme.of(context).colorTheme.accentBlue
              : (!_attachmentContainsFile
                  ? StreamChatTheme.of(context).colorTheme.accentBlue
                  : StreamChatTheme.of(context)
                      .colorTheme
                      .black
                      .withOpacity(0.2));
          break;
        case 1:
          return _attachmentContainsFile
              ? StreamChatTheme.of(context).colorTheme.accentBlue
              : (_attachments.isEmpty
                  ? StreamChatTheme.of(context)
                      .colorTheme
                      .black
                      .withOpacity(0.5)
                  : StreamChatTheme.of(context)
                      .colorTheme
                      .black
                      .withOpacity(0.2));
          break;
        case 2:
          return _attachmentContainsFile && _attachments.isNotEmpty
              ? StreamChatTheme.of(context).colorTheme.black.withOpacity(0.2)
              : StreamChatTheme.of(context).colorTheme.black.withOpacity(0.5);
          break;
        case 3:
          return _attachmentContainsFile && _attachments.isNotEmpty
              ? StreamChatTheme.of(context).colorTheme.black.withOpacity(0.2)
              : StreamChatTheme.of(context).colorTheme.black.withOpacity(0.5);
          break;
        default:
          return Colors.black;
      }
    }

    return AnimatedContainer(
      duration: _animateContainer ? Duration(milliseconds: 300) : Duration.zero,
      height: _openFilePickerSection ? _filePickerSize : 0,
      child: Material(
        color: StreamChatTheme.of(context).colorTheme.whiteSmoke,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  iconSize: 24,
                  icon: StreamSvgIcon.pictures(
                    color: _getIconColor(0),
                  ),
                  onPressed: _attachmentContainsFile && _attachments.isNotEmpty
                      ? null
                      : () {
                          setState(() {
                            _filePickerIndex = 0;
                          });
                        },
                ),
                IconButton(
                  iconSize: 32,
                  icon: StreamSvgIcon.files(
                    color: _getIconColor(1),
                  ),
                  onPressed: !_attachmentContainsFile && _attachments.isNotEmpty
                      ? null
                      : () {
                          pickFile(DefaultAttachmentTypes.file, false);
                        },
                ),
                IconButton(
                  iconSize: 24,
                  icon: StreamSvgIcon.camera(
                    color: _getIconColor(2),
                  ),
                  onPressed: _attachmentContainsFile && _attachments.isNotEmpty
                      ? null
                      : () {
                          pickFile(DefaultAttachmentTypes.image, true);
                        },
                ),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  iconSize: 24,
                  icon: StreamSvgIcon.record(
                    color: _getIconColor(3),
                  ),
                  onPressed: _attachmentContainsFile && _attachments.isNotEmpty
                      ? null
                      : () {
                          pickFile(DefaultAttachmentTypes.video, true);
                        },
                ),
              ],
            ),
            GestureDetector(
              onVerticalDragUpdate: (update) {
                setState(() {
                  _animateContainer = false;
                  _filePickerSize = (_filePickerSize - update.delta.dy).clamp(
                    _kMinMediaPickerSize,
                    MediaQuery.of(context).size.height / 1.7,
                  );
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: StreamChatTheme.of(context).colorTheme.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 40.0,
                        height: 4.0,
                        decoration: BoxDecoration(
                          color:
                              StreamChatTheme.of(context).colorTheme.whiteSmoke,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_openFilePickerSection)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: StreamChatTheme.of(context).colorTheme.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: _PickerWidget(
                    filePickerIndex: _filePickerIndex,
                    containsFile: _attachmentContainsFile,
                    selectedMedias: _attachments.keys.toList(),
                    onAddMoreFilesClick: pickFile,
                    onMediaSelected: (media) {
                      if (_attachments.containsKey(media.id)) {
                        setState(() => _attachments.remove(media.id));
                      } else {
                        _addAttachment(media);
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _addAttachment(AssetEntity medium) async {
    final mediaFile = await medium.originFile.timeout(
      Duration(seconds: 5),
      onTimeout: () => medium.originFile,
    );

    var file = AttachmentFile(
      path: mediaFile.path,
      size: await mediaFile.length(),
      bytes: mediaFile.readAsBytesSync(),
    );

    if (file.size > _kMaxAttachmentSize) {
      if (medium?.type == AssetType.video) {
        final mediaInfo = await VideoService.compressVideo(file.path);

        if (mediaInfo.filesize > _kMaxAttachmentSize) {
          _showErrorAlert(
            'The file is too large to upload. The file size limit is 20MB. We tried compressing it, but it was not enough.',
          );
          return;
        }
        file = AttachmentFile(
          name: file.name,
          size: mediaInfo.filesize,
          bytes: await mediaInfo.file.readAsBytes(),
          path: mediaInfo.path,
        );
      } else {
        _showErrorAlert(
          'The file is too large to upload. The file size limit is 20MB.',
        );
      }
    }

    setState(() {
      _attachments[medium.id] = Attachment(
        id: medium.id,
        file: file,
        type: medium.type == AssetType.image ? 'image' : 'video',
      );
    });
  }

  Widget _buildCommandIcon(String iconType) {
    switch (iconType) {
      case 'giphy':
        return CircleAvatar(
          radius: 12,
          child: StreamSvgIcon.giphyIcon(
            size: 24.0,
          ),
        );
        break;
      case 'ban':
        return CircleAvatar(
          backgroundColor: StreamChatTheme.of(context).colorTheme.accentBlue,
          radius: 12,
          child: StreamSvgIcon.iconUserDelete(
            size: 16.0,
            color: Colors.white,
          ),
        );
        break;
      case 'flag':
        return CircleAvatar(
          backgroundColor: StreamChatTheme.of(context).colorTheme.accentBlue,
          radius: 12,
          child: StreamSvgIcon.flag(
            size: 14.0,
            color: Colors.white,
          ),
        );
        break;
      case 'imgur':
        return CircleAvatar(
          backgroundColor: StreamChatTheme.of(context).colorTheme.accentBlue,
          radius: 12,
          child: ClipOval(
            child: StreamSvgIcon.imgur(
              size: 24.0,
            ),
          ),
        );
        break;
      case 'mute':
        return CircleAvatar(
          backgroundColor: StreamChatTheme.of(context).colorTheme.accentBlue,
          radius: 12,
          child: StreamSvgIcon.mute(
            size: 16.0,
            color: Colors.white,
          ),
        );
        break;
      case 'unban':
        return CircleAvatar(
          backgroundColor: StreamChatTheme.of(context).colorTheme.accentBlue,
          radius: 12,
          child: StreamSvgIcon.userAdd(
            size: 16.0,
            color: Colors.white,
          ),
        );
        break;
      case 'unmute':
        return CircleAvatar(
          backgroundColor: StreamChatTheme.of(context).colorTheme.accentBlue,
          radius: 12,
          child: StreamSvgIcon.volumeUp(
            size: 16.0,
            color: Colors.white,
          ),
        );
        break;
      default:
        return CircleAvatar(
          backgroundColor: StreamChatTheme.of(context).colorTheme.accentBlue,
          radius: 12,
          child: StreamSvgIcon.lightning(
            size: 16.0,
            color: Colors.white,
          ),
        );
        break;
    }
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

    if (members.isEmpty) {
      return null;
    }

    RenderBox renderBox = context.findRenderObject();
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          bottom: size.height + MediaQuery.of(context).viewInsets.bottom,
          left: 0,
          right: 0,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOutExpo,
            builder: (context, val, wid) {
              return Transform.scale(
                scale: val,
                child: Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 2.0,
                  color: StreamChatTheme.of(context).colorTheme.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    constraints: BoxConstraints.loose(Size.fromHeight(240)),
                    decoration: BoxDecoration(
                      color: StreamChatTheme.of(context).colorTheme.white,
                    ),
                    child: FutureBuilder<List<Member>>(
                      future: queryMembers ?? Future.value(members),
                      initialData: members,
                      builder: (context, snapshot) {
                        return ListView(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: 8.0,
                            ),
                            ...snapshot.data.map(
                              (m) {
                                return Material(
                                  color: StreamChatTheme.of(context)
                                      .colorTheme
                                      .white,
                                  child: InkWell(
                                    onTap: () {
                                      _mentionedUsers.add(m.user);

                                      splits[splits.length - 1] = m.user.name;
                                      final rejoin = splits.join('@');

                                      textEditingController.value =
                                          TextEditingValue(
                                        text: rejoin +
                                            textEditingController.text
                                                .substring(textEditingController
                                                    .selection.start),
                                        selection: TextSelection.collapsed(
                                          offset: rejoin.length,
                                        ),
                                      );
                                      _debounce.cancel();
                                      _mentionsOverlay?.remove();
                                      _mentionsOverlay = null;
                                    },
                                    child: Container(
                                      height: 56.0,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 16.0,
                                          ),
                                          UserAvatar(
                                            constraints: BoxConstraints.tight(
                                              Size(
                                                40,
                                                40,
                                              ),
                                            ),
                                            user: m.user,
                                          ),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${m.user.name}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: StreamChatTheme.of(
                                                            context)
                                                        .textTheme
                                                        .bodyBold,
                                                  ),
                                                  SizedBox(
                                                    height: 2.0,
                                                  ),
                                                  Text(
                                                    '@${m.userId}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: StreamChatTheme.of(
                                                            context)
                                                        .textTheme
                                                        .footnoteBold
                                                        .copyWith(
                                                            color: StreamChatTheme
                                                                    .of(context)
                                                                .colorTheme
                                                                .grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 18.0, left: 8.0),
                                            child: StreamSvgIcon.mentions(
                                              color: StreamChatTheme.of(context)
                                                  .colorTheme
                                                  .accentBlue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                            SizedBox(
                              height: 8.0,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  OverlayEntry _buildEmojiOverlay() {
    final splits = textEditingController.text
        .substring(0, textEditingController.value.selection.start)
        .split(':');
    final query = splits.last.toLowerCase();

    if (query.isEmpty) {
      return null;
    }

    final emojis = _emojiNames
        .where((e) => e.contains(query))
        .map((e) => Emoji.byName(e))
        .where((e) => e != null);

    if (emojis.isEmpty) {
      return null;
    }

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
          color: StreamChatTheme.of(context).colorTheme.white,
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
              color: StreamChatTheme.of(context).colorTheme.white,
            ),
            child: ListView.builder(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount: emojis.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: StreamSvgIcon.smile(
                              color: StreamChatTheme.of(context)
                                  .colorTheme
                                  .accentBlue,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              'Emoji matching "$query"',
                              style: TextStyle(
                                color: StreamChatTheme.of(context)
                                    .colorTheme
                                    .black
                                    .withOpacity(.5),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }

                  final emoji = emojis.elementAt(i - 1);
                  return ListTile(
                    title: SubstringHighlight(
                      text: "${emoji.char} ${emoji.name.replaceAll('_', ' ')}",
                      term: query,
                      textStyleHighlight:
                          Theme.of(context).textTheme.headline6.copyWith(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                              ),
                      textStyle: Theme.of(context).textTheme.headline6.copyWith(
                            fontSize: 14.5,
                          ),
                    ),
                    onTap: () {
                      _chooseEmoji(splits, emoji);
                    },
                  );
                }),
          ),
        ),
      );
    });
  }

  void _chooseEmoji(List<String> splits, Emoji emoji) {
    final rejoin = splits.sublist(0, splits.length - 1).join(':') + emoji.char;

    textEditingController.value = TextEditingValue(
      text: rejoin +
          textEditingController.text
              .substring(textEditingController.selection.start),
      selection: TextSelection.collapsed(
        offset: rejoin.length,
      ),
    );

    _emojiOverlay?.remove();
    _emojiOverlay = null;
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

  Widget _buildReplyToMessage() {
    if (!_hasQuotedMessage) return Offstage();
    final containsUrl = widget.quotedMessage.attachments
            ?.any((element) => element.ogScrapeUrl != null) ==
        true;
    return Transform(
      transform: Matrix4.rotationY(pi),
      alignment: Alignment.center,
      child: QuotedMessageWidget(
        reverse: true,
        showBorder: !containsUrl,
        message: widget.quotedMessage,
        messageTheme: StreamChatTheme.of(context).otherMessageTheme,
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      ),
    );
  }

  Widget _buildAttachments() {
    if (_attachments.isEmpty) return Offstage();
    final fileAttachments = _attachments.values
        .where((it) => it.type == 'file')
        .toList(growable: false);
    final remainingAttachments = _attachments.values
        .where((it) => it.type != 'file')
        .toList(growable: false);
    return Column(
      children: [
        if (fileAttachments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: LimitedBox(
              maxHeight: 136.0,
              child: ListView(
                reverse: true,
                shrinkWrap: true,
                children: fileAttachments.reversed
                    .map<Widget>(
                      (e) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        clipBehavior: Clip.antiAlias,
                        child: FileAttachment(
                          message: null,
                          attachment: e,
                          size: Size(
                            MediaQuery.of(context).size.width * 0.65,
                            56.0,
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildRemoveButton(e),
                          ),
                        ),
                      ),
                    )
                    .insertBetween(const SizedBox(height: 8)),
              ),
            ),
          ),
        if (remainingAttachments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: LimitedBox(
              maxHeight: 104.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: remainingAttachments
                    .map<Widget>(
                      (attachment) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 1.0,
                              child: Container(
                                height: 104,
                                width: 104,
                                child: _buildAttachment(attachment),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: _buildRemoveButton(attachment),
                            ),
                          ],
                        ),
                      ),
                    )
                    .insertBetween(const SizedBox(width: 8)),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRemoveButton(Attachment attachment) {
    return Container(
      height: 24,
      width: 24,
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
          setState(() => _attachments.remove(attachment.id));
        },
        fillColor: StreamChatTheme.of(context).colorTheme.black.withOpacity(.5),
        child: Center(
          child: StreamSvgIcon.close(
            size: 24,
            color: StreamChatTheme.of(context).colorTheme.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAttachment(Attachment attachment) {
    if (attachment == null) return Offstage();

    if (widget.attachmentThumbnailBuilders?.containsKey(attachment.type) ==
        true) {
      return widget.attachmentThumbnailBuilders[attachment.type](
        context,
        attachment,
      );
    }

    switch (attachment.type) {
      case 'image':
      case 'giphy':
        return attachment.file != null
            ? Image.memory(
                attachment.file.bytes,
                fit: BoxFit.cover,
                errorBuilder: (context, _, __) {
                  return Image.asset(
                    'images/placeholder.png',
                    package: 'stream_chat_flutter',
                  );
                },
              )
            : CachedNetworkImage(
                imageUrl: attachment.imageUrl ??
                    attachment.assetUrl ??
                    attachment.thumbUrl,
                fit: BoxFit.cover,
                errorWidget: (_, obj, trace) {
                  return getFileTypeImage(attachment.extraData['other']);
                },
                progressIndicatorBuilder: (context, _, progress) {
                  return Shimmer.fromColors(
                    baseColor:
                        StreamChatTheme.of(context).colorTheme.greyGainsboro,
                    highlightColor:
                        StreamChatTheme.of(context).colorTheme.whiteSmoke,
                    child: Image.asset(
                      'images/placeholder.png',
                      fit: BoxFit.cover,
                      package: 'stream_chat_flutter',
                    ),
                  );
                },
              );
      case 'video':
        return Stack(
          children: [
            VideoThumbnailImage(
              height: 104,
              width: 104,
              video: attachment.file?.path ?? attachment.assetUrl,
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 8,
              bottom: 10,
              child: SvgPicture.asset(
                'svgs/video_call_icon.svg',
                package: 'stream_chat_flutter',
              ),
            ),
          ],
        );
      default:
        return Container(
          color: Colors.black26,
          child: Icon(Icons.insert_drive_file),
        );
    }
  }

  Widget _buildCommandButton() {
    final s = textEditingController.text.trim();

    return IconButton(
      icon: StreamSvgIcon.lightning(
        color: s.isNotEmpty
            ? StreamChatTheme.of(context).colorTheme.greyGainsboro
            : (_commandsOverlay != null
                ? StreamChatTheme.of(context)
                    .messageInputTheme
                    .actionButtonColor
                : StreamChatTheme.of(context)
                    .messageInputTheme
                    .actionButtonIdleColor),
      ),
      padding: const EdgeInsets.all(0),
      constraints: BoxConstraints.tightFor(
        height: 24,
        width: 24,
      ),
      splashRadius: 24,
      onPressed: () async {
        if (_openFilePickerSection) {
          setState(() {
            _animateContainer = false;
            _openFilePickerSection = false;
            _filePickerSize = _kMinMediaPickerSize;
          });
          await Future.delayed(Duration(milliseconds: 300));
        }

        if (_commandsOverlay == null) {
          setState(() {
            _commandsOverlay = _buildCommandsOverlayEntry();
            if (_commandsOverlay != null) {
              Overlay.of(context).insert(_commandsOverlay);
            }
          });
        } else {
          setState(() {
            _commandsOverlay?.remove();
            _commandsOverlay = null;
          });
        }
      },
    );
  }

  Widget _buildAttachmentButton() {
    return IconButton(
      icon: StreamSvgIcon.attach(
        color: _openFilePickerSection
            ? StreamChatTheme.of(context).messageInputTheme.actionButtonColor
            : StreamChatTheme.of(context)
                .messageInputTheme
                .actionButtonIdleColor,
      ),
      padding: const EdgeInsets.all(0),
      constraints: BoxConstraints.tightFor(
        height: 24,
        width: 24,
      ),
      splashRadius: 24,
      onPressed: () async {
        _emojiOverlay?.remove();
        _emojiOverlay = null;
        _commandsOverlay?.remove();
        _commandsOverlay = null;
        _mentionsOverlay?.remove();
        _mentionsOverlay = null;

        if (_openFilePickerSection) {
          setState(() {
            _animateContainer = true;
            _openFilePickerSection = false;
            _filePickerSize = _kMinMediaPickerSize;
          });
        } else {
          showAttachmentModal();
        }
      },
    );
  }

  /// Show the attachment modal, making the user choose where to pick a media from
  void showAttachmentModal() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }

    if (!kIsWeb) {
      setState(() {
        _openFilePickerSection = true;
      });
    } else {
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
  }

  /// Add an attachment to the sending message
  /// Use this to add custom type attachments
  void addAttachment(Attachment attachment) {
    setState(() {
      _attachments[attachment.id] = attachment.copyWith(
        uploadState: attachment.uploadState ?? UploadState.success(),
      );
    });
  }

  /// Pick a file from the device
  /// If [camera] is true then the camera will open
  void pickFile(DefaultAttachmentTypes fileType, [bool camera = false]) async {
    setState(() => _inputEnabled = false);

    AttachmentFile file;
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
      if (pickedFile == null) {
        return;
      }
      final bytes = await pickedFile.readAsBytes();
      file = AttachmentFile(
        size: bytes.length,
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
        file = res.files.single.toAttachmentFile;
      }
    }

    setState(() => _inputEnabled = true);

    if (file == null) return;

    final mimeType = file.name?.mimeType ?? file.path.split('/').last.mimeType;

    final extraDataMap = <String, dynamic>{};

    if (mimeType?.subtype != null) {
      extraDataMap['mime_type'] = mimeType.subtype.toLowerCase();
    }

    if (file.size != null) {
      extraDataMap['file_size'] = file.size;
    }

    final attachment = Attachment(
      file: file,
      type: attachmentType,
      extraData: extraDataMap.isNotEmpty ? extraDataMap : null,
    );

    _attachments[attachment.id] = attachment;

    if (file.size > _kMaxAttachmentSize) {
      if (attachmentType == 'Video') {
        final mediaInfo = await VideoService.compressVideo(file.path);

        if (mediaInfo.filesize > _kMaxAttachmentSize) {
          _showErrorAlert(
            'The file is too large to upload. The file size limit is 20MB. We tried compressing it, but it was not enough.',
          );
          _attachments.remove(attachment.id);
          return;
        }
        file = AttachmentFile(
          name: file.name,
          size: mediaInfo.filesize,
          bytes: await mediaInfo.file.readAsBytes(),
          path: mediaInfo.path,
        );
      } else {
        _showErrorAlert(
          'The file is too large to upload. The file size limit is 20MB.',
        );
      }
    }

    setState(() {
      _attachments.update(attachment.id, (it) {
        return it.copyWith(
          file: file,
          extraData: {...it.extraData}..update('file_size', (_) => file.size),
        );
      });
    });
  }

  Widget _buildIdleSendButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamSvgIcon(
        assetName: _getIdleSendIcon(),
        color:
            StreamChatTheme.of(context).messageInputTheme.sendButtonIdleColor,
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: sendMessage,
        padding: const EdgeInsets.all(0),
        splashRadius: 24,
        constraints: BoxConstraints.tightFor(
          height: 24,
          width: 24,
        ),
        icon: StreamSvgIcon(
          assetName: _getSendIcon(),
          color: StreamChatTheme.of(context).messageInputTheme.sendButtonColor,
        ),
      ),
    );
  }

  String _getIdleSendIcon() {
    if (_commandEnabled) {
      return 'Icon_search.svg';
    } else {
      return 'Icon_circle_right.svg';
    }
  }

  String _getSendIcon() {
    if (widget.editMessage != null) {
      return 'Icon_circle_up.svg';
    } else if (_commandEnabled) {
      return 'Icon_search.svg';
    } else {
      return 'Icon_circle_up.svg';
    }
  }

  /// Sends the current message
  void sendMessage() async {
    var text = textEditingController.text.trim();
    if (text.isEmpty && _attachments.isEmpty) {
      return;
    }

    final shouldUnfocus = _commandEnabled;

    if (_commandEnabled) {
      text = '/${_chosenCommand.name} ' + text;
    }

    final attachments = [..._attachments.values];

    textEditingController.clear();
    _attachments.clear();
    if (widget.onQuotedMessageCleared != null) {
      widget.onQuotedMessageCleared();
    }

    setState(() {
      _messageIsPresent = false;
      _commandEnabled = false;
    });

    _commandsOverlay?.remove();
    _commandsOverlay = null;
    _mentionsOverlay?.remove();
    _mentionsOverlay = null;

    Future sendingFuture;
    Message message;
    if (widget.editMessage != null) {
      message = widget.editMessage.copyWith(
        text: text,
        attachments: attachments,
        mentionedUsers:
            _mentionedUsers.where((u) => text.contains('@${u.name}')).toList(),
      );
    } else {
      message = (widget.initialMessage ?? Message()).copyWith(
        parentId: widget.parentMessage?.id,
        text: text,
        attachments: attachments,
        mentionedUsers:
            _mentionedUsers.where((u) => text.contains('@${u.name}')).toList(),
        showInChannel: widget.parentMessage != null ? _sendAsDm : null,
      );
    }

    if (widget.quotedMessage != null) {
      message = message.copyWith(
        quotedMessageId: widget.quotedMessage.id,
      );
    }

    if (widget.preMessageSending != null) {
      message = await widget.preMessageSending(message);
    }

    final streamChannel = StreamChannel.of(context);
    final channel = streamChannel.channel;
    if (!channel.state.isUpToDate) {
      await streamChannel.reloadChannel();
    }

    _mentionedUsers.clear();

    if (widget.editMessage == null ||
        widget.editMessage.status == MessageSendingStatus.failed ||
        widget.editMessage.status == MessageSendingStatus.sending) {
      sendingFuture = channel.sendMessage(message);
    } else {
      sendingFuture = channel.updateMessage(message);
    }

    if (!shouldUnfocus) {
      FocusScope.of(context).requestFocus(_focusNode);
    }

    return sendingFuture.then((resp) {
      if (resp.message?.type == 'error') {
        _parseExistingMessage(message);
      }
      if (widget.onMessageSent != null) {
        widget.onMessageSent(resp.message);
      }
    });
  }

  StreamSubscription _keyboardListener;

  void _showErrorAlert(String description) {
    showModalBottomSheet(
      backgroundColor: StreamChatTheme.of(context).colorTheme.white,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      )),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 26.0,
            ),
            StreamSvgIcon.error(
              color: StreamChatTheme.of(context).colorTheme.accentRed,
              size: 24.0,
            ),
            SizedBox(
              height: 26.0,
            ),
            Text(
              'Something went wrong',
              style: StreamChatTheme.of(context).textTheme.headlineBold,
            ),
            SizedBox(
              height: 7.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 36.0,
            ),
            Container(
              color:
                  StreamChatTheme.of(context).colorTheme.black.withOpacity(.08),
              height: 1.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: StreamChatTheme.of(context)
                        .textTheme
                        .bodyBold
                        .copyWith(
                            color: StreamChatTheme.of(context)
                                .colorTheme
                                .accentBlue),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _parseExistingMessage(Message message) {
    textEditingController.text = message.text;
    _messageIsPresent = true;
    for (final attachment in message?.attachments) {
      _attachments[attachment.id] = attachment.copyWith(
        uploadState: attachment.uploadState ?? UploadState.success(),
      );
    }
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

/// Represents a 2-tuple, or pair.
class Tuple2<T1, T2> {
  /// Returns the first item of the tuple
  final T1 item1;

  /// Returns the second item of the tuple
  final T2 item2;

  /// Creates a new tuple value with the specified items.
  const Tuple2(this.item1, this.item2);

  /// Create a new tuple value with the specified list [items].
  factory Tuple2.fromList(List items) {
    if (items.length != 2) {
      throw ArgumentError('items must have length 2');
    }

    return Tuple2<T1, T2>(items[0] as T1, items[1] as T2);
  }

  /// Returns a tuple with the first item set to the specified value.
  Tuple2<T1, T2> withItem1(T1 v) => Tuple2<T1, T2>(v, item2);

  /// Returns a tuple with the second item set to the specified value.
  Tuple2<T1, T2> withItem2(T2 v) => Tuple2<T1, T2>(item1, v);

  /// Creates a [List] containing the items of this [Tuple2].
  ///
  /// The elements are in item order. The list is variable-length
  /// if [growable] is true.
  List toList({bool growable = false}) =>
      List.from([item1, item2], growable: growable);

  @override
  String toString() => '[$item1, $item2]';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tuple2 &&
          runtimeType == other.runtimeType &&
          item1 == other.item1 &&
          item2 == other.item2;

  @override
  int get hashCode => item1.hashCode ^ item2.hashCode;
}

class _PickerWidget extends StatefulWidget {
  final int filePickerIndex;
  final bool containsFile;
  final List<String> selectedMedias;
  final void Function(DefaultAttachmentTypes) onAddMoreFilesClick;
  final void Function(AssetEntity) onMediaSelected;

  const _PickerWidget({
    Key key,
    @required this.filePickerIndex,
    @required this.containsFile,
    @required this.selectedMedias,
    @required this.onAddMoreFilesClick,
    @required this.onMediaSelected,
  }) : super(key: key);

  @override
  __PickerWidgetState createState() => __PickerWidgetState();
}

class __PickerWidgetState extends State<_PickerWidget> {
  Future<bool> requestPermission;

  @override
  void initState() {
    super.initState();
    requestPermission = PhotoManager.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filePickerIndex != 0) {
      return Offstage();
    }
    return FutureBuilder<bool>(
        future: requestPermission,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data) {
            if (widget.containsFile) {
              return GestureDetector(
                onTap: () {
                  widget.onAddMoreFilesClick(DefaultAttachmentTypes.file);
                },
                child: Container(
                  constraints: BoxConstraints.expand(),
                  color: StreamChatTheme.of(context).colorTheme.whiteSmoke,
                  alignment: Alignment.center,
                  child: Text(
                    'Add more files',
                    style: TextStyle(
                      color: StreamChatTheme.of(context).colorTheme.accentBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
            return MediaListView(
              selectedIds: widget.selectedMedias,
              onSelect: widget.onMediaSelected,
            );
          }

          return InkWell(
            onTap: () async {
              PhotoManager.openSetting();
            },
            child: Container(
              color: StreamChatTheme.of(context).colorTheme.whiteSmoke,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SvgPicture.asset(
                    'svgs/icon_picture_empty_state.svg',
                    package: 'stream_chat_flutter',
                    height: 140,
                    color: StreamChatTheme.of(context).colorTheme.greyGainsboro,
                  ),
                  Text(
                    'Please enable access to your photos \nand videos so you can share them with friends.',
                    style: StreamChatTheme.of(context).textTheme.body.copyWith(
                        color: StreamChatTheme.of(context).colorTheme.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6.0),
                  Center(
                    child: Text(
                      'Allow access to your gallery',
                      style: StreamChatTheme.of(context)
                          .textTheme
                          .bodyBold
                          .copyWith(
                            color: StreamChatTheme.of(context)
                                .colorTheme
                                .accentBlue,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
