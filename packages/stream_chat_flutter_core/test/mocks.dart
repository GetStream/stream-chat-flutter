import 'package:mockito/mockito.dart';
import 'package:stream_chat/stream_chat.dart';

class MockClient extends Mock implements StreamChatClient {
  final Logger logger = MockLogger();

  ClientState _state;

  @override
  ClientState get state => _state ??= MockClientState();
}

class MockLogger extends Mock implements Logger {}

class MockClientState extends Mock implements ClientState {
  OwnUser _user;

  @override
  OwnUser get user => _user ??= OwnUser(
        id: 'testUserId',
        role: 'admin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
}

class MockChannel extends Mock implements Channel {
  ChannelClientState _state;

  @override
  ChannelClientState get state => _state ??= MockChannelState();
}

class MockChannelState extends Mock implements ChannelClientState {}
