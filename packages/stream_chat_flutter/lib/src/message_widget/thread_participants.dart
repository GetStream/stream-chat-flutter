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
    required this.threadParticipants,
  });

  /// The users participating in the thread.
  final Iterable<User> threadParticipants;

  @override
  Widget build(BuildContext context) {
    // TODO(redesign): Old design used 14px diameter avatars, but .xs is 20px.
    return StreamUserAvatarStack(
      max: 3,
      size: .xs,
      users: threadParticipants,
    );
  }
}
