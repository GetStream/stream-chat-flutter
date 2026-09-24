import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/core/models/device.dart';
import 'package:stream_chat/src/core/models/list_devices_response.dart';
import 'package:stream_chat/src/core/models/push_provider.dart';
import 'package:stream_chat/src/repository/devices_repository.dart';
import 'package:stream_core/stream_core.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  test('DevicesRepository.addDevice forwards the id and provider without a name', () async {
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

  test('DevicesRepository.addDevice forwards the provider name when given', () async {
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

  test('DevicesRepository.addDevice sends an empty provider name as no name', () async {
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

  test('DevicesRepository.addDevice returns success when the server accepts the device', () async {
    final defaultApi = MockDefaultApi();
    const request = api.CreateDeviceRequest(
      id: 'device-id',
      pushProvider: api.CreateDeviceRequestPushProvider.firebase,
    );
    _stubCreateDevice(defaultApi, request);

    final res = await DevicesRepository(defaultApi).addDevice('device-id', PushProvider.firebase);

    expect(res.isSuccess, isTrue);
  });

  test('DevicesRepository.addDevice returns the failure without throwing', () async {
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

  test('DevicesRepository.getDevices returns the mapped response', () async {
    final defaultApi = MockDefaultApi();
    final device = api.DeviceResponse(
      id: 'device-id',
      pushProvider: 'firebase',
      createdAt: DateTime.utc(2024),
      userId: 'user-id',
    );
    when(defaultApi.listDevices).thenAnswer(
      (_) async => Result.success(api.ListDevicesResponse(duration: '0.02ms', devices: [device])),
    );

    final res = await DevicesRepository(defaultApi).getDevices();

    expect(
      res.getOrNull(),
      const ListDevicesResponse(
        duration: '0.02ms',
        devices: [Device(id: 'device-id', pushProvider: PushProvider.firebase)],
      ),
    );
  });

  test('DevicesRepository.getDevices returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    const error = StreamClientException(message: 'boom');
    when(defaultApi.listDevices).thenAnswer((_) async => const Result.failure(error));

    final res = await DevicesRepository(defaultApi).getDevices();

    expect(res.exceptionOrNull(), error);
  });

  test('DevicesRepository.removeDevice forwards the id', () async {
    final defaultApi = MockDefaultApi();
    _stubDeleteDevice(defaultApi, 'device-id');

    await DevicesRepository(defaultApi).removeDevice('device-id');

    verify(() => defaultApi.deleteDevice(id: 'device-id')).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('DevicesRepository.removeDevice returns success when the server removes the device', () async {
    final defaultApi = MockDefaultApi();
    _stubDeleteDevice(defaultApi, 'device-id');

    final res = await DevicesRepository(defaultApi).removeDevice('device-id');

    expect(res.isSuccess, isTrue);
  });

  test('DevicesRepository.removeDevice returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    const error = StreamClientException(message: 'boom');
    when(() => defaultApi.deleteDevice(id: 'device-id')).thenAnswer((_) async => const Result.failure(error));

    final res = await DevicesRepository(defaultApi).removeDevice('device-id');

    expect(res.exceptionOrNull(), error);
  });
}

void _stubCreateDevice(MockDefaultApi defaultApi, api.CreateDeviceRequest request) {
  when(() => defaultApi.createDevice(createDeviceRequest: request)).thenAnswer(
    (_) async => const Result.success(api.DurationResponse(duration: '0.01ms')),
  );
}

void _stubDeleteDevice(MockDefaultApi defaultApi, String id) {
  when(() => defaultApi.deleteDevice(id: id)).thenAnswer(
    (_) async => const Result.success(api.DurationResponse(duration: '0.01ms')),
  );
}
