import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/src/commands_overlay.dart';
import 'package:stream_chat_flutter/src/emoji/emoji.dart';
import 'package:stream_chat_flutter/src/emoji_overlay.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/media_list_view.dart';
import 'package:stream_chat_flutter/src/multi_overlay.dart';
import 'package:stream_chat_flutter/src/quoted_message_widget.dart';
import 'package:stream_chat_flutter/src/user_mentions_overlay.dart';
import 'package:stream_chat_flutter/src/video_service.dart';
import 'package:stream_chat_flutter/src/video_thumbnail_image.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_compress/video_compress.dart';

export 'package:video_compress/video_compress.dart' show VideoQuality;

/// A callback that can be passed to [MessageInput.onError].
///
/// This callback should not throw.
///
/// It exists merely for error reporting, and should not be used otherwise.
typedef ErrorListener = void Function(
  Object error,
  StackTrace? stackTrace,
);

/// A callback that can be passed to [MessageInput.onAttachmentLimitExceed].
///
/// This callback should not throw.
///
/// It exists merely for showing custom error, and should not be used otherwise.
typedef AttachmentLimitExceedListener = void Function(
  int limit,
  String error,
);

/// Builder for attachment thumbnails
typedef AttachmentThumbnailBuilder = Widget Function(
  BuildContext,
  Attachment,
);

/// Builder function for building a mention tile.
typedef MentionTileBuilder = Widget Function(
  BuildContext context,
  Member member,
);

/// Builder function for building a user mention tile.
///
/// Use [UserMentionTile] for the default implementation.
typedef UserMentionTileBuilder = Widget Function(
  BuildContext context,
  User user,
);

/// Widget builder for action button.
///
/// [defaultActionButton] is the default [IconButton] configuration,
/// use [defaultActionButton.copyWith] to easily customize it.
typedef ActionButtonBuilder = Widget Function(
  BuildContext context,
  IconButton defaultActionButton,
);

/// Location for actions on the [MessageInput]
enum ActionsLocation {
  /// Align to left
  left,

  /// Align to right
  right,

  /// Align to left but inside the [TextField]
  leftInside,

  /// Align to right but inside the [TextField]
  rightInside,
}

/// Default attachments for widget
enum DefaultAttachmentTypes {
  /// Image Attachment
  image,

  /// Video Attachment
  video,

  /// File Attachment
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

const _kDefaultMaxAttachmentSize = 20971520; // 20MB in Bytes

/// Inactive state
///
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_input.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_input_paint.png)
///
/// Focused state
///
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_input2.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_input2_paint.png)
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
/// You usually put this widget in the same page of a [MessageListView]
/// as the bottom widget.
///
/// The widget renders the ui based on the first ancestor of
/// type [StreamChatTheme].
/// Modify it to change the widget appearance.
class MessageInput extends StatefulWidget {
  /// Instantiate a new MessageInput
  const MessageInput({
    Key? key,
    this.onMessageSent,
    this.preMessageSending,
    this.parentMessage,
    this.editMessage,
    this.maxHeight = 150,
    this.keyboardType = TextInputType.multiline,
    this.disableAttachments = false,
    this.initialMessage,
    this.textEditingController,
    this.actions = const [],
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
    @Deprecated('''Use `userMentionsTileBuilder` instead. Will be removed in future release''')
        this.mentionsTileBuilder,
    this.userMentionsTileBuilder,
    this.maxAttachmentSize = _kDefaultMaxAttachmentSize,
    this.compressedVideoQuality = VideoQuality.DefaultQuality,
    this.compressedVideoFrameRate = 30,
    this.onError,
    this.attachmentLimit = 10,
    this.onAttachmentLimitExceed,
    this.attachmentButtonBuilder,
    this.commandButtonBuilder,
    this.customOverlays = const [],
    this.mentionAllAppUsers = false,
    this.shouldKeepFocusAfterMessage,
  })  : assert(
          initialMessage == null || editMessage == null,
          "Can't provide both `initialMessage` and `editMessage`",
        ),
        super(key: key);

  /// List of options for showing overlays
  final List<OverlayOptions> customOverlays;

  /// Message to edit
  final Message? editMessage;

  /// Video quality to use when compressing the videos
  final VideoQuality compressedVideoQuality;

  /// Frame rate to use when compressing the videos
  final int compressedVideoFrameRate;

  /// Max attachment size in bytes
  /// Defaults to 20 MB
  /// do not set it if you're using our default CDN
  final int maxAttachmentSize;

  /// Message to start with
  final Message? initialMessage;

  /// Function called after sending the message
  final void Function(Message)? onMessageSent;

  /// Function called right before sending the message
  /// Use this to transform the message
  final FutureOr<Message> Function(Message)? preMessageSending;

  /// Parent message in case of a thread
  final Message? parentMessage;

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
  final TextEditingController? textEditingController;

  /// List of action widgets
  final List<Widget> actions;

  /// The location of the custom actions
  final ActionsLocation actionsLocation;

  /// Map that defines a thumbnail builder for an attachment type
  final Map<String, AttachmentThumbnailBuilder>? attachmentThumbnailBuilders;

  /// The focus node associated to the TextField
  final FocusNode? focusNode;

  ///
  final Message? quotedMessage;

  ///
  final VoidCallback? onQuotedMessageCleared;

  /// The location of the send button
  final SendButtonLocation sendButtonLocation;

  /// Autofocus property passed to the TextField
  final bool autofocus;

  /// Send button widget in an idle state
  final Widget? idleSendButton;

  /// Send button widget in an active state
  final Widget? activeSendButton;

  /// Customize the tile for the mentions overlay.
  final MentionTileBuilder? mentionsTileBuilder;

  /// Customize the tile for the mentions overlay.
  final UserMentionTileBuilder? userMentionsTileBuilder;

  /// A callback for error reporting
  final ErrorListener? onError;

  /// A limit for the no. of attachments that can be sent with a single message.
  final int attachmentLimit;

  /// A callback for when the [attachmentLimit] is exceeded.
  ///
  /// This will override the default error alert behaviour.
  final AttachmentLimitExceedListener? onAttachmentLimitExceed;

  /// Builder for customizing the attachment button.
  ///
  /// The builder contains the default [IconButton] that can be customized by
  /// calling `.copyWith`.
  final ActionButtonBuilder? attachmentButtonBuilder;

  /// Builder for customizing the command button.
  ///
  /// The builder contains the default [IconButton] that can be customized by
  /// calling `.copyWith`.
  final ActionButtonBuilder? commandButtonBuilder;

  /// When enabled mentions search users across the entire app.
  ///
  /// Defaults to false.
  final bool mentionAllAppUsers;

  /// Defines if the [MessageInput] loses focuses after a message is sent.
  /// The default behaviour keeps focus until a command is enabled.
  final bool? shouldKeepFocusAfterMessage;

  @override
  MessageInputState createState() => MessageInputState();

  /// Use this method to get the current [StreamChatState] instance
  static MessageInputState of(BuildContext context) {
    MessageInputState? messageInputState;
    messageInputState = context.findAncestorStateOfType<MessageInputState>();
    assert(
      messageInputState != null,
      'You must have a MessageInput widget as ancestor of your widget tree',
    );
    return messageInputState!;
  }
}

/// State of [MessageInput]
class MessageInputState extends State<MessageInput> {
  final _attachments = <String, Attachment>{};
  final List<User> _mentionedUsers = [];

  final _imagePicker = ImagePicker();
  late final _focusNode = widget.focusNode ?? FocusNode();
  late final _isInternalFocusNode = widget.focusNode == null;
  bool _inputEnabled = true;
  bool _commandEnabled = false;
  bool _showCommandsOverlay = false;
  bool _showMentionsOverlay = false;

  Command? _chosenCommand;
  bool _actionsShrunk = false;
  bool _sendAsDm = false;
  bool _openFilePickerSection = false;
  int _filePickerIndex = 0;

  /// The editing controller passed to the input TextField
  late final TextEditingController textEditingController =
      widget.textEditingController ?? TextEditingController();

  late StreamChatThemeData _streamChatTheme;
  late MessageInputThemeData _messageInputTheme;

  bool get _hasQuotedMessage => widget.quotedMessage != null;

  bool get _messageIsPresent => textEditingController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (widget.editMessage != null || widget.initialMessage != null) {
      _parseExistingMessage(widget.editMessage ?? widget.initialMessage!);
    }
    textEditingController.addListener(_onChangedDebounced);
    _focusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (_focusNode.hasFocus) {
      _openFilePickerSection = false;
    }
  }

  int _timeOut = 0;
  Timer? _slowModeTimer;

  void _startSlowMode() {
    if (!mounted) {
      return;
    }
    final channel = StreamChannel.of(context).channel;
    final cooldownStartedAt = channel.cooldownStartedAt;
    if (cooldownStartedAt != null) {
      final diff = DateTime.now().difference(cooldownStartedAt).inSeconds;
      if (diff < channel.cooldown) {
        _timeOut = channel.cooldown - diff;
        if (_timeOut > 0) {
          _slowModeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
            if (_timeOut == 0) {
              timer.cancel();
            } else {
              if (mounted) {
                setState(() => _timeOut -= 1);
              }
            }
          });
        }
      }
    }
  }

  void _stopSlowMode() => _slowModeTimer?.cancel();

  @override
  Widget build(BuildContext context) {
    Widget child = DecoratedBox(
      decoration: BoxDecoration(
        color: _messageInputTheme.inputBackgroundColor,
      ),
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
                        padding: const EdgeInsets.all(8),
                        child: StreamSvgIcon.reply(
                          color: _streamChatTheme.colorTheme.disabled,
                        ),
                      ),
                      Text(
                        context.translations.replyToMessageLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: _buildTextField(context),
              ),
              if (widget.parentMessage != null && !widget.hideSendAsDm)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 12,
                    left: 12,
                    bottom: 12,
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
        color: _messageInputTheme.inputBackgroundColor,
        child: child,
      );
    }

    return MultiOverlay(
      childAnchor: Alignment.topCenter,
      overlayAnchor: Alignment.bottomCenter,
      overlayOptions: [
        OverlayOptions(
          visible: _showCommandsOverlay,
          widget: _buildCommandsOverlayEntry(),
        ),
        OverlayOptions(
          visible: _focusNode.hasFocus &&
              textEditingController.text.isNotEmpty &&
              textEditingController.selection.baseOffset > 0 &&
              textEditingController.text
                  .substring(
                    0,
                    textEditingController.selection.baseOffset,
                  )
                  .contains(':'),
          widget: _buildEmojiOverlay(),
        ),
        OverlayOptions(
          visible: _showMentionsOverlay,
          widget: _buildMentionsOverlayEntry(),
        ),
        ...widget.customOverlays,
      ],
      child: child,
    );
  }

  Flex _buildTextField(BuildContext context) => Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          if (!_commandEnabled &&
              widget.actionsLocation == ActionsLocation.left)
            _buildExpandActionsButton(context),
          _buildTextInput(context),
          if (!_commandEnabled &&
              widget.actionsLocation == ActionsLocation.right)
            _buildExpandActionsButton(context),
          if (widget.sendButtonLocation == SendButtonLocation.outside)
            _animateSendButton(context),
        ],
      );

  Widget _buildDmCheckbox() => Row(
        children: [
          Container(
            height: 16,
            width: 16,
            foregroundDecoration: BoxDecoration(
              border: _sendAsDm
                  ? null
                  : Border.all(
                      color: _streamChatTheme.colorTheme.textHighEmphasis
                          .withOpacity(0.5),
                      width: 2,
                    ),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Center(
              child: Material(
                borderRadius: BorderRadius.circular(3),
                color: _sendAsDm
                    ? _streamChatTheme.colorTheme.accentPrimary
                    : _streamChatTheme.colorTheme.barsBg,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _sendAsDm = !_sendAsDm;
                    });
                  },
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    reverseDuration: const Duration(milliseconds: 300),
                    crossFadeState: _sendAsDm
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: StreamSvgIcon.check(
                      size: 16,
                      color: _streamChatTheme.colorTheme.barsBg,
                    ),
                    secondChild: const SizedBox(
                      height: 16,
                      width: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              context.translations.alsoSendAsDirectMessageLabel,
              style: _streamChatTheme.textTheme.footnote.copyWith(
                color: _streamChatTheme.colorTheme.textHighEmphasis
                    .withOpacity(0.5),
              ),
            ),
          ),
        ],
      );

  Widget _animateSendButton(BuildContext context) {
    late Widget sendButton;
    if (_timeOut > 0) {
      sendButton = _CountdownButton(count: _timeOut);
    } else if (!_messageIsPresent && _attachments.isEmpty) {
      sendButton = widget.idleSendButton ?? _buildIdleSendButton(context);
    } else {
      sendButton = widget.activeSendButton != null
          ? InkWell(
              onTap: sendMessage,
              child: widget.activeSendButton,
            )
          : _buildSendButton(context);
    }

    return AnimatedSwitcher(
      duration: _streamChatTheme.messageInputTheme.sendAnimationDuration!,
      child: sendButton,
    );
  }

  Widget _buildExpandActionsButton(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AnimatedCrossFade(
        crossFadeState: _actionsShrunk
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstCurve: Curves.easeOut,
        secondCurve: Curves.easeIn,
        firstChild: IconButton(
          onPressed: () {
            if (_actionsShrunk) {
              setState(() => _actionsShrunk = false);
            }
          },
          icon: Transform.rotate(
            angle: (widget.actionsLocation == ActionsLocation.right ||
                    widget.actionsLocation == ActionsLocation.rightInside)
                ? pi
                : 0,
            child: StreamSvgIcon.emptyCircleLeft(
              color: _messageInputTheme.expandButtonColor,
            ),
          ),
          padding: const EdgeInsets.all(0),
          constraints: const BoxConstraints.tightFor(
            height: 24,
            width: 24,
          ),
          splashRadius: 24,
        ),
        secondChild: widget.disableAttachments &&
                !widget.showCommandsButton &&
                !widget.actions.isNotEmpty
            ? const Offstage()
            : Wrap(
                children: <Widget>[
                  if (!widget.disableAttachments)
                    _buildAttachmentButton(context),
                  if (widget.showCommandsButton &&
                      widget.editMessage == null &&
                      channel.state != null &&
                      channel.config?.commands.isNotEmpty == true)
                    _buildCommandButton(context),
                  ...widget.actions,
                ].insertBetween(const SizedBox(width: 8)),
              ),
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
      ),
    );
  }

  Expanded _buildTextInput(BuildContext context) {
    final margin = (widget.sendButtonLocation == SendButtonLocation.inside
            ? const EdgeInsets.only(right: 8)
            : EdgeInsets.zero) +
        (widget.actionsLocation != ActionsLocation.left || _commandEnabled
            ? const EdgeInsets.only(left: 8)
            : EdgeInsets.zero);
    return Expanded(
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: _messageInputTheme.borderRadius,
          gradient: _focusNode.hasFocus
              ? _messageInputTheme.activeBorderGradient
              : _messageInputTheme.idleBorderGradient,
          color: _messageInputTheme.inputBackgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.5),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: _messageInputTheme.borderRadius,
              color: _messageInputTheme.inputBackgroundColor,
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
                    key: const Key('messageInputText'),
                    enabled: _inputEnabled,
                    maxLines: null,
                    onSubmitted: (_) => sendMessage(),
                    keyboardType: widget.keyboardType,
                    controller: textEditingController,
                    focusNode: _focusNode,
                    style: _messageInputTheme.inputTextStyle,
                    autofocus: widget.autofocus,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: _getInputDecoration(context),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _getInputDecoration(BuildContext context) {
    final passedDecoration = _messageInputTheme.inputDecoration;
    return InputDecoration(
      isDense: true,
      hintText: _getHint(context),
      hintStyle: _messageInputTheme.inputTextStyle!.copyWith(
        color: _streamChatTheme.colorTheme.textLowEmphasis,
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      disabledBorder: const OutlineInputBorder(
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
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    constraints: BoxConstraints.tight(const Size(64, 24)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _streamChatTheme.colorTheme.accentPrimary,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StreamSvgIcon.lightning(
                          color: Colors.white,
                          size: 16,
                        ),
                        Text(
                          _chosenCommand?.name.toUpperCase() ?? '',
                          style:
                              _streamChatTheme.textTheme.footnoteBold.copyWith(
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
                  children: [_buildExpandActionsButton(context)],
                )
              : null),
      suffixIconConstraints: const BoxConstraints.tightFor(height: 40),
      prefixIconConstraints: const BoxConstraints.tightFor(height: 40),
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_commandEnabled)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: StreamSvgIcon.closeSmall(),
                splashRadius: 24,
                padding: const EdgeInsets.all(0),
                constraints: const BoxConstraints.tightFor(
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
            _buildExpandActionsButton(context),
          if (widget.sendButtonLocation == SendButtonLocation.inside)
            _animateSendButton(context),
        ],
      ),
    ).merge(passedDecoration);
  }

  late final _onChangedDebounced = debounce(
    () {
      var value = textEditingController.text;
      if (!mounted) return;
      value = value.trim();

      final channel = StreamChannel.of(context).channel;
      if (value.isNotEmpty) {
        // ignore: no-empty-block
        channel.keyStroke(widget.parentMessage?.id).catchError((e) {});
      }

      var actionsLength = widget.actions.length;
      if (widget.showCommandsButton) actionsLength += 1;
      if (!widget.disableAttachments) actionsLength += 1;

      setState(() {
        _actionsShrunk = value.isNotEmpty && actionsLength > 1;
      });

      _checkCommands(value, context);
      _checkMentions(value, context);
      _checkEmoji(value, context);
    },
    const Duration(milliseconds: 350),
    leading: true,
  );

  String _getHint(BuildContext context) {
    if (_commandEnabled && _chosenCommand!.name == 'giphy') {
      return context.translations.searchGifLabel;
    }
    if (_attachments.isNotEmpty) {
      return context.translations.addACommentOrSendLabel;
    }
    if (_timeOut != 0) {
      return context.translations.slowModeOnLabel;
    }

    return context.translations.writeAMessageLabel;
  }

  void _checkEmoji(String s, BuildContext context) {
    if (s.isNotEmpty &&
        textEditingController.selection.baseOffset > 0 &&
        textEditingController.text
            .substring(0, textEditingController.selection.baseOffset)
            .contains(':')) {
      final textToSelection = textEditingController.text
          .substring(0, textEditingController.value.selection.start);
      final splits = textToSelection.split(':');
      final query = splits[splits.length - 2].toLowerCase();
      final emoji = Emoji.byName(query);

      if (textToSelection.endsWith(':') && emoji != null) {
        _chooseEmoji(splits.sublist(0, splits.length - 1), emoji);
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
      if (!_showMentionsOverlay) {
        setState(() {
          _showMentionsOverlay = true;
        });
      }
    } else if (_showMentionsOverlay) {
      setState(() {
        _showMentionsOverlay = false;
      });
    }
  }

  void _checkCommands(String s, BuildContext context) {
    if (s.startsWith('/')) {
      final allCommands = StreamChannel.of(context).channel.config?.commands;
      final command =
          allCommands?.firstWhereOrNull((it) => it.name == s.substring(1));
      if (command != null) {
        return _setCommand(command);
      } else if (!_showCommandsOverlay) {
        setState(() {
          _showCommandsOverlay = true;
        });
      }
    } else if (_showCommandsOverlay) {
      setState(() {
        _showCommandsOverlay = false;
      });
    }
  }

  Widget _buildCommandsOverlayEntry() {
    final text = textEditingController.text.trimLeft();

    final renderObject = context.findRenderObject() as RenderBox?;
    if (renderObject == null) {
      return const Offstage();
    }
    return CommandsOverlay(
      channel: StreamChannel.of(context).channel,
      size: Size(renderObject.size.width - 16, 400),
      text: text,
      onCommandResult: _setCommand,
    );
  }

  Widget _buildFilePickerSection() {
    final _attachmentContainsFile =
        _attachments.values.any((it) => it.type == 'file');

    final attachmentLimitCrossed =
        _attachments.length >= widget.attachmentLimit;

    Color _getIconColor(int index) {
      final streamChatThemeData = _streamChatTheme;
      switch (index) {
        case 0:
          return _attachments.isEmpty
              ? streamChatThemeData.colorTheme.accentPrimary
              : (!_attachmentContainsFile
                  ? streamChatThemeData.colorTheme.accentPrimary
                  : streamChatThemeData.colorTheme.textHighEmphasis
                      .withOpacity(0.2));
        case 1:
          return _attachmentContainsFile
              ? streamChatThemeData.colorTheme.accentPrimary
              : (_attachments.isEmpty
                  ? streamChatThemeData.colorTheme.textHighEmphasis
                      .withOpacity(0.5)
                  : streamChatThemeData.colorTheme.textHighEmphasis
                      .withOpacity(0.2));
        case 2:
          return attachmentLimitCrossed
              ? streamChatThemeData.colorTheme.textHighEmphasis.withOpacity(0.2)
              : _attachmentContainsFile && _attachments.isNotEmpty
                  ? streamChatThemeData.colorTheme.textHighEmphasis
                      .withOpacity(0.2)
                  : streamChatThemeData.colorTheme.textHighEmphasis
                      .withOpacity(0.5);
        case 3:
          return attachmentLimitCrossed
              ? streamChatThemeData.colorTheme.textHighEmphasis.withOpacity(0.2)
              : _attachmentContainsFile && _attachments.isNotEmpty
                  ? streamChatThemeData.colorTheme.textHighEmphasis
                      .withOpacity(0.2)
                  : streamChatThemeData.colorTheme.textHighEmphasis
                      .withOpacity(0.5);
        default:
          return Colors.black;
      }
    }

    return AnimatedContainer(
      duration: _openFilePickerSection
          ? const Duration(milliseconds: 300)
          : const Duration(),
      curve: Curves.easeOut,
      height: _openFilePickerSection ? _kMinMediaPickerSize : 0,
      child: SingleChildScrollView(
        child: SizedBox(
          height: _kMinMediaPickerSize,
          child: Material(
            color: _streamChatTheme.colorTheme.inputBg,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: StreamSvgIcon.pictures(
                        color: _getIconColor(0),
                      ),
                      onPressed:
                          _attachmentContainsFile && _attachments.isNotEmpty
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
                      onPressed:
                          !_attachmentContainsFile && _attachments.isNotEmpty
                              ? null
                              : () {
                                  pickFile(DefaultAttachmentTypes.file);
                                },
                    ),
                    IconButton(
                      icon: StreamSvgIcon.camera(
                        color: _getIconColor(2),
                      ),
                      onPressed: attachmentLimitCrossed ||
                              (_attachmentContainsFile &&
                                  _attachments.isNotEmpty)
                          ? null
                          : () {
                              pickFile(
                                DefaultAttachmentTypes.image,
                                camera: true,
                              );
                            },
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: StreamSvgIcon.record(
                        color: _getIconColor(3),
                      ),
                      onPressed: attachmentLimitCrossed ||
                              (_attachmentContainsFile &&
                                  _attachments.isNotEmpty)
                          ? null
                          : () {
                              pickFile(
                                DefaultAttachmentTypes.video,
                                camera: true,
                              );
                            },
                    ),
                  ],
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: _streamChatTheme.colorTheme.barsBg,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _streamChatTheme.colorTheme.inputBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_openFilePickerSection)
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: _streamChatTheme.colorTheme.barsBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _PickerWidget(
                        filePickerIndex: _filePickerIndex,
                        streamChatTheme: _streamChatTheme,
                        containsFile: _attachmentContainsFile,
                        selectedMedias: _attachments.keys.toList(),
                        onAddMoreFilesClick: pickFile,
                        onMediaSelected: (media) {
                          if (_attachments.containsKey(media.id)) {
                            setState(() => _attachments.remove(media.id));
                          } else {
                            _addAssetAttachment(media);
                          }
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addAssetAttachment(AssetEntity medium) async {
    final mediaFile = await medium.originFile.timeout(
      const Duration(seconds: 5),
      onTimeout: () => medium.originFile,
    );

    if (mediaFile == null) return;

    var file = AttachmentFile(
      path: mediaFile.path,
      size: await mediaFile.length(),
      bytes: mediaFile.readAsBytesSync(),
    );

    if (file.size! > widget.maxAttachmentSize) {
      if (medium.type == AssetType.video && file.path != null) {
        final mediaInfo = await VideoService.compressVideo(
          file.path!,
          frameRate: widget.compressedVideoFrameRate,
          quality: widget.compressedVideoQuality,
        );

        if (mediaInfo == null ||
            mediaInfo.filesize! > widget.maxAttachmentSize) {
          _showErrorAlert(
            context.translations.fileTooLargeAfterCompressionError(
              widget.maxAttachmentSize / (1024 * 1024),
            ),
          );
          return;
        }
        file = AttachmentFile(
          name: file.name,
          size: mediaInfo.filesize,
          bytes: await mediaInfo.file?.readAsBytes(),
          path: mediaInfo.path,
        );
      } else {
        _showErrorAlert(context.translations.fileTooLargeError(
          widget.maxAttachmentSize / (1024 * 1024),
        ));
        return;
      }
    }

    setState(() {
      final attachment = Attachment(
        id: medium.id,
        file: file,
        type: medium.type == AssetType.image ? 'image' : 'video',
      );
      _addAttachments([attachment]);
    });
  }

  Widget _buildMentionsOverlayEntry() {
    final channel = StreamChannel.of(context).channel;
    if (textEditingController.value.selection.start < 0 ||
        channel.state == null) {
      return const Offstage();
    }

    final splits = textEditingController.text
        .substring(0, textEditingController.value.selection.start)
        .split('@');
    final query = splits.last.toLowerCase();

    // ignore: cast_nullable_to_non_nullable
    final renderObject = context.findRenderObject() as RenderBox;

    var tileBuilder = widget.userMentionsTileBuilder;
    if (tileBuilder == null && widget.mentionsTileBuilder != null) {
      tileBuilder = (context, user) {
        final member = Member(
          user: user,
          userId: user.id,
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
        );
        return widget.mentionsTileBuilder!(context, member);
      };
    }

    return LayoutBuilder(
      builder: (context, snapshot) => UserMentionsOverlay(
        query: query,
        mentionAllAppUsers: widget.mentionAllAppUsers,
        client: StreamChat.of(context).client,
        channel: channel,
        size: Size(
          renderObject.size.width - 16,
          min(400, (snapshot.maxHeight - renderObject.size.height - 16).abs()),
        ),
        mentionsTileBuilder: tileBuilder,
        onMentionUserTap: (user) {
          _mentionedUsers.add(user);
          splits[splits.length - 1] = user.name;
          final rejoin = splits.join('@');

          textEditingController.value = TextEditingValue(
            text: rejoin +
                textEditingController.text.substring(
                  textEditingController.selection.start,
                ),
            selection: TextSelection.collapsed(
              offset: rejoin.length,
            ),
          );
          _onChangedDebounced.cancel();

          setState(() => _showMentionsOverlay = false);
        },
      ),
    );
  }

  Widget _buildEmojiOverlay() {
    if (textEditingController.value.selection.baseOffset < 0) {
      return const Offstage();
    }

    final splits = textEditingController.text
        .substring(0, textEditingController.value.selection.baseOffset)
        .split(':');

    final query = splits.last.toLowerCase();
    // ignore: cast_nullable_to_non_nullable
    final renderObject = context.findRenderObject() as RenderBox;

    return EmojiOverlay(
      size: Size(renderObject.size.width - 16, 200),
      query: query,
      onEmojiResult: (emoji) {
        _chooseEmoji(splits, emoji);
      },
    );
  }

  void _chooseEmoji(List<String> splits, Emoji emoji) {
    final rejoin = splits.sublist(0, splits.length - 1).join(':') + emoji.char!;

    textEditingController.value = TextEditingValue(
      text: rejoin +
          textEditingController.text
              .substring(textEditingController.selection.start),
      selection: TextSelection.collapsed(
        offset: rejoin.length,
      ),
    );
  }

  void _setCommand(Command c) {
    textEditingController.clear();
    setState(() {
      _chosenCommand = c;
      _commandEnabled = true;
      _showCommandsOverlay = false;
    });
  }

  Widget _buildReplyToMessage() {
    if (!_hasQuotedMessage) return const Offstage();
    final containsUrl = widget.quotedMessage!.attachments
        .any((element) => element.ogScrapeUrl!= null);
    return QuotedMessageWidget(
      reverse: true,
      showBorder: !containsUrl,
      message: widget.quotedMessage!,
      messageTheme: _streamChatTheme.otherMessageTheme,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
    );
  }

  Widget _buildAttachments() {
    if (_attachments.isEmpty) return const Offstage();
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
              maxHeight: 136,
              child: ListView(
                reverse: true,
                shrinkWrap: true,
                children: fileAttachments.reversed
                    .map<Widget>(
                      (e) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FileAttachment(
                          message: Message(
                            status: MessageSendingStatus.sending,
                          ), // dummy message
                          attachment: e,
                          size: Size(
                            MediaQuery.of(context).size.width * 0.65,
                            56,
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.all(8),
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
              maxHeight: 104,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: remainingAttachments
                    .map<Widget>(
                      (attachment) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 1,
                              child: SizedBox(
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

  Widget _buildRemoveButton(Attachment attachment) => SizedBox(
        height: 24,
        width: 24,
        child: RawMaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          highlightElevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          onPressed: () {
            setState(() => _attachments.remove(attachment.id));
          },
          fillColor:
              _streamChatTheme.colorTheme.textHighEmphasis.withOpacity(0.5),
          child: Center(
            child: StreamSvgIcon.close(
              size: 24,
              color: _streamChatTheme.colorTheme.barsBg,
            ),
          ),
        ),
      );

  Widget _buildAttachment(Attachment attachment) {
    if (widget.attachmentThumbnailBuilders?.containsKey(attachment.type) ==
        true) {
      return widget.attachmentThumbnailBuilders![attachment.type!]!(
        context,
        attachment,
      );
    }

    switch (attachment.type) {
      case 'image':
      case 'giphy':
        return attachment.file != null
            ? Image.memory(
                attachment.file!.bytes!,
                fit: BoxFit.cover,
                errorBuilder: (context, _, __) => Image.asset(
                  'images/placeholder.png',
                  package: 'stream_chat_flutter',
                ),
              )
            : CachedNetworkImage(
                imageUrl: attachment.imageUrl ??
                    attachment.assetUrl ??
                    attachment.thumbUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, obj, trace) =>
                    getFileTypeImage(attachment.extraData['other'] as String?),
                placeholder: (context, _) => Shimmer.fromColors(
                  baseColor: _streamChatTheme.colorTheme.disabled,
                  highlightColor: _streamChatTheme.colorTheme.inputBg,
                  child: Image.asset(
                    'images/placeholder.png',
                    fit: BoxFit.cover,
                    package: 'stream_chat_flutter',
                  ),
                ),
              );
      case 'video':
        return Stack(
          children: [
            VideoThumbnailImage(
              height: 104,
              width: 104,
              video: (attachment.file?.path ?? attachment.assetUrl)!,
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
          child: const Icon(Icons.insert_drive_file),
        );
    }
  }

  Widget _buildCommandButton(BuildContext context) {
    final s = textEditingController.text.trim();
    final defaultButton = IconButton(
      icon: StreamSvgIcon.lightning(
        color: s.isNotEmpty
            ? _streamChatTheme.colorTheme.disabled
            : (_showCommandsOverlay
                ? _messageInputTheme.actionButtonColor
                : _messageInputTheme.actionButtonIdleColor),
      ),
      padding: const EdgeInsets.all(0),
      constraints: const BoxConstraints.tightFor(
        height: 24,
        width: 24,
      ),
      splashRadius: 24,
      onPressed: () async {
        if (_openFilePickerSection) {
          setState(() => _openFilePickerSection = false);
          await Future.delayed(const Duration(milliseconds: 300));
        }

        setState(() {
          _showCommandsOverlay = !_showCommandsOverlay;
        });
      },
    );

    return widget.commandButtonBuilder?.call(context, defaultButton) ??
        defaultButton;
  }

  Widget _buildAttachmentButton(BuildContext context) {
    final defaultButton = IconButton(
      icon: StreamSvgIcon.attach(
        color: _openFilePickerSection
            ? _messageInputTheme.actionButtonColor
            : _messageInputTheme.actionButtonIdleColor,
      ),
      padding: const EdgeInsets.all(0),
      constraints: const BoxConstraints.tightFor(
        height: 24,
        width: 24,
      ),
      splashRadius: 24,
      onPressed: () async {
        _showCommandsOverlay = false;
        _showMentionsOverlay = false;

        if (_openFilePickerSection) {
          setState(() => _openFilePickerSection = false);
        } else {
          showAttachmentModal();
        }
      },
    );

    return widget.attachmentButtonBuilder?.call(context, defaultButton) ??
        defaultButton;
  }

  /// Show the attachment modal, making the user choose where to
  /// pick a media from
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        context: context,
        isScrollControlled: true,
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                context.translations.addAFileLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: Text(context.translations.uploadAPhotoLabel),
              onTap: () {
                pickFile(DefaultAttachmentTypes.image);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: Text(context.translations.uploadAVideoLabel),
              onTap: () {
                pickFile(DefaultAttachmentTypes.video);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: Text(context.translations.uploadAFileLabel),
              onTap: () {
                pickFile(DefaultAttachmentTypes.file);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  /// Add an attachment to the sending message
  /// Use this to add custom type attachments
  ///
  /// Note: Only meant to be used from outside the state.
  void addAttachment(Attachment attachment) {
    setState(() => _addAttachments([attachment]));
  }

  /// Adds an attachment to the [_attachments] map
  void _addAttachments(Iterable<Attachment> attachments) {
    final limit = widget.attachmentLimit;
    final length = _attachments.length + attachments.length;
    if (length > limit) {
      final onAttachmentLimitExceed = widget.onAttachmentLimitExceed;
      if (onAttachmentLimitExceed != null) {
        return onAttachmentLimitExceed(
          widget.attachmentLimit,
          context.translations.attachmentLimitExceedError(limit),
        );
      }
      return _showErrorAlert(
        context.translations.attachmentLimitExceedError(limit),
      );
    }
    for (final attachment in attachments) {
      _attachments[attachment.id] = attachment;
    }
  }

  /// Pick a file from the device
  /// If [camera] is true then the camera will open
  void pickFile(
    DefaultAttachmentTypes fileType, {
    bool camera = false,
  }) async {
    setState(() => _inputEnabled = false);

    AttachmentFile? file;
    String? attachmentType;

    if (fileType == DefaultAttachmentTypes.image) {
      attachmentType = 'image';
    } else if (fileType == DefaultAttachmentTypes.video) {
      attachmentType = 'video';
    } else if (fileType == DefaultAttachmentTypes.file) {
      attachmentType = 'file';
    }

    if (camera) {
      XFile? pickedFile;
      if (fileType == DefaultAttachmentTypes.image) {
        pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
      } else if (fileType == DefaultAttachmentTypes.video) {
        pickedFile = await _imagePicker.pickVideo(source: ImageSource.camera);
      }
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        file = AttachmentFile(
          size: bytes.length,
          path: pickedFile.path,
          bytes: bytes,
        );
      }
    } else {
      late FileType type;
      if (fileType == DefaultAttachmentTypes.image) {
        type = FileType.image;
      } else if (fileType == DefaultAttachmentTypes.video) {
        type = FileType.video;
      } else if (fileType == DefaultAttachmentTypes.file) {
        type = FileType.any;
      }
      final res = await FilePicker.platform.pickFiles(
        type: type,
      );
      if (res?.files.isNotEmpty == true) {
        file = res!.files.single.toAttachmentFile;
      }
    }

    setState(() => _inputEnabled = true);

    if (file == null) return;

    final mimeType = file.name?.mimeType ?? file.path!.split('/').last.mimeType;

    final extraDataMap = <String, Object>{};

    if (mimeType?.subtype != null) {
      extraDataMap['mime_type'] = mimeType!.subtype.toLowerCase();
    }

    extraDataMap['file_size'] = file.size!;

    final attachment = Attachment(
      file: file,
      type: attachmentType,
      uploadState: const UploadState.preparing(),
      extraData: extraDataMap,
    );

    if (file.size! > widget.maxAttachmentSize) {
      if (attachmentType == 'video' && file.path != null) {
        final mediaInfo = await (VideoService.compressVideo(
          file.path!,
          frameRate: widget.compressedVideoFrameRate,
          quality: widget.compressedVideoQuality,
        ) as FutureOr<MediaInfo>);

        if (mediaInfo.filesize! > widget.maxAttachmentSize) {
          _showErrorAlert(
            context.translations.fileTooLargeAfterCompressionError(
              widget.maxAttachmentSize / (1024 * 1024),
            ),
          );
          return;
        }
        file = AttachmentFile(
          name: file.name,
          size: mediaInfo.filesize,
          bytes: await mediaInfo.file!.readAsBytes(),
          path: mediaInfo.path,
        );
      } else {
        _showErrorAlert(context.translations.fileTooLargeError(
          widget.maxAttachmentSize / (1024 * 1024),
        ));
        return;
      }
    }

    setState(() {
      _addAttachments([
        attachment.copyWith(
          file: file,
          extraData: {...attachment.extraData}
            ..update('file_size', ((_) => file!.size!)),
        ),
      ]);
    });
  }

  Widget _buildIdleSendButton(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: StreamSvgIcon(
          assetName: _getIdleSendIcon(),
          color: _messageInputTheme.sendButtonIdleColor,
        ),
      );

  Widget _buildSendButton(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: IconButton(
          onPressed: sendMessage,
          padding: const EdgeInsets.all(0),
          splashRadius: 24,
          constraints: const BoxConstraints.tightFor(
            height: 24,
            width: 24,
          ),
          icon: StreamSvgIcon(
            assetName: _getSendIcon(),
            color: _messageInputTheme.sendButtonColor,
          ),
        ),
      );

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
  Future<void> sendMessage() async {
    var text = textEditingController.text.trim();
    if (text.isEmpty && _attachments.isEmpty) {
      return;
    }

    var shouldKeepFocus = widget.shouldKeepFocusAfterMessage;

    shouldKeepFocus ??= !_commandEnabled;

    if (_commandEnabled) {
      text = '${'/${_chosenCommand!.name} '}$text';
    }

    final attachments = [..._attachments.values];

    textEditingController.clear();
    _attachments.clear();
    widget.onQuotedMessageCleared?.call();

    setState(() {
      _commandEnabled = false;
    });

    Message message;
    if (widget.editMessage != null) {
      message = widget.editMessage!.copyWith(
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
        quotedMessageId: widget.quotedMessage!.id,
      );
    }

    if (widget.preMessageSending != null) {
      message = await widget.preMessageSending!(message);
    }

    final streamChannel = StreamChannel.of(context);
    final channel = streamChannel.channel;
    if (!channel.state!.isUpToDate) {
      await streamChannel.reloadChannel();
    }

    _mentionedUsers.clear();

    message = _replaceUserNameWithId(message);

    try {
      Future sendingFuture;
      if (widget.editMessage == null ||
          widget.editMessage!.status == MessageSendingStatus.failed ||
          widget.editMessage!.status == MessageSendingStatus.sending) {
        sendingFuture = channel.sendMessage(message);
      } else {
        sendingFuture = channel.updateMessage(message);
      }

      if (shouldKeepFocus) {
        FocusScope.of(context).requestFocus(_focusNode);
      } else {
        FocusScope.of(context).unfocus();
      }

      final resp = await sendingFuture;
      if (resp.message?.type == 'error') {
        _parseExistingMessage(message);
      }
      _startSlowMode();
      widget.onMessageSent?.call(resp.message);
    } catch (e, stk) {
      if (widget.onError != null) {
        widget.onError?.call(e, stk);
      } else {
        rethrow;
      }
    }
  }

  void _showErrorAlert(String description) {
    showModalBottomSheet(
      backgroundColor: _streamChatTheme.colorTheme.barsBg,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 26,
          ),
          StreamSvgIcon.error(
            color: _streamChatTheme.colorTheme.accentError,
            size: 24,
          ),
          const SizedBox(
            height: 26,
          ),
          Text(
            context.translations.somethingWentWrongError,
            style: _streamChatTheme.textTheme.headlineBold,
          ),
          const SizedBox(
            height: 7,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              description,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 36,
          ),
          Container(
            color:
                _streamChatTheme.colorTheme.textHighEmphasis.withOpacity(0.08),
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  context.translations.okLabel,
                  style: _streamChatTheme.textTheme.bodyBold.copyWith(
                    color: _streamChatTheme.colorTheme.accentPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _parseExistingMessage(Message message) {
    final messageText = message.text;
    if (messageText != null) textEditingController.text = messageText;
    _addAttachments(message.attachments);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    _focusNode.removeListener(_focusNodeListener);
    if (_isInternalFocusNode) _focusNode.dispose();
    _stopSlowMode();
    _onChangedDebounced.cancel();
    super.dispose();
  }

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    _streamChatTheme = StreamChatTheme.of(context);
    _messageInputTheme = MessageInputTheme.of(context);
    if (widget.editMessage == null) _startSlowMode();

    if ((widget.editMessage != null || widget.initialMessage != null) &&
        !_initialized) {
      FocusScope.of(context).requestFocus(_focusNode);
      _initialized = true;
    }
    super.didChangeDependencies();
  }
}

class _PickerWidget extends StatefulWidget {
  const _PickerWidget({
    Key? key,
    required this.filePickerIndex,
    required this.containsFile,
    required this.selectedMedias,
    required this.onAddMoreFilesClick,
    required this.onMediaSelected,
    required this.streamChatTheme,
  }) : super(key: key);

  final int filePickerIndex;
  final bool containsFile;
  final List<String> selectedMedias;
  final void Function(DefaultAttachmentTypes) onAddMoreFilesClick;
  final void Function(AssetEntity) onMediaSelected;
  final StreamChatThemeData streamChatTheme;

  @override
  _PickerWidgetState createState() => _PickerWidgetState();
}

class _PickerWidgetState extends State<_PickerWidget> {
  Future<PermissionState>? requestPermission;

  @override
  void initState() {
    super.initState();
    requestPermission = PhotoManager.requestPermissionExtend();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filePickerIndex != 0) {
      return const Offstage();
    }
    return FutureBuilder<PermissionState>(
      future: requestPermission,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Offstage();
        }

        if ([PermissionState.authorized, PermissionState.limited]
            .contains(snapshot.data)) {
          if (widget.containsFile) {
            return GestureDetector(
              onTap: () {
                widget.onAddMoreFilesClick(DefaultAttachmentTypes.file);
              },
              child: Container(
                constraints: const BoxConstraints.expand(),
                color: widget.streamChatTheme.colorTheme.inputBg,
                alignment: Alignment.center,
                child: Text(
                  context.translations.addMoreFilesLabel,
                  style: TextStyle(
                    color: widget.streamChatTheme.colorTheme.accentPrimary,
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
            color: widget.streamChatTheme.colorTheme.inputBg,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SvgPicture.asset(
                  'svgs/icon_picture_empty_state.svg',
                  package: 'stream_chat_flutter',
                  height: 140,
                  color: widget.streamChatTheme.colorTheme.disabled,
                ),
                Text(
                  context.translations.enablePhotoAndVideoAccessMessage,
                  style: widget.streamChatTheme.textTheme.body.copyWith(
                    color: widget.streamChatTheme.colorTheme.textLowEmphasis,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    context.translations.allowGalleryAccessMessage,
                    style: widget.streamChatTheme.textTheme.bodyBold.copyWith(
                      color: widget.streamChatTheme.colorTheme.accentPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CountdownButton extends StatelessWidget {
  const _CountdownButton({
    Key? key,
    required this.count,
  }) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: StreamChatTheme.of(context).colorTheme.disabled,
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            height: 24,
            width: 24,
            child: Center(
              child: Text('$count'),
            ),
          ),
        ),
      );
}

Message _replaceUserNameWithId(Message message) {
  final mentionedUsers = message.mentionedUsers;
  if (mentionedUsers.isEmpty) return message;

  var messageTextToSend = message.text;
  if (messageTextToSend == null) return message;

  for (final user in mentionedUsers.toSet()) {
    final userName = user.name;
    messageTextToSend = messageTextToSend!.replaceAll(
      '@$userName',
      '@${user.id}',
    );
  }

  return message.copyWith(text: messageTextToSend);
}
