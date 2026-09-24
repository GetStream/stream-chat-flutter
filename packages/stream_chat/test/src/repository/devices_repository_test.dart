import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/core/models/device.dart';
import 'package:stream_chat/src/repository/devices_repository.dart';
import 'package:stream_core/stream_core.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  test('addDevice forwards the id and provider without a name', () async {
    final defaultApi = MockDefaultApi();
    const request = api.CreateDeviceRequest(
      id: 'device-id',
      pushProvider: api.CreateDeviceRequestPushProvider.firebase,
    );
    _stubCreateDevice(defaultApi, request);

    await DevicesRepository(defaultApi).addDevice('device-id', PushProvider.firebase);

    verify(() => defaultApi.createDevice(createDeviceRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('addDevice forwards the provider name when given', () async {
    final defaultApi = MockDefaultApi();
    const request = api.CreateDeviceRequest(
      id: 'device-id',
      pushProvider: api.CreateDeviceRequestPushProvider.apn,
      pushProviderName: 'staging',
    );
    _stubCreateDevice(defaultApi, request);

    await DevicesRepository(defaultApi).addDevice('device-id', PushProvider.apn, pushProviderName: 'staging');

    verify(() => defaultApi.createDevice(createDeviceRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('addDevice sends an empty provider name as no name', () async {
    final defaultApi = MockDefaultApi();
    const request = api.CreateDeviceRequest(
      id: 'device-id',
      pushProvider: api.CreateDeviceRequestPushProvider.apn,
    );
    _stubCreateDevice(defaultApi, request);

    await DevicesRepository(defaultApi).addDevice('device-id', PushProvider.apn, pushProviderName: '');

    verify(() => defaultApi.createDevice(createDeviceRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('addDevice sends every provider under its wire value', () async {
    final defaultApi = MockDefaultApi();
    final repository = DevicesRepository(defaultApi);
    const wireValues = {
      PushProvider.apn: 'apn',
      PushProvider.firebase: 'firebase',
      PushProvider.huawei: 'huawei',
      PushProvider.xiaomi: 'xiaomi',
    };

    for (final MapEntry(key: provider, value: wireValue) in wireValues.entries) {
      final request = api.CreateDeviceRequest(
        id: 'device-id',
        pushProvider: api.CreateDeviceRequestPushProvider.fromJson(wireValue),
      );
      _stubCreateDevice(defaultApi, request);

      await repository.addDevice('device-id', provider);

      verify(() => defaultApi.createDevice(createDeviceRequest: request)).called(1);
    }
    verifyNoMoreInteractions(defaultApi);
  });

  test('addDevice answers the server duration', () async {
    final defaultApi = MockDefaultApi();
    const request = api.CreateDeviceRequest(
      id: 'device-id',
      pushProvider: api.CreateDeviceRequestPushProvider.firebase,
    );
    _stubCreateDevice(defaultApi, request, duration: '0.02ms');

    final res = await DevicesRepository(defaultApi).addDevice('device-id', PushProvider.firebase);

    expect(res.getOrNull()?.duration, '0.02ms');
  });

  test('addDevice returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    const error = StreamClientException(message: 'boom');
    const request = api.CreateDeviceRequest(
      id: 'device-id',
      pushProvider: api.CreateDeviceRequestPushProvider.firebase,
    );
    when(
      () => defaultApi.createDevice(createDeviceRequest: request),
    ).thenAnswer((_) async => const Result.failure(error));

    final res = await DevicesRepository(defaultApi).addDevice('device-id', PushProvider.firebase);

    expect(res.exceptionOrNull(), error);
  });

  test('getDevices maps every device the server sends to its id and push provider', () async {
    final defaultApi = MockDefaultApi();
    final generated = api.DeviceResponse(
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
    when(defaultApi.listDevices).thenAnswer(
      (_) async => Result.success(api.ListDevicesResponse(duration: '0.01ms', devices: [generated])),
    );

    final res = await DevicesRepository(defaultApi).getDevices();

    final device = res.getOrNull()!.devices.single;
    expect((device.id, device.pushProvider), ('device-id', 'firebase'));
  });

  test('getDevices answers the server duration', () async {
    final defaultApi = MockDefaultApi();
    when(defaultApi.listDevices).thenAnswer(
      (_) async => const Result.success(api.ListDevicesResponse(duration: '0.02ms', devices: [])),
    );

    final res = await DevicesRepository(defaultApi).getDevices();

    expect(res.getOrNull()?.duration, '0.02ms');
  });

  test('getDevices returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    const error = StreamClientException(message: 'boom');
    when(defaultApi.listDevices).thenAnswer((_) async => const Result.failure(error));

    final res = await DevicesRepository(defaultApi).getDevices();

    expect(res.exceptionOrNull(), error);
  });

  test('removeDevice forwards the id and answers the server duration', () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.deleteDevice(id: 'device-id')).thenAnswer(
      (_) async => const Result.success(api.DurationResponse(duration: '0.02ms')),
    );

    final res = await DevicesRepository(defaultApi).removeDevice('device-id');

    expect(res.getOrNull()?.duration, '0.02ms');
    verify(() => defaultApi.deleteDevice(id: 'device-id')).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('removeDevice returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    const error = StreamClientException(message: 'boom');
    when(() => defaultApi.deleteDevice(id: 'device-id')).thenAnswer((_) async => const Result.failure(error));

    final res = await DevicesRepository(defaultApi).removeDevice('device-id');

    expect(res.exceptionOrNull(), error);
  });
}

void _stubCreateDevice(MockDefaultApi defaultApi, api.CreateDeviceRequest request, {String duration = '0.01ms'}) {
  when(() => defaultApi.createDevice(createDeviceRequest: request)).thenAnswer(
    (_) async => Result.success(api.DurationResponse(duration: duration)),
  );
}
