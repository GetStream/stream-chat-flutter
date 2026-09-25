import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/client/app_settings_manager.dart';
import 'package:stream_chat/src/repository/app_settings_repository.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

class MockAppSettingsRepository extends Mock implements AppSettingsRepository {}

void main() {
  test('AppSettingsManager.appSettings is the default until a load completes', () {
    final repository = MockAppSettingsRepository();
    final manager = AppSettingsManager(repository);
    expect(manager.appSettings, const AppSettings());
  });

  test('AppSettingsManager.loadAppSettings caches the fetched settings', () async {
    final repository = MockAppSettingsRepository();
    final manager = AppSettingsManager(repository);
    when(repository.getAppSettings).thenAnswer((_) async => Result.success(_response()));

    await manager.loadAppSettings();

    expect(manager.appSettings, _response().app);
  });

  test('AppSettingsManager.loadAppSettings does not fetch again once settings are cached', () async {
    final repository = MockAppSettingsRepository();
    final manager = AppSettingsManager(repository);
    when(repository.getAppSettings).thenAnswer((_) async => Result.success(_response()));

    await manager.loadAppSettings();
    await manager.loadAppSettings();

    verify(repository.getAppSettings).called(1);
  });

  test('AppSettingsManager.loadAppSettings keeps the default when the request fails', () async {
    final repository = MockAppSettingsRepository();
    final manager = AppSettingsManager(repository);
    when(repository.getAppSettings).thenAnswer((_) async => const Result.failure(_error));

    await manager.loadAppSettings();

    expect(manager.appSettings, const AppSettings());
  });

  test('AppSettingsManager.loadAppSettings fetches again after a failed attempt', () async {
    final repository = MockAppSettingsRepository();
    final manager = AppSettingsManager(repository);
    var calls = 0;
    when(repository.getAppSettings).thenAnswer((_) async {
      calls++;
      if (calls == 1) return const Result.failure(_error);
      return Result.success(_response());
    });

    await manager.loadAppSettings();
    await manager.loadAppSettings();

    expect(manager.appSettings, _response().app);
  });

  test('AppSettingsManager.refresh returns the fetched response', () async {
    final repository = MockAppSettingsRepository();
    final manager = AppSettingsManager(repository);
    when(repository.getAppSettings).thenAnswer((_) async => Result.success(_response()));

    final res = await manager.refresh();

    expect(res.getOrNull(), _response());
  });

  test('AppSettingsManager.refresh replaces the cached settings', () async {
    final repository = MockAppSettingsRepository();
    final manager = AppSettingsManager(repository);
    when(repository.getAppSettings).thenAnswer((_) async => Result.success(_response(name: 'stale')));
    await manager.loadAppSettings();

    when(repository.getAppSettings).thenAnswer((_) async => Result.success(_response(name: 'fresh')));
    await manager.refresh();

    expect(manager.appSettings.name, 'fresh');
  });

  test('AppSettingsManager.refresh fetches even when settings are cached', () async {
    final repository = MockAppSettingsRepository();
    final manager = AppSettingsManager(repository);
    when(repository.getAppSettings).thenAnswer((_) async => Result.success(_response()));

    await manager.loadAppSettings();
    await manager.refresh();

    verify(repository.getAppSettings).called(2);
  });

  test('AppSettingsManager.refresh returns the failure without throwing', () async {
    final repository = MockAppSettingsRepository();
    final manager = AppSettingsManager(repository);
    when(repository.getAppSettings).thenAnswer((_) async => const Result.failure(_error));

    final res = await manager.refresh();

    expect(res.exceptionOrNull(), _error);
  });

  test('AppSettingsManager.refresh keeps the cached settings when it fails', () async {
    final repository = MockAppSettingsRepository();
    final manager = AppSettingsManager(repository);
    when(repository.getAppSettings).thenAnswer((_) async => Result.success(_response()));
    await manager.loadAppSettings();

    when(repository.getAppSettings).thenAnswer((_) async => const Result.failure(_error));
    await manager.refresh();

    expect(manager.appSettings, _response().app);
  });

  test('AppSettingsManager.clear resets appSettings to the default', () async {
    final repository = MockAppSettingsRepository();
    final manager = AppSettingsManager(repository);
    when(repository.getAppSettings).thenAnswer((_) async => Result.success(_response()));
    await manager.loadAppSettings();

    manager.clear();

    expect(manager.appSettings, const AppSettings());
  });

  test('AppSettingsManager.clear makes the next load fetch again', () async {
    final repository = MockAppSettingsRepository();
    final manager = AppSettingsManager(repository);
    when(repository.getAppSettings).thenAnswer((_) async => Result.success(_response()));

    await manager.loadAppSettings();
    manager.clear();
    await manager.loadAppSettings();

    verify(repository.getAppSettings).called(2);
  });
}

const _error = StreamClientException(message: 'boom');

GetAppSettingsResponse _response({String name = 'test-app'}) {
  return GetAppSettingsResponse(
    duration: '0.01ms',
    app: AppSettings(
      name: name,
      fileUploadConfig: const UploadConfig(sizeLimit: 10485760, blockedFileExtensions: ['.exe']),
      imageUploadConfig: const UploadConfig(sizeLimit: 5242880, allowedMimeTypes: ['image/png']),
      asyncUrlEnrichEnabled: true,
    ),
  );
}
