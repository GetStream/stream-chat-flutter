import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A typed mention surfaced by the read-side render pipeline.
///
/// One of the five built-in subclasses: [UserMention], [ChannelMention],
/// [HereMention], [RoleMention], [GroupMention].
abstract class Mention {
  /// Creates a new [Mention].
  const Mention();

  /// The kind of mention — one of the five constants on [MentionType].
  MentionType get type;

  /// The display name of the mention, derived from the payload.
  ///
  /// For user mentions this is `user.name`, which itself falls back to
  /// `user.id` when the user has no name set (see [User.name]).
  String get display;
}

/// A mention referencing a single user.
class UserMention extends Mention {
  /// Creates a new [UserMention] wrapping [user].
  const UserMention({required this.user});

  /// The referenced user.
  final User user;

  @override
  MentionType get type => .user;

  @override
  String get display => user.name;
}

/// A `@channel` broadcast mention.
class ChannelMention extends Mention {
  /// Creates a new [ChannelMention].
  const ChannelMention();

  @override
  MentionType get type => .channel;

  @override
  String get display => MentionType.channel.value;
}

/// An `@here` broadcast mention targeting online channel members.
class HereMention extends Mention {
  /// Creates a new [HereMention].
  const HereMention();

  @override
  MentionType get type => .here;

  @override
  String get display => MentionType.here.value;
}

/// A mention referencing a role.
///
/// Carries the role name only — the SDK does not persist the full [Role]
/// model on the message. Customers needing the full [Role] can fetch it via
/// `channel.client.searchRoles(role)`.
class RoleMention extends Mention {
  /// Creates a new [RoleMention] for the role with the given name.
  const RoleMention({required this.role});

  /// The role name.
  final String role;

  @override
  MentionType get type => .role;

  @override
  String get display => role;
}

/// A mention referencing a named subset of channel members.
class GroupMention extends Mention {
  /// Creates a new [GroupMention] wrapping [userGroup].
  const GroupMention({required this.userGroup});

  /// The referenced user group.
  final UserGroup userGroup;

  @override
  MentionType get type => .group;

  @override
  String get display => userGroup.name;
}
