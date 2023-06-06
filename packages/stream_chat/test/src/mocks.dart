import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/client/channel.dart';
import 'package:stream_chat/src/client/client.dart';
import 'package:stream_chat/src/core/api/attachment_file_uploader.dart';
import 'package:stream_chat/src/core/api/channel_api.dart';
import 'package:stream_chat/src/core/api/device_api.dart';
import 'package:stream_chat/src/core/api/general_api.dart';
import 'package:stream_chat/src/core/api/guest_api.dart';
import 'package:stream_chat/src/core/api/message_api.dart';
import 'package:stream_chat/src/core/api/moderation_api.dart';
import 'package:stream_chat/src/core/api/user_api.dart';
import 'package:stream_chat/src/core/http/connection_id_manager.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/core/http/token_manager.dart';
import 'package:stream_chat/src/core/models/channel_config.dart';
import 'package:stream_chat/src/db/chat_persistence_client.dart';
import 'package:stream_chat/src/ws/websocket.dart';
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

class MockUserApi extends Mock implements UserApi {}

class MockGuestApi extends Mock implements GuestApi {}

class MockMessageApi extends Mock implements MessageApi {}

class MockChannelApi extends Mock implements ChannelApi {}

class MockDeviceApi extends Mock implements DeviceApi {}

class MockModerationApi extends Mock implements ModerationApi {}

class MockGeneralApi extends Mock implements GeneralApi {}

class MockAttachmentFileUploader extends Mock
    implements AttachmentFileUploader {}

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

class MockStreamChatClient extends Mock implements StreamChatClient {
  @override
  bool get persistenceEnabled => false;
}

class MockStreamChatClientWithPersistence extends Mock
    implements StreamChatClient {
  ChatPersistenceClient? _persistenceClient;

  @override
  ChatPersistenceClient get chatPersistenceClient =>
      _persistenceClient ??= MockPersistenceClient();

  @override
  bool get persistenceEnabled => true;
}

class MockChannelConfig extends Mock implements ChannelConfig {}

class MockRetryQueueChannel extends Mock implements Channel {
  final channelId = 'test-channel-id';
  final channelType = 'test-channel-type';

  @override
  String? get id => channelId;

  @override
  String get type => channelType;

  @override
  String? get cid => '$channelType:$channelId';

  StreamChatClient? _client;

  @override
  StreamChatClient get client => _client ??= MockStreamChatClient();
}

class MockWebSocket extends Mock implements WebSocket {}
