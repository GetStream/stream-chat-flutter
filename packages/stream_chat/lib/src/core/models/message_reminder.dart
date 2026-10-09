import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_core/stream_core.dart' show Filter, FilterField, Sort, SortField;

import 'channel_model.dart';
import 'message.dart';
import 'user.dart';

part 'message_reminder.freezed.dart';

class _NullConst {
  const _NullConst();
}

const _nullConst = _NullConst();

/// {@template messageReminder}
/// A reminder a user set on a message.
///
/// A reminder with a [remindAt] is scheduled: the user is notified about the message at that time. One without it
/// is a bookmark, which keeps the message for later without a notification.
/// {@endtemplate}
@Freezed(copyWith: false)
class MessageReminder with _$MessageReminder {
  /// {@macro messageReminder}
  MessageReminder({
    required this.channelCid,
    this.channel,
    required this.messageId,
    this.message,
    required this.userId,
    this.user,
    this.remindAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// The full id of the channel holding the message, in the form `type:id`.
  @override
  final String channelCid;

  /// The channel holding the message.
  @override
  final ChannelModel? channel;

  /// The id of the message the reminder is set on.
  @override
  final String messageId;

  /// The message the reminder is set on.
  @override
  final Message? message;

  /// The id of the user who set the reminder.
  @override
  final String userId;

  /// The user who set the reminder.
  @override
  final User? user;

  /// The time at which the user wants to be reminded about the message.
  ///
  /// If `null`, the reminder is a bookmark and no notification is sent.
  @override
  final DateTime? remindAt;

  /// The date at which the reminder was created.
  @override
  final DateTime createdAt;

  /// The date at which the reminder was last updated.
  @override
  final DateTime updatedAt;

  /// Creates a copy of this reminder with the given fields replaced.
  ///
  /// A field passed as null keeps its current value, except [remindAt], which a null clears.
  MessageReminder copyWith({
    String? channelCid,
    ChannelModel? channel,
    String? messageId,
    Message? message,
    String? userId,
    User? user,
    Object? remindAt = _nullConst,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MessageReminder(
      channelCid: channelCid ?? this.channelCid,
      channel: channel ?? this.channel,
      messageId: messageId ?? this.messageId,
      message: message ?? this.message,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      remindAt: remindAt == _nullConst ? this.remindAt : remindAt as DateTime?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Returns this reminder with the fields [other] sets.
  ///
  /// A field [other] leaves null keeps its current value, except [remindAt]: a null one clears it. If [other] is
  /// null, this reminder is returned unchanged.
  MessageReminder merge(MessageReminder? other) {
    if (other == null) return this;
    return copyWith(
      channelCid: other.channelCid,
      channel: other.channel,
      messageId: other.messageId,
      message: other.message,
      userId: other.userId,
      user: other.user,
      remindAt: other.remindAt,
      createdAt: other.createdAt,
      updatedAt: other.updatedAt,
    );
  }
}

/// A filter for a reminder query.
///
/// See [MessageReminderFilterField] for the fields that can be filtered on.
///
/// ```dart
/// final filter = MessageReminderFilter.lessOrEqual(
///   MessageReminderFilterField.remindAt,
///   DateTime.timestamp().toIso8601String(),
/// );
/// ```
typedef MessageReminderFilter = Filter<MessageReminder>;

/// Represents a field that reminder queries can be filtered on.
class MessageReminderFilterField extends FilterField<MessageReminder> {
  /// Creates a reminder filter field named [remote] in queries, reading its
  /// value off an instance with [value].
  MessageReminderFilterField(super.remote, super.value);

  /// Filters reminders by the full id of the channel holding the message, in
  /// the form `type:id`.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final channelCid = MessageReminderFilterField(
    'channel_cid',
    (it) => it.channelCid,
  );

  /// Filters reminders by the id of the message they mark.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final messageId = MessageReminderFilterField(
    'message_id',
    (it) => it.messageId,
  );

  /// Filters reminders by the time at which the user wants to be reminded.
  ///
  /// **Supported operators:** `$eq`, `$gt`, `$gte`, `$lt`, `$lte`, `$exists`
  static final remindAt = MessageReminderFilterField(
    'remind_at',
    (it) => it.remindAt,
  );

  /// Filters reminders by their creation date.
  ///
  /// **Supported operators:** `$eq`, `$gt`, `$gte`, `$lt`, `$lte`
  static final createdAt = MessageReminderFilterField(
    'created_at',
    (it) => it.createdAt,
  );
}

/// Represents a sorting operation for message reminders.
///
/// The API accepts only whole combinations, not an arbitrary mix:
/// `channelCid` + `messageId`, `remindAt` + `messageId`, or `createdAt` alone.
/// Anything else is rejected.
///
/// See [MessageReminderSortField] for the fields that can be sorted on.
///
/// ```dart
/// final sort = [MessageReminderSort.asc(MessageReminderSortField.remindAt)];
/// ```
class MessageReminderSort extends Sort<MessageReminder> {
  /// Sorts by [field], smallest first.
  const MessageReminderSort.asc(
    MessageReminderSortField super.field, {
    super.nullOrdering,
  }) : super.asc();

  /// Sorts by [field], largest first.
  const MessageReminderSort.desc(
    MessageReminderSortField super.field, {
    super.nullOrdering,
  }) : super.desc();

  /// An empty sort: the query carries no sort term, and a list keeps the
  /// order it arrived in.
  static const List<MessageReminderSort> empty = [];

  /// The ordering the API applies to a reminder query when none is given.
  ///
  /// Sorts by when the user asked to be reminded, soonest first.
  static final List<MessageReminderSort> defaultSort = [
    MessageReminderSort.asc(MessageReminderSortField.remindAt),
  ];
}

/// Represents a field that reminder queries can be sorted on.
class MessageReminderSortField extends SortField<MessageReminder> {
  /// Creates a field named [remote] in queries, reading its value off an
  /// instance with `localValue`.
  ///
  /// For a name the SDK has not modelled; prefer the fields declared here.
  MessageReminderSortField(super.remote, super.localValue);

  /// Sorts reminders by the channel CID.
  static final channelCid = MessageReminderSortField(
    'channel_cid',
    (it) => it.channelCid,
  );

  /// Sorts reminders by the time at which the user wants to be reminded.
  static final remindAt = MessageReminderSortField(
    'remind_at',
    (it) => it.remindAt,
  );

  /// Sorts reminders by the date at which the reminder was created.
  static final createdAt = MessageReminderSortField(
    'created_at',
    (it) => it.createdAt,
  );

  /// Sorts reminders by the id of the message they are set on.
  ///
  /// Ties break on this field, so naming it explicitly is what makes a page
  /// boundary reproducible.
  static final messageId = MessageReminderSortField(
    'message_id',
    (it) => it.messageId,
  );
}
