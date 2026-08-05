// ignore_for_file: avoid_redundant_argument_values

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/client/pending_operations_manager.dart';
import 'package:stream_chat/src/client/reaction_pending_operation.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  group('PendingOperationsManager', () {
    const apiKey = 'test-api-key';

    late FakeChatApi api;
    late FakeWebSocket ws;
    late MockPersistenceClient persistence;
    late StreamChatClient client;
    late PendingOperationsManager manager;

    setUpAll(() {
      registerFallbackValue(Reaction(type: 'fallback'));
    });

    setUp(() {
      api = FakeChatApi();
      ws = FakeWebSocket();
      persistence = MockPersistenceClient();
      client = StreamChatClient(apiKey, chatApi: api, ws: ws)..chatPersistenceClient = persistence;
      manager = PendingOperationsManager(client);
    });

    tearDown(() async {
      await client.dispose();
    });

    PendingOperation addOp(String messageId) => ReactionPendingOperation.add(
      Reaction(type: 'like', messageId: messageId),
      skipPush: false,
      enforceUnique: false,
    );

    PendingOperation deleteOp(String messageId) => ReactionPendingOperation.delete(
      messageId: messageId,
      reactionType: 'like',
    );

    void stubSendReactionOk() {
      when(
        () => api.message.sendReaction(
          any(),
          any(),
          skipPush: any(named: 'skipPush'),
          enforceUnique: any(named: 'enforceUnique'),
        ),
      ).thenAnswer(
        (invocation) async => SendReactionResponse()
          ..message = Message(id: invocation.positionalArguments[0] as String)
          ..reaction = Reaction(type: 'like'),
      );
    }

    void stubSendReactionThrows(Object error) {
      when(
        () => api.message.sendReaction(
          any(),
          any(),
          skipPush: any(named: 'skipPush'),
          enforceUnique: any(named: 'enforceUnique'),
        ),
      ).thenThrow(error);
    }

    // Retriable/offline: no server response, so `data == null`.
    final transientError = StreamChatNetworkError(ChatErrorCode.inputError);
    // Terminal: the server responded with an error.
    final terminalError = StreamChatNetworkError(
      ChatErrorCode.inputError,
      data: ErrorResponse()..statusCode = 403,
    );

    group('with persistence enabled', () {
      setUp(() async {
        await persistence.connect('user-id');
      });

      test('replays queued operations FIFO and drops them on success', () async {
        await manager.enqueue(addOp('m1'));
        await manager.enqueue(addOp('m2'));
        stubSendReactionOk();

        await manager.replay();

        verifyInOrder([
          () => api.message.sendReaction(
            'm1',
            any(),
            skipPush: any(named: 'skipPush'),
            enforceUnique: any(named: 'enforceUnique'),
          ),
          () => api.message.sendReaction(
            'm2',
            any(),
            skipPush: any(named: 'skipPush'),
            enforceUnique: any(named: 'enforceUnique'),
          ),
        ]);
        // Dropped from the persisted mirror on success.
        expect(persistence.storedPendingOperations, isEmpty);
      });

      test('mirrors the enqueued op and its payload to persistence', () async {
        await manager.enqueue(
          ReactionPendingOperation.add(
            Reaction(type: 'like', messageId: 'm1'),
            skipPush: true,
            enforceUnique: true,
          ),
        );

        final op = persistence.storedPendingOperations.single;
        expect(op.type, ReactionPendingOperation.addType);
        expect(op.targetMessageId, 'm1');
        expect(op.payload[ReactionPendingOperation.skipPushKey], isTrue);
        expect(op.payload[ReactionPendingOperation.enforceUniqueKey], isTrue);
      });

      test('keeps a queued operation on a transient (offline) failure', () async {
        await manager.enqueue(addOp('m1'));
        stubSendReactionThrows(transientError);

        await manager.replay();

        // Kept for the next recovery — no revert, no drop.
        expect(persistence.storedPendingOperations, hasLength(1));
      });

      test('drops a queued operation on a terminal (server-rejected) failure', () async {
        await manager.enqueue(addOp('m1'));
        stubSendReactionThrows(terminalError);

        await manager.replay();

        // Dropped without a revert; the reconnect refresh reconciles.
        expect(persistence.storedPendingOperations, isEmpty);
      });

      test('drops an operation whose stored payload cannot be parsed', () async {
        await manager.enqueue(
          const PendingOperation(
            type: ReactionPendingOperation.addType,
            targetMessageId: 'm1',
            payload: {}, // missing the reaction payload
          ),
        );

        await manager.replay();

        // Dropped without ever hitting the API — it can never be replayed.
        expect(persistence.storedPendingOperations, isEmpty);
        verifyNever(
          () => api.message.sendReaction(
            any(),
            any(),
            skipPush: any(named: 'skipPush'),
            enforceUnique: any(named: 'enforceUnique'),
          ),
        );
      });

      test('drops an operation with a missing targetMessageId', () async {
        await manager.enqueue(
          PendingOperation(
            type: ReactionPendingOperation.addType,
            // No targetMessageId — the reaction can never be routed to a message.
            payload: {
              ReactionPendingOperation.reactionKey: Reaction(type: 'like').toJson(),
            },
          ),
        );

        await manager.replay();

        // Dropped without ever hitting the API — it can never be replayed.
        expect(persistence.storedPendingOperations, isEmpty);
        verifyNever(
          () => api.message.sendReaction(
            any(),
            any(),
            skipPush: any(named: 'skipPush'),
            enforceUnique: any(named: 'enforceUnique'),
          ),
        );
      });

      test('drops an operation of an unknown type', () async {
        await manager.enqueue(
          const PendingOperation(
            type: 'unknown.op',
            targetMessageId: 'm1',
            payload: {},
          ),
        );

        await manager.replay();

        // Dropped without ever hitting the API — this version can't replay it.
        expect(persistence.storedPendingOperations, isEmpty);
        verifyNever(
          () => api.message.sendReaction(
            any(),
            any(),
            skipPush: any(named: 'skipPush'),
            enforceUnique: any(named: 'enforceUnique'),
          ),
        );
      });

      test('replays an operation for a channel not loaded this session', () async {
        // No channel is loaded for `test:cid`; the queue still replays it.
        await manager.enqueue(deleteOp('m9'));
        when(() => api.message.deleteReaction('m9', 'like')).thenAnswer((_) async => EmptyResponse());

        await manager.replay();

        verify(() => api.message.deleteReaction('m9', 'like')).called(1);
        expect(persistence.storedPendingOperations, isEmpty);
      });

      test('a persistence delete failure does not abort the rest of the batch', () async {
        await manager.enqueue(addOp('m1')); // id 1
        await manager.enqueue(addOp('m2')); // id 2

        // m1 replays terminally (server-rejected) → dropped; m2 replays OK.
        when(
          () => api.message.sendReaction(
            'm1',
            any(),
            skipPush: any(named: 'skipPush'),
            enforceUnique: any(named: 'enforceUnique'),
          ),
        ).thenThrow(terminalError);
        when(
          () => api.message.sendReaction(
            'm2',
            any(),
            skipPush: any(named: 'skipPush'),
            enforceUnique: any(named: 'enforceUnique'),
          ),
        ).thenAnswer(
          (_) async => SendReactionResponse()
            ..message = Message(id: 'm2')
            ..reaction = Reaction(type: 'like'),
        );

        // Dropping the first operation (id 1) throws mid-loop.
        persistence.failDeleteForIds.add(1);

        await manager.replay();

        // The loop continued past the failed delete: m2 still replayed.
        verify(
          () => api.message.sendReaction(
            'm2',
            any(),
            skipPush: any(named: 'skipPush'),
            enforceUnique: any(named: 'enforceUnique'),
          ),
        ).called(1);
        // m1's mirror row survived (its delete failed); m2 was dropped on success.
        expect(persistence.storedPendingOperations, hasLength(1));
        expect(persistence.storedPendingOperations.single.targetMessageId, 'm1');
      });

      test('keeps the op in memory when the durable insert fails', () async {
        persistence.failInsert = true;

        await manager.enqueue(addOp('m1'));

        // Nothing was mirrored, but the op still replays this session.
        expect(persistence.storedPendingOperations, isEmpty);
        stubSendReactionOk();
        await manager.replay();
        verify(
          () => api.message.sendReaction(
            'm1',
            any(),
            skipPush: any(named: 'skipPush'),
            enforceUnique: any(named: 'enforceUnique'),
          ),
        ).called(1);
      });

      group('hydrate', () {
        test('loads persisted operations into memory and replays them', () async {
          // Operations that survived process death, seeded straight into the DB.
          await persistence.insertPendingOperation(addOp('m1'));
          await persistence.insertPendingOperation(addOp('m2'));
          stubSendReactionOk();

          // A fresh manager (as after a restart) starts with an empty queue.
          await manager.hydrate();
          await manager.replay();

          verifyInOrder([
            () => api.message.sendReaction(
              'm1',
              any(),
              skipPush: any(named: 'skipPush'),
              enforceUnique: any(named: 'enforceUnique'),
            ),
            () => api.message.sendReaction(
              'm2',
              any(),
              skipPush: any(named: 'skipPush'),
              enforceUnique: any(named: 'enforceUnique'),
            ),
          ]);
          expect(persistence.storedPendingOperations, isEmpty);
        });
      });
    });

    group('with persistence disabled', () {
      // `persistence` is set on the client but never connected, so
      // `client.persistenceEnabled` is false and the queue is memory-only.

      test('replays memory-only operations without touching persistence', () async {
        await manager.enqueue(addOp('m1'));
        await manager.enqueue(addOp('m2'));
        stubSendReactionOk();

        await manager.replay();

        verifyInOrder([
          () => api.message.sendReaction(
            'm1',
            any(),
            skipPush: any(named: 'skipPush'),
            enforceUnique: any(named: 'enforceUnique'),
          ),
          () => api.message.sendReaction(
            'm2',
            any(),
            skipPush: any(named: 'skipPush'),
            enforceUnique: any(named: 'enforceUnique'),
          ),
        ]);
        // Never mirrored to persistence.
        expect(persistence.storedPendingOperations, isEmpty);
      });

      test('keeps a memory-only op on a transient failure for the next replay', () async {
        await manager.enqueue(addOp('m1'));
        stubSendReactionThrows(transientError);
        await manager.replay();

        // Still queued in memory — a later replay retries it (the first,
        // failing attempt plus this successful one make two calls in total).
        stubSendReactionOk();
        await manager.replay();

        verify(
          () => api.message.sendReaction(
            'm1',
            any(),
            skipPush: any(named: 'skipPush'),
            enforceUnique: any(named: 'enforceUnique'),
          ),
        ).called(2);
      });

      test('drops a memory-only op on a terminal failure', () async {
        await manager.enqueue(addOp('m1'));
        stubSendReactionThrows(terminalError);
        await manager.replay();

        // Dropped from memory — a later replay does nothing.
        stubSendReactionOk();
        await manager.replay();

        verify(
          () => api.message.sendReaction(
            'm1',
            any(),
            skipPush: any(named: 'skipPush'),
            enforceUnique: any(named: 'enforceUnique'),
          ),
        ).called(1);
      });

      test('hydrate is a no-op', () async {
        // A row exists in the DB, but with persistence disabled it is ignored.
        await persistence.insertPendingOperation(addOp('m1'));
        stubSendReactionOk();

        await manager.hydrate();
        await manager.replay();

        verifyNever(
          () => api.message.sendReaction(
            any(),
            any(),
            skipPush: any(named: 'skipPush'),
            enforceUnique: any(named: 'enforceUnique'),
          ),
        );
      });
    });

    group('clear', () {
      test('empties the queue so a later replay does nothing', () async {
        await manager.enqueue(addOp('m1'));
        manager.clear();
        stubSendReactionOk();

        await manager.replay();

        verifyNever(
          () => api.message.sendReaction(
            any(),
            any(),
            skipPush: any(named: 'skipPush'),
            enforceUnique: any(named: 'enforceUnique'),
          ),
        );
      });
    });
  });
}
