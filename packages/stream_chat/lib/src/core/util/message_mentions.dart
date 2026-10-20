import '../models/message.dart';

/// Prunes the mentions a [Message] carries before it is sent.
extension MessageMentions on Message {
  /// Returns this message without the mentions its text no longer contains.
  ///
  /// A mentioned user stays while the text mentions their id or name, and a
  /// role or group while it mentions its name, each as a standalone `@` word;
  /// `@channel` and `@here` are cleared once the text drops them. Mentions
  /// that were never set stay as they are, and a message without text is
  /// returned unchanged.
  Message removeMentionsIfNotIncluded() {
    final text = this.text;
    if (text == null) return this;

    // Whether [text] mentions [token] as a standalone @-prefixed word.
    //
    // Word-boundary lookarounds so that e.g. mentioning `@administrator`
    // doesn't satisfy a stale `admin` token, and `@channels` doesn't satisfy
    // `channel`.
    bool mentionsToken(String token) {
      final pattern = RegExp('(?<![A-Za-z0-9_])@${RegExp.escape(token)}(?![A-Za-z0-9_])');
      return pattern.hasMatch(text);
    }

    final updatedMentionedUsers = [...mentionedUsers];
    for (final user in mentionedUsers.toSet()) {
      if (mentionsToken(user.id)) continue;
      if (mentionsToken(user.nameOrId)) continue;

      updatedMentionedUsers.remove(user);
    }

    final updatedMentionedChannel = mentionedChannel == true ? mentionsToken('channel') : mentionedChannel;
    final updatedMentionedHere = mentionedHere == true ? mentionsToken('here') : mentionedHere;

    final updatedMentionedRoles = mentionedRoles?.where(mentionsToken).toList();
    final updatedMentionedGroups = mentionedGroups?.where((g) => mentionsToken(g.name)).toList();
    final updatedMentionedGroupIds = updatedMentionedGroups?.map((g) => g.id).toList() ?? mentionedGroupIds;

    return copyWith(
      mentionedUsers: updatedMentionedUsers,
      mentionedChannel: updatedMentionedChannel,
      mentionedHere: updatedMentionedHere,
      mentionedRoles: updatedMentionedRoles,
      mentionedGroups: updatedMentionedGroups,
      mentionedGroupIds: updatedMentionedGroupIds,
    );
  }
}
