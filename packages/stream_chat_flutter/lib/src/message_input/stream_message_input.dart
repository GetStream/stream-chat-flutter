import 'dart:async';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/src/message_input/tld.dart';
import 'package:stream_chat_flutter/src/misc/simple_safe_area.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

const _kCommandTrigger = '/';
const _kMentionTrigger = '@';

/// Signature for the function that determines if a [matchedUri] should be
/// previewed as an OG Attachment.
typedef OgPreviewFilter =
    bool Function(
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
    this.messageInputController,
    this.focusNode,
    this.disableAttachments = false,
    this.maxAttachmentSize = kDefaultMaxAttachmentSize,
    this.canAlsoSendToChannelFromThread = true,
    this.enableVoiceRecording = false,
    this.sendVoiceRecordingAutomatically = false,
    this.voiceRecordingFeedback = const AudioRecorderFeedback(),
    this.userMentionsTileBuilder,
    this.onError,
    this.attachmentLimit,
    this.allowedAttachmentPickerTypes = AttachmentPickerType.values,
    this.onAttachmentLimitExceed,
    this.customAutocompleteTriggers = const [],
    this.mentionAllAppUsers = false,
    this.shouldKeepFocusAfterMessage,
    this.validator = _defaultValidator,
    this.restorationId,
    this.enableSafeArea,
    this.enableMentionsOverlay = true,
    this.onQuotedMessageCleared,
    this.ogPreviewFilter = _defaultOgPreviewFilter,
    this.hintGetter = _defaultHintGetter,
    this.useSystemAttachmentPicker = false,
    this.pollConfig,
    this.attachmentPickerOptionsBuilder,
    this.onAttachmentPickerResult,
    this.sendMessageKeyPredicate = _defaultSendMessageKeyPredicate,
    this.clearQuotedMessageKeyPredicate = _defaultClearQuotedMessageKeyPredicate,
    this.textInputAction,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.autofocus = false,
    this.autoCorrect = true,
  });

  /// List of triggers for showing autocomplete.
  final Iterable<StreamAutocompleteTrigger> customAutocompleteTriggers;

  /// Function called after sending the message.
  final void Function(Message)? onMessageSent;

  /// Function called right before sending the message.
  ///
  /// Use this to transform the message.
  final FutureOr<Message> Function(Message)? preMessageSending;

  /// The text controller of the TextField.
  final StreamMessageInputController? messageInputController;

  /// The focus node associated to the TextField.
  final FocusNode? focusNode;

  /// If true the attachments button will not be displayed.
  ///
  /// Defaults to false.
  final bool disableAttachments;

  /// Max attachment size in bytes.
  ///
  /// Defaults to 100 MB.
  final int maxAttachmentSize;

  /// Show the checkbox to send the message as a direct message to the channel.
  ///
  /// Defaults to true.
  final bool canAlsoSendToChannelFromThread;

  /// If true the voice recording button will be displayed.
  ///
  /// Defaults to false.
  final bool enableVoiceRecording;

  /// If True, the voice recording will be sent automatically after the user
  /// releases the microphone button.
  ///
  /// Defaults to false.
  final bool sendVoiceRecordingAutomatically;

  /// The feedback handler for voice recording interactions.
  ///
  /// Defaults to [AudioRecorderFeedback] with feedback enabled.
  ///
  /// To disable feedback:
  /// ```dart
  /// StreamMessageInput(
  ///   voiceRecordingFeedback: const AudioRecorderFeedback.disabled(),
  /// )
  /// ```
  ///
  /// To customize feedback, extend [AudioRecorderFeedback] and override
  /// the desired methods:
  /// ```dart
  /// class CustomFeedback extends AudioRecorderFeedback {
  ///   @override
  ///   Future<void> onRecordStart(BuildContext context) async {
  ///     // Haptic feedback
  ///     await HapticFeedback.heavyImpact();
  ///     // Or system sound
  ///     // await SystemSound.play(SystemSoundType.click);
  ///   }
  /// }
  ///
  /// StreamMessageInput(
  ///   voiceRecordingFeedback: CustomFeedback(),
  /// )
  /// ```
  final AudioRecorderFeedback voiceRecordingFeedback;

  /// Customize the tile for the mentions overlay.
  final UserMentionTileBuilder? userMentionsTileBuilder;

  /// A callback for error reporting
  final ErrorListener? onError;

  /// A limit for the no. of attachments that can be sent with a single message.
  final int? attachmentLimit;

  /// The list of allowed attachment types which can be picked using the
  /// attachment button.
  ///
  /// By default, all the attachment types are allowed.
  final List<AttachmentPickerType> allowedAttachmentPickerTypes;

  /// A callback for when the [attachmentLimit] is exceeded.
  ///
  /// This will override the default error alert behaviour.
  final AttachmentLimitExceedListener? onAttachmentLimitExceed;

  /// When enabled mentions search users across the entire app.
  ///
  /// Defaults to false.
  final bool mentionAllAppUsers;

  /// Defines if the [StreamMessageInput] loses focuses after a message is sent.
  /// The default behaviour keeps focus until a command is enabled.
  final bool? shouldKeepFocusAfterMessage;

  /// A callback function that validates the message.
  final MessageValidator validator;

  /// Restoration ID to save and restore the state of the MessageInput.
  final String? restorationId;

  /// Wrap [StreamMessageInput] with a [SafeArea widget]
  final bool? enableSafeArea;

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

  /// Builder for customizing the attachment picker options.
  ///
  /// The builder receives the [BuildContext] and a list of default options
  /// that can be modified or extended.
  ///
  /// If not provided, the default options are presented.
  final AttachmentPickerOptionsBuilder? attachmentPickerOptionsBuilder;

  /// Callback that is called when the attachment picker result is received.
  ///
  /// Return `true` if the result is handled. Otherwise, return `false` to
  /// allow the result to be handled internally.
  final OnAttachmentPickerResult? onAttachmentPickerResult;

  /// Predicate to determine if the current key event should trigger sending
  /// the message. Defaults to Enter on non-mobile platforms (without Shift).
  final KeyEventPredicate sendMessageKeyPredicate;

  /// Predicate to determine if the current key event should clear the quoted
  /// message. Defaults to Escape on non-mobile platforms.
  final KeyEventPredicate clearQuotedMessageKeyPredicate;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// The keyboard type assigned to the TextField.
  final TextInputType? keyboardType;

  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization textCapitalization;

  /// Autofocus property passed to the TextField.
  final bool autofocus;

  /// Whether to enable autocorrect.
  ///
  /// Defaults to true.
  final bool autoCorrect;

  static bool _defaultSendMessageKeyPredicate(FocusNode node, KeyEvent event) {
    if (CurrentPlatform.isAndroid || CurrentPlatform.isIos) return false;
    if (HardwareKeyboard.instance.isShiftPressed) return false;
    return event.logicalKey == LogicalKeyboardKey.enter && event is KeyDownEvent;
  }

  static bool _defaultClearQuotedMessageKeyPredicate(FocusNode node, KeyEvent event) {
    if (CurrentPlatform.isAndroid || CurrentPlatform.isIos) return false;
    return event.logicalKey == LogicalKeyboardKey.escape && event is KeyDownEvent;
  }

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
    final hasText = message.text?.trim().isNotEmpty == true;
    final hasAttachments = message.attachments.isNotEmpty;
    final hasPoll = message.pollId != null;

    return hasText || hasAttachments || hasPoll;
  }

  @override
  StreamMessageInputState createState() => StreamMessageInputState();
}

/// State of [StreamMessageInput]
class StreamMessageInputState extends State<StreamMessageInput> with RestorationMixin<StreamMessageInput> {
  bool get _commandEnabled => _effectiveController.message.command != null;

  bool get _isPickerVisible => _pickerController != null;
  StreamAttachmentPickerController? _pickerController;
  StreamSubscription<CustomAttachmentPickerResult>? _customResultSubscription;
  bool _isSyncingControllers = false;

  late StreamChatThemeData _streamChatTheme;
  late StreamMessageInputThemeData _messageInputTheme;

  bool get _isEditing => !_effectiveController.message.state.isInitial;

  late final _audioRecorderController = StreamAudioRecorderController();

  FocusNode get _effectiveFocusNode => widget.focusNode ?? (_focusNode ??= FocusNode());
  FocusNode? _focusNode;

  StreamMessageInputController get _effectiveController => widget.messageInputController ?? _controller!.value;
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
      ..removeListener(_onChangedThrottled)
      ..removeListener(_onChangedDebounced)
      ..addListener(_onChangedThrottled)
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
    if (!_isEditing && channel.state != null) {
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
    if (widget.messageInputController == null && oldWidget.messageInputController != null) {
      _createLocalController(oldWidget.messageInputController!.message);
    } else if (widget.messageInputController != null && oldWidget.messageInputController == null) {
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

  void _focusNodeListener() {
    if (_effectiveFocusNode.hasFocus && _isPickerVisible) {
      _hidePicker();
    }
  }

  KeyEventResult _handleKeyPressed(FocusNode node, KeyEvent event) {
    if (widget.sendMessageKeyPredicate(node, event)) {
      sendMessage();
      return KeyEventResult.handled;
    }
    if (widget.clearQuotedMessageKeyPredicate(node, event)) {
      final hasQuote = _effectiveController.message.quotedMessage != null;
      if (hasQuote && _effectiveController.text.isEmpty) {
        _effectiveController.clearQuotedMessage();
        widget.onQuotedMessageCleared?.call();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    bool canSendOrUpdateMessage(List<ChannelCapability> capabilities) {
      var result = capabilities.contains(ChannelCapability.sendMessage);

      final insideThread = _effectiveController.message.parentId != null;
      if (insideThread) {
        result |= capabilities.contains(ChannelCapability.sendReply);
      }

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

    final spacing = context.streamSpacing;

    return Material(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.streamColorScheme.backgroundElevation1,
        ),
        child: SimpleSafeArea(
          enabled: !_isPickerVisible && (widget.enableSafeArea ?? _messageInputTheme.enableSafeArea ?? true),
          minimum: _isPickerVisible ? .zero : .only(bottom: spacing.md),
          child: Center(heightFactor: 1, child: messageInput),
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
          optionsViewBuilder:
              (
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
            optionsViewBuilder:
                (
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
                      StreamAutocomplete.of(context).acceptAutocompleteOption(user.name);
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
    final currentUserId = StreamChat.of(context).currentUser?.id;

    return StreamMessageValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropTarget(
            onDragDone: (details) async {
              final attachments = <Attachment>[];
              for (final file in details.files) {
                attachments.add(await file.toAttachment(type: AttachmentType.file));
              }
              if (attachments.isNotEmpty) _addAttachments(attachments);
            },
            onDragEntered: (_) {},
            onDragExited: (_) {},
            child: Focus(
              skipTraversal: true,
              onKeyEvent: _handleKeyPressed,
              child: StreamChatMessageComposer(
                controller: controller,
                currentUserId: currentUserId,
                onAttachmentButtonPressed: widget.disableAttachments ? null : _onAttachmentButtonPressed,
                isPickerOpen: _isPickerVisible,
                placeholder: _getHint(context) ?? '',
                focusNode: focusNode,
                onSendPressed: sendMessage,
                canAlsoSendToChannel: _shouldShowSendToChannelCheckbox(),
                audioRecorderController: widget.enableVoiceRecording ? _audioRecorderController : null,
                sendVoiceRecordingAutomatically: widget.sendVoiceRecordingAutomatically,
                feedback: widget.voiceRecordingFeedback,
                onQuotedMessageCleared: () {
                  _effectiveController.clearQuotedMessage();
                  widget.onQuotedMessageCleared?.call();
                },
                textInputAction: widget.textInputAction,
                keyboardType: widget.keyboardType,
                textCapitalization: widget.textCapitalization,
                autofocus: widget.autofocus,
                autocorrect: widget.autoCorrect,
              ),
            ),
          ),
          _buildInlineAttachmentPicker(context),
        ].nonNulls.toList(),
      ),
    );
  }

  Widget? _buildInlineAttachmentPicker(BuildContext context) {
    if (!_isPickerVisible) return null;

    final allowedTypes = _getAllowedAttachmentPickerTypes();

    final messageInputTheme = StreamMessageInputTheme.of(context);
    final isWebOrDesktop = switch (CurrentPlatform.type) {
      PlatformType.android || PlatformType.ios => false,
      _ => true,
    };
    final useSystemPicker =
        widget.useSystemAttachmentPicker || (messageInputTheme.useSystemAttachmentPicker ?? false) || isWebOrDesktop;

    final child = useSystemPicker
        ? systemAttachmentPickerBuilder(
            context: context,
            controller: _pickerController!,
            allowedTypes: allowedTypes,
            pollConfig: widget.pollConfig,
            optionsBuilder: widget.attachmentPickerOptionsBuilder,
            onError: _onPickerError,
            onPollCreated: _onPollCreated,
          )
        : tabbedAttachmentPickerBuilder(
            context: context,
            controller: _pickerController!,
            allowedTypes: allowedTypes,
            pollConfig: widget.pollConfig,
            optionsBuilder: widget.attachmentPickerOptionsBuilder,
            onError: _onPickerError,
            onPollCreated: _onPollCreated,
            onCommandSelected: _onCommandSelectedFromPicker,
          );

    return SizedBox(height: 333, child: child);
  }

  void _onCommandSelectedFromPicker(Command command) {
    _hidePicker();
    _effectiveController.command = command.name;
  }

  bool _shouldShowSendToChannelCheckbox() {
    if (!widget.canAlsoSendToChannelFromThread) return false;

    final insideThread = _effectiveController.message.parentId != null;
    return insideThread;
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

  Future<void> _onPollCreated(Poll poll) async {
    _hidePicker();

    final channel = StreamChannel.maybeOf(context)?.channel;
    if (channel == null) return;

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

  /// Toggles the inline attachment picker visibility.
  void _onAttachmentButtonPressed() => _isPickerVisible ? _hidePicker() : _showPicker();

  void _showPicker() {
    if (_isPickerVisible) return;

    setState(() {
      final attachmentLimit = widget.attachmentLimit;
      _pickerController = attachmentLimit != null
          ? StreamAttachmentPickerController(
              initialAttachments: _effectiveController.attachments,
              initialPoll: _effectiveController.poll,
              maxAttachmentCount: attachmentLimit,
              maxAttachmentSize: widget.maxAttachmentSize,
            )
          : StreamAttachmentPickerController(
              initialAttachments: _effectiveController.attachments,
              initialPoll: _effectiveController.poll,
              maxAttachmentSize: widget.maxAttachmentSize,
            );
      _pickerController!.addListener(_syncPickerToMessage);
      _effectiveController.addListener(_syncMessageToPicker);
      _customResultSubscription = _pickerController!.customResults.listen(_onCustomResult);

      if (_effectiveFocusNode.hasFocus) {
        _effectiveFocusNode.unfocus();
      }
    });
  }

  void _hidePicker() {
    if (!_isPickerVisible) return;
    setState(_disposePickerResources);
  }

  void _disposePickerResources() {
    _customResultSubscription?.cancel();
    _customResultSubscription = null;
    _pickerController?.removeListener(_syncPickerToMessage);
    _effectiveController.removeListener(_syncMessageToPicker);
    _pickerController?.dispose();
    _pickerController = null;
  }

  Future<void> _onCustomResult(CustomAttachmentPickerResult result) async {
    final handled = await widget.onAttachmentPickerResult?.call(result) ?? false;
    if (handled && mounted) _hidePicker();
  }

  /// Copies picker attachments into the message controller when the user
  /// selects or removes items in the picker.
  void _syncPickerToMessage() {
    if (_isSyncingControllers) return;
    _isSyncingControllers = true;

    try {
      _effectiveController.attachments = _pickerController?.value.attachments ?? [];
    } finally {
      _isSyncingControllers = false;
    }
  }

  /// Removes picker selections that the user deleted from the composer preview.
  void _syncMessageToPicker() {
    if (_isSyncingControllers) return;

    final pickerController = _pickerController;
    if (pickerController == null) return;

    final messageIds = _effectiveController.attachments.map((a) => a.id).toSet();
    final pickerIds = pickerController.value.attachments.map((a) => a.id).toSet();

    final removedIds = pickerIds.difference(messageIds);
    if (removedIds.isEmpty) return;

    _isSyncingControllers = true;
    try {
      for (final id in removedIds) {
        pickerController.removeAttachmentById(id);
      }
    } finally {
      _isSyncingControllers = false;
    }
  }

  void _onPickerError(AttachmentPickerError error) {
    widget.onError?.call(error.error, error.stackTrace);
  }

  late final _onChangedThrottled = throttle(
    () {
      if (!mounted) return;

      final channel = StreamChannel.maybeOf(context)?.channel;
      if (channel == null) return;

      final value = _effectiveController.text.trim();
      if (value.isNotEmpty && channel.canUseTypingEvents) {
        channel.keyStroke(_effectiveController.message.parentId).onError(
          (error, stackTrace) {
            widget.onError?.call(error!, stackTrace);
          },
        );
      }
    },
    const Duration(milliseconds: 350),
  );

  late final _onChangedDebounced = debounce(
    () {
      if (!mounted) return;

      final channel = StreamChannel.maybeOf(context)?.channel;
      if (channel == null) return;

      final value = _effectiveController.text.trim();
      _checkContainsUrl(value, channel);
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

  void _checkContainsUrl(String value, Channel channel) async {
    // Cancel the previous operation if it's still running
    _enrichUrlOperation?.cancel();

    // If the text is same as the last time, don't do anything
    if (_lastSearchedContainsUrlText == value) return;
    _lastSearchedContainsUrlText = value;

    final matchedUrls = _urlRegex.allMatches(value).where((it) {
      final _parsedMatch = Uri.tryParse(it.group(0) ?? '')?.withScheme;
      if (_parsedMatch == null) return false;

      return _parsedMatch.host.split('.').last.isValidTLD() && widget.ogPreviewFilter.call(_parsedMatch, value);
    }).toList();

    // Reset the og attachment if the text doesn't contain any url
    if (matchedUrls.isEmpty || !channel.canSendLinks) {
      return _effectiveController.clearOGAttachment();
    }

    final firstMatchedUrl = matchedUrls.first.group(0)!;

    // If the parsed url matches the ogAttachment url, don't do anything
    if (_effectiveController.ogAttachment?.titleLink == firstMatchedUrl) {
      return;
    }

    final client = StreamChat.maybeOf(context)?.client;
    if (client == null) return;

    _enrichUrlOperation =
        CancelableOperation.fromFuture(
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
      try {
        response = await client.enrichUrl(url);
        _ogAttachmentCache[url] = response;
      } catch (e, stk) {
        return Future.error(e, stk);
      }
    }
    return response;
  }

  /// Adds an attachment to the [messageInputController.attachments] map
  void _addAttachments(Iterable<Attachment> attachments) {
    if (widget.attachmentLimit case final limit?) {
      final length = _effectiveController.attachments.length + attachments.length;
      if (length > limit) {
        final onAttachmentLimitExceed = widget.onAttachmentLimitExceed;
        if (onAttachmentLimitExceed != null) {
          return onAttachmentLimitExceed(
            limit,
            context.translations.attachmentLimitExceedError(limit),
          );
        }
        return _showErrorAlert(
          context.translations.attachmentLimitExceedError(limit),
        );
      }
    }
    for (final attachment in attachments) {
      _effectiveController.addAttachment(attachment);
    }
  }

  /// Sends the current message
  Future<void> sendMessage() async {
    if (_effectiveController.isSlowModeActive) return;
    if (!widget.validator(_effectiveController.message)) return;

    _hidePicker();

    final streamChannel = StreamChannel.maybeOf(context);
    if (streamChannel == null) return;

    final channel = streamChannel.channel;
    var message = _effectiveController.value;

    if (!channel.canSendLinks &&
        _urlRegex
            .allMatches(message.text ?? '')
            .any((element) => element.group(0)?.split('.').last.isValidTLD() == true)) {
      showInfoBottomSheet(
        context,
        icon: Icon(
          context.streamIcons.exclamationCircle1,
          color: StreamChatTheme.of(context).colorTheme.accentError,
          size: 24,
        ),
        title: context.translations.linkDisabledError,
        details: context.translations.linkDisabledDetails,
        okText: context.translations.okLabel,
      );
      return;
    }

    _maybeDeleteDraftMessage(message, channel);
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

    await _sendOrUpdateMessage(message: message, channel: channel);

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
    required Channel channel,
  }) async {
    try {
      // Note: edited messages which are bounced back with an error needs to be
      // sent as new messages as the backend doesn't store them.
      // Use message.state directly rather than _isEditing, because the
      // controller is reset before this method is called.
      final isEditing = !message.state.isInitial;
      final resp = await switch (isEditing && !message.isBouncedWithError) {
        true => channel.updateMessage(message),
        false => channel.sendMessage(message),
      };

      // We don't want to start the cooldown if an already sent message is
      // being edited.
      if (!isEditing) {
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
    final channel = StreamChannel.maybeOf(context)?.channel;
    if (channel == null) return;

    final message = _effectiveController.message;
    final isMessageValid = widget.validator.call(message);

    // If the message is valid, we need to create or update it as a draft
    // message for the channel or thread.
    if (isMessageValid) return _maybeUpdateDraftMessage(message, channel);

    // Otherwise, we need to delete the draft message.
    return _maybeDeleteDraftMessage(message, channel);
  }

  void _maybeUpdateDraftMessage(Message message, Channel channel) {
    final draft = switch (message.parentId) {
      final parentId? => channel.state?.threadDraft(parentId),
      null => channel.state?.draft,
    };

    final draftMessage = message.toDraftMessage();

    // If the draft message is not valid, we don't need to update it.
    final isDraftValid = widget.validator.call(draftMessage.toMessage());
    if (!isDraftValid) return;

    // If the draft message didn't change, we don't need to update it.
    if (draft?.message == draftMessage) return;

    return channel.createDraft(draftMessage).ignore();
  }

  void _maybeDeleteDraftMessage(Message message, Channel channel) {
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
    _disposePickerResources();
    _effectiveController
      ..removeListener(_onChangedThrottled)
      ..removeListener(_onChangedDebounced);
    _controller?.dispose();
    _effectiveFocusNode.removeListener(_focusNodeListener);
    _focusNode?.dispose();
    _onChangedDebounced.cancel();
    _onChangedThrottled.cancel();
    _audioRecorderController.dispose();
    _draftStreamSubscription?.cancel();
    super.dispose();
  }
}
