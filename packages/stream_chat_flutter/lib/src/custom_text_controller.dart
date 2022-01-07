import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class CustomTextController extends TextEditingController {
  final Set<User> users = {};

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
        text: text,
        children: _mentionBuilder(text, users),
        style: const TextStyle(color: Colors.black),
      );
}

List<InlineSpan> _mentionBuilder(String text, Set<User> users) {
  final styledWords = <TextSpan>[];
  var editedText = '';

  if (text.isNotEmpty) {
    for (final user in users) {
      final nameAsMention = '@${user.name}';
      editedText = text.replaceAll(nameAsMention, '|||@${user.name}|||');
    }

    final splittedMessage = editedText.split('|||');
    for (final sentence in splittedMessage) {
      if (sentence.contains('@')) {
        styledWords.add(
          TextSpan(
            text: sentence,
            style: const TextStyle(color: Colors.lightBlue),
          ),
        );
      } else {
        styledWords.add(_normalTextSpan(sentence));
      }
    }
  } else {
    styledWords.add(_normalTextSpan(text));
  }
  return styledWords;
}

TextSpan _normalTextSpan(String sentence) => TextSpan(
      text: sentence,
      style: const TextStyle(
        color: Colors.black,
      ),
    );
