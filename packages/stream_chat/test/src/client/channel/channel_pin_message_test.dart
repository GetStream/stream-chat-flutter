import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState Function(ChannelState) _seedChannel() {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
      ownCapabilities: [ChannelCapability.readEvents],
    ),
  );
}

void main() {
  group('`.pinMessage`', () {
    channelTest(
      'should work fine without passing timeoutOrExpirationDate',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(id: 'test-message-id');

        tester.mockApi(
          (api) => api.message.partialUpdateMessage(
            message.id,
            set: {'pinned': true, 'pin_expires': null},
          ),
          result: createDefaultUpdateMessageResponse(
            message: message.copyWith(
              pinned: true,
              pinExpires: null,
            ),
          ),
        );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updated),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await tester.channel.pinMessage(message);

        expect(res, isNotNull);
        expect(res.message.pinned, isTrue);
        expect(res.message.pinExpires, isNull);

        await messagesEmits;

        tester.verifyApi(
          (api) => api.message.partialUpdateMessage(
            message.id,
            set: {'pinned': true, 'pin_expires': null},
          ),
        );
      },
    );

    channelTest(
      'should work fine if passed timeoutOrExpirationDate as num(seconds)',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(id: 'test-message-id');
        const timeoutOrExpirationDate = 300; // 300 seconds

        // The channel computes `pin_expires` from the current time, so the
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
            ),
          ),
        );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updated),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await tester.channel.pinMessage(
          message,
          timeoutOrExpirationDate: timeoutOrExpirationDate,
        );

        expect(res, isNotNull);
        expect(res.message.pinned, isTrue);
        expect(res.message.pinExpires, isNotNull);

        await messagesEmits;

        tester.verifyApi(
          (api) => api.message.partialUpdateMessage(
            message.id,
            set: any(named: 'set'),
          ),
        );
      },
    );

    channelTest(
      'should work fine if passed timeoutOrExpirationDate as DateTime',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(id: 'test-message-id');
        final timeoutOrExpirationDate = DateTime.utc(2021, 3).add(const Duration(days: 3)); // 3 days

        tester.mockApi(
          (api) => api.message.partialUpdateMessage(
            message.id,
            set: {
              'pinned': true,
              'pin_expires': timeoutOrExpirationDate.toUtc().toIso8601String(),
            },
          ),
          result: createDefaultUpdateMessageResponse(
            message: message.copyWith(
              pinned: true,
              pinExpires: timeoutOrExpirationDate,
            ),
          ),
        );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updated),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await tester.channel.pinMessage(
          message,
          timeoutOrExpirationDate: timeoutOrExpirationDate,
        );

        expect(res, isNotNull);
        expect(res.message.pinned, isTrue);
        expect(res.message.pinExpires, isNotNull);
        expect(res.message.pinExpires, timeoutOrExpirationDate.toUtc());

        await messagesEmits;

        tester.verifyApi(
          (api) => api.message.partialUpdateMessage(
            message.id,
            set: {
              'pinned': true,
              'pin_expires': timeoutOrExpirationDate.toUtc().toIso8601String(),
            },
          ),
        );
      },
    );

    channelTest(
      'should throw if invalid timeoutOrExpirationDate is passed',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(id: 'test-message-id');
        const timeoutOrExpirationDate = 'invalid-value';

        try {
          await tester.channel.pinMessage(
            message,
            timeoutOrExpirationDate: timeoutOrExpirationDate,
          );
        } catch (e) {
          expect(e, isA<ArgumentError>());
        }
      },
    );
  });

  channelTest(
    '`.unpinMessage`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      final message = Message(id: 'test-message-id', pinned: true);

      tester.mockApi(
        (api) => api.message.partialUpdateMessage(
          message.id,
          set: {'pinned': false},
        ),
        result: createDefaultUpdateMessageResponse(
          message: message.copyWith(pinned: false),
        ),
      );

      final messagesEmits = expectLater(
        // skipping first seed message list -> [] messages
        tester.channelState?.messagesStream.skip(1),
        emitsInOrder([
          [
            isSameMessageAs(
              message.copyWith(state: MessageState.updating),
              matchMessageState: true,
            ),
          ],
          [
            isSameMessageAs(
              message.copyWith(state: MessageState.updated),
              matchMessageState: true,
            ),
          ],
        ]),
      );

      final res = await tester.channel.unpinMessage(message);

      expect(res, isNotNull);
      expect(res.message.pinned, isFalse);

      await messagesEmits;

      tester.verifyApi(
        (api) => api.message.partialUpdateMessage(
          message.id,
          set: {'pinned': false},
        ),
      );
    },
  );
}
