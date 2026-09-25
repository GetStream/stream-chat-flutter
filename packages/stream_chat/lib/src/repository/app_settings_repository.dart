import 'package:stream_core/stream_core.dart' show PatternMatching, Result;

import '../../open_api/api.dart' as api;
import '../core/models/get_app_settings_response.dart';
import 'mapper/app_settings_mapper.dart';

/// Repository dedicated to application settings operations.
class AppSettingsRepository {
  /// Initialize a new app settings repository.
  const AppSettingsRepository(this._api);

  final api.DefaultApi _api;

  /// Fetches the settings configured for the application.
  Future<Result<GetAppSettingsResponse>> getAppSettings() async {
    final result = await _api.getApp();

    return result.map((response) => response.toModel());
  }
}
