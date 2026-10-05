import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';
import '../ws/fake_chat_server.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.UpdateMemberPartialRequest()));

  test('StreamChatClient.updateMemberPartial sends the set and unset fields and returns the updated member', () async {
    final defaultApi = _defaultApiAnswering(Result.success(_updateMemberPartialResponse()));
    final client = _client(defaultApi);

    final res = await client.updateMemberPartial(
      channelId: 'general',
      channelType: 'messaging',
      set: const {'nickname': 'Mo'},
      unset: const ['status'],
    );

    expect(res.getOrNull(), UpdateMemberPartialResponse(duration: '0.01ms', channelMember: fakeChannelMember()));
    verify(
      () => defaultApi.updateMemberPartial(
        type: 'messaging',
        id: 'general',
        updateMemberPartialRequest: const api.UpdateMemberPartialRequest(set: {'nickname': 'Mo'}, unset: ['status']),
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.updateMemberPartial returns a null member when the response has none', () async {
    const response = api.UpdateMemberPartialResponse(duration: '0.01ms');
    final client = _client(_defaultApiAnswering(const Result.success(response)));

    final res = await client.updateMemberPartial(channelId: 'general', channelType: 'messaging', set: const {'a': 1});

    expect(res, const Result.success(UpdateMemberPartialResponse(duration: '0.01ms')));
  });

  test('StreamChatClient.updateMemberPartial returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final client = _client(_defaultApiAnswering(const Result.failure(error)));

    final res = await client.updateMemberPartial(channelId: 'general', channelType: 'messaging', set: const {'a': 1});

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.updateMemberPartial drops custom data named like a member field', () async {
    final response = api.UpdateMemberPartialResponse(
      duration: '0.01ms',
      channelMember: fakeChannelMemberResponse(custom: const {'status': 'shadowed', 'user_id': 'shadowed'}),
    );
    final client = _client(_defaultApiAnswering(Result.success(response)));

    final res = await client.updateMemberPartial(channelId: 'general', channelType: 'messaging', set: const {'a': 1});

    final member = res.getOrNull()!.channelMember!;
    expect(member.status, 'member');
    expect(member.extraData, isNot(contains('user_id')));
  });

  test('StreamChatClient.updateMemberPartial falls back to the defaults for member fields left out', () async {
    final response = api.UpdateMemberPartialResponse(
      duration: '0.01ms',
      channelMember: api.ChannelMemberResponse(
        banned: false,
        channelRole: 'channel_member',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026, 2),
        custom: const {},
        notificationsMuted: false,
        shadowBanned: false,
      ),
    );
    final client = _client(_defaultApiAnswering(Result.success(response)));

    final res = await client.updateMemberPartial(channelId: 'general', channelType: 'messaging', set: const {'a': 1});

    final member = res.getOrNull()!.channelMember!;
    expect(member.invited, isFalse);
    expect(member.isModerator, isFalse);
    expect(member.deletedMessages, isEmpty);
  });

  test('StreamChatClient.pinChannel sends the pinned flag and returns the updated member', () async {
    final defaultApi = _defaultApiAnswering(Result.success(_updateMemberPartialResponse()));
    final client = _client(defaultApi);

    final res = await client.pinChannel(channelId: 'general', channelType: 'messaging');

    expect(res.getOrNull(), UpdateMemberPartialResponse(duration: '0.01ms', channelMember: fakeChannelMember()));
    verify(
      () => defaultApi.updateMemberPartial(
        type: 'messaging',
        id: 'general',
        updateMemberPartialRequest: const api.UpdateMemberPartialRequest(set: {'pinned': true}),
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.pinChannel returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final client = _client(_defaultApiAnswering(const Result.failure(error)));

    final res = await client.pinChannel(channelId: 'general', channelType: 'messaging');

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.unpinChannel sends the pinned flag unset and returns the updated member', () async {
    final defaultApi = _defaultApiAnswering(Result.success(_updateMemberPartialResponse()));
    final client = _client(defaultApi);

    final res = await client.unpinChannel(channelId: 'general', channelType: 'messaging');

    expect(res.getOrNull(), UpdateMemberPartialResponse(duration: '0.01ms', channelMember: fakeChannelMember()));
    verify(
      () => defaultApi.updateMemberPartial(
        type: 'messaging',
        id: 'general',
        updateMemberPartialRequest: const api.UpdateMemberPartialRequest(unset: ['pinned']),
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.unpinChannel returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final client = _client(_defaultApiAnswering(const Result.failure(error)));

    final res = await client.unpinChannel(channelId: 'general', channelType: 'messaging');

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.archiveChannel sends the archived flag and returns the updated member', () async {
    final defaultApi = _defaultApiAnswering(Result.success(_updateMemberPartialResponse()));
    final client = _client(defaultApi);

    final res = await client.archiveChannel(channelId: 'general', channelType: 'messaging');

    expect(res.getOrNull(), UpdateMemberPartialResponse(duration: '0.01ms', channelMember: fakeChannelMember()));
    verify(
      () => defaultApi.updateMemberPartial(
        type: 'messaging',
        id: 'general',
        updateMemberPartialRequest: const api.UpdateMemberPartialRequest(set: {'archived': true}),
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.archiveChannel returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final client = _client(_defaultApiAnswering(const Result.failure(error)));

    final res = await client.archiveChannel(channelId: 'general', channelType: 'messaging');

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.unarchiveChannel sends the archived flag unset and returns the updated member', () async {
    final defaultApi = _defaultApiAnswering(Result.success(_updateMemberPartialResponse()));
    final client = _client(defaultApi);

    final res = await client.unarchiveChannel(channelId: 'general', channelType: 'messaging');

    expect(res.getOrNull(), UpdateMemberPartialResponse(duration: '0.01ms', channelMember: fakeChannelMember()));
    verify(
      () => defaultApi.updateMemberPartial(
        type: 'messaging',
        id: 'general',
        updateMemberPartialRequest: const api.UpdateMemberPartialRequest(unset: ['archived']),
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.unarchiveChannel returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final client = _client(_defaultApiAnswering(const Result.failure(error)));

    final res = await client.unarchiveChannel(channelId: 'general', channelType: 'messaging');

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi, wsProvider: FakeChatServer().connect);
  addTearDown(client.dispose);
  return client;
}

MockDefaultApi _defaultApiAnswering(Result<api.UpdateMemberPartialResponse> result) {
  final defaultApi = MockDefaultApi();
  when(
    () => defaultApi.updateMemberPartial(
      type: any(named: 'type'),
      id: any(named: 'id'),
      updateMemberPartialRequest: any(named: 'updateMemberPartialRequest'),
    ),
  ).thenAnswer((_) async => result);
  return defaultApi;
}

// A response with every field set.
api.UpdateMemberPartialResponse _updateMemberPartialResponse() =>
    api.UpdateMemberPartialResponse(duration: '0.01ms', channelMember: fakeChannelMemberResponse());
