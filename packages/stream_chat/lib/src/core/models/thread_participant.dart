import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'thread_participant.freezed.dart';

/// {@template streamThreadParticipant}
/// A model class representing a user that is participating in a thread.
/// {@endtemplate}
@Freezed(copyWith: false)
class ThreadParticipant with _$ThreadParticipant {
  /// {@macro streamThreadParticipant}
  const ThreadParticipant({
    required this.channelCid,
    required this.createdAt,
    required this.lastReadAt,
    this.lastThreadMessageAt,
    this.leftThreadAt,
    this.threadId,
    this.userId,
    this.user,
  });

  /// The channel cid this thread participant belongs to.
  @override
  final String channelCid;

  /// The date at which the thread participant was created.
  @override
  final DateTime createdAt;

  /// The date at which the user last read the thread.
  @override
  final DateTime lastReadAt;

  /// The date at which the user last sent a message in the thread.
  @override
  final DateTime? lastThreadMessageAt;

  /// The date at which the user left the thread.
  @override
  final DateTime? leftThreadAt;

  /// The id of the thread this participant belongs to.
  @override
  final String? threadId;

  /// The id of the user participating in the thread.
  @override
  final String? userId;

  /// The user participating in the thread.
  @override
  final User? user;

  /// Creates a copy of this [ThreadParticipant] with specified attributes
  /// overridden.
  ThreadParticipant copyWith({
    String? channelCid,
    DateTime? createdAt,
    DateTime? lastReadAt,
    DateTime? lastThreadMessageAt,
    DateTime? leftThreadAt,
    String? threadId,
    String? userId,
    User? user,
  }) => ThreadParticipant(
    channelCid: channelCid ?? this.channelCid,
    createdAt: createdAt ?? this.createdAt,
    lastReadAt: lastReadAt ?? this.lastReadAt,
    lastThreadMessageAt: lastThreadMessageAt ?? this.lastThreadMessageAt,
    leftThreadAt: leftThreadAt ?? this.leftThreadAt,
    threadId: threadId ?? this.threadId,
    userId: userId ?? this.userId,
    user: user ?? this.user,
  );
}
