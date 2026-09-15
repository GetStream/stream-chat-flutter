import 'package:json_annotation/json_annotation.dart';
import 'package:stream_core/stream_core.dart'
    show Filter, FilterField, NullOrdering, Sort, SortDirection, SortField, Standard, normalizeStringForSort;
import 'channel_model.dart';
import 'draft.dart';
import 'location.dart';
import 'member.dart';
import 'message.dart';
import 'push_preference.dart';
import 'read.dart';
import 'user.dart';

part 'channel_state.g.dart';

class _NullConst {
  const _NullConst();
}

const _nullConst = _NullConst();

/// The class that contains the information about a channel
@JsonSerializable()
class ChannelState {
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
    this.pendingMessages,
    this.pushPreferences,
    this.activeLiveLocations,
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

  static Object? _pendingMessagesReadValue(
    Map<Object?, Object?> json,
    String key,
  ) {
    final pendingMessageResponse = json[key];
    if (pendingMessageResponse is! List<Object?>) return null;

    final value = pendingMessageResponse.map((it) {
      if (it is! Map<String, Object?>) return null;
      return it['message'];
    }).nonNulls;

    if (value.isEmpty) return null;
    return value.toList(growable: false);
  }

  /// List of messages pending for moderation on this channel.
  ///
  /// These messages are only visible to the author until they are approved.
  @JsonKey(readValue: _pendingMessagesReadValue)
  final List<Message>? pendingMessages;

  /// The push preferences for this channel if it exists.
  final ChannelPushPreference? pushPreferences;

  /// The list of active live locations in the channel.
  final List<Location>? activeLiveLocations;

  /// Create a new instance from a json
  static ChannelState fromJson(Map<String, dynamic> json) => _$ChannelStateFromJson(json);

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
    List<Message>? pendingMessages,
    ChannelPushPreference? pushPreferences,
    List<Location>? activeLiveLocations,
  }) => ChannelState(
    channel: channel ?? this.channel,
    messages: messages ?? this.messages,
    members: members ?? this.members,
    pinnedMessages: pinnedMessages ?? this.pinnedMessages,
    watcherCount: watcherCount ?? this.watcherCount,
    watchers: watchers ?? this.watchers,
    read: read ?? this.read,
    membership: membership ?? this.membership,
    draft: draft == _nullConst ? this.draft : draft as Draft?,
    pendingMessages: pendingMessages ?? this.pendingMessages,
    pushPreferences: pushPreferences ?? this.pushPreferences,
    activeLiveLocations: activeLiveLocations ?? this.activeLiveLocations,
  );
}

/// A filter for a channel query.
///
/// See [ChannelFilterField] for the fields that can be filtered on.
///
/// ```dart
/// final filter = ChannelFilter.and([
///   ChannelFilter.equal(ChannelFilterField.type, 'messaging'),
///   ChannelFilter.in_(ChannelFilterField.members, [user.id]),
/// ]);
/// ```
typedef ChannelFilter = Filter<ChannelState>;

/// Represents a field that channel queries can be filtered on.
class ChannelFilterField extends FilterField<ChannelState> {
  /// Creates a channel filter field named [remote] on the wire, reading its
  /// value off an instance with [value].
  ChannelFilterField(super.remote, super.value);

  /// Creates a field the SDK does not model, read from [ChannelModel.extraData].
  ///
  /// The fields the server computes per request — `joined`, `has_unread`,
  /// `invite`, `distinct` and `app_banned` — are reached this way. The server
  /// resolves them against the caller; a local match cannot.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`, `$exists`,
  /// `$contains`, `$q`, `$autocomplete`
  factory ChannelFilterField.custom(String remote) {
    return ChannelFilterField(remote, (it) => it.channel?.extraData[remote]);
  }

  /// Filters channels by their id.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`, `$exists`
  static final id = ChannelFilterField(
    'id',
    (it) => it.channel?.id,
  );

  /// Filters channels by their full id, in the form `type:id`.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`, `$exists`
  static final cid = ChannelFilterField(
    'cid',
    (it) => it.channel?.cid,
  );

  /// Filters channels by their type.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`, `$exists`
  static final type = ChannelFilterField(
    'type',
    (it) => it.channel?.type,
  );

  /// Filters channels by their name.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`, `$exists`, `$q`,
  /// `$autocomplete`
  static final name = ChannelFilterField(
    'name',
    (it) => it.channel?.name,
  );

  /// Filters channels by the id of the user who created them.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`, `$exists`
  static final createdById = ChannelFilterField(
    'created_by_id',
    (it) => it.channel?.createdBy?.id,
  );

  /// Filters channels by the team they belong to.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`, `$exists`
  static final team = ChannelFilterField(
    'team',
    (it) => it.channel?.team,
  );

  /// Filters channels by whether they are frozen.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`, `$exists`
  static final frozen = ChannelFilterField(
    'frozen',
    (it) => it.channel?.frozen,
  );

  /// Filters channels by the date they were created.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`, `$exists`
  static final createdAt = ChannelFilterField(
    'created_at',
    (it) => it.channel?.createdAt,
  );

  /// Filters channels by the date they were updated.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`, `$exists`
  static final updatedAt = ChannelFilterField(
    'updated_at',
    (it) => it.channel?.updatedAt,
  );

  /// Filters channels by the timestamp of the last message.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`, `$exists`
  static final lastMessageAt = ChannelFilterField(
    'last_message_at',
    (it) => it.channel?.lastMessageAt,
  );

  /// Filters channels by their last activity.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`, `$exists`
  static final lastUpdated = ChannelFilterField(
    'last_updated',
    (it) => it.channel?.lastUpdatedAt,
  );

  /// Filters channels by the number of members.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`, `$exists`
  static final memberCount = ChannelFilterField(
    'member_count',
    (it) => it.channel?.memberCount,
  );

  /// Filters channels by the number of messages.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`, `$exists`
  static final messageCount = ChannelFilterField(
    'message_count',
    (it) => it.channel?.messageCount,
  );

  /// Filters channels by their members.
  ///
  /// `$eq` matches a channel whose members are exactly the given users, the
  /// way a distinct channel is looked up. `$in` matches a channel any of them
  /// belong to.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final members = ChannelFilterField(
    'members',
    (it) => it.members?.map((it) => it.userId),
  );

  /// Filters channels by the name of any of their members.
  ///
  /// **Supported operators:** `$eq`, `$autocomplete`
  static final memberUserName = ChannelFilterField(
    'member.user.name',
    (it) => it.members?.map((it) => it.user?.name),
  );

  /// Filters channels by the current user's role in them.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final channelRole = ChannelFilterField(
    'channel_role',
    (it) => it.membership?.channelRole,
  );

  /// Filters channels by whether the current user pinned them.
  ///
  /// **Supported operators:** `$eq`
  static final pinned = ChannelFilterField(
    'pinned',
    (it) => it.membership?.pinnedAt != null,
  );

  /// Filters channels by whether the current user hid them.
  ///
  /// **Supported operators:** `$eq`
  static final hidden = ChannelFilterField(
    'hidden',
    (it) => it.channel?.hidden,
  );

  /// Filters channels by whether the current user muted them.
  ///
  /// **Supported operators:** `$eq`
  static final muted = ChannelFilterField(
    'muted',
    (it) => it.channel?.muted,
  );

  /// Filters channels by whether the current user blocked them.
  ///
  /// **Supported operators:** `$eq`
  static final blocked = ChannelFilterField(
    'blocked',
    (it) => it.channel?.blocked,
  );

  /// Filters channels by whether they are disabled.
  ///
  /// **Supported operators:** `$eq`
  static final disabled = ChannelFilterField(
    'disabled',
    (it) => it.channel?.disabled,
  );

  /// Filters channels by whether the current user archived them.
  ///
  /// **Supported operators:** `$eq`
  static final archived = ChannelFilterField(
    'archived',
    (it) => it.membership?.archivedAt != null,
  );
}

/// Represents a sorting operation for channels.
///
/// Keeps [ChannelSortField.pinnedAt] and [ChannelSortField.lastMessageAt]
/// nulls-last in either direction, the way the API orders them, unless a
/// `nullOrdering` says otherwise.
///
/// See [ChannelSortField] for the fields that can be sorted on.
///
/// ```dart
/// final sort = [
///   ChannelSort.desc(ChannelSortField.pinnedAt),
///   ChannelSort.desc(ChannelSortField.lastMessageAt),
/// ];
/// ```
class ChannelSort extends Sort<ChannelState> {
  /// Sorts by [field], smallest first.
  ChannelSort.asc(
    ChannelSortField super.field, {
    NullOrdering? nullOrdering,
  }) : super.asc(nullOrdering: nullOrdering ?? _orderingFor(field, .nullsLast));

  /// Sorts by [field], largest first.
  ChannelSort.desc(
    ChannelSortField super.field, {
    NullOrdering? nullOrdering,
  }) : super.desc(nullOrdering: nullOrdering ?? _orderingFor(field, .nullsFirst));

  /// Reads a sort back from the `{'field': …, 'direction': ±1}` shape [Sort]
  /// serializes to.
  factory ChannelSort.fromJson(Map<String, dynamic> json) {
    final field = ChannelSortField.fromRemote(json['field'] as String);

    return switch (_directionFromJson(json['direction'])) {
      SortDirection.asc => ChannelSort.asc(field),
      SortDirection.desc => ChannelSort.desc(field),
    };
  }

  // Anything other than descending's value reads as ascending, which is how
  // the API reads it — so an absent or unknown direction is not an error.
  static SortDirection _directionFromJson(Object? value) {
    if (value == SortDirection.desc.value) return SortDirection.desc;
    return SortDirection.asc;
  }

  // The fields the API orders nulls-last whichever way they are sorted, so a
  // channel with no messages and one that is not pinned stay at the end.
  static final _nullsLastFields = {
    ChannelSortField.pinnedAt.remote,
    ChannelSortField.lastMessageAt.remote,
  };

  // Keyed on the remote name, so a field built by hand for a pinned name is
  // ordered the same way.
  static NullOrdering _orderingFor(ChannelSortField field, NullOrdering fallback) {
    if (_nullsLastFields.contains(field.remote)) return NullOrdering.nullsLast;
    return fallback;
  }

  /// An empty sort: the query carries no sort term, and a list keeps the
  /// order it arrived in.
  static const List<ChannelSort> empty = [];

  /// The ordering the API applies to a channel query when none is given.
  ///
  /// Sorts by the last message date, or the channel creation date when it has
  /// no messages.
  static final List<ChannelSort> defaultSort = [
    ChannelSort.desc(ChannelSortField.lastUpdated),
  ];
}

/// Represents a field that channel queries can be sorted on.
class ChannelSortField extends SortField<ChannelState> {
  /// Creates a field named [remote] on the wire, reading its value off an
  /// instance with `localValue`.
  ///
  /// For a name the SDK has not modelled; prefer the fields declared here.
  ChannelSortField(super.remote, super.localValue);

  /// Creates a field the SDK does not model, read from [ChannelModel.extraData].
  ///
  /// Declared only where the API accepts a custom sort field.
  ///
  /// String values are compared as they are, without the case and diacritic
  /// folding a declared name field applies.
  factory ChannelSortField.custom(String remote) {
    return ChannelSortField(remote, (it) => it.channel?.extraData[remote]);
  }

  /// Sorts channels by their last activity.
  ///
  /// The date of the last message, or the channel creation date when it has
  /// none.
  static final lastUpdated = ChannelSortField(
    'last_updated',
    (it) => it.channel?.lastUpdatedAt,
  );

  /// Sorts channels by their channel id.
  static final cid = ChannelSortField(
    'cid',
    (it) => it.channel?.cid,
  );

  /// Sorts channels by their name.
  ///
  /// Compares the folded form, so a name differing only by case, a diacritic
  /// or a ligature sorts where a reader expects it rather than after Z.
  static final name = ChannelSortField(
    'name',
    (it) => it.channel?.name?.let(normalizeStringForSort),
  );

  /// Sorts channels by the date they were created.
  static final createdAt = ChannelSortField(
    'created_at',
    (it) => it.channel?.createdAt,
  );

  /// Sorts channels by the date they were updated.
  static final updatedAt = ChannelSortField(
    'updated_at',
    (it) => it.channel?.updatedAt,
  );

  /// Sorts channels by the timestamp of the last message.
  ///
  /// Channels with no messages come last whichever direction this is sorted
  /// in.
  static final lastMessageAt = ChannelSortField(
    'last_message_at',
    (it) => it.channel?.lastMessageAt,
  );

  /// Sorts channels by the number of members.
  static final memberCount = ChannelSortField(
    'member_count',
    (it) => it.channel?.memberCount,
  );

  /// Sorts channels by whether they have unread messages.
  ///
  /// Useful for grouping read and unread channels.
  // TODO: Support providing default value for hasUnread
  static final hasUnread = ChannelSortField(
    'has_unread',
    (_) => null,
  );

  /// Sorts channels by the count of unread messages.
  // TODO: Support providing default value for unreadCount
  static final unreadCount = ChannelSortField(
    'unread_count',
    (_) => null,
  );

  /// Sorts channels by the date they were pinned.
  ///
  /// Unpinned channels come last whichever direction this is sorted in.
  static final pinnedAt = ChannelSortField(
    'pinned_at',
    (it) => it.membership?.pinnedAt,
  );

  static final _fields = [
    lastUpdated,
    cid,
    name,
    createdAt,
    updatedAt,
    lastMessageAt,
    memberCount,
    hasUnread,
    unreadCount,
    pinnedAt,
  ];

  static final _byRemote = {for (final field in _fields) field.remote: field};

  /// The field [remote] names, or a [ChannelSortField.custom] one when the SDK
  /// does not model it.
  ///
  /// An undeclared name still sorts the query correctly, but reads nothing
  /// locally, so a list sorted on it keeps the order it arrived in.
  static ChannelSortField fromRemote(String remote) {
    return _byRemote[remote] ?? ChannelSortField.custom(remote);
  }
}
