import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ThreadParticipants extends StatelessWidget {
  const ThreadParticipants({
    Key? key,
    required StreamChatThemeData streamChatTheme,
    required this.threadParticipants,
  })  : _streamChatTheme = streamChatTheme,
        super(key: key);

  final StreamChatThemeData _streamChatTheme;
  final Iterable<User> threadParticipants;

  @override
  Widget build(BuildContext context) {
    var padding = 0.0;
    return Stack(
      children: threadParticipants.map((user) {
        padding += 8.0;
        return Positioned(
          right: padding - 8,
          bottom: 0,
          top: 0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _streamChatTheme.colorTheme.barsBg,
            ),
            padding: const EdgeInsets.all(1),
            child: UserAvatar(
              user: user,
              constraints: BoxConstraints.loose(const Size.fromRadius(7)),
              showOnlineStatus: false,
            ),
          ),
        );
      }).toList(),
    );
  }
}
