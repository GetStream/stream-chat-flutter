import 'dart:async' show Timer;
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat/stream_chat.dart';

import 'package:stream_chat_flutter_core/src/message_text_field_controller.dart';

/// A value listenable builder related to a [Message].
///
/// Pass in a [StreamMessageComposerController] as the `valueListenable`.
typedef StreamMessageValueListenableBuilder = ValueListenableBuilder<Message>;

/// {@template stream_chat_flutter.StreamMessageComposerController}
/// Controller for storing and mutating a [Message] value.
/// {@endtemplate}
class StreamMessageComposerController extends ValueNotifier<Message> {
  /// Creates a controller for an editable text field.
  ///
  /// This constructor treats a null [message] argument as if it were the empty
  /// message.
  factory StreamMessageComposerController({
    Message? message,
    Map<RegExp, TextStyleBuilder>? textPatternStyle,
  }) => StreamMessageComposerController._(
    initialMessage: message ?? Message(),
    textPatternStyle: textPatternStyle,
  );

  /// Creates a controller for an editable text field from an initial [text].
  factory StreamMessageComposerController.fromText(
    String? text, {
    Map<RegExp, TextStyleBuilder>? textPatternStyle,
  }) => StreamMessageComposerController._(
    initialMessage: Message(text: text),
    textPatternStyle: textPatternStyle,
  );

  /// Creates a controller for an editable text field from initial
  /// [attachments].
  factory StreamMessageComposerController.fromAttachments(
    List<Attachment> attachments, {
    Map<RegExp, TextStyleBuilder>? textPatternStyle,
  }) => StreamMessageComposerController._(
    initialMessage: Message(attachments: attachments),
    textPatternStyle: textPatternStyle,
  );

  StreamMessageComposerController._({
    required Message initialMessage,
    Map<RegExp, TextStyleBuilder>? textPatternStyle,
  }) : assert(
         initialMessage.state.isInitial,
         'Controllers must be created with an initial (draft) message. '
         'Call editMessage() to enter edit mode on an existing message.',
       ),
       _initialMessage = initialMessage,
       _textFieldController = MessageTextFieldController.fromValue(
         _textEditingValueFromMessage(initialMessage),
         textPatternStyle: textPatternStyle,
       ),
       super(initialMessage) {
    _textFieldController.addListener(_textFieldListener);
  }

  /// Returns the controller of the text field linked to this controller.
  MessageTextFieldController get textFieldController => _textFieldController;
  MessageTextFieldController _textFieldController;

  Message _initialMessage;

  static TextEditingValue _textEditingValueFromMessage(Message message) {
    final messageText = message.text;
    var textEditingValue = TextEditingValue.empty;
    if (messageText != null) {
      textEditingValue = TextEditingValue(
        text: messageText,
        selection: TextSelection.collapsed(offset: messageText.length),
      );
    }
    return textEditingValue;
  }

  void _textFieldListener() {
    final text = _textFieldController.text;
    message = message.copyWith(text: text);
  }

  /// Returns the current message associated with this controller.
  Message get message => value;

  /// Sets the current message associated with this controller.
  set message(Message message) => value = message;

  @override
  set value(Message message) {
    super.value = message;

    // Update text field controller only if message text has changed.
    final messageText = message.text;
    final textFieldText = _textFieldController.text;
    if (messageText != textFieldText) {
      textEditingValue = _textEditingValueFromMessage(message);
    }
  }

  /// Text of the message.
  String get text => _textFieldController.text;

  /// Sets the text of the message.
  set text(String text) {
    _textFieldController.text = text;
  }

  /// Returns true if the slow mode is currently active.
  bool get isSlowModeActive => _cooldownTimeOut > 0;

  /// The current [cooldownTimeOut] of the slow mode.
  ///
  /// Defaults to 0, which means slow mode is not active.
  int get cooldownTimeOut => _cooldownTimeOut;
  int _cooldownTimeOut = 0;

  Timer? _cooldownTimer;

  /// Starts the slow mode timer.
  void startCooldown(int cooldown) {
    if (cooldown <= 0) return;

    // Start the slow mode timer.
    _cooldownTimer ??= _setPeriodicTimer(
      immediate: true,
      const Duration(seconds: 1),
      (timer) {
        final elapsed = timer.tick;
        if (elapsed >= cooldown) return cancelCooldown();

        final updatedTimeOut = cooldown - elapsed;
        if (_cooldownTimeOut == updatedTimeOut) return;

        _cooldownTimeOut = updatedTimeOut;
        if (hasListeners) notifyListeners();
      },
    );
  }

  /// Cancels the slow mode timer.
  void cancelCooldown() {
    _cooldownTimer?.cancel();
    _cooldownTimer = null;

    _cooldownTimeOut = 0;
    if (hasListeners) notifyListeners();
  }

  /// The currently selected [text].
  ///
  /// If the selection is collapsed, then this property gives the offset of the
  /// cursor within the text.
  TextSelection get selection => _textFieldController.selection;

  set selection(TextSelection newSelection) {
    _textFieldController.selection = newSelection;
  }

  /// Returns the textEditingValue associated with this controller.
  TextEditingValue get textEditingValue => _textFieldController.value;

  set textEditingValue(TextEditingValue value) {
    _textFieldController.value = value;
  }

  set quotedMessage(Message quotedMessage) {
    message = message.copyWith(
      quotedMessage: quotedMessage,
      quotedMessageId: quotedMessage.id,
    );
  }

  /// Clears the quoted message.
  void clearQuotedMessage() {
    message = message.copyWith(
      quotedMessageId: null,
      quotedMessage: null,
    );
  }

  // Snapshot of the composer message taken when [command] is first set, so
  // [clearCommand] can restore the user's content.
  Message? _messageBeforeCommand;

  /// Sets a command on the message.
  ///
  /// Replaces the composer's content with an empty message tagged with
  /// [command] so the UI can reflect command mode. Call [clearCommand] to
  /// exit command mode and restore the composer to the content it had
  /// before. Passing `null` is equivalent to calling [clearCommand].
  ///
  /// Safe to call repeatedly during an active command; [clearCommand] still
  /// restores the content that was in the composer before the first call.
  set command(String? command) {
    if (command == null) return clearCommand();
    _messageBeforeCommand ??= message;

    message = message.copyWith(
      text: '',
      attachments: [],
      command: command,
    );
  }

  /// Clears the active command and restores the composer to the content it
  /// had before [command] was set.
  ///
  /// No-op if there is no active command.
  void clearCommand() {
    if (_messageBeforeCommand case final message?) {
      this.message = message;
      _messageBeforeCommand = null;
    }
  }

  /// Whether the controller is currently in edit mode.
  ///
  /// Equivalent to `messageBeingEdited != null`.
  bool get isEditing => _messageBeingEdited != null;

  /// The message currently being edited, unmodified by the user's changes.
  ///
  /// Set by [editMessage] and cleared by [cancelEditMessage]. Use this to
  /// display a stable preview of the original message while the user is
  /// typing their edits.
  Message? get messageBeingEdited => _messageBeingEdited;
  Message? _messageBeingEdited;

  // Snapshot of the composer message taken when [editMessage] is first called,
  // so [cancelEditMessage] can restore the user's draft.
  Message? _messageBeforeEdit;

  /// Switches the controller to edit mode for the given [message].
  ///
  /// Replaces the composer's content with [message] and exposes it via
  /// [messageBeingEdited] so the UI can show a preview of the message being
  /// edited. Call [cancelEditMessage] to exit edit mode and restore the
  /// composer to the content it had before.
  ///
  /// Safe to call repeatedly during an active edit (e.g. when a newer
  /// version of the same message arrives); [cancelEditMessage] still
  /// restores the content that was in the composer before the first call.
  void editMessage(Message message) {
    _messageBeforeEdit ??= this.message;
    _messageBeingEdited = message;

    this.message = message.copyWith(state: MessageState.updating);
  }

  /// Cancels the active edit and restores the composer to the content it
  /// had before [editMessage] was called.
  ///
  /// No-op if there is no active edit.
  void cancelEditMessage() {
    _messageBeingEdited = null;
    if (_messageBeforeEdit case final message?) {
      this.message = message;
      _messageBeforeEdit = null;
    }
  }

  /// Sets the [showInChannel] flag of the message.
  set showInChannel(bool newValue) {
    message = message.copyWith(showInChannel: newValue);
  }

  /// Returns true if the message is in a thread and
  /// should be shown in the main channel as well.
  bool get showInChannel => message.showInChannel ?? false;

  /// Returns the attachments of the message.
  List<Attachment> get attachments => message.attachments;

  /// Sets the list of [attachments] for the message.
  set attachments(List<Attachment> attachments) {
    message = message.copyWith(attachments: attachments);
  }

  /// Adds a new attachment to the message.
  void addAttachment(Attachment attachment) {
    attachments = [...attachments, attachment];
  }

  /// Adds a new attachment at the specified [index].
  void addAttachmentAt(int index, Attachment attachment) {
    attachments = [...attachments]..insert(index, attachment);
  }

  /// Removes the specified [attachment] from the message.
  void removeAttachment(Attachment attachment) {
    attachments = [...attachments]..remove(attachment);
  }

  /// Remove the attachment with the given [attachmentId].
  void removeAttachmentById(String attachmentId) {
    attachments = [...attachments]..removeWhere((it) => it.id == attachmentId);
  }

  /// Removes the attachment at the given [index].
  void removeAttachmentAt(int index) {
    attachments = [...attachments]..removeAt(index);
  }

  /// Clears the message attachments.
  void clearAttachments() {
    attachments = [];
  }

  /// Returns the og attachment of the message if set
  Attachment? get ogAttachment {
    return attachments.firstWhereOrNull((it) => it.ogScrapeUrl != null);
  }

  /// Sets the og attachment in the message.
  void setOGAttachment(Attachment attachment) {
    final updatedAttachments = [...attachments];
    // Remove the existing og attachment if it exists.
    if (ogAttachment case final existingOGAttachment?) {
      updatedAttachments.remove(existingOGAttachment);
    }

    // Add the new og attachment at the beginning of the list.
    updatedAttachments.insert(0, attachment);

    // Update the attachments list.
    attachments = updatedAttachments;
  }

  /// Removes the og attachment.
  void clearOGAttachment() {
    if (ogAttachment case final existingOGAttachment?) {
      removeAttachment(existingOGAttachment);
    }
  }

  /// Returns the poll in the message.
  Poll? get poll => message.poll;

  /// Sets the poll in the message.
  set poll(Poll? poll) {
    message = message.copyWith(pollId: poll?.id, poll: poll);
  }

  /// Returns the list of mentioned users in the message.
  List<User> get mentionedUsers => message.mentionedUsers;

  /// Sets the mentioned users.
  set mentionedUsers(List<User> users) {
    message = message.copyWith(mentionedUsers: users);
  }

  /// Adds a user to the list of mentioned users.
  void addMentionedUser(User user) {
    mentionedUsers = [...mentionedUsers, user];
  }

  /// Removes the specified [user] from the mentioned users list.
  void removeMentionedUser(User user) {
    mentionedUsers = [...mentionedUsers]..remove(user);
  }

  /// Removes the mentioned user with the given [userId].
  void removeMentionedUserById(String userId) {
    mentionedUsers = [...mentionedUsers]..removeWhere((it) => it.id == userId);
  }

  /// Removes all mentioned users from the message.
  void clearMentionedUsers() {
    mentionedUsers = [];
  }

  /// Sets the [message], to empty.
  ///
  /// After calling this function, [text], [attachments] and [mentionedUsers]
  /// will all be empty, and any active command is dropped. Any active edit
  /// session is preserved — use [cancelEditMessage] to exit edit mode.
  ///
  /// Calling this will notify all the listeners of this
  /// [StreamMessageComposerController] that they need to update
  /// (calls [notifyListeners]). For this reason,
  /// this method should only be called between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  void clear() {
    // Clear the command state, if any.
    _messageBeforeCommand = null;
    message = Message();
  }

  /// Sets the [message] to the initial [Message] value.
  void reset({bool resetId = true}) {
    // Reset the edit state, if any.
    _messageBeingEdited = null;
    _messageBeforeEdit = null;

    // Reset the command state, if any.
    _messageBeforeCommand = null;

    if (resetId) {
      final newId = const Uuid().v4();
      _initialMessage = _initialMessage.copyWith(id: newId);
    }
    // Reset the message to the initial value.
    message = _initialMessage;
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _cooldownTimer = null;
    _textFieldController
      ..removeListener(_textFieldListener)
      ..dispose();
    super.dispose();
  }
}

/// A [RestorableProperty] that knows how to store and restore a
/// [StreamMessageComposerController].
///
/// The [StreamMessageComposerController] is accessible via the [value] getter.
/// During state restoration,
/// the property will restore [StreamMessageComposerController.message]
/// to the value it had when the restoration data it is getting restored from
/// was collected.
class StreamRestorableMessageComposerController extends RestorableChangeNotifier<StreamMessageComposerController> {
  /// Creates a [StreamRestorableMessageComposerController].
  ///
  /// This constructor creates a default [Message] when no `message` argument
  /// is supplied.
  StreamRestorableMessageComposerController({Message? message}) : _initialValue = message ?? Message();

  /// Creates a [StreamRestorableMessageComposerController] from an initial
  /// [text] value.
  factory StreamRestorableMessageComposerController.fromText(String? text) =>
      StreamRestorableMessageComposerController(message: Message(text: text));

  final Message _initialValue;

  @override
  StreamMessageComposerController createDefaultValue() => StreamMessageComposerController(message: _initialValue);

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

Timer _setPeriodicTimer(
  Duration duration,
  void Function(Timer) callback, {
  bool immediate = false,
}) {
  final timer = Timer.periodic(duration, callback);
  if (immediate) callback.call(timer);
  return timer;
}
