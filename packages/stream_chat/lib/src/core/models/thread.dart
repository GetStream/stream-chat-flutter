import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_core/stream_core.dart' show Filter, FilterField, NullOrdering, Sort, SortField;

import 'channel_model.dart';
import 'draft.dart';
import 'message.dart';
import 'read.dart';
import 'thread_participant.dart';
import 'user.dart';

part 'thread.freezed.dart';

/// {@template streamThread}
/// A thread of replies to a message in a channel.
/// {@endtemplate}
@freezed
class Thread with _$Thread {
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
    this.custom = const {},
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// The active participant count in the thread.
  @override
  final int? activeParticipantCount;

  /// The channel cid this thread belongs to.
  @override
  final String channelCid;

  /// The channel this thread belongs to.
  @override
  final ChannelModel? channel;

  /// The date at which the thread was created.
  @override
  final DateTime createdAt;

  /// The date at which the thread was last updated.
  @override
  final DateTime updatedAt;

  /// The date at which the thread was deleted.
  @override
  final DateTime? deletedAt;

  /// The id of the user who created the thread.
  @override
  final String createdByUserId;

  /// The user who created the thread.
  @override
  final User? createdBy;

  /// An optional title for the thread.
  @override
  final String? title;

  /// The id of the parent message of the thread.
  @override
  final String parentMessageId;

  /// The parent message of the thread.
  @override
  final Message? parentMessage;

  /// The number of replies in the thread.
  @override
  final int replyCount;

  /// The number of users participating in the thread.
  @override
  final int participantCount;

  /// The list of participants in the thread.
  @override
  final List<ThreadParticipant> threadParticipants;

  /// The date of the last message in the thread.
  @override
  final DateTime? lastMessageAt;

  /// The list of latest replies in the thread.
  @override
  final List<Message> latestReplies;

  /// The list of reads in the thread.
  @override
  final List<Read>? read;

  /// The draft message in the thread.
  @override
  final Draft? draft;

  /// This thread's custom data.
  @override
  final Map<String, Object?> custom;

  /// A copy of this thread updated with the fields [other] carries.
  ///
  /// A nullable field [other] leaves null keeps this thread's value, except
  /// [draft], which is always taken from [other].
  ///
  /// Every other field, [custom] included, takes the value of [other]. Returns
  /// this thread when [other] is null.
  Thread merge(Thread? other) {
    if (other == null) return this;
    return Thread(
      activeParticipantCount: other.activeParticipantCount ?? activeParticipantCount,
      channel: other.channel ?? channel,
      channelCid: other.channelCid,
      parentMessageId: other.parentMessageId,
      parentMessage: other.parentMessage ?? parentMessage,
      createdByUserId: other.createdByUserId,
      createdBy: other.createdBy ?? createdBy,
      replyCount: other.replyCount,
      participantCount: other.participantCount,
      threadParticipants: other.threadParticipants,
      lastMessageAt: other.lastMessageAt ?? lastMessageAt,
      createdAt: other.createdAt,
      updatedAt: other.updatedAt,
      deletedAt: other.deletedAt ?? deletedAt,
      title: other.title ?? title,
      latestReplies: other.latestReplies,
      read: other.read ?? read,
      draft: other.draft,
      custom: other.custom,
    );
  }
}

/// A filter for a thread query.
///
/// See [ThreadFilterField] for the fields that can be filtered on.
///
/// ```dart
/// final filter = ThreadFilter.equal(
///   ThreadFilterField.channelCid,
///   'messaging:general',
/// );
/// ```
typedef ThreadFilter = Filter<Thread>;

/// Represents a field that thread queries can be filtered on.
class ThreadFilterField extends FilterField<Thread> {
  /// Creates a thread filter field named [remote] in queries, reading its
  /// value off an instance with [value].
  ThreadFilterField(super.remote, super.value);

  /// Creates a field the SDK does not model, read from [Thread.custom].
  ///
  /// `has_unread` is reached this way. It depends on the caller's read state,
  /// so a local match cannot reproduce it.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`,
  /// `$exists`, `$contains`, `$q`, `$autocomplete`
  factory ThreadFilterField.custom(String remote) {
    return ThreadFilterField(remote, (it) => it.custom[remote]);
  }

  /// Filters threads by the full id of the channel they belong to, in the form
  /// `type:id`.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final channelCid = ThreadFilterField(
    'channel_cid',
    (it) => it.channelCid,
  );

  /// Filters threads by the id of their parent message.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final parentMessageId = ThreadFilterField(
    'parent_message_id',
    (it) => it.parentMessageId,
  );

  /// Filters threads by the id of the user who created them.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final createdByUserId = ThreadFilterField(
    'created_by_user_id',
    (it) => it.createdByUserId,
  );

  /// Filters threads by how many replies they have.
  ///
  /// **Supported operators:** `$eq`, `$gt`, `$gte`, `$lt`, `$lte`
  static final replyCount = ThreadFilterField(
    'reply_count',
    (it) => it.replyCount,
  );

  /// Filters threads by how many users have participated in them.
  ///
  /// **Supported operators:** `$eq`, `$gt`, `$gte`, `$lt`, `$lte`
  static final participantCount = ThreadFilterField(
    'participant_count',
    (it) => it.participantCount,
  );

  /// Filters threads by how many participants are currently active.
  ///
  /// **Supported operators:** `$eq`, `$gt`, `$gte`, `$lt`, `$lte`
  static final activeParticipantCount = ThreadFilterField(
    'active_participant_count',
    (it) => it.activeParticipantCount,
  );

  /// Filters threads by the date of their last message.
  ///
  /// **Supported operators:** `$eq`, `$gt`, `$gte`, `$lt`, `$lte`
  static final lastMessageAt = ThreadFilterField(
    'last_message_at',
    (it) => it.lastMessageAt,
  );

  /// Filters threads by their creation date.
  ///
  /// **Supported operators:** `$eq`, `$gt`, `$gte`, `$lt`, `$lte`
  static final createdAt = ThreadFilterField(
    'created_at',
    (it) => it.createdAt,
  );

  /// Filters threads by their last update date.
  ///
  /// **Supported operators:** `$eq`, `$gt`, `$gte`, `$lt`, `$lte`
  static final updatedAt = ThreadFilterField(
    'updated_at',
    (it) => it.updatedAt,
  );

  /// Filters threads by the team of the channel they belong to.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final channelTeam = ThreadFilterField(
    'channel.team',
    (it) => it.channel?.team,
  );

  /// Filters threads by whether the channel they belong to is disabled.
  ///
  /// **Supported operators:** `$eq`
  static final channelDisabled = ThreadFilterField(
    'channel.disabled',
    (it) => it.channel?.disabled,
  );
}

/// Represents a sorting operation for threads.
///
/// The API accepts only whole combinations, not an arbitrary mix:
/// `hasUnread` + `lastMessageAt` + `parentMessageId`, `lastMessageAt` +
/// `parentMessageId`, or any one of `createdAt`, `updatedAt`, `replyCount`,
/// `participantCount`, `activeParticipantCount` and `parentMessageId` alone.
/// Anything else is rejected.
///
/// See [ThreadSortField] for the fields that can be sorted on.
///
/// ```dart
/// final sort = [ThreadSort.desc(ThreadSortField.lastMessageAt)];
/// ```
class ThreadSort extends Sort<Thread> {
  /// Sorts by [field], smallest first.
  ThreadSort.asc(
    ThreadSortField super.field, {
    NullOrdering? nullOrdering,
  }) : super.asc(nullOrdering: nullOrdering ?? _orderingFor(field, .nullsLast));

  /// Sorts by [field], largest first.
  ThreadSort.desc(
    ThreadSortField super.field, {
    NullOrdering? nullOrdering,
  }) : super.desc(nullOrdering: nullOrdering ?? _orderingFor(field, .nullsFirst));

  // A thread the SDK has no last-message date for belongs at the end whichever
  // way the list is sorted. Not API parity: the API's own date is never absent.
  static final _nullsLastFields = {ThreadSortField.lastMessageAt.remote};

  // Keyed on the remote name, so a field built by hand for a pinned name is
  // ordered the same way.
  static NullOrdering _orderingFor(ThreadSortField field, NullOrdering fallback) {
    if (_nullsLastFields.contains(field.remote)) return NullOrdering.nullsLast;
    return fallback;
  }

  /// An empty sort: the query carries no sort term, and a list keeps the
  /// order it arrived in.
  static const List<ThreadSort> empty = [];
}

/// Represents a field that thread queries can be sorted on.
class ThreadSortField extends SortField<Thread> {
  /// Creates a field named [remote] in queries, reading its value off an
  /// instance with `localValue`.
  ///
  /// For a name the SDK has not modelled; prefer the fields declared here.
  ThreadSortField(super.remote, super.localValue);

  /// Sorts threads by their last message date.
  static final lastMessageAt = ThreadSortField(
    'last_message_at',
    (it) => it.lastMessageAt,
  );

  /// Sorts threads by their creation date.
  static final createdAt = ThreadSortField(
    'created_at',
    (it) => it.createdAt,
  );

  /// Sorts threads by their last update date.
  static final updatedAt = ThreadSortField(
    'updated_at',
    (it) => it.updatedAt,
  );

  /// Sorts threads by their reply count.
  static final replyCount = ThreadSortField(
    'reply_count',
    (it) => it.replyCount,
  );

  /// Sorts threads by their participant count.
  static final participantCount = ThreadSortField(
    'participant_count',
    (it) => it.participantCount,
  );

  /// Sorts threads by their active participant count.
  static final activeParticipantCount = ThreadSortField(
    'active_participant_count',
    (it) => it.activeParticipantCount,
  );

  /// Sorts threads by their parent message id.
  static final parentMessageId = ThreadSortField(
    'parent_message_id',
    (it) => it.parentMessageId,
  );

  /// Sorts threads by whether they have unread replies.
  // TODO: Support providing default value for hasUnread
  static final hasUnread = ThreadSortField(
    'has_unread',
    (_) => null,
  );
}
