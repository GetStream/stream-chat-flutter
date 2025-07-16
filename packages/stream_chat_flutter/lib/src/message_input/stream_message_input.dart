import 'dart:async';
import 'dart:math';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/platform_widget_builder/src/platform_widget_builder.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_button.dart';
import 'package:stream_chat_flutter/src/message_input/command_button.dart';
import 'package:stream_chat_flutter/src/message_input/dm_checkbox_list_tile.dart';
import 'package:stream_chat_flutter/src/message_input/quoting_message_top_area.dart';
import 'package:stream_chat_flutter/src/message_input/stream_message_input_icon_button.dart';
import 'package:stream_chat_flutter/src/message_input/tld.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/misc/gradient_box_border.dart';
import 'package:stream_chat_flutter/src/misc/simple_safe_area.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

const _kCommandTrigger = '/';
const _kMentionTrigger = '@';

/// Signature for the function that determines if a [matchedUri] should be
/// previewed as an OG Attachment.
typedef OgPreviewFilter = bool Function(
  Uri matchedUri,
  String messageText,
);

/// Different types of hints that can be shown in [StreamMessageInput].
enum HintType {
  /// Hint for [StreamMessageInput] when the command is enabled and the command
  /// is 'giphy'.
  searchGif,

  /// Hint for [StreamMessageInput] when there are attachments.
  addACommentOrSend,

  /// Hint for [StreamMessageInput] when slow mode is enabled.
  slowModeOn,

  /// Hint for [StreamMessageInput] when other conditions are not met.
  writeAMessage,
}

/// Function that returns the hint text for [StreamMessageInput] based on
/// [type].
typedef HintGetter = String? Function(BuildContext context, HintType type);

/// The signature for the function that builds the list of actions.
typedef ActionsBuilder = List<Widget> Function(
  BuildContext context,
  List<Widget> defaultActions,
);

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
    super.key,
    this.onMessageSent,
    this.preMessageSending,
    this.maxHeight = 150,
    this.maxLines,
    this.minLines,
    this.textInputAction,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.disableAttachments = false,
    this.messageInputController,
    this.actionsBuilder,
    this.spaceBetweenActions = 0,
    this.actionsLocation = ActionsLocation.left,
    this.attachmentListBuilder,
    this.fileAttachmentListBuilder,
    this.mediaAttachmentListBuilder,
    this.voiceRecordingAttachmentListBuilder,
    this.fileAttachmentBuilder,
    this.mediaAttachmentBuilder,
    this.voiceRecordingAttachmentBuilder,
    this.focusNode,
    this.sendButtonLocation = SendButtonLocation.outside,
    this.autofocus = false,
    this.hideSendAsDm = false,
    this.enableVoiceRecording = false,
    this.sendVoiceRecordingAutomatically = false,
    this.idleSendIcon,
    this.activeSendIcon,
    this.showCommandsButton = true,
    this.userMentionsTileBuilder,
    this.maxAttachmentSize = kDefaultMaxAttachmentSize,
    this.onError,
    this.attachmentLimit = 10,
    this.allowedAttachmentPickerTypes = AttachmentPickerType.values,
    this.onAttachmentLimitExceed,
    this.attachmentButtonBuilder,
    this.commandButtonBuilder,
    this.customAutocompleteTriggers = const [],
    this.mentionAllAppUsers = false,
    this.sendButtonBuilder,
    this.quotedMessageBuilder,
    this.quotedMessageAttachmentThumbnailBuilders,
    this.shouldKeepFocusAfterMessage,
    this.validator = _defaultValidator,
    this.restorationId,
    this.enableSafeArea,
    this.elevation,
    this.shadow,
    this.autoCorrect = true,
    this.enableMentionsOverlay = true,
    this.onQuotedMessageCleared,
    this.enableActionAnimation = true,
    this.sendMessageKeyPredicate = _defaultSendMessageKeyPredicate,
    this.clearQuotedMessageKeyPredicate =
        _defaultClearQuotedMessageKeyPredicate,
    this.ogPreviewFilter = _defaultOgPreviewFilter,
    this.hintGetter = _defaultHintGetter,
    this.contentInsertionConfiguration,
    this.useSystemAttachmentPicker = false,
    this.pollConfig,
    this.customAttachmentPickerOptions = const [],
    this.onCustomAttachmentPickerResult,
  });

  /// The predicate used to send a message on desktop/web
  final KeyEventPredicate sendMessageKeyPredicate;

  /// The predicate used to clear the quoted message on desktop/web
  final KeyEventPredicate clearQuotedMessageKeyPredicate;

  /// If true the message input will animate the actions while you type
  final bool enableActionAnimation;

  /// List of triggers for showing autocomplete.
  final Iterable<StreamAutocompleteTrigger> customAutocompleteTriggers;

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

  /// The maximum lines of text the input can span.
  final int? maxLines;

  /// The minimum lines of text the input can span.
  final int? minLines;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// The keyboard type assigned to the TextField.
  final TextInputType? keyboardType;

  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization textCapitalization;

  /// If true the attachments button will not be displayed.
  final bool disableAttachments;

  /// Use this property to hide/show the commands button.
  final bool showCommandsButton;

  /// Hide send as dm checkbox.
  final bool hideSendAsDm;

  /// If true the voice recording button will be displayed.
  ///
  /// Defaults to true.
  final bool enableVoiceRecording;

  /// If True, the voice recording will be sent automatically after the user
  /// releases the microphone button.
  ///
  /// Defaults to false.
  final bool sendVoiceRecordingAutomatically;

  /// The text controller of the TextField.
  final StreamMessageInputController? messageInputController;

  /// List of action widgets.
  final ActionsBuilder? actionsBuilder;

  /// Space between the actions.
  final double spaceBetweenActions;

  /// The location of the custom actions.
  final ActionsLocation actionsLocation;

  /// Builder used to build the attachment list present in the message input.
  ///
  /// In case you want to customize only sub-parts of the attachment list,
  /// consider using [fileAttachmentListBuilder], [mediaAttachmentListBuilder].
  final AttachmentListBuilder? attachmentListBuilder;

  /// Builder used to build the file type attachment list.
  ///
  /// In case you want to customize the attachment item, consider using
  /// [fileAttachmentBuilder].
  final AttachmentListBuilder? fileAttachmentListBuilder;

  /// Builder used to build the media type attachment list.
  ///
  /// In case you want to customize the attachment item, consider using
  /// [mediaAttachmentBuilder].
  final AttachmentListBuilder? mediaAttachmentListBuilder;

  /// Builder used to build the voice recording attachment list.
  ///
  /// In case you want to customize the attachment item, consider using
  /// [voiceRecordingAttachmentBuilder].
  final AttachmentListBuilder? voiceRecordingAttachmentListBuilder;

  /// Builder used to build the file attachment item.
  final AttachmentItemBuilder? fileAttachmentBuilder;

  /// Builder used to build the media attachment item.
  final AttachmentItemBuilder? mediaAttachmentBuilder;

  /// Builder used to build the voice recording attachment item.
  final AttachmentItemBuilder? voiceRecordingAttachmentBuilder;

  /// Map that defines a thumbnail builder for an attachment type.
  ///
  /// This is used to build the thumbnail for the attachment in the quoted
  /// message.
  final Map<String, QuotedMessageAttachmentThumbnailBuilder>?
      quotedMessageAttachmentThumbnailBuilders;

  /// The focus node associated to the TextField.
  final FocusNode? focusNode;

  /// The location of the send button
  final SendButtonLocation sendButtonLocation;

  /// Autofocus property passed to the TextField
  final bool autofocus;

  /// Send button widget in an idle state
  final Widget? idleSendIcon;

  /// Send button widget in an active state
  final Widget? activeSendIcon;

  /// Customize the tile for the mentions overlay.
  final UserMentionTileBuilder? userMentionsTileBuilder;

  /// A callback for error reporting
  final ErrorListener? onError;

  /// A limit for the no. of attachments that can be sent with a single message.
  final int attachmentLimit;

  /// The list of allowed attachment types which can be picked using the
  /// attachment button.
  ///
  /// By default, all the attachment types are allowed.
  final List<AttachmentPickerType> allowedAttachmentPickerTypes;

  /// A callback for when the [attachmentLimit] is exceeded.
  ///
  /// This will override the default error alert behaviour.
  final AttachmentLimitExceedListener? onAttachmentLimitExceed;

  /// Builder for customizing the attachment button.
  ///
  /// The builder contains the default [AttachmentButton] that can be customized
  /// by calling `.copyWith`.
  final AttachmentButtonBuilder? attachmentButtonBuilder;

  /// Builder for customizing the command button.
  ///
  /// The builder contains the default [CommandButton] that can be customized by
  /// calling `.copyWith`.
  final CommandButtonBuilder? commandButtonBuilder;

  /// When enabled mentions search users across the entire app.
  ///
  /// Defaults to false.
  final bool mentionAllAppUsers;

  /// Builder for creating send button
  final MessageRelatedBuilder? sendButtonBuilder;

  /// Builder for building quoted message
  final Widget Function(BuildContext, Message)? quotedMessageBuilder;

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
  final bool autoCorrect;

  /// Disable the mentions overlay by passing false
  /// Enabled by default
  final bool enableMentionsOverlay;

  /// Callback for when the quoted message is cleared
  final VoidCallback? onQuotedMessageCleared;

  /// The filter used to determine if a link should be shown as an OpenGraph
  /// preview.
  final OgPreviewFilter ogPreviewFilter;

  /// Returns the hint text for the message input.
  final HintGetter hintGetter;

  /// {@macro flutter.widgets.editableText.contentInsertionConfiguration}
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  /// If True, allows you to use the system’s default media picker instead of
  /// the custom media picker provided by the library. This can be beneficial
  /// for several reasons:
  ///
  /// 1. Consistency: Provides a consistent user experience by using the
  /// familiar system media picker.
  /// 2. Permissions: Reduces the need for additional permissions, as the system
  /// media picker handles permissions internally.
  /// 3. Simplicity: Simplifies the implementation by leveraging the built-in
  /// functionality of the system media picker.
  final bool useSystemAttachmentPicker;

  /// The configuration to use while creating a poll.
  ///
  /// If not provided, the default configuration is used.
  final PollConfig? pollConfig;

  /// A list of custom attachment picker options that can be used to extend the
  /// attachment picker functionality.
  final List<AttachmentPickerOption> customAttachmentPickerOptions;

  /// Callback that is called when the custom attachment picker result is
  /// received.
  ///
  /// This is used to handle the result of the custom attachment picker
  final OnCustomAttachmentPickerResult? onCustomAttachmentPickerResult;

  static String? _defaultHintGetter(
    BuildContext context,
    HintType type,
  ) {
    switch (type) {
      case HintType.searchGif:
        return context.translations.searchGifLabel;
      case HintType.addACommentOrSend:
        return context.translations.addACommentOrSendLabel;
      case HintType.slowModeOn:
        return context.translations.slowModeOnLabel;
      case HintType.writeAMessage:
        return context.translations.writeAMessageLabel;
    }
  }

  static bool _defaultOgPreviewFilter(
    Uri matchedUri,
    String messageText,
  ) {
    // Show the preview for all links
    return true;
  }

  static bool _defaultValidator(Message message) {
    // The message is valid if it has text or attachments.
    if (message.attachments.isNotEmpty) return true;
    if (message.text?.trim() case final text? when text.isNotEmpty) return true;

    return false;
  }

  static bool _defaultSendMessageKeyPredicate(
    FocusNode node,
    KeyEvent event,
  ) {
    // Do not handle the event if the user is using a mobile device.
    if (CurrentPlatform.isAndroid || CurrentPlatform.isIos) return false;

    // Do not send the message if the shift key is pressed. Generally, this
    // means the user is trying to add a new line.
    if (HardwareKeyboard.instance.isShiftPressed) return false;

    // Otherwise, send the message when the user presses the enter key.
    final isEnterKeyPressed = event.logicalKey == LogicalKeyboardKey.enter;
    return isEnterKeyPressed && event is KeyDownEvent;
  }

  static bool _defaultClearQuotedMessageKeyPredicate(
    FocusNode node,
    KeyEvent event,
  ) {
    // Do not handle the event if the user is using a mobile device.
    if (CurrentPlatform.isAndroid || CurrentPlatform.isIos) return false;

    // Otherwise, Clear the quoted message when the user presses the escape key.
    final isEscapeKeyPressed = event.logicalKey == LogicalKeyboardKey.escape;
    return isEscapeKeyPressed && event is KeyDownEvent;
  }

  @override
  StreamMessageInputState createState() => StreamMessageInputState();
}

/// State of [StreamMessageInput]
class StreamMessageInputState extends State<StreamMessageInput>
    with RestorationMixin<StreamMessageInput> {
  bool get _commandEnabled => _effectiveController.message.command != null;

  bool _actionsShrunk = false;

  late StreamChatThemeData _streamChatTheme;
  late StreamMessageInputThemeData _messageInputTheme;

  bool get _hasQuotedMessage =>
      _effectiveController.message.quotedMessage != null;

  bool get _isEditing => !_effectiveController.message.state.isInitial;

  late final _audioRecorderController = StreamAudioRecorderController();

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());
  FocusNode? _focusNode;

  StreamMessageInputController get _effectiveController =>
      widget.messageInputController ?? _controller!.value;
  StreamRestorableMessageInputController? _controller;

  void _createLocalController([Message? message]) {
    assert(_controller == null, '');
    _controller = StreamRestorableMessageInputController(message: message);
  }

  void _registerController() {
    assert(_controller != null, '');

    registerForRestoration(_controller!, 'messageInputController');
    _initialiseEffectiveController();
  }

  void _initialiseEffectiveController() {
    _effectiveController
      ..removeListener(_onChangedDebounced)
      ..addListener(_onChangedDebounced);
  }

  StreamSubscription<Draft?>? _draftStreamSubscription;

  @override
  void initState() {
    super.initState();
    if (widget.messageInputController == null) {
      _createLocalController();
    } else {
      _initialiseEffectiveController();
    }
    _effectiveFocusNode.addListener(_focusNodeListener);

    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) return _initializeState();
    });
  }

  void _initializeState() {
    // Call the listener once to make sure the initial state is reflected
    // correctly in the UI.
    _onChangedDebounced.call();

    final channel = StreamChannel.of(context).channel;
    final config = StreamChatConfiguration.of(context);

    // Resumes the cooldown if the channel has currently an active cooldown.
    if (!_isEditing) {
      _effectiveController.startCooldown(channel.getRemainingCooldown());
    }

    // Starts listening to the draft stream for the current channel/thread.
    if (!_isEditing && config.draftMessagesEnabled) {
      final draftStream = switch (_effectiveController.message.parentId) {
        final parentId? => channel.state?.threadDraftStream(parentId),
        _ => channel.state?.draftStream,
      };

      _draftStreamSubscription = draftStream?.distinct().listen(_onDraftUpdate);
    }
  }

  void _onDraftUpdate(Draft? draft) {
    // If the draft is removed, reset the controller.
    if (draft == null) return _effectiveController.reset();

    // Otherwise, update the controller with the draft message.
    if (draft.message case final draftMessage) {
      _effectiveController.message = draftMessage.toMessage();
    }
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
      _createLocalController(oldWidget.messageInputController!.message);
    } else if (widget.messageInputController != null &&
        oldWidget.messageInputController == null) {
      unregisterFromRestoration(_controller!);
      _controller!.dispose();
      _controller = null;
      _initialiseEffectiveController();
    }

    // Update _focusNode
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _focusNode)?.removeListener(_focusNodeListener);
      (widget.focusNode ?? _focusNode)?.addListener(_focusNodeListener);
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

  // ignore: no-empty-block
  void _focusNodeListener() {}

  @override
  Widget build(BuildContext context) {
    bool canSendOrUpdateMessage(List<ChannelCapability> capabilities) {
      var result = capabilities.contains(ChannelCapability.sendMessage);
      if (_isEditing) {
        result |= capabilities.contains(ChannelCapability.updateOwnMessage);
        result |= capabilities.contains(ChannelCapability.updateAnyMessage);
      }

      return result;
    }

    final channel = StreamChannel.of(context).channel;
    final messageInput = switch (_buildAutocompleteMessageInput(context)) {
      final messageInput when channel.state != null => BetterStreamBuilder(
          stream: channel.ownCapabilitiesStream.map(canSendOrUpdateMessage),
          initialData: canSendOrUpdateMessage(channel.ownCapabilities),
          builder: (context, enabled) {
            // Allow the user to send messages if the user has the permission to
            // send messages or if the user is editing a message.
            if (enabled) return messageInput;

            // Otherwise, show the no permission message.
            return _buildNoPermissionMessage(context);
          },
        ),
      final messageInput => messageInput,
    };

    final shadow = widget.shadow ?? _messageInputTheme.shadow;
    final elevation = widget.elevation ?? _messageInputTheme.elevation;
    return Material(
      elevation: elevation ?? 8,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _messageInputTheme.inputBackgroundColor,
          boxShadow: [if (shadow != null) shadow],
        ),
        child: SimpleSafeArea(
          enabled: widget.enableSafeArea ?? _messageInputTheme.enableSafeArea,
          child: Center(child: messageInput),
        ),
      ),
    );
  }

  Widget _buildAutocompleteMessageInput(BuildContext context) {
    return StreamAutocomplete(
      focusNode: _effectiveFocusNode,
      messageEditingController: _effectiveController,
      fieldViewBuilder: _buildMessageInput,
      autocompleteTriggers: [
        ...widget.customAutocompleteTriggers,
        StreamAutocompleteTrigger(
          trigger: _kCommandTrigger,
          triggerOnlyAtStart: true,
          optionsViewBuilder: (
            context,
            autocompleteQuery,
            messageEditingController,
          ) {
            final query = autocompleteQuery.query;
            return StreamCommandAutocompleteOptions(
              query: query,
              channel: StreamChannel.of(context).channel,
              onCommandSelected: (command) {
                _effectiveController.command = command.name;
                // removing the overlay after the command is selected
                StreamAutocomplete.of(context).closeSuggestions();
              },
            );
          },
        ),
        if (widget.enableMentionsOverlay)
          StreamAutocompleteTrigger(
            trigger: _kMentionTrigger,
            optionsViewBuilder: (
              context,
              autocompleteQuery,
              messageEditingController,
            ) {
              final query = autocompleteQuery.query;
              return StreamMentionAutocompleteOptions(
                query: query,
                channel: StreamChannel.of(context).channel,
                mentionAllAppUsers: widget.mentionAllAppUsers,
                mentionsTileBuilder: widget.userMentionsTileBuilder,
                onMentionUserTap: (user) {
                  // adding the mentioned user to the controller.
                  _effectiveController.addMentionedUser(user);

                  // accepting the autocomplete option.
                  StreamAutocomplete.of(context)
                      .acceptAutocompleteOption(user.name);
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildMessageInput(
    BuildContext context,
    StreamMessageEditingController controller,
    FocusNode focusNode,
  ) {
    return StreamMessageValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) => Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget?>[
            _buildTopMessageArea(context),
            _buildTextField(context),
            _buildDmCheckbox(context),
          ].nonNulls.toList(),
        ),
      ),
    );
  }

  Widget? _buildTopMessageArea(BuildContext context) {
    if (_hasQuotedMessage && !_isEditing) {
      // Ensure this doesn't show on web & desktop
      return PlatformWidgetBuilder(
        mobile: (context, child) => child,
        child: QuotingMessageTopArea(
          hasQuotedMessage: _hasQuotedMessage,
          onQuotedMessageCleared: widget.onQuotedMessageCleared,
        ),
      );
    }

    if (_effectiveController.ogAttachment != null) {
      return OGAttachmentPreview(
        attachment: _effectiveController.ogAttachment!,
        onDismissPreviewPressed: () {
          _effectiveController.clearOGAttachment();
          _effectiveFocusNode.unfocus();
        },
      );
    }

    return null;
  }

  Widget? _buildDmCheckbox(BuildContext context) {
    if (widget.hideSendAsDm) return null;

    final insideThread = _effectiveController.message.parentId != null;
    if (!insideThread) return null;

    return DmCheckboxListTile(
      value: _effectiveController.showInChannel,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      onChanged: (value) => _effectiveController.showInChannel = value,
    );
  }

  Widget _buildNoPermissionMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Text(
        context.translations.sendMessagePermissionError,
        style: _messageInputTheme.inputTextStyle,
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _audioRecorderController,
      builder: (context, state, _) {
        final isAudioRecordingFlowActive = state is! RecordStateIdle;

        return Row(
          children: [
            if (!isAudioRecordingFlowActive) ...[
              if (!_commandEnabled &&
                  widget.actionsLocation == ActionsLocation.left)
                _buildExpandActionsButton(context),
              const SizedBox(width: 4),
              Expanded(child: _buildTextInput(context)),
              const SizedBox(width: 4),
              if (!_commandEnabled &&
                  widget.actionsLocation == ActionsLocation.right)
                _buildExpandActionsButton(context),
              if (widget.sendButtonLocation == SendButtonLocation.outside)
                _buildSendButton(context),
            ],
            if (widget.enableVoiceRecording)
              Expanded(
                // This is to make sure the audio recorder button will be given
                // the full width when it's visible.
                flex: isAudioRecordingFlowActive ? 1 : 0,
                child: StreamAudioRecorderButton(
                  recordState: state,
                  onRecordStart: _audioRecorderController.startRecord,
                  onRecordCancel: _audioRecorderController.cancelRecord,
                  onRecordStop: _audioRecorderController.stopRecord,
                  onRecordLock: _audioRecorderController.lockRecord,
                  onRecordDragUpdate: _audioRecorderController.dragRecord,
                  onRecordStartCancel: () {
                    // Show a message to the user to hold to record.
                    _audioRecorderController.showInfo(
                      context.translations.holdToRecordLabel,
                    );
                  },
                  onRecordFinish: () async {
                    //isVoiceRecordingConfirmationRequiredEnabled
                    // Finish the recording session and add the audio to the
                    // message input controller.
                    final audio = await _audioRecorderController.finishRecord();
                    if (audio != null) {
                      _effectiveController.addAttachment(audio);
                    }

                    // Once the recording is finished, cancel the recorder.
                    _audioRecorderController.cancelRecord(discardTrack: false);

                    // Send the message if the user has enabled the option to
                    // send the voice recording automatically.
                    if (widget.sendVoiceRecordingAutomatically) {
                      return sendMessage();
                    }
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSendButton(BuildContext context) {
    if (widget.sendButtonBuilder case final builder?) {
      return builder(context, _effectiveController);
    }

    return StreamMessageSendButton(
      onSendMessage: sendMessage,
      timeOut: _effectiveController.cooldownTimeOut,
      isIdle: !widget.validator(_effectiveController.message),
      idleSendIcon: widget.idleSendIcon,
      activeSendIcon: widget.activeSendIcon,
    );
  }

  Widget _buildExpandActionsButton(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 200),
      crossFadeState: switch (widget.enableActionAnimation && _actionsShrunk) {
        true => CrossFadeState.showFirst,
        false => CrossFadeState.showSecond,
      },
      layoutBuilder: (top, topKey, bottom, bottomKey) => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(key: bottomKey, top: 0, child: bottom),
          Positioned(key: topKey, child: top),
        ],
      ),
      firstChild: StreamMessageInputIconButton(
        color: _messageInputTheme.expandButtonColor,
        icon: Transform.rotate(
          angle: (widget.actionsLocation == ActionsLocation.right ||
                  widget.actionsLocation == ActionsLocation.rightInside)
              ? pi
              : 0,
          child: const StreamSvgIcon(icon: StreamSvgIcons.emptyCircleRight),
        ),
        onPressed: () {
          if (_actionsShrunk) {
            setState(() => _actionsShrunk = false);
          }
        },
      ),
      secondChild: widget.disableAttachments &&
              !widget.showCommandsButton &&
              !(widget.actionsBuilder != null)
          ? const Empty()
          : Row(
              spacing: widget.spaceBetweenActions,
              mainAxisSize: MainAxisSize.min,
              children: _actionsList(),
            ),
    );
  }

  List<Widget> _actionsList() {
    final channel = StreamChannel.of(context).channel;
    final defaultActions = <Widget>[
      if (!widget.disableAttachments && channel.canUploadFile)
        _buildAttachmentButton(context),
      if (widget.showCommandsButton &&
          !_isEditing &&
          channel.state != null &&
          channel.config?.commands.isNotEmpty == true)
        _buildCommandButton(context),
    ];

    if (widget.actionsBuilder case final builder?) {
      return builder(context, defaultActions);
    }

    return defaultActions;
  }

  Widget _buildAttachmentButton(BuildContext context) {
    final defaultButton = AttachmentButton(
      color: _messageInputTheme.actionButtonIdleColor,
      onPressed: _onAttachmentButtonPressed,
    );

    return widget.attachmentButtonBuilder?.call(context, defaultButton) ??
        defaultButton;
  }

  Future<void> _onPollCreated(Poll poll) async {
    final channel = StreamChannel.of(context).channel;
    return channel.sendPoll(poll).ignore();
  }

  // Returns the list of allowed attachment picker types based on the
  // current channel configuration and context.
  List<AttachmentPickerType> _getAllowedAttachmentPickerTypes() {
    final allowedTypes = widget.allowedAttachmentPickerTypes.where((type) {
      if (type != AttachmentPickerType.poll) return true;

      // We don't allow editing polls.
      if (_isEditing) return false;
      // We don't allow creating polls in threads.
      if (_effectiveController.message.parentId != null) return false;

      // Otherwise, check if the user has the permission to send polls.
      final channel = StreamChannel.of(context).channel;
      return channel.config?.polls == true && channel.canSendPoll;
    });

    return allowedTypes.toList(growable: false);
  }

  /// Handle the platform-specific logic for selecting files.
  ///
  /// On mobile, this will open the file selection bottom sheet. On desktop,
  /// this will open the native file system and allow the user to select one
  /// or more files.
  Future<void> _onAttachmentButtonPressed() async {
    final initialPoll = _effectiveController.poll;
    final initialAttachments = _effectiveController.attachments;
    final allowedTypes = _getAllowedAttachmentPickerTypes();

    final messageInputTheme = StreamMessageInputTheme.of(context);
    final useSystemPicker = widget.useSystemAttachmentPicker ||
        (messageInputTheme.useSystemAttachmentPicker ?? false);

    final result = await showStreamAttachmentPickerModalBottomSheet(
      context: context,
      allowedTypes: allowedTypes,
      initialPoll: initialPoll,
      pollConfig: widget.pollConfig,
      initialAttachments: initialAttachments,
      useSystemAttachmentPicker: useSystemPicker,
      customOptions: widget.customAttachmentPickerOptions,
    );

    if (result == null || result is! StreamAttachmentPickerResult) return;

    void _onAttachmentsPicked(List<Attachment> attachments) {
      _effectiveController.attachments = attachments;
    }

    void _onAttachmentPickerError(AttachmentPickerError error) {
      return widget.onError?.call(error.error, error.stackTrace);
    }

    void _onCustomAttachmentPickerResult(CustomAttachmentPickerResult result) {
      return widget.onCustomAttachmentPickerResult?.call(result);
    }

    return switch (result) {
      // Add the attachments to the controller.
      AttachmentsPicked() => _onAttachmentsPicked(result.attachments),
      // Send the created poll in the channel.
      PollCreated() => _onPollCreated(result.poll),
      // Handle custom attachment picker results.
      CustomAttachmentPickerResult() => _onCustomAttachmentPickerResult(result),
      // Handle/Notify returned errors.
      AttachmentPickerError() => _onAttachmentPickerError(result),
    };
  }

  Widget _buildTextInput(BuildContext context) {
    final margin = (widget.sendButtonLocation == SendButtonLocation.inside
            ? const EdgeInsets.only(right: 8)
            : EdgeInsets.zero) +
        (widget.actionsLocation != ActionsLocation.left || _commandEnabled
            ? const EdgeInsets.only(left: 8)
            : EdgeInsets.zero);

    return DropTarget(
      onDragDone: (details) async {
        final files = details.files;
        final attachments = <Attachment>[];
        for (final file in files) {
          final attachment = await file.toAttachment(type: AttachmentType.file);
          attachments.add(attachment);
        }

        if (attachments.isNotEmpty) _addAttachments(attachments);
      },
      onDragEntered: (details) {
        setState(() {});
      },
      onDragExited: (details) {},
      child: Container(
        margin: margin,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: _messageInputTheme.borderRadius,
          color: _messageInputTheme.inputBackgroundColor,
          border: GradientBoxBorder(
            gradient: _effectiveFocusNode.hasFocus
                ? _messageInputTheme.activeBorderGradient!
                : _messageInputTheme.idleBorderGradient!,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReplyToMessage(),
            _buildAttachments(),
            LimitedBox(
              maxHeight: widget.maxHeight,
              child: Focus(
                skipTraversal: true,
                onKeyEvent: _handleKeyPressed,
                child: StreamMessageTextField(
                  key: const Key('messageInputText'),
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  textInputAction: widget.textInputAction,
                  onSubmitted: (_) => sendMessage(),
                  keyboardType: widget.keyboardType,
                  controller: _effectiveController,
                  focusNode: _effectiveFocusNode,
                  style: _messageInputTheme.inputTextStyle,
                  autofocus: widget.autofocus,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: _getInputDecoration(context),
                  textCapitalization: widget.textCapitalization,
                  autocorrect: widget.autoCorrect,
                  contentInsertionConfiguration:
                      widget.contentInsertionConfiguration,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  KeyEventResult _handleKeyPressed(FocusNode node, KeyEvent event) {
    // Check for send message key.
    if (widget.sendMessageKeyPredicate(node, event)) {
      sendMessage();
      return KeyEventResult.handled;
    }

    // Check for clear quoted message key.
    if (widget.clearQuotedMessageKeyPredicate(node, event)) {
      if (_hasQuotedMessage && _effectiveController.text.isEmpty) {
        widget.onQuotedMessageCleared?.call();
      }
      return KeyEventResult.handled;
    }

    // Return ignored to allow other key events to be handled.
    return KeyEventResult.ignored;
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
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      prefixIcon: _commandEnabled
          ? Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: _streamChatTheme.colorTheme.accentPrimary,
                borderRadius: _messageInputTheme.borderRadius?.add(
                  BorderRadius.circular(6),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const StreamSvgIcon(
                    size: 16,
                    color: Colors.white,
                    icon: StreamSvgIcons.lightning,
                  ),
                  Text(
                    _effectiveController.message.command!.toUpperCase(),
                    style: _streamChatTheme.textTheme.footnoteBold.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
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
              child: StreamMessageInputIconButton(
                iconSize: 24,
                color: _messageInputTheme.actionButtonIdleColor,
                icon: const StreamSvgIcon(icon: StreamSvgIcons.closeSmall),
                onPressed: _effectiveController.clear,
              ),
            ),
          if (!_commandEnabled &&
              widget.actionsLocation == ActionsLocation.rightInside)
            _buildExpandActionsButton(context),
          if (widget.sendButtonLocation == SendButtonLocation.inside)
            _buildSendButton(context),
        ].nonNulls.toList(),
      ),
    ).merge(passedDecoration);
  }

  late final _onChangedDebounced = debounce(
    () {
      var value = _effectiveController.text;
      if (!mounted) return;
      value = value.trim();

      final channel = StreamChannel.of(context).channel;
      if (value.isNotEmpty && channel.canSendTypingEvents) {
        // Notify the server that the user started typing.
        channel.keyStroke(_effectiveController.message.parentId).onError(
          (error, stackTrace) {
            widget.onError?.call(error!, stackTrace);
          },
        );
      }

      int actionsLength;
      if (widget.actionsBuilder != null) {
        actionsLength = widget.actionsBuilder!(context, []).length;
      } else {
        actionsLength = 0;
      }
      if (widget.showCommandsButton) actionsLength += 1;
      if (!widget.disableAttachments) actionsLength += 1;

      setState(() => _actionsShrunk = value.isNotEmpty && actionsLength > 1);

      _checkContainsUrl(value, context);
    },
    const Duration(milliseconds: 350),
    leading: true,
  );

  String? _getHint(BuildContext context) {
    HintType hintType;

    if (_commandEnabled && _effectiveController.message.command == 'giphy') {
      hintType = HintType.searchGif;
    } else if (_effectiveController.attachments.isNotEmpty) {
      hintType = HintType.addACommentOrSend;
    } else if (_effectiveController.isSlowModeActive) {
      hintType = HintType.slowModeOn;
    } else {
      hintType = HintType.writeAMessage;
    }

    return widget.hintGetter.call(context, hintType);
  }

  String? _lastSearchedContainsUrlText;
  CancelableOperation? _enrichUrlOperation;
  final _urlRegex = RegExp(
    r'https?://(www\.)?[-a-zA-Z0-9@:%._+~#=]{2,256}\.[a-z]{2,4}\b([-a-zA-Z0-9@:%_+.~#?&//=]*)',
    caseSensitive: false,
  );

  void _checkContainsUrl(String value, BuildContext context) async {
    // Cancel the previous operation if it's still running
    _enrichUrlOperation?.cancel();

    // If the text is same as the last time, don't do anything
    if (_lastSearchedContainsUrlText == value) return;
    _lastSearchedContainsUrlText = value;

    final matchedUrls = _urlRegex.allMatches(value).where((it) {
      final _parsedMatch = Uri.tryParse(it.group(0) ?? '')?.withScheme;
      if (_parsedMatch == null) return false;

      return _parsedMatch.host.split('.').last.isValidTLD() &&
          widget.ogPreviewFilter.call(_parsedMatch, value);
    }).toList();

    // Reset the og attachment if the text doesn't contain any url
    if (matchedUrls.isEmpty ||
        !StreamChannel.of(context).channel.canSendLinks) {
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
      try {
        response = await client.enrichUrl(url);
        _ogAttachmentCache[url] = response;
      } catch (e, stk) {
        return Future.error(e, stk);
      }
    }
    return response;
  }

  Widget _buildReplyToMessage() {
    if (!_hasQuotedMessage) return const Empty();
    final quotedMessage = _effectiveController.message.quotedMessage!;

    final quotedMessageBuilder = widget.quotedMessageBuilder;
    if (quotedMessageBuilder != null) {
      return quotedMessageBuilder(
        context,
        _effectiveController.message.quotedMessage!,
      );
    }

    final containsUrl = quotedMessage.attachments.any((it) {
      return it.type == AttachmentType.urlPreview;
    });

    return StreamQuotedMessageWidget(
      reverse: true,
      showBorder: !containsUrl,
      message: quotedMessage,
      messageTheme: _streamChatTheme.otherMessageTheme,
      onQuotedMessageClear: widget.onQuotedMessageCleared,
      attachmentThumbnailBuilders:
          widget.quotedMessageAttachmentThumbnailBuilders,
    );
  }

  Widget _buildAttachments() {
    final attachments = _effectiveController.attachments;
    final nonOGAttachments = attachments.where((it) {
      return it.titleLink == null;
    }).toList(growable: false);

    // If there are no attachments, return an empty widget
    if (nonOGAttachments.isEmpty) return const Empty();

    // If the user has provided a custom attachment list builder, use that.
    final attachmentListBuilder = widget.attachmentListBuilder;
    if (attachmentListBuilder != null) {
      return attachmentListBuilder(
        context,
        nonOGAttachments,
        _onAttachmentRemovePressed,
      );
    }

    // Otherwise, use the default attachment list builder.
    return LimitedBox(
      maxHeight: 240,
      child: StreamMessageInputAttachmentList(
        attachments: nonOGAttachments,
        onRemovePressed: _onAttachmentRemovePressed,
        fileAttachmentListBuilder: widget.fileAttachmentListBuilder,
        mediaAttachmentListBuilder: widget.mediaAttachmentListBuilder,
        voiceRecordingAttachmentBuilder: widget.voiceRecordingAttachmentBuilder,
        fileAttachmentBuilder: widget.fileAttachmentBuilder,
        mediaAttachmentBuilder: widget.mediaAttachmentBuilder,
        voiceRecordingAttachmentListBuilder:
            widget.voiceRecordingAttachmentListBuilder,
      ),
    );
  }

  // Default callback for removing an attachment.
  Future<void> _onAttachmentRemovePressed(Attachment attachment) async {
    final file = attachment.file;
    final uploadState = attachment.uploadState;

    if (file != null && !uploadState.isSuccess && !isWeb) {
      await StreamAttachmentHandler.instance.deleteAttachmentFile(
        attachmentFile: file,
      );
    }

    _effectiveController.removeAttachmentById(attachment.id);
  }

  Widget _buildCommandButton(BuildContext context) {
    final s = _effectiveController.text.trim();
    final isCommandOptionsVisible = s.startsWith(_kCommandTrigger);
    final defaultButton = CommandButton(
      color: s.isNotEmpty
          ? _streamChatTheme.colorTheme.disabled
          : (isCommandOptionsVisible
              ? _messageInputTheme.actionButtonColor!
              : _messageInputTheme.actionButtonIdleColor!),
      onPressed: () async {
        // Clear the text if the commands options are already visible.
        if (isCommandOptionsVisible) {
          _effectiveController.clear();
          _effectiveFocusNode.unfocus();
        } else {
          // This triggers the [StreamAutocomplete] to show the command trigger.
          _effectiveController.textEditingValue = const TextEditingValue(
            text: _kCommandTrigger,
            selection: TextSelection.collapsed(offset: _kCommandTrigger.length),
          );
          _effectiveFocusNode.requestFocus();
        }
      },
    );

    return widget.commandButtonBuilder?.call(context, defaultButton) ??
        defaultButton;
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

  /// Sends the current message
  Future<void> sendMessage() async {
    if (_effectiveController.isSlowModeActive) return;
    if (!widget.validator(_effectiveController.message)) return;

    final streamChannel = StreamChannel.of(context);
    final channel = streamChannel.channel;
    var message = _effectiveController.value;

    if (!channel.canSendLinks &&
        _urlRegex.allMatches(message.text ?? '').any((element) =>
            element.group(0)?.split('.').last.isValidTLD() == true)) {
      showInfoBottomSheet(
        context,
        icon: StreamSvgIcon(
          icon: StreamSvgIcons.error,
          color: StreamChatTheme.of(context).colorTheme.accentError,
          size: 24,
        ),
        title: context.translations.linkDisabledError,
        details: context.translations.linkDisabledDetails,
        okText: context.translations.okLabel,
      );
      return;
    }

    _maybeDeleteDraftMessage(message);
    widget.onQuotedMessageCleared?.call();
    _effectiveController.reset();

    if (widget.preMessageSending case final onPreMessageSending?) {
      message = await onPreMessageSending.call(message);
    }

    // If the channel is not up to date, we should reload it before sending
    // the message.
    if (!channel.state!.isUpToDate) {
      await streamChannel.reloadChannel();

      // We need to wait for the frame to be rendered with the updated channel
      // state before sending the message.
      await WidgetsBinding.instance.endOfFrame;
    }

    await _sendOrUpdateMessage(message: message);

    if (mounted) {
      if (widget.shouldKeepFocusAfterMessage ?? !_commandEnabled) {
        FocusScope.of(context).requestFocus(_effectiveFocusNode);
      } else {
        FocusScope.of(context).unfocus();
      }
    }
  }

  Future<void> _sendOrUpdateMessage({
    required Message message,
  }) async {
    try {
      final channel = StreamChannel.of(context).channel;

      // Note: edited messages which are bounced back with an error needs to be
      // sent as new messages as the backend doesn't store them.
      final resp = await switch (_isEditing && !message.isBouncedWithError) {
        true => channel.updateMessage(message),
        false => channel.sendMessage(message),
      };

      // We don't want to start the cooldown if an already sent message is
      // being edited.
      if (!_isEditing) {
        _effectiveController.startCooldown(channel.getRemainingCooldown());
      }

      widget.onMessageSent?.call(resp.message);
    } catch (e, stk) {
      if (widget.onError != null) {
        return widget.onError?.call(e, stk);
      }

      rethrow;
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

  void _maybeUpdateOrDeleteDraftMessage() {
    final message = _effectiveController.message;
    final isMessageValid = widget.validator.call(message);

    // If the message is valid, we need to create or update it as a draft
    // message for the channel or thread.
    if (isMessageValid) return _maybeUpdateDraftMessage(message);

    // Otherwise, we need to delete the draft message.
    return _maybeDeleteDraftMessage(message);
  }

  void _maybeUpdateDraftMessage(Message message) {
    final channel = StreamChannel.of(context).channel;
    final draft = switch (message.parentId) {
      final parentId? => channel.state?.threadDraft(parentId),
      null => channel.state?.draft,
    };

    final draftMessage = message.toDraftMessage();

    // If the draft message didn't change, we don't need to update it.
    if (draft?.message == draftMessage) return;

    return channel.createDraft(draftMessage).ignore();
  }

  void _maybeDeleteDraftMessage(Message message) {
    final channel = StreamChannel.of(context).channel;
    final draft = switch (message.parentId) {
      final parentId? => channel.state?.threadDraft(parentId),
      null => channel.state?.draft,
    };

    // If there is no draft message, we don't need to delete it.
    if (draft == null) return;

    return channel.deleteDraft(parentId: message.parentId).ignore();
  }

  @override
  void deactivate() {
    final config = StreamChatConfiguration.of(context);
    if (!_isEditing && config.draftMessagesEnabled) {
      _maybeUpdateOrDeleteDraftMessage();
    }

    super.deactivate();
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_onChangedDebounced);
    _controller?.dispose();
    _effectiveFocusNode.removeListener(_focusNodeListener);
    _focusNode?.dispose();
    _onChangedDebounced.cancel();
    _audioRecorderController.dispose();
    _draftStreamSubscription?.cancel();
    super.dispose();
  }
}

/// Preview of an Open Graph attachment.
class OGAttachmentPreview extends StatelessWidget {
  /// Returns a new instance of [OGAttachmentPreview]
  const OGAttachmentPreview({
    super.key,
    required this.attachment,
    this.onDismissPreviewPressed,
  });

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
          child: StreamSvgIcon(
            icon: StreamSvgIcons.link,
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
          icon: const StreamSvgIcon(icon: StreamSvgIcons.closeSmall),
          onPressed: onDismissPreviewPressed,
        ),
      ],
    );
  }
}
