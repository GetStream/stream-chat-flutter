import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat/stream_chat.dart';

/// A value listenable builder related to a [Message].
///
/// Pass in a [MessageInputController] as the `valueListenable`.
typedef MessageValueListenableBuilder = ValueListenableBuilder<Message>;

/// Controller for storing and mutating a [Message] value.
class MessageInputController extends ValueNotifier<Message> {
  /// Creates a controller for an editable text field.
  ///
  /// This constructor treats a null [message] argument as if it were the empty
  /// message.
  factory MessageInputController({
    Message? message,
  }) =>
      MessageInputController._(
        initialMessage: message ?? Message(),
      );

  /// Creates a controller for an editable text field from an initial [text].
  factory MessageInputController.fromText(String? text) =>
      MessageInputController._(
        initialMessage: Message(text: text),
      );

  /// Creates a controller for an editable text field from initial
  /// [attachments].
  factory MessageInputController.fromAttachments(
    List<Attachment> attachments,
  ) =>
      MessageInputController._(
        initialMessage: Message(attachments: attachments),
      );

  MessageInputController._({
    required Message initialMessage,
  })  : _textEditingController =
            TextEditingController.fromValue(TextEditingValue(
          text: initialMessage.text ?? '',
          composing: TextRange.collapsed(initialMessage.text?.length ?? 0),
        )),
        _initialMessage = initialMessage,
        super(initialMessage) {
    addListener(_textEditingSyncer);
  }

  void _textEditingSyncer() {
    final cleanText = value.command == null
        ? value.text
        : value.text?.replaceFirst(
            '/${value.command} ',
            '',
          );

    if (cleanText != _textEditingController.text) {
      final previousOffset = _textEditingController.value.selection.start;
      final previousText = _textEditingController.text;
      final diff = (cleanText?.length ?? 0) - previousText.length;
      _textEditingController
        ..text = cleanText ?? ''
        ..selection = TextSelection.collapsed(
          offset: previousOffset + diff,
        );
    }
  }

  /// Returns the current message associated with this controller.
  Message get message => value;

  /// Returns the controller of the text field linked to this controller.
  TextEditingController get textEditingController => _textEditingController;
  final TextEditingController _textEditingController;

  /// Returns the text of the message.
  String get text => _textEditingController.text;

  Message _initialMessage;

  /// Sets the message.
  set message(Message message) {
    value = message;
  }

  /// Sets the message that's being quoted.
  set quotedMessage(Message message) {
    value = value.copyWith(
      quotedMessage: message,
      quotedMessageId: message.id,
    );
  }

  /// Clears the quoted message.
  void clearQuotedMessage() {
    value = value.copyWith(
      quotedMessageId: null,
      quotedMessage: null,
    );
  }

  /// Sets a command for the message.
  set command(Command command) {
    value = value.copyWith(
      command: command.name,
      text: '/${command.name} ',
    );
  }

  /// Sets the text of the message.
  set text(String newText) {
    var newTextWithCommand = newText;
    if (value.command != null) {
      if (!newText.startsWith('/${value.command}')) {
        newTextWithCommand = '/${value.command} $newText';
      }
    }
    value = value.copyWith(text: newTextWithCommand);
  }

  /// Returns the baseOffset of the text field.
  int get baseOffset => textEditingController.selection.baseOffset;

  /// Returns the start of the selection of the text field.
  int get selectionStart => textEditingController.selection.start;

  /// Sets the [showInChannel] flag of the message.
  set showInChannel(bool newValue) {
    value = value.copyWith(showInChannel: newValue);
  }

  /// Returns true if the message is in a thread and
  /// should be shown in the main channel as well.
  bool get showInChannel => value.showInChannel ?? false;

  /// Returns the attachments of the message.
  List<Attachment> get attachments => value.attachments;

  /// Sets the list of [attachments] for the message.
  set attachments(List<Attachment> attachments) {
    value = value.copyWith(attachments: attachments);
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

  /// Returns the list of mentioned users in the message.
  List<User> get mentionedUsers => value.mentionedUsers;

  /// Sets the mentioned users.
  set mentionedUsers(List<User> users) {
    value = value.copyWith(mentionedUsers: users);
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

  /// Sets the [message], or [value], to empty.
  ///
  /// After calling this function, [text], [attachments] and [mentionedUsers]
  /// will all be empty.
  ///
  /// Calling this will notify all the listeners of this
  /// [MessageInputController] that they need to update
  /// (calls [notifyListeners]). For this reason,
  /// this method should only be called between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  void clear() {
    value = Message();
    _textEditingController.clear();
  }

  /// Sets the [value] to the initial [Message] value.
  void reset({bool resetId = true}) {
    if (resetId) {
      _initialMessage = _initialMessage.copyWith(
        id: const Uuid().v4(),
      );
    }
    value = _initialMessage;
  }

  @override
  void dispose() {
    removeListener(_textEditingSyncer);
    _textEditingController.dispose();
    super.dispose();
  }
}

/// A [RestorableProperty] that knows how to store and restore a
/// [MessageInputController].
///
/// The [MessageInputController] is accessible via the [value] getter. During
/// state restoration, the property will restore [MessageInputController.value]
/// to the value it had when the restoration data it is getting restored from
/// was collected.
class RestorableMessageInputController
    extends RestorableChangeNotifier<MessageInputController> {
  /// Creates a [RestorableMessageInputController].
  ///
  /// This constructor creates a default [Message] when no `message` argument
  /// is supplied.
  RestorableMessageInputController({Message? message})
      : _initialValue = message ?? Message();

  /// Creates a [RestorableMessageInputController] from an initial
  /// [text] value.
  factory RestorableMessageInputController.fromText(String? text) =>
      RestorableMessageInputController(message: Message(text: text));

  final Message _initialValue;

  @override
  MessageInputController createDefaultValue() =>
      MessageInputController(message: _initialValue);

  @override
  MessageInputController fromPrimitives(Object? data) {
    final message = Message.fromJson(json.decode(data! as String));
    return MessageInputController(message: message);
  }

  @override
  String toPrimitives() => json.encode(value.value);
}
