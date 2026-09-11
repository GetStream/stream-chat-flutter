import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

// Pinned base timestamp for the seeded messages (m1, m2 +1s, m3 +2s).
final _baseCreatedAt = DateTime.utc(2021, 3);

ChannelState Function(ChannelState) _seedChannel() {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(cid: _channelCid),
    messages: [
      Message(id: 'm1', text: '1', createdAt: _baseCreatedAt),
      Message(id: 'm2', text: '2', createdAt: _baseCreatedAt.add(const Duration(seconds: 1))),
      Message(id: 'm3', text: '3', createdAt: _baseCreatedAt.add(const Duration(seconds: 2))),
    ],
  );
}

void main() {
  group('updateChannelState identity guard', () {
    channelTest(
      'preserves messages reference when updatedState.messages is null',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final before = tester.channelState!.messages;
        tester.channelState!.updateChannelState(
          ChannelState(channel: tester.channelState!.channelState.channel),
        );
        final after = tester.channelState!.messages;

        expect(identical(before, after), isTrue);
      },
    );

    channelTest(
      'preserves messages reference when updatedState.messages is identical',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final before = tester.channelState!.messages;
        // copyWith without messages keeps the same `messages` reference, so
        // updateChannelState should hit the identity-guard fast path.
        tester.channelState!.updateChannelState(
          tester.channelState!.channelState.copyWith(
            read: [
              Read(
                user: User(id: 'me'),
                lastRead: DateTime.utc(2021, 3, 2),
                unreadMessages: 1,
              ),
            ],
          ),
        );
        final after = tester.channelState!.messages;

        expect(identical(before, after), isTrue);
      },
    );

    channelTest(
      'still merges messages when updatedState.messages is a different list',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final newMessage = Message(
          id: 'm4',
          text: '4',
          createdAt: _baseCreatedAt.add(const Duration(seconds: 10)),
        );
        tester.channelState!.updateChannelState(
          ChannelState(
            channel: tester.channelState!.channelState.channel,
            messages: [newMessage],
          ),
        );

        expect(
          tester.channelState!.messages.map((m) => m.id),
          ['m1', 'm2', 'm3', 'm4'],
        );
      },
    );

    channelTest(
      'cold-path merge interleaves new messages in sorted order',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final base = tester.channelState!.messages.first.createdAt;
        // Incoming list is sorted ascending by createdAt and slots between
        // the existing m1, m2, m3.
        final incoming = [
          Message(
            id: 'm1.5',
            text: 'between m1 and m2',
            createdAt: base.add(const Duration(milliseconds: 500)),
          ),
          Message(
            id: 'm2.5',
            text: 'between m2 and m3',
            createdAt: base.add(const Duration(milliseconds: 1500)),
          ),
        ];
        tester.channelState!.updateChannelState(
          ChannelState(
            channel: tester.channelState!.channelState.channel,
            messages: incoming,
          ),
        );

        expect(
          tester.channelState!.messages.map((m) => m.id),
          ['m1', 'm1.5', 'm2', 'm2.5', 'm3'],
        );
      },
    );

    channelTest(
      'cold-path merge runs syncWith on overlapping ids',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final localStamp = DateTime.utc(2021, 3, 5);
        // Seed m2 with a localCreatedAt that the incoming version doesn't
        // carry, so we can verify syncWith fired during the merge.
        tester.channelState!.updateMessage(
          Message(
            id: 'm2',
            text: '2',
            createdAt: tester.channelState!.messages.firstWhere((m) => m.id == 'm2').createdAt,
          ).copyWith(localCreatedAt: localStamp),
        );

        final incoming = [
          Message(
            id: 'm2',
            text: '2 (server)',
            createdAt: tester.channelState!.messages.firstWhere((m) => m.id == 'm2').createdAt,
          ),
        ];
        tester.channelState!.updateChannelState(
          ChannelState(
            channel: tester.channelState!.channelState.channel,
            messages: incoming,
          ),
        );

        final m2 = tester.channelState!.messages.firstWhere((m) => m.id == 'm2');
        expect(m2.text, '2 (server)');
        // Local-only field carried over by syncWith during the merge.
        expect(m2.localCreatedAt, localStamp);
      },
    );
  });
}
