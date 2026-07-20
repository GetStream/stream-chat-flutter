import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/stream_channel_list_controller.dart';
import 'package:stream_chat_flutter_core/src/stream_channel_list_event_handler.dart';

class MockLogger extends Mock implements Logger {}

class MockStreamChannelListController extends Mock implements StreamChannelListController {}

class MockStreamChannelListEventHandler extends Mock implements StreamChannelListEventHandler {}

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

  @override
  Future<bool> get initialized async => false;
}

class MockChannel extends NonInitializedMockChannel {
  ChannelClientState? _state;

  @override
  ChannelClientState get state => _state ??= MockChannelState();

  @override
  Future<bool> get initialized async => true;
}

class MockChannelState extends Mock implements ChannelClientState {}
