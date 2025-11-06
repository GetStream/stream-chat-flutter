import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/src/core/api/channel_api.dart';
import 'package:stream_chat/src/core/api/device_api.dart';
import 'package:stream_chat/src/core/api/general_api.dart';
import 'package:stream_chat/src/core/api/guest_api.dart';
import 'package:stream_chat/src/core/api/message_api.dart';
import 'package:stream_chat/src/core/api/moderation_api.dart';
import 'package:stream_chat/src/core/api/polls_api.dart';
import 'package:stream_chat/src/core/api/user_api.dart';
import 'package:stream_chat/src/core/http/token.dart';
import 'package:stream_chat/src/core/http/token_manager.dart';
import 'package:stream_chat/src/ws/websocket.dart';
import 'package:stream_chat/stream_chat.dart';

import 'mocks.dart';

class FakeTokenManager extends Fake implements TokenManager {
  final token = Token.development('test-user-id');

  @override
  bool get isStatic => true;

  @override
  String? get userId => token.userId;

  @override
  Future<Token> loadToken({bool refresh = false}) async => token;

  @override
  Future<Token> setTokenOrProvider(
    String userId, {
    Token? token,
    TokenProvider? provider,
  }) async =>
      this.token;

  @override
  void reset() {}
}

class FakeMultiPartFile extends Fake implements MultipartFile {}

/// Fake persistence client for testing persistence client reliability features
class FakePersistenceClient extends Fake implements ChatPersistenceClient {
  FakePersistenceClient({
    DateTime? lastSyncAt,
    List<String>? channelCids,
  })  : _lastSyncAt = lastSyncAt,
        _channelCids = channelCids ?? [];

  String? _userId;
  bool _isConnected = false;
  DateTime? _lastSyncAt;
  List<String> _channelCids;

  // Track method calls for testing
  int connectCallCount = 0;
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

  GeneralApi? _general;

  @override
  GeneralApi get general => _general ??= MockGeneralApi();

  AttachmentFileUploader? _fileUploader;

  @override
  AttachmentFileUploader get fileUploader =>
      _fileUploader ??= MockAttachmentFileUploader();
}

class FakeClientState extends Fake implements ClientState {
  FakeClientState({
    OwnUser? currentUser,
  }) : _currentUser = currentUser;

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

class FakeWebSocket extends Fake implements WebSocket {
  late final _connectionStatusController = BehaviorSubject.seeded(
    ConnectionStatus.disconnected,
  );

  set connectionStatus(ConnectionStatus value) {
    _connectionStatusController.add(value);
  }

  @override
  ConnectionStatus get connectionStatus => _connectionStatusController.value;

  @override
  Stream<ConnectionStatus> get connectionStatusStream =>
      _connectionStatusController.stream;

  @override
  Completer<Event>? connectionCompleter;

  @override
  Future<Event> connect(
    User user, {
    bool? includeUserDetails = true,
  }) async {
    connectionStatus = ConnectionStatus.connecting;
    final event = Event(
      type: EventType.healthCheck,
      connectionId: 'fake-connection-id',
      me: OwnUser.fromUser(user),
    );
    connectionCompleter = Completer()..complete(event);
    connectionStatus = ConnectionStatus.connected;
    return connectionCompleter!.future;
  }

  @override
  void disconnect() {
    connectionStatus = ConnectionStatus.disconnected;
    connectionCompleter = null;
  }

  @override
  Future<void> dispose() async {
    await _connectionStatusController.close();
  }
}

class FakeWebSocketWithConnectionError extends Fake implements WebSocket {
  late final _connectionStatusController = BehaviorSubject.seeded(
    ConnectionStatus.disconnected,
  );

  set connectionStatus(ConnectionStatus value) {
    _connectionStatusController.add(value);
  }

  @override
  ConnectionStatus get connectionStatus => _connectionStatusController.value;

  @override
  Stream<ConnectionStatus> get connectionStatusStream =>
      _connectionStatusController.stream;

  @override
  Completer<Event>? connectionCompleter;

  @override
  Future<Event> connect(
    User user, {
    bool? includeUserDetails = true,
  }) async {
    connectionStatus = ConnectionStatus.connecting;
    const error = StreamWebSocketError('Error Connecting');
    connectionCompleter = Completer()..completeError(error);
    return connectionCompleter!.future;
  }

  @override
  void disconnect() {
    connectionStatus = ConnectionStatus.disconnected;
    connectionCompleter = null;
  }

  @override
  Future<void> dispose() async {
    await _connectionStatusController.close();
  }
}

class FakeChannelState extends Fake implements ChannelState {}

class FakePartialUpdateMemberResponse extends Fake
    implements PartialUpdateMemberResponse {
  FakePartialUpdateMemberResponse({
    Member? channelMember,
  }) : _channelMember = channelMember ?? Member();

  final Member _channelMember;
  @override
  Member get channelMember => _channelMember;
}
