import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_core/stream_core.dart'
    show Filter, FilterField, Standard, Sort, SortField, normalizeStringForSort;

import '../util/extension.dart';
import 'user.dart';

part 'member.freezed.dart';

/// The class that contains the information about the user membership
/// in a channel
@freezed
class Member with _$Member {
  /// Creates a member.
  Member({
    this.user,
    this.inviteAcceptedAt,
    this.inviteRejectedAt,
    this.invited = false,
    this.channelRole,
    String? userId,
    this.isModerator = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.banned = false,
    this.banExpires,
    this.shadowBanned = false,
    this.pinnedAt,
    this.archivedAt,
    this.deletedMessages = const [],
    Map<String, Object?> custom = const {},
    this.notificationsMuted,
    this.status,
    this.banFromFutureChannels,
    this.futureChannelBanExpires,
    this.deletedAt,
  }) : userId = userId ?? user?.id,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(),
       custom = {...custom};

  /// The interested user
  @override
  final User? user;

  /// The date in which the user accepted the invite to the channel
  @override
  final DateTime? inviteAcceptedAt;

  /// The date in which the user rejected the invite to the channel
  @override
  final DateTime? inviteRejectedAt;

  /// True if the user has been invited to the channel
  @override
  final bool invited;

  /// The role of this member in the channel
  @override
  final String? channelRole;

  /// The id of the interested user
  @override
  final String? userId;

  /// True if the user is a moderator of the channel
  @override
  final bool isModerator;

  /// True if the member is banned from the channel
  @override
  final bool banned;

  /// The date at which the ban will expire.
  @override
  final DateTime? banExpires;

  /// True if the member is shadow banned from the channel
  @override
  final bool shadowBanned;

  /// The date at which the channel was pinned by the member
  @override
  final DateTime? pinnedAt;

  /// The date at which the channel was archived by the member
  @override
  final DateTime? archivedAt;

  /// The date of creation
  @override
  final DateTime createdAt;

  /// The last date of update
  @override
  final DateTime updatedAt;

  /// List of message ids deleted by this member only for himself.
  ///
  /// These messages are not visible to this member anymore, but are still
  /// visible to other channel members.
  @override
  final List<String> deletedMessages;

  /// This member's custom data.
  @override
  final Map<String, Object?> custom;

  /// Whether this member muted notifications for the channel.
  @override
  final bool? notificationsMuted;

  /// The status of this membership, such as `member`, or `pending` while an
  /// invite is outstanding.
  @override
  final String? status;

  /// Whether this member is banned from future channels.
  ///
  /// The ban covers the channels the channel's creator creates later.
  @override
  final bool? banFromFutureChannels;

  /// The date at which this member's ban from future channels expires.
  ///
  /// Null when there is no such ban or it has no expiry.
  @override
  final DateTime? futureChannelBanExpires;

  /// The date at which this membership was deleted.
  ///
  /// Null while the member belongs to the channel.
  @override
  final DateTime? deletedAt;
}

/// A filter for a member query.
///
/// See [MemberFilterField] for the fields that can be filtered on.
///
/// ```dart
/// final filter = MemberFilter.autoComplete(MemberFilterField.name, 'jo');
/// ```
typedef MemberFilter = Filter<Member>;

/// Represents a field that member queries can be filtered on.
class MemberFilterField extends FilterField<Member> {
  /// Creates a member filter field named [remote] in queries, reading its
  /// value off an instance with [value].
  MemberFilterField(super.remote, super.value);

  /// Creates a field the SDK does not model, read from [Member.custom].
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`,
  /// `$exists`, `$contains`, `$q`, `$autocomplete`
  factory MemberFilterField.custom(String remote) {
    return MemberFilterField(remote, (it) => it.custom[remote]);
  }

  /// Filters members by their user id.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`,
  /// `$exists`
  static final userId = MemberFilterField(
    'user_id',
    (it) => it.userId,
  );

  /// Filters members by their name.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$q`, `$autocomplete`
  static final name = MemberFilterField(
    'name',
    (it) => it.user?.name,
  );

  /// Filters members by their role in the channel.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final channelRole = MemberFilterField(
    'channel_role',
    (it) => it.channelRole,
  );

  /// Filters members by whether they moderate the channel.
  ///
  /// **Supported operators:** `$eq`
  static final isModerator = MemberFilterField(
    'is_moderator',
    (it) => it.isModerator,
  );

  /// Filters members by whether they are banned from the channel.
  ///
  /// **Supported operators:** `$eq`
  static final banned = MemberFilterField(
    'banned',
    (it) => it.banned,
  );

  /// Filters members by the state of their invite.
  ///
  /// One of `pending`, `accepted` or `rejected`. A member who was never
  /// invited has no invite state.
  ///
  /// **Supported operators:** `$eq`
  static final invite = MemberFilterField(
    'invite',
    (it) => switch (it) {
      Member(invited: false) => null,
      Member(inviteAcceptedAt: != null) => 'accepted',
      Member(inviteRejectedAt: != null) => 'rejected',
      _ => 'pending',
    },
  );

  /// Filters members by whether they have joined the channel.
  ///
  /// A member has joined when they were added directly, or accepted the
  /// invite they were sent.
  ///
  /// **Supported operators:** `$eq`
  static final joined = MemberFilterField(
    'joined',
    (it) => !it.invited || it.inviteAcceptedAt != null,
  );

  /// Filters members by when they were last online.
  ///
  /// **Supported operators:** `$eq`, `$gt`, `$gte`, `$lt`, `$lte`
  static final lastActive = MemberFilterField(
    'last_active',
    (it) => it.user?.lastActive,
  );

  /// Filters members by their email address.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$q`, `$autocomplete`
  static final userEmail = MemberFilterField(
    'user.email',
    (it) => it.user?.custom['email'].safeCast<String>(),
  );

  /// Filters members by whether their user is deactivated.
  ///
  /// **Supported operators:** `$eq`
  static final userDeactivated = MemberFilterField(
    'user.nd_deactivated',
    (it) => it.user?.custom['nd_deactivated'].safeCast<bool>(),
  );

  /// Filters members by whether they muted notifications for the channel.
  ///
  /// **Supported operators:** `$eq`
  static final notificationsMuted = MemberFilterField(
    'notifications_muted',
    (it) => it.notificationsMuted,
  );

  /// Filters members by when they joined the channel.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`,
  /// `$exists`
  static final createdAt = MemberFilterField(
    'created_at',
    (it) => it.createdAt,
  );

  /// Filters members by when their membership last changed.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`,
  /// `$exists`
  static final updatedAt = MemberFilterField(
    'updated_at',
    (it) => it.updatedAt,
  );
}

/// Represents a sorting operation for channel members.
///
/// See [MemberSortField] for the fields that can be sorted on.
///
/// ```dart
/// final sort = [MemberSort.asc(MemberSortField.name)];
/// ```
class MemberSort extends Sort<Member> {
  /// Sorts by [field], smallest first.
  const MemberSort.asc(
    MemberSortField super.field, {
    super.nullOrdering,
  }) : super.asc();

  /// Sorts by [field], largest first.
  const MemberSort.desc(
    MemberSortField super.field, {
    super.nullOrdering,
  }) : super.desc();

  /// An empty sort: the query carries no sort term, and a list keeps the
  /// order it arrived in.
  static const List<MemberSort> empty = [];

  /// The ordering the API applies to a member query when none is given.
  ///
  /// Sorts by when the member joined, oldest first.
  static final List<MemberSort> defaultSort = [
    MemberSort.asc(MemberSortField.createdAt),
  ];
}

/// Represents a field that member queries can be sorted on.
class MemberSortField extends SortField<Member> {
  /// Creates a field named [remote] in queries, reading its value off an
  /// instance with `localValue`.
  ///
  /// For a name the SDK has not modelled; prefer the fields declared here.
  MemberSortField(super.remote, super.localValue);

  /// Creates a field the SDK does not model, read from [Member.custom].
  ///
  /// Declared only where the API accepts a custom sort field.
  factory MemberSortField.custom(String remote) {
    return MemberSortField(remote, (it) => it.custom[remote]);
  }

  /// Sorts members by their creation date in the channel.
  static final createdAt = MemberSortField(
    'created_at',
    (it) => it.createdAt,
  );

  /// Sorts members by the user ID.
  static final userId = MemberSortField(
    'user_id',
    (it) => it.userId,
  );

  /// Sorts members by user name.
  ///
  /// Compared with case, diacritics and ligatures folded away, so a list
  /// sorted locally matches the order a query returns.
  ///
  /// Slower than the other member sorts.
  static final name = MemberSortField(
    'name',
    (it) => it.user?.name?.let(normalizeStringForSort),
  );

  /// Sorts members by the channel role.
  static final channelRole = MemberSortField(
    'channel_role',
    (it) => it.channelRole,
  );

  /// Sorts members by the date their membership was last updated.
  static final updatedAt = MemberSortField(
    'updated_at',
    (it) => it.updatedAt,
  );
}
