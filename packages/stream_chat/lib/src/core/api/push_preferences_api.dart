import 'dart:convert';

import '../http/stream_http_client.dart';
import '../models/push_preference.dart';
import 'responses.dart';

/// Defines the api dedicated to push preference operations
class PushPreferencesApi {
  /// Initialize a new push preferences api
  PushPreferencesApi(this._client);

  final StreamHttpClient _client;

  /// Set push preferences for the current user.
  ///
  /// This method allows you to configure push notification settings
  /// at both global and channel-specific levels.
  ///
  /// [preferences] - List of [PushPreferenceInput] to apply. Use the default
  /// constructor for user-level preferences or [PushPreferenceInput.channel]
  /// for channel-specific preferences.
  ///
  /// Returns [UpsertPushPreferencesResponse] with the updated preferences.
  ///
  /// Throws [ArgumentError] if preferences list is empty.
  Future<UpsertPushPreferencesResponse> setPushPreferences(
    List<PushPreferenceInput> preferences,
  ) async {
    if (preferences.isEmpty) {
      throw ArgumentError.value(
        preferences,
        'preferences',
        'Cannot be empty. At least one preference must be provided.',
      );
    }

    final response = await _client.post(
      '/push_preferences',
      data: jsonEncode({'preferences': preferences}),
    );
    return UpsertPushPreferencesResponse.fromJson(response.data);
  }
}
