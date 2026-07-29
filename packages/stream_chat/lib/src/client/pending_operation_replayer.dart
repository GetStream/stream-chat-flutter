import 'package:stream_chat/src/client/client.dart';
import 'package:stream_chat/src/client/reaction_pending_operation.dart';
import 'package:stream_chat/src/core/error/error.dart';
import 'package:stream_chat/src/core/models/pending_operation.dart';
import 'package:stream_chat/src/core/models/reaction.dart';

/// Replays the stored [PendingOperation] queue against the server when the
/// connection is recovered.
///
/// Replay is at-least-once: an operation is removed from the queue only after
/// the server accepts or terminally rejects it, so a crash between acceptance
/// and removal re-sends it on the next recovery. Every operation type handled
/// by [_replayCallFor] must therefore be idempotent on the server — e.g.
/// reactions dedupe by (message, type, user).
class PendingOperationReplayer {
  /// Creates a replayer for [client]'s pending-operation queue.
  PendingOperationReplayer(this._client);

  final StreamChatClient _client;

  // Prevents overlapping replays.
  bool _isReplaying = false;

  /// Replays each stored operation against the server in insertion order.
  Future<void> replay() async {
    final persistence = _client.chatPersistenceClient;
    if (persistence == null) return;
    if (_isReplaying) return;
    _isReplaying = true;

    try {
      final operations = await persistence.getPendingOperations();
      for (final operation in operations) {
        try {
          final Future<void> Function()? call;
          try {
            call = _replayCallFor(operation);
          } catch (error, stk) {
            // Malformed payload for a known type — can never be replayed.
            _client.logger.warning(
              'Dropping unreplayable pending operation ${operation.id}',
              error,
              stk,
            );
            await persistence.deletePendingOperation(operation.id!);
            continue;
          }

          if (call == null) {
            // Unknown type (e.g. persisted by a newer app version) — drop it.
            _client.logger.warning(
              'Dropping unknown pending operation type "${operation.type}" '
              '(${operation.id})',
            );
            await persistence.deletePendingOperation(operation.id!);
            continue;
          }

          try {
            await call();
          } on StreamChatNetworkError catch (error) {
            // Keep transient failures for the next recovery.
            if (error.isRetriable) continue;
          }

          // Accepted or terminally rejected by the server — drop it.
          await persistence.deletePendingOperation(operation.id!);
        } catch (error, stk) {
          _client.logger.warning(
            'Error replaying pending operation ${operation.id}',
            error,
            stk,
          );
        }
      }
    } catch (error, stk) {
      _client.logger.severe(
        'Error replaying pending operations',
        error,
        stk,
      );
    } finally {
      _isReplaying = false;
    }
  }

  /// Returns the server call that replays [operation], or `null` if its type
  /// is unknown to this version.
  Future<void> Function()? _replayCallFor(PendingOperation operation) {
    switch (operation.type) {
      case ReactionPendingOperation.addType:
        final targetMessageId = operation.targetMessageId;
        if (targetMessageId == null) {
          throw StateError('Missing targetMessageId for ${operation.type}');
        }
        final reaction = Reaction.fromJson(
          operation.payload[ReactionPendingOperation.reactionKey] as Map<String, dynamic>,
        );
        final skipPush = operation.payload[ReactionPendingOperation.skipPushKey] as bool? ?? false;
        final enforceUnique = operation.payload[ReactionPendingOperation.enforceUniqueKey] as bool? ?? false;
        return () => _client.sendReaction(
          targetMessageId,
          reaction,
          skipPush: skipPush,
          enforceUnique: enforceUnique,
        );
      case ReactionPendingOperation.deleteType:
        final targetMessageId = operation.targetMessageId;
        if (targetMessageId == null) {
          throw StateError('Missing targetMessageId for ${operation.type}');
        }
        final reactionType = operation.payload[ReactionPendingOperation.reactionTypeKey] as String;
        return () => _client.deleteReaction(targetMessageId, reactionType);
      default:
        // Unknown operation type — cannot be replayed by this version.
        return null;
    }
  }
}
