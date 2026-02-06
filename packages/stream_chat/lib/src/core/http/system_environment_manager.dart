// ignore_for_file: use_setters_to_change_properties

import 'package:stream_chat/src/core/platform_detector/platform_detector.dart';
import 'package:stream_chat/src/system_environment.dart';
import 'package:stream_chat/version.dart';

/// {@template systemEnvironmentManager}
/// A manager class to handle the current [SystemEnvironment].
/// {@endtemplate}
class SystemEnvironmentManager {
  /// {@macro systemEnvironmentManager}
  SystemEnvironmentManager({
    SystemEnvironment? environment,
  }) : _environment = switch (environment) {
         final env? => env,
         _ => SystemEnvironment(
           sdkName: 'stream-chat',
           sdkIdentifier: 'dart',
           sdkVersion: PACKAGE_VERSION,
           osName: CurrentPlatform.name,
         ),
       };

  /// Returns the Stream client user agent string based on the current
  /// [environment] value.
  String get userAgent => _environment.xStreamClientHeader;

  /// The current [SystemEnvironment].
  SystemEnvironment get environment => _environment;
  SystemEnvironment _environment;

  /// Updates the current [SystemEnvironment].
  void updateEnvironment(SystemEnvironment environment) {
    _environment = environment;
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
