import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/channel_api.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

void main() {
  String _getChannelUrl(String channelId, String channelType) =>
      '/channels/$channelType/$channelId';

  ChannelState _generateChannelState(
    String channelId,
    String channelType,
  ) {
    final channel = ChannelModel(id: channelId, type: channelType);
    final messages = List.generate(
      3,
      (index) => Message(
        id: 'test-message-id-$index',
        text: 'test-message-text-$index',
      ),
    );
    final members = List.generate(
      3,
      (index) => Member(userId: 'test-user-id-$index'),
    );
    final reads = List.generate(
      3,
      (index) => Read(
        lastRead: DateTime.now(),
        user: User(id: 'test-user-id-$index'),
      ),
    );
    final watchers = List.generate(
      3,
      (index) => User(id: 'test-user-id-$index'),
    );
    final state = ChannelState(
      channel: channel,
      messages: messages,
      pinnedMessages: messages,
      members: members,
      read: reads,
      watchers: watchers,
      watcherCount: watchers.length,
    );
    return state;
  }

  Response successResponse(String path, {Object? data}) => Response(
        data: data,
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
      );

  late final client = MockHttpClient();
  late ChannelApi channelApi;

  setUp(() {
    channelApi = ChannelApi(client);
  });

  test('queryChannel', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    const channelData = <String, Object>{'name': 'test-channel'};
    const messagePagination = PaginationParams();
    const membersPagination = PaginationParams();
    const watchersPagination = PaginationParams();

    const channelPath = '/channels/$channelType/$channelId';
    const path = '$channelPath/query';

    final channelState = _generateChannelState(channelId, channelType);

    final data = {
      'state': true,
      'watch': false,
      'presence': false,
      'data': channelData,
      'messages': messagePagination,
      'members': membersPagination,
      'watchers': watchersPagination,
    };

    when(() => client.post(
          path,
          data: data,
        )).thenAnswer((_) async => successResponse(
          path,
          data: channelState.toJson(),
        ));

    final res = await channelApi.queryChannel(
      channelType,
      channelId: channelId,
      channelData: channelData,
      messagesPagination: messagePagination,
      membersPagination: membersPagination,
      watchersPagination: watchersPagination,
    );

    expect(res, isNotNull);
    expect(res.messages?.length, channelState.messages?.length);
    expect(res.pinnedMessages?.length, channelState.pinnedMessages?.length);
    expect(res.members?.length, channelState.members?.length);
    expect(res.read?.length, channelState.read?.length);
    expect(res.watchers?.length, channelState.watchers?.length);
    expect(res.watcherCount, channelState.watcherCount);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('queryChannels', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';

    final filter = Filter.in_('cid', const ['test-cid']);
    const sort = [SortOption<ChannelModel>('test-field')];
    const memberLimit = 33;
    const messageLimit = 33;

    const path = '/channels';

    final channelState = _generateChannelState(channelId, channelType);

    final payload = jsonEncode({
      // default options
      'state': true,
      'watch': true,
      'presence': false,

      // passed options
      'sort': sort,
      'filter_conditions': filter,
      'member_limit': memberLimit,
      'message_limit': messageLimit,

      // pagination
      ...const PaginationParams().toJson()
    });

    when(() => client.get(
          path,
          queryParameters: {
            'payload': payload,
          },
        )).thenAnswer((_) async => successResponse(
          path,
          data: {
            'channels': [channelState.toJson()]
          },
        ));

    final res = await channelApi.queryChannels(
      filter: filter,
      sort: sort,
      memberLimit: memberLimit,
      messageLimit: messageLimit,
    );

    expect(res, isNotNull);
    expect(res.channels, isNotEmpty);

    verify(
      () => client.get(path, queryParameters: any(named: 'queryParameters')),
    ).called(1);
    verifyNoMoreInteractions(client);
  });

  test('markAllRead', () async {
    const path = '/channels/read';
    when(() => client.post(path, data: {})).thenAnswer(
        (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await channelApi.markAllRead();

    expect(res, isNotNull);

    verify(() => client.post(path, data: {})).called(1);
    verifyNoMoreInteractions(client);
  });

  test('updateChannel', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    const data = {'name': 'test-channel-name'};
    final message = Message(id: 'test-message-id', text: 'channel-updated');

    final path = _getChannelUrl(channelId, channelType);

    final channelModel = ChannelModel(
      id: channelId,
      type: channelType,
      extraData: data,
    );

    when(() => client.post(
          path,
          data: any(
            named: 'data',
            that: wrapMatcher((Map v) =>
                containsPair('data', data).matches(v, {}) &&
                contains('message').matches(v, {})),
          ),
        )).thenAnswer((_) async => successResponse(path, data: {
          'channel': channelModel.toJson(),
          'message': message.toJson(),
        }));

    final res = await channelApi.updateChannel(
      channelId,
      channelType,
      data,
      message: message,
    );

    expect(res, isNotNull);
    expect(res.channel.cid, channelModel.cid);
    expect(res.message?.id, message.id);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('updateChannelPartial', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    const set = {
      'name': 'Stream Team',
      'profile_image': 'test-profile-image',
    };

    const unset = ['tag', 'last_name'];

    final path = _getChannelUrl(channelId, channelType);

    final channelModel = ChannelModel(
      id: channelId,
      type: channelType,
      extraData: set,
    );

    when(
      () => client.patch(path, data: {'set': set, 'unset': unset}),
    ).thenAnswer((_) async => successResponse(path, data: {
          'channel': channelModel.toJson(),
        }));

    final res = await channelApi.updateChannelPartial(
      channelId,
      channelType,
      set: set,
      unset: unset,
    );

    expect(res, isNotNull);

    verify(
      () => client.patch(path, data: {'set': set, 'unset': unset}),
    ).called(1);
    verifyNoMoreInteractions(client);
  });

  test('acceptChannelInvite', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    final message = Message(id: 'test-message-id', text: 'channel-accepted');

    final channelModel = ChannelModel(id: channelId, type: channelType);

    final path = _getChannelUrl(channelId, channelType);

    when(() => client.post(
          path,
          data: {
            'accept_invite': true,
            'message': message,
          },
        )).thenAnswer((_) async => successResponse(path, data: {
          'channel': channelModel.toJson(),
          'message': message.toJson(),
        }));

    final res = await channelApi.acceptChannelInvite(
      channelId,
      channelType,
      message: message,
    );

    expect(res, isNotNull);
    expect(res.channel.cid, channelModel.cid);
    expect(res.message?.id, message.id);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('rejectChannelInvite', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    final message = Message(id: 'test-message-id', text: 'channel-rejected');

    final channelModel = ChannelModel(id: channelId, type: channelType);

    final path = _getChannelUrl(channelId, channelType);

    when(() => client.post(
          path,
          data: {
            'reject_invite': true,
            'message': message,
          },
        )).thenAnswer((_) async => successResponse(path, data: {
          'channel': channelModel.toJson(),
          'message': message.toJson(),
        }));

    final res = await channelApi.rejectChannelInvite(
      channelId,
      channelType,
      message: message,
    );

    expect(res, isNotNull);
    expect(res.channel.cid, channelModel.cid);
    expect(res.message?.id, message.id);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('inviteChannelMembers', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    const memberIds = ['test-member-id-1', 'test-member-id-2'];
    final channelModel = ChannelModel(id: channelId, type: channelType);
    final message = Message(id: 'test-message-id', text: 'members-invited');

    final path = _getChannelUrl(channelId, channelType);

    when(() => client.post(
          path,
          data: {
            'invites': memberIds,
            'message': message,
          },
        )).thenAnswer((_) async => successResponse(path, data: {
          'channel': channelModel.toJson(),
          'message': message.toJson(),
        }));

    final res = await channelApi.inviteChannelMembers(
      channelId,
      channelType,
      memberIds,
      message: message,
    );

    expect(res, isNotNull);
    expect(res.channel.cid, channelModel.cid);
    expect(res.message?.id, message.id);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('addMembers', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    const memberIds = ['test-member-id-1', 'test-member-id-2'];
    final channelModel = ChannelModel(id: channelId, type: channelType);
    final message = Message(id: 'test-message-id', text: 'members-added');
    const hideHistory = true;

    final path = _getChannelUrl(channelId, channelType);

    when(() => client.post(
          path,
          data: {
            'add_members': memberIds,
            'message': message,
            'hide_history': hideHistory,
          },
        )).thenAnswer((_) async => successResponse(path, data: {
          'channel': channelModel.toJson(),
          'message': message.toJson(),
        }));

    final res = await channelApi.addMembers(
      channelId,
      channelType,
      memberIds,
      message: message,
      hideHistory: hideHistory,
    );

    expect(res, isNotNull);
    expect(res.channel.cid, channelModel.cid);
    expect(res.message?.id, message.id);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('removeMembers', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    const memberIds = ['test-member-id-1', 'test-member-id-2'];
    final channelModel = ChannelModel(id: channelId, type: channelType);
    final message = Message(id: 'test-message-id', text: 'members-removed');

    final path = _getChannelUrl(channelId, channelType);

    when(() => client.post(
          path,
          data: {
            'remove_members': memberIds,
            'message': message,
          },
        )).thenAnswer((_) async => successResponse(path, data: {
          'channel': channelModel.toJson(),
          'message': message.toJson(),
        }));

    final res = await channelApi.removeMembers(
      channelId,
      channelType,
      memberIds,
      message: message,
    );

    expect(res, isNotNull);
    expect(res.channel.cid, channelModel.cid);
    expect(res.message?.id, message.id);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('sendEvent', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    final event = Event(type: 'event.test');

    final path = '${_getChannelUrl(channelId, channelType)}/event';

    when(() => client.post(path, data: {'event': event})).thenAnswer(
        (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await channelApi.sendEvent(channelId, channelType, event);

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('deleteChannel', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';

    final path = _getChannelUrl(channelId, channelType);

    when(() => client.delete(path)).thenAnswer(
        (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await channelApi.deleteChannel(channelId, channelType);

    expect(res, isNotNull);

    verify(() => client.delete(path)).called(1);
    verifyNoMoreInteractions(client);
  });

  test('truncateChannel', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';

    final path = '${_getChannelUrl(channelId, channelType)}/truncate';

    when(() => client.post(
              path,
              data: {},
            ))
        .thenAnswer(
            (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await channelApi.truncateChannel(channelId, channelType);

    expect(res, isNotNull);

    verify(() => client.post(
          path,
          data: {},
        )).called(1);
    verifyNoMoreInteractions(client);
  });

  test('hideChannel', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';

    final path = '${_getChannelUrl(channelId, channelType)}/hide';

    when(
      () => client.post(
        path,
        data: {
          'clear_history': false,
        },
      ),
    ).thenAnswer((_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await channelApi.hideChannel(channelId, channelType);

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('hideChannel with clear_history: true', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';

    final path = '${_getChannelUrl(channelId, channelType)}/hide';

    when(
      () => client.post(
        path,
        data: {
          'clear_history': true,
        },
      ),
    ).thenAnswer((_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await channelApi.hideChannel(
      channelId,
      channelType,
      clearHistory: true,
    );

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('showChannel', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';

    final path = '${_getChannelUrl(channelId, channelType)}/show';

    when(() => client.post(
              path,
              data: {},
            ))
        .thenAnswer(
            (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await channelApi.showChannel(channelId, channelType);

    expect(res, isNotNull);

    verify(() => client.post(
          path,
          data: {},
        )).called(1);
    verifyNoMoreInteractions(client);
  });

  test('markRead', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    const messageId = 'test-message-id';

    final path = '${_getChannelUrl(channelId, channelType)}/read';

    when(() => client.post(
              path,
              data: {
                'message_id': messageId,
              },
            ))
        .thenAnswer(
            (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await channelApi.markRead(
      channelId,
      channelType,
      messageId: messageId,
    );

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('stopWatching', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';

    final path = '${_getChannelUrl(channelId, channelType)}/stop-watching';

    when(() => client.post(path, data: {})).thenAnswer(
        (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await channelApi.stopWatching(channelId, channelType);

    expect(res, isNotNull);

    verify(() => client.post(path, data: {})).called(1);
    verifyNoMoreInteractions(client);
  });

  test('enableSlowdown', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    const cooldown = 10;
    const set = {
      'cooldown': 10,
    };

    final path = _getChannelUrl(channelId, channelType);

    final channelModel = ChannelModel(
      id: channelId,
      type: channelType,
      extraData: set,
    );

    when(() => client.patch(path, data: {
          'set': set,
        })).thenAnswer((_) async => successResponse(path, data: {
          'channel': channelModel.toJson(),
        }));

    final res =
        await channelApi.enableSlowdown(channelId, channelType, cooldown);

    expect(res, isNotNull);

    verify(() => client.patch(path, data: {
          'set': set,
        })).called(1);
    verifyNoMoreInteractions(client);
  });

  test('disableSlowdown', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    const unset = ['cooldown'];

    final path = _getChannelUrl(channelId, channelType);

    final channelModel = ChannelModel(
      id: channelId,
      type: channelType,
    );

    when(() => client.patch(path, data: {
          'unset': unset,
        })).thenAnswer((_) async => successResponse(path, data: {
          'channel': channelModel.toJson(),
        }));

    final res = await channelApi.disableSlowdown(channelId, channelType);

    expect(res, isNotNull);

    verify(() => client.patch(path, data: {
          'unset': unset,
        })).called(1);
    verifyNoMoreInteractions(client);
  });
}
