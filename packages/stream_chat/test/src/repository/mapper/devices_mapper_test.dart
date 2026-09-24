import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/core/models/device.dart';
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

    final device = response.toModel();

    expect((device.id, device.pushProvider), ('device-id', 'firebase'));
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

    final devices = response.toModel().devices;

    expect(devices.map((it) => (it.id, it.pushProvider)), [
      ('device-1', 'firebase'),
      ('device-2', 'apn'),
      ('device-3', 'huawei'),
    ]);
  });

  test('PushProvider.toRequest maps every provider to the generated value with the same wire name', () {
    final requests = {for (final provider in PushProvider.values) provider: provider.toRequest()};

    expect(requests, {
      for (final provider in PushProvider.values) provider: api.CreateDeviceRequestPushProvider.fromJson(provider.name),
    });
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
