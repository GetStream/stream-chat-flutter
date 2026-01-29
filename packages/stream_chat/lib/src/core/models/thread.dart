import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/comparable_field.dart';
import 'package:stream_chat/src/core/models/draft.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/read.dart';
import 'package:stream_chat/src/core/models/thread_participant.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/util/serializer.dart';

part 'thread.g.dart';

class _NullConst {
  const _NullConst();
}

const _nullConst = _NullConst();

/// {@template streamThread}
/// A model class representing a thread. Threads are a way to group replies
/// to a message in a channel.
/// {@endtemplate}
@JsonSerializable()
class Thread extends Equatable implements ComparableFieldProvider {
  /// {@macro streamThread}
  Thread({
    this.activeParticipantCount,
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
    this.draft,
    this.extraData = const {},
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// Create a new instance from a json
  factory Thread.fromJson(Map<String, dynamic> json) =>
      _$ThreadFromJson(Serializer.moveToExtraDataFromRoot(json, topLevelFields));

  /// The active participant count in the thread.
  final int? activeParticipantCount;

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

  /// The list of participants in the thread.
  final List<ThreadParticipant> threadParticipants;

  /// The date of the last message in the thread.
  final DateTime? lastMessageAt;

  /// The list of latest replies in the thread.
  final List<Message> latestReplies;

  /// The list of reads in the thread.
  final List<Read>? read;

  /// The draft message in the thread.
  final Draft? draft;

  /// Map of custom thread extraData
  final Map<String, Object?> extraData;

  /// Serialize to json
  Map<String, dynamic> toJson() => Serializer.moveFromExtraDataToRoot(_$ThreadToJson(this));

  /// Creates a copy of [Thread] with specified attributes overridden.
  Thread copyWith({
    int? activeParticipantCount,
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
    Object? draft = _nullConst,
    Map<String, Object?>? extraData,
  }) => Thread(
    activeParticipantCount: activeParticipantCount ?? this.activeParticipantCount,
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
    draft: draft == _nullConst ? this.draft : draft as Draft?,
    extraData: extraData ?? this.extraData,
  );

  /// Merge this thread with the [other] thread.
  Thread merge(Thread? other) {
    if (other == null) return this;
    return copyWith(
      activeParticipantCount: other.activeParticipantCount,
      channel: other.channel,
      channelCid: other.channelCid,
      createdAt: other.createdAt,
      updatedAt: other.updatedAt,
      deletedAt: other.deletedAt,
      createdByUserId: other.createdByUserId,
      createdBy: other.createdBy,
      title: other.title,
      parentMessageId: other.parentMessageId,
      parentMessage: other.parentMessage,
      replyCount: other.replyCount,
      participantCount: other.participantCount,
      threadParticipants: other.threadParticipants,
      lastMessageAt: other.lastMessageAt,
      latestReplies: other.latestReplies,
      read: other.read,
      draft: other.draft,
      extraData: other.extraData,
    );
  }

  /// Known top level fields.
  ///
  /// Useful for [Serializer] methods.
  static const topLevelFields = [
    'active_participant_count',
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
    'draft',
  ];

  @override
  List<Object?> get props => [
    activeParticipantCount,
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
    draft,
  ];

  @override
  ComparableField? getComparableField(String sortKey) {
    final value = switch (sortKey) {
      ThreadSortKey.lastMessageAt => lastMessageAt,
      ThreadSortKey.createdAt => createdAt,
      ThreadSortKey.updatedAt => updatedAt,
      ThreadSortKey.replyCount => replyCount,
      ThreadSortKey.participantCount => participantCount,
      ThreadSortKey.activeParticipantCount => activeParticipantCount,
      ThreadSortKey.parentMessageId => parentMessageId,
      // TODO: Support providing default value for hasUnread
      ThreadSortKey.hasUnread => null,
      _ => null,
    };

    return ComparableField.fromValue(value);
  }
}

/// Extension type representing sortable fields for [Thread].
///
/// This type provides type-safe keys that can be used for sorting threads
/// in queries. Each constant represents a field that can be sorted on.
extension type const ThreadSortKey(String key) implements String {
  /// Sort threads by their last message date.
  static const lastMessageAt = ThreadSortKey('last_message_at');

  /// Sort threads by their creation date.
  static const createdAt = ThreadSortKey('created_at');

  /// Sort threads by their last update date.
  static const updatedAt = ThreadSortKey('updated_at');

  /// Sort threads by their reply count.
  static const replyCount = ThreadSortKey('reply_count');

  /// Sort threads by their participant count.
  static const participantCount = ThreadSortKey('participant_count');

  /// Sort threads by their active participant count.
  static const activeParticipantCount = ThreadSortKey('active_participant_count');

  /// Sort threads by their parent message id.
  static const parentMessageId = ThreadSortKey('parent_message_id');

  /// Sort threads by their has unread.
  static const hasUnread = ThreadSortKey('has_unread');
}
