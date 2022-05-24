import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

import 'package:stream_chat_flutter_core/src/message_text_field_controller.dart';

/// A value listenable builder related to a [Message].
///
/// Pass in a [StreamMessageInputController] as the `valueListenable`.
typedef StreamMessageValueListenableBuilder = ValueListenableBuilder<Message>;

/// Controller for storing and mutating a [Message] value.
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
  })  : _textEditingController = MessageTextFieldController.fromValue(
          initialMessage.text == null
              ? TextEditingValue.empty
              : TextEditingValue(
                  text: initialMessage.text!,
                  composing: TextRange.collapsed(initialMessage.text!.length),
                ),
          textPatternStyle: textPatternStyle,
        ),
        _initialMessage = initialMessage,
        super(initialMessage) {
    addListener(_textEditingSyncer);
  }

  void _textEditingSyncer() {
    final cleanText = value.command == null
        ? value.text
        : value.text?.replaceFirst('/${value.command} ', '');

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
  MessageTextFieldController get textEditingController =>
      _textEditingController;
  final MessageTextFieldController _textEditingController;

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
  /// [StreamMessageInputController] that they need to update
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
      final newId = const Uuid().v4();
      _initialMessage = _initialMessage.copyWith(id: newId);
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
/// [StreamMessageInputController].
///
/// The [StreamMessageInputController] is accessible via the [value] getter.
/// During state restoration,
/// the property will restore [StreamMessageInputController.value]
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
  String toPrimitives() => json.encode(value.value);
}
