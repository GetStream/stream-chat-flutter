import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/general_api.dart';
import 'package:stream_chat/src/core/http/connection_id_manager.dart';
import 'package:stream_chat/src/core/http/token_manager.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart' show MockPersistenceClient;
import 'package:web_socket_channel/web_socket_channel.dart';

class MockWebSocketChannel extends Mock implements WebSocketChannel {}

class MockWebSocketSink extends Mock implements WebSocketSink {}

class MockDio extends Mock implements Dio {
  BaseOptions? _options;

  @override
  BaseOptions get options => _options ??= BaseOptions();

  Interceptors? _interceptors;

  @override
  Interceptors get interceptors => _interceptors ??= Interceptors();
}

class MockLogger extends Mock implements Logger {
  @override
  Level get level => Level.ALL;
}

class MockHttpClient extends Mock implements StreamHttpClient {}

class MockTokenManager extends Mock implements TokenManager {}

class MockConnectionIdManager extends Mock implements ConnectionIdManager {}

class MockGeneralApi extends Mock implements GeneralApi {}

class MockChannelDeliveryReporter extends Mock implements ChannelDeliveryReporter {}

class MockStreamChatClient extends Mock implements StreamChatClient {
  // A plain settable field for the same reason as [isLocalUnreadCountEnabled]
  // below: stubbing it via `when()` corrupts mocktail's global stubbing state
  // when this mock is lazily constructed inside another `when()`.
  @override
  bool persistenceEnabled = false;

  // A plain settable field (not a `when(...)` stub) so tests can flip it
  // with a direct assignment, e.g. `client.isLocalUnreadCountEnabled = true`.
  // Stubbing it via `when()` in this constructor would be re-entrant: this
  // mock is often stored in a `late final` and lazily constructed as a side
  // effect of evaluating another `when(() => client....)` call already in
  // progress, which corrupts mocktail's global stubbing state.
  @override
  bool isLocalUnreadCountEnabled = false;

  ChannelDeliveryReporter? _deliveryReporter;

  @override
  ChannelDeliveryReporter get channelDeliveryReporter {
    return _deliveryReporter ??= MockChannelDeliveryReporter();
  }
}

class MockStreamChatClientWithPersistence extends MockStreamChatClient {
  MockStreamChatClientWithPersistence() {
    // Sets the inherited field rather than overriding its getter, which would
    // leave the inherited setter silently doing nothing.
    persistenceEnabled = true;
  }

  ChatPersistenceClient? _persistenceClient;

  @override
  ChatPersistenceClient get chatPersistenceClient => _persistenceClient ??= MockPersistenceClient();
}

class MockClientState extends Mock implements ClientState {}

class MockChannelConfig extends Mock implements ChannelConfig {}

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
