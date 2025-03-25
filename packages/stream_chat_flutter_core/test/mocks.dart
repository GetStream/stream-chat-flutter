import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';

class MockLogger extends Mock implements Logger {}

class MockClient extends Mock implements StreamChatClient {
  MockClient() {
    when(() => wsConnectionStatus).thenReturn(ConnectionStatus.connected);
  }

  @override
  final Logger logger = MockLogger();

  ClientState? _state;

  @override
  ClientState get state => _state ??= MockClientState();
}

class MockClientState extends Mock implements ClientState {
  OwnUser? _currentUser;

  @override
  OwnUser get currentUser => _currentUser ??= OwnUser(
        id: 'testUserId',
        role: 'admin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
}

class NonInitializedMockChannel extends Mock implements Channel {
  StreamChatClient? _client;

  @override
  StreamChatClient get client => _client ??= MockClient();

  @override
  ChannelClientState? get state => null;
}

class MockChannel extends NonInitializedMockChannel {
  ChannelClientState? _state;

  @override
  ChannelClientState get state => _state ??= MockChannelState();
}

class MockChannelState extends Mock implements ChannelClientState {}
