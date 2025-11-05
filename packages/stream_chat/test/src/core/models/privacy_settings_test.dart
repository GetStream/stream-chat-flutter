// ignore_for_file: avoid_redundant_argument_values

import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

void main() {
  group('PrivacySettings', () {
    test('should parse json correctly with all fields', () {
      final json = {
        'typing_indicators': {'enabled': false},
        'read_receipts': {'enabled': false},
      };

      final privacySettings = PrivacySettings.fromJson(json);

      expect(privacySettings.typingIndicators, isNotNull);
      expect(privacySettings.typingIndicators?.enabled, false);
      expect(privacySettings.readReceipts, isNotNull);
      expect(privacySettings.readReceipts?.enabled, false);
    });

    test('should parse json correctly with null fields', () {
      final json = <String, dynamic>{};

      final privacySettings = PrivacySettings.fromJson(json);

      expect(privacySettings.typingIndicators, isNull);
      expect(privacySettings.readReceipts, isNull);
    });

    test('should parse json correctly with partial fields', () {
      final json = {
        'typing_indicators': {'enabled': true},
      };

      final privacySettings = PrivacySettings.fromJson(json);

      expect(privacySettings.typingIndicators, isNotNull);
      expect(privacySettings.typingIndicators?.enabled, true);
      expect(privacySettings.readReceipts, isNull);
    });

    test('equality should work correctly', () {
      const privacySettings1 = PrivacySettings(
        typingIndicators: TypingIndicatorPrivacySettings(enabled: false),
        readReceipts: ReadReceiptsPrivacySettings(enabled: false),
      );

      const privacySettings2 = PrivacySettings(
        typingIndicators: TypingIndicatorPrivacySettings(enabled: false),
        readReceipts: ReadReceiptsPrivacySettings(enabled: false),
      );

      const privacySettings3 = PrivacySettings(
        typingIndicators: TypingIndicatorPrivacySettings(enabled: true),
        readReceipts: ReadReceiptsPrivacySettings(enabled: false),
      );

      expect(privacySettings1, equals(privacySettings2));
      expect(privacySettings1, isNot(equals(privacySettings3)));
    });
  });

  group('TypingIndicatorPrivacySettings', () {
    test('should have enabled as true by default', () {
      const settings = TypingIndicatorPrivacySettings();
      expect(settings.enabled, true);
    });

    test('should parse json correctly', () {
      final json = {'enabled': false};

      final settings = TypingIndicatorPrivacySettings.fromJson(json);

      expect(settings.enabled, false);
    });

    test('should parse json with enabled as true', () {
      final json = {'enabled': true};

      final settings = TypingIndicatorPrivacySettings.fromJson(json);

      expect(settings.enabled, true);
    });

    test('equality should work correctly', () {
      const settings1 = TypingIndicatorPrivacySettings(enabled: true);
      const settings2 = TypingIndicatorPrivacySettings(enabled: true);
      const settings3 = TypingIndicatorPrivacySettings(enabled: false);

      expect(settings1, equals(settings2));
      expect(settings1, isNot(equals(settings3)));
    });
  });

  group('ReadReceiptsPrivacySettings', () {
    test('should have enabled as true by default', () {
      const settings = ReadReceiptsPrivacySettings();
      expect(settings.enabled, true);
    });

    test('should parse json correctly', () {
      final json = {'enabled': false};

      final settings = ReadReceiptsPrivacySettings.fromJson(json);

      expect(settings.enabled, false);
    });

    test('should parse json with enabled as true', () {
      final json = {'enabled': true};

      final settings = ReadReceiptsPrivacySettings.fromJson(json);

      expect(settings.enabled, true);
    });

    test('equality should work correctly', () {
      const settings1 = ReadReceiptsPrivacySettings(enabled: true);
      const settings2 = ReadReceiptsPrivacySettings(enabled: true);
      const settings3 = ReadReceiptsPrivacySettings(enabled: false);

      expect(settings1, equals(settings2));
      expect(settings1, isNot(equals(settings3)));
    });
  });
}
