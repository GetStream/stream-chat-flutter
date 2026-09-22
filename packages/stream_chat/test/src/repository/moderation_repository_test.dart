import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart';
import 'package:stream_chat/src/repository/moderation_repository.dart';
import 'package:stream_core/stream_core.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  late MockDefaultApi api;
  late ModerationRepository repository;

  setUp(() {
    api = MockDefaultApi();
    repository = ModerationRepository(api);

    registerFallbackValue(const MuteRequest(targetIds: []));
    registerFallbackValue(const UnmuteRequest(targetIds: []));
    registerFallbackValue(const MuteChannelRequest());
    registerFallbackValue(const UnmuteChannelRequest());
    registerFallbackValue(const BanRequest(targetUserId: ''));
    registerFallbackValue(const FlagRequest(entityId: '', entityType: ''));
  });

  test('muteUser sends the user id as a single-element target list', () async {
    const request = MuteRequest(targetIds: ['jane']);
    when(() => api.mute(muteRequest: request)).thenAnswer(
      (_) async => const Result.success(MuteResponse(duration: '0.01ms')),
    );

    final res = await repository.muteUser('jane');

    expect(res.isSuccess, isTrue);
    verify(() => api.mute(muteRequest: request)).called(1);
    verifyNoMoreInteractions(api);
  });

  test('muteUser converts its timeout to whole minutes', () async {
    const request = MuteRequest(targetIds: ['jane'], timeout: 90);
    when(() => api.mute(muteRequest: request)).thenAnswer(
      (_) async => const Result.success(MuteResponse(duration: '0.01ms')),
    );

    await repository.muteUser('jane', timeout: const Duration(minutes: 90));

    verify(() => api.mute(muteRequest: request)).called(1);
  });

  test('muteUser truncates a timeout to the minute below it', () async {
    const request = MuteRequest(targetIds: ['jane'], timeout: 1);
    when(() => api.mute(muteRequest: request)).thenAnswer(
      (_) async => const Result.success(MuteResponse(duration: '0.01ms')),
    );

    await repository.muteUser('jane', timeout: const Duration(seconds: 90));

    verify(() => api.mute(muteRequest: request)).called(1);
  });

  test('muteUser sends a sub-minute timeout as no expiry', () async {
    const request = MuteRequest(targetIds: ['jane'], timeout: 0);
    when(() => api.mute(muteRequest: request)).thenAnswer(
      (_) async => const Result.success(MuteResponse(duration: '0.01ms')),
    );

    await repository.muteUser('jane', timeout: const Duration(seconds: 30));

    verify(() => api.mute(muteRequest: request)).called(1);
  });

  test('muteUser omits the timeout when none is given', () async {
    when(() => api.mute(muteRequest: any(named: 'muteRequest'))).thenAnswer(
      (_) async => const Result.success(MuteResponse(duration: '0.01ms')),
    );

    await repository.muteUser('jane');

    final request = verify(() => api.mute(muteRequest: captureAny(named: 'muteRequest'))).captured.single;
    expect((request as MuteRequest).timeout, isNull);
  });

  test('muteUser returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    when(() => api.mute(muteRequest: any(named: 'muteRequest'))).thenAnswer(
      (_) async => const Result.failure(error),
    );

    final res = await repository.muteUser('jane');

    expect(res.isFailure, isTrue);
    expect(res.exceptionOrNull(), error);
  });

  test('unmuteUser sends the user id as a single-element target list', () async {
    const request = UnmuteRequest(targetIds: ['jane']);
    when(() => api.unmute(unmuteRequest: request)).thenAnswer(
      (_) async => const Result.success(UnmuteResponse(duration: '0.01ms')),
    );

    final res = await repository.unmuteUser('jane');

    expect(res.isSuccess, isTrue);
    verify(() => api.unmute(unmuteRequest: request)).called(1);
    verifyNoMoreInteractions(api);
  });

  test('muteChannel sends the cid as a single-element list', () async {
    const request = MuteChannelRequest(channelCids: ['messaging:general']);
    when(() => api.muteChannel(muteChannelRequest: request)).thenAnswer(
      (_) async => const Result.success(MuteChannelResponse(duration: '0.01ms')),
    );

    final res = await repository.muteChannel('messaging:general');

    expect(res.isSuccess, isTrue);
    verify(() => api.muteChannel(muteChannelRequest: request)).called(1);
    verifyNoMoreInteractions(api);
  });

  test('muteChannel converts its expiration to milliseconds', () async {
    const request = MuteChannelRequest(
      channelCids: ['messaging:general'],
      expiration: 60000,
    );
    when(() => api.muteChannel(muteChannelRequest: request)).thenAnswer(
      (_) async => const Result.success(MuteChannelResponse(duration: '0.01ms')),
    );

    await repository.muteChannel('messaging:general', expiration: const Duration(minutes: 1));

    verify(() => api.muteChannel(muteChannelRequest: request)).called(1);
  });

  test('unmuteChannel sends the cid as a single-element list', () async {
    const request = UnmuteChannelRequest(channelCids: ['messaging:general']);
    when(() => api.unmuteChannel(unmuteChannelRequest: request)).thenAnswer(
      (_) async => const Result.success(UnmuteResponse(duration: '0.01ms')),
    );

    final res = await repository.unmuteChannel('messaging:general');

    expect(res.isSuccess, isTrue);
    verify(() => api.unmuteChannel(unmuteChannelRequest: request)).called(1);
    verifyNoMoreInteractions(api);
  });

  test('banUser sends only the target when nothing else is given', () async {
    const request = BanRequest(targetUserId: 'jane');
    when(() => api.ban(banRequest: request)).thenAnswer(
      (_) async => const Result.success(ModerationBanResponse(duration: '0.01ms')),
    );

    final res = await repository.banUser('jane');

    expect(res.isSuccess, isTrue);
    verify(() => api.ban(banRequest: request)).called(1);
    verifyNoMoreInteractions(api);
  });

  test('banUser forwards every option to the generated request', () async {
    const request = BanRequest(
      targetUserId: 'jane',
      channelCid: 'messaging:general',
      timeout: 30,
      reason: 'spam',
      shadow: true,
      ipBan: true,
      deleteMessages: BanRequestDeleteMessages.hard,
    );
    when(() => api.ban(banRequest: request)).thenAnswer(
      (_) async => const Result.success(ModerationBanResponse(duration: '0.01ms')),
    );

    await repository.banUser(
      'jane',
      channelCid: 'messaging:general',
      timeout: const Duration(minutes: 30),
      reason: 'spam',
      shadow: true,
      ipBan: true,
      deleteMessages: BanRequestDeleteMessages.hard,
    );

    verify(() => api.ban(banRequest: request)).called(1);
  });

  test('banUser sends a sub-minute timeout as no expiry', () async {
    const request = BanRequest(targetUserId: 'jane', timeout: 0);
    when(() => api.ban(banRequest: request)).thenAnswer(
      (_) async => const Result.success(ModerationBanResponse(duration: '0.01ms')),
    );

    await repository.banUser('jane', timeout: const Duration(seconds: 30));

    verify(() => api.ban(banRequest: request)).called(1);
  });

  test('unbanUser sends the target as a query parameter', () async {
    when(() => api.unban(targetUserId: 'jane')).thenAnswer(
      (_) async => const Result.success(UnbanResponse(duration: '0.01ms')),
    );

    final res = await repository.unbanUser('jane');

    expect(res.isSuccess, isTrue);
    verify(() => api.unban(targetUserId: 'jane')).called(1);
    verifyNoMoreInteractions(api);
  });

  test('unbanUser scopes the unban to a channel when a cid is given', () async {
    when(() => api.unban(targetUserId: 'jane', channelCid: 'messaging:general')).thenAnswer(
      (_) async => const Result.success(UnbanResponse(duration: '0.01ms')),
    );

    await repository.unbanUser('jane', channelCid: 'messaging:general');

    verify(() => api.unban(targetUserId: 'jane', channelCid: 'messaging:general')).called(1);
  });

  test('flagMessage flags the message entity type', () async {
    const request = FlagRequest(
      entityType: 'stream:chat:v1:message',
      entityId: 'message-id',
    );
    when(() => api.flag(flagRequest: request)).thenAnswer(
      (_) async => const Result.success(FlagItemResponse(duration: '0.01ms', itemId: 'item-id')),
    );

    final res = await repository.flagMessage('message-id');

    expect(res.isSuccess, isTrue);
    verify(() => api.flag(flagRequest: request)).called(1);
    verifyNoMoreInteractions(api);
  });

  test('flagMessage forwards the reason and custom data', () async {
    const request = FlagRequest(
      entityType: 'stream:chat:v1:message',
      entityId: 'message-id',
      reason: 'spam',
      custom: {'source': 'long-press'},
    );
    when(() => api.flag(flagRequest: request)).thenAnswer(
      (_) async => const Result.success(FlagItemResponse(duration: '0.01ms', itemId: 'item-id')),
    );

    await repository.flagMessage(
      'message-id',
      reason: 'spam',
      custom: const {'source': 'long-press'},
    );

    verify(() => api.flag(flagRequest: request)).called(1);
  });

  test('flagUser flags the user entity type', () async {
    const request = FlagRequest(
      entityType: 'stream:user',
      entityId: 'jane',
    );
    when(() => api.flag(flagRequest: request)).thenAnswer(
      (_) async => const Result.success(FlagItemResponse(duration: '0.01ms', itemId: 'item-id')),
    );

    final res = await repository.flagUser('jane');

    expect(res.isSuccess, isTrue);
    verify(() => api.flag(flagRequest: request)).called(1);
    verifyNoMoreInteractions(api);
  });
}
