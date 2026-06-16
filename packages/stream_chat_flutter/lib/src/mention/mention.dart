import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A typed mention surfaced by the read-side render pipeline.
///
/// One of the five built-in subclasses: [StreamUserMention],
/// [StreamChannelMention], [StreamHereMention], [StreamRoleMention],
/// [StreamGroupMention].
abstract class StreamMention {
  /// Creates a new [StreamMention].
  const StreamMention();

  /// The kind of mention — one of the five constants on [StreamMentionType].
  StreamMentionType get type;

  /// The display name of the mention, derived from the payload.
  ///
  /// For user mentions this is `user.name`, which itself falls back to
  /// `user.id` when the user has no name set (see [User.name]).
  String get display;
}

/// A mention referencing a single user.
class StreamUserMention extends StreamMention {
  /// Creates a new [StreamUserMention] wrapping [user].
  const StreamUserMention({required this.user});

  /// The referenced user.
  final User user;

  @override
  StreamMentionType get type => .user;

  @override
  String get display => user.name;
}

/// A `@channel` broadcast mention.
class StreamChannelMention extends StreamMention {
  /// Creates a new [StreamChannelMention].
  const StreamChannelMention();

  @override
  StreamMentionType get type => .channel;

  @override
  String get display => StreamMentionType.channel;
}

/// An `@here` broadcast mention targeting online channel members.
class StreamHereMention extends StreamMention {
  /// Creates a new [StreamHereMention].
  const StreamHereMention();

  @override
  StreamMentionType get type => .here;

  @override
  String get display => StreamMentionType.here;
}

/// A mention referencing a role.
///
/// Carries the role name only — the SDK does not persist the full [Role]
/// model on the message. Customers needing the full [Role] can fetch it via
/// `channel.client.searchRoles(role)`.
class StreamRoleMention extends StreamMention {
  /// Creates a new [StreamRoleMention] for the role with the given name.
  const StreamRoleMention({required this.role});

  /// The role name.
  final String role;

  @override
  StreamMentionType get type => .role;

  @override
  String get display => role;
}

/// A mention referencing a named subset of channel members.
class StreamGroupMention extends StreamMention {
  /// Creates a new [StreamGroupMention] wrapping [userGroup].
  const StreamGroupMention({required this.userGroup});

  /// The referenced user group.
  final UserGroup userGroup;

  @override
  StreamMentionType get type => .group;

  @override
  String get display => userGroup.name;
}
