import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('AppSettings.fromJson parses the name', () {
    final appSettings = _appSettingsFromFixture();

    expect(appSettings.name, 'test-app');
  });

  test('AppSettings.fromJson parses the file upload config', () {
    final appSettings = _appSettingsFromFixture();

    expect(
      appSettings.fileUploadConfig,
      const UploadConfig(
        sizeLimit: 10485760,
        allowedFileExtensions: ['.csv', '.pdf'],
        blockedFileExtensions: ['.exe'],
        allowedMimeTypes: ['text/csv', 'application/pdf'],
        blockedMimeTypes: ['application/x-msdownload'],
      ),
    );
  });

  test('AppSettings.fromJson parses the image upload config', () {
    final appSettings = _appSettingsFromFixture();

    expect(
      appSettings.imageUploadConfig,
      const UploadConfig(
        sizeLimit: 5242880,
        allowedMimeTypes: ['image/png', 'image/jpeg'],
      ),
    );
  });

  test('AppSettings.fromJson defaults both upload configs when absent', () {
    final appSettings = AppSettings.fromJson(const {'name': 'test-app'});

    expect(appSettings.fileUploadConfig, const UploadConfig());
    expect(appSettings.imageUploadConfig, const UploadConfig());
  });

  test('UploadConfig.fromJson defaults the lists when they are absent', () {
    final config = UploadConfig.fromJson(const {});

    expect(config, const UploadConfig());
  });

  test('UploadConfig.fromJson defaults the size limit when it is absent', () {
    final config = UploadConfig.fromJson(const {});

    expect(config.sizeLimit, UploadConfig.defaultSizeLimit);
  });

  test('UploadConfig.fromJson maps a size limit of 0 to the default', () {
    final config = UploadConfig.fromJson(const {'size_limit': 0});

    expect(config.sizeLimit, UploadConfig.defaultSizeLimit);
  });
}

AppSettings _appSettingsFromFixture() {
  final json = jsonFixture('app_settings.json');
  return AppSettings.fromJson(json['app'] as Map<String, dynamic>);
}
