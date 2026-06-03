import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/http/app_settings_manager.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../mocks.dart';
import '../../utils.dart';

void main() {
  late MockGeneralApi api;
  late AppSettingsManager manager;

  GetAppSettingsResponse responseFromFixture() {
    return GetAppSettingsResponse.fromJson(jsonFixture('app_settings.json'));
  }

  setUp(() {
    api = MockGeneralApi();
    manager = AppSettingsManager(api);
  });

  group('appSettings', () {
    test('returns a default AppSettings before any load', () {
      expect(manager.appSettings, const AppSettings());
    });
  });

  group('loadAppSettings', () {
    test('fetches and caches on first call', () async {
      final response = responseFromFixture();
      when(() => api.getAppSettings()).thenAnswer((_) async => response);

      await manager.loadAppSettings();

      expect(manager.appSettings, response.app);
      verify(() => api.getAppSettings()).called(1);
    });

    test('is a no-op when a cached value already exists', () async {
      when(() => api.getAppSettings()).thenAnswer((_) async => responseFromFixture());

      await manager.loadAppSettings();
      await manager.loadAppSettings();

      verify(() => api.getAppSettings()).called(1);
    });

    test('swallows errors and leaves appSettings at the default', () async {
      when(() => api.getAppSettings()).thenThrow(Exception('boom'));

      await manager.loadAppSettings();

      expect(manager.appSettings, const AppSettings());
    });

    test('retries on the next call when the previous attempt failed', () async {
      final response = responseFromFixture();
      var calls = 0;
      when(() => api.getAppSettings()).thenAnswer((_) async {
        calls++;
        if (calls == 1) throw Exception('boom');
        return response;
      });

      await manager.loadAppSettings();
      await manager.loadAppSettings();

      expect(manager.appSettings, response.app);
      verify(() => api.getAppSettings()).called(2);
    });
  });

  group('refresh', () {
    test('always re-fetches and returns the new value', () async {
      final response = responseFromFixture();
      when(() => api.getAppSettings()).thenAnswer((_) async => response);

      await manager.loadAppSettings();
      final refreshed = await manager.refresh();

      expect(refreshed, response.app);
      expect(manager.appSettings, response.app);
      verify(() => api.getAppSettings()).called(2);
    });

    test('propagates errors instead of swallowing them', () async {
      when(() => api.getAppSettings()).thenThrow(Exception('boom'));

      await expectLater(manager.refresh(), throwsA(isA<Exception>()));
    });
  });

  group('clear', () {
    test('drops the cache so the next load re-fetches', () async {
      when(() => api.getAppSettings()).thenAnswer((_) async => responseFromFixture());

      await manager.loadAppSettings();
      manager.clear();
      await manager.loadAppSettings();

      verify(() => api.getAppSettings()).called(2);
    });

    test('resets appSettings back to the default', () async {
      when(() => api.getAppSettings()).thenAnswer((_) async => responseFromFixture());

      await manager.loadAppSettings();
      manager.clear();

      expect(manager.appSettings, const AppSettings());
    });
  });
}
