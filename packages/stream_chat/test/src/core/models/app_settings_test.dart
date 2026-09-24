import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('AppSettings.fromJson', () {
    late AppSettings appSettings;

    setUp(() {
      final json = jsonFixture('app_settings.json');
      appSettings = AppSettings.fromJson(json['app'] as Map<String, dynamic>);
    });

    test('parses the name', () {
      expect(appSettings.name, 'test-app');
    });

    test('parses the file upload config', () {
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

    test('parses the image upload config', () {
      expect(
        appSettings.imageUploadConfig,
        const UploadConfig(
          sizeLimit: 5242880,
          allowedMimeTypes: ['image/png', 'image/jpeg'],
        ),
      );
    });

    test('defaults both upload configs when they are absent', () {
      final appSettings = AppSettings.fromJson(const {'name': 'test-app'});

      expect(appSettings.fileUploadConfig, const UploadConfig());
      expect(appSettings.imageUploadConfig, const UploadConfig());
    });

    test('defaults the lists and size limit when they are absent', () {
      final config = UploadConfig.fromJson(const {});

      expect(config, const UploadConfig());
      expect(config.sizeLimit, UploadConfig.defaultSizeLimit);
    });

    test('uses the default size limit when none is configured', () {
      final config = UploadConfig.fromJson(const {'size_limit': 0});

      expect(config.sizeLimit, UploadConfig.defaultSizeLimit);
    });
  });
}
