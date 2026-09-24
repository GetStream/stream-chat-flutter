import '../../../open_api/api.dart' as api;
import '../../core/models/device.dart';
import '../../core/models/responses/list_devices_response.dart';

/// Maps a generated [api.DeviceResponse] to a [Device].
extension DeviceResponseMapper on api.DeviceResponse {
  /// Converts this response into a [Device].
  Device toDomain() => Device(id: id, pushProvider: pushProvider);
}

/// Maps a generated [api.ListDevicesResponse] to a [ListDevicesResponse].
extension ListDevicesResponseMapper on api.ListDevicesResponse {
  /// Converts this response into a [ListDevicesResponse].
  ListDevicesResponse toDomain() => ListDevicesResponse(
    duration: duration,
    devices: [for (final device in devices) device.toDomain()],
  );
}

/// Maps a [PushProvider] to the generated request enum.
extension PushProviderMapper on PushProvider {
  /// Converts this provider into an [api.CreateDeviceRequestPushProvider].
  api.CreateDeviceRequestPushProvider toApi() => switch (this) {
    PushProvider.firebase => api.CreateDeviceRequestPushProvider.firebase,
    PushProvider.huawei => api.CreateDeviceRequestPushProvider.huawei,
    PushProvider.xiaomi => api.CreateDeviceRequestPushProvider.xiaomi,
    PushProvider.apn => api.CreateDeviceRequestPushProvider.apn,
  };
}
