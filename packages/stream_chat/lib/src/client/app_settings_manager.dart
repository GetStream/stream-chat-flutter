import 'package:stream_core/stream_core.dart' show Failure, Result, StreamLogger, Success;

import '../core/models/app_settings.dart';
import '../core/models/response/get_app_settings_response.dart';
import '../repository/app_settings_repository.dart';

/// {@template appSettingsManager}
/// Holds the [AppSettings] for the current connection.
///
/// The first call to [loadAppSettings] populates the cache; subsequent
/// reads through [appSettings] return the cached value. Use [refresh] to
/// re-fetch on demand, and [clear] to drop the cache.
///
/// See also:
///
///  * [StreamChatClient.appSettings], for the public entry point.
/// {@endtemplate}
class AppSettingsManager {
  /// {@macro appSettingsManager}
  AppSettingsManager(
    this._repository, {
    String tag = 'SCh:AppSettings',
  }) : _logger = StreamLogger(tag);

  final AppSettingsRepository _repository;
  final StreamLogger _logger;

  /// The cached [AppSettings].
  ///
  /// Returns a default instance until the first successful
  /// [loadAppSettings] or [refresh] call completes.
  AppSettings get appSettings => _appSettings ?? const AppSettings();
  AppSettings? _appSettings;

  /// Performs the initial load of [AppSettings].
  ///
  /// No-op when a cached value already exists. Failures are logged and
  /// suppressed so the caller is never blocked; use [refresh] when a
  /// failure should reach the caller.
  Future<void> loadAppSettings() async {
    if (_appSettings != null) return;

    switch (await _repository.getAppSettings()) {
      case Success(:final data):
        _appSettings = data.app;
      case Failure(:final error, :final stackTrace):
        _logger.w(() => 'Failed to load app settings', error: error, stackTrace: stackTrace);
    }
  }

  /// Re-fetches the [AppSettings] and replaces the cached value.
  ///
  /// The cached value is replaced only on success, so a failed refresh
  /// leaves it as it was.
  Future<Result<GetAppSettingsResponse>> refresh() async {
    final result = await _repository.getAppSettings();
    if (result case Success(:final data)) _appSettings = data.app;
    return result;
  }

  /// Clears the cached [AppSettings].
  ///
  /// The next call to [loadAppSettings] or [refresh] will fetch a fresh
  /// value.
  void clear() => _appSettings = null;
}
