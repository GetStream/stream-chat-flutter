import 'package:json_annotation/json_annotation.dart';
import 'package:stream_core/stream_core.dart' show NullOrdering, Sort, SortDirection, SortField, Standard;
import '../util/string_sort_normalizer.dart';
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

/// Represents a sorting operation for channels.
///
/// Keeps [ChannelSortField.pinnedAt] and [ChannelSortField.lastMessageAt]
/// nulls-last in either direction, the way the API orders them, unless a
/// `nullOrdering` says otherwise.
///
/// See [ChannelSortField] for the fields that can be sorted on.
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

  // The direction the API wrote. Anything other than descending's value is
  // ascending, which is how the API reads it — so a direction it did not
  // write, or none at all, is ascending rather than an error.
  //
  // Stays here rather than on `SortDirection`: json_serializable decodes an
  // enum through its generated value map, never a `fromJson` static, so one
  // upstream would be reachable only by hand.
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

  // Keyed on the remote name rather than the field instance, so a field built
  // by hand for a name the API pins is ordered the same way ours is.
  static NullOrdering _orderingFor(ChannelSortField field, NullOrdering fallback) {
    if (_nullsLastFields.contains(field.remote)) return NullOrdering.nullsLast;
    return fallback;
  }

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
  /// Creates a channel sort field named [remote] on the wire, reading its
  /// value off an instance with `localValue`.
  ///
  /// Prefer the fields this class declares — they are the ones the API accepts.
  /// This is for a field the SDK has not modelled yet.
  ChannelSortField(super.remote, super.localValue);

  /// Creates a field the SDK does not model, read from [ChannelModel.extraData].
  ///
  /// Only declared for the models whose queries accept a custom sort field,
  /// and slower than a field this class declares.
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

  // Every field declared above.
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

  // Keyed off the fields themselves, so a remote name is written once.
  static final _byRemote = {for (final field in _fields) field.remote: field};

  /// The field [remote] names, or a [ChannelSortField.custom] one when the SDK
  /// does not model it.
  ///
  /// A name the API has added and this SDK has not caught up with still sorts
  /// correctly. A name this SDK models as a channel property but does not
  /// declare as a sort field does not: the query carries it, but a list sorted
  /// locally ignores that term.
  static ChannelSortField fromRemote(String remote) {
    return _byRemote[remote] ?? ChannelSortField.custom(remote);
  }
}
