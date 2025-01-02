import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/user.dart';

part 'thread_participant.g.dart';

/// {@template streamThreadParticipant}
/// A model class representing a user that is participating in a thread.
/// {@endtemplate}
@JsonSerializable()
class ThreadParticipant extends Equatable {
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

  /// Create a new instance from a json
  factory ThreadParticipant.fromJson(Map<String, dynamic> json) =>
      _$ThreadParticipantFromJson(json);

  /// The channel cid this thread participant belongs to.
  final String channelCid;

  /// The date at which the thread participant was created.
  final DateTime createdAt;

  /// The date at which the user last read the thread.
  final DateTime lastReadAt;

  /// The date at which the user last sent a message in the thread.
  final DateTime? lastThreadMessageAt;

  /// The date at which the user left the thread.
  final DateTime? leftThreadAt;

  /// The id of the thread this participant belongs to.
  final String? threadId;

  /// The id of the user participating in the thread.
  final String? userId;

  /// The user participating in the thread.
  final User? user;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ThreadParticipantToJson(this);

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
  }) =>
      ThreadParticipant(
        channelCid: channelCid ?? this.channelCid,
        createdAt: createdAt ?? this.createdAt,
        lastReadAt: lastReadAt ?? this.lastReadAt,
        lastThreadMessageAt: lastThreadMessageAt ?? this.lastThreadMessageAt,
        leftThreadAt: leftThreadAt ?? this.leftThreadAt,
        threadId: threadId ?? this.threadId,
        userId: userId ?? this.userId,
        user: user ?? this.user,
      );

  @override
  List<Object?> get props => [
        channelCid,
        createdAt,
        lastReadAt,
        lastThreadMessageAt,
        leftThreadAt,
        threadId,
        userId,
        user,
      ];
}
