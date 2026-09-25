import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/repository/app_settings_repository.dart';
import 'package:stream_core/stream_core.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  test('AppSettingsRepository.getAppSettings requests the application from the generated client', () async {
    final defaultApi = MockDefaultApi();
    when(defaultApi.getApp).thenAnswer((_) async => const Result.success(_response));

    await AppSettingsRepository(defaultApi).getAppSettings();

    verify(defaultApi.getApp).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('AppSettingsRepository.getAppSettings returns the mapped response', () async {
    final defaultApi = MockDefaultApi();
    when(defaultApi.getApp).thenAnswer((_) async => const Result.success(_response));

    final res = await AppSettingsRepository(defaultApi).getAppSettings();

    expect(res.getOrNull()?.app.name, 'test-app');
  });

  test('AppSettingsRepository.getAppSettings returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    const error = StreamClientException(message: 'boom');
    when(defaultApi.getApp).thenAnswer((_) async => const Result.failure(error));

    final res = await AppSettingsRepository(defaultApi).getAppSettings();

    expect(res.exceptionOrNull(), error);
  });
}

const _response = api.GetApplicationResponse(
  duration: '0.01ms',
  app: api.AppResponseFields(
    id: 42,
    name: 'test-app',
    placement: 'us-east',
    asyncUrlEnrichEnabled: false,
    autoTranslationEnabled: false,
    fileUploadConfig: _unrestricted,
    imageUploadConfig: _unrestricted,
  ),
);

const _unrestricted = api.FileUploadConfig(
  allowedFileExtensions: [],
  allowedMimeTypes: [],
  blockedFileExtensions: [],
  blockedMimeTypes: [],
  sizeLimit: 0,
);
