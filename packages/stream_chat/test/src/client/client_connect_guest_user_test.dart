import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';
import '../utils.dart';
import '../ws/fake_chat_server.dart';

const _guestId = 'guest-1b2c3d4e-requested-id';

void main() {
  test('StreamChatClient.connectGuestUser sends only the fields a guest takes from the user', () async {
    final defaultApi = _defaultApiAnswering(Result.success(_createGuestResponse()));
    final client = _client(defaultApi);

    await client.connectGuestUser(_fullyPopulatedUser(), connectWebSocket: false);

    final request = verify(
      () => defaultApi.createGuest(createGuestRequest: captureAny(named: 'createGuestRequest')),
    ).captured.single;
    expect(
      request,
      const api.CreateGuestRequest(
        user: api.UserRequest(
          id: 'requested-id',
          name: 'Requested Name',
          image: 'https://example.com/requested.png',
          language: 'fr',
          invisible: true,
          privacySettings: api.PrivacySettingsResponse(
            typingIndicators: api.TypingIndicatorsResponse(enabled: false),
            readReceipts: api.ReadReceiptsResponse(enabled: true),
            deliveryReceipts: api.DeliveryReceiptsResponse(enabled: false),
          ),
          custom: {'favorite_color': 'blue'},
        ),
      ),
    );
  });

  test('StreamChatClient.connectGuestUser returns the created guest', () async {
    final client = _client(_defaultApiAnswering(Result.success(_createGuestResponse())));

    final guest = await client.connectGuestUser(_fullyPopulatedUser(), connectWebSocket: false);

    expect(guest, OwnUser.fromUser(_createdGuest()));
    // `User` equality leaves these two out.
    expect(guest.createdAt, DateTime.utc(2026, 9, 1));
    expect(guest.updatedAt, DateTime.utc(2026, 9, 2));
  });

  test(
    "StreamChatClient.connectGuestUser sends no custom data named like one of the user's own fields",
    () async {
      final defaultApi = _defaultApiAnswering(Result.success(_createGuestResponse()));
      final client = _client(defaultApi);
      final user = User.fromJson(const {
        'id': 'requested-id',
        'deleted_at': '2026-01-01T00:00:00Z',
        'devices': <Object?>[],
        'color': 'blue',
      });

      await client.connectGuestUser(user, connectWebSocket: false);

      final request =
          verify(
                () => defaultApi.createGuest(createGuestRequest: captureAny(named: 'createGuestRequest')),
              ).captured.single
              as api.CreateGuestRequest;
      expect(request.user.custom, {'color': 'blue'});
    },
  );

  test('StreamChatClient.connectGuestUser sends neither a name nor an image for a user without them', () async {
    final defaultApi = _defaultApiAnswering(Result.success(_createGuestResponse()));
    final client = _client(defaultApi);

    await client.connectGuestUser(User(id: 'requested-id'), connectWebSocket: false);

    final request = verify(
      () => defaultApi.createGuest(createGuestRequest: captureAny(named: 'createGuestRequest')),
    ).captured.single;
    expect(
      request,
      const api.CreateGuestRequest(
        user: api.UserRequest(id: 'requested-id', custom: {}),
      ),
    );
  });

  test(
    "StreamChatClient.connectGuestUser keeps custom fields named like the user's own fields out of the created guest",
    () async {
      final response = _createGuestResponse(
        custom: const {
          'favorite_color': 'green',
          'online': 'custom-online',
          'blocked_user_ids': 'custom-blocked-user-ids',
          'privacy_settings': 'custom-privacy-settings',
          'deleted_at': 'custom-deleted-at',
          'deactivated_at': 'custom-deactivated-at',
          'revoke_tokens_issued_before': 'custom-revoke-tokens-issued-before',
        },
      );
      final client = _client(_defaultApiAnswering(Result.success(response)));

      final guest = await client.connectGuestUser(_fullyPopulatedUser(), connectWebSocket: false);

      expect(guest.extraData, {
        'favorite_color': 'green',
        'name': 'Created Name',
        'image': 'https://example.com/created.png',
      });
    },
  );

  test('StreamChatClient.connectGuestUser connects the socket as the created guest', () async {
    final defaultApi = _defaultApiAnswering(Result.success(_createGuestResponse()));
    final client = _client(
      defaultApi,
      server: FakeChatServer(user: OwnUser(id: _guestId)),
    );

    await client.connectGuestUser(_fullyPopulatedUser());

    expect(client.connectionStatus, ConnectionStatus.connected);
    expect(client.state.currentUser?.id, _guestId);
  });

  test('StreamChatClient.connectGuestUser throws the failure when the guest cannot be created', () async {
    final defaultApi = _defaultApiAnswering(Result.failure(apiException(statusCode: 403)));
    final client = _client(defaultApi);

    await expectLater(
      client.connectGuestUser(_fullyPopulatedUser()),
      throwsA(isA<StreamApiException>().having((it) => it.statusCode, 'statusCode', 403)),
    );
  });

  test(
    'StreamChatClient.connectGuestUser throws a StreamClientException when the guest cannot be created for a reason '
    'other than a StreamException',
    () async {
      final client = _client(_defaultApiAnswering(const Result.failure(FormatException('Unexpected response'))));

      await expectLater(
        client.connectGuestUser(_fullyPopulatedUser()),
        throwsA(isA<StreamClientException>().having((it) => it.cause, 'cause', isA<FormatException>())),
      );
    },
  );

  test('StreamChatClient.connectGuestUser throws when the connection fails', () async {
    final client = _client(
      _defaultApiAnswering(Result.success(_createGuestResponse())),
      server: FakeChatServer()..handshakeFails = true,
    );

    await expectLater(
      client.connectGuestUser(_fullyPopulatedUser()),
      throwsA(isA<StreamNetworkException>()),
    );
  });

  test('StreamChatClient.connectGuestUser leaves the connection closed when connectWebSocket is false', () async {
    final client = _client(_defaultApiAnswering(Result.success(_createGuestResponse())));

    await client.connectGuestUser(_fullyPopulatedUser(), connectWebSocket: false);

    expect(client.connectionStatus, ConnectionStatus.disconnected);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi, {FakeChatServer? server}) {
  final client = StreamChatClient(
    'test-api-key',
    defaultApi: defaultApi,
    wsProvider: (server ?? FakeChatServer()).connect,
  );
  addTearDown(client.dispose);
  return client;
}

MockDefaultApi _defaultApiAnswering(Result<api.CreateGuestResponse> result) {
  registerFallbackValue(const api.CreateGuestRequest(user: api.UserRequest(id: 'fallback')));

  final defaultApi = MockDefaultApi();
  when(
    () => defaultApi.createGuest(createGuestRequest: any(named: 'createGuestRequest')),
  ).thenAnswer((_) async => result);
  // Connecting loads the app settings in the background.
  when(defaultApi.getApp).thenAnswer((_) async => Result.success(fakeGetApplicationResponse()));
  return defaultApi;
}

// Carries a value in every field, so the request shows which of them a guest takes.
OwnUser _fullyPopulatedUser() => OwnUser(
  id: 'requested-id',
  role: 'admin',
  name: 'Requested Name',
  image: 'https://example.com/requested.png',
  createdAt: DateTime.utc(2020, 1, 1),
  updatedAt: DateTime.utc(2020, 1, 2),
  lastActive: DateTime.utc(2020, 1, 3),
  online: true,
  banned: true,
  banExpires: DateTime.utc(2030),
  teams: const ['team-x'],
  language: 'fr',
  invisible: true,
  teamsRole: const {'team-x': 'admin'},
  avgResponseTime: 7,
  extraData: const {'favorite_color': 'blue'},
  devices: const [Device(id: 'device-1', pushProvider: PushProvider.firebase)],
  mutes: [
    Mute(
      user: User(id: 'requested-id'),
      target: User(id: 'muted-user'),
      createdAt: DateTime.utc(2020),
      updatedAt: DateTime.utc(2020),
    ),
  ],
  channelMutes: [
    ChannelMute(
      user: User(id: 'requested-id'),
      channel: ChannelModel(cid: 'messaging:muted'),
      createdAt: DateTime.utc(2020),
      updatedAt: DateTime.utc(2020),
    ),
  ],
  totalUnreadCount: 5,
  unreadChannels: 2,
  unreadThreads: 1,
  blockedUserIds: const ['blocked-user'],
  pushPreferences: const PushPreference(chatLevel: ChatLevel.allMentions),
  privacySettings: const PrivacySettings(
    typingIndicators: TypingIndicators(enabled: false),
    readReceipts: ReadReceipts(),
    deliveryReceipts: DeliveryReceipts(enabled: false),
  ),
);

// Every field the server answers with, including the ones a [User] does not carry.
api.CreateGuestResponse _createGuestResponse({
  Map<String, Object?> custom = const {'favorite_color': 'green'},
}) => api.CreateGuestResponse(
  duration: '3.20ms',
  accessToken: testUserToken(_guestId).rawValue,
  user: api.UserResponse(
    id: _guestId,
    role: 'guest',
    name: 'Created Name',
    image: 'https://example.com/created.png',
    language: 'de',
    online: true,
    banned: true,
    teams: const ['team-a'],
    teamsRole: const {'team-a': 'member'},
    avgResponseTime: 42,
    custom: custom,
    blockedUserIds: const ['blocked-user'],
    createdAt: DateTime.utc(2026, 9, 1),
    updatedAt: DateTime.utc(2026, 9, 2),
    lastActive: DateTime.utc(2026, 9, 3),
    deactivatedAt: DateTime.utc(2026, 9, 4),
    deletedAt: DateTime.utc(2026, 9, 5),
    revokeTokensIssuedBefore: DateTime.utc(2026, 9, 6),
  ),
);

// The user [_createGuestResponse] carries.
User _createdGuest() => User(
  id: _guestId,
  role: 'guest',
  name: 'Created Name',
  image: 'https://example.com/created.png',
  language: 'de',
  online: true,
  banned: true,
  teams: const ['team-a'],
  teamsRole: const {'team-a': 'member'},
  avgResponseTime: 42,
  extraData: const {'favorite_color': 'green'},
  createdAt: DateTime.utc(2026, 9, 1),
  updatedAt: DateTime.utc(2026, 9, 2),
  lastActive: DateTime.utc(2026, 9, 3),
);
