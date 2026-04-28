import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/stream_channel.dart';
import 'package:stream_chat_flutter_core/src/message_text_field_controller.dart';
import 'package:stream_chat_flutter_core/src/stream_message_input_controller.dart';
import 'package:stream_chat_flutter_core/src/typedef.dart';

/// A value listenable builder related to a [Message].
///
/// Pass in a [StreamMessageComposerController] as the `valueListenable`.
typedef StreamMessageValueListenableBuilder = ValueListenableBuilder<Message>;

/// {@template stream_chat_flutter_core.StreamMessageComposerController}
/// Chat-aware controller for the message composer.
///
/// Manages the full message-composition state (text, attachments, quoted
/// message, mentions, polls, edit mode, slow-mode cooldown) and — when
/// [attach]ed to a [StreamChannel] — drives channel-coupled behavior such
/// as draft sync, OG link enrichment, and send/update operations.
/// {@endtemplate}
class StreamMessageComposerController extends ValueNotifier<Message> {
  /// Creates a [StreamMessageComposerController].
  ///
  /// Optionally inject an existing [inputController]. When not provided,
  /// one is created and owned internally (and disposed on [dispose]).
  factory StreamMessageComposerController({
    Message? message,
    StreamMessageInputController? inputController,
    Map<RegExp, TextStyleBuilder>? textPatternStyle,
  }) => StreamMessageComposerController._(
    initialMessage: message ?? Message(),
    inputController: inputController,
    textPatternStyle: textPatternStyle,
  );

  StreamMessageComposerController._({
    required Message initialMessage,
    StreamMessageInputController? inputController,
    Map<RegExp, TextStyleBuilder>? textPatternStyle,
  }) : assert(
         initialMessage.state.isInitial,
         'Controllers must be created with an initial (draft) message. '
         'Call editMessage() to enter edit mode on an existing message.',
       ),
       _initialMessage = initialMessage,
       _ownedInputController = inputController == null,
       _inputController =
           inputController ??
           StreamMessageInputController(
             textPatternStyle: textPatternStyle,
           ),
       super(initialMessage) {
    _inputController.addListener(_onInputControllerChanged);
  }

  // ---------- input controller ----------

  final bool _ownedInputController;

  /// The underlying [StreamMessageInputController].
  ///
  /// Provides access to the text field controller, focus node, command label,
  /// and cooldown state.
  StreamMessageInputController get inputController => _inputController;
  final StreamMessageInputController _inputController;

  void _onInputControllerChanged() {
    final newText = _inputController.text;
    if (newText != (value.text ?? '')) {
      // Sync text from input controller → message value, suppressing the
      // reverse sync so we don't create an infinite loop.
      _suppressTextSync = true;
      try {
        super.value = value.copyWith(text: newText);
      } finally {
        _suppressTextSync = false;
      }
    }
    // Forward notifications so ValueListenableBuilder rebuilds.
    notifyListeners();
  }

  bool _suppressTextSync = false;

  // ---------- message value ----------

  Message _initialMessage;

  /// Returns the current message associated with this controller.
  Message get message => value;

  /// Sets the current message, syncing the text field if necessary.
  set message(Message message) => value = message;

  @override
  set value(Message newMessage) {
    super.value = newMessage;

    if (!_suppressTextSync) {
      final newText = newMessage.text ?? '';
      if (_inputController.text != newText) {
        _inputController.textEditingValue = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    }
  }

  // ---------- text bridging ----------

  /// The current text of the composer.
  String get text => _inputController.text;

  /// Sets the text of the composer.
  set text(String newText) {
    _inputController.text = newText;
  }

  /// The current text selection.
  TextSelection get selection => _inputController.selection;

  /// Sets the text selection.
  set selection(TextSelection newSelection) {
    _inputController.selection = newSelection;
  }

  /// The full [TextEditingValue].
  TextEditingValue get textEditingValue => _inputController.textEditingValue;

  /// Sets the full [TextEditingValue].
  set textEditingValue(TextEditingValue v) {
    _inputController.textEditingValue = v;
  }

  // ---------- edit mode ----------

  /// Whether the controller is currently in edit mode.
  bool get isEditing => _messageBeingEdited != null;

  /// The message currently being edited, unmodified by the user's changes.
  Message? get messageBeingEdited => _messageBeingEdited;
  Message? _messageBeingEdited;

  Message? _messageBeforeEdit;

  /// Switches the controller to edit mode for the given [message].
  void editMessage(Message message) {
    _messageBeforeEdit ??= value;
    _messageBeingEdited = message;
    this.message = message.copyWith(state: MessageState.updating);
  }

  /// Cancels the active edit and restores the previous draft.
  void cancelEditMessage() {
    _messageBeingEdited = null;
    if (_messageBeforeEdit case final prev?) {
      message = prev;
      _messageBeforeEdit = null;
    }
  }

  // ---------- command ----------

  /// Sets a command on the message.
  set command(String? command) {
    if (command == null) return clearCommand();
    _messageBeforeCommand ??= message;
    _inputController.command = command;
    message = message.copyWith(text: '', attachments: [], command: command);
  }

  Message? _messageBeforeCommand;

  /// Clears the active command and restores the previous content.
  void clearCommand() {
    _inputController.clearCommand();
    if (_messageBeforeCommand case final prev?) {
      message = prev;
      _messageBeforeCommand = null;
    }
  }

  // ---------- quoted message ----------

  /// Sets the quoted message.
  set quotedMessage(Message quotedMessage) {
    message = message.copyWith(
      quotedMessage: quotedMessage,
      quotedMessageId: quotedMessage.id,
    );
  }

  /// Clears the quoted message.
  void clearQuotedMessage() {
    message = message.copyWith(quotedMessageId: null, quotedMessage: null);
  }

  // ---------- showInChannel ----------

  /// Whether the message should also be sent to the parent channel.
  bool get showInChannel => message.showInChannel ?? false;

  /// Sets whether the message should also be sent to the parent channel.
  set showInChannel(bool newValue) {
    message = message.copyWith(showInChannel: newValue);
  }

  // ---------- attachments ----------

  /// The current list of attachments.
  List<Attachment> get attachments => message.attachments;

  /// Replaces the entire attachment list.
  set attachments(List<Attachment> attachments) {
    message = message.copyWith(attachments: attachments);
  }

  /// Appends an attachment.
  void addAttachment(Attachment attachment) {
    attachments = [...attachments, attachment];
  }

  /// Inserts an attachment at [index].
  void addAttachmentAt(int index, Attachment attachment) {
    attachments = [...attachments]..insert(index, attachment);
  }

  /// Removes an attachment by identity.
  void removeAttachment(Attachment attachment) {
    attachments = [...attachments]..remove(attachment);
  }

  /// Removes the attachment with the given [attachmentId].
  void removeAttachmentById(String attachmentId) {
    attachments = [...attachments]..removeWhere((it) => it.id == attachmentId);
  }

  /// Removes the attachment at [index].
  void removeAttachmentAt(int index) {
    attachments = [...attachments]..removeAt(index);
  }

  /// Clears all attachments.
  void clearAttachments() {
    attachments = [];
  }

  /// Returns the OG (link preview) attachment, if present.
  Attachment? get ogAttachment {
    return attachments.firstWhereOrNull((it) => it.ogScrapeUrl != null);
  }

  /// Sets the OG attachment, replacing any existing one.
  void setOGAttachment(Attachment attachment) {
    final updated = [...attachments];
    if (ogAttachment case final existing?) {
      updated.remove(existing);
    }
    updated.insert(0, attachment);
    attachments = updated;
  }

  /// Removes the OG attachment.
  void clearOGAttachment() {
    if (ogAttachment case final existing?) {
      removeAttachment(existing);
    }
  }

  // ---------- poll ----------

  /// The current poll, if any.
  Poll? get poll => message.poll;

  /// Sets the poll.
  set poll(Poll? poll) {
    message = message.copyWith(pollId: poll?.id, poll: poll);
  }

  // ---------- mentioned users ----------

  /// The list of mentioned users.
  List<User> get mentionedUsers => message.mentionedUsers;

  /// Replaces the mentioned users list.
  set mentionedUsers(List<User> users) {
    message = message.copyWith(mentionedUsers: users);
  }

  /// Adds a user to the mentioned list.
  void addMentionedUser(User user) {
    mentionedUsers = [...mentionedUsers, user];
  }

  /// Removes a user from the mentioned list by identity.
  void removeMentionedUser(User user) {
    mentionedUsers = [...mentionedUsers]..remove(user);
  }

  /// Removes the mentioned user with [userId].
  void removeMentionedUserById(String userId) {
    mentionedUsers = [...mentionedUsers]..removeWhere((it) => it.id == userId);
  }

  /// Clears all mentioned users.
  void clearMentionedUsers() {
    mentionedUsers = [];
  }

  // ---------- cooldown (delegated to inputController) ----------

  /// Whether slow-mode is currently active.
  bool get isSlowModeActive => _inputController.isSlowModeActive;

  /// Remaining cooldown seconds.
  int get cooldownTimeOut => _inputController.cooldownTimeOut;

  // ---------- channel-attached behavior ----------

  StreamChannelState? _attachedChannel;
  StreamSubscription<Draft?>? _draftSubscription;
  StreamSubscription<Event>? _messageUpdatedSubscription;
  StreamSubscription<Event>? _messageDeletedSubscription;
  Timer? _keystrokeThrottle;
  CancelableOperation<void>? _enrichUrlOperation;
  String? _lastSearchedUrl;
  final _ogAttachmentCache = <String, OGAttachmentResponse>{};
  bool _draftEnabled = false;
  OgPreviewFilter _ogPreviewFilter = _defaultOgPreviewFilter;
  ErrorListener? _attachedOnError;

  static bool _defaultOgPreviewFilter(Uri matchedUri, String messageText) => true;

  /// Attaches this controller to the given [streamChannelState].
  ///
  /// Sets up:
  /// - Slow-mode cooldown bootstrap.
  /// - Draft sync (when [draftMessagesEnabled] is true).
  /// - Remote message-updated/-deleted listeners.
  /// - Typing-event throttle.
  /// - OG link enrichment (debounced, driven by text changes).
  ///
  /// Call [detach] before disposing the channel or the controller itself.
  void attach(
    StreamChannelState streamChannelState, {
    bool draftMessagesEnabled = true,
    OgPreviewFilter? ogPreviewFilter,
    ErrorListener? onError,
  }) {
    detach();
    _attachedChannel = streamChannelState;
    _draftEnabled = draftMessagesEnabled;
    _ogPreviewFilter = ogPreviewFilter ?? _defaultOgPreviewFilter;
    _attachedOnError = onError;

    final channel = streamChannelState.channel;

    // Cooldown bootstrap.
    if (!isEditing && channel.state != null) {
      _inputController.startCooldown(channel.getRemainingCooldown());
    }

    // Draft sync.
    if (!isEditing && draftMessagesEnabled) {
      final draftStream = switch (message.parentId) {
        final parentId? => channel.state?.threadDraftStream(parentId),
        _ => channel.state?.draftStream,
      };
      _draftSubscription = draftStream?.distinct().listen(_onDraftUpdate);
    }

    // Remote message change listeners.
    _messageUpdatedSubscription = channel.on(EventType.messageUpdated).listen(_onMessageUpdated);
    _messageDeletedSubscription = channel.on(EventType.messageDeleted).listen(_onMessageDeleted);

    // Wire text changes → typing keystroke throttle + OG debounce.
    _inputController.addListener(_onTextChanged);
  }

  /// Detaches from the channel, cancelling all subscriptions, timers, and
  /// pending operations.
  ///
  /// If drafts were enabled, calls [_maybeUpdateOrDeleteDraftMessage] before
  /// tearing down subscriptions (mirroring the old [deactivate] hook).
  void detach() {
    if (_attachedChannel == null) return;

    if (!isEditing && _draftEnabled) {
      _maybeUpdateOrDeleteDraftMessage();
    }

    _inputController.removeListener(_onTextChanged);
    _draftSubscription?.cancel();
    _draftSubscription = null;
    _messageUpdatedSubscription?.cancel();
    _messageUpdatedSubscription = null;
    _messageDeletedSubscription?.cancel();
    _messageDeletedSubscription = null;
    _keystrokeThrottle?.cancel();
    _keystrokeThrottle = null;
    _ogDebounceTimer?.cancel();
    _ogDebounceTimer = null;
    _enrichUrlOperation?.cancel();
    _enrichUrlOperation = null;
    _lastSearchedUrl = null;
    _attachedChannel = null;
    _attachedOnError = null;
  }

  void _onMessageUpdated(Event event) {
    final updatedMessage = event.message;
    if (updatedMessage == null) return;

    if (message.quotedMessageId == updatedMessage.id) {
      quotedMessage = updatedMessage;
    }

    if (isEditing && message.id == updatedMessage.id) {
      editMessage(updatedMessage);
    }
  }

  void _onMessageDeleted(Event event) {
    final deletedId = event.message?.id;
    if (deletedId == null) return;

    if (message.quotedMessageId == deletedId) {
      clearQuotedMessage();
    }

    if (isEditing && message.id == deletedId) {
      cancelEditMessage();
    }
  }

  void _onDraftUpdate(Draft? draft) {
    if (isEditing) return;
    if (draft == null) return reset();

    if (draft.message case final draftMessage) {
      message = draftMessage
          .copyWith(
            quotedMessage: draftMessage.quotedMessage ?? draft.quotedMessage,
            parentId: draftMessage.parentId ?? draft.parentId,
          )
          .toMessage();
    }
  }

  Timer? _ogDebounceTimer;

  void _onTextChanged() {
    final channelState = _attachedChannel;
    if (channelState == null) return;
    final channel = channelState.channel;

    // Throttled keystroke (fire on leading edge, then gate for 350 ms).
    _keystrokeThrottle ??= Timer(const Duration(milliseconds: 350), () {
      _keystrokeThrottle = null;
      final currentText = _inputController.text.trim();
      if (currentText.isNotEmpty && channel.canUseTypingEvents) {
        channel.keyStroke(message.parentId).onError(
          (error, stackTrace) => _attachedOnError?.call(error!, stackTrace),
        );
      }
    });

    // Trailing-edge debounce for OG enrichment.
    _ogDebounceTimer?.cancel();
    _enrichUrlOperation?.cancel();
    _enrichUrlOperation = null;
    _ogDebounceTimer = Timer(
      const Duration(milliseconds: 350),
      () {
        final text = _inputController.text.trim();
        _checkContainsUrl(text, channel);
      },
    );
  }

  static final _urlRegex = RegExp(
    r'https?://(www\.)?[-a-zA-Z0-9@:%._+~#=]{2,256}\.[a-z]{2,4}\b([-a-zA-Z0-9@:%_+.~#?&//=]*)',
    caseSensitive: false,
  );

  void _checkContainsUrl(String value, Channel channel) {
    if (_lastSearchedUrl == value) return;
    _lastSearchedUrl = value;

    final matchedUrls = _urlRegex.allMatches(value).where((it) {
      final rawMatch = it.group(0) ?? '';
      final parsedMatch = Uri.tryParse(rawMatch).withScheme;
      if (parsedMatch == null) return false;
      return _ogPreviewFilter.call(parsedMatch, value);
    }).toList();

    if (matchedUrls.isEmpty || !channel.canSendLinks) {
      return clearOGAttachment();
    }

    final firstUrl = matchedUrls.first.group(0)!;
    if (ogAttachment?.titleLink == firstUrl) return;

    _enrichUrlOperation = CancelableOperation.fromFuture(
      _enrichUrl(firstUrl, channel.client),
    ).then(
      (ogResponse) {
        final attachment = Attachment.fromOGAttachment(ogResponse);
        setOGAttachment(attachment);
      },
      onError: (error, stackTrace) {
        clearOGAttachment();
        _attachedOnError?.call(error, stackTrace);
      },
    );
  }

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

  // ---------- send ----------

  /// Whether the user can send a message (or update an existing one) given
  /// the channel's [ownCapabilities].
  ///
  /// [inThread] should be true when the composer is inside a thread.
  bool canSendOrUpdate(
    Set<String> ownCapabilities, {
    required bool inThread,
  }) {
    var result = ownCapabilities.contains(ChannelCapability.sendMessage);

    if (inThread) {
      result |= ownCapabilities.contains(ChannelCapability.sendReply);
    }

    if (isEditing) {
      result |= ownCapabilities.contains(ChannelCapability.updateOwnMessage);
      result |= ownCapabilities.contains(ChannelCapability.updateAnyMessage);
    }

    return result;
  }

  /// Sends the current message using the attached channel.
  ///
  /// Returns early if slow-mode is active, the [validator] rejects the message,
  /// or no channel is attached. If the message contains a link but the channel
  /// does not allow links, [onLinkDisabled] is called and the send is aborted.
  Future<void> sendMessage({
    PreMessageSending? preMessageSending,
    MessageValidator? validator,
    void Function(Message)? onMessageSent,
    ErrorListener? onError,
    VoidCallback? onLinkDisabled,
    VoidCallback? onQuotedMessageCleared,
    bool resetId = true,
  }) async {
    final channelState = _attachedChannel;
    if (channelState == null) return;
    if (_inputController.isSlowModeActive) return;

    final effectiveValidator = validator ?? _defaultValidator;
    if (!effectiveValidator(message)) return;

    final channel = channelState.channel;
    var msg = value;

    if (!channel.canSendLinks && _urlRegex.allMatches(msg.text ?? '').isNotEmpty) {
      onLinkDisabled?.call();
      return;
    }

    _maybeDeleteDraftMessage(msg, channel);
    onQuotedMessageCleared?.call();
    reset(resetId: resetId);

    if (preMessageSending != null) {
      msg = await preMessageSending.call(msg);
    }

    if (!channel.state!.isUpToDate) {
      await channelState.reloadChannel();
      await WidgetsBinding.instance.endOfFrame;
    }

    await _sendOrUpdateMessage(message: msg, channel: channel, onMessageSent: onMessageSent, onError: onError);
  }

  Future<void> _sendOrUpdateMessage({
    required Message message,
    required Channel channel,
    void Function(Message)? onMessageSent,
    ErrorListener? onError,
  }) async {
    try {
      final isFreshMessage = message.remoteCreatedAt == null;
      final resp = await switch (!isFreshMessage && !message.isBouncedWithError) {
        true => channel.updateMessage(message),
        false => channel.sendMessage(message),
      };
      _inputController.startCooldown(channel.getRemainingCooldown());
      onMessageSent?.call(resp.message);
    } catch (e, stk) {
      if (onError != null) {
        return onError.call(e, stk);
      }
      rethrow;
    }
  }

  static bool _defaultValidator(Message message) {
    final hasText = message.text?.trim().isNotEmpty == true;
    final hasAttachments = message.attachments.isNotEmpty;
    final hasPoll = message.pollId != null;
    return hasText || hasAttachments || hasPoll;
  }

  // ---------- draft helpers ----------

  void _maybeUpdateOrDeleteDraftMessage() {
    final channelState = _attachedChannel;
    if (channelState == null) return;
    final channel = channelState.channel;

    if (_defaultValidator(message)) {
      _maybeUpdateDraftMessage(message, channel);
    } else {
      _maybeDeleteDraftMessage(message, channel);
    }
  }

  void _maybeUpdateDraftMessage(Message msg, Channel channel) {
    final draft = switch (msg.parentId) {
      final parentId? => channel.state?.threadDraft(parentId),
      null => channel.state?.draft,
    };

    final draftMessage = msg.toDraftMessage();
    if (!_defaultValidator(draftMessage.toMessage())) return;
    if (draft?.message == draftMessage) return;

    channel.createDraft(draftMessage).ignore();
  }

  void _maybeDeleteDraftMessage(Message msg, Channel channel) {
    final draft = switch (msg.parentId) {
      final parentId? => channel.state?.threadDraft(parentId),
      null => channel.state?.draft,
    };

    if (draft == null) return;
    channel.deleteDraft(parentId: msg.parentId).ignore();
  }

  // ---------- lifecycle ----------

  /// Clears text, command, and any active command snapshot.
  ///
  /// Active edit state is preserved — use [cancelEditMessage] to exit edit mode.
  void clear() {
    _messageBeforeCommand = null;
    _inputController.clear();
    message = Message();
  }

  /// Resets the controller to its initial [Message] value.
  void reset({bool resetId = true}) {
    _messageBeingEdited = null;
    _messageBeforeEdit = null;
    _messageBeforeCommand = null;

    if (resetId) {
      _initialMessage = _initialMessage.copyWith(id: const Uuid().v4());
    }
    message = _initialMessage;
  }

  @override
  void dispose() {
    detach();
    _inputController.removeListener(_onInputControllerChanged);
    if (_ownedInputController) _inputController.dispose();
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// Restorable companion
// ---------------------------------------------------------------------------

/// A [RestorableProperty] that stores and restores a
/// [StreamMessageComposerController].
class StreamRestorableMessageComposerController
    extends RestorableChangeNotifier<StreamMessageComposerController> {
  /// Creates a [StreamRestorableMessageComposerController].
  StreamRestorableMessageComposerController({Message? message}) : _initialValue = message ?? Message();

  final Message _initialValue;

  @override
  StreamMessageComposerController createDefaultValue() =>
      StreamMessageComposerController(message: _initialValue);

  @override
  StreamMessageComposerController fromPrimitives(Object? data) {
    final restoredData = json.decode(data! as String);

    final message = Message.fromJson(restoredData['message']);
    final state = MessageState.fromJson(restoredData['message_state']);

    return StreamMessageComposerController(message: message.copyWith(state: state));
  }

  @override
  String toPrimitives() => json.encode({
    'message': value.message.toJson(),
    'message_state': value.message.state.toJson(),
  });
}

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

extension _NullableUriX on Uri? {
  Uri? get withScheme {
    final uri = this;
    if (uri == null) return null;
    if (uri.hasScheme) return uri;
    return Uri.tryParse('http://${uri.toString()}');
  }
}
