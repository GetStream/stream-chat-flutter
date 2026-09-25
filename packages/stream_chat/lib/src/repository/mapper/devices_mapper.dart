import '../../../open_api/api.dart' as api;
import '../../core/models/device.dart';
import '../../core/models/push_provider.dart';
import '../../core/models/response/list_devices_response.dart';

/// Maps a generated [api.DeviceResponse] to a [Device].
extension DeviceResponseMapper on api.DeviceResponse {
  /// Converts this response into a [Device].
  Device toModel() => Device(id: id, pushProvider: PushProvider(pushProvider));
}

/// Maps a generated [api.ListDevicesResponse] to a [ListDevicesResponse].
extension ListDevicesResponseMapper on api.ListDevicesResponse {
  /// Converts this response into a [ListDevicesResponse].
  ListDevicesResponse toModel() => ListDevicesResponse(
    duration: duration,
    devices: [for (final device in devices) device.toModel()],
  );
}

/// Maps a [PushProvider] to the generated request enum.
extension PushProviderMapper on PushProvider {
  /// Converts this provider into an [api.CreateDeviceRequestPushProvider].
  api.CreateDeviceRequestPushProvider toRequest() => api.CreateDeviceRequestPushProvider.fromJson(rawType);
}
