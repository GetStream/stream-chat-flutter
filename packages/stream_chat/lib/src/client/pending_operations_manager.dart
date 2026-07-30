import 'package:meta/meta.dart';
import 'package:stream_chat/src/client/client.dart';
import 'package:stream_chat/src/client/reaction_pending_operation.dart';
import 'package:stream_chat/src/core/error/error.dart';
import 'package:stream_chat/src/core/models/pending_operation.dart';
import 'package:stream_chat/src/core/models/reaction.dart';

/// Owns the queue of [PendingOperation]s and replays them against the server
/// when the connection is recovered.
///
/// The queue lives in memory for the current session and is the single source
/// replayed from. When persistence is enabled the queue is additionally
/// mirrored to [StreamChatClient.chatPersistenceClient], so operations survive
/// process death: [hydrate] loads them back into memory on the next connect.
/// Without persistence the queue is session-only, giving reactions same-session
/// replay across transient outages.
///
/// Replay is at-least-once: an operation is removed only after the server
/// accepts or terminally rejects it, so a crash between acceptance and removal
/// re-sends it on the next recovery. Every operation type handled by
/// [_replayCallFor] must therefore be idempotent on the server — e.g. reactions
/// dedupe by (message, type, user).
@internal
class PendingOperationsManager {
  /// Creates a manager for [client]'s pending-operation queue.
  PendingOperationsManager(this._client);

  final StreamChatClient _client;

  /// The in-memory queue, replayed in insertion order.
  ///
  /// Every entry carries a non-null [PendingOperation.id]: a positive DB
  /// autoincrement id when the operation is mirrored to persistence, or a
  /// negative session id otherwise. The two ranges never collide.
  final _operations = <PendingOperation>[];

  // Source of negative, session-only ids for operations that are not persisted.
  int _memorySeq = 0;
  int _nextMemoryId() => --_memorySeq;

  // Prevents overlapping replays.
  bool _isReplaying = false;

  /// Appends [operation] to the queue, mirroring it to persistence when
  /// enabled so it survives process death.
  Future<void> enqueue(PendingOperation operation) async {
    int? id;
    if (_client.persistenceEnabled) {
      try {
        id = await _client.chatPersistenceClient!.insertPendingOperation(
          operation,
        );
      } catch (error, stk) {
        // Keep the operation in memory so it still replays this session.
        _client.logger.warning(
          'Failed to persist pending operation',
          error,
          stk,
        );
      }
    }
    _operations.add(operation.copyWith(id: id ?? _nextMemoryId()));
  }

  /// Loads any persisted operations into the in-memory queue.
  ///
  /// Called once per connect to restore operations that survived process
  /// death. A no-op when persistence is disabled.
  Future<void> hydrate() async {
    if (!_client.persistenceEnabled) return;
    try {
      final stored = await _client.chatPersistenceClient!.getPendingOperations();
      _operations
        ..clear()
        ..addAll(stored);
    } catch (error, stk) {
      _client.logger.warning(
        'Failed to hydrate pending operations',
        error,
        stk,
      );
    }
  }

  /// Empties the in-memory queue.
  ///
  /// Must be called on disconnect so a user's queued operations never replay
  /// under a different user. The persisted mirror is user-scoped and closed
  /// separately with the persistence connection.
  void clear() {
    _operations.clear();
    _memorySeq = 0;
  }

  /// Removes the operation with the given [id] from memory and, when persisted,
  /// from the mirror. A delete of a memory-only (negative) id is a no-op.
  Future<void> _remove(int id) async {
    _operations.removeWhere((it) => it.id == id);
    if (!_client.persistenceEnabled || id < 0) return;
    try {
      await _client.chatPersistenceClient!.deletePendingOperation(id);
    } catch (error, stk) {
      _client.logger.warning(
        'Failed to delete pending operation $id',
        error,
        stk,
      );
    }
  }

  /// Replays each queued operation against the server in insertion order.
  Future<void> replay() async {
    if (_isReplaying) return;
    _isReplaying = true;

    try {
      // Copy so removals during replay don't mutate the list being iterated.
      final operations = List.of(_operations);
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
            await _remove(operation.id!);
            continue;
          }

          if (call == null) {
            // Unknown type (e.g. persisted by a newer app version) — drop it.
            _client.logger.warning(
              'Dropping unknown pending operation type "${operation.type}" '
              '(${operation.id})',
            );
            await _remove(operation.id!);
            continue;
          }

          try {
            await call();
          } on StreamChatNetworkError catch (error) {
            // Keep transient failures for the next recovery.
            if (error.isRetriable) continue;
          }

          // Accepted or terminally rejected by the server — drop it.
          await _remove(operation.id!);
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
