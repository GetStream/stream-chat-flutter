import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat/stream_chat.dart';

typedef MessageValidator = bool Function(Message message);

/// Controller for storing and mutating a [Message] value.
class MessageInputController extends ValueNotifier<Message> {
  /// Creates a controller for an editable text field.
  ///
  /// This constructor treats a null [message] argument as if it were the empty
  /// message.
  factory MessageInputController({
    Message? message,
    MessageValidator? validator,
  }) =>
      MessageInputController._(
        initialMessage: message ?? Message(),
        validator: validator ?? _defaultValidator,
      );

  /// Creates a controller for an editable text field from an initial [text].
  factory MessageInputController.fromText(
    String? text, {
    MessageValidator? validator,
  }) =>
      MessageInputController._(
        initialMessage: Message(text: text),
        validator: validator ?? _defaultValidator,
      );

  /// Creates a controller for an editable text field from an initial
  /// [attachments].
  factory MessageInputController.fromAttachments(
    List<Attachment> attachments, {
    MessageValidator? validator,
  }) =>
      MessageInputController._(
        initialMessage: Message(attachments: attachments),
        validator: validator ?? _defaultValidator,
      );

  MessageInputController._({
    required Message initialMessage,
    this.validator = _defaultValidator,
  })  : _textEditingController =
            TextEditingController(text: initialMessage.text),
        _initialMessage = initialMessage,
        super(initialMessage) {
    addListener(_textEditingSyncer);
  }

  /// A callback function that validates the message.
  final MessageValidator validator;

  /// Checks if the message is valid.
  bool get isValid => validator(value);

  static bool _defaultValidator(Message message) =>
      message.text?.isNotEmpty != true && message.attachments.isEmpty;

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

  ///
  TextEditingController get textEditingController => _textEditingController;
  final TextEditingController _textEditingController;

  ///
  String get text => _textEditingController.text;

  final Message _initialMessage;

  ///
  set message(Message message) {
    value = message;
  }

  ///
  set command(Command command) {
    value = value.copyWith(
      command: command.name,
      text: '/${command.name} ',
    );
  }

  set text(String newText) {
    var newTextWithCommand = newText;
    if (value.command != null) {
      if (!newText.startsWith('/${value.command}')) {
        newTextWithCommand = '/${value.command} $newText';
      }
    }
    value = value.copyWith(text: newTextWithCommand);
  }

  ///
  int get baseOffset => textEditingController.selection.baseOffset;

  ///
  int get selectionStart => textEditingController.selection.start;

  set showInChannel(bool newValue) {
    value = value.copyWith(showInChannel: newValue);
  }

  ///
  bool get showInChannel => value.showInChannel ?? false;

  ///
  List<Attachment> get attachments => value.attachments;

  set attachments(List<Attachment> attachments) {
    value = value.copyWith(attachments: attachments);
  }

  ///
  void addAttachment(Attachment attachment) {
    attachments = [...attachments, attachment];
  }

  ///
  void addAttachmentAt(int index, Attachment attachment) {
    attachments = [...attachments]..insert(index, attachment);
  }

  ///
  void removeAttachment(Attachment attachment) {
    attachments = [...attachments]..remove(attachment);
  }

  ///
  void removeAttachmentById(String attachmentId) {
    attachments = [...attachments]..removeWhere((it) => it.id == attachmentId);
  }

  ///
  void removeAttachmentAt(int index) {
    attachments = [...attachments]..removeAt(index);
  }

  ///
  void clearAttachments() {
    attachments = [];
  }

  ///
  List<User> get mentionedUsers => value.mentionedUsers;

  set mentionedUsers(List<User> users) {
    value = value.copyWith(mentionedUsers: users);
  }

  ///
  void addMentionedUser(User user) {
    mentionedUsers = [...mentionedUsers, user];
  }

  ///
  void removeMentionedUser(User user) {
    mentionedUsers = [...mentionedUsers]..remove(user);
  }

  ///
  void removeMentionedUserById(String userId) {
    mentionedUsers = [...mentionedUsers]..removeWhere((it) => it.id == userId);
  }

  ///
  void clearMentionedUsers() {
    mentionedUsers = [];
  }

  /// Set the [value] to empty.
  ///
  /// After calling this function, [text], [attachments] and [mentionedUsers]
  /// all will be empty.
  ///
  /// Calling this will notify all the listeners of this
  /// [MessageInputController] that they need to update
  /// (it calls [notifyListeners]). For this reason,
  /// this method should only be called between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  void clear() {
    value = Message();
    _textEditingController.clear();
  }

  /// Set the [value] to the initial [Message] value.
  void reset() => value = _initialMessage;

  @override
  void dispose() {
    super.dispose();
    removeListener(_textEditingSyncer);
    _textEditingController.dispose();
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
  /// This constructor treats a null `text` argument as if it were the empty
  /// string.
  RestorableMessageInputController({Message? message})
      : _initialValue = message ?? Message();

  /// Creates a [RestorableMessageInputController] from an initial
  /// [TextEditingValue].
  ///
  /// This constructor treats a null `value` argument as if it were
  /// [TextEditingValue.empty].
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
