/// {@template streamChatSystemEnvironment}
/// A class that represents the environment in which the Stream Chat SDK is
/// running.
///
/// This class provides information about the SDK, application, and device
/// used for tracking and debugging purposes.
/// {@endtemplate}
class SystemEnvironment {
  /// {@macro streamChatSystemEnvironment}
  const SystemEnvironment({
    required this.sdkName,
    required this.sdkIdentifier,
    required this.sdkVersion,
    this.appName,
    this.appVersion,
    this.osName,
    this.osVersion,
    this.deviceModel,
  });

  /// The name of the SDK.
  final String sdkName;

  /// The identifier of the SDK platform.
  ///
  /// This is used to distinguish between different implementations
  /// (e.g., 'dart', 'flutter', etc.).
  final String sdkIdentifier;

  /// The version of the SDK.
  final String sdkVersion;

  /// The name of the application.
  ///
  /// This is null by default and could be set by the application.
  final String? appName;

  /// The version of the application.
  ///
  /// This is null by default and could be set by the application.
  final String? appVersion;

  /// The name of the operating system.
  ///
  /// This is null by default and could be set by the application.
  final String? osName;

  /// The version of the operating system.
  ///
  /// This is null by default and could be set by the application.
  final String? osVersion;

  /// The device model information.
  ///
  /// This is null by default and could be set by the application.
  final String? deviceModel;

  /// Creates a copy of this [SystemEnvironment] with the given fields replaced
  /// with the new values.
  SystemEnvironment copyWith({
    String? sdkName,
    String? sdkIdentifier,
    String? sdkVersion,
    String? appName,
    String? appVersion,
    String? osName,
    String? osVersion,
    String? deviceModel,
  }) {
    return SystemEnvironment(
      sdkName: sdkName ?? this.sdkName,
      sdkIdentifier: sdkIdentifier ?? this.sdkIdentifier,
      sdkVersion: sdkVersion ?? this.sdkVersion,
      appName: appName ?? this.appName,
      appVersion: appVersion ?? this.appVersion,
      osName: osName ?? this.osName,
      osVersion: osVersion ?? this.osVersion,
      deviceModel: deviceModel ?? this.deviceModel,
    );
  }

  /// Merges this [SystemEnvironment] with the [other] one.
  SystemEnvironment merge(SystemEnvironment? other) {
    if (other == null) return this;
    return copyWith(
      sdkName: other.sdkName,
      sdkIdentifier: other.sdkIdentifier,
      sdkVersion: other.sdkVersion,
      appName: other.appName,
      appVersion: other.appVersion,
      osName: other.osName,
      osVersion: other.osVersion,
      deviceModel: other.deviceModel,
    );
  }
}
