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
}
