// ignore_for_file: avoid_redundant_argument_values

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/client/pending_operation_replayer.dart';
import 'package:stream_chat/src/client/reaction_pending_operation.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  group('PendingOperationReplayer', () {
    const apiKey = 'test-api-key';

    late FakeChatApi api;
    late FakeWebSocket ws;
    late MockPersistenceClient persistence;
    late StreamChatClient client;
    late PendingOperationReplayer replayer;

    setUpAll(() {
      registerFallbackValue(Reaction(type: 'fallback'));
    });

    setUp(() {
      api = FakeChatApi();
      ws = FakeWebSocket();
      persistence = MockPersistenceClient();
      client = StreamChatClient(apiKey, chatApi: api, ws: ws)..chatPersistenceClient = persistence;
      replayer = PendingOperationReplayer(client);
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

    test('replays queued operations FIFO and drops them on success', () async {
      await persistence.insertPendingOperation(addOp('m1'));
      await persistence.insertPendingOperation(addOp('m2'));
      stubSendReactionOk();

      await replayer.replay();

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

    test('keeps a queued operation on a transient (offline) failure', () async {
      await persistence.insertPendingOperation(addOp('m1'));
      // data == null → retriable/offline.
      when(
        () => api.message.sendReaction(
          any(),
          any(),
          skipPush: any(named: 'skipPush'),
          enforceUnique: any(named: 'enforceUnique'),
        ),
      ).thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

      await replayer.replay();

      // Kept for the next recovery — no revert, no drop.
      expect(persistence.storedPendingOperations, hasLength(1));
    });

    test('drops a queued operation on a terminal (server-rejected) failure', () async {
      await persistence.insertPendingOperation(addOp('m1'));
      when(
        () => api.message.sendReaction(
          any(),
          any(),
          skipPush: any(named: 'skipPush'),
          enforceUnique: any(named: 'enforceUnique'),
        ),
      ).thenThrow(
        StreamChatNetworkError(
          ChatErrorCode.inputError,
          data: ErrorResponse()..statusCode = 403,
        ),
      );

      await replayer.replay();

      // Dropped without a revert; the reconnect refresh reconciles.
      expect(persistence.storedPendingOperations, isEmpty);
    });

    test('drops an operation whose stored payload cannot be parsed', () async {
      await persistence.insertPendingOperation(
        const PendingOperation(
          type: ReactionPendingOperation.addType,
          targetMessageId: 'm1',
          payload: {}, // missing the reaction payload
        ),
      );

      await replayer.replay();

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
      await persistence.insertPendingOperation(
        const PendingOperation(
          type: 'unknown.op',
          targetMessageId: 'm1',
          payload: {},
        ),
      );

      await replayer.replay();

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
      await persistence.insertPendingOperation(deleteOp('m9'));
      when(() => api.message.deleteReaction('m9', 'like')).thenAnswer((_) async => EmptyResponse());

      await replayer.replay();

      verify(() => api.message.deleteReaction('m9', 'like')).called(1);
      expect(persistence.storedPendingOperations, isEmpty);
    });

    test('a persistence delete failure does not abort the rest of the batch', () async {
      await persistence.insertPendingOperation(addOp('m1')); // id 1
      await persistence.insertPendingOperation(addOp('m2')); // id 2

      // m1 replays terminally (server-rejected) → its row is dropped; m2 is OK.
      when(
        () => api.message.sendReaction(
          'm1',
          any(),
          skipPush: any(named: 'skipPush'),
          enforceUnique: any(named: 'enforceUnique'),
        ),
      ).thenThrow(
        StreamChatNetworkError(
          ChatErrorCode.inputError,
          data: ErrorResponse()..statusCode = 403,
        ),
      );
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

      await replayer.replay();

      // The loop continued past the failed delete: m2 still replayed.
      verify(
        () => api.message.sendReaction(
          'm2',
          any(),
          skipPush: any(named: 'skipPush'),
          enforceUnique: any(named: 'enforceUnique'),
        ),
      ).called(1);
      // m1 stayed queued (its delete failed); m2 was dropped on success.
      expect(persistence.storedPendingOperations, hasLength(1));
      expect(persistence.storedPendingOperations.single.targetMessageId, 'm1');
    });
  });
}
