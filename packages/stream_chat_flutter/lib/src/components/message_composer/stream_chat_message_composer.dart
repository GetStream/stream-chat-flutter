import 'dart:async';
import 'dart:math' as math;

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_header.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_leading.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_trailing.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_leading.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_recording_locked.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_recording_ongoing.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_trailing.dart';
import 'package:stream_chat_flutter/src/message_input/dm_checkbox_list_tile.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// Different types of hints that can be shown in [StreamChatMessageComposer].
enum HintType {
  /// Shown when a 'giphy' command is active.
  searchGif,

  /// Shown when the composer has attachments and no other hint applies.
  addACommentOrSend,

  /// Shown when slow mode is active.
  slowModeOn,

  /// Default hint.
  writeAMessage,
}

/// Function that returns the hint text for [StreamChatMessageComposer].
typedef HintGetter = String? Function(BuildContext context, HintType type);

/// Predicate that determines whether a [KeyEvent] should trigger an action.
typedef KeyEventPredicate = bool Function(FocusNode node, KeyEvent event);

/// A fully self-contained message-composer widget.
///
/// Absorbs all responsibilities of the legacy [StreamMessageInput] widget:
/// send pipeline, draft sync, OG enrichment, attachment picker, voice
/// recording, autocomplete, key handlers, slow-mode cooldown, drag-and-drop,
/// back-press picker dismiss, and state restoration.
///
/// Create via the default constructor, which accepts a [MessageComposerProps].
/// Sub-components can be customised through the [StreamComponentFactory].
class StreamChatMessageComposer extends StatefulWidget {
  /// Creates a [StreamChatMessageComposer].
  StreamChatMessageComposer({
    super.key,
    StreamMessageComposerController? controller,
    this.onMessageSent,
    this.preMessageSending,
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
    this.validator,
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
    this.isFloating = false,
    this.audioRecorderController,
  }) : props = MessageComposerProps(
         controller: controller,
         isFloating: isFloating,
         message: null,
         onSendPressed: () {},
         focusNode: focusNode,
         audioRecorderController: audioRecorderController,
         sendVoiceRecordingAutomatically: sendVoiceRecordingAutomatically,
         feedback: voiceRecordingFeedback,
         textInputAction: textInputAction,
         keyboardType: keyboardType,
         textCapitalization: textCapitalization,
         autofocus: autofocus,
         autocorrect: autoCorrect,
       );

  /// The controller for the message composer.
  ///
  /// When not provided, a controller is created and owned internally.
  StreamMessageComposerController? get controller => props.controller;

  /// The props for the message composer.
  final MessageComposerProps props;

  // ---- Behavior props ----

  /// Called after a message is sent successfully.
  final void Function(Message)? onMessageSent;

  /// Called right before sending; can transform the message.
  final FutureOr<Message> Function(Message)? preMessageSending;

  /// Focus node for the text field.
  final FocusNode? focusNode;

  /// When true, the attachment button is hidden.
  final bool disableAttachments;

  /// Maximum attachment size in bytes (default 100 MB).
  final int maxAttachmentSize;

  /// Show "also send to channel" checkbox in threads.
  final bool canAlsoSendToChannelFromThread;

  /// Whether to show the voice-recording button.
  final bool enableVoiceRecording;

  /// Whether to automatically send voice recordings.
  final bool sendVoiceRecordingAutomatically;

  /// Haptic/audio feedback for voice-recording interactions.
  final AudioRecorderFeedback voiceRecordingFeedback;

  /// Custom tile builder for the @-mention overlay.
  final UserMentionTileBuilder? userMentionsTileBuilder;

  /// Error callback.
  final ErrorListener? onError;

  /// Maximum number of attachments per message.
  final int? attachmentLimit;

  /// Allowed attachment picker types.
  final List<AttachmentPickerType> allowedAttachmentPickerTypes;

  /// Called when [attachmentLimit] is exceeded.
  final AttachmentLimitExceedListener? onAttachmentLimitExceed;

  /// Extra autocomplete triggers (besides built-in `/` and `@`).
  final Iterable<StreamAutocompleteTrigger> customAutocompleteTriggers;

  /// Search all app users for @-mentions (default: channel members only).
  final bool mentionAllAppUsers;

  /// Keep keyboard focus after sending a message.
  ///
  /// Defaults to true unless a command was active.
  final bool? shouldKeepFocusAfterMessage;

  /// Custom message validator. Defaults to requiring non-empty text,
  /// attachments, or a poll.
  final MessageValidator? validator;

  /// Restoration ID for state persistence.
  final String? restorationId;

  /// Wrap the composer in [SafeArea].
  final bool? enableSafeArea;

  /// Disable the @-mention overlay.
  final bool enableMentionsOverlay;

  /// Called when the quoted message is cleared via key shortcut.
  final VoidCallback? onQuotedMessageCleared;

  /// Filter determining whether a URL should show an OG preview.
  final OgPreviewFilter ogPreviewFilter;

  /// Returns the hint text for a given [HintType].
  final HintGetter hintGetter;

  /// Use the system attachment picker instead of the inline one.
  final bool useSystemAttachmentPicker;

  /// Poll creation configuration.
  final PollConfig? pollConfig;

  /// Customise the attachment picker options.
  final AttachmentPickerOptionsBuilder? attachmentPickerOptionsBuilder;

  /// Called when the attachment picker produces a custom result.
  final OnAttachmentPickerResult? onAttachmentPickerResult;

  /// Key predicate that triggers sending the message.
  final KeyEventPredicate sendMessageKeyPredicate;

  /// Key predicate that clears the quoted message.
  final KeyEventPredicate clearQuotedMessageKeyPredicate;

  /// Keyboard action button type.
  final TextInputAction? textInputAction;

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Text capitalisation mode.
  final TextCapitalization textCapitalization;

  /// Auto-focus the text field.
  final bool autofocus;

  /// Enable autocorrect.
  final bool autoCorrect;

  /// Whether the composer is displayed in a floating container.
  final bool isFloating;

  /// Externally-managed audio recorder controller.
  ///
  /// When provided, the send button transforms into a microphone button
  /// and the recording flow is handled by this controller.
  final StreamAudioRecorderController? audioRecorderController;

  // ---- Defaults ----

  static bool _defaultSendMessageKeyPredicate(FocusNode node, KeyEvent event) {
    if (CurrentPlatform.isAndroid || CurrentPlatform.isIos) return false;
    if (HardwareKeyboard.instance.isShiftPressed) return false;
    return event.logicalKey == LogicalKeyboardKey.enter && event is KeyDownEvent;
  }

  static bool _defaultClearQuotedMessageKeyPredicate(FocusNode node, KeyEvent event) {
    if (CurrentPlatform.isAndroid || CurrentPlatform.isIos) return false;
    return event.logicalKey == LogicalKeyboardKey.escape && event is KeyDownEvent;
  }

  static String? _defaultHintGetter(BuildContext context, HintType type) => switch (type) {
    HintType.searchGif => context.translations.searchGifLabel,
    HintType.slowModeOn => context.translations.slowModeOnLabel,
    HintType.addACommentOrSend || HintType.writeAMessage => context.translations.writeAMessageLabel,
  };

  static bool _defaultOgPreviewFilter(Uri matchedUri, String messageText) => true;

  @override
  State<StreamChatMessageComposer> createState() => _StreamChatMessageComposerState();
}

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class _StreamChatMessageComposerState extends State<StreamChatMessageComposer>
    with RestorationMixin<StreamChatMessageComposer>, SingleTickerProviderStateMixin {
  // ---- Controller ----

  StreamMessageComposerController get _effectiveController =>
      widget.controller ?? _restorableController!.value;

  StreamRestorableMessageComposerController? _restorableController;

  void _createLocalController([Message? message]) {
    assert(_restorableController == null, '');
    _restorableController = StreamRestorableMessageComposerController(message: message);
  }

  void _registerController() {
    assert(_restorableController != null, '');
    registerForRestoration(_restorableController!, 'messageComposerController');
    _initController();
  }

  String? _prevQuotedMessageId;

  void _initController() {
    _prevQuotedMessageId = _effectiveController.message.quotedMessageId;
    _effectiveController
      ..addListener(_onControllerChanged)
      ..attach(
        StreamChannel.of(context),
        draftMessagesEnabled: StreamChatConfiguration.of(context).draftMessagesEnabled,
        ogPreviewFilter: (uri, text) => widget.ogPreviewFilter.call(uri, text),
        onError: widget.onError,
      );
  }

  /// Notifies [widget.onQuotedMessageCleared] when the controller clears
  /// the quoted message externally (e.g. the quoted message was deleted).
  void _onControllerChanged() {
    final current = _effectiveController.message.quotedMessageId;
    if (_prevQuotedMessageId != null && current == null) {
      widget.onQuotedMessageCleared?.call();
    }
    _prevQuotedMessageId = current;
  }

  // ---- Focus ----

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _effectiveController.inputController.focusNode;

  // ---- Picker ----

  bool get _isPickerVisible => _pickerController != null;
  StreamAttachmentPickerController? _pickerController;
  StreamSubscription<CustomAttachmentPickerResult>? _customResultSubscription;
  bool _isSyncingControllers = false;

  late final AnimationController _pickerAnimationController;
  late final CurvedAnimation _pickerAnimation;

  // ---- Audio recorder ----

  late final StreamAudioRecorderController _audioRecorderController = StreamAudioRecorderController();

  StreamAudioRecorderController get _effectiveAudioRecorderController =>
      widget.audioRecorderController ?? _audioRecorderController;

  // ---- Theme ----

  late StreamChatThemeData _streamChatTheme;

  // ---- Init / lifecycle ----

  @override
  void initState() {
    super.initState();
    _pickerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _pickerAnimation = CurvedAnimation(
      parent: _pickerAnimationController,
      curve: Curves.easeInOut,
    );

    if (widget.controller == null) {
      _createLocalController();
    }

    _effectiveFocusNode.addListener(_focusNodeListener);

    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted && widget.controller != null) {
        _initController();
      }
    });
  }

  @override
  void didChangeDependencies() {
    _streamChatTheme = StreamChatTheme.of(context);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant StreamChatMessageComposer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller == null && oldWidget.controller != null) {
      _createLocalController(oldWidget.controller!.message);
    } else if (widget.controller != null && oldWidget.controller == null) {
      if (_restorableController != null) {
        unregisterFromRestoration(_restorableController!);
        _restorableController!.dispose();
        _restorableController = null;
      }
      _initController();
    }

    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _effectiveController.inputController.focusNode).removeListener(_focusNodeListener);
      _effectiveFocusNode.addListener(_focusNodeListener);
    }
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    if (_restorableController != null) {
      _registerController();
    }
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void deactivate() {
    _effectiveController
      ..detach()
      ..removeListener(_onControllerChanged);
    super.deactivate();
  }

  @override
  void dispose() {
    _pickerAnimation.dispose();
    _pickerAnimationController.dispose();
    _stopPickerSync();
    _disposePickerController();
    _effectiveFocusNode.removeListener(_focusNodeListener);
    _restorableController?.dispose();
    if (widget.audioRecorderController == null) {
      _audioRecorderController.dispose();
    }
    super.dispose();
  }

  // ---- Focus listener ----

  void _focusNodeListener() {
    if (_effectiveFocusNode.hasFocus && _isPickerVisible) {
      _hidePicker();
    }
  }

  // ---- Key handler ----

  KeyEventResult _handleKeyPressed(FocusNode node, KeyEvent event) {
    if (widget.sendMessageKeyPredicate(node, event)) {
      _sendMessage();
      return KeyEventResult.handled;
    }
    if (widget.clearQuotedMessageKeyPredicate(node, event)) {
      final hasQuote = _effectiveController.message.quotedMessage != null;
      if (hasQuote && _effectiveController.text.isEmpty) {
        _effectiveController.clearQuotedMessage();
        widget.onQuotedMessageCleared?.call();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    return KeyEventResult.ignored;
  }

  // ---- Build ----

  @override
  Widget build(BuildContext context) {
    bool canSendOrUpdateMessage(List<ChannelCapability> capabilities) {
      final ownCaps = capabilities.cast<String>().toSet();
      return _effectiveController.canSendOrUpdate(
        ownCaps,
        inThread: _effectiveController.message.parentId != null,
      );
    }

    final channel = StreamChannel.of(context).channel;
    final messageInput = switch (_buildAutocompleteMessageInput(context)) {
      final input when channel.state != null => BetterStreamBuilder(
        stream: channel.ownCapabilitiesStream.map(canSendOrUpdateMessage),
        initialData: canSendOrUpdateMessage(channel.ownCapabilities),
        builder: (context, enabled) {
          if (enabled) return input;
          return _buildNoPermissionMessage(context);
        },
      ),
      final input => input,
    };

    final spacing = context.streamSpacing;
    final safeAreaEnabled = widget.enableSafeArea ?? true;
    final viewPadding = MediaQuery.paddingOf(context);

    return Material(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.streamColorScheme.backgroundElevation1,
        ),
        child: AnimatedBuilder(
          animation: _pickerAnimation,
          builder: (context, child) {
            final safeAreaPadding = safeAreaEnabled
                ? EdgeInsets.lerp(
                    EdgeInsets.only(
                      left: viewPadding.left,
                      top: viewPadding.top,
                      right: viewPadding.right,
                      bottom: math.max(viewPadding.bottom, spacing.md),
                    ),
                    EdgeInsets.zero,
                    _pickerAnimation.value,
                  )!
                : EdgeInsets.zero;
            return Padding(padding: safeAreaPadding, child: child);
          },
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
          trigger: '/',
          triggerOnlyAtStart: true,
          optionsViewBuilder: (context, autocompleteQuery, messageEditingController) {
            return StreamCommandAutocompleteOptions(
              query: autocompleteQuery.query,
              channel: StreamChannel.of(context).channel,
              onCommandSelected: (command) {
                _effectiveController.command = command.name;
                StreamAutocomplete.of(context).closeSuggestions();
              },
            );
          },
        ),
        if (widget.enableMentionsOverlay)
          StreamAutocompleteTrigger(
            trigger: '@',
            optionsViewBuilder: (context, autocompleteQuery, messageEditingController) {
              return StreamMentionAutocompleteOptions(
                query: autocompleteQuery.query,
                channel: StreamChannel.of(context).channel,
                mentionAllAppUsers: widget.mentionAllAppUsers,
                mentionsTileBuilder: widget.userMentionsTileBuilder,
                onMentionUserTap: (user) {
                  _effectiveController.addMentionedUser(user);
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
    StreamMessageComposerController controller,
    FocusNode focusNode,
  ) {
    final currentUserId = StreamChat.of(context).currentUser?.id;

    return StreamMessageValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) => PopScope(
        canPop: !_isPickerVisible,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _hidePicker();
        },
        child: Column(
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
                child: _buildComposerWithRecording(controller, currentUserId, focusNode),
              ),
            ),
            SizeTransition(
              sizeFactor: _pickerAnimation,
              axisAlignment: -1,
              child: _buildInlineAttachmentPicker(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComposerWithRecording(
    StreamMessageComposerController controller,
    String? currentUserId,
    FocusNode focusNode,
  ) {
    final audioController = widget.enableVoiceRecording ? _effectiveAudioRecorderController : null;
    if (audioController == null) {
      return DefaultStreamChatMessageComposer(
        props: _buildComponentProps(controller, currentUserId, focusNode, const RecordStateIdle()),
        inputController: controller,
        isFloating: widget.isFloating,
        placeholder: _getHint(context) ?? '',
      );
    }

    return ValueListenableBuilder(
      valueListenable: audioController,
      builder: (context, state, _) {
        final body = switch (state) {
          RecordStateRecordingLocked() => MessageComposerRecordingLocked(
            audioRecorderController: audioController,
            feedback: widget.voiceRecordingFeedback,
            messageInputController: controller,
            sendMessageCallback: widget.sendVoiceRecordingAutomatically ? _sendMessage : null,
            state: state,
          ),
          RecordStateStopped() => MessageComposerRecordingStopped(
            audioRecorderController: audioController,
            feedback: widget.voiceRecordingFeedback,
            messageInputController: controller,
            sendMessageCallback: widget.sendVoiceRecordingAutomatically ? _sendMessage : null,
            recordingState: state,
          ),
          RecordStateRecording() => StreamMessageComposerRecordingOngoing(
            audioRecorderController: audioController,
          ),
          _ => null,
        };

        final streamSpacing = context.streamSpacing;
        final textDirection = Directionality.maybeOf(context);

        const targetAlignment = AlignmentDirectional.topEnd;
        const followerAlignment = AlignmentDirectional.bottomEnd;

        return PortalTarget(
          anchor: Aligned(
            target: targetAlignment.resolve(textDirection),
            follower: followerAlignment.resolve(textDirection),
            offset: Offset(-streamSpacing.md, -streamSpacing.md).directional(textDirection),
          ),
          visible: state is RecordStateRecording,
          portalFollower: SwipeToLockButton(isLocked: state is RecordStateRecordingLocked),
          child: DefaultStreamChatMessageComposer(
            props: _buildComponentProps(controller, currentUserId, focusNode, state),
            inputController: controller,
            isFloating: widget.isFloating,
            placeholder: _getHint(context) ?? '',
            audioRecorderState: state,
            body: body,
          ),
        );
      },
    );
  }

  MessageComposerComponentProps _buildComponentProps(
    StreamMessageComposerController controller,
    String? currentUserId,
    FocusNode focusNode,
    AudioRecorderState audioRecorderState,
  ) {
    return MessageComposerComponentProps(
      controller: controller,
      isFloating: widget.isFloating,
      message: controller.message,
      currentUserId: currentUserId,
      onSendPressed: _sendMessage,
      voiceRecordingCallback: _createVoiceRecordingCallback(context),
      onAttachmentButtonPressed: widget.disableAttachments ? null : _onAttachmentButtonPressed,
      isPickerOpen: _isPickerVisible,
      audioRecorderState: audioRecorderState,
      focusNode: focusNode,
      onQuotedMessageCleared: () {
        _effectiveController.clearQuotedMessage();
        widget.onQuotedMessageCleared?.call();
      },
      canAlsoSendToChannel: _shouldShowSendToChannelCheckbox(),
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      autofocus: widget.autofocus,
      autocorrect: widget.autoCorrect,
    );
  }

  // ---- Inline picker ----

  Widget _buildInlineAttachmentPicker(BuildContext context) {
    if (!_isPickerVisible) return const SizedBox.shrink();

    final allowedTypes = _getAllowedAttachmentPickerTypes();

    final isWebOrDesktop = switch (CurrentPlatform.type) {
      PlatformType.android || PlatformType.ios => false,
      _ => true,
    };
    final useSystemPicker = widget.useSystemAttachmentPicker || isWebOrDesktop;

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
    _effectiveFocusNode.requestFocus();
  }

  bool _shouldShowSendToChannelCheckbox() {
    if (!widget.canAlsoSendToChannelFromThread) return false;
    return _effectiveController.message.parentId != null;
  }

  Widget _buildNoPermissionMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Text(
        context.translations.sendMessagePermissionError,
        style: context.streamTextInputTheme.style?.textStyle,
      ),
    );
  }

  Future<void> _onPollCreated(Poll poll) async {
    _hidePicker();
    final channel = StreamChannel.maybeOf(context)?.channel;
    if (channel == null) return;
    return channel.sendPoll(poll).ignore();
  }

  List<AttachmentPickerType> _getAllowedAttachmentPickerTypes() {
    return widget.allowedAttachmentPickerTypes.where((type) {
      if (type != AttachmentPickerType.poll) return true;
      if (_effectiveController.isEditing) return false;
      if (_effectiveController.message.parentId != null) return false;
      final channel = StreamChannel.of(context).channel;
      return channel.config?.polls == true && channel.canSendPoll;
    }).toList(growable: false);
  }

  void _onAttachmentButtonPressed() => _isPickerVisible ? _hidePicker() : _showPicker();

  void _showPicker() {
    if (_isPickerVisible) {
      _pickerAnimationController.forward();
      return;
    }

    setState(() {
      _pickerController = StreamAttachmentPickerController(
        initialAttachments: _effectiveController.attachments,
        initialPoll: _effectiveController.poll,
        maxAttachmentCount: widget.attachmentLimit,
        maxAttachmentSize: widget.maxAttachmentSize,
      );
      _startPickerSync();
      if (_effectiveFocusNode.hasFocus) {
        _effectiveFocusNode.unfocus();
      }
    });

    _pickerAnimationController.forward();
  }

  void _hidePicker() {
    if (!_isPickerVisible) return;

    _stopPickerSync();
    _pickerAnimationController.reverse().then((_) {
      if (mounted) setState(_disposePickerController);
    });
  }

  void _startPickerSync() {
    _pickerController?.addListener(_syncPickerToMessage);
    _effectiveController.addListener(_syncMessageToPicker);
    _customResultSubscription = _pickerController?.customResults.listen(_onCustomResult);
  }

  void _stopPickerSync() {
    _customResultSubscription?.cancel();
    _customResultSubscription = null;
    _pickerController?.removeListener(_syncPickerToMessage);
    _effectiveController.removeListener(_syncMessageToPicker);
  }

  void _disposePickerController() {
    _pickerController?.dispose();
    _pickerController = null;
  }

  Future<void> _onCustomResult(CustomAttachmentPickerResult result) async {
    final handled = await widget.onAttachmentPickerResult?.call(result) ?? false;
    if (handled && mounted) _hidePicker();
  }

  void _syncPickerToMessage() {
    if (_isSyncingControllers) return;
    _isSyncingControllers = true;
    try {
      _effectiveController.attachments = _pickerController?.value.attachments ?? [];
    } finally {
      _isSyncingControllers = false;
    }
  }

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

  // ---- Hint text ----

  String? _getHint(BuildContext context) {
    final HintType hintType;
    if (_effectiveController.message.command == 'giphy') {
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

  // ---- Attachments from drag-drop ----

  void _addAttachments(Iterable<Attachment> attachments) {
    if (widget.attachmentLimit case final limit?) {
      final total = _effectiveController.attachments.length + attachments.length;
      if (total > limit) {
        final onExceed = widget.onAttachmentLimitExceed;
        if (onExceed != null) {
          return onExceed(limit, context.translations.attachmentLimitExceedError(limit));
        }
        return _showErrorAlert(context.translations.attachmentLimitExceedError(limit));
      }
    }
    for (final attachment in attachments) {
      _effectiveController.addAttachment(attachment);
    }
  }

  // ---- Send ----

  Future<void> _sendMessage() async {
    _hidePicker();

    final commandWasActive = _effectiveController.message.command != null;

    await _effectiveController.sendMessage(
      preMessageSending: widget.preMessageSending,
      validator: widget.validator,
      onMessageSent: widget.onMessageSent,
      onError: widget.onError,
      onLinkDisabled: () => _showLinkDisabledDialog(context),
      onQuotedMessageCleared: widget.onQuotedMessageCleared,
    );

    if (mounted) {
      if (widget.shouldKeepFocusAfterMessage ?? !commandWasActive) {
        FocusScope.of(context).requestFocus(_effectiveFocusNode);
      } else {
        FocusScope.of(context).unfocus();
      }
    }
  }

  void _showLinkDisabledDialog(BuildContext context) {
    showInfoBottomSheet(
      context,
      icon: Icon(
        context.streamIcons.exclamationCircleFill,
        color: _streamChatTheme.colorTheme.accentError,
        size: 24,
      ),
      title: context.translations.linkDisabledError,
      details: context.translations.linkDisabledDetails,
      okText: context.translations.okLabel,
    );
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

  // ---- Voice recording helpers ----

  core.VoiceRecordingCallback? _createVoiceRecordingCallback(BuildContext context) {
    if (!widget.enableVoiceRecording) return null;
    final audioRecorderController = _effectiveAudioRecorderController;

    return core.VoiceRecordingCallback(
      onLongPressStart: () async {
        if (audioRecorderController.isRecording) return;
        await widget.voiceRecordingFeedback.onRecordStart(context);
        return audioRecorderController.startRecord();
      },
      onLongPressEnd: (_) async {
        if (!audioRecorderController.isRecording || audioRecorderController.isLocked) return;
        await widget.voiceRecordingFeedback.onRecordFinish(context);
        final audio = await audioRecorderController.finishRecord();
        if (audio != null) {
          _effectiveController.addAttachment(audio);
        }
        audioRecorderController.cancelRecord(discardTrack: false);
        if (widget.sendVoiceRecordingAutomatically) {
          return _sendMessage();
        }
      },
      onLongPressCancel: () async {
        if (audioRecorderController.isRecording) return;
        await widget.voiceRecordingFeedback.onRecordStartCancel(context);
        audioRecorderController.showInfo(context.translations.holdToRecordLabel);
      },
      onLongPressMoveUpdate: (details) async {
        if (!audioRecorderController.isRecording || audioRecorderController.isLocked) return;
        final dragOffset = details.offsetFromOrigin;
        if (dragOffset.dy <= -50) {
          await widget.voiceRecordingFeedback.onRecordLock(context);
          return audioRecorderController.lockRecord();
        }
        if (dragOffset.dx <= -75) {
          await widget.voiceRecordingFeedback.onRecordCancel(context);
          return audioRecorderController.cancelRecord();
        }
        return audioRecorderController.dragRecord(dragOffset);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Props class — internal plumbing for sub-components
// ---------------------------------------------------------------------------

/// Properties to build the main message composer component.
class MessageComposerProps {
  /// Creates a new instance of [MessageComposerProps].
  const MessageComposerProps({
    this.controller,
    this.isFloating = false,
    this.message,
    this.placeholder = '',
    this.onSendPressed,
    this.onAttachmentButtonPressed,
    this.isPickerOpen = false,
    this.focusNode,
    this.currentUserId,
    this.audioRecorderController,
    this.sendVoiceRecordingAutomatically = false,
    this.feedback = const AudioRecorderFeedback(),
    this.canAlsoSendToChannel = false,
    this.onQuotedMessageCleared,
    this.textInputAction,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.autofocus = false,
    this.autocorrect = true,
  });

  /// The controller for the message composer.
  final StreamMessageComposerController? controller;

  /// Whether the message composer is floating.
  final bool isFloating;

  /// The message for the message composer.
  final Message? message;

  /// The placeholder text.
  final String placeholder;

  /// Called when the send button is pressed.
  final VoidCallback? onSendPressed;

  /// Called when the attachment button is pressed.
  final VoidCallback? onAttachmentButtonPressed;

  /// Whether the inline attachment picker is open.
  final bool isPickerOpen;

  /// Focus node for the text field.
  final FocusNode? focusNode;

  /// The current user id.
  final String? currentUserId;

  /// Audio recorder controller for voice recording.
  final StreamAudioRecorderController? audioRecorderController;

  /// Whether to send voice recordings automatically.
  final bool sendVoiceRecordingAutomatically;

  /// Feedback for audio recorder interactions.
  final AudioRecorderFeedback feedback;

  /// Show "also send to channel" checkbox in threads.
  final bool canAlsoSendToChannel;

  /// Called when the quoted message is cleared.
  final VoidCallback? onQuotedMessageCleared;

  /// Keyboard action button type.
  final TextInputAction? textInputAction;

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Text capitalisation mode.
  final TextCapitalization textCapitalization;

  /// Auto-focus the text field.
  final bool autofocus;

  /// Enable autocorrect.
  final bool autocorrect;
}

extension on StreamAudioRecorderController {
  bool get isRecording => value is RecordStateRecording;
  bool get isLocked => isRecording && value is! RecordStateRecordingHold;
}

// ---------------------------------------------------------------------------
// Default renderer
// ---------------------------------------------------------------------------

/// Default rendering of the composer widget.
///
/// Delegates to [core.StreamCoreMessageComposer] with the chat-specific
/// sub-components wired in.
class DefaultStreamChatMessageComposer extends StatelessWidget {
  /// Creates a [DefaultStreamChatMessageComposer].
  const DefaultStreamChatMessageComposer({
    super.key,
    required this.props,
    required this.inputController,
    required this.isFloating,
    required this.placeholder,
    this.audioRecorderState = const RecordStateIdle(),
    this.body,
  });

  /// The component properties.
  final MessageComposerComponentProps props;

  /// The message composer controller.
  final StreamMessageComposerController inputController;

  /// Whether the composer is in a floating container.
  final bool isFloating;

  /// Placeholder text.
  final String placeholder;

  /// Current audio recorder state.
  final AudioRecorderState audioRecorderState;

  /// Optional override for the input body.
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return core.StreamCoreMessageComposer(
      placeholder: placeholder,
      controller: inputController.inputController.textFieldController,
      isFloating: isFloating,
      focusNode: props.focusNode,
      composerLeading: StreamMessageComposerLeading(props: props),
      composerTrailing: StreamMessageComposerTrailing(props: props),
      inputHeader: StreamMessageComposerInputHeader(props: props),
      inputTrailing: StreamMessageComposerInputTrailing(props: props),
      inputLeading: StreamMessageComposerInputLeading(props: props),
      inputBody:
          body ??
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              core.StreamMessageComposerInputField(
                controller: inputController.inputController.textFieldController,
                placeholder: placeholder,
                focusNode: props.focusNode,
                command: inputController.message.command?.toUpperCase(),
                onDismissCommand: inputController.clearCommand,
                textInputAction: props.textInputAction,
                keyboardType: props.keyboardType,
                textCapitalization: props.textCapitalization,
                autofocus: props.autofocus,
                autocorrect: props.autocorrect,
              ),
              if (props.canAlsoSendToChannel) 
                DmCheckboxListTile(
                  value: props.controller.showInChannel,
                  contentPadding: EdgeInsets.only(
                    right: context.streamSpacing.md,
                    left: context.streamSpacing.md,
                    bottom: context.streamSpacing.md - 8,
                  ),
                  onChanged: (value) => props.controller.showInChannel = value,
                ),
            ],
          ),
    );
  }

}
