// ignore_for_file: avoid_redundant_argument_values, lines_longer_than_80_chars

import 'package:stream_chat/src/core/http/system_environment_manager.dart';
import 'package:stream_chat/src/core/platform_detector/platform_detector.dart';
import 'package:stream_chat/src/system_environment.dart';
import 'package:stream_chat/version.dart';
import 'package:test/test.dart';

void main() {
  group('SystemEnvironmentManager', () {
    late SystemEnvironmentManager manager;

    setUp(() {
      manager = SystemEnvironmentManager();
    });

    test('initializes with default Stream environment', () {
      expect(manager.environment.sdkName, equals('stream-chat'));
      expect(manager.environment.sdkIdentifier, equals('dart'));
      expect(manager.environment.sdkVersion, equals(PACKAGE_VERSION));
    });

    test('sanitizes environment passed to constructor', () {
      const customEnv = SystemEnvironment(
        sdkName: 'custom-sdk',
        sdkIdentifier: 'flutter',
        sdkVersion: '1.0.0',
        appName: 'test-app',
      );

      manager = SystemEnvironmentManager(environment: customEnv);

      // Immutable fields are forced to internal values.
      expect(manager.environment.sdkName, equals('stream-chat'));
      expect(manager.environment.sdkVersion, equals(PACKAGE_VERSION));
      expect(manager.environment.osName, equals(CurrentPlatform.name));
      // Whitelisted sdkIdentifier is accepted.
      expect(manager.environment.sdkIdentifier, equals('flutter'));
      // App fields are passed through.
      expect(manager.environment.appName, equals('test-app'));
    });

    test('sanitizes environment on update', () {
      const newEnv = SystemEnvironment(
        sdkName: 'stream-chat-android',
        sdkIdentifier: 'android',
        sdkVersion: '99.0.0',
        appName: 'test-app',
        appVersion: '2.0.0',
        osName: 'spoofed-os',
        osVersion: '14',
        deviceModel: 'Pixel 7',
      );

      manager.updateEnvironment(newEnv);

      // Immutable fields are forced to internal values.
      expect(manager.environment.sdkName, equals('stream-chat'));
      expect(manager.environment.sdkVersion, equals(PACKAGE_VERSION));
      expect(manager.environment.osName, equals(CurrentPlatform.name));
      // Unknown sdkIdentifier falls back to the current value.
      expect(manager.environment.sdkIdentifier, equals('dart'));
      // App/device/os-version fields are passed through.
      expect(manager.environment.appName, equals('test-app'));
      expect(manager.environment.appVersion, equals('2.0.0'));
      expect(manager.environment.osVersion, equals('14'));
      expect(manager.environment.deviceModel, equals('Pixel 7'));
    });

    test('allows promoting sdkIdentifier from dart to flutter', () {
      manager.updateEnvironment(
        const SystemEnvironment(
          sdkName: 'stream-chat',
          sdkIdentifier: 'flutter',
          sdkVersion: PACKAGE_VERSION,
        ),
      );

      expect(manager.environment.sdkIdentifier, equals('flutter'));
    });

    test('ignores demotion of sdkIdentifier from flutter to dart', () {
      manager
        ..updateEnvironment(
          const SystemEnvironment(
            sdkName: 'stream-chat',
            sdkIdentifier: 'flutter',
            sdkVersion: PACKAGE_VERSION,
          ),
        )
        ..updateEnvironment(
          const SystemEnvironment(
            sdkName: 'stream-chat',
            sdkIdentifier: 'dart',
            sdkVersion: PACKAGE_VERSION,
          ),
        );

      expect(manager.environment.sdkIdentifier, equals('flutter'));
    });

    test('userAgent returns proper header string', () {
      expect(
        manager.userAgent,
        equals('stream-chat-dart-v$PACKAGE_VERSION|os=${CurrentPlatform.name}'),
      );
    });
  });

  group('XStreamClientHeaderExtension', () {
    test('generates minimal header with required fields only', () {
      const env = SystemEnvironment(
        sdkName: 'stream-chat',
        sdkIdentifier: 'dart',
        sdkVersion: '1.0.0',
      );

      expect(env.xStreamClientHeader, equals('stream-chat-dart-v1.0.0'));
    });

    test('includes app name when available', () {
      const env = SystemEnvironment(
        sdkName: 'stream-chat',
        sdkIdentifier: 'dart',
        sdkVersion: '1.0.0',
        appName: 'test-app',
      );

      expect(
        env.xStreamClientHeader,
        equals('stream-chat-dart-v1.0.0|app=test-app'),
      );
    });

    test('includes app version when available', () {
      const env = SystemEnvironment(
        sdkName: 'stream-chat',
        sdkIdentifier: 'dart',
        sdkVersion: '1.0.0',
        appVersion: '2.0.0',
      );

      expect(
        env.xStreamClientHeader,
        equals('stream-chat-dart-v1.0.0|app_version=2.0.0'),
      );
    });

    test('includes OS information with name and version', () {
      const env = SystemEnvironment(
        sdkName: 'stream-chat',
        sdkIdentifier: 'dart',
        sdkVersion: '1.0.0',
        osName: 'iOS',
        osVersion: '16.0',
      );

      expect(
        env.xStreamClientHeader,
        equals('stream-chat-dart-v1.0.0|os=iOS 16.0'),
      );
    });

    test('includes OS name only when version is null', () {
      const env = SystemEnvironment(
        sdkName: 'stream-chat',
        sdkIdentifier: 'dart',
        sdkVersion: '1.0.0',
        osName: 'Android',
      );

      expect(
        env.xStreamClientHeader,
        equals('stream-chat-dart-v1.0.0|os=Android'),
      );
    });

    test('includes device model when available', () {
      const env = SystemEnvironment(
        sdkName: 'stream-chat',
        sdkIdentifier: 'dart',
        sdkVersion: '1.0.0',
        deviceModel: 'iPhone 14',
      );

      expect(
        env.xStreamClientHeader,
        equals('stream-chat-dart-v1.0.0|device_model=iPhone 14'),
      );
    });

    test('includes all information when available', () {
      const env = SystemEnvironment(
        sdkName: 'stream-chat',
        sdkIdentifier: 'dart',
        sdkVersion: '1.0.0',
        appName: 'test-app',
        appVersion: '2.0.0',
        osName: 'iOS',
        osVersion: '16.0',
        deviceModel: 'iPhone 14',
      );

      expect(
        env.xStreamClientHeader,
        equals(
          'stream-chat-dart-v1.0.0|app=test-app|app_version=2.0.0|os=iOS 16.0|device_model=iPhone 14',
        ),
      );
    });

    test('excludes OS section when both osName and osVersion are null', () {
      const env = SystemEnvironment(
        sdkName: 'stream-chat',
        sdkIdentifier: 'dart',
        sdkVersion: '1.0.0',
        appName: 'test-app',
      );

      expect(
        env.xStreamClientHeader,
        equals('stream-chat-dart-v1.0.0|app=test-app'),
      );
      expect(env.xStreamClientHeader.contains('os='), isFalse);
    });

    test('skips null values in header generation', () {
      const env = SystemEnvironment(
        sdkName: 'stream-chat',
        sdkIdentifier: 'dart',
        sdkVersion: '1.0.0',
        appName: null,
        appVersion: '2.0.0',
        osName: null,
        osVersion: null,
        deviceModel: 'iPhone 14',
      );

      expect(
        env.xStreamClientHeader,
        equals(
          'stream-chat-dart-v1.0.0|app_version=2.0.0|device_model=iPhone 14',
        ),
      );
    });
  });
}
