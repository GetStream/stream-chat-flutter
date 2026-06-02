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
      expect(appSettings.fileUploadConfig.sizeLimitInBytes, 10485760);
    });

    test('parses imageUploadConfig size_limit', () {
      expect(appSettings.imageUploadConfig.sizeLimitInBytes, 5242880);
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
      final config = UploadConfig.fromJson({'size_limit': 0});
      expect(config.allowedFileExtensions, isEmpty);
      expect(config.blockedFileExtensions, isEmpty);
      expect(config.allowedMimeTypes, isEmpty);
      expect(config.blockedMimeTypes, isEmpty);
    });

    test('defaults sizeLimitInBytes to null when absent', () {
      final config = UploadConfig.fromJson({});
      expect(config.sizeLimitInBytes, isNull);
    });
  });

  group('UploadConfig.isAllowed', () {
    test('allows everything when lists are empty', () {
      final config = UploadConfig();
      expect(config.isAllowed(fileExtension: '.pdf', mimeType: 'application/pdf'), isTrue);
      expect(config.isAllowed(), isTrue);
    });

    test('blocks by extension', () {
      final config = UploadConfig(blockedFileExtensions: ['.exe']);
      expect(config.isAllowed(fileExtension: '.exe'), isFalse);
      expect(config.isAllowed(fileExtension: '.pdf'), isTrue);
    });

    test('blocked extension check is case-insensitive', () {
      final config = UploadConfig(blockedFileExtensions: ['.EXE']);
      expect(config.isAllowed(fileExtension: '.exe'), isFalse);
      expect(config.isAllowed(fileExtension: 'exe'), isFalse);
    });

    test('leading dot on blocked extension is stripped before comparison', () {
      final config = UploadConfig(blockedFileExtensions: ['exe']);
      expect(config.isAllowed(fileExtension: '.exe'), isFalse);
    });

    test('enforces allow-list for extensions', () {
      final config = UploadConfig(allowedFileExtensions: ['.csv', '.pdf']);
      expect(config.isAllowed(fileExtension: '.csv'), isTrue);
      expect(config.isAllowed(fileExtension: '.pdf'), isTrue);
      expect(config.isAllowed(fileExtension: '.txt'), isFalse);
    });

    test('blocks by mime type', () {
      final config = UploadConfig(blockedMimeTypes: ['application/x-msdownload']);
      expect(config.isAllowed(mimeType: 'application/x-msdownload'), isFalse);
      expect(config.isAllowed(mimeType: 'text/csv'), isTrue);
    });

    test('enforces allow-list for mime types', () {
      final config = UploadConfig(allowedMimeTypes: ['text/csv', 'image/png']);
      expect(config.isAllowed(mimeType: 'text/csv'), isTrue);
      expect(config.isAllowed(mimeType: 'application/pdf'), isFalse);
    });

    test('blocked takes precedence over allowed', () {
      final config = UploadConfig(
        allowedFileExtensions: ['.pdf', '.exe'],
        blockedFileExtensions: ['.exe'],
      );
      expect(config.isAllowed(fileExtension: '.exe'), isFalse);
      expect(config.isAllowed(fileExtension: '.pdf'), isTrue);
    });

    test('null extension and mime type are always allowed', () {
      final config = UploadConfig(
        allowedFileExtensions: ['.pdf'],
        allowedMimeTypes: ['image/png'],
      );
      expect(config.isAllowed(), isTrue);
    });

    test('extension and mime type are both checked', () {
      final config = UploadConfig(
        allowedFileExtensions: ['.pdf'],
        allowedMimeTypes: ['application/pdf'],
      );
      // Both pass
      expect(config.isAllowed(fileExtension: '.pdf', mimeType: 'application/pdf'), isTrue);
      // Extension fails
      expect(config.isAllowed(fileExtension: '.txt', mimeType: 'application/pdf'), isFalse);
      // Mime fails
      expect(config.isAllowed(fileExtension: '.pdf', mimeType: 'text/plain'), isFalse);
    });
  });
}
