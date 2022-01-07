import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

///Custom text controller that handle different text styles when a Roger
///user is mentioned in the input field.
class CustomTextController extends TextEditingController {
  ///Set of Roger available users.
  final Set<User> users = {};

  ///Method used to add Roger available users to the text controller.
  void addUsers(Set<User> newUsers) {
    users.addAll(newUsers);
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) =>
      TextSpan(
        children: _mentionBuilder(text, users),
        style: const TextStyle(color: Colors.black),
      );
}

List<InlineSpan> _mentionBuilder(String text, Set<User> users) {
  final styledWords = <TextSpan>[];
  final namesAsMentions = <String>[];
  var editedText = text;

  if (text.isNotEmpty) {
    for (final user in users) {
      final nameAsMention = '@${user.name}';
      namesAsMentions.add(nameAsMention);
      editedText = editedText.replaceAll(nameAsMention, '|||@${user.name}|||');
    }
    final splittedMessage = editedText.split('|||');

    styledWords.addAll(
      _mentionTextSpan(
        splittedMessage: splittedMessage,
        names: namesAsMentions,
      ),
    );
  } else {
    styledWords.add(_normalTextSpan(text));
  }
  return styledWords;
}

List<TextSpan> _mentionTextSpan({
  required List<String> splittedMessage,
  required List<String> names,
}) {
  //ignore: prefer_final_locals
  var result = <TextSpan>[];
  for (final sentence in splittedMessage) {
    var isMention = false;
    names.forEach((name) {
      if (sentence.contains(name)) {
        isMention = true;
      }
    });

    if (isMention) {
      result.add(
        TextSpan(
          text: sentence,
          style: const TextStyle(color: Colors.lightBlue),
        ),
      );
    } else {
      result.add(_normalTextSpan(sentence));
    }
  }

  return result;
}

TextSpan _normalTextSpan(String sentence) => TextSpan(
      text: sentence,
      style: const TextStyle(
        color: Colors.black,
      ),
    );
