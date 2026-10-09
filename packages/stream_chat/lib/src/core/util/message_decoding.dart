import '../models/message.dart';
import '../models/message_state.dart';
import '../models/reaction_group.dart';

/// Derivations every decoder of a received [Message] applies.
extension MessageDecoding on Message {
  /// Returns this message with the type and state its flags imply.
  ///
  /// A message deleted only for the current user reads as a [MessageType.deleted] message in the
  /// [MessageState.deletedForMe] state. Otherwise the type is kept, and the state is
  /// [MessageState.softDeleted] once the message has a [deletedAt], [MessageState.updated] once it was updated after
  /// it was created, and [MessageState.sent] before either.
  Message withDerivedState() {
    final isDeletedForMe = deletedForMe ?? false;
    // TODO: Remove this override once type is properly enriched on the backend.
    final type = isDeletedForMe ? MessageType.deleted : this.type;
    final state = switch (this) {
      _ when isDeletedForMe => MessageState.deletedForMe,
      _ when deletedAt != null => MessageState.softDeleted,
      _ when updatedAt.isAfter(createdAt) => MessageState.updated,
      _ => MessageState.sent,
    };

    return copyWith(type: type, state: state);
  }
}

/// Builds the reaction groups of a received message from its reaction [counts] and [scores], keyed by reaction type.
///
/// Returns null when neither has an entry. A type with no positive count is left out, whatever its score. As the
/// dates of the reactions are unknown, each group's first and last reaction date is now.
Map<String, ReactionGroup>? reactionGroupsFromCounts(Map<String, int>? counts, Map<String, int>? scores) {
  final reactionTypes = {...?counts?.keys, ...?scores?.keys};
  if (reactionTypes.isEmpty) return null;

  final now = DateTime.timestamp();
  return {
    for (final type in reactionTypes)
      if ((counts?[type] ?? 0) > 0)
        type: ReactionGroup(
          count: counts?[type] ?? 0,
          sumScores: scores?[type] ?? 0,
          firstReactionAt: now,
          lastReactionAt: now,
        ),
  };
}
