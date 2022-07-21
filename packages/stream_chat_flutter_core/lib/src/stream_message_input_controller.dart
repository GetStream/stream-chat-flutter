import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

import 'package:stream_chat_flutter_core/src/message_text_field_controller.dart';

/// A value listenable builder related to a [Message].
///
/// Pass in a [StreamMessageInputController] as the `valueListenable`.
typedef StreamMessageValueListenableBuilder = ValueListenableBuilder<Message>;

/// {@template stream_chat_flutter.StreamMessageInputController}
/// Controller for storing and mutating a [Message] value.
/// {@endtemplate}
class StreamMessageInputController extends ValueNotifier<Message> {
  /// Creates a controller for an editable text field.
  ///
  /// This constructor treats a null [message] argument as if it were the empty
  /// message.
  factory StreamMessageInputController({
    Message? message,
    Map<RegExp, TextStyleBuilder>? textPatternStyle,
  }) =>
      StreamMessageInputController._(
        initialMessage: message ?? Message(),
        textPatternStyle: textPatternStyle,
      );

  /// Creates a controller for an editable text field from an initial [text].
  factory StreamMessageInputController.fromText(
    String? text, {
    Map<RegExp, TextStyleBuilder>? textPatternStyle,
  }) =>
      StreamMessageInputController._(
        initialMessage: Message(text: text),
        textPatternStyle: textPatternStyle,
      );

  /// Creates a controller for an editable text field from initial
  /// [attachments].
  factory StreamMessageInputController.fromAttachments(
    List<Attachment> attachments, {
    Map<RegExp, TextStyleBuilder>? textPatternStyle,
  }) =>
      StreamMessageInputController._(
        initialMessage: Message(attachments: attachments),
        textPatternStyle: textPatternStyle,
      );

  StreamMessageInputController._({
    required Message initialMessage,
    Map<RegExp, TextStyleBuilder>? textPatternStyle,
  })  : _initialMessage = initialMessage,
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

  /// The currently selected [text].
  ///
  /// If the selection is collapsed, then this property gives the offset of the
  /// cursor within the text.
  TextSelection get selection => _textFieldController.selection;

  set selection(TextSelection newSelection) {
    _textFieldController.selection = selection;
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

  /// Sets a command for the message.
  set command(String command) {
    // Setting the command should also clear the text and attachments.
    message = message.copyWith(
      text: '',
      attachments: [],
      command: command,
    );
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

  // Only used to store the value locally in order to remove it if we call
  // [clearOGAttachment] or [setOGAttachment] again.
  Attachment? _ogAttachment;

  /// Returns the og attachment of the message if set
  Attachment? get ogAttachment =>
      attachments.firstWhereOrNull((it) => it.id == _ogAttachment?.id);

  /// Sets the og attachment in the message.
  void setOGAttachment(Attachment attachment) {
    attachments = [...attachments]
      ..remove(_ogAttachment)
      ..insert(0, attachment);
    _ogAttachment = attachment;
  }

  /// Removes the og attachment.
  void clearOGAttachment() {
    if (_ogAttachment != null) {
      removeAttachment(_ogAttachment!);
    }
    _ogAttachment = null;
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
  /// will all be empty.
  ///
  /// Calling this will notify all the listeners of this
  /// [StreamMessageInputController] that they need to update
  /// (calls [notifyListeners]). For this reason,
  /// this method should only be called between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  void clear() {
    message = Message();
  }

  /// Sets the [message] to the initial [Message] value.
  void reset({bool resetId = true}) {
    if (resetId) {
      final newId = const Uuid().v4();
      _initialMessage = _initialMessage.copyWith(id: newId);
    }
    // Reset the message to the initial value.
    message = _initialMessage;
  }

  @override
  void dispose() {
    _textFieldController
      ..removeListener(_textFieldListener)
      ..dispose();
    super.dispose();
  }
}

/// A [RestorableProperty] that knows how to store and restore a
/// [StreamMessageInputController].
///
/// The [StreamMessageInputController] is accessible via the [value] getter.
/// During state restoration,
/// the property will restore [StreamMessageInputController.message]
/// to the value it had when the restoration data it is getting restored from
/// was collected.
class StreamRestorableMessageInputController
    extends RestorableChangeNotifier<StreamMessageInputController> {
  /// Creates a [StreamRestorableMessageInputController].
  ///
  /// This constructor creates a default [Message] when no `message` argument
  /// is supplied.
  StreamRestorableMessageInputController({Message? message})
      : _initialValue = message ?? Message();

  /// Creates a [StreamRestorableMessageInputController] from an initial
  /// [text] value.
  factory StreamRestorableMessageInputController.fromText(String? text) =>
      StreamRestorableMessageInputController(message: Message(text: text));

  final Message _initialValue;

  @override
  StreamMessageInputController createDefaultValue() =>
      StreamMessageInputController(message: _initialValue);

  @override
  StreamMessageInputController fromPrimitives(Object? data) {
    final message = Message.fromJson(json.decode(data! as String));
    return StreamMessageInputController(message: message);
  }

  @override
  String toPrimitives() => json.encode(value.message);
}
