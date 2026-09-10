import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  chatClientTest(
    '`.updateUser`',
    body: (tester) async {
      final user = User(
        id: 'test-user-id',
        extraData: const {'name': 'test-user'},
      );

      tester.mockApi(
        (api) => api.user.updateUsers([user]),
        result: createDefaultUpdateUsersResponse(users: {user.id: user}),
      );

      final res = await tester.client.updateUser(user);

      expect(res, isNotNull);
      expect(res.users, {user.id: user});

      tester
        ..verifyApi((api) => api.user.updateUsers([user]))
        ..verifyNoMoreApiInteractions((api) => api.user);
    },
  );

  chatClientTest(
    '`.partialUpdateUser`',
    body: (tester) async {
      const userId = 'test-user-id';

      final set = {'color': 'yellow'};
      final unset = <String>[];

      final partialUpdateRequest = PartialUpdateUserRequest(
        id: userId,
        set: set,
        unset: unset,
      );

      final updatedUser = User(
        id: userId,
        extraData: {'color': set['color']},
      );

      tester.mockApi(
        (api) => api.user.partialUpdateUsers([partialUpdateRequest]),
        result: createDefaultUpdateUsersResponse(users: {updatedUser.id: updatedUser}),
      );

      final res = await tester.client.partialUpdateUser(
        userId,
        set: set,
        unset: unset,
      );

      expect(res, isNotNull);
      expect(res.users, {updatedUser.id: updatedUser});

      tester
        ..verifyApi((api) => api.user.partialUpdateUsers([partialUpdateRequest]))
        ..verifyNoMoreApiInteractions((api) => api.user);
    },
  );

  chatClientTest(
    '`.banUser`',
    body: (tester) async {
      const userId = 'test-user-id';

      tester.mockApi(
        (api) => api.moderation.banUser(userId, options: any(named: 'options')),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.banUser(userId);

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.moderation.banUser(userId, options: any(named: 'options')))
        ..verifyNoMoreApiInteractions((api) => api.moderation);
    },
  );

  chatClientTest(
    '`.unbanUser`',
    body: (tester) async {
      const userId = 'test-user-id';

      tester.mockApi(
        (api) => api.moderation.unbanUser(userId, options: any(named: 'options')),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.unbanUser(userId);

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.moderation.unbanUser(userId, options: any(named: 'options')))
        ..verifyNoMoreApiInteractions((api) => api.moderation);
    },
  );

  chatClientTest(
    '`.blockUser`',
    body: (tester) async {
      const userId = 'test-user-id';

      tester.mockApi(
        (api) => api.user.blockUser(userId),
        result: UserBlockResponse.fromJson({
          'blocked_by_user_id': 'deven',
          'blocked_user_id': 'jaap',
          'created_at': '2024-10-01 12:45:23.456',
        }),
      );

      final res = await tester.client.blockUser(userId);

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.user.blockUser(userId))
        ..verifyNoMoreApiInteractions((api) => api.user);
    },
  );

  chatClientTest(
    '`.unblockUser`',
    body: (tester) async {
      const userId = 'test-user-id';

      tester.mockApi(
        (api) => api.user.unblockUser(userId),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.unblockUser(userId);

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.user.unblockUser(userId))
        ..verifyNoMoreApiInteractions((api) => api.user);
    },
  );

  chatClientTest(
    '`.queryBlockedUsers`',
    body: (tester) async {
      final users = List.generate(
        3,
        (index) => User(id: 'test-user-id-$index'),
      );

      tester.mockApi(
        (api) => api.user.queryBlockedUsers(),
        result: createDefaultBlockedUsersResponse(
          blocks: [
            UserBlock(user: users[0], blockedUser: users[1]),
            UserBlock(user: users[0], blockedUser: users[2]),
          ],
        ),
      );

      final res = await tester.client.queryBlockedUsers();
      expect(res, isNotNull);
      expect(res.blocks.length, 2);

      tester
        ..verifyApi((api) => api.user.queryBlockedUsers())
        ..verifyNoMoreApiInteractions((api) => api.user);
    },
  );

  chatClientTest(
    '`.getUnreadCount`',
    body: (tester) async {
      tester.mockApi(
        (api) => api.user.getUnreadCount(),
        result: createDefaultGetUnreadCountResponse(
          totalUnreadCount: 42,
          totalUnreadThreadsCount: 8,
          channels: [
            UnreadCountsChannel(
              channelId: 'messaging:test-channel-1',
              unreadCount: 10,
              lastRead: DateTime.utc(2021, 3),
            ),
            UnreadCountsChannel(
              channelId: 'messaging:test-channel-2',
              unreadCount: 15,
              lastRead: DateTime.utc(2021, 3),
            ),
          ],
          threads: [
            UnreadCountsThread(
              unreadCount: 3,
              lastRead: DateTime.utc(2021, 3),
              lastReadMessageId: 'message-1',
              parentMessageId: 'parent-message-1',
            ),
            UnreadCountsThread(
              unreadCount: 5,
              lastRead: DateTime.utc(2021, 3),
              lastReadMessageId: 'message-2',
              parentMessageId: 'parent-message-2',
            ),
          ],
        ),
      );

      final res = await tester.client.getUnreadCount();

      expect(res, isNotNull);
      expect(res.totalUnreadCount, 42);
      expect(res.totalUnreadThreadsCount, 8);

      tester
        ..verifyApi((api) => api.user.getUnreadCount())
        ..verifyNoMoreApiInteractions((api) => api.user);
    },
  );

  chatClientTest(
    '`.getUnreadCount` should also update user unread count as a side effect',
    body: (tester) async {
      tester.mockApi(
        (api) => api.user.getUnreadCount(),
        result: createDefaultGetUnreadCountResponse(
          totalUnreadCount: 25,
          totalUnreadThreadsCount: 2,
          channels: [
            UnreadCountsChannel(
              channelId: 'messaging:test-channel-1',
              unreadCount: 10,
              lastRead: DateTime.utc(2021, 3),
            ),
            UnreadCountsChannel(
              channelId: 'messaging:test-channel-2',
              unreadCount: 15,
              lastRead: DateTime.utc(2021, 3),
            ),
          ],
          threads: [
            UnreadCountsThread(
              unreadCount: 3,
              lastRead: DateTime.utc(2021, 3),
              lastReadMessageId: 'message-1',
              parentMessageId: 'parent-message-1',
            ),
            UnreadCountsThread(
              unreadCount: 5,
              lastRead: DateTime.utc(2021, 3),
              lastReadMessageId: 'message-2',
              parentMessageId: 'parent-message-2',
            ),
          ],
        ),
      );

      tester.client.getUnreadCount().ignore();

      // Wait for the local side effect event to be processed
      await Future.delayed(Duration.zero);

      expect(tester.currentUser?.totalUnreadCount, 25);
      expect(tester.currentUser?.unreadChannels, 2); // channels.length
      expect(tester.currentUser?.unreadThreads, 2); // threads.length

      tester
        ..verifyApi((api) => api.user.getUnreadCount())
        ..verifyNoMoreApiInteractions((api) => api.user);
    },
  );

  chatClientTest(
    '`.shadowBan`',
    body: (tester) async {
      const userId = 'test-user-id';

      tester.mockApi(
        (api) => api.moderation.banUser(userId, options: {'shadow': true}),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.shadowBan(userId);

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.moderation.banUser(userId, options: {'shadow': true}))
        ..verifyNoMoreApiInteractions((api) => api.moderation);
    },
  );

  chatClientTest(
    '`.removeShadowBan`',
    body: (tester) async {
      const userId = 'test-user-id';

      tester.mockApi(
        (api) => api.moderation.unbanUser(userId, options: {'shadow': true}),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.removeShadowBan(userId);

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.moderation.unbanUser(userId, options: {'shadow': true}))
        ..verifyNoMoreApiInteractions((api) => api.moderation);
    },
  );

  chatClientTest(
    '`.muteUser`',
    body: (tester) async {
      const userId = 'test-user-id';

      tester.mockApi(
        (api) => api.moderation.muteUser(userId),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.muteUser(userId);

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.moderation.muteUser(userId))
        ..verifyNoMoreApiInteractions((api) => api.moderation);
    },
  );

  chatClientTest(
    '`.unmuteUser`',
    body: (tester) async {
      const userId = 'test-user-id';

      tester.mockApi(
        (api) => api.moderation.unmuteUser(userId),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.unmuteUser(userId);

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.moderation.unmuteUser(userId))
        ..verifyNoMoreApiInteractions((api) => api.moderation);
    },
  );

  chatClientTest(
    '`.flagMessage`',
    body: (tester) async {
      const messageId = 'test-message-id';

      tester.mockApi(
        (api) => api.moderation.flagMessage(messageId),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.flagMessage(messageId);

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.moderation.flagMessage(messageId))
        ..verifyNoMoreApiInteractions((api) => api.moderation);
    },
  );

  chatClientTest(
    '`.unflagMessage`',
    body: (tester) async {
      const messageId = 'test-message-id';

      tester.mockApi(
        (api) => api.moderation.unflagMessage(messageId),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.unflagMessage(messageId);

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.moderation.unflagMessage(messageId))
        ..verifyNoMoreApiInteractions((api) => api.moderation);
    },
  );

  chatClientTest(
    '`.flagUser`',
    body: (tester) async {
      const userId = 'test-message-id';

      tester.mockApi(
        (api) => api.moderation.flagUser(userId),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.flagUser(userId);

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.moderation.flagUser(userId))
        ..verifyNoMoreApiInteractions((api) => api.moderation);
    },
  );

  chatClientTest(
    '`.unflagUser`',
    body: (tester) async {
      const userId = 'test-message-id';

      tester.mockApi(
        (api) => api.moderation.unflagUser(userId),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.unflagUser(userId);

      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.moderation.unflagUser(userId))
        ..verifyNoMoreApiInteractions((api) => api.moderation);
    },
  );

  chatClientTest(
    '`.getActiveLiveLocations`',
    body: (tester) async {
      final locations = [
        Location(
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device-1',
          endAt: DateTime.timestamp().add(const Duration(hours: 1)),
        ),
        Location(
          latitude: 34.0522,
          longitude: -118.2437,
          createdByDeviceId: 'device-2',
          endAt: DateTime.timestamp().add(const Duration(hours: 2)),
        ),
      ];

      tester.mockApi(
        (api) => api.user.getActiveLiveLocations(),
        result: GetActiveLiveLocationsResponse()..activeLiveLocations = locations,
      );

      // Initial state should be empty
      expect(tester.clientState.activeLiveLocations, isEmpty);

      final res = await tester.client.getActiveLiveLocations();

      expect(res, isNotNull);
      expect(res.activeLiveLocations, hasLength(2));
      expect(res.activeLiveLocations, equals(locations));
      expect(tester.clientState.activeLiveLocations, equals(locations));

      tester
        ..verifyApi((api) => api.user.getActiveLiveLocations())
        ..verifyNoMoreApiInteractions((api) => api.user);
    },
  );

  chatClientTest(
    '`.updateLiveLocation`',
    body: (tester) async {
      const messageId = 'test-message-id';
      const createdByDeviceId = 'test-device-id';
      final endAt = DateTime.timestamp().add(const Duration(hours: 1));
      const location = LocationCoordinates(
        latitude: 40.7128,
        longitude: -74.0060,
      );

      final expectedLocation = Location(
        latitude: location.latitude,
        longitude: location.longitude,
        createdByDeviceId: createdByDeviceId,
        endAt: endAt,
      );

      tester.mockApi(
        (api) => api.user.updateLiveLocation(
          messageId: messageId,
          createdByDeviceId: createdByDeviceId,
          location: location,
          endAt: endAt,
        ),
        result: expectedLocation,
      );

      final res = await tester.client.updateLiveLocation(
        messageId: messageId,
        createdByDeviceId: createdByDeviceId,
        location: location,
        endAt: endAt,
      );

      expect(res, isNotNull);
      expect(res, equals(expectedLocation));

      tester
        ..verifyApi(
          (api) => api.user.updateLiveLocation(
            messageId: messageId,
            createdByDeviceId: createdByDeviceId,
            location: location,
            endAt: endAt,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.user);
    },
  );

  chatClientTest(
    '`.stopLiveLocation`',
    body: (tester) async {
      const messageId = 'test-message-id';
      const createdByDeviceId = 'test-device-id';

      final expectedLocation = Location(
        latitude: 40.7128,
        longitude: -74.0060,
        createdByDeviceId: createdByDeviceId,
        endAt: DateTime.timestamp(), // Should be expired
      );

      tester.mockApi(
        (api) => api.user.updateLiveLocation(
          messageId: messageId,
          createdByDeviceId: createdByDeviceId,
          endAt: any(named: 'endAt'),
        ),
        result: expectedLocation,
      );

      final res = await tester.client.stopLiveLocation(
        messageId: messageId,
        createdByDeviceId: createdByDeviceId,
      );

      expect(res, isNotNull);
      expect(res, equals(expectedLocation));

      tester
        ..verifyApi(
          (api) => api.user.updateLiveLocation(
            messageId: messageId,
            createdByDeviceId: createdByDeviceId,
            endAt: any(named: 'endAt'),
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.user);
    },
  );
}
