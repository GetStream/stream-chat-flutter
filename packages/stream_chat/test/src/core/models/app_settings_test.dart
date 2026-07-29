import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('AppSettings', () {
    late AppSettings appSettings;

    setUp(() {
      final json = jsonFixture('app_settings.json');
      appSettings = AppSettings.fromJson(json['app'] as Map<String, dynamic>);
    });

    test('parses name', () {
      expect(appSettings.name, 'test-app');
    });

    test('parses top-level booleans', () {
      expect(appSettings.autoTranslationEnabled, false);
      expect(appSettings.asyncUrlEnrichEnabled, true);
    });

    test('parses fileUploadConfig size_limit', () {
      expect(appSettings.fileUploadConfig.sizeLimit, 10485760);
    });

    test('parses imageUploadConfig size_limit', () {
      expect(appSettings.imageUploadConfig.sizeLimit, 5242880);
    });

    test('parses fileUploadConfig extension lists', () {
      expect(appSettings.fileUploadConfig.allowedFileExtensions, ['.csv', '.pdf']);
      expect(appSettings.fileUploadConfig.blockedFileExtensions, ['.exe']);
    });

    test('parses fileUploadConfig mime lists', () {
      expect(appSettings.fileUploadConfig.allowedMimeTypes, ['text/csv', 'application/pdf']);
      expect(appSettings.fileUploadConfig.blockedMimeTypes, ['application/x-msdownload']);
    });

    test('parses imageUploadConfig with empty lists', () {
      expect(appSettings.imageUploadConfig.allowedFileExtensions, isEmpty);
      expect(appSettings.imageUploadConfig.blockedFileExtensions, isEmpty);
    });

    test('defaults to empty lists when fields are absent', () {
      final config = UploadConfig.fromJson(const {'size_limit': 0});
      expect(config.allowedFileExtensions, isEmpty);
      expect(config.blockedFileExtensions, isEmpty);
      expect(config.allowedMimeTypes, isEmpty);
      expect(config.blockedMimeTypes, isEmpty);
    });

    test('defaults sizeLimit to defaultSizeLimit when absent', () {
      final config = UploadConfig.fromJson(const {});
      expect(config.sizeLimit, UploadConfig.defaultSizeLimit);
    });
  });
}
