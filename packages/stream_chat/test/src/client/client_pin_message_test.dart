import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  group('`.pinMessage`', () {
    chatClientTest(
      'should work fine without passing timeoutOrExpirationDate',
      body: (tester) async {
        const messageId = 'test-message-id';
        final message = Message(id: messageId);

        tester.mockApi(
          (api) => api.message.partialUpdateMessage(
            messageId,
            set: {'pinned': true, 'pin_expires': null},
          ),
          result: createDefaultUpdateMessageResponse(
            message: message.copyWith(
              pinned: true,
              pinExpires: null,
              state: MessageState.sent,
            ),
          ),
        );

        final res = await tester.client.pinMessage(messageId);

        expect(res, isNotNull);
        expect(res.message.pinned, isTrue);
        expect(res.message.pinExpires, isNull);

        tester
          ..verifyApi(
            (api) => api.message.partialUpdateMessage(
              messageId,
              set: {'pinned': true, 'pin_expires': null},
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      'should work fine if passed timeoutOrExpirationDate as num(seconds)',
      body: (tester) async {
        const messageId = 'test-message-id';
        final message = Message(id: messageId);
        const timeoutOrExpirationDate = 300; // 300 seconds

        // The client computes `pin_expires` from the current time, so the
        // stub cannot match the exact `set` map.
        tester.mockApi(
          (api) => api.message.partialUpdateMessage(
            message.id,
            set: any(named: 'set'),
          ),
          result: createDefaultUpdateMessageResponse(
            message: message.copyWith(
              pinned: true,
              pinExpires: DateTime.utc(2021, 3).add(
                const Duration(seconds: timeoutOrExpirationDate),
              ),
              state: MessageState.sent,
            ),
          ),
        );

        final res = await tester.client.pinMessage(
          messageId,
          timeoutOrExpirationDate: timeoutOrExpirationDate,
        );

        expect(res, isNotNull);
        expect(res.message.pinned, isTrue);
        expect(res.message.pinExpires, isNotNull);

        tester
          ..verifyApi(
            (api) => api.message.partialUpdateMessage(
              messageId,
              set: any(named: 'set'),
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      'should work fine if passed timeoutOrExpirationDate as DateTime',
      body: (tester) async {
        const messageId = 'test-message-id';
        final message = Message(id: messageId);
        final timeoutOrExpirationDate = DateTime.utc(2021, 3).add(const Duration(days: 3)); // 3 days

        tester.mockApi(
          (api) => api.message.partialUpdateMessage(
            messageId,
            set: {
              'pinned': true,
              'pin_expires': timeoutOrExpirationDate.toUtc().toIso8601String(),
            },
          ),
          result: createDefaultUpdateMessageResponse(
            message: message.copyWith(
              pinned: true,
              pinExpires: timeoutOrExpirationDate,
              state: MessageState.sent,
            ),
          ),
        );

        final res = await tester.client.pinMessage(
          messageId,
          timeoutOrExpirationDate: timeoutOrExpirationDate,
        );

        expect(res, isNotNull);
        expect(res.message.pinned, isTrue);
        expect(res.message.pinExpires, isNotNull);
        expect(res.message.pinExpires, timeoutOrExpirationDate.toUtc());

        tester
          ..verifyApi(
            (api) => api.message.partialUpdateMessage(
              messageId,
              set: {
                'pinned': true,
                'pin_expires': timeoutOrExpirationDate.toUtc().toIso8601String(),
              },
            ),
          )
          ..verifyNoMoreApiInteractions((api) => api.message);
      },
    );

    chatClientTest(
      'should throw if invalid timeoutOrExpirationDate is passed',
      body: (tester) async {
        const messageId = 'test-message-id';
        const timeoutOrExpirationDate = 'invalid-value';

        try {
          await tester.client.pinMessage(
            messageId,
            timeoutOrExpirationDate: timeoutOrExpirationDate,
          );
        } catch (e) {
          expect(e, isA<ArgumentError>());
        }
      },
    );
  });
}
