// ignore_for_file: avoid_redundant_argument_values, lines_longer_than_80_chars, deprecated_member_use_from_same_package

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/http/token.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../utils.dart';

void main() {
  group('Client with connected user without persistence', () {
    const apiKey = 'test-api-key';
    const userId = 'test-user-id';
    late final api = FakeChatApi();

    final user = User(id: userId);
    final token = Token.development(user.id).rawValue;

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeEvent());
      registerFallbackValue(FakeMessage());
      registerFallbackValue(FakeDraftMessage());
      registerFallbackValue(FakePollVote());
      registerFallbackValue(const PaginationParams());
    });

    setUp(() async {
      // Clear any accumulated interactions from a previous test so that
      // verifyNoMoreInteractions on api.general stays accurate.
      clearInteractions(api.general);

      final ws = FakeWebSocket();
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
      // Stub getAppSettings so the background fetch after connectUser succeeds.
      when(() => api.general.getAppSettings()).thenAnswer(
        (_) async => GetAppSettingsResponse()..app = const AppSettings(name: 'test'),
      );
      await client.connectUser(user, token);
      await delay(300);
      expect(client.persistenceEnabled, isFalse);
      expect(client.wsConnectionStatus, ConnectionStatus.connected);
    });

    tearDown(() async {
      await client.dispose();
    });
  });
}
