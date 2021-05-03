import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';

class MockLogger extends Mock implements Logger {}

class MockClient extends Mock implements StreamChatClient {
  @override
  final Logger logger = MockLogger();

  ClientState? _state;

  @override
  ClientState get state => _state ??= MockClientState();
}

class MockClientState extends Mock implements ClientState {
  OwnUser? _user;

  @override
  OwnUser get user => _user ??= OwnUser(
        id: 'testUserId',
        role: 'admin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
}

class MockChannel extends Mock implements Channel {
  ChannelClientState? _state;

  @override
  ChannelClientState get state => _state ??= MockChannelState();

  StreamChatClient? _client;

  @override
  StreamChatClient get client => _client ??= MockClient();
}

class MockChannelState extends Mock implements ChannelClientState {}
