import 'package:stream_chat/src/core/models/pending_operation.dart';
import 'package:stream_chat/src/core/models/reaction.dart';

/// Builds and identifies the reaction-specific forms of [PendingOperation].
abstract class ReactionPendingOperation {
  /// The [PendingOperation.type] discriminator for a reaction add.
  static const addType = 'reaction.add';

  /// The [PendingOperation.type] discriminator for a reaction delete.
  static const deleteType = 'reaction.delete';

  /// The [PendingOperation.payload] key holding the serialized reaction of an
  /// add.
  static const reactionKey = 'reaction';

  /// The [PendingOperation.payload] key holding the `enforce_unique` flag of an
  /// add.
  static const enforceUniqueKey = 'enforce_unique';

  /// The [PendingOperation.payload] key holding the `skip_push` flag of an add.
  static const skipPushKey = 'skip_push';

  /// The [PendingOperation.payload] key holding the reaction type of a delete.
  static const reactionTypeKey = 'reaction_type';

  /// Builds the pending operation recording an optimistic reaction add.
  static PendingOperation add(
    Reaction reaction, {
    required bool skipPush,
    required bool enforceUnique,
  }) => PendingOperation(
    type: addType,
    targetMessageId: reaction.messageId,
    payload: {
      reactionKey: reaction.toJson(),
      enforceUniqueKey: enforceUnique,
      skipPushKey: skipPush,
    },
  );

  /// Builds the pending operation recording an optimistic reaction delete.
  static PendingOperation delete({
    required String messageId,
    required String reactionType,
  }) => PendingOperation(
    type: deleteType,
    targetMessageId: messageId,
    payload: {reactionTypeKey: reactionType},
  );
}
