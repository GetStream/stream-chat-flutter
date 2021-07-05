import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/moderation_api.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

void main() {
  Response successResponse(String path, {Object? data}) => Response(
        data: data,
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
      );

  late final client = MockHttpClient();
  late ModerationApi moderationApi;

  setUp(() {
    moderationApi = ModerationApi(client);
  });

  test('muteUser', () async {
    const userId = 'test-user-id';

    const path = '/moderation/mute';

    when(
      () => client.post(
        path,
        data: {'target_id': userId},
      ),
    ).thenAnswer((_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await moderationApi.muteUser(userId);

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('unmuteUser', () async {
    const userId = 'test-user-id';

    const path = '/moderation/unmute';

    when(
      () => client.post(
        path,
        data: {'target_id': userId},
      ),
    ).thenAnswer((_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await moderationApi.unmuteUser(userId);

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('muteChannel', () async {
    const channelCid = 'test-channel-cid';
    const expiration = Duration(days: 3);

    const path = '/moderation/mute/channel';

    when(() => client.post(
              path,
              data: {
                'channel_cid': channelCid,
                'expiration': expiration.inMilliseconds,
              },
            ))
        .thenAnswer(
            (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await moderationApi.muteChannel(
      channelCid,
      expiration: expiration,
    );

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('unmuteChannel', () async {
    const channelCid = 'test-channel-cid';

    const path = '/moderation/unmute/channel';

    when(() => client.post(
              path,
              data: {'channel_cid': channelCid},
            ))
        .thenAnswer(
            (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await moderationApi.unmuteChannel(channelCid);

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('flagMessage', () async {
    const messageId = 'test-message-id';

    const path = '/moderation/flag';

    when(() => client.post(
              path,
              data: {
                'target_message_id': messageId,
              },
            ))
        .thenAnswer(
            (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await moderationApi.flagMessage(messageId);

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('unflagMessage', () async {
    const messageId = 'test-message-id';

    const path = '/moderation/unflag';

    when(() => client.post(
              path,
              data: {
                'target_message_id': messageId,
              },
            ))
        .thenAnswer(
            (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await moderationApi.unflagMessage(messageId);

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('flagUser', () async {
    const userId = 'test-message-id';

    const path = '/moderation/flag';

    when(() => client.post(path, data: {
              'target_user_id': userId,
            }))
        .thenAnswer(
            (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await moderationApi.flagUser(userId);

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('unflagUser', () async {
    const userId = 'test-message-id';

    const path = '/moderation/unflag';

    when(() => client.post(
              path,
              data: {
                'target_user_id': userId,
              },
            ))
        .thenAnswer(
            (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await moderationApi.unflagUser(userId);

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('banUser', () async {
    const targetUserId = 'test-target-user-id';
    const options = {'key': 'value'};

    const path = '/moderation/ban';

    when(() => client.post(path, data: {
              'target_user_id': targetUserId,
              ...options,
            }))
        .thenAnswer(
            (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await moderationApi.banUser(targetUserId, options: options);

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('unbanUser', () async {
    const targetUserId = 'test-target-user-id';
    const options = {'key': 'value'};

    const path = '/moderation/ban';

    when(
      () => client.delete(
        path,
        queryParameters: {
          'target_user_id': targetUserId,
          ...options,
        },
      ),
    ).thenAnswer((_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await moderationApi.unbanUser(targetUserId, options: options);

    expect(res, isNotNull);

    verify(
      () => client.delete(path, queryParameters: any(named: 'queryParameters')),
    ).called(1);
    verifyNoMoreInteractions(client);
  });
}
