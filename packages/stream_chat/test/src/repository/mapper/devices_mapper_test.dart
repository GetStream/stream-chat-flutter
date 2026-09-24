import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/core/models/device.dart';
import 'package:stream_chat/src/core/models/push_provider.dart';
import 'package:stream_chat/src/repository/mapper/devices_mapper.dart';
import 'package:test/test.dart';

void main() {
  test('DeviceResponse.toModel keeps the id and push provider of a fully populated response', () {
    final response = api.DeviceResponse(
      id: 'device-id',
      pushProvider: 'firebase',
      pushProviderName: 'staging',
      createdAt: DateTime.utc(2024),
      userId: 'user-id',
      disabled: true,
      disabledReason: 'expired',
      hardwareId: 'hardware-id',
      voip: false,
    );

    expect(response.toModel(), const Device(id: 'device-id', pushProvider: PushProvider.firebase));
  });

  test('ListDevicesResponse.toModel keeps the duration', () {
    const response = api.ListDevicesResponse(duration: '0.02ms', devices: []);

    expect(response.toModel().duration, '0.02ms');
  });

  test('ListDevicesResponse.toModel maps every device in order', () {
    final response = api.ListDevicesResponse(
      duration: '0.01ms',
      devices: [
        _deviceResponse(id: 'device-1', pushProvider: 'firebase'),
        _deviceResponse(id: 'device-2', pushProvider: 'apn'),
        _deviceResponse(id: 'device-3', pushProvider: 'huawei'),
      ],
    );

    expect(response.toModel().devices, const [
      Device(id: 'device-1', pushProvider: PushProvider.firebase),
      Device(id: 'device-2', pushProvider: PushProvider.apn),
      Device(id: 'device-3', pushProvider: PushProvider.huawei),
    ]);
  });

  test('PushProvider.toRequest carries the wire value of every provider, named or not', () {
    const providers = [
      PushProvider.firebase,
      PushProvider.huawei,
      PushProvider.xiaomi,
      PushProvider.apn,
      PushProvider('onesignal'),
    ];

    expect(
      [for (final provider in providers) provider.toRequest()],
      [
        api.CreateDeviceRequestPushProvider.firebase,
        api.CreateDeviceRequestPushProvider.huawei,
        api.CreateDeviceRequestPushProvider.xiaomi,
        api.CreateDeviceRequestPushProvider.apn,
        api.CreateDeviceRequestPushProvider.fromJson('onesignal'),
      ],
    );
  });
}

api.DeviceResponse _deviceResponse({required String id, required String pushProvider}) {
  return api.DeviceResponse(
    id: id,
    pushProvider: pushProvider,
    createdAt: DateTime.utc(2024),
    userId: 'user-id',
  );
}
