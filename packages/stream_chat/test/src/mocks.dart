import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
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
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/db/chat_persistence_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'db/chat_persistence_client_test.dart';

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

class MockPersistenceClient extends Mock implements ChatPersistenceClient {}

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
