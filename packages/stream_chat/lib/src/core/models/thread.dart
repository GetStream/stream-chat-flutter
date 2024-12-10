import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/read.dart';
import 'package:stream_chat/src/core/models/thread_participant.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/util/serializer.dart';

part 'thread.g.dart';

/// {@template streamThread}
/// A model class representing a thread. Threads are a way to group replies
/// to a message in a channel.
/// {@endtemplate}
@JsonSerializable()
class Thread extends Equatable {
  /// {@macro streamThread}
  Thread({
    this.channel,
    required this.channelCid,
    required this.parentMessageId,
    this.parentMessage,
    required this.createdByUserId,
    this.createdBy,
    required this.replyCount,
    required this.participantCount,
    this.threadParticipants = const [],
    this.lastMessageAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.deletedAt,
    this.title,
    this.latestReplies = const [],
    this.read = const [],
    this.extraData = const {},
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Create a new instance from a json
  factory Thread.fromJson(Map<String, dynamic> json) => _$ThreadFromJson(
      Serializer.moveToExtraDataFromRoot(json, topLevelFields));

  /// The channel cid this thread belongs to.
  final String channelCid;

  /// The channel this thread belongs to.
  final ChannelModel? channel;

  /// The date at which the thread was created.
  final DateTime createdAt;

  /// The date at which the thread was last updated.
  final DateTime updatedAt;

  /// The date at which the thread was deleted.
  final DateTime? deletedAt;

  /// The id of the user who created the thread.
  final String createdByUserId;

  /// The user who created the thread.
  final User? createdBy;

  /// An optional title for the thread.
  final String? title;

  /// The id of the parent message of the thread.
  final String parentMessageId;

  /// The parent message of the thread.
  final Message? parentMessage;

  /// The number of replies in the thread.
  final int replyCount;

  /// The number of users participating in the thread.
  final int participantCount;

  /// The list of users participating in the thread.
  final List<ThreadParticipant> threadParticipants;

  /// The date of the last message in the thread.
  final DateTime? lastMessageAt;

  /// The list of latest replies in the thread.
  final List<Message> latestReplies;

  /// The list of reads in the thread.
  final List<Read>? read;

  /// Map of custom thread extraData
  final Map<String, Object?> extraData;

  /// Serialize to json
  Map<String, dynamic> toJson() =>
      Serializer.moveFromExtraDataToRoot(_$ThreadToJson(this));

  /// Creates a copy of [Thread] with specified attributes overridden.
  Thread copyWith({
    ChannelModel? channel,
    String? channelCid,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? createdByUserId,
    User? createdBy,
    String? title,
    String? parentMessageId,
    Message? parentMessage,
    int? replyCount,
    int? participantCount,
    List<ThreadParticipant>? threadParticipants,
    DateTime? lastMessageAt,
    List<Message>? latestReplies,
    List<Read>? read,
    Map<String, Object?>? extraData,
  }) =>
      Thread(
        channel: channel ?? this.channel,
        channelCid: channelCid ?? this.channelCid,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        createdByUserId: createdByUserId ?? this.createdByUserId,
        createdBy: createdBy ?? this.createdBy,
        title: title ?? this.title,
        parentMessageId: parentMessageId ?? this.parentMessageId,
        parentMessage: parentMessage ?? this.parentMessage,
        replyCount: replyCount ?? this.replyCount,
        participantCount: participantCount ?? this.participantCount,
        threadParticipants: threadParticipants ?? this.threadParticipants,
        lastMessageAt: lastMessageAt ?? this.lastMessageAt,
        latestReplies: latestReplies ?? this.latestReplies,
        read: read ?? this.read,
        extraData: extraData ?? this.extraData,
      );

  /// Known top level fields.
  ///
  /// Useful for [Serializer] methods.
  static const topLevelFields = [
    'channel_cid',
    'channel',
    'created_at',
    'updated_at',
    'deleted_at',
    'created_by_user_id',
    'created_by',
    'title',
    'parent_message_id',
    'parent_message',
    'reply_count',
    'participant_count',
    'thread_participants',
    'last_message_at',
    'latest_replies',
    'read',
  ];

  @override
  List<Object?> get props => [
        channelCid,
        channel,
        createdAt,
        updatedAt,
        deletedAt,
        createdByUserId,
        createdBy,
        title,
        parentMessageId,
        parentMessage,
        replyCount,
        participantCount,
        threadParticipants,
        lastMessageAt,
        latestReplies,
        read,
      ];
}
