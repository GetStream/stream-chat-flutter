import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/comparable_field.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/user.dart';

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
class MessageReminder extends Equatable implements ComparableFieldProvider {
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

  @override
  ComparableField? getComparableField(String sortKey) {
    final value = switch (sortKey) {
      MessageReminderSortKey.channelCid => channelCid,
      MessageReminderSortKey.remindAt => remindAt,
      MessageReminderSortKey.createdAt => createdAt,
      _ => null,
    };

    return ComparableField.fromValue(value);
  }
}

/// Extension type representing sortable fields for [MessageReminder].
///
/// This type provides type-safe keys that can be used for sorting reminders
/// in queries. Each constant represents a field that can be sorted on.
extension type const MessageReminderSortKey(String key) implements String {
  /// Sorts reminders by the channel CID.
  static const channelCid = MessageReminderSortKey('channel_cid');

  /// Sorts reminders by the time at which the user wants to be reminded.
  static const remindAt = MessageReminderSortKey('remind_at');

  /// Sorts reminders by the date at which the reminder was created.
  static const createdAt = MessageReminderSortKey('created_at');
}
