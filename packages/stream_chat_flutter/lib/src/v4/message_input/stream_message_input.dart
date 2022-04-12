import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart'
    hide ErrorListener;
import 'package:collection/collection.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/platform_widget_builder/src/platform_widget_builder.dart';
import 'package:stream_chat_flutter/src/emoji/emoji.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_button.dart';
import 'package:stream_chat_flutter/src/message_input/dm_checkbox.dart';
import 'package:stream_chat_flutter/src/message_input/file_upload_error_handler.dart';
import 'package:stream_chat_flutter/src/message_input/quoted_message_widget.dart';
import 'package:stream_chat_flutter/src/message_input/quoting_message_top_area.dart';
import 'package:stream_chat_flutter/src/message_input/user_mentions_overlay.dart';
import 'package:stream_chat_flutter/src/overlays/commands_overlay.dart';
import 'package:stream_chat_flutter/src/overlays/emoji_overlay.dart';
import 'package:stream_chat_flutter/src/overlays/multi_overlay.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter/src/v4/message_input/simple_safe_area.dart';
import 'package:stream_chat_flutter/src/v4/message_input/tld.dart';
import 'package:stream_chat_flutter/src/video/video_thumbnail_image.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

const _kMinMediaPickerSize = 360.0;

const _kDefaultMaxAttachmentSize = 20971520; // 20MB in Bytes

/// Inactive state:
///
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_input.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_input_paint.png)
///
/// Focused state:
///
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_input2.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_input2_paint.png)
///
/// Widget used to enter a message and add attachments:
///
/// ```dart
/// class ChannelPage extends StatelessWidget {
///   const ChannelPage({
///     Key? key,
///   }) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) => Scaffold(
///         appBar: const StreamChannelHeader(),
///         body: Column(
///           children: <Widget>[
///             Expanded(
///               child: StreamMessageListView(
///                 threadBuilder: (_, parentMessage) => ThreadPage(
///                   parent: parentMessage,
///                 ),
///               ),
///             ),
///             const StreamMessageInput(),
///           ],
///         ),
///       );
/// }
/// ```
///
/// You usually put this widget in the same page of a [StreamMessageListView]
/// as the bottom widget.
///
/// The widget renders the ui based on the first ancestor of
/// type [StreamChatTheme]. Modify it to change the widget appearance.
class StreamMessageInput extends StatefulWidget {
  /// Instantiate a new MessageInput
  const StreamMessageInput({
    Key? key,
    this.onMessageSent,
    this.preMessageSending,
    this.maxHeight = 150,
    this.keyboardType = TextInputType.multiline,
    this.disableAttachments = false,
    this.messageInputController,
    this.actions = const [],
    this.actionsLocation = ActionsLocation.left,
    this.attachmentThumbnailBuilders,
    this.focusNode,
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
    this.onError,
    this.attachmentLimit = 10,
    this.onAttachmentLimitExceed,
    this.attachmentButtonBuilder,
    this.commandButtonBuilder,
    this.customOverlays = const [],
    this.mentionAllAppUsers = false,
    this.attachmentsPickerBuilder,
    this.sendButtonBuilder,
    this.shouldKeepFocusAfterMessage,
    this.validator = _defaultValidator,
    this.restorationId,
    this.enableSafeArea,
    this.elevation,
    this.shadow,
    this.autoCorrect,
    this.disableEmojiSuggestionsOverlay,
    this.quotedMessage,
    this.onQuotedMessageCleared,
  }) : super(key: key);

  /// List of options for showing overlays.
  final List<OverlayOptions> customOverlays;

  /// Max attachment size in bytes:
  /// - Defaults to 20 MB
  /// - Do not set it if you're using our default CDN
  final int maxAttachmentSize;

  /// Function called after sending the message.
  final void Function(Message)? onMessageSent;

  /// Function called right before sending the message.
  ///
  /// Use this to transform the message.
  final FutureOr<Message> Function(Message)? preMessageSending;

  /// Maximum Height for the TextField to grow before it starts scrolling.
  final double maxHeight;

  /// The keyboard type assigned to the TextField.
  final TextInputType keyboardType;

  /// If true the attachments button will not be displayed.
  final bool disableAttachments;

  /// Use this property to hide/show the commands button.
  final bool showCommandsButton;

  /// Hide send as dm checkbox.
  final bool hideSendAsDm;

  /// The text controller of the TextField.
  final MessageInputController? messageInputController;

  /// List of action widgets.
  final List<Widget> actions;

  /// The location of the custom actions.
  final ActionsLocation actionsLocation;

  /// Map that defines a thumbnail builder for an attachment type.
  final Map<String, AttachmentThumbnailBuilder>? attachmentThumbnailBuilders;

  /// The focus node associated to the TextField.
  final FocusNode? focusNode;

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

  /// Builds bottom sheet when attachment picker is opened.
  final AttachmentsPickerBuilder? attachmentsPickerBuilder;

  /// Builder for creating send button
  final MessageRelatedBuilder? sendButtonBuilder;

  /// Defines if the [StreamMessageInput] loses focuses after a message is sent.
  /// The default behaviour keeps focus until a command is enabled.
  final bool? shouldKeepFocusAfterMessage;

  /// A callback function that validates the message.
  final MessageValidator validator;

  /// Restoration ID to save and restore the state of the MessageInput.
  final String? restorationId;

  /// Wrap [StreamMessageInput] with a [SafeArea widget]
  final bool? enableSafeArea;

  /// Elevation of the [StreamMessageInput]
  final double? elevation;

  /// Shadow for the [StreamMessageInput] widget
  final BoxShadow? shadow;

  /// Disable autoCorrect by passing false
  /// autoCorrect is enabled by default
  final bool? autoCorrect;

  /// Disable the default emoji suggestions
  /// Enabled by default
  final bool? disableEmojiSuggestionsOverlay;

  /// TODO: document me!
  final Message? quotedMessage;

  /// TODO: document me!
  final VoidCallback? onQuotedMessageCleared;

  static bool _defaultValidator(Message message) =>
      message.text?.isNotEmpty == true || message.attachments.isNotEmpty;

  @override
  StreamMessageInputState createState() => StreamMessageInputState();
}

/// State of [StreamMessageInput]
class StreamMessageInputState extends State<StreamMessageInput>
    with RestorationMixin<StreamMessageInput> {
  final _imagePicker = ImagePicker();
  late FocusNode _focusNode = widget.focusNode ?? FocusNode();
  late final _isInternalFocusNode = widget.focusNode == null;
  bool _inputEnabled = true;

  bool get _commandEnabled => _effectiveController.value.command != null;
  bool _showCommandsOverlay = false;
  bool _showMentionsOverlay = false;

  bool _actionsShrunk = false;
  bool _openFilePickerSection = false;

  late StreamChatThemeData _streamChatTheme;
  late StreamMessageInputThemeData _messageInputTheme;

  bool get _hasQuotedMessage =>
      _effectiveController.value.quotedMessage != null;

  bool get _isEditing =>
      _effectiveController.value.status != MessageSendingStatus.sending;

  bool get _autoCorrect => widget.autoCorrect ?? true;

  bool get _disableEmojiSuggestionsOverlay =>
      widget.disableEmojiSuggestionsOverlay ?? false;

  RestorableMessageInputController? _controller;

  MessageInputController get _effectiveController =>
      widget.messageInputController ?? _controller!.value;

  BoxBorder? _draggingBorder;

  void _createLocalController([Message? message]) {
    assert(_controller == null, '');
    _controller = RestorableMessageInputController(message: message);
  }

  void _registerController() {
    assert(_controller != null, '');

    registerForRestoration(
      _controller!,
      widget.restorationId ?? 'messageInputController',
    );
    _effectiveController.textEditingController
        .removeListener(_onChangedDebounced);
    _effectiveController.textEditingController.addListener(_onChangedDebounced);
    if (!_isEditing && _timeOut <= 0) _startSlowMode();
  }

  @override
  void initState() {
    super.initState();
    if (widget.messageInputController == null) {
      _createLocalController();
    } else {
      _initialiseEffectiveController();
    }
    _focusNode.addListener(_focusNodeListener);
  }

  @override
  void didChangeDependencies() {
    _streamChatTheme = StreamChatTheme.of(context);
    _messageInputTheme = StreamMessageInputTheme.of(context);

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant StreamMessageInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messageInputController == null &&
        oldWidget.messageInputController != null) {
      _createLocalController(oldWidget.messageInputController!.value);
    } else if (widget.messageInputController != null &&
        oldWidget.messageInputController == null) {
      unregisterFromRestoration(_controller!);
      _controller!.dispose();
      _controller = null;
      _initialiseEffectiveController();
    }

    // Update _focusNode
    if (widget.focusNode != null && oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_focusNodeListener);
      _focusNode = widget.focusNode!;
      _focusNode.addListener(_focusNodeListener);
    }
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    if (_controller != null) {
      _registerController();
    }
  }

  @override
  String? get restorationId => widget.restorationId;

  void _focusNodeListener() {
    if (_focusNode.hasFocus) {
      _openFilePickerSection = false;
    }
  }

  int _timeOut = 0;
  Timer? _slowModeTimer;

  void _initialiseEffectiveController() {
    _effectiveController.textEditingController
        .removeListener(_onChangedDebounced);
    _effectiveController.textEditingController.addListener(_onChangedDebounced);
    if (!_isEditing && _timeOut <= 0) _startSlowMode();
  }

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
    if (!StreamChannel.of(context)
        .channel
        .ownCapabilities
        .contains(PermissionType.sendMessage)) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 15,
          ),
          child: Text(
            context.translations.sendMessagePermissionError,
            style: _messageInputTheme.inputTextStyle,
          ),
        ),
      );
    }
    return MessageValueListenableBuilder(
      valueListenable: _effectiveController,
      builder: (context, value, _) {
        Widget child = DecoratedBox(
          decoration: BoxDecoration(
            color: _messageInputTheme.inputBackgroundColor,
            boxShadow: widget.shadow == null
                ? (_streamChatTheme.messageInputTheme.shadow == null
                    ? []
                    : [_streamChatTheme.messageInputTheme.shadow!])
                : [widget.shadow!],
          ),
          child: SimpleSafeArea(
            enabled: widget.enableSafeArea ??
                _streamChatTheme.messageInputTheme.enableSafeArea ??
                true,
            child: GestureDetector(
              onPanUpdate: (details) {
                if (details.delta.dy > 0) {
                  _focusNode.unfocus();
                  if (_openFilePickerSection) {
                    setState(() => _openFilePickerSection = false);
                  }
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_hasQuotedMessage)
                    // Ensure this doesn't show on web & desktop
                    PlatformWidgetBuilder(
                      mobile: (context, child) => child,
                      child: QuotingMessageTopArea(
                        hasQuotedMessage: _hasQuotedMessage,
                        onQuotedMessageCleared: widget.onQuotedMessageCleared,
                      ),
                    )
                  else if (_effectiveController.ogAttachment != null)
                    OGAttachmentPreview(
                      attachment: _effectiveController.ogAttachment!,
                      onDismissPreviewPressed: () {
                        _effectiveController.clearOGAttachment();
                        _focusNode.unfocus();
                      },
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: _buildTextField(context),
                  ),
                  if (_effectiveController.value.parentId != null &&
                      !widget.hideSendAsDm)
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 12,
                        left: 12,
                        bottom: 12,
                      ),
                      child: DmCheckbox(
                        foregroundDecoration: BoxDecoration(
                          border: _effectiveController.showInChannel
                              ? null
                              : Border.all(
                                  color: _streamChatTheme
                                      .colorTheme.textHighEmphasis
                                      .withOpacity(0.5),
                                  width: 2,
                                ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        color: _effectiveController.showInChannel
                            ? _streamChatTheme.colorTheme.accentPrimary
                            : _streamChatTheme.colorTheme.barsBg,
                        onTap: () {
                          _effectiveController.showInChannel =
                              !_effectiveController.showInChannel;
                        },
                        crossFadeState: _effectiveController.showInChannel
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      ),
                    ),
                  PlatformWidgetBuilder(
                    mobile: (context, child) => _buildFilePickerSection(),
                  ),
                ],
              ),
            ),
          ),
        );
        if (!_isEditing) {
          child = Material(
            elevation: widget.elevation ??
                _streamChatTheme.messageInputTheme.elevation ??
                8,
            child: child,
          );
        }
        return StreamMultiOverlay(
          childAnchor: Alignment.topCenter,
          overlayAnchor: Alignment.bottomCenter,
          overlayOptions: [
            OverlayOptions(
              visible: _showCommandsOverlay,
              widget: _buildCommandsOverlayEntry(),
            ),
            if (!_disableEmojiSuggestionsOverlay)
              OverlayOptions(
                visible: _focusNode.hasFocus &&
                    _effectiveController.text.isNotEmpty &&
                    _effectiveController.baseOffset > 0 &&
                    _effectiveController.text
                        .substring(
                          0,
                          _effectiveController.baseOffset,
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
      },
    );
  }

  Flex _buildTextField(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        if (!_commandEnabled && widget.actionsLocation == ActionsLocation.left)
          _buildExpandActionsButton(context),
        _buildTextInput(context),
        if (!_commandEnabled && widget.actionsLocation == ActionsLocation.right)
          _buildExpandActionsButton(context),
        if (widget.sendButtonLocation == SendButtonLocation.outside)
          _buildSendButton(context),
      ],
    );
  }

  Widget _buildSendButton(BuildContext context) {
    if (widget.sendButtonBuilder != null) {
      return widget.sendButtonBuilder!(context, _effectiveController);
    }

    return StreamMessageSendButton(
      onSendMessage: sendMessage,
      timeOut: _timeOut,
      isIdle: !widget.validator(_effectiveController.message),
      isEditEnabled: _isEditing,
      idleSendButton: widget.idleSendButton,
      activeSendButton: widget.activeSendButton,
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
                  if (!widget.disableAttachments &&
                      channel.ownCapabilities
                          .contains(PermissionType.uploadFile))
                    AttachmentButton(
                      color: _openFilePickerSection
                          ? _messageInputTheme.actionButtonColor!
                          : _messageInputTheme.actionButtonIdleColor!,
                      onPressed: _handleFileSelect,
                    ),
                  if (widget.showCommandsButton &&
                      !_isEditing &&
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

  /// Handle the platform-specific logic for selecting files.
  ///
  /// On mobile, this will open the file selection bottom sheet. On desktop,
  /// this will open the native file system and allow the user to select one
  /// or more files.
  Future<void> _handleFileSelect() async {
    if (isDesktopDeviceOrWeb) {
      final desktopAttachmentHandler = DesktopAttachmentHandler(
        maxAttachmentSize: widget.maxAttachmentSize,
      );
      desktopAttachmentHandler.upload().then((attachments) {
        // If attachments is empty, it means the user closed the file system
        // without selecting any files.
        if (attachments.isNotEmpty) {
          setState(() => _addAttachments(attachments));
        }
      }).catchError((error) {
        handleFileUploadError(context, error, widget.maxAttachmentSize);
      });
    } else {
      _showCommandsOverlay = false;
      _showMentionsOverlay = false;

      if (_openFilePickerSection) {
        setState(() => _openFilePickerSection = false);
      } else {
        showAttachmentModal();
      }
    }
  }

  Expanded _buildTextInput(BuildContext context) {
    final margin = (widget.sendButtonLocation == SendButtonLocation.inside
            ? const EdgeInsets.only(right: 8)
            : EdgeInsets.zero) +
        (widget.actionsLocation != ActionsLocation.left || _commandEnabled
            ? const EdgeInsets.only(left: 8)
            : EdgeInsets.zero);
    final _desktopAttachmentHandler = DesktopAttachmentHandler(
      maxAttachmentSize: widget.maxAttachmentSize,
    );

    return Expanded(
      child: DropTarget(
        onDragDone: (details) {
          _desktopAttachmentHandler
              .uploadViaDragNDrop(details.files)
              .then((attachments) {
            if (attachments.isNotEmpty) {
              setState(() => _addAttachments(attachments));
            }
          }).catchError((error) {
            handleFileUploadError(context, error, widget.maxAttachmentSize);
          });
        },
        onDragEntered: (details) {
          setState(() {
            _draggingBorder = Border.all(
              color: _streamChatTheme.colorTheme.accentPrimary,
            );
          });
        },
        onDragExited: (details) {
          setState(() => _draggingBorder = null);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          margin: margin,
          decoration: BoxDecoration(
            borderRadius: _messageInputTheme.borderRadius,
            gradient: _focusNode.hasFocus
                ? _messageInputTheme.activeBorderGradient
                : _messageInputTheme.idleBorderGradient,
            border: _draggingBorder,
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
                    child: KeyboardShortcutRunner(
                      onEnterKeypress: sendMessage,
                      onEscapeKeypress: () {
                        if (_hasQuotedMessage &&
                            _effectiveController.text.isEmpty) {
                          widget.onQuotedMessageCleared?.call();
                        }
                      },
                      child: StreamMessageTextField(
                        key: const Key('messageInputText'),
                        enabled: _inputEnabled,
                        maxLines: null,
                        onSubmitted: (_) => sendMessage(),
                        keyboardType: widget.keyboardType,
                        controller: _effectiveController,
                        focusNode: _focusNode,
                        style: _messageInputTheme.inputTextStyle,
                        autofocus: widget.autofocus,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: _getInputDecoration(context),
                        textCapitalization: TextCapitalization.sentences,
                        autocorrect: _autoCorrect,
                      ),
                    ),
                  ),
                ],
              ),
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
                          _effectiveController.value.command!.toUpperCase(),
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
                onPressed: _effectiveController.clear,
              ),
            ),
          if (!_commandEnabled &&
              widget.actionsLocation == ActionsLocation.rightInside)
            _buildExpandActionsButton(context),
          if (widget.sendButtonLocation == SendButtonLocation.inside)
            _buildSendButton(context),
        ],
      ),
    ).merge(passedDecoration);
  }

  late final _onChangedDebounced = debounce(
    () {
      var value = _effectiveController.text;
      if (!mounted) return;
      value = value.trim();

      final channel = StreamChannel.of(context).channel;
      if (channel.ownCapabilities.contains(PermissionType.sendTypingEvents) &&
          value.isNotEmpty) {
        channel
            .keyStroke(_effectiveController.value.parentId)
            // ignore: no-empty-block
            .catchError((e) {});
      }

      var actionsLength = widget.actions.length;
      if (widget.showCommandsButton) actionsLength += 1;
      if (!widget.disableAttachments) actionsLength += 1;

      setState(() => _actionsShrunk = value.isNotEmpty && actionsLength > 1);

      _checkContainsUrl(value, context);
      _checkCommands(value, context);
      _checkMentions(value, context);
      _checkEmoji(value, context);
    },
    const Duration(milliseconds: 350),
    leading: true,
  );

  String _getHint(BuildContext context) {
    if (_commandEnabled && _effectiveController.value.command == 'giphy') {
      return context.translations.searchGifLabel;
    }
    if (_effectiveController.attachments.isNotEmpty) {
      return context.translations.addACommentOrSendLabel;
    }
    if (_timeOut != 0) {
      return context.translations.slowModeOnLabel;
    }

    return context.translations.writeAMessageLabel;
  }

  String? _lastSearchedContainsUrlText;
  CancelableOperation? _enrichUrlOperation;
  final _urlRegex = RegExp(
    r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+',
  );

  void _checkContainsUrl(String value, BuildContext context) async {
    // Cancel the previous operation if it's still running
    _enrichUrlOperation?.cancel();

    // If the text is same as the last time, don't do anything
    if (_lastSearchedContainsUrlText == value) return;
    _lastSearchedContainsUrlText = value;

    final matchedUrls = _urlRegex.allMatches(value).toList()
      ..removeWhere((it) => it.group(0)?.split('.').last.isValidTLD() == false);

    // Reset the og attachment if the text doesn't contain any url
    if (matchedUrls.isEmpty ||
        !StreamChannel.of(context)
            .channel
            .ownCapabilities
            .contains(PermissionType.sendLinks)) {
      _effectiveController.clearOGAttachment();
      return;
    }

    final firstMatchedUrl = matchedUrls.first.group(0)!;

    // If the parsed url matches the ogAttachment url, don't do anything
    if (_effectiveController.ogAttachment?.titleLink == firstMatchedUrl) {
      return;
    }

    final client = StreamChat.of(context).client;

    _enrichUrlOperation = CancelableOperation.fromFuture(
      _enrichUrl(firstMatchedUrl, client),
    ).then(
      (ogAttachment) {
        final attachment = Attachment.fromOGAttachment(ogAttachment);
        _effectiveController.setOGAttachment(attachment);
      },
      onError: (error, stackTrace) {
        // Reset the ogAttachment if there was an error
        _effectiveController.clearOGAttachment();
        widget.onError?.call(error, stackTrace);
      },
    );
  }

  final _ogAttachmentCache = <String, OGAttachmentResponse>{};

  Future<OGAttachmentResponse> _enrichUrl(
    String url,
    StreamChatClient client,
  ) async {
    var response = _ogAttachmentCache[url];
    if (response == null) {
      final client = StreamChat.of(context).client;
      response = await client.enrichUrl(url);
      _ogAttachmentCache[url] = response;
    }
    return response;
  }

  void _checkEmoji(String value, BuildContext context) {
    if (value.isNotEmpty &&
        _effectiveController.baseOffset > 0 &&
        _effectiveController.text
            .substring(0, _effectiveController.baseOffset)
            .contains(':')) {
      final textToSelection = _effectiveController.text.substring(
        0,
        _effectiveController.selectionStart,
      );
      final splits = textToSelection.split(':');
      final query = splits[splits.length - 2].toLowerCase();
      final emoji = Emoji.byName(query);

      if (textToSelection.endsWith(':') && emoji != null) {
        _chooseEmoji(splits.sublist(0, splits.length - 1), emoji);
      }
    }
  }

  void _checkMentions(String value, BuildContext context) {
    if (value.isNotEmpty &&
        _effectiveController.baseOffset > 0 &&
        _effectiveController.text
            .substring(0, _effectiveController.baseOffset)
            .split(' ')
            .last
            .contains('@')) {
      if (!_showMentionsOverlay) {
        setState(() => _showMentionsOverlay = true);
      }
    } else if (_showMentionsOverlay) {
      setState(() => _showMentionsOverlay = false);
    }
  }

  void _checkCommands(String value, BuildContext context) {
    if (value.startsWith('/')) {
      final allCommands = StreamChannel.of(context).channel.config?.commands;
      final command =
          allCommands?.firstWhereOrNull((it) => it.name == value.substring(1));
      if (command != null) {
        return _setCommand(command);
      } else if (!_showCommandsOverlay) {
        setState(() => _showCommandsOverlay = true);
      }
    } else if (_showCommandsOverlay) {
      setState(() => _showCommandsOverlay = false);
    }
  }

  Widget _buildCommandsOverlayEntry() {
    final text = _effectiveController.text.trimLeft();

    final renderObject = context.findRenderObject() as RenderBox?;
    if (renderObject == null) {
      return const Offstage();
    }
    return StreamCommandsOverlay(
      channel: StreamChannel.of(context).channel,
      size: Size(renderObject.size.width - 16, 400),
      text: text,
      onCommandResult: _setCommand,
    );
  }

  Widget _buildFilePickerSection() {
    final picker = StreamAttachmentPicker(
      messageInputController: _effectiveController,
      onFilePicked: pickFile,
      isOpen: _openFilePickerSection,
      pickerSize: _openFilePickerSection ? _kMinMediaPickerSize : 0,
      attachmentLimit: widget.attachmentLimit,
      onAttachmentLimitExceeded: widget.onAttachmentLimitExceed,
      maxAttachmentSize: widget.maxAttachmentSize,
      onError: _showErrorAlert,
    );

    if (_openFilePickerSection && widget.attachmentsPickerBuilder != null) {
      return widget.attachmentsPickerBuilder!(
        context,
        _effectiveController,
        picker,
      );
    }

    return picker;
  }

  Widget _buildMentionsOverlayEntry() {
    final channel = StreamChannel.of(context).channel;
    if (_effectiveController.selectionStart < 0 || channel.state == null) {
      return const Offstage();
    }

    final splits = _effectiveController.text
        .substring(0, _effectiveController.selectionStart)
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
      builder: (context, snapshot) {
        return StreamUserMentionsOverlay(
          query: query,
          mentionAllAppUsers: widget.mentionAllAppUsers,
          client: StreamChat.of(context).client,
          channel: channel,
          size: Size(
            renderObject.size.width - 16,
            min(
              400,
              (snapshot.maxHeight - renderObject.size.height - 16).abs(),
            ),
          ),
          mentionsTileBuilder: tileBuilder,
          onMentionUserTap: (user) {
            _effectiveController.addMentionedUser(user);
            splits[splits.length - 1] = user.name;
            final rejoin = splits.join('@');

            _effectiveController.text =
                '$rejoin${_effectiveController.text.substring(
              _effectiveController.selectionStart,
            )}';

            _onChangedDebounced.cancel();
            setState(() => _showMentionsOverlay = false);
          },
        );
      },
    );
  }

  Widget _buildEmojiOverlay() {
    if (_effectiveController.baseOffset < 0) {
      return const Offstage();
    }

    final splits = _effectiveController.text
        .substring(0, _effectiveController.baseOffset)
        .split(':');

    final query = splits.last.toLowerCase();
    // ignore: cast_nullable_to_non_nullable
    final renderObject = context.findRenderObject() as RenderBox;

    return StreamEmojiOverlay(
      size: Size(renderObject.size.width - 16, 200),
      query: query,
      onEmojiResult: (emoji) => _chooseEmoji(splits, emoji),
    );
  }

  void _chooseEmoji(List<String> splits, Emoji emoji) {
    final rejoin = splits.sublist(0, splits.length - 1).join(':') + emoji.char!;

    _effectiveController.text = rejoin +
        _effectiveController.text.substring(
          _effectiveController.selectionStart,
        );
  }

  void _setCommand(Command c) {
    _effectiveController
      ..clear()
      ..command = c;
    setState(() => _showCommandsOverlay = false);
  }

  Widget _buildReplyToMessage() {
    if (!_hasQuotedMessage) return const Offstage();
    final containsUrl = _effectiveController.value.quotedMessage!.attachments
        .any((element) => element.titleLink != null);
    return StreamQuotedMessageWidget(
      reverse: true,
      showBorder: !containsUrl,
      message: _effectiveController.value.quotedMessage!,
      messageTheme: _streamChatTheme.otherMessageTheme,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      onQuotedMessageClear: widget.onQuotedMessageCleared,
    );
  }

  Widget _buildAttachments() {
    final nonOGAttachments = _effectiveController.attachments.where(
      (it) => it.titleLink == null,
    );
    if (nonOGAttachments.isEmpty) return const Offstage();
    final fileAttachments = nonOGAttachments
        .where((it) => it.type == 'file')
        .toList(growable: false);
    final remainingAttachments = nonOGAttachments
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
                        child: StreamFileAttachment(
                          message: Message(), // dummy message
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

  Widget _buildRemoveButton(Attachment attachment) {
    return SizedBox(
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
          _effectiveController.removeAttachmentById(attachment.id);
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
  }

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
            StreamVideoThumbnailImage(
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
    final s = _effectiveController.text.trim();
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

        setState(() => _showCommandsOverlay = !_showCommandsOverlay);
      },
    );

    return widget.commandButtonBuilder?.call(context, defaultButton) ??
        defaultButton;
  }

  /// Show the attachment modal, making the user choose where to
  /// pick a media from
  void showAttachmentModal() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }

    if (!kIsWeb) {
      setState(() => _openFilePickerSection = true);
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
        builder: (_) => AttachmentModalSheet(
          onFileTap: () => pickFile(DefaultAttachmentTypes.file),
          onPhotoTap: () => pickFile(DefaultAttachmentTypes.image),
          onVideoTap: () => pickFile(DefaultAttachmentTypes.video),
        ),
      );
    }
  }

  /// Adds an attachment to the [messageInputController.attachments] map
  void _addAttachments(Iterable<Attachment> attachments) {
    final limit = widget.attachmentLimit;
    final length = _effectiveController.attachments.length + attachments.length;
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
      _effectiveController.addAttachment(attachment);
    }
  }

  /// Pick a file from the device
  /// If [camera] is true then the camera will open
  void pickFile(
    DefaultAttachmentTypes fileType, {
    bool camera = false,
  }) async {
    setState(() => _inputEnabled = false);
    final attachmentHandler = MobileAttachmentHandler(
      maxAttachmentSize: widget.maxAttachmentSize,
      imagePicker: _imagePicker,
    );

    attachmentHandler
        .upload(fileType: fileType, camera: camera)
        .then((attachments) {
      setState(() => _inputEnabled = true);

      if (attachments.isNotEmpty) {
        setState(() => _addAttachments(attachments));
      }
    }).catchError((error) {
      if (error.runtimeType == FileSystemException) {
        switch (error.message) {
          case 'File size too large after compression and exceeds maximum '
              'attachment size':
            _showErrorAlert(
              context.translations.fileTooLargeAfterCompressionError(
                widget.maxAttachmentSize / (1024 * 1024),
              ),
            );
            break;
          case 'File size exceeds maximum attachment size':
            _showErrorAlert(
              context.translations.fileTooLargeError(
                widget.maxAttachmentSize / (1024 * 1024),
              ),
            );
            break;
          default:
            _showErrorAlert(context.translations.somethingWentWrongError);
            break;
        }
      }
    });
  }

  /// Sends the current message
  Future<void> sendMessage() async {
    final streamChannel = StreamChannel.of(context);
    var message = _effectiveController.value;
    if (!streamChannel.channel.ownCapabilities
            .contains(PermissionType.sendLinks) &&
        _urlRegex.allMatches(message.text ?? '').any((element) =>
            element.group(0)?.split('.').last.isValidTLD() == true)) {
      showInfoBottomSheet(
        context,
        icon: StreamSvgIcon.error(
          color: StreamChatTheme.of(context).colorTheme.accentError,
          size: 24,
        ),
        title: 'Links are disabled',
        details: 'Sending links is not allowed in this conversation.',
        okText: context.translations.okLabel,
      );
      return;
    }

    final skipEnrichUrl = _effectiveController.ogAttachment == null;

    var shouldKeepFocus = widget.shouldKeepFocusAfterMessage;

    shouldKeepFocus ??= !_commandEnabled;
    widget.onQuotedMessageCleared?.call();

    _effectiveController.reset();

    if (widget.preMessageSending != null) {
      message = await widget.preMessageSending!(message);
    }

    final channel = streamChannel.channel;
    if (!channel.state!.isUpToDate) {
      await streamChannel.reloadChannel();
    }

    message = message.replaceMentionsWithId();

    try {
      Future sendingFuture;
      if (_isEditing) {
        sendingFuture = channel.updateMessage(
          message,
          skipEnrichUrl: skipEnrichUrl,
        );
      } else {
        sendingFuture = channel.sendMessage(
          message,
          skipEnrichUrl: skipEnrichUrl,
        );
      }

      if (shouldKeepFocus) {
        FocusScope.of(context).requestFocus(_focusNode);
      } else {
        FocusScope.of(context).unfocus();
      }

      final resp = await sendingFuture;
      if (resp.message?.type == 'error') {
        _effectiveController.value = message;
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
      builder: (context) => ErrorAlertSheet(
        errorDescription: context.translations.somethingWentWrongError,
      ),
    );
  }

  @override
  void dispose() {
    _effectiveController.textEditingController
        .removeListener(_onChangedDebounced);
    _controller?.dispose();
    _focusNode.removeListener(_focusNodeListener);
    if (_isInternalFocusNode) _focusNode.dispose();
    _stopSlowMode();
    _onChangedDebounced.cancel();
    super.dispose();
  }
}

/// Preview of an Open Graph attachment.
class OGAttachmentPreview extends StatelessWidget {
  /// Returns a new instance of [OGAttachmentPreview]
  const OGAttachmentPreview({
    Key? key,
    required this.attachment,
    this.onDismissPreviewPressed,
  }) : super(key: key);

  /// The attachment to be rendered.
  final Attachment attachment;

  /// Called when the dismiss button is pressed.
  final VoidCallback? onDismissPreviewPressed;

  @override
  Widget build(BuildContext context) {
    final chatTheme = StreamChatTheme.of(context);
    final textTheme = chatTheme.textTheme;
    final colorTheme = chatTheme.colorTheme;

    final attachmentTitle = attachment.title;
    final attachmentText = attachment.text;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            Icons.link,
            color: colorTheme.accentPrimary,
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: colorTheme.accentPrimary,
                  width: 2,
                ),
              ),
            ),
            padding: const EdgeInsets.only(left: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (attachmentTitle != null)
                  Text(
                    attachmentTitle.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.body.copyWith(fontWeight: FontWeight.w700),
                  ),
                if (attachmentText != null)
                  Text(
                    attachmentText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.body.copyWith(fontWeight: FontWeight.w400),
                  ),
              ],
            ),
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: StreamSvgIcon.closeSmall(),
          onPressed: onDismissPreviewPressed,
        ),
      ],
    );
  }
}
