import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:stream_chat/src/core/api/general_api.dart';
import 'package:stream_chat/src/core/models/app_settings.dart';

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
@internal
class AppSettingsManager {
  /// {@macro appSettingsManager}
  AppSettingsManager(this._api);

  final GeneralApi _api;
  late final _logger = Logger('AppSettingsManager');

  /// The cached [AppSettings].
  ///
  /// Returns a default instance until the first successful
  /// [loadAppSettings] or [refresh] call completes.
  AppSettings get appSettings => _appSettings ?? const AppSettings();
  AppSettings? _appSettings;

  /// Performs the initial load of [AppSettings].
  ///
  /// No-op when a cached value already exists. Errors are logged and
  /// suppressed so the caller is never blocked; use [refresh] when
  /// errors should propagate.
  Future<void> loadAppSettings() async {
    if (_appSettings != null) return;
    try {
      final response = await _api.getAppSettings();
      _appSettings = response.app;
    } catch (e, stk) {
      _logger.warning('Failed to load app settings', e, stk);
    }
  }

  /// Re-fetches and replaces the cached [AppSettings].
  ///
  /// Returns the newly fetched value, or throws when the request fails.
  Future<AppSettings> refresh() async {
    final response = await _api.getAppSettings();
    _appSettings = response.app;
    return response.app;
  }

  /// Clears the cached [AppSettings].
  ///
  /// The next call to [loadAppSettings] or [refresh] will fetch a fresh
  /// value.
  void clear() => _appSettings = null;
}
