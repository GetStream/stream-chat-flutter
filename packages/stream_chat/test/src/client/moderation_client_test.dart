import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  late MockDefaultApi defaultApi;
  late StreamChatClient client;

  setUpAll(() {
    registerFallbackValue(const api.MuteRequest(targetIds: []));
    registerFallbackValue(const api.UnmuteRequest(targetIds: []));
    registerFallbackValue(const api.MuteChannelRequest());
    registerFallbackValue(const api.UnmuteChannelRequest());
    registerFallbackValue(const api.BanRequest(targetUserId: ''));
    registerFallbackValue(const api.FlagRequest(entityId: '', entityType: ''));
  });

  setUp(() {
    defaultApi = MockDefaultApi();
    client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  });

  test('StreamChatClient.moderation.muteUser sends the user id and returns the mute', () async {
    const request = api.MuteRequest(targetIds: ['test-user-id']);

    when(() => defaultApi.mute(muteRequest: request)).thenAnswer(
      (_) async => const Result.success(
        api.MuteResponse(duration: '0.01ms', nonExistingUsers: ['ghost']),
      ),
    );

    final res = await client.moderation.muteUser('test-user-id');

    expect(res.getOrNull(), const MuteResponse(duration: '0.01ms', nonExistingUsers: ['ghost']));
    verify(() => defaultApi.mute(muteRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.moderation.muteUser sends the timeout in whole minutes', () async {
    const request = api.MuteRequest(targetIds: ['test-user-id'], timeout: 90);

    when(() => defaultApi.mute(muteRequest: request)).thenAnswer(
      (_) async => const Result.success(api.MuteResponse(duration: '0.01ms')),
    );

    await client.moderation.muteUser('test-user-id', timeout: const Duration(minutes: 90));

    verify(() => defaultApi.mute(muteRequest: request)).called(1);
  });

  test('StreamChatClient.moderation.muteUser raises a sub-minute timeout to one minute', () async {
    const request = api.MuteRequest(targetIds: ['test-user-id'], timeout: 1);

    when(() => defaultApi.mute(muteRequest: request)).thenAnswer(
      (_) async => const Result.success(api.MuteResponse(duration: '0.01ms')),
    );

    await client.moderation.muteUser('test-user-id', timeout: const Duration(seconds: 30));

    verify(() => defaultApi.mute(muteRequest: request)).called(1);
  });

  test('StreamChatClient.moderation.muteUser raises a zero timeout to one minute', () async {
    const request = api.MuteRequest(targetIds: ['test-user-id'], timeout: 1);

    when(() => defaultApi.mute(muteRequest: request)).thenAnswer(
      (_) async => const Result.success(api.MuteResponse(duration: '0.01ms')),
    );

    await client.moderation.muteUser('test-user-id', timeout: Duration.zero);

    verify(() => defaultApi.mute(muteRequest: request)).called(1);
  });

  test('StreamChatClient.moderation.muteUser omits the timeout when none is given', () async {
    when(() => defaultApi.mute(muteRequest: any(named: 'muteRequest'))).thenAnswer(
      (_) async => const Result.success(api.MuteResponse(duration: '0.01ms')),
    );

    await client.moderation.muteUser('test-user-id');

    final sent = verify(() => defaultApi.mute(muteRequest: captureAny(named: 'muteRequest'))).captured.single;
    expect((sent as api.MuteRequest).timeout, isNull);
  });

  test('StreamChatClient.moderation.muteUser returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');

    when(() => defaultApi.mute(muteRequest: any(named: 'muteRequest'))).thenAnswer(
      (_) async => const Result.failure(error),
    );

    final res = await client.moderation.muteUser('test-user-id');

    expect(res.isFailure, isTrue);
    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.moderation.muteUsers sends every id in one request', () async {
    const request = api.MuteRequest(targetIds: ['jane', 'john'], timeout: 30);

    when(() => defaultApi.mute(muteRequest: request)).thenAnswer(
      (_) async => const Result.success(
        api.MuteResponse(duration: '0.01ms', nonExistingUsers: ['john']),
      ),
    );

    final res = await client.moderation.muteUsers(
      ['jane', 'john'],
      timeout: const Duration(minutes: 30),
    );

    expect(res.getOrNull()?.nonExistingUsers, ['john']);
    verify(() => defaultApi.mute(muteRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.moderation.muteUsers returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');

    when(() => defaultApi.mute(muteRequest: any(named: 'muteRequest'))).thenAnswer(
      (_) async => const Result.failure(error),
    );

    final res = await client.moderation.muteUsers(['jane', 'john']);

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.moderation.unmuteUser sends the user id and returns the unmute', () async {
    const request = api.UnmuteRequest(targetIds: ['test-user-id']);

    when(() => defaultApi.unmute(unmuteRequest: request)).thenAnswer(
      (_) async => const Result.success(
        api.UnmuteResponse(duration: '0.01ms', nonExistingUsers: ['ghost']),
      ),
    );

    final res = await client.moderation.unmuteUser('test-user-id');

    expect(res.getOrNull(), const UnmuteResponse(duration: '0.01ms', nonExistingUsers: ['ghost']));
    verify(() => defaultApi.unmute(unmuteRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.moderation.unmuteUser returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');

    when(() => defaultApi.unmute(unmuteRequest: any(named: 'unmuteRequest'))).thenAnswer(
      (_) async => const Result.failure(error),
    );

    final res = await client.moderation.unmuteUser('test-user-id');

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.moderation.unmuteUsers sends every id in one request', () async {
    const request = api.UnmuteRequest(targetIds: ['jane', 'john']);

    when(() => defaultApi.unmute(unmuteRequest: request)).thenAnswer(
      (_) async => const Result.success(api.UnmuteResponse(duration: '0.01ms')),
    );

    final res = await client.moderation.unmuteUsers(['jane', 'john']);

    expect(res.isSuccess, isTrue);
    verify(() => defaultApi.unmute(unmuteRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.moderation.unmuteUsers returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');

    when(() => defaultApi.unmute(unmuteRequest: any(named: 'unmuteRequest'))).thenAnswer(
      (_) async => const Result.failure(error),
    );

    final res = await client.moderation.unmuteUsers(['jane', 'john']);

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.moderation.muteChannel sends the cid and returns a success', () async {
    const request = api.MuteChannelRequest(channelCids: ['messaging:general']);

    when(() => defaultApi.muteChannel(muteChannelRequest: request)).thenAnswer(
      (_) async => const Result.success(api.MuteChannelResponse(duration: '0.01ms')),
    );

    final res = await client.moderation.muteChannel('messaging:general');

    expect(res.isSuccess, isTrue);
    verify(() => defaultApi.muteChannel(muteChannelRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.moderation.muteChannel sends the expiration in milliseconds', () async {
    const request = api.MuteChannelRequest(channelCids: ['messaging:general'], expiration: 60000);

    when(() => defaultApi.muteChannel(muteChannelRequest: request)).thenAnswer(
      (_) async => const Result.success(api.MuteChannelResponse(duration: '0.01ms')),
    );

    await client.moderation.muteChannel('messaging:general', expiration: const Duration(minutes: 1));

    verify(() => defaultApi.muteChannel(muteChannelRequest: request)).called(1);
  });

  test('StreamChatClient.moderation.muteChannel returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');

    when(() => defaultApi.muteChannel(muteChannelRequest: any(named: 'muteChannelRequest'))).thenAnswer(
      (_) async => const Result.failure(error),
    );

    final res = await client.moderation.muteChannel('messaging:general');

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.moderation.unmuteChannel sends the cid and returns a success', () async {
    const request = api.UnmuteChannelRequest(channelCids: ['messaging:general']);

    when(() => defaultApi.unmuteChannel(unmuteChannelRequest: request)).thenAnswer(
      (_) async => const Result.success(api.UnmuteResponse(duration: '0.01ms')),
    );

    final res = await client.moderation.unmuteChannel('messaging:general');

    expect(res.isSuccess, isTrue);
    verify(() => defaultApi.unmuteChannel(unmuteChannelRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.moderation.unmuteChannel returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');

    when(() => defaultApi.unmuteChannel(unmuteChannelRequest: any(named: 'unmuteChannelRequest'))).thenAnswer(
      (_) async => const Result.failure(error),
    );

    final res = await client.moderation.unmuteChannel('messaging:general');

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.moderation.banUser sends only the target when nothing else is given', () async {
    const request = api.BanRequest(targetUserId: 'test-user-id');

    when(() => defaultApi.ban(banRequest: request)).thenAnswer(
      (_) async => const Result.success(api.ModerationBanResponse(duration: '0.01ms')),
    );

    final res = await client.moderation.banUser('test-user-id');

    expect(res.isSuccess, isTrue);
    verify(() => defaultApi.ban(banRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.moderation.banUser sends every option to the generated request', () async {
    const request = api.BanRequest(
      targetUserId: 'test-user-id',
      channelCid: 'messaging:general',
      timeout: 30,
      reason: 'spam',
      shadow: true,
      ipBan: true,
      deleteMessages: api.BanRequestDeleteMessages.hard,
    );

    when(() => defaultApi.ban(banRequest: request)).thenAnswer(
      (_) async => const Result.success(api.ModerationBanResponse(duration: '0.01ms')),
    );

    await client.moderation.banUser(
      'test-user-id',
      channelCid: 'messaging:general',
      timeout: const Duration(minutes: 30),
      reason: 'spam',
      shadow: true,
      ipBan: true,
      deleteMessages: DeleteType.hard,
    );

    verify(() => defaultApi.ban(banRequest: request)).called(1);
  });

  test('StreamChatClient.moderation.banUser sends a delete type it does not name', () async {
    when(() => defaultApi.ban(banRequest: any(named: 'banRequest'))).thenAnswer(
      (_) async => const Result.success(api.ModerationBanResponse(duration: '0.01ms')),
    );

    await client.moderation.banUser('test-user-id', deleteMessages: const DeleteType('quarantine'));

    final sent = verify(() => defaultApi.ban(banRequest: captureAny(named: 'banRequest'))).captured.single;
    expect((sent as api.BanRequest).deleteMessages, 'quarantine');
  });

  test('StreamChatClient.moderation.banUser raises a sub-minute timeout to one minute', () async {
    const request = api.BanRequest(targetUserId: 'test-user-id', timeout: 1);

    when(() => defaultApi.ban(banRequest: request)).thenAnswer(
      (_) async => const Result.success(api.ModerationBanResponse(duration: '0.01ms')),
    );

    await client.moderation.banUser('test-user-id', timeout: const Duration(seconds: 30));

    verify(() => defaultApi.ban(banRequest: request)).called(1);
  });

  test('StreamChatClient.moderation.banUser returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');

    when(() => defaultApi.ban(banRequest: any(named: 'banRequest'))).thenAnswer(
      (_) async => const Result.failure(error),
    );

    final res = await client.moderation.banUser('test-user-id');

    expect(res.isFailure, isTrue);
    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.moderation.shadowBan sets the shadow flag on the ban', () async {
    const request = api.BanRequest(targetUserId: 'test-user-id', shadow: true);

    when(() => defaultApi.ban(banRequest: request)).thenAnswer(
      (_) async => const Result.success(api.ModerationBanResponse(duration: '0.01ms')),
    );

    final res = await client.moderation.shadowBan('test-user-id');

    expect(res.isSuccess, isTrue);
    verify(() => defaultApi.ban(banRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.moderation.shadowBan returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');

    when(() => defaultApi.ban(banRequest: any(named: 'banRequest'))).thenAnswer(
      (_) async => const Result.failure(error),
    );

    final res = await client.moderation.shadowBan('test-user-id');

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.moderation.unbanUser sends the target as a query parameter', () async {
    when(() => defaultApi.unban(targetUserId: 'test-user-id')).thenAnswer(
      (_) async => const Result.success(api.UnbanResponse(duration: '0.01ms')),
    );

    final res = await client.moderation.unbanUser('test-user-id');

    expect(res.isSuccess, isTrue);
    verify(() => defaultApi.unban(targetUserId: 'test-user-id')).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.moderation.unbanUser scopes the unban to a channel when a cid is given', () async {
    when(
      () => defaultApi.unban(targetUserId: 'test-user-id', channelCid: 'messaging:general'),
    ).thenAnswer((_) async => const Result.success(api.UnbanResponse(duration: '0.01ms')));

    await client.moderation.unbanUser('test-user-id', channelCid: 'messaging:general');

    verify(
      () => defaultApi.unban(targetUserId: 'test-user-id', channelCid: 'messaging:general'),
    ).called(1);
  });

  test('StreamChatClient.moderation.unbanUser returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');

    when(() => defaultApi.unban(targetUserId: any(named: 'targetUserId'))).thenAnswer(
      (_) async => const Result.failure(error),
    );

    final res = await client.moderation.unbanUser('test-user-id');

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.moderation.flagMessage flags the message entity and returns the item', () async {
    const request = api.FlagRequest(
      entityType: 'stream:chat:v1:message',
      entityId: 'test-message-id',
    );

    when(() => defaultApi.flag(flagRequest: request)).thenAnswer(
      (_) async => const Result.success(
        api.FlagItemResponse(duration: '0.01ms', itemId: 'review-item-7'),
      ),
    );

    final res = await client.moderation.flagMessage('test-message-id');

    expect(res.getOrNull(), const FlagResponse(duration: '0.01ms', itemId: 'review-item-7'));
    verify(() => defaultApi.flag(flagRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.moderation.flagMessage sends the reason and custom data', () async {
    const request = api.FlagRequest(
      entityType: 'stream:chat:v1:message',
      entityId: 'test-message-id',
      reason: 'spam',
      custom: {'source': 'long-press'},
    );

    when(() => defaultApi.flag(flagRequest: request)).thenAnswer(
      (_) async => const Result.success(
        api.FlagItemResponse(duration: '0.01ms', itemId: 'review-item-7'),
      ),
    );

    await client.moderation.flagMessage(
      'test-message-id',
      reason: 'spam',
      custom: const {'source': 'long-press'},
    );

    verify(() => defaultApi.flag(flagRequest: request)).called(1);
  });

  test('StreamChatClient.moderation.flagMessage returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');

    when(() => defaultApi.flag(flagRequest: any(named: 'flagRequest'))).thenAnswer(
      (_) async => const Result.failure(error),
    );

    final res = await client.moderation.flagMessage('test-message-id');

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.moderation.flagUser flags the user entity and returns the item', () async {
    const request = api.FlagRequest(entityType: 'stream:user', entityId: 'test-user-id');

    when(() => defaultApi.flag(flagRequest: request)).thenAnswer(
      (_) async => const Result.success(
        api.FlagItemResponse(duration: '0.01ms', itemId: 'review-item-9'),
      ),
    );

    final res = await client.moderation.flagUser('test-user-id');

    expect(res.getOrNull(), const FlagResponse(duration: '0.01ms', itemId: 'review-item-9'));
    verify(() => defaultApi.flag(flagRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.moderation.flagUser sends the reason and custom data', () async {
    const request = api.FlagRequest(
      entityType: 'stream:user',
      entityId: 'test-user-id',
      reason: 'harassment',
      custom: {'source': 'profile'},
    );

    when(() => defaultApi.flag(flagRequest: request)).thenAnswer(
      (_) async => const Result.success(
        api.FlagItemResponse(duration: '0.01ms', itemId: 'review-item-9'),
      ),
    );

    await client.moderation.flagUser(
      'test-user-id',
      reason: 'harassment',
      custom: const {'source': 'profile'},
    );

    verify(() => defaultApi.flag(flagRequest: request)).called(1);
  });

  test('StreamChatClient.moderation.flagUser returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');

    when(() => defaultApi.flag(flagRequest: any(named: 'flagRequest'))).thenAnswer(
      (_) async => const Result.failure(error),
    );

    final res = await client.moderation.flagUser('test-user-id');

    expect(res.exceptionOrNull(), error);
  });
}
