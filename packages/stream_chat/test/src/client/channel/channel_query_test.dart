import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

// Builds the channel already initialized from state — the `.query` tests
// exercise `queryChannel` themselves, so they cannot seed through
// `tester.watch()` without polluting the call counts they verify.
Channel _buildInitializedChannel(
  StreamChatClient client, {
  List<ChannelCapability> ownCapabilities = const [ChannelCapability.readEvents],
  List<Message> messages = const [],
}) {
  return Channel.fromState(
    client,
    createDefaultChannelState(
      channel: createDefaultChannelModel(
        cid: _channelCid,
        config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
        ownCapabilities: ownCapabilities,
      ),
      messages: messages,
    ),
  );
}

void main() {
  group('`.query`', () {
    channelTest(
      'should work fine',
      channelType: _channelType,
      channelId: _channelId,
      build: _buildInitializedChannel,
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: tester.channel.extraData,
          ),
          result: createDefaultChannelState(
            channel: createDefaultChannelModel(cid: _channelCid),
          ),
        );

        final res = await tester.channel.query();

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: tester.channel.extraData,
          ),
        );
      },
    );

    channelTest(
      'should rethrow if `client.queryChannel` throws',
      channelType: _channelType,
      channelId: _channelId,
      build: _buildInitializedChannel,
      body: (tester) async {
        tester.mockApiFailure(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: tester.channel.extraData,
          ),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.inputError),
        );

        try {
          await tester.channel.query();
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());
        }

        tester.verifyApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: tester.channel.extraData,
          ),
        );
      },
    );

    channelTest(
      'should truncate state when querying around message id',
      channelType: _channelType,
      channelId: _channelId,
      build: _buildInitializedChannel,
      body: (tester) async {
        final initialMessages = [
          Message(id: 'msg1', text: 'Hello 1'),
          Message(id: 'msg2', text: 'Hello 2'),
          Message(id: 'msg3', text: 'Hello 3'),
        ];

        final stateWithMessages = createDefaultChannelState(
          channel: createDefaultChannelModel(cid: _channelCid),
          messages: initialMessages,
        );

        tester.channelState!.updateChannelState(stateWithMessages);
        expect(tester.channelState!.messages, hasLength(3));

        final newState = createDefaultChannelState(
          channel: createDefaultChannelModel(cid: _channelCid),
          messages: [
            Message(id: 'msg-before-1', text: 'Message before 1'),
            Message(id: 'msg-before-2', text: 'Message before 2'),
            Message(id: 'target-message-id', text: 'Target message'),
            Message(id: 'msg-after-1', text: 'Message after 1'),
            Message(id: 'msg-after-2', text: 'Message after 2'),
          ],
        );

        const pagination = PaginationParams(idAround: 'target-message-id');

        tester.mockApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: tester.channel.extraData,
            messagesPagination: pagination,
          ),
          result: newState,
        );

        final res = await tester.channel.query(messagesPagination: pagination);

        expect(res, isNotNull);
        expect(tester.channelState!.messages, hasLength(5));
        expect(tester.channelState!.messages[2].id, 'target-message-id');

        tester.verifyApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: tester.channel.extraData,
            messagesPagination: pagination,
          ),
        );
      },
    );

    channelTest(
      'should truncate state when querying around created date',
      channelType: _channelType,
      channelId: _channelId,
      build: _buildInitializedChannel,
      body: (tester) async {
        final initialMessages = [
          Message(id: 'msg1', text: 'Hello 1'),
          Message(id: 'msg2', text: 'Hello 2'),
          Message(id: 'msg3', text: 'Hello 3'),
        ];

        final stateWithMessages = createDefaultChannelState(
          channel: createDefaultChannelModel(cid: _channelCid),
          messages: initialMessages,
        );

        tester.channelState!.updateChannelState(stateWithMessages);
        expect(tester.channelState!.messages, hasLength(3));

        final targetDate = DateTime.utc(2021, 3);
        final newState = createDefaultChannelState(
          channel: createDefaultChannelModel(cid: _channelCid),
          messages: [
            Message(id: 'msg-before-1', text: 'Message before 1'),
            Message(id: 'msg-before-2', text: 'Message before 2'),
            Message(id: 'target-message', text: 'Target message'),
            Message(id: 'msg-after-1', text: 'Message after 1'),
            Message(id: 'msg-after-2', text: 'Message after 2'),
          ],
        );

        final pagination = PaginationParams(createdAtAround: targetDate);

        tester.mockApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: tester.channel.extraData,
            messagesPagination: pagination,
          ),
          result: newState,
        );

        final res = await tester.channel.query(messagesPagination: pagination);

        expect(res, isNotNull);
        expect(tester.channelState!.messages, hasLength(5));
        expect(tester.channelState!.messages[2].id, 'target-message');

        tester.verifyApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: tester.channel.extraData,
            messagesPagination: pagination,
          ),
        );
      },
    );

    channelTest(
      'should submit for delivery when querying latest messages (no pagination)',
      channelType: _channelType,
      channelId: _channelId,
      // The delivery reporter is real in the harness: it only records a
      // channel whose last message qualifies for a receipt, so the channel is
      // seeded with the `deliveryEvents` capability and a message from
      // another user.
      build: (client) => _buildInitializedChannel(
        client,
        ownCapabilities: const [ChannelCapability.readEvents, ChannelCapability.deliveryEvents],
        messages: [
          Message(
            id: 'test-message-id',
            user: User(id: 'other-user'),
            createdAt: DateTime.utc(2021, 1, 2),
          ),
        ],
      ),
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: tester.channel.extraData,
          ),
          result: createDefaultChannelState(
            channel: createDefaultChannelModel(cid: _channelCid),
          ),
        );

        registerFallbackValue(<MessageDelivery>[]);
        tester.mockApi(
          (api) => api.channel.markChannelsDelivered(any()),
          result: createDefaultEmptyResponse(),
        );

        // Query without pagination params (fetching latest messages)
        await tester.channel.query();

        // The delivery reporter batches receipts behind a 1s trailing
        // throttle.
        await Future.delayed(const Duration(milliseconds: 1100));

        // Verify the channel's last message was marked as delivered
        final captured = tester.captureApi(
          (api) => api.channel.markChannelsDelivered(captureAny()),
        );
        final deliveries = captured.single! as List<MessageDelivery>;
        expect(deliveries.single.channelCid, _channelCid);
        expect(deliveries.single.messageId, 'test-message-id');
      },
    );

    channelTest(
      'should NOT submit for delivery when querying with pagination (older messages)',
      channelType: _channelType,
      channelId: _channelId,
      // Seeded exactly like the positive test above, so the absence of a
      // receipt can only come from the pagination params.
      build: (client) => _buildInitializedChannel(
        client,
        ownCapabilities: const [ChannelCapability.readEvents, ChannelCapability.deliveryEvents],
        messages: [
          Message(
            id: 'test-message-id',
            user: User(id: 'other-user'),
            createdAt: DateTime.utc(2021, 1, 2),
          ),
        ],
      ),
      body: (tester) async {
        registerFallbackValue(<MessageDelivery>[]);
        tester.mockApi(
          (api) => api.channel.markChannelsDelivered(any()),
          result: createDefaultEmptyResponse(),
        );

        const pagination = PaginationParams(limit: 20, lessThan: 'some-message-id');

        tester.mockApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: tester.channel.extraData,
            messagesPagination: pagination,
          ),
          result: createDefaultChannelState(
            channel: createDefaultChannelModel(cid: _channelCid),
          ),
        );

        // Query with pagination params (fetching older messages)
        await tester.channel.query(messagesPagination: pagination);

        // Wait out the reporter's 1s trailing throttle so a receipt would
        // have been sent by now if the channel had been submitted.
        await Future.delayed(const Duration(milliseconds: 1100));

        // Verify no delivery receipt was sent
        tester.verifyNeverCalled(
          (api) => api.channel.markChannelsDelivered(any()),
        );
      },
    );
  });

  channelTest(
    '`.queryMembers`',
    channelType: _channelType,
    channelId: _channelId,
    build: _buildInitializedChannel,
    body: (tester) async {
      final filter = Filter.in_('cid', const [_channelCid]);

      final members = List.generate(
        3,
        (index) => Member(userId: 'test-user-id-$index'),
      );

      tester.mockApi(
        // The seeded channel state holds no members, so the SDK forwards an
        // empty list.
        (api) => api.general.queryMembers(
          _channelType,
          channelId: _channelId,
          filter: filter,
          members: const <Member>[],
        ),
        result: QueryMembersResponse()..members = members,
      );

      final res = await tester.channel.queryMembers(filter: filter);

      expect(res, isNotNull);
      expect(res.members.length, members.length);

      tester.verifyApi(
        (api) => api.general.queryMembers(
          _channelType,
          channelId: _channelId,
          filter: filter,
          members: const <Member>[],
        ),
      );
    },
  );

  channelTest(
    '`.queryBannedUsers`',
    channelType: _channelType,
    channelId: _channelId,
    build: _buildInitializedChannel,
    body: (tester) async {
      final filter = Filter.equal('channel_cid', _channelCid);

      final bans = List.generate(
        3,
        (index) => BannedUser(
          user: User(id: 'test-user-id-$index'),
          bannedBy: User(id: 'test-user-id-${index + 1}'),
        ),
      );

      tester.mockApi(
        (api) => api.moderation.queryBannedUsers(filter: filter),
        result: QueryBannedUsersResponse()..bans = bans,
      );

      final res = await tester.channel.queryBannedUsers();

      expect(res, isNotNull);
      expect(res.bans.length, bans.length);

      tester.verifyApi(
        (api) => api.moderation.queryBannedUsers(filter: filter),
      );
    },
  );
}
