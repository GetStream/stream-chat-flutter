// ignore_for_file: use_setters_to_change_properties

import 'package:stream_chat/src/core/platform_detector/platform_detector.dart';
import 'package:stream_chat/src/system_environment.dart';
import 'package:stream_chat/version.dart';

/// {@template systemEnvironmentManager}
/// A manager class to handle the current [SystemEnvironment].
/// {@endtemplate}
class SystemEnvironmentManager {
  /// {@macro systemEnvironmentManager}
  SystemEnvironmentManager({SystemEnvironment? environment})
      : _environment = SystemEnvironment(
          sdkName: _sdkName,
          sdkIdentifier: _SdkIdentifier.dart,
          sdkVersion: PACKAGE_VERSION,
          osName: CurrentPlatform.name,
        ) {
    if (environment != null) updateEnvironment(environment);
  }

  static const _sdkName = 'stream-chat';

  /// Returns the Stream client user agent string based on the current
  /// [environment] value.
  String get userAgent => _environment.xStreamClientHeader;

  /// The current [SystemEnvironment].
  SystemEnvironment get environment => _environment;
  SystemEnvironment _environment;

  /// Updates the current [SystemEnvironment].
  void updateEnvironment(SystemEnvironment environment) {
    _environment = _sanitize(environment);
  }

  /// Sanitizes the passed [SystemEnvironment]
  /// Ignores custom values for:
  /// - sdkName
  /// - sdkVersion
  /// - osName
  /// Allows only the dart -> flutter promotion for:
  /// - sdkIdentifier (any other value, including a flutter -> dart
  ///   demotion, is ignored)
  /// Allows overriding of:
  /// - appName
  /// - appVersion
  /// - osVersion
  /// - deviceModel
  SystemEnvironment _sanitize(SystemEnvironment environment) {
    final incoming = _SdkIdentifier(environment.sdkIdentifier);
    final current = _SdkIdentifier(_environment.sdkIdentifier);
    final sdkIdentifier =
        incoming.precedence < current.precedence ? current : incoming;
    final osName = _environment.osName;
    return SystemEnvironment(
      sdkName: _sdkName,
      sdkIdentifier: sdkIdentifier,
      sdkVersion: PACKAGE_VERSION,
      appName: environment.appName,
      appVersion: environment.appVersion,
      osName: osName,
      osVersion: environment.osVersion,
      deviceModel: environment.deviceModel,
    );
  }
}

/// Extension on [SystemEnvironment] to build a Stream client header string.
extension XStreamClientHeaderExtension on SystemEnvironment {
  /// Builds a Stream client header string for API requests.
  ///
  /// The header follows the format:
  /// `{sdk}-{identifier}-v{version}
  /// |app={appName}
  /// |app_version={appVersion}
  /// |os={osName} {osVersion}
  /// |device_model={deviceModel}`
  ///
  /// Only non-null values are included in the header.
  String get xStreamClientHeader {
    final clientInfo = '$sdkName-$sdkIdentifier-v$sdkVersion';

    return [
      clientInfo,
      if (appName case final name?) 'app=$name',
      if (appVersion case final version?) 'app_version=$version',
      switch ((osName, osVersion)) {
        (final name?, final version?) => 'os=$name $version',
        (final name?, null) => 'os=$name',
        _ => null,
      },
      if (deviceModel case final model?) 'device_model=$model',
    ].nonNulls.join('|');
  }
}

/// Known SDK identifiers ranked by precedence. A proposed update is only
/// accepted when its precedence is greater than or equal to the current
/// identifier's, which makes the dart -> flutter transition one-way and
/// causes unknown identifiers to fall back to the current value.
extension type const _SdkIdentifier(String value) implements String {
  static const dart = _SdkIdentifier('dart');
  static const flutter = _SdkIdentifier('flutter');

  int get precedence => switch (this) {
        dart => 0,
        flutter => 1,
        _ => -1,
      };
}
