import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat/stream_chat.dart';

class MessageInputController extends ValueNotifier<Message> {
  /// Creates a controller for an editable text field.
  ///
  /// This constructor treats a null [message] argument as if it were the empty
  /// message.
  factory MessageInputController({Message? message}) =>
      MessageInputController._(message ?? Message());

  /// Creates a controller for an editable text field from an initial [text].
  factory MessageInputController.fromText(String? text) =>
      MessageInputController._(Message(text: text));

  /// Creates a controller for an editable text field from an initial [attachments].
  factory MessageInputController.fromAttachments(
    List<Attachment> attachments,
  ) =>
      MessageInputController._(Message(attachments: attachments));

  MessageInputController._(Message message)
      : _textEditingController = TextEditingController(text: message.text),
        super(message);

  ///
  TextEditingController get textEditingController => _textEditingController;
  final TextEditingController _textEditingController;

  ///
  String get text => _textEditingController.text;

  ///
  set message(Message message) {
    value = message;
  }

  set text(String newText) {
    value = value.copyWith(text: newText);
    _textEditingController
      ..text = newText
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: _textEditingController.text.length),
      );
  }

  ///
  set textEditingValue(TextEditingValue newValue) {
    _textEditingController.value = newValue;
    value = value.copyWith(text: _textEditingController.text);
  }

  ///
  get baseOffset {
    return textEditingController.selection.baseOffset;
  }

  ///
  get selectionStart {
    return textEditingController.selection.start;
  }

  set showInChannel(bool newValue) {
    value = value.copyWith(showInChannel: newValue);
  }

  ///
  bool get showInChannel {
    return value.showInChannel ?? false;
  }

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
  /// Calling this will notify all the listeners of this [MessageInputController]
  /// that they need to update (it calls [notifyListeners]). For this reason,
  /// this method should only be called between frames, e.g. in response to user
  /// actions, not during the build, layout, or paint phases.
  void clear() {
    value = Message();
    _textEditingController.clear();
  }

  @override
  void dispose() {
    super.dispose();
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
