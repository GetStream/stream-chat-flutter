import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_core/stream_core.dart'
    show Filter, FilterField, Standard, Sort, SortField, normalizeStringForSort;

import '../util/extension.dart';
import '../util/serializer.dart';
import 'user.dart';

part 'member.g.dart';

/// The class that contains the information about the user membership
/// in a channel
@JsonSerializable()
class Member extends Equatable {
  /// Constructor used for json serialization
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
    this.extraData = const {},
  }) : userId = userId ?? user?.id,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// Create a new instance from a json
  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(
    Serializer.moveToExtraDataFromRoot(json, _topLevelFields),
  );

  /// Known top level fields.
  ///
  /// Useful for [Serializer] methods.
  static const _topLevelFields = [
    'user',
    'invite_accepted_at',
    'invite_rejected_at',
    'invited',
    'channel_role',
    'user_id',
    'is_moderator',
    'banned',
    'ban_expires',
    'shadow_banned',
    'created_at',
    'updated_at',
    'pinned_at',
    'archived_at',
    'deleted_messages',
  ];

  /// The interested user
  final User? user;

  /// The date in which the user accepted the invite to the channel
  final DateTime? inviteAcceptedAt;

  /// The date in which the user rejected the invite to the channel
  final DateTime? inviteRejectedAt;

  /// True if the user has been invited to the channel
  final bool invited;

  /// The role of this member in the channel
  final String? channelRole;

  /// The id of the interested user
  final String? userId;

  /// True if the user is a moderator of the channel
  final bool isModerator;

  /// True if the member is banned from the channel
  final bool banned;

  /// The date at which the ban will expire.
  final DateTime? banExpires;

  /// True if the member is shadow banned from the channel
  final bool shadowBanned;

  /// The date at which the channel was pinned by the member
  final DateTime? pinnedAt;

  /// The date at which the channel was archived by the member
  final DateTime? archivedAt;

  /// The date of creation
  final DateTime createdAt;

  /// The last date of update
  final DateTime updatedAt;

  /// List of message ids deleted by this member only for himself.
  ///
  /// These messages are not visible to this member anymore, but are still
  /// visible to other channel members.
  final List<String> deletedMessages;

  /// Map of custom member extraData.
  final Map<String, Object?> extraData;

  /// Creates a copy of [Member] with specified attributes overridden.
  Member copyWith({
    User? user,
    DateTime? inviteAcceptedAt,
    DateTime? inviteRejectedAt,
    bool? invited,
    String? role,
    String? channelRole,
    String? userId,
    bool? isModerator,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? pinnedAt,
    DateTime? archivedAt,
    bool? banned,
    DateTime? banExpires,
    bool? shadowBanned,
    List<String>? deletedMessages,
    Map<String, Object?>? extraData,
  }) => Member(
    user: user ?? this.user,
    inviteAcceptedAt: inviteAcceptedAt ?? this.inviteAcceptedAt,
    inviteRejectedAt: inviteRejectedAt ?? this.inviteRejectedAt,
    invited: invited ?? this.invited,
    banned: banned ?? this.banned,
    banExpires: banExpires ?? this.banExpires,
    shadowBanned: shadowBanned ?? this.shadowBanned,
    channelRole: channelRole ?? this.channelRole,
    userId: userId ?? this.userId,
    isModerator: isModerator ?? this.isModerator,
    pinnedAt: pinnedAt ?? this.pinnedAt,
    archivedAt: archivedAt ?? this.archivedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedMessages: deletedMessages ?? this.deletedMessages,
    extraData: extraData ?? this.extraData,
  );

  /// Serialize to json
  Map<String, dynamic> toJson() => Serializer.moveFromExtraDataToRoot(
    _$MemberToJson(this),
  );

  @override
  List<Object?> get props => [
    user,
    inviteAcceptedAt,
    inviteRejectedAt,
    invited,
    channelRole,
    userId,
    isModerator,
    banned,
    banExpires,
    shadowBanned,
    pinnedAt,
    archivedAt,
    createdAt,
    updatedAt,
    deletedMessages,
    extraData,
  ];
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
  /// Creates a member filter field named [remote] on the wire, reading its
  /// value off an instance with [value].
  MemberFilterField(super.remote, super.value);

  /// Creates a field the SDK does not model, read from [Member.extraData].
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`,
  /// `$exists`, `$contains`, `$q`, `$autocomplete`
  factory MemberFilterField.custom(String remote) {
    return MemberFilterField(remote, (it) => it.extraData[remote]);
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
    (it) => it.user?.extraData['email'].safeCast<String>(),
  );

  /// Filters members by whether their user is deactivated.
  ///
  /// **Supported operators:** `$eq`
  static final userDeactivated = MemberFilterField(
    'user.nd_deactivated',
    (it) => it.user?.extraData['nd_deactivated'].safeCast<bool>(),
  );

  /// Filters members by whether they muted notifications for the channel.
  ///
  /// **Supported operators:** `$eq`
  static final notificationsMuted = MemberFilterField(
    'notifications_muted',
    (it) => it.extraData['notifications_muted'].safeCast<bool>(),
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
  /// Creates a field named [remote] on the wire, reading its value off an
  /// instance with `localValue`.
  ///
  /// For a name the SDK has not modelled; prefer the fields declared here.
  MemberSortField(super.remote, super.localValue);

  /// Creates a field the SDK does not model, read from [Member.extraData].
  ///
  /// Declared only where the API accepts a custom sort field.
  factory MemberSortField.custom(String remote) {
    return MemberSortField(remote, (it) => it.extraData[remote]);
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
    // Reads the raw name rather than `User.name`, which falls back to the id.
    (it) {
      final name = it.user?.extraData['name'];
      return name.safeCast<String>()?.let(normalizeStringForSort);
    },
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
