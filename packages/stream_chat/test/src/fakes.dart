import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/channel_api.dart';
import 'package:stream_chat/src/core/api/device_api.dart';
import 'package:stream_chat/src/core/api/general_api.dart';
import 'package:stream_chat/src/core/api/guest_api.dart';
import 'package:stream_chat/src/core/api/message_api.dart';
import 'package:stream_chat/src/core/api/moderation_api.dart';
import 'package:stream_chat/src/core/api/polls_api.dart';
import 'package:stream_chat/src/core/api/user_api.dart';
import 'package:stream_chat/src/core/api/user_groups_api.dart';
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

  GuestApi? _guest;

  @override
  GuestApi get guest => _guest ??= MockGuestApi();

  MessageApi? _message;

  @override
  MessageApi get message => _message ??= MockMessageApi();

  @override
  PollsApi get polls => _polls ??= MockPollsApi();

  PollsApi? _polls;

  ChannelApi? _channel;

  @override
  ChannelApi get channel => _channel ??= MockChannelApi();

  DeviceApi? _device;

  @override
  DeviceApi get device => _device ??= MockDeviceApi();

  ModerationApi? _moderation;

  @override
  ModerationApi get moderation => _moderation ??= MockModerationApi();

  UserGroupsApi? _userGroups;

  @override
  UserGroupsApi get userGroups => _userGroups ??= MockUserGroupsApi();

  GeneralApi? _general;

  @override
  GeneralApi get general => _general ??= MockGeneralApi();

  AttachmentFileUploader? _fileUploader;

  @override
  AttachmentFileUploader get fileUploader => _fileUploader ??= MockAttachmentFileUploader();
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

class FakePartialUpdateMemberResponse extends Fake implements PartialUpdateMemberResponse {
  FakePartialUpdateMemberResponse({
    Member? channelMember,
  }) : _channelMember = channelMember ?? Member();

  final Member _channelMember;
  @override
  Member get channelMember => _channelMember;
}
