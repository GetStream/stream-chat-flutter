import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/core/api/channel_api.dart';
import 'package:stream_chat/src/core/api/general_api.dart';
import 'package:stream_chat/src/core/api/message_api.dart';
import 'package:stream_chat/src/core/api/moderation_api.dart';
import 'package:stream_chat/src/core/api/push_preferences_api.dart';
import 'package:stream_chat/src/core/api/user_api.dart';
import 'package:stream_chat/stream_chat.dart';

import 'mocks.dart';
import 'utils.dart';

class FakeTokenManager extends Fake implements TokenManager {
  final token = testUserToken('test-user-id');

  @override
  bool get usesStaticProvider => true;

  @override
  String? get userId => token.userId;

  @override
  UserToken? peekToken() => token;

  @override
  Future<UserToken> getToken() async => token;

  @override
  void setTokenProvider(String userId, {required TokenProvider tokenProvider}) {}

  @override
  void expireToken() {}

  @override
  void reset() {}
}

class FakeMultiPartFile extends Fake implements MultipartFile {}

/// Fake persistence client for testing persistence client reliability features
class FakePersistenceClient extends Fake implements ChatPersistenceClient {
  FakePersistenceClient({
    this._lastSyncAt,
    List<String>? channelCids,
  }) : _channelCids = channelCids ?? [];

  String? _userId;
  bool _isConnected = false;
  DateTime? _lastSyncAt;
  List<String> _channelCids;

  // Track method calls for testing
  int connectCallCount = 0;
  int disconnectCallCount = 0;
  int flushCallCount = 0;

  /// The health check last persisted, and `null` until one is.
  Event? connectionInfo;

  @override
  bool get isConnected => _isConnected;

  @override
  String? get userId => _userId;

  @override
  Future<void> connect(String userId) async {
    _userId = userId;
    _isConnected = true;
    connectCallCount++;
  }

  @override
  Future<void> disconnect({bool flush = false}) async {
    if (flush) await this.flush();

    _userId = null;
    _isConnected = false;
    disconnectCallCount++;
  }

  @override
  Future<void> flush() async {
    flushCallCount++;
    _lastSyncAt = null;
    _channelCids = [];
  }

  @override
  Future<DateTime?> getLastSyncAt() async => _lastSyncAt;

  @override
  Future<void> updateLastSyncAt(DateTime lastSyncAt) async {
    _lastSyncAt = lastSyncAt;
  }

  @override
  Future<List<String>> getChannelCids() async => _channelCids;

  @override
  Future<void> saveChannelQueries({
    required List<String> cids,
    ChannelFilter? filter,
    List<ChannelSort>? sort,
    String? predefinedFilter,
    ChannelFilter? resolvedFilter,
    List<ChannelSort>? resolvedSort,
    Map<String, Object?>? filterValues,
    Map<String, Object?>? sortValues,
    bool clearQueryCache = false,
  }) async {}

  @override
  Future<void> updateChannelStates(List<ChannelState> channelStates) async {}

  @override
  Future<void> updateConnectionInfo(Event event) async {
    connectionInfo = event;
  }
}

class FakeChatApi extends Fake implements StreamChatApi {
  UserApi? _user;

  @override
  UserApi get user => _user ??= MockUserApi();

  MessageApi? _message;

  @override
  MessageApi get message => _message ??= MockMessageApi();

  ChannelApi? _channel;

  @override
  ChannelApi get channel => _channel ??= MockChannelApi();

  PushPreferencesApi? _pushPreferences;

  @override
  PushPreferencesApi get pushPreferences => _pushPreferences ??= MockPushPreferencesApi();

  ModerationApi? _moderation;

  @override
  ModerationApi get moderation => _moderation ??= MockModerationApi();

  GeneralApi? _general;

  @override
  GeneralApi get general => _general ??= MockGeneralApi();
}

/// Answers the `getApp` call `connectUser` makes on the generated client.
class FakeDefaultApi extends Fake implements api.DefaultApi {
  @override
  Future<Result<api.GetApplicationResponse>> getApp() async => Result.success(fakeGetApplicationResponse());
}

/// A generated application response, for tests that need `getApp` to answer.
api.GetApplicationResponse fakeGetApplicationResponse({String name = 'test-app'}) {
  const unrestricted = api.FileUploadConfig(
    allowedFileExtensions: [],
    allowedMimeTypes: [],
    blockedFileExtensions: [],
    blockedMimeTypes: [],
    sizeLimit: 0,
  );

  return api.GetApplicationResponse(
    duration: '0.01ms',
    app: api.AppResponseFields(
      id: 42,
      name: name,
      placement: 'us-east',
      asyncUrlEnrichEnabled: false,
      autoTranslationEnabled: false,
      fileUploadConfig: unrestricted,
      imageUploadConfig: unrestricted,
    ),
  );
}

class FakeClientState extends Fake implements ClientState {
  FakeClientState({
    this._currentUser,
  });

  OwnUser? _currentUser;

  @override
  OwnUser? get currentUser {
    return _currentUser ??= OwnUser(
      id: 'test-user-id',
      name: 'Test User',
      privacySettings: const PrivacySettings(
        typingIndicators: TypingIndicators(),
        readReceipts: ReadReceipts(),
      ),
    );
  }

  @override
  Map<String, User> get users => const {};

  @override
  void updateUser(User? user) {
    if (user == null) return;
    if (_currentUser case final current? when user.id != current.id) return;

    _currentUser = OwnUser.fromUser(user);
  }

  @override
  int totalUnreadCount = 0;

  @override
  Map<String, Channel> get channels => _channels;
  final _channels = <String, Channel>{};

  @override
  void addChannels(Map<String, Channel> channelMap) {
    _channels.addAll(channelMap);
  }

  @override
  void removeChannel(String channelCid) {
    _channels.remove(channelCid);
  }
}

class FakeMessage extends Fake implements Message {}

class FakeDraftMessage extends Fake implements DraftMessage {}

class FakeAttachmentFile extends Fake implements AttachmentFile {}

class FakeEvent extends Fake implements Event {}

class FakeUser extends Fake implements User {}

class FakePollVote extends Fake implements PollVote {}

class FakeChannelState extends Fake implements ChannelState {}

/// A generated channel member with every field set.
api.ChannelMemberResponse fakeChannelMemberResponse({Map<String, Object?> custom = const {'nickname': 'Mo'}}) =>
    api.ChannelMemberResponse(
      archivedAt: DateTime.utc(2026, 1, 5),
      banExpires: DateTime.utc(2026, 6),
      banFromFutureChannels: true,
      banned: true,
      channelRole: 'channel_moderator',
      createdAt: DateTime.utc(2026),
      custom: custom,
      deletedAt: DateTime.utc(2026, 8),
      deletedMessages: const ['message-1'],
      futureChannelBanExpires: DateTime.utc(2026, 7),
      inviteAcceptedAt: DateTime.utc(2026, 1, 2),
      inviteRejectedAt: DateTime.utc(2026, 1, 3),
      invited: true,
      isModerator: true,
      notificationsMuted: true,
      pinnedAt: DateTime.utc(2026, 1, 4),
      role: 'user',
      shadowBanned: true,
      status: 'member',
      updatedAt: DateTime.utc(2026, 2),
      user: fakeUserResponse('member'),
      userId: 'member',
    );

/// A generated [api.UserResponse] with the id [id] and only the fields it requires.
api.UserResponse fakeUserResponse(String id) => api.UserResponse(
  banned: false,
  blockedUserIds: const [],
  createdAt: DateTime.utc(2025),
  custom: const {},
  id: id,
  language: 'en',
  online: false,
  role: 'user',
  teams: const [],
  updatedAt: DateTime.utc(2025),
);

/// The [Member] that [fakeChannelMemberResponse] maps to, with its default custom data.
Member fakeChannelMember() => Member(
  user: fakeUser('member'),
  userId: 'member',
  inviteAcceptedAt: DateTime.utc(2026, 1, 2),
  inviteRejectedAt: DateTime.utc(2026, 1, 3),
  invited: true,
  channelRole: 'channel_moderator',
  isModerator: true,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026, 2),
  banned: true,
  banExpires: DateTime.utc(2026, 6),
  shadowBanned: true,
  pinnedAt: DateTime.utc(2026, 1, 4),
  archivedAt: DateTime.utc(2026, 1, 5),
  deletedMessages: const ['message-1'],
  extraData: const {'nickname': 'Mo', 'role': 'user'},
  notificationsMuted: true,
  status: 'member',
  banFromFutureChannels: true,
  futureChannelBanExpires: DateTime.utc(2026, 7),
  deletedAt: DateTime.utc(2026, 8),
);

/// The [User] that [fakeUserResponse] maps to.
User fakeUser(String id) => User(
  id: id,
  role: 'user',
  createdAt: DateTime.utc(2025),
  updatedAt: DateTime.utc(2025),
  online: false,
  banned: false,
  teams: const [],
  language: 'en',
);
