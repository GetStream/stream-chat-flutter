import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';

/// Provider used to send push notifications.
enum PushProvider {
  /// Send notifications using Google's Firebase Cloud Messaging
  firebase,

  /// Send notifications using Apple's Push Notification service
  apn,
}

/// Defines the api dedicated to device operations
class DeviceApi {
  /// Initialize a new device api
  DeviceApi(this._client);

  final StreamHttpClient _client;

  /// Add a device for Push Notifications.
  Future<EmptyResponse> addDevice(
    String deviceId,
    PushProvider pushProvider, {
    String? pushProviderName,
  }) async {
    final response = await _client.post(
      '/devices',
      data: {
        'id': deviceId,
        'push_provider': pushProvider.name,
        if (pushProviderName != null && pushProviderName.isNotEmpty)
          'push_provider_name': pushProviderName,
      },
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Gets a list of user devices.
  Future<ListDevicesResponse> getDevices() async {
    final response = await _client.get('/devices');
    return ListDevicesResponse.fromJson(response.data);
  }

  /// Remove a user's device.
  Future<EmptyResponse> removeDevice(
    String deviceId,
  ) async {
    final response = await _client.delete(
      '/devices',
      queryParameters: {'id': deviceId},
    );
    return EmptyResponse.fromJson(response.data);
  }
}
