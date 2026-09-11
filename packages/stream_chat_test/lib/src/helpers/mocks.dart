import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/channel_api.dart';
import 'package:stream_chat/src/core/api/device_api.dart';
import 'package:stream_chat/src/core/api/general_api.dart';
import 'package:stream_chat/src/core/api/guest_api.dart';
import 'package:stream_chat/src/core/api/message_api.dart';
import 'package:stream_chat/src/core/api/moderation_api.dart';
import 'package:stream_chat/src/core/api/polls_api.dart';
import 'package:stream_chat/src/core/api/reminders_api.dart';
import 'package:stream_chat/src/core/api/roles_api.dart';
import 'package:stream_chat/src/core/api/threads_api.dart';
import 'package:stream_chat/src/core/api/user_api.dart';
import 'package:stream_chat/src/core/api/user_groups_api.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Mock implementation of [UserApi].
class MockUserApi extends Mock implements UserApi {}

/// Mock implementation of [GuestApi].
class MockGuestApi extends Mock implements GuestApi {}

/// Mock implementation of [MessageApi].
class MockMessageApi extends Mock implements MessageApi {}

/// Mock implementation of [PollsApi].
class MockPollsApi extends Mock implements PollsApi {}

/// Mock implementation of [ThreadsApi].
class MockThreadsApi extends Mock implements ThreadsApi {}

/// Mock implementation of [ChannelApi].
class MockChannelApi extends Mock implements ChannelApi {}

/// Mock implementation of [DeviceApi].
class MockDeviceApi extends Mock implements DeviceApi {}

/// Mock implementation of [ModerationApi].
class MockModerationApi extends Mock implements ModerationApi {}

/// Mock implementation of [RemindersApi].
class MockRemindersApi extends Mock implements RemindersApi {}

/// Mock implementation of [UserGroupsApi].
class MockUserGroupsApi extends Mock implements UserGroupsApi {}

/// Mock implementation of [RolesApi].
class MockRolesApi extends Mock implements RolesApi {}

/// Mock implementation of [GeneralApi].
class MockGeneralApi extends Mock implements GeneralApi {}

/// Mock implementation of [AttachmentFileUploader].
class MockAttachmentFileUploader extends Mock implements AttachmentFileUploader {}

/// Mock implementation of [WebSocketChannel].
class MockWebSocketChannel extends Mock implements WebSocketChannel {}

/// Mock implementation of [WebSocketSink].
class MockWebSocketSink extends Mock implements WebSocketSink {}

/// Mock implementation of [ChatPersistenceClient].
///
/// Tracks real connection state (`connect` / `disconnect` / [isConnected] /
/// [userId]) so the client's persistence lifecycle works without stubbing;
/// every other member is a regular mocktail mock. Pass it to the harness via
/// the `chatPersistenceClient:` parameter.
class MockPersistenceClient extends Mock implements ChatPersistenceClient {
  String? _userId;
  bool _isConnected = false;

  @override
  bool get isConnected => _isConnected;

  @override
  String? get userId => _userId;

  @override
  Future<void> connect(String userId) async {
    _userId = userId;
    _isConnected = true;
  }

  @override
  Future<void> disconnect({bool flush = false}) async {
    _userId = null;
    _isConnected = false;
  }
}

/// Fake implementation of [ChatPersistenceClient].
///
/// Implements the connection lifecycle and sync bookkeeping with real state
/// and records how often `connect` / `disconnect` were called, for tests that
/// assert on the persistence lifecycle itself. Members beyond these throw,
/// as on any [Fake].
class FakePersistenceClient extends Fake implements ChatPersistenceClient {
  /// Creates a [FakePersistenceClient], optionally seeded with a last-sync
  /// timestamp and a list of locally cached channel cids.
  FakePersistenceClient({
    this._lastSyncAt,
    List<String>? channelCids,
  }) : _channelCids = channelCids ?? [];

  String? _userId;
  bool _isConnected = false;
  DateTime? _lastSyncAt;
  List<String> _channelCids;

  /// Number of times [connect] was called.
  int connectCallCount = 0;

  /// Number of times [disconnect] was called.
  int disconnectCallCount = 0;

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
}

/// A [StreamChatApi] whose sub-APIs are lazily-created mocks.
///
/// Injected into [StreamChatClient] as the `chatApi:` seam so that every REST
/// call made by the SDK can be stubbed and verified through the mocked
/// sub-APIs, while everything above the API layer stays real.
class FakeChatApi extends Fake implements StreamChatApi {
  UserApi? _user;

  @override
  UserApi get user => _user ??= MockUserApi();

  GuestApi? _guest;

  @override
  GuestApi get guest => _guest ??= MockGuestApi();

  MessageApi? _message;

  @override
  MessageApi get message => _message ??= MockMessageApi();

  PollsApi? _polls;

  @override
  PollsApi get polls => _polls ??= MockPollsApi();

  ThreadsApi? _threads;

  @override
  ThreadsApi get threads => _threads ??= MockThreadsApi();

  ChannelApi? _channel;

  @override
  ChannelApi get channel => _channel ??= MockChannelApi();

  DeviceApi? _device;

  @override
  DeviceApi get device => _device ??= MockDeviceApi();

  ModerationApi? _moderation;

  @override
  ModerationApi get moderation => _moderation ??= MockModerationApi();

  RemindersApi? _reminders;

  @override
  RemindersApi get reminders => _reminders ??= MockRemindersApi();

  UserGroupsApi? _userGroups;

  @override
  UserGroupsApi get userGroups => _userGroups ??= MockUserGroupsApi();

  RolesApi? _roles;

  @override
  RolesApi get roles => _roles ??= MockRolesApi();

  GeneralApi? _general;

  @override
  GeneralApi get general => _general ??= MockGeneralApi();

  AttachmentFileUploader? _fileUploader;

  @override
  AttachmentFileUploader get fileUploader => _fileUploader ??= MockAttachmentFileUploader();
}

class _FakeMessage extends Fake implements Message {}

class _FakeDraftMessage extends Fake implements DraftMessage {}

class _FakeAttachmentFile extends Fake implements AttachmentFile {}

class _FakeEvent extends Fake implements Event {}

class _FakeUser extends Fake implements User {}

class _FakePollVote extends Fake implements PollVote {}

class _FakeChannelState extends Fake implements ChannelState {}

class _FakeMultipartFile extends Fake implements MultipartFile {}

/// Registers mocktail fallback values for common chat argument types, so that
/// `any()` / `captureAny()` matchers can be used with them.
///
/// Called automatically by the tester lifecycle, so tests should not need to
/// call it. Calling it again is harmless but appends another set of values —
/// mocktail keeps every value it is given.
void registerChatFallbackValues() {
  registerFallbackValue(_FakeMessage());
  registerFallbackValue(_FakeDraftMessage());
  registerFallbackValue(_FakeAttachmentFile());
  registerFallbackValue(_FakeEvent());
  registerFallbackValue(_FakeUser());
  registerFallbackValue(_FakePollVote());
  registerFallbackValue(_FakeChannelState());
  registerFallbackValue(_FakeMultipartFile());
  registerFallbackValue(const PaginationParams());
  registerFallbackValue(const Filter.empty());
}
