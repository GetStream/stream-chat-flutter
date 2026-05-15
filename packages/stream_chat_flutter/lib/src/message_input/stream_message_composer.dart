import 'dart:async';
import 'dart:math' as math;

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/src/message_input/error_alert_sheet.dart';
import 'package:stream_chat_flutter/src/message_input/stream_chat_message_input.dart';
import 'package:stream_chat_flutter/src/message_input/tld.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

const _kCommandTrigger = '/';
const _kMentionTrigger = '@';

/// Signature for the function that determines if a [matchedUri] should be
/// previewed as an OG Attachment.
typedef OgPreviewFilter = bool Function(Uri matchedUri, String messageText);

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
///             const StreamMessageComposer(),
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
class StreamMessageComposer extends StatelessWidget {
  /// Instantiate a new StreamMessageComposer
  StreamMessageComposer({
    super.key,
    void Function(Message)? onMessageSent,
    FutureOr<Message> Function(Message)? preMessageSending,
    StreamMessageComposerController? messageComposerController,
    FocusNode? focusNode,
    bool disableAttachments = false,
    int maxAttachmentSize = kDefaultMaxAttachmentSize,
    bool canAlsoSendToChannelFromThread = true,
    bool enableVoiceRecording = false,
    bool sendVoiceRecordingAutomatically = false,
    AudioRecorderFeedback voiceRecordingFeedback = const AudioRecorderFeedback(),
    UserMentionTileBuilder? userMentionsTileBuilder,
    ErrorListener? onError,
    int? attachmentLimit,
    List<AttachmentPickerType> allowedAttachmentPickerTypes = AttachmentPickerType.values,
    AttachmentLimitExceedListener? onAttachmentLimitExceed,
    Iterable<StreamAutocompleteTrigger> customAutocompleteTriggers = const [],
    bool mentionAllAppUsers = false,
    bool? shouldKeepFocusAfterMessage,
    MessageValidator validator = MessageComposerProps._defaultValidator,
    String? restorationId,
    bool? enableSafeArea,
    bool enableMentionsOverlay = true,
    VoidCallback? onQuotedMessageCleared,
    OgPreviewFilter ogPreviewFilter = MessageComposerProps._defaultOgPreviewFilter,
    MessageInputPlaceholderBuilder placeholderBuilder = MessageComposerProps._defaultPlaceholderBuilder,
    bool useSystemAttachmentPicker = false,
    PollConfig? pollConfig,
    AttachmentPickerOptionsBuilder? attachmentPickerOptionsBuilder,
    OnAttachmentPickerResult? onAttachmentPickerResult,
    KeyEventPredicate sendMessageKeyPredicate = MessageComposerProps._defaultSendMessageKeyPredicate,
    KeyEventPredicate clearQuotedMessageKeyPredicate = MessageComposerProps._defaultClearQuotedMessageKeyPredicate,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    bool autofocus = false,
    bool autoCorrect = true,
  }) : props = MessageComposerProps(
         onMessageSent: onMessageSent,
         preMessageSending: preMessageSending,
         messageComposerController: messageComposerController,
         focusNode: focusNode,
         disableAttachments: disableAttachments,
         maxAttachmentSize: maxAttachmentSize,
         canAlsoSendToChannelFromThread: canAlsoSendToChannelFromThread,
         enableVoiceRecording: enableVoiceRecording,
         sendVoiceRecordingAutomatically: sendVoiceRecordingAutomatically,
         voiceRecordingFeedback: voiceRecordingFeedback,
         userMentionsTileBuilder: userMentionsTileBuilder,
         onError: onError,
         attachmentLimit: attachmentLimit,
         allowedAttachmentPickerTypes: allowedAttachmentPickerTypes,
         onAttachmentLimitExceed: onAttachmentLimitExceed,
         customAutocompleteTriggers: customAutocompleteTriggers,
         mentionAllAppUsers: mentionAllAppUsers,
         shouldKeepFocusAfterMessage: shouldKeepFocusAfterMessage,
         validator: validator,
         restorationId: restorationId,
         enableSafeArea: enableSafeArea,
         enableMentionsOverlay: enableMentionsOverlay,
         onQuotedMessageCleared: onQuotedMessageCleared,
         ogPreviewFilter: ogPreviewFilter,
         placeholderBuilder: placeholderBuilder,
         useSystemAttachmentPicker: useSystemAttachmentPicker,
         pollConfig: pollConfig,
         attachmentPickerOptionsBuilder: attachmentPickerOptionsBuilder,
         onAttachmentPickerResult: onAttachmentPickerResult,
         sendMessageKeyPredicate: sendMessageKeyPredicate,
         clearQuotedMessageKeyPredicate: clearQuotedMessageKeyPredicate,
         textInputAction: textInputAction,
         keyboardType: keyboardType,
         textCapitalization: textCapitalization,
         autofocus: autofocus,
         autoCorrect: autoCorrect,
       );

  /// Creates a [StreamMessageComposer] from a pre-built [MessageComposerProps].
  ///
  /// Use this constructor when you have already assembled a [MessageComposerProps]
  /// instance and want to avoid re-specifying every field individually.
  const StreamMessageComposer.fromProps({
    super.key,
    required this.props,
  });

  /// The properties for the message composer.
  final MessageComposerProps props;

  @override
  Widget build(BuildContext context) {
    return context.chatComponentBuilder<MessageComposerProps>()?.call(context, props) ??
        DefaultStreamMessageComposer(props: props);
  }
}

/// Properties for [StreamMessageComposer] and [DefaultStreamMessageComposer].
class MessageComposerProps {
  /// Creates a new instance of [MessageComposerProps].
  const MessageComposerProps({
    this.onMessageSent,
    this.preMessageSending,
    this.messageComposerController,
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
  });

  /// Function called after sending the message.
  final void Function(Message)? onMessageSent;

  /// Function called right before sending the message.
  ///
  /// Use this to transform the message.
  final FutureOr<Message> Function(Message)? preMessageSending;

  /// The controller for the message composer.
  final StreamMessageComposerController? messageComposerController;

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
  /// StreamMessageComposer(
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
  /// StreamMessageComposer(
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

  /// List of triggers for showing autocomplete.
  final Iterable<StreamAutocompleteTrigger> customAutocompleteTriggers;

  /// When enabled mentions search users across the entire app.
  ///
  /// Defaults to false.
  final bool mentionAllAppUsers;

  /// Defines if the [StreamMessageComposer] loses focuses after a message is sent.
  /// The default behaviour keeps focus until a command is enabled.
  final bool? shouldKeepFocusAfterMessage;

  /// A callback function that validates the message.
  final MessageValidator validator;

  /// Restoration ID to save and restore the state of the MessageInput.
  final String? restorationId;

  /// Wrap [StreamMessageComposer] with a [SafeArea widget]
  final bool? enableSafeArea;

  /// Disable the mentions overlay by passing false
  /// Enabled by default
  final bool enableMentionsOverlay;

  /// Callback for when the quoted message is cleared
  final VoidCallback? onQuotedMessageCleared;

  /// The filter used to determine if a link should be shown as an OpenGraph
  /// preview.
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

  /// If True, allows you to use the system's default media picker instead of
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
    // Do not handle the event if the user is using a mobile device.
    if (CurrentPlatform.isAndroid || CurrentPlatform.isIos) return false;

    // Do not send the message if the shift key is pressed. Generally, this
    // means the user is trying to add a new line.
    if (HardwareKeyboard.instance.isShiftPressed) return false;

    // Otherwise, send the message when the user presses the enter key.
    return event.logicalKey == .enter && event is KeyDownEvent;
  }

  static bool _defaultClearQuotedMessageKeyPredicate(FocusNode node, KeyEvent event) {
    // Do not handle the event if the user is using a mobile device.
    if (CurrentPlatform.isAndroid || CurrentPlatform.isIos) return false;

    // Otherwise, Clear the quoted message when the user presses the escape key.
    return event.logicalKey == .escape && event is KeyDownEvent;
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
}

/// Default implementation of [StreamMessageComposer].
///
/// Contains the full stateful implementation. To provide a custom composer,
/// register a [StreamComponentBuilder] for [MessageComposerProps] via
/// [StreamComponentFactory] instead of subclassing this widget.
class DefaultStreamMessageComposer extends StatefulWidget {
  /// Creates a new instance of [DefaultStreamMessageComposer].
  const DefaultStreamMessageComposer({super.key, required this.props});

  /// The properties for the message composer.
  final MessageComposerProps props;

  @override
  DefaultStreamMessageComposerState createState() => DefaultStreamMessageComposerState();
}

/// State of [DefaultStreamMessageComposer].
class DefaultStreamMessageComposerState extends State<DefaultStreamMessageComposer>
    with RestorationMixin<DefaultStreamMessageComposer>, SingleTickerProviderStateMixin {
  bool get _commandEnabled => _effectiveController.message.command != null;

  bool get _isPickerVisible => _pickerController != null;
  StreamAttachmentPickerController? _pickerController;
  StreamSubscription<CustomAttachmentPickerResult>? _customResultSubscription;
  bool _isSyncingControllers = false;

  late final AnimationController _pickerAnimationController;
  late final CurvedAnimation _pickerAnimation;

  late StreamChatThemeData _streamChatTheme;

  bool get _isEditing => _effectiveController.isEditing;

  late final _audioRecorderController = StreamAudioRecorderController();

  FocusNode get _effectiveFocusNode => widget.props.focusNode ?? (_focusNode ??= FocusNode());
  FocusNode? _focusNode;

  StreamMessageComposerController get _effectiveController =>
      widget.props.messageComposerController ?? _controller!.value;
  StreamRestorableMessageComposerController? _controller;

  void _createLocalController([Message? message]) {
    assert(_controller == null, '');
    _controller = StreamRestorableMessageComposerController(message: message);
  }

  void _registerController() {
    assert(_controller != null, '');

    registerForRestoration(_controller!, 'messageComposerController');
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
  StreamSubscription<Event>? _messageUpdatedSubscription;
  StreamSubscription<Event>? _messageDeletedSubscription;

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
    if (widget.props.messageComposerController == null) {
      _createLocalController();
    } else {
      _initialiseEffectiveController();
    }
    _effectiveFocusNode.addListener(_focusNodeListener);
    _audioRecorderController.addListener(() {
      if (_audioRecorderController.value is RecordStateRecordingLocked) {
        _hidePicker();
      }
    });

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

    // Keeps the composer in sync with remote message changes.
    _messageUpdatedSubscription = channel.on(EventType.messageUpdated).listen(_onMessageUpdated);
    _messageDeletedSubscription = channel.on(EventType.messageDeleted).listen(_onMessageDeleted);
  }

  void _onMessageUpdated(Event event) {
    final updatedMessage = event.message;
    if (updatedMessage == null) return;

    if (_effectiveController.message.quotedMessageId == updatedMessage.id) {
      _effectiveController.quotedMessage = updatedMessage;
    }

    if (_isEditing && _effectiveController.message.id == updatedMessage.id) {
      _effectiveController.editMessage(updatedMessage);
    }
  }

  void _onMessageDeleted(Event event) {
    final deletedMessageId = event.message?.id;
    if (deletedMessageId == null) return;

    if (_effectiveController.message.quotedMessageId == deletedMessageId) {
      widget.props.onQuotedMessageCleared?.call();
    }

    if (_isEditing && _effectiveController.message.id == deletedMessageId) {
      _effectiveController.cancelEditMessage();
    }
  }

  void _onDraftUpdate(Draft? draft) {
    // Don't let draft changes clobber an in-progress edit.
    if (_isEditing) return;

    // If the draft is removed, reset the controller.
    if (draft == null) return _effectiveController.reset();

    // Otherwise, update the controller with the draft message.
    if (draft.message case final draftMessage) {
      _effectiveController.message = draftMessage
          .copyWith(
            quotedMessage: draftMessage.quotedMessage ?? draft.quotedMessage,
            parentId: draftMessage.parentId ?? draft.parentId,
          )
          .toMessage();
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
    if (widget.props.messageComposerController == null && oldWidget.props.messageComposerController != null) {
      _createLocalController(oldWidget.props.messageComposerController!.message);
    } else if (widget.props.messageComposerController != null && oldWidget.props.messageComposerController == null) {
      unregisterFromRestoration(_controller!);
      _controller!.dispose();
      _controller = null;
      _initialiseEffectiveController();
    } else if (widget.props.messageComposerController != null && oldWidget.props.messageComposerController != null &&
        widget.props.messageComposerController != oldWidget.props.messageComposerController) {
      // External controller instance was swapped — detach all listeners from
      // the old instance and rebind them to the new one.
      oldWidget.props.messageComposerController!
        ..removeListener(_onChangedThrottled)
        ..removeListener(_onChangedDebounced)
        ..removeListener(_syncMessageToPicker);
      _initialiseEffectiveController();
    }

    // Update _focusNode
    if (widget.props.focusNode != oldWidget.props.focusNode) {
      (oldWidget.props.focusNode ?? _focusNode)?.removeListener(_focusNodeListener);
      (widget.props.focusNode ?? _focusNode)?.addListener(_focusNodeListener);
    }
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    if (_controller != null) {
      _registerController();
    }
  }

  @override
  String? get restorationId => widget.props.restorationId;

  void _focusNodeListener() {
    if (_effectiveFocusNode.hasFocus && _isPickerVisible) {
      _hidePicker();
    }
  }

  KeyEventResult _handleKeyPressed(FocusNode node, KeyEvent event) {
    if (widget.props.sendMessageKeyPredicate(node, event)) {
      sendMessage();
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
      messageComposerController: _effectiveController,
      fieldViewBuilder: _buildMessageInput,
      autocompleteTriggers: [
        ...widget.props.customAutocompleteTriggers,
        StreamAutocompleteTrigger(
          trigger: _kCommandTrigger,
          triggerOnlyAtStart: true,
          optionsViewBuilder:
              (
                context,
                autocompleteQuery,
                messageComposerController,
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
        if (widget.props.enableMentionsOverlay)
          StreamAutocompleteTrigger(
            trigger: _kMentionTrigger,
            optionsViewBuilder:
                (
                  context,
                  autocompleteQuery,
                  messageComposerController,
                ) {
                  final query = autocompleteQuery.query;
                  return StreamMentionAutocompleteOptions(
                    query: query,
                    channel: StreamChannel.of(context).channel,
                    mentionAllAppUsers: widget.props.mentionAllAppUsers,
                    mentionsTileBuilder: widget.props.userMentionsTileBuilder,
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
                child: StreamChatMessageInput(
                  controller: controller,
                  currentUserId: currentUserId,
                  onAttachmentButtonPressed: widget.props.disableAttachments ? null : _onAttachmentButtonPressed,
                  isPickerOpen: _isPickerVisible,
                  placeholder: _buildPlaceholder(context),
                  focusNode: focusNode,
                  onSendPressed: sendMessage,
                  canAlsoSendToChannel: _shouldShowSendToChannelCheckbox(),
                  audioRecorderController: widget.props.enableVoiceRecording ? _audioRecorderController : null,
                  sendVoiceRecordingAutomatically: widget.props.sendVoiceRecordingAutomatically,
                  feedback: widget.props.voiceRecordingFeedback,
                  onQuotedMessageCleared: () {
                    _effectiveController.clearQuotedMessage();
                    widget.props.onQuotedMessageCleared?.call();
                  },
                  textInputAction: widget.props.textInputAction,
                  keyboardType: widget.props.keyboardType,
                  textCapitalization: widget.props.textCapitalization,
                  autofocus: widget.props.autofocus,
                  autocorrect: widget.props.autoCorrect,
                ),
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

    final insideThread = _effectiveController.message.parentId != null;
    return insideThread;
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

  // Returns the list of allowed attachment picker types based on the
  // current channel configuration and context.
  List<AttachmentPickerType> _getAllowedAttachmentPickerTypes() {
    final allowedTypes = widget.props.allowedAttachmentPickerTypes.where((type) {
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
    final addedIds = messageIds.difference(pickerIds);

    if (removedIds.isEmpty && addedIds.isEmpty) return;

    final addedAttachments = addedIds
        .map((id) => _effectiveController.value.attachments.firstWhere((a) => a.id == id))
        .toList();

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

  late final _onChangedThrottled = throttle(
    () {
      if (!mounted) return;

      final channel = StreamChannel.maybeOf(context)?.channel;
      if (channel == null) return;

      final value = _effectiveController.text.trim();
      if (value.isNotEmpty && channel.canUseTypingEvents) {
        channel.keyStroke(_effectiveController.message.parentId).onError(
          (error, stackTrace) {
            widget.props.onError?.call(error!, stackTrace);
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

  String? _buildPlaceholder(BuildContext context) {
    final state = MessageInputPlaceholder.resolve(_effectiveController);
    return widget.props.placeholderBuilder.call(context, state);
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

      return _parsedMatch.host.split('.').last.isValidTLD() && widget.props.ogPreviewFilter.call(_parsedMatch, value);
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
            widget.props.onError?.call(error, stackTrace);
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

  /// Adds an attachment to the [messageComposerController.attachments] list
  void _addAttachments(Iterable<Attachment> attachments) {
    if (widget.props.attachmentLimit case final limit?) {
      final length = _effectiveController.attachments.length + attachments.length;
      if (length > limit) {
        final onAttachmentLimitExceed = widget.props.onAttachmentLimitExceed;
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
    if (!widget.props.validator(_effectiveController.message)) return;

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
          context.streamIcons.exclamationCircleFill,
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
    widget.props.onQuotedMessageCleared?.call();
    _effectiveController.reset();

    if (widget.props.preMessageSending case final onPreMessageSending?) {
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
      if (widget.props.shouldKeepFocusAfterMessage ?? !_commandEnabled) {
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
      // A message is considered fresh if it doesn't have a remoteCreatedAt.
      final isFreshMessage = message.remoteCreatedAt == null;

      // Note: edited messages which are bounced back with an error needs to be
      // sent as new messages as the backend doesn't store them.
      final resp = await switch (!isFreshMessage && !message.isBouncedWithError) {
        true => channel.updateMessage(message),
        false => channel.sendMessage(message),
      };

      _effectiveController.startCooldown(channel.getRemainingCooldown());
      widget.props.onMessageSent?.call(resp.message);
    } catch (e, stk) {
      if (widget.props.onError != null) {
        return widget.props.onError?.call(e, stk);
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
    final isMessageValid = widget.props.validator.call(message);

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
    final isDraftValid = widget.props.validator.call(draftMessage.toMessage());
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
    _pickerAnimation.dispose();
    _pickerAnimationController.dispose();
    _stopPickerSync();
    _disposePickerController();
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
    _messageUpdatedSubscription?.cancel();
    _messageDeletedSubscription?.cancel();
    super.dispose();
  }
}
