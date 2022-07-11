import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template threadParticipants}
/// Shows the users participating in a thread.
///
/// Used in [BottomRow].
/// {@endtemplate}
class ThreadParticipants extends StatelessWidget {
  /// {@macro threadParticipants}
  const ThreadParticipants({
    super.key,
    required StreamChatThemeData streamChatTheme,
    required this.threadParticipants,
  }) : _streamChatTheme = streamChatTheme;

  /// {@macro streamChatThemeData}
  final StreamChatThemeData _streamChatTheme;

  /// The users participating in the thread.
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
            child: StreamUserAvatar(
              user: user,
              constraints: BoxConstraints.tight(const Size.fromRadius(7)),
              showOnlineStatus: false,
            ),
          ),
        );
      }).toList(),
    );
  }
}
