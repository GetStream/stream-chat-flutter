import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/comparable_field.dart';
import 'package:stream_chat/src/core/models/draft.dart';
import 'package:stream_chat/src/core/models/member.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/push_preference.dart';
import 'package:stream_chat/src/core/models/read.dart';
import 'package:stream_chat/src/core/models/user.dart';

part 'channel_state.g.dart';

class _NullConst {
  const _NullConst();
}

const _nullConst = _NullConst();

/// The class that contains the information about a channel
@JsonSerializable()
class ChannelState implements ComparableFieldProvider {
  /// Constructor used for json serialization
  const ChannelState({
    this.channel,
    this.messages,
    this.members,
    this.pinnedMessages,
    this.watcherCount,
    this.watchers,
    this.read,
    this.membership,
    this.draft,
    this.pushPreferences,
  });

  /// The channel to which this state belongs
  final ChannelModel? channel;

  /// A paginated list of channel messages
  final List<Message>? messages;

  /// A paginated list of channel members
  final List<Member>? members;

  /// A paginated list of pinned messages
  final List<Message>? pinnedMessages;

  /// The count of users watching the channel
  final int? watcherCount;

  /// A paginated list of users watching the channel
  final List<User>? watchers;

  /// The list of channel reads
  final List<Read>? read;

  /// Relationship of the current user to this channel.
  final Member? membership;

  /// The draft message for this channel if it exists.
  final Draft? draft;

  /// The push preferences for this channel if it exists.
  final ChannelPushPreference? pushPreferences;

  /// Create a new instance from a json
  static ChannelState fromJson(Map<String, dynamic> json) =>
      _$ChannelStateFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ChannelStateToJson(this);

  /// Creates a copy of [ChannelState] with specified attributes overridden.
  ChannelState copyWith({
    ChannelModel? channel,
    List<Message>? messages,
    List<Member>? members,
    List<Message>? pinnedMessages,
    int? watcherCount,
    List<User>? watchers,
    List<Read>? read,
    Member? membership,
    Object? draft = _nullConst,
    ChannelPushPreference? pushPreferences,
  }) =>
      ChannelState(
        channel: channel ?? this.channel,
        messages: messages ?? this.messages,
        members: members ?? this.members,
        pinnedMessages: pinnedMessages ?? this.pinnedMessages,
        watcherCount: watcherCount ?? this.watcherCount,
        watchers: watchers ?? this.watchers,
        read: read ?? this.read,
        membership: membership ?? this.membership,
        draft: draft == _nullConst ? this.draft : draft as Draft?,
        pushPreferences: pushPreferences ?? this.pushPreferences,
      );

  @override
  ComparableField? getComparableField(String sortKey) {
    final value = switch (sortKey) {
      ChannelSortKey.lastUpdated => channel?.lastUpdatedAt,
      ChannelSortKey.createdAt => channel?.createdAt,
      ChannelSortKey.updatedAt => channel?.updatedAt,
      ChannelSortKey.lastMessageAt => channel?.lastMessageAt,
      ChannelSortKey.memberCount => channel?.memberCount,
      ChannelSortKey.pinnedAt => membership?.pinnedAt,
      // TODO: Support providing default value for hasUnread, unreadCount
      ChannelSortKey.hasUnread => null,
      ChannelSortKey.unreadCount => null,
      _ => channel?.extraData[sortKey],
    };

    return ComparableField.fromValue(value);
  }
}

/// Extension type representing sortable fields for [ChannelState].
///
/// This type provides type-safe keys that can be used for sorting channels
/// in queries. Each constant represents a field that can be sorted on.
extension type const ChannelSortKey(String key) implements String {
  /// The default sorting is by the last message date or a channel created date
  /// if no messages.
  static const lastUpdated = ChannelSortKey('last_updated');

  /// Sort channels by the date they were created.
  static const createdAt = ChannelSortKey('created_at');

  /// Sort channels by the date they were updated.
  static const updatedAt = ChannelSortKey('updated_at');

  /// Sort channels by the timestamp of the last message.
  static const lastMessageAt = ChannelSortKey('last_message_at');

  /// Sort channels by the number of members.
  static const memberCount = ChannelSortKey('member_count');

  /// Sort channels by whether they have unread messages.
  /// Useful for grouping read and unread channels.
  static const hasUnread = ChannelSortKey('has_unread');

  /// Sort channels by the count of unread messages.
  static const unreadCount = ChannelSortKey('unread_count');

  /// Sort channels by the date they were pinned.
  static const pinnedAt = ChannelSortKey('pinned_at');
}
