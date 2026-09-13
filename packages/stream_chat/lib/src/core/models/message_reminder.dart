import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_core/stream_core.dart' show Sort, SortField;

import 'channel_model.dart';
import 'message.dart';
import 'user.dart';

part 'message_reminder.g.dart';

class _NullConst {
  const _NullConst();
}

const _nullConst = _NullConst();

/// {@template messageReminder}
/// A model class representing a message reminder.
///
/// The [MessageReminder] class represents a marked message that is important
/// to the user.
///
/// It can be of two types:
/// 1. **Scheduled Reminder**: (`remindAt != null`) - Used to notify the user
/// about a message after a certain time.
/// 2. **Bookmarks**: (`remindAt == null`) - Used to mark a message for later
/// reference without notification.
/// {@endtemplate}
@JsonSerializable()
class MessageReminder extends Equatable {
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

  /// Create a new instance from a json
  factory MessageReminder.fromJson(Map<String, dynamic> json) => _$MessageReminderFromJson(json);

  /// The channel CID where the message exists.
  final String channelCid;

  /// The channel where the message exists.
  @JsonKey(includeToJson: false)
  final ChannelModel? channel;

  /// The ID of the message that is marked as important.
  final String messageId;

  /// The message that is marked as important.
  @JsonKey(includeToJson: false)
  final Message? message;

  /// The ID of the user who marked the message as important.
  final String userId;

  /// The user who marked the message as important.
  @JsonKey(includeToJson: false)
  final User? user;

  /// The time at which the user wants to be reminded about the message.
  ///
  /// If `null`, the reminder is a bookmark and no notification will be sent.
  final DateTime? remindAt;

  /// The date at which the reminder was created.
  final DateTime createdAt;

  /// The date at which the reminder was last updated.
  final DateTime updatedAt;

  /// Convert the object to JSON
  Map<String, dynamic> toJson() => _$MessageReminderToJson(this);

  /// Creates a copy of this [Draft] with specified attributes overridden.
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

  /// Returns a new [MessageReminder] instance that merges the current
  /// instance with another [MessageReminder] instance.
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

  @override
  List<Object?> get props => [
    channelCid,
    channel,
    messageId,
    message,
    userId,
    user,
    remindAt,
    createdAt,
    updatedAt,
  ];
}

/// Represents a sorting operation for message reminders.
///
/// The API accepts only whole combinations, not an arbitrary mix:
/// `channelCid` + `messageId`, `remindAt` + `messageId`, or `createdAt` alone.
/// Anything else is rejected.
///
/// See [MessageReminderSortField] for the fields that can be sorted on.
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
  /// Creates a field named [remote] on the wire, reading its value off an
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
