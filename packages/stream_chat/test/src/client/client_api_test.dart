import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  chatClientTest(
    '`.queryUsers`',
    body: (tester) async {
      final users = List.generate(
        3,
        (index) => User(id: 'test-user-id-$index'),
      );

      tester.mockApi(
        (api) => api.user.queryUsers(presence: true),
        result: QueryUsersResponse()..users = users,
      );

      final usersEmitted = expectLater(
        // skipping initial seed event -> {} users
        tester.clientState.usersStream.skip(1),
        emitsInOrder([
          {for (final user in users) user.id: user},
        ]),
      );

      final res = await tester.client.queryUsers();
      expect(res, isNotNull);
      expect(res.users.length, users.length);

      await usersEmitted;

      tester
        ..verifyApi((api) => api.user.queryUsers(presence: true))
        ..verifyNoMoreApiInteractions((api) => api.user);
    },
  );

  chatClientTest(
    '`.queryBannedUsers`',
    body: (tester) async {
      final bans = List.generate(
        3,
        (index) => BannedUser(
          user: User(id: 'test-user-id-$index'),
          bannedBy: User(id: 'test-user-id-${index + 1}'),
        ),
      );

      const cid = 'message:nice-channel';
      final filter = Filter.equal('channel_cid', cid);

      tester.mockApi(
        (api) => api.moderation.queryBannedUsers(filter: filter),
        result: QueryBannedUsersResponse()..bans = bans,
      );

      final res = await tester.client.queryBannedUsers(filter: filter);
      expect(res, isNotNull);
      expect(res.bans.length, bans.length);

      tester
        ..verifyApi((api) => api.moderation.queryBannedUsers(filter: filter))
        ..verifyNoMoreApiInteractions((api) => api.moderation);
    },
  );

  chatClientTest(
    '`.search`',
    body: (tester) async {
      const cid = 'test-type:test-id';
      final filter = Filter.in_('cid', const [cid]);

      final messages = List.generate(
        3,
        (index) => createDefaultGetMessageResponse(
          channel: ChannelModel(cid: cid),
          message: Message(id: 'test-message-id-$index'),
        ),
      );

      tester.mockApi(
        (api) => api.general.searchMessages(filter),
        result: createDefaultSearchMessagesResponse(results: messages),
      );

      final res = await tester.client.search(filter);
      expect(res, isNotNull);
      expect(res.results.length, messages.length);

      tester
        ..verifyApi((api) => api.general.searchMessages(filter))
        ..verifyApi((api) => api.general.getAppSettings())
        ..verifyNoMoreApiInteractions((api) => api.general);
    },
  );

  chatClientTest(
    '`.sendFile`',
    body: (tester) async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      final file = AttachmentFile(size: 33, path: 'test-file-path');

      const fileUrl = 'test-file-url';

      tester.mockApi(
        (api) => api.fileUploader.sendFile(file, channelId, channelType),
        result: SendFileResponse()..file = fileUrl,
      );

      final res = await tester.client.sendFile(file, channelId, channelType);
      expect(res, isNotNull);
      expect(res.file, fileUrl);

      tester
        ..verifyApi((api) => api.fileUploader.sendFile(file, channelId, channelType))
        ..verifyNoMoreApiInteractions((api) => api.fileUploader);
    },
  );

  chatClientTest(
    '`.sendImage`',
    body: (tester) async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      final image = AttachmentFile(size: 33, path: 'test-image-path');

      const fileUrl = 'test-image-url';

      tester.mockApi(
        (api) => api.fileUploader.sendImage(image, channelId, channelType),
        result: SendImageResponse()..file = fileUrl,
      );

      final res = await tester.client.sendImage(image, channelId, channelType);
      expect(res, isNotNull);
      expect(res.file, fileUrl);

      tester
        ..verifyApi((api) => api.fileUploader.sendImage(image, channelId, channelType))
        ..verifyNoMoreApiInteractions((api) => api.fileUploader);
    },
  );

  chatClientTest(
    '`.deleteFile`',
    body: (tester) async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      const fileUrl = 'test-file-url';

      tester.mockApi(
        (api) => api.fileUploader.deleteFile(fileUrl, channelId, channelType),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.deleteFile(fileUrl, channelId, channelType);
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.fileUploader.deleteFile(fileUrl, channelId, channelType))
        ..verifyNoMoreApiInteractions((api) => api.fileUploader);
    },
  );

  chatClientTest(
    '`.deleteImage`',
    body: (tester) async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      const imageUrl = 'test-image-url';

      tester.mockApi(
        (api) => api.fileUploader.deleteImage(imageUrl, channelId, channelType),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.deleteImage(imageUrl, channelId, channelType);
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.fileUploader.deleteImage(imageUrl, channelId, channelType))
        ..verifyNoMoreApiInteractions((api) => api.fileUploader);
    },
  );

  chatClientTest(
    '`.uploadImage`',
    body: (tester) async {
      final image = AttachmentFile(size: 33, path: 'test-image-path');
      const fileUrl = 'test-image-url';

      tester.mockApi(
        (api) => api.fileUploader.uploadImage(image),
        result: UploadImageResponse()..file = fileUrl,
      );

      final res = await tester.client.uploadImage(image);
      expect(res, isNotNull);
      expect(res.file, fileUrl);

      tester
        ..verifyApi((api) => api.fileUploader.uploadImage(image))
        ..verifyNoMoreApiInteractions((api) => api.fileUploader);
    },
  );

  chatClientTest(
    '`.uploadFile`',
    body: (tester) async {
      final file = AttachmentFile(size: 33, path: 'test-file-path');
      const fileUrl = 'test-file-url';

      tester.mockApi(
        (api) => api.fileUploader.uploadFile(file),
        result: UploadFileResponse()..file = fileUrl,
      );

      final res = await tester.client.uploadFile(file);
      expect(res, isNotNull);
      expect(res.file, fileUrl);

      tester
        ..verifyApi((api) => api.fileUploader.uploadFile(file))
        ..verifyNoMoreApiInteractions((api) => api.fileUploader);
    },
  );

  chatClientTest(
    '`.removeImage`',
    body: (tester) async {
      const imageUrl = 'test-image-url';

      tester.mockApi(
        (api) => api.fileUploader.removeImage(imageUrl),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.removeImage(imageUrl);
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.fileUploader.removeImage(imageUrl))
        ..verifyNoMoreApiInteractions((api) => api.fileUploader);
    },
  );

  chatClientTest(
    '`.removeFile`',
    body: (tester) async {
      const fileUrl = 'test-file-url';

      tester.mockApi(
        (api) => api.fileUploader.removeFile(fileUrl),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.removeFile(fileUrl);
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.fileUploader.removeFile(fileUrl))
        ..verifyNoMoreApiInteractions((api) => api.fileUploader);
    },
  );

  chatClientTest(
    '`.updateChannel`',
    body: (tester) async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      const data = {'name': 'test-channel'};

      tester.mockApi(
        (api) => api.channel.updateChannel(channelId, channelType, data),
        result: UpdateChannelResponse()
          ..channel = ChannelModel(
            id: channelId,
            type: channelType,
            extraData: {...data},
          ),
      );

      final res = await tester.client.updateChannel(channelId, channelType, data);
      expect(res, isNotNull);
      expect(res.channel.cid, '$channelType:$channelId');
      expect(res.channel.extraData['name'], 'test-channel');

      tester
        ..verifyApi((api) => api.channel.updateChannel(channelId, channelType, data))
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.updateChannelPartial`',
    body: (tester) async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      const set = {
        'name': 'Stream Team',
        'profile_image': 'test-profile-image',
      };
      const unset = ['tag', 'last_name'];

      tester.mockApi(
        (api) => api.channel.updateChannelPartial(channelId, channelType, set: set, unset: unset),
        result: createDefaultPartialUpdateChannelResponse(
          channel: ChannelModel(
            id: channelId,
            type: channelType,
            extraData: {...set},
          ),
        ),
      );

      final res = await tester.client.updateChannelPartial(
        channelId,
        channelType,
        set: set,
        unset: unset,
      );
      expect(res, isNotNull);
      expect(res.channel.cid, '$channelType:$channelId');
      expect(res.channel.extraData, set);

      tester
        ..verifyApi((api) => api.channel.updateChannelPartial(channelId, channelType, set: set, unset: unset))
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.addDevice should work`',
    body: (tester) async {
      const id = 'test-device-id';
      const provider = PushProvider.firebase;

      tester.mockApi(
        (api) => api.device.addDevice(id, provider),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.addDevice(id, provider);
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.device.addDevice(id, provider))
        ..verifyNoMoreApiInteractions((api) => api.device);
    },
  );

  chatClientTest(
    '`.addDevice should work with pushProviderName`',
    body: (tester) async {
      const id = 'test-device-id';
      const provider = PushProvider.firebase;
      const pushProviderName = 'my-custom-config';

      tester.mockApi(
        (api) => api.device.addDevice(
          id,
          provider,
          pushProviderName: pushProviderName,
        ),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.addDevice(
        id,
        provider,
        pushProviderName: pushProviderName,
      );
      expect(res, isNotNull);

      tester
        ..verifyApi(
          (api) => api.device.addDevice(
            id,
            provider,
            pushProviderName: pushProviderName,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.device);
    },
  );

  chatClientTest(
    '`.getDevices`',
    body: (tester) async {
      final devices = List.generate(
        3,
        (index) => Device(
          id: 'test-device-id-$index',
          pushProvider: PushProvider.firebase.name,
        ),
      );

      tester.mockApi(
        (api) => api.device.getDevices(),
        result: ListDevicesResponse()..devices = devices,
      );

      final res = await tester.client.getDevices();
      expect(res, isNotNull);
      expect(res.devices.length, devices.length);

      tester
        ..verifyApi((api) => api.device.getDevices())
        ..verifyNoMoreApiInteractions((api) => api.device);
    },
  );

  chatClientTest(
    '`.removeDevice`',
    body: (tester) async {
      const deviceId = 'test-device-id';

      tester.mockApi(
        (api) => api.device.removeDevice(deviceId),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.removeDevice(deviceId);
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.device.removeDevice(deviceId))
        ..verifyNoMoreApiInteractions((api) => api.device);
    },
  );

  chatClientTest(
    '`.setPushPreferences`',
    body: (tester) async {
      const pushPreferenceInput = PushPreferenceInput(
        chatLevel: ChatLevel.mentions,
      );

      const channelCid = 'messaging:123';
      const channelPreferenceInput = PushPreferenceInput.channel(
        channelCid: channelCid,
        chatLevel: ChatLevel.mentions,
      );

      const preferences = [pushPreferenceInput, channelPreferenceInput];

      final currentUser = tester.currentUser;
      tester.mockApi(
        (api) => api.device.setPushPreferences(preferences),
        result: UpsertPushPreferencesResponse()
          ..userPreferences = {
            '${currentUser?.id}': PushPreference(
              chatLevel: pushPreferenceInput.chatLevel,
            ),
          }
          ..userChannelPreferences = {
            '${currentUser?.id}': {
              channelCid: ChannelPushPreference(
                chatLevel: channelPreferenceInput.chatLevel,
              ),
            },
          },
      );

      expect(
        tester.events,
        emitsInOrder([
          isA<Event>().having(
            (e) => e.type,
            'push_preference.updated event',
            EventType.pushPreferenceUpdated,
          ),
          isA<Event>().having(
            (e) => e.type,
            'channel.push_preference.updated event',
            EventType.channelPushPreferenceUpdated,
          ),
        ]),
      );

      final res = await tester.client.setPushPreferences(preferences);
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.device.setPushPreferences(preferences))
        ..verifyNoMoreApiInteractions((api) => api.device);
    },
  );

  chatClientTest(
    'should handle push_preference.updated event',
    body: (tester) async {
      final pushPreference = PushPreference(
        chatLevel: ChatLevel.mentions,
        callLevel: CallLevel.all,
        disabledUntil: DateTime.utc(2021, 3),
      );

      final event = createDefaultEvent(
        type: EventType.pushPreferenceUpdated,
        pushPreference: pushPreference,
      );

      // Initially null
      expect(tester.currentUser?.pushPreferences, isNull);

      // Trigger the event
      await tester.emitEvent(event);

      // Should update currentUser.pushPreferences
      final pushPreferences = tester.currentUser?.pushPreferences;
      expect(pushPreferences, isNotNull);
      expect(pushPreferences?.chatLevel, ChatLevel.mentions);
      expect(pushPreferences?.callLevel, CallLevel.all);
      expect(pushPreferences?.disabledUntil, pushPreference.disabledUntil);
    },
  );

  chatClientTest(
    '`.listUserGroups`',
    body: (tester) async {
      const limit = 10;
      const idGt = 'cursor-group-id';
      final createdAtGt = DateTime.utc(2024, 6, 15, 12);
      const teamId = 'test-team-id';

      tester.mockApi(
        (api) => api.userGroups.listUserGroups(
          limit: limit,
          idGt: idGt,
          createdAtGt: createdAtGt,
          teamId: teamId,
        ),
        result: ListUserGroupsResponse()..userGroups = const [],
      );

      final res = await tester.client.listUserGroups(
        limit: limit,
        idGt: idGt,
        createdAtGt: createdAtGt,
        teamId: teamId,
      );
      expect(res, isNotNull);

      tester
        ..verifyApi(
          (api) => api.userGroups.listUserGroups(
            limit: limit,
            idGt: idGt,
            createdAtGt: createdAtGt,
            teamId: teamId,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.userGroups);
    },
  );

  chatClientTest(
    '`.searchUserGroups`',
    body: (tester) async {
      const query = 'eng';
      const limit = 10;
      const nameGt = 'engineering';
      const idGt = 'cursor-group-id';
      const teamId = 'test-team-id';

      tester.mockApi(
        (api) => api.userGroups.searchUserGroups(
          query,
          limit: limit,
          nameGt: nameGt,
          idGt: idGt,
          teamId: teamId,
        ),
        result: SearchUserGroupsResponse()..userGroups = const [],
      );

      final res = await tester.client.searchUserGroups(
        query,
        limit: limit,
        nameGt: nameGt,
        idGt: idGt,
        teamId: teamId,
      );
      expect(res, isNotNull);

      tester
        ..verifyApi(
          (api) => api.userGroups.searchUserGroups(
            query,
            limit: limit,
            nameGt: nameGt,
            idGt: idGt,
            teamId: teamId,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.userGroups);
    },
  );

  chatClientTest(
    '`.getUserGroup`',
    body: (tester) async {
      const id = 'test-group-id';
      const teamId = 'test-team-id';

      tester.mockApi(
        (api) => api.userGroups.getUserGroup(id, teamId: teamId),
        result: GetUserGroupResponse()
          ..userGroup = UserGroup(
            id: id,
            name: 'test-group-name',
            createdAt: DateTime.utc(2024, 1, 1),
            updatedAt: DateTime.utc(2024, 1, 2),
          ),
      );

      final res = await tester.client.getUserGroup(id, teamId: teamId);
      expect(res, isNotNull);
      expect(res.userGroup.id, id);

      tester
        ..verifyApi((api) => api.userGroups.getUserGroup(id, teamId: teamId))
        ..verifyNoMoreApiInteractions((api) => api.userGroups);
    },
  );

  chatClientTest(
    '`.createUserGroup`',
    body: (tester) async {
      const name = 'Engineering';
      const id = 'eng';
      const description = 'Engineering team';
      const teamId = 'test-team-id';
      const memberIds = ['user-1', 'user-2'];

      tester.mockApi(
        (api) => api.userGroups.createUserGroup(
          name,
          id: id,
          description: description,
          teamId: teamId,
          memberIds: memberIds,
        ),
        result: CreateUserGroupResponse()
          ..userGroup = UserGroup(
            id: id,
            name: name,
            description: description,
            teamId: teamId,
            createdAt: DateTime.utc(2024, 1, 1),
            updatedAt: DateTime.utc(2024, 1, 2),
          ),
      );

      final res = await tester.client.createUserGroup(
        name,
        id: id,
        description: description,
        teamId: teamId,
        memberIds: memberIds,
      );
      expect(res, isNotNull);
      expect(res.userGroup.id, id);

      tester
        ..verifyApi(
          (api) => api.userGroups.createUserGroup(
            name,
            id: id,
            description: description,
            teamId: teamId,
            memberIds: memberIds,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.userGroups);
    },
  );

  chatClientTest(
    '`.updateUserGroup`',
    body: (tester) async {
      const id = 'test-group-id';
      const name = 'New Name';
      const description = 'New description';
      const teamId = 'test-team-id';

      tester.mockApi(
        (api) => api.userGroups.updateUserGroup(
          id,
          name: name,
          description: description,
          teamId: teamId,
        ),
        result: UpdateUserGroupResponse()
          ..userGroup = UserGroup(
            id: id,
            name: name,
            description: description,
            teamId: teamId,
            createdAt: DateTime.utc(2024, 1, 1),
            updatedAt: DateTime.utc(2024, 1, 2),
          ),
      );

      final res = await tester.client.updateUserGroup(
        id,
        name: name,
        description: description,
        teamId: teamId,
      );
      expect(res, isNotNull);
      expect(res.userGroup.name, name);

      tester
        ..verifyApi(
          (api) => api.userGroups.updateUserGroup(
            id,
            name: name,
            description: description,
            teamId: teamId,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.userGroups);
    },
  );

  chatClientTest(
    '`.deleteUserGroup`',
    body: (tester) async {
      const id = 'test-group-id';
      const teamId = 'test-team-id';

      tester.mockApi(
        (api) => api.userGroups.deleteUserGroup(id, teamId: teamId),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.deleteUserGroup(id, teamId: teamId);
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.userGroups.deleteUserGroup(id, teamId: teamId))
        ..verifyNoMoreApiInteractions((api) => api.userGroups);
    },
  );

  chatClientTest(
    '`.addUserGroupMembers`',
    body: (tester) async {
      const id = 'test-group-id';
      const memberIds = ['user-1', 'user-2'];
      const asAdmin = true;
      const teamId = 'test-team-id';

      tester.mockApi(
        (api) => api.userGroups.addUserGroupMembers(
          id,
          memberIds,
          asAdmin: asAdmin,
          teamId: teamId,
        ),
        result: AddUserGroupMembersResponse()
          ..userGroup = UserGroup(
            id: id,
            name: 'test-group-name',
            createdAt: DateTime.utc(2024, 1, 1),
            updatedAt: DateTime.utc(2024, 1, 2),
          ),
      );

      final res = await tester.client.addUserGroupMembers(
        id,
        memberIds,
        asAdmin: asAdmin,
        teamId: teamId,
      );
      expect(res, isNotNull);

      tester
        ..verifyApi(
          (api) => api.userGroups.addUserGroupMembers(
            id,
            memberIds,
            asAdmin: asAdmin,
            teamId: teamId,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.userGroups);
    },
  );

  chatClientTest(
    '`.removeUserGroupMembers`',
    body: (tester) async {
      const id = 'test-group-id';
      const memberIds = ['user-1', 'user-2'];
      const teamId = 'test-team-id';

      tester.mockApi(
        (api) => api.userGroups.removeUserGroupMembers(
          id,
          memberIds,
          teamId: teamId,
        ),
        result: RemoveUserGroupMembersResponse()
          ..userGroup = UserGroup(
            id: id,
            name: 'test-group-name',
            createdAt: DateTime.utc(2024, 1, 1),
            updatedAt: DateTime.utc(2024, 1, 2),
          ),
      );

      final res = await tester.client.removeUserGroupMembers(
        id,
        memberIds,
        teamId: teamId,
      );
      expect(res, isNotNull);

      tester
        ..verifyApi(
          (api) => api.userGroups.removeUserGroupMembers(
            id,
            memberIds,
            teamId: teamId,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.userGroups);
    },
  );

  chatClientTest(
    '`.searchRoles`',
    body: (tester) async {
      const query = 'adm';
      const limit = 10;
      const nameGt = 'admin';
      const roleType = RoleType.user;
      const includeGlobalRoles = true;

      tester.mockApi(
        (api) => api.roles.searchRoles(
          query,
          limit: limit,
          nameGt: nameGt,
          roleType: roleType,
          includeGlobalRoles: includeGlobalRoles,
        ),
        result: SearchRolesResponse()..roles = const [],
      );

      final res = await tester.client.searchRoles(
        query,
        limit: limit,
        nameGt: nameGt,
        roleType: roleType,
        includeGlobalRoles: includeGlobalRoles,
      );
      expect(res, isNotNull);

      tester
        ..verifyApi(
          (api) => api.roles.searchRoles(
            query,
            limit: limit,
            nameGt: nameGt,
            roleType: roleType,
            includeGlobalRoles: includeGlobalRoles,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.roles);
    },
  );

  chatClientTest(
    '`.devToken`',
    body: (tester) async {
      const userId = 'test-user-id';

      final token = tester.client.devToken(userId);

      expect(token, isNotNull);
      expect(token.userId, userId);
      expect(token.authType, AuthType.jwt);
    },
  );

  chatClientTest(
    '`.markAllRead`',
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.markAllRead(),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.markAllRead();
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.channel.markAllRead())
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.markChannelsDelivered`',
    body: (tester) async {
      final deliveries = [
        const MessageDelivery(
          channelCid: 'messaging:test-channel-1',
          messageId: 'test-message-id-1',
        ),
        const MessageDelivery(
          channelCid: 'messaging:test-channel-2',
          messageId: 'test-message-id-2',
        ),
      ];

      tester.mockApi(
        (api) => api.channel.markChannelsDelivered(deliveries),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.markChannelsDelivered(deliveries);
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.channel.markChannelsDelivered(deliveries))
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.sendEvent`',
    body: (tester) async {
      const channelType = 'test-channel-type';
      const channelId = 'test-channel-id';
      final event = Event(type: EventType.any);

      tester.mockApi(
        (api) => api.channel.sendEvent(
          channelId,
          channelType,
          any(that: isSameEventAs(event)),
        ),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.sendEvent(channelId, channelType, event);
      expect(res, isNotNull);

      tester
        ..verifyApi(
          (api) => api.channel.sendEvent(
            channelId,
            channelType,
            any(that: isSameEventAs(event)),
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.channel);
    },
  );

  chatClientTest(
    '`.sendReaction`',
    body: (tester) async {
      const messageId = 'test-message-id';
      const reactionType = 'like';
      const emojiCode = '👍';
      const score = 4;

      final reaction = Reaction(
        type: reactionType,
        messageId: messageId,
        emojiCode: emojiCode,
        score: score,
      );

      tester.mockApi(
        (api) => api.message.sendReaction(messageId, reaction),
        result: createDefaultSendReactionResponse(
          message: Message(id: messageId),
          reaction: reaction,
        ),
      );

      final res = await tester.client.sendReaction(messageId, reaction);
      expect(res, isNotNull);
      expect(res.message.id, messageId);
      expect(res.reaction.type, reactionType);
      expect(res.reaction.emojiCode, emojiCode);
      expect(res.reaction.score, score);
      expect(res.reaction.messageId, messageId);

      tester
        ..verifyApi((api) => api.message.sendReaction(messageId, reaction))
        ..verifyNoMoreApiInteractions((api) => api.message);
    },
  );

  chatClientTest(
    '`.deleteReaction`',
    body: (tester) async {
      const messageId = 'test-message-id';
      const reactionType = 'like';

      tester.mockApi(
        (api) => api.message.deleteReaction(messageId, reactionType),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.deleteReaction(messageId, reactionType);
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.message.deleteReaction(messageId, reactionType))
        ..verifyNoMoreApiInteractions((api) => api.message);
    },
  );

  chatClientTest(
    '`.sendMessage`',
    body: (tester) async {
      final message = Message(id: 'test-message-id');
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      tester.mockApi(
        (api) => api.message.sendMessage(channelId, channelType, any(that: isSameMessageAs(message))),
        result: createDefaultSendMessageResponse(message: message),
      );

      final res = await tester.client.sendMessage(message, channelId, channelType);
      expect(res, isNotNull);
      expect(res.message, isSameMessageAs(message));

      tester
        ..verifyApi(
          (api) => api.message.sendMessage(
            channelId,
            channelType,
            any(that: isSameMessageAs(message)),
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.message);
    },
  );

  chatClientTest(
    '`.createDraft`',
    body: (tester) async {
      final message = DraftMessage(id: 'test-message-id', text: 'Hello!');
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      tester.mockApi(
        (api) => api.message.createDraft(
          channelId,
          channelType,
          any(that: isSameDraftMessageAs(message)),
        ),
        result: createDefaultCreateDraftResponse(
          draft: createDefaultDraft(
            channelCid: '$channelType:$channelId',
            message: message,
          ),
        ),
      );

      final res = await tester.client.createDraft(
        message,
        channelId,
        channelType,
      );

      expect(res, isNotNull);
      expect(res.draft.message, isSameDraftMessageAs(message));

      tester
        ..verifyApi(
          (api) => api.message.createDraft(
            channelId,
            channelType,
            any(that: isSameDraftMessageAs(message)),
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.message);
    },
  );

  chatClientTest(
    '`.deleteDraft`',
    body: (tester) async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      tester.mockApi(
        (api) => api.message.deleteDraft(channelId, channelType),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.deleteDraft(channelId, channelType);
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.message.deleteDraft(channelId, channelType))
        ..verifyNoMoreApiInteractions((api) => api.message);
    },
  );

  chatClientTest(
    '`.getDraft`',
    body: (tester) async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      final message = DraftMessage(id: 'test-message-id', text: 'Hello!');

      tester.mockApi(
        (api) => api.message.getDraft(channelId, channelType),
        result: createDefaultGetDraftResponse(
          draft: createDefaultDraft(
            channelCid: '$channelType:$channelId',
            message: message,
          ),
        ),
      );

      final res = await tester.client.getDraft(channelId, channelType);

      expect(res, isNotNull);
      expect(res.draft.message, isSameDraftMessageAs(message));

      tester
        ..verifyApi((api) => api.message.getDraft(channelId, channelType))
        ..verifyNoMoreApiInteractions((api) => api.message);
    },
  );

  chatClientTest(
    '`.queryDrafts`',
    body: (tester) async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';

      final filter = Filter.equal('channel_cid', '$channelType:$channelId');
      final sort = [const SortOption<Draft>.desc('created_at')];
      const pagination = PaginationParams(limit: 20);

      final drafts = [
        createDefaultDraft(
          channelCid: '$channelType:$channelId',
          message: DraftMessage(id: 'test-message-id', text: 'Hello!'),
        ),
      ];

      tester.mockApi(
        (api) => api.message.queryDrafts(
          filter: filter,
          sort: sort,
          pagination: pagination,
        ),
        result: QueryDraftsResponse()..drafts = drafts,
      );

      final res = await tester.client.queryDrafts(
        filter: filter,
        sort: sort,
        pagination: pagination,
      );

      expect(res, isNotNull);
      expect(res.drafts.length, drafts.length);

      tester
        ..verifyApi(
          (api) => api.message.queryDrafts(
            filter: filter,
            sort: sort,
            pagination: pagination,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.message);
    },
  );

  chatClientTest(
    '`.getReplies`',
    body: (tester) async {
      const parentId = 'test-parent-id';

      final messages = List.generate(
        3,
        (index) => Message(id: 'test-message-id-$index'),
      );

      tester.mockApi(
        (api) => api.message.getReplies(parentId),
        result: createDefaultQueryRepliesResponse(messages: messages),
      );

      final res = await tester.client.getReplies(parentId);
      expect(res, isNotNull);
      expect(res.messages.length, messages.length);

      tester
        ..verifyApi((api) => api.message.getReplies(parentId))
        ..verifyNoMoreApiInteractions((api) => api.message);
    },
  );

  chatClientTest(
    '`.getReactions`',
    body: (tester) async {
      const messageId = 'test-parent-id';

      final reactions = List.generate(
        3,
        (index) => Reaction(
          type: 'test-reactions-type-$index',
          messageId: messageId,
        ),
      );

      tester.mockApi(
        (api) => api.message.getReactions(messageId),
        result: createDefaultQueryReactionsResponse(reactions: reactions),
      );

      final res = await tester.client.getReactions(messageId);
      expect(res, isNotNull);
      expect(res.reactions.length, reactions.length);
      expect(res.reactions.every((it) => it.messageId == messageId), isTrue);

      tester
        ..verifyApi((api) => api.message.getReactions(messageId))
        ..verifyNoMoreApiInteractions((api) => api.message);
    },
  );

  chatClientTest(
    '`.queryReactions`',
    body: (tester) async {
      const messageId = 'test-message-id';

      final reactions = List.generate(
        3,
        (index) => Reaction(
          type: 'test-reactions-type-$index',
          messageId: messageId,
        ),
      );

      tester.mockApi(
        (api) => api.message.queryReactions(messageId),
        result: createDefaultQueryReactionsResponse(reactions: reactions),
      );

      final res = await tester.client.queryReactions(messageId);
      expect(res, isNotNull);
      expect(res.reactions.length, reactions.length);
      expect(res.reactions.every((it) => it.messageId == messageId), isTrue);

      tester
        ..verifyApi((api) => api.message.queryReactions(messageId))
        ..verifyNoMoreApiInteractions((api) => api.message);
    },
  );

  chatClientTest(
    '`.updateMessage`',
    body: (tester) async {
      final message = Message(id: 'test-message-id', text: 'Hello!');

      tester.mockApi(
        (api) => api.message.updateMessage(any(that: isSameMessageAs(message))),
        result: createDefaultUpdateMessageResponse(message: message),
      );

      final res = await tester.client.updateMessage(message);
      expect(res, isNotNull);
      expect(res.message, isSameMessageAs(message));

      tester
        ..verifyApi(
          (api) => api.message.updateMessage(any(that: isSameMessageAs(message))),
        )
        ..verifyNoMoreApiInteractions((api) => api.message);
    },
  );

  chatClientTest(
    '`.deleteMessage`',
    body: (tester) async {
      const messageId = 'test-message-id';

      tester.mockApi(
        (api) => api.message.deleteMessage(messageId, hard: false),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.deleteMessage(messageId);
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.message.deleteMessage(messageId, hard: false))
        ..verifyNoMoreApiInteractions((api) => api.message);
    },
  );

  chatClientTest(
    '`.deleteMessageForMe`',
    body: (tester) async {
      const messageId = 'test-message-id';

      tester.mockApi(
        (api) => api.message.deleteMessage(messageId, deleteForMe: true),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.deleteMessageForMe(messageId);
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.message.deleteMessage(messageId, deleteForMe: true))
        ..verifyNoMoreApiInteractions((api) => api.message);
    },
  );

  chatClientTest(
    '`.getMessage`',
    body: (tester) async {
      const messageId = 'test-message-id';
      final message = Message(id: messageId);

      tester.mockApi(
        (api) => api.message.getMessage(messageId),
        result: createDefaultGetMessageResponse(message: message),
      );

      final res = await tester.client.getMessage(messageId);
      expect(res, isNotNull);
      expect(res.message.id, messageId);

      tester
        ..verifyApi((api) => api.message.getMessage(messageId))
        ..verifyNoMoreApiInteractions((api) => api.message);
    },
  );

  chatClientTest(
    '`.getMessagesById`',
    body: (tester) async {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      const messageIds = ['test-message-id'];

      final messages = messageIds.map((id) => Message(id: id)).toList();

      tester.mockApi(
        (api) => api.message.getMessagesById(channelId, channelType, messageIds),
        result: createDefaultGetMessagesByIdResponse(messages: messages),
      );

      final res = await tester.client.getMessagesById(
        channelId,
        channelType,
        messageIds,
      );
      expect(res, isNotNull);
      expect(res.messages.length, messageIds.length);

      tester
        ..verifyApi(
          (api) => api.message.getMessagesById(channelId, channelType, messageIds),
        )
        ..verifyNoMoreApiInteractions((api) => api.message);
    },
  );

  chatClientTest(
    '`.translateMessage`',
    body: (tester) async {
      const messageId = 'test-message-id';
      const language = 'hi'; // Hindi
      const translatedMessageText = 'नमस्ते';
      final translatedMessage = Message(
        i18n: const {
          language: translatedMessageText,
        },
      );

      tester.mockApi(
        (api) => api.message.translateMessage(messageId, language),
        result: createDefaultTranslateMessageResponse(message: translatedMessage),
      );

      final res = await tester.client.translateMessage(messageId, language);

      expect(res, isNotNull);
      expect(res.message.i18n, translatedMessage.i18n);

      tester
        ..verifyApi((api) => api.message.translateMessage(messageId, language))
        ..verifyNoMoreApiInteractions((api) => api.message);
    },
  );

  chatClientTest(
    '`.partialUpdateMessage`',
    body: (tester) async {
      const messageId = 'test-message-id';
      final message = Message(id: messageId);

      const set = {'text': 'Update Message text'};
      const unset = ['pinExpires'];

      final updateMessageResponse = createDefaultUpdateMessageResponse(
        message: message.copyWith(text: set['text'], pinExpires: null),
      );

      tester.mockApi(
        (api) => api.message.partialUpdateMessage(
          message.id,
          set: set,
          unset: unset,
        ),
        result: updateMessageResponse,
      );

      final res = await tester.client.partialUpdateMessage(
        messageId,
        set: set,
        unset: unset,
      );

      expect(res, isNotNull);
      expect(res.message.id, message.id);
      expect(res.message.id, message.id);
      expect(res.message.text, set['text']);
      expect(res.message.pinExpires, isNull);

      tester
        ..verifyApi(
          (api) => api.message.partialUpdateMessage(
            message.id,
            set: set,
            unset: unset,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.message);
    },
  );
}
