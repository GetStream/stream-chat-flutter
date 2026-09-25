import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_settings.dart';

part 'get_app_settings_response.freezed.dart';

/// The settings of the application, returned by [StreamChatClient.getAppSettings].
@freezed
class GetAppSettingsResponse with _$GetAppSettingsResponse {
  /// Creates a new [GetAppSettingsResponse].
  const GetAppSettingsResponse({
    required this.duration,
    required this.app,
  });

  /// How long the server took to handle the request, such as `4.21ms`.
  @override
  final String duration;

  /// The settings configured for the application.
  @override
  final AppSettings app;
}
