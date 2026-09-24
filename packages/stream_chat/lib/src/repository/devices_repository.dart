import 'package:stream_core/stream_core.dart' show PatternMatching, Result;

import '../../open_api/api.dart' as api;
import '../core/models/device.dart';
import '../core/models/responses/list_devices_response.dart';
import 'mapper/devices_mapper.dart';

/// Repository dedicated to device operations.
class DevicesRepository {
  /// Initialize a new devices repository.
  const DevicesRepository(this._api);

  final api.DefaultApi _api;

  /// Registers a device to receive push notifications.
  ///
  /// [id] is the token the push provider issued for this device.
  ///
  /// [pushProviderName] names which of the app's configurations for
  /// [pushProvider] to use, for apps that have more than one.
  Future<Result<void>> addDevice(
    String id,
    PushProvider pushProvider, {
    String? pushProviderName,
  }) async {
    final result = await _api.createDevice(
      createDeviceRequest: api.CreateDeviceRequest(
        id: id,
        pushProvider: pushProvider.toRequest(),
        pushProviderName: switch (pushProviderName) {
          final name? when name.isNotEmpty => name,
          _ => null,
        },
      ),
    );

    return result.map((_) {});
  }

  /// Lists the devices registered for the current user.
  Future<Result<ListDevicesResponse>> getDevices() async {
    final result = await _api.listDevices();
    return result.map((response) => response.toModel());
  }

  /// Removes a registered device, stopping push notifications to it.
  Future<Result<void>> removeDevice(String id) async {
    final result = await _api.deleteDevice(id: id);
    return result.map((_) {});
  }
}
