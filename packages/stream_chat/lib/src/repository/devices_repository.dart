import 'package:stream_core/stream_core.dart' show Result;

import '../../open_api/api.dart' show DefaultApi;
import '../../open_api/models.dart'
    show CreateDeviceRequest, CreateDeviceRequestPushProvider, DurationResponse, ListDevicesResponse;

/// Repository dedicated to device operations.
class DevicesRepository {
  /// Initialize a new devices repository.
  const DevicesRepository(this._api);

  final DefaultApi _api;

  /// Registers a device to receive push notifications.
  ///
  /// [id] is the token the push provider issued for this device.
  ///
  /// [pushProviderName] names which of the app's configurations for
  /// [pushProvider] to use, for apps that have more than one.
  Future<Result<DurationResponse>> addDevice(
    String id,
    CreateDeviceRequestPushProvider pushProvider, {
    String? pushProviderName,
  }) => _api.createDevice(
    createDeviceRequest: CreateDeviceRequest(
      id: id,
      pushProvider: pushProvider,
      // An empty name is sent as no name, as it always has been: no provider
      // is configured under the empty string, so it is a lookup key the
      // server can only reject.
      pushProviderName: switch (pushProviderName) {
        final name? when name.isNotEmpty => name,
        _ => null,
      },
    ),
  );

  /// Lists the devices registered for the current user.
  Future<Result<ListDevicesResponse>> getDevices() => _api.listDevices();

  /// Removes a registered device, stopping push notifications to it.
  Future<Result<DurationResponse>> removeDevice(String id) => _api.deleteDevice(id: id);
}
