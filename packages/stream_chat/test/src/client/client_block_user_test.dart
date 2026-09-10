import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  group('Block user state management', () {
    chatClientTest(
      'blockUser should update blockedUserIds on client state',
      body: (tester) async {
        final testUser = OwnUser(id: 'test-user');
        const userId = 'blocked-user-id';

        // Verify initial state
        expect(tester.currentUser?.blockedUserIds, isEmpty);

        tester.mockApi(
          (api) => api.user.blockUser(userId),
          result: createDefaultUserBlockResponse(
            blockedUserId: userId,
            blockedByUserId: testUser.id,
          ),
        );

        await tester.client.blockUser(userId);

        // Verify - should now include the blocked user ID
        expect(tester.currentUser?.blockedUserIds, contains(userId));
        tester
          ..verifyApi((api) => api.user.blockUser(userId))
          ..verifyNoMoreApiInteractions((api) => api.user);
      },
    );

    chatClientTest(
      'blockUser should not duplicate existing blocked user IDs',
      body: (tester) async {
        const userId = 'blocked-user-id';
        tester.clientState.blockedUserIds = const [userId];

        // Verify the user is already in the blocked list
        expect(tester.currentUser?.blockedUserIds, contains(userId));

        tester.mockApi(
          (api) => api.user.blockUser(userId),
          result: createDefaultUserBlockResponse(
            blockedUserId: userId,
            blockedByUserId: tester.currentUser!.id,
          ),
        );

        await tester.client.blockUser(userId);

        // Verify - should still have only one entry
        expect(tester.currentUser?.blockedUserIds, contains(userId));
        expect(tester.currentUser?.blockedUserIds.length, 1);
        tester
          ..verifyApi((api) => api.user.blockUser(userId))
          ..verifyNoMoreApiInteractions((api) => api.user);
      },
    );

    chatClientTest(
      'unblockUser should remove user from blockedUserIds',
      body: (tester) async {
        const blockedUserId = 'blocked-user-id';
        const otherBlockedId = 'other-blocked-id';
        tester.clientState.blockedUserIds = const [blockedUserId, otherBlockedId];

        // Verify initial state includes both blocked IDs
        expect(
          tester.currentUser?.blockedUserIds,
          containsAll([blockedUserId, otherBlockedId]),
        );

        tester.mockApi(
          (api) => api.user.unblockUser(blockedUserId),
          result: createDefaultEmptyResponse(),
        );

        await tester.client.unblockUser(blockedUserId);

        // Verify - blockedUserId should be removed
        expect(
          tester.currentUser?.blockedUserIds,
          contains(otherBlockedId),
        );

        expect(
          tester.currentUser?.blockedUserIds,
          isNot(contains(blockedUserId)),
        );

        tester
          ..verifyApi((api) => api.user.unblockUser(blockedUserId))
          ..verifyNoMoreApiInteractions((api) => api.user);
      },
    );

    chatClientTest(
      'unblockUser should be resilient if user ID not in blocked list',
      body: (tester) async {
        const nonBlockedUserId = 'not-in-list';
        const otherBlockedId = 'other-blocked-id';
        tester.clientState.blockedUserIds = const [otherBlockedId];

        // Verify initial state
        expect(
          tester.currentUser?.blockedUserIds,
          contains(otherBlockedId),
        );

        expect(
          tester.currentUser?.blockedUserIds,
          isNot(contains(nonBlockedUserId)),
        );

        tester.mockApi(
          (api) => api.user.unblockUser(nonBlockedUserId),
          result: createDefaultEmptyResponse(),
        );

        await tester.client.unblockUser(nonBlockedUserId);

        // Verify - should remain unchanged
        expect(tester.currentUser?.blockedUserIds, contains(otherBlockedId));
        expect(tester.currentUser?.blockedUserIds, isNot(contains(nonBlockedUserId)));
        tester
          ..verifyApi((api) => api.user.unblockUser(nonBlockedUserId))
          ..verifyNoMoreApiInteractions((api) => api.user);
      },
    );

    chatClientTest(
      'queryBlockedUsers should update client state with blockedUserIds',
      body: (tester) async {
        const blockedId1 = 'blocked-1';
        const blockedId2 = 'blocked-2';

        // Verify initial state
        expect(tester.currentUser?.blockedUserIds, isEmpty);

        // Create mock users
        final user = tester.user;
        final blockedUser1 = User(id: 'blocked-user-1');
        final blockedUser2 = User(id: 'blocked-user-2');

        // Mock the queryBlockedUsers API call
        tester.mockApi(
          (api) => api.user.queryBlockedUsers(),
          result: createDefaultBlockedUsersResponse(
            blocks: [
              UserBlock(
                user: user,
                userId: user.id,
                blockedUser: blockedUser1,
                blockedUserId: blockedId1,
              ),
              UserBlock(
                user: user,
                userId: user.id,
                blockedUser: blockedUser2,
                blockedUserId: blockedId2,
              ),
            ],
          ),
        );

        await tester.client.queryBlockedUsers();

        // Verify - should now include both blocked IDs
        expect(
          tester.currentUser?.blockedUserIds,
          containsAll([blockedId1, blockedId2]),
        );

        tester
          ..verifyApi((api) => api.user.queryBlockedUsers())
          ..verifyNoMoreApiInteractions((api) => api.user);
      },
    );
  });
}
