import 'dart:async';
import 'dart:math' as math;

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_leading.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_trailing.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// Predicate that determines whether a [KeyEvent] should trigger an action.
typedef KeyEventPredicate = bool Function(FocusNode node, KeyEvent event);

/// A fully self-contained message-composer widget.
///
/// Absorbs all responsibilities of the legacy [StreamMessageInput] widget:
/// send pipeline, draft sync, OG enrichment, attachment picker, voice
/// recording, autocomplete, key handlers, slow-mode cooldown, drag-and-drop,
/// back-press picker dismiss, and state restoration.
///
/// Sub-components can be customised through the [StreamComponentFactory].
class StreamMessageComposer extends StatelessWidget {
  /// Creates a [StreamMessageComposer].
  // ignore: prefer_const_constructors_in_immutables
  const StreamMessageComposer({
    super.key,
    this.controller,
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
    this.placeholderBuilder = _defaultPlaceholderBuilder,
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
  });

  /// The controller for the message composer.
  ///
  /// When not provided, a controller is created and owned internally.
  final StreamMessageComposerController? controller;

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

  /// Resolves the placeholder text shown inside the input field.
  ///
  /// Receives the current [MessageInputPlaceholder] state (resolved from the
  /// active [StreamMessageComposerController]) and returns the string to display.
  /// Override this callback to provide custom placeholders for
  /// backend-defined commands or any other input state — pattern-match
  /// exhaustively over the sealed [MessageInputPlaceholder] cases:
  ///
  /// ```dart
  /// placeholderBuilder: (context, placeholder) {
  ///   final translations = context.translations;
  ///   return switch (placeholder) {
  ///     SlowModePlaceholder() => translations.slowModeOnLabel,
  ///     CommandPlaceholder(command: 'weather') => 'Type a city name',
  ///     CommandPlaceholder() => translations.writeAMessageLabel,
  ///     AttachmentsPlaceholder() => translations.addACommentOrSendLabel,
  ///     WriteMessagePlaceholder() => translations.writeAMessageLabel,
  ///   };
  /// }
  /// ```
  final MessageInputPlaceholderBuilder placeholderBuilder;

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

  static bool _defaultSendMessageKeyPredicate(FocusNode node, KeyEvent event) {
    if (CurrentPlatform.isAndroid || CurrentPlatform.isIos) return false;
    if (HardwareKeyboard.instance.isShiftPressed) return false;
    return event.logicalKey == LogicalKeyboardKey.enter && event is KeyDownEvent;
  }

  static bool _defaultClearQuotedMessageKeyPredicate(FocusNode node, KeyEvent event) {
    if (CurrentPlatform.isAndroid || CurrentPlatform.isIos) return false;
    return event.logicalKey == LogicalKeyboardKey.escape && event is KeyDownEvent;
  }

  static String? _defaultPlaceholderBuilder(
    BuildContext context,
    MessageInputPlaceholder placeholder,
  ) {
    final translations = context.translations;
    return switch (placeholder) {
      SlowModePlaceholder() => translations.slowModeOnLabel,
      CommandPlaceholder(command: 'giphy') => translations.searchGifLabel,
      CommandPlaceholder(command: 'mute' || 'unmute' || 'ban' || 'unban') => translations.commandUsernameLabel,
      CommandPlaceholder() || AttachmentsPlaceholder() || WriteMessagePlaceholder() => translations.writeAMessageLabel,
    };
  }

  static bool _defaultOgPreviewFilter(Uri matchedUri, String messageText) => true;

  @override
  Widget build(BuildContext context) {
    final props = MessageComposerProps.from(this);
    return context.chatComponentBuilder<MessageComposerProps>()?.call(context, props) ??
        DefaultStreamMessageComposer(props: props);
  }
}

// ---------------------------------------------------------------------------
// MessageComposerProps — comprehensive public props for whole-composer customisation
// ---------------------------------------------------------------------------

/// Properties for building the whole message composer component.
///
/// Used by the [MessageComposerProps] factory builder in [StreamComponentFactory],
/// and taken by [DefaultStreamMessageComposer] as its configuration.
class MessageComposerProps {
  /// Creates a new instance of [MessageComposerProps].
  MessageComposerProps({
    this.controller,
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
    this.ogPreviewFilter = StreamMessageComposer._defaultOgPreviewFilter,
    this.placeholderBuilder = StreamMessageComposer._defaultPlaceholderBuilder,
    this.useSystemAttachmentPicker = false,
    this.pollConfig,
    this.attachmentPickerOptionsBuilder,
    this.onAttachmentPickerResult,
    this.sendMessageKeyPredicate = StreamMessageComposer._defaultSendMessageKeyPredicate,
    this.clearQuotedMessageKeyPredicate = StreamMessageComposer._defaultClearQuotedMessageKeyPredicate,
    this.textInputAction,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.autofocus = false,
    this.autoCorrect = true,
    this.isFloating = false,
    this.audioRecorderController,
  });

  /// Creates a [MessageComposerProps] from a [StreamMessageComposer] widget.
  factory MessageComposerProps.from(StreamMessageComposer widget) => MessageComposerProps(
    controller: widget.controller,
    onMessageSent: widget.onMessageSent,
    preMessageSending: widget.preMessageSending,
    focusNode: widget.focusNode,
    disableAttachments: widget.disableAttachments,
    maxAttachmentSize: widget.maxAttachmentSize,
    canAlsoSendToChannelFromThread: widget.canAlsoSendToChannelFromThread,
    enableVoiceRecording: widget.enableVoiceRecording,
    sendVoiceRecordingAutomatically: widget.sendVoiceRecordingAutomatically,
    voiceRecordingFeedback: widget.voiceRecordingFeedback,
    userMentionsTileBuilder: widget.userMentionsTileBuilder,
    onError: widget.onError,
    attachmentLimit: widget.attachmentLimit,
    allowedAttachmentPickerTypes: widget.allowedAttachmentPickerTypes,
    onAttachmentLimitExceed: widget.onAttachmentLimitExceed,
    customAutocompleteTriggers: widget.customAutocompleteTriggers,
    mentionAllAppUsers: widget.mentionAllAppUsers,
    shouldKeepFocusAfterMessage: widget.shouldKeepFocusAfterMessage,
    validator: widget.validator,
    restorationId: widget.restorationId,
    enableSafeArea: widget.enableSafeArea,
    enableMentionsOverlay: widget.enableMentionsOverlay,
    onQuotedMessageCleared: widget.onQuotedMessageCleared,
    ogPreviewFilter: widget.ogPreviewFilter,
    placeholderBuilder: widget.placeholderBuilder,
    useSystemAttachmentPicker: widget.useSystemAttachmentPicker,
    pollConfig: widget.pollConfig,
    attachmentPickerOptionsBuilder: widget.attachmentPickerOptionsBuilder,
    onAttachmentPickerResult: widget.onAttachmentPickerResult,
    sendMessageKeyPredicate: widget.sendMessageKeyPredicate,
    clearQuotedMessageKeyPredicate: widget.clearQuotedMessageKeyPredicate,
    textInputAction: widget.textInputAction,
    keyboardType: widget.keyboardType,
    textCapitalization: widget.textCapitalization,
    autofocus: widget.autofocus,
    autoCorrect: widget.autoCorrect,
    isFloating: widget.isFloating,
    audioRecorderController: widget.audioRecorderController,
  );

  /// The controller for the message composer.
  final StreamMessageComposerController? controller;

  /// Called after a message is sent successfully.
  final void Function(Message)? onMessageSent;

  /// Called right before sending; can transform the message.
  final FutureOr<Message> Function(Message)? preMessageSending;

  /// Focus node for the text field.
  final FocusNode? focusNode;

  /// When true, the attachment button is hidden.
  final bool disableAttachments;

  /// Maximum attachment size in bytes.
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

  /// Extra autocomplete triggers.
  final Iterable<StreamAutocompleteTrigger> customAutocompleteTriggers;

  /// Search all app users for @-mentions.
  final bool mentionAllAppUsers;

  /// Keep keyboard focus after sending a message.
  final bool? shouldKeepFocusAfterMessage;

  /// Custom message validator.
  final MessageValidator? validator;

  /// Restoration ID for state persistence.
  final String? restorationId;

  /// Wrap the composer in [SafeArea].
  final bool? enableSafeArea;

  /// Disable the @-mention overlay.
  final bool enableMentionsOverlay;

  /// Called when the quoted message is cleared.
  final VoidCallback? onQuotedMessageCleared;

  /// Filter determining whether a URL should show an OG preview.
  final OgPreviewFilter ogPreviewFilter;

  /// Resolves the placeholder text shown inside the input field.
  ///
  /// See [StreamMessageComposer.placeholderBuilder].
  final MessageInputPlaceholderBuilder placeholderBuilder;

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
  final StreamAudioRecorderController? audioRecorderController;
}

// ---------------------------------------------------------------------------
// DefaultStreamMessageComposer — full implementation
// ---------------------------------------------------------------------------

/// Default rendering of the composer widget.
///
/// Contains all state and logic: restoration, controller attach/detach, focus
/// management, attachment picker, autocomplete, drag-and-drop, key handlers,
/// send pipeline, hint resolution, and audio-recorder lifecycle.
///
/// Can be used directly when constructing a custom [MessageComposerProps]
/// builder in [StreamComponentFactory].
class DefaultStreamMessageComposer extends StatefulWidget {
  /// Creates a [DefaultStreamMessageComposer].
  const DefaultStreamMessageComposer({super.key, required this.props});

  /// The configuration for this composer.
  final MessageComposerProps props;

  @override
  State<DefaultStreamMessageComposer> createState() => _DefaultStreamMessageComposerState();
}

class _DefaultStreamMessageComposerState extends State<DefaultStreamMessageComposer>
    with RestorationMixin<DefaultStreamMessageComposer>, SingleTickerProviderStateMixin {
  // ---- Controller ----

  StreamMessageComposerController get _effectiveController => widget.props.controller ?? _restorableController!.value;

  StreamRestorableMessageComposerController? _restorableController;

  void _createLocalController([Message? message]) {
    assert(_restorableController == null, '');
    _restorableController = StreamRestorableMessageComposerController(message: message);
  }

  void _registerController() {
    assert(_restorableController != null, '');
    registerForRestoration(_restorableController!, 'messageComposerController');
    _initController();
    // Add the focus listener here since _effectiveController.value is only
    // accessible after the restorable has been registered.
    _effectiveFocusNode.addListener(_focusNodeListener);
  }

  String? _prevQuotedMessageId;

  void _initController() {
    _prevQuotedMessageId = _effectiveController.message.quotedMessageId;
    _effectiveController
      ..addListener(_onControllerChanged)
      ..attach(
        StreamChannel.of(context),
        draftMessagesEnabled: StreamChatConfiguration.of(context).draftMessagesEnabled,
        ogPreviewFilter: (uri, text) => widget.props.ogPreviewFilter.call(uri, text),
        onError: widget.props.onError,
      );
  }

  /// Notifies [MessageComposerProps.onQuotedMessageCleared] when the controller
  /// clears the quoted message externally (e.g. the quoted message was deleted).
  void _onControllerChanged() {
    final current = _effectiveController.message.quotedMessageId;
    if (_prevQuotedMessageId != null && current == null) {
      widget.props.onQuotedMessageCleared?.call();
    }
    _prevQuotedMessageId = current;
  }

  // ---- Focus ----

  FocusNode get _effectiveFocusNode => widget.props.focusNode ?? _effectiveController.focusNode;

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
      widget.props.audioRecorderController ?? _audioRecorderController;

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

    if (widget.props.controller == null) {
      _createLocalController();
      // Focus listener and controller init happen later in _registerController,
      // which is called from restoreState — after the restorable is registered.
    } else {
      _effectiveFocusNode.addListener(_focusNodeListener);
      WidgetsBinding.instance.endOfFrame.then((_) {
        if (mounted) _initController();
      });
    }
  }

  @override
  void didChangeDependencies() {
    _streamChatTheme = StreamChatTheme.of(context);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant DefaultStreamMessageComposer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.props.controller == null && oldWidget.props.controller != null) {
      _createLocalController(oldWidget.props.controller!.message);
    } else if (widget.props.controller != null && oldWidget.props.controller == null) {
      if (_restorableController != null) {
        unregisterFromRestoration(_restorableController!);
        _restorableController!.dispose();
        _restorableController = null;
      }
      _initController();
    }

    if (widget.props.focusNode != oldWidget.props.focusNode) {
      (oldWidget.props.focusNode ?? _effectiveController.focusNode).removeListener(_focusNodeListener);
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
  String? get restorationId => widget.props.restorationId;

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
    if (widget.props.audioRecorderController == null) {
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
    if (widget.props.sendMessageKeyPredicate(node, event)) {
      _sendMessage();
      return KeyEventResult.handled;
    }
    if (widget.props.clearQuotedMessageKeyPredicate(node, event)) {
      final hasQuote = _effectiveController.message.quotedMessage != null;
      if (hasQuote && _effectiveController.text.isEmpty) {
        _effectiveController.clearQuotedMessage();
        widget.props.onQuotedMessageCleared?.call();
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
    final safeAreaEnabled = widget.props.enableSafeArea ?? true;
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
        ...widget.props.customAutocompleteTriggers,
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
        if (widget.props.enableMentionsOverlay)
          StreamAutocompleteTrigger(
            trigger: '@',
            optionsViewBuilder: (context, autocompleteQuery, messageEditingController) {
              return StreamMentionAutocompleteOptions(
                query: autocompleteQuery.query,
                channel: StreamChannel.of(context).channel,
                mentionAllAppUsers: widget.props.mentionAllAppUsers,
                mentionsTileBuilder: widget.props.userMentionsTileBuilder,
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
                child: _buildComposerRow(context, controller, currentUserId, focusNode),
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

  Widget _buildComposerRow(
    BuildContext context,
    StreamMessageComposerController controller,
    String? currentUserId,
    FocusNode focusNode,
  ) {
    final audioController = widget.props.enableVoiceRecording ? _effectiveAudioRecorderController : null;

    if (audioController == null) {
      final componentProps = _buildComponentProps(
        context,
        controller,
        currentUserId,
        focusNode,
        const RecordStateIdle(),
      );
      return _buildRow(context, componentProps);
    }

    return ValueListenableBuilder(
      valueListenable: audioController,
      builder: (context, state, _) {
        final componentProps = _buildComponentProps(context, controller, currentUserId, focusNode, state);

        final streamSpacing = context.streamSpacing;
        final textDirection = Directionality.maybeOf(context);

        const targetAlignment = AlignmentDirectional.topEnd;
        const followerAlignment = AlignmentDirectional.bottomEnd;

        final idleMessage = state is RecordStateIdle ? state.message : null;
        final showIdleTooltip = idleMessage != null && idleMessage.isNotEmpty;

        return PortalTarget(
          visible: showIdleTooltip,
          anchor: Aligned(
            target: Alignment.topCenter,
            follower: Alignment.bottomCenter,
            offset: Offset(0, -streamSpacing.md),
          ),
          portalFollower: showIdleTooltip ? HoldToRecordInfoTooltip(message: idleMessage) : const SizedBox.shrink(),
          child: PortalTarget(
            anchor: Aligned(
              target: targetAlignment.resolve(textDirection),
              follower: followerAlignment.resolve(textDirection),
              offset: Offset(-streamSpacing.md, -streamSpacing.md).directional(textDirection),
            ),
            visible: state is RecordStateRecording,
            portalFollower: SwipeToLockButton(isLocked: state is RecordStateRecordingLocked),
            child: _buildRow(context, componentProps),
          ),
        );
      },
    );
  }

  Widget _buildRow(BuildContext context, MessageComposerComponentProps componentProps) {
    final spacing = context.streamSpacing;
    return Container(
      padding: EdgeInsets.only(top: spacing.md),
      decoration: widget.props.isFloating
          ? null
          : BoxDecoration(
              border: Border(
                top: BorderSide(color: context.streamColorScheme.borderDefault),
              ),
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: spacing.md),
          StreamMessageComposerLeading(props: componentProps),
          Expanded(child: StreamMessageComposerInput(props: componentProps)),
          StreamMessageComposerTrailing(props: componentProps),
          SizedBox(width: spacing.md),
        ],
      ),
    );
  }

  MessageComposerComponentProps _buildComponentProps(
    BuildContext context,
    StreamMessageComposerController controller,
    String? currentUserId,
    FocusNode focusNode,
    AudioRecorderState audioRecorderState,
  ) {
    return MessageComposerComponentProps(
      controller: controller,
      isFloating: widget.props.isFloating,
      message: controller.message,
      currentUserId: currentUserId,
      onSendPressed: _sendMessage,
      voiceRecordingCallback: _createVoiceRecordingCallback(context),
      onAttachmentButtonPressed: widget.props.disableAttachments ? null : _onAttachmentButtonPressed,
      isPickerOpen: _isPickerVisible,
      audioRecorderState: audioRecorderState,
      focusNode: focusNode,
      onQuotedMessageCleared: () {
        _effectiveController.clearQuotedMessage();
        widget.props.onQuotedMessageCleared?.call();
      },
      canAlsoSendToChannel: _shouldShowSendToChannelCheckbox(),
      textInputAction: widget.props.textInputAction,
      keyboardType: widget.props.keyboardType,
      textCapitalization: widget.props.textCapitalization,
      autofocus: widget.props.autofocus,
      autocorrect: widget.props.autoCorrect,
      audioRecorderController: widget.props.enableVoiceRecording ? _effectiveAudioRecorderController : null,
      voiceRecordingFeedback: widget.props.voiceRecordingFeedback,
      sendVoiceRecordingAutomatically: widget.props.sendVoiceRecordingAutomatically,
      placeholder: _buildPlaceholder(context),
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
    final useSystemPicker = widget.props.useSystemAttachmentPicker || isWebOrDesktop;

    final child = useSystemPicker
        ? systemAttachmentPickerBuilder(
            context: context,
            controller: _pickerController!,
            allowedTypes: allowedTypes,
            pollConfig: widget.props.pollConfig,
            optionsBuilder: widget.props.attachmentPickerOptionsBuilder,
            onError: _onPickerError,
            onPollCreated: _onPollCreated,
          )
        : tabbedAttachmentPickerBuilder(
            context: context,
            controller: _pickerController!,
            allowedTypes: allowedTypes,
            pollConfig: widget.props.pollConfig,
            optionsBuilder: widget.props.attachmentPickerOptionsBuilder,
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
    if (!widget.props.canAlsoSendToChannelFromThread) return false;
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
    return widget.props.allowedAttachmentPickerTypes
        .where((type) {
          if (type != AttachmentPickerType.poll) return true;
          if (_effectiveController.isEditing) return false;
          if (_effectiveController.message.parentId != null) return false;
          final channel = StreamChannel.of(context).channel;
          return channel.config?.polls == true && channel.canSendPoll;
        })
        .toList(growable: false);
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
        maxAttachmentCount: widget.props.attachmentLimit,
        maxAttachmentSize: widget.props.maxAttachmentSize,
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
    final handled = await widget.props.onAttachmentPickerResult?.call(result) ?? false;
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

    final messageAttachments = _effectiveController.attachments;
    final messageIds = messageAttachments.map((a) => a.id).toSet();
    final pickerIds = pickerController.value.attachments.map((a) => a.id).toSet();

    final removedIds = pickerIds.difference(messageIds);
    final addedIds = messageIds.difference(pickerIds);

    if (removedIds.isEmpty && addedIds.isEmpty) return;

    final addedAttachments = messageAttachments.where((a) => addedIds.contains(a.id)).toList();

    _isSyncingControllers = true;
    try {
      for (final id in removedIds) {
        pickerController.removeAttachmentById(id);
      }
      for (final attachment in addedAttachments) {
        pickerController.addAttachment(attachment);
      }
    } finally {
      _isSyncingControllers = false;
    }
  }

  void _onPickerError(AttachmentPickerError error) {
    widget.props.onError?.call(error.error, error.stackTrace);
  }

  // ---- Placeholder text ----

  String? _buildPlaceholder(BuildContext context) {
    final state = MessageInputPlaceholder.resolve(_effectiveController);
    return widget.props.placeholderBuilder.call(context, state);
  }

  // ---- Attachments from drag-drop ----

  void _addAttachments(Iterable<Attachment> attachments) {
    if (widget.props.attachmentLimit case final limit?) {
      final total = _effectiveController.attachments.length + attachments.length;
      if (total > limit) {
        final onExceed = widget.props.onAttachmentLimitExceed;
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
      preMessageSending: widget.props.preMessageSending,
      validator: widget.props.validator,
      onMessageSent: widget.props.onMessageSent,
      onError: widget.props.onError,
      onLinkDisabled: () => _showLinkDisabledDialog(context),
      onQuotedMessageCleared: widget.props.onQuotedMessageCleared,
    );

    if (mounted) {
      if (widget.props.shouldKeepFocusAfterMessage ?? !commandWasActive) {
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
    if (!widget.props.enableVoiceRecording) return null;
    final audioRecorderController = _effectiveAudioRecorderController;

    return core.VoiceRecordingCallback(
      onLongPressStart: () async {
        if (audioRecorderController.isRecording) return;
        await widget.props.voiceRecordingFeedback.onRecordStart(context);
        return audioRecorderController.startRecord();
      },
      onLongPressEnd: (_) async {
        if (!audioRecorderController.isRecording || audioRecorderController.isLocked) return;
        await widget.props.voiceRecordingFeedback.onRecordFinish(context);
        final audio = await audioRecorderController.finishRecord();
        if (audio != null) {
          _effectiveController.addAttachment(audio);
        }
        audioRecorderController.cancelRecord(discardTrack: false);
        if (widget.props.sendVoiceRecordingAutomatically) {
          return _sendMessage();
        }
      },
      onLongPressCancel: () async {
        if (audioRecorderController.isRecording) return;
        await widget.props.voiceRecordingFeedback.onRecordStartCancel(context);
        audioRecorderController.showInfo(context.translations.holdToRecordLabel);
      },
      onLongPressMoveUpdate: (details) async {
        if (!audioRecorderController.isRecording || audioRecorderController.isLocked) return;
        final dragOffset = details.offsetFromOrigin;
        if (dragOffset.dy <= -50) {
          await widget.props.voiceRecordingFeedback.onRecordLock(context);
          return audioRecorderController.lockRecord();
        }
        if (dragOffset.dx <= -75) {
          await widget.props.voiceRecordingFeedback.onRecordCancel(context);
          return audioRecorderController.cancelRecord();
        }
        return audioRecorderController.dragRecord(dragOffset);
      },
    );
  }
}

extension on StreamAudioRecorderController {
  bool get isRecording => value is RecordStateRecording;
  bool get isLocked => isRecording && value is! RecordStateRecordingHold;
}
