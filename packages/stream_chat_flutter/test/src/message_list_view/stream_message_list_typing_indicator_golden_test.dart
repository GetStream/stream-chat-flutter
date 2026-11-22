import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  for (final brightness in Brightness.values) {
    for (final count in [1, 2, 3, 5]) {
      final theme = brightness.name;
      goldenTest(
        '[$theme] -> StreamMessageListTypingIndicator shows $count typing users',
        fileName: 'stream_message_list_typing_indicator_${count}_users_$theme',
        constraints: const BoxConstraints.tightFor(width: 300, height: 80),
        builder: () => _wrapWithStreamChatApp(
          StreamMessageListTypingIndicator(users: _users(count)),
          brightness: brightness,
        ),
      );
    }
  }
}

List<User> _users(int count) {
  const names = ['Ada Lovelace', 'Grace Hopper', 'Alan Turing', 'Katherine Johnson', 'Linus Torvalds'];
  return [for (var i = 0; i < count; i += 1) User(id: 'user-$i', name: names[i])];
}

// Animations off, so the dots hold a still frame.
Widget _wrapWithStreamChatApp(
  Widget widget, {
  Brightness brightness = Brightness.light,
}) {
  return MaterialApp(
    theme: ThemeData(brightness: brightness),
    home: StreamChatTheme(
      data: StreamChatThemeData(),
      child: Builder(
        builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: Scaffold(
              backgroundColor: context.streamColorScheme.backgroundApp,
              body: Center(child: widget),
            ),
          );
        },
      ),
    ),
  );
}
