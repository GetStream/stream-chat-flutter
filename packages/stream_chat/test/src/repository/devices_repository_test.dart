import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart';
import 'package:stream_chat/src/repository/devices_repository.dart';
import 'package:stream_core/stream_core.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  late MockDefaultApi api;
  late DevicesRepository repository;

  setUp(() {
    api = MockDefaultApi();
    repository = DevicesRepository(api);
  });

  test('addDevice forwards the id and provider when no name is given', () async {
    const request = CreateDeviceRequest(
      id: 'device-id',
      pushProvider: CreateDeviceRequestPushProvider.firebase,
    );

    when(() => api.createDevice(createDeviceRequest: request)).thenAnswer(
      (_) async => const Result.success(DurationResponse(duration: '0.01ms')),
    );

    final res = await repository.addDevice(
      'device-id',
      CreateDeviceRequestPushProvider.firebase,
    );

    expect(res.isSuccess, isTrue);
    verify(() => api.createDevice(createDeviceRequest: request)).called(1);
    verifyNoMoreInteractions(api);
  });

  test('addDevice forwards the provider name when given', () async {
    const request = CreateDeviceRequest(
      id: 'device-id',
      pushProvider: CreateDeviceRequestPushProvider.apn,
      pushProviderName: 'staging',
    );

    when(() => api.createDevice(createDeviceRequest: request)).thenAnswer(
      (_) async => const Result.success(DurationResponse(duration: '0.01ms')),
    );

    await repository.addDevice(
      'device-id',
      CreateDeviceRequestPushProvider.apn,
      pushProviderName: 'staging',
    );

    verify(() => api.createDevice(createDeviceRequest: request)).called(1);
    verifyNoMoreInteractions(api);
  });

  test('addDevice sends an empty provider name as no name', () async {
    const request = CreateDeviceRequest(
      id: 'device-id',
      pushProvider: CreateDeviceRequestPushProvider.apn,
    );

    when(() => api.createDevice(createDeviceRequest: request)).thenAnswer(
      (_) async => const Result.success(DurationResponse(duration: '0.01ms')),
    );

    await repository.addDevice(
      'device-id',
      CreateDeviceRequestPushProvider.apn,
      pushProviderName: '',
    );

    verify(() => api.createDevice(createDeviceRequest: request)).called(1);
    verifyNoMoreInteractions(api);
  });

  test('addDevice sends every provider under its wire value', () async {
    const providers = {
      CreateDeviceRequestPushProvider.apn: 'apn',
      CreateDeviceRequestPushProvider.firebase: 'firebase',
      CreateDeviceRequestPushProvider.huawei: 'huawei',
      CreateDeviceRequestPushProvider.xiaomi: 'xiaomi',
    };

    for (final MapEntry(key: provider, value: wireValue) in providers.entries) {
      final request = CreateDeviceRequest(id: 'device-id', pushProvider: provider);

      when(() => api.createDevice(createDeviceRequest: request)).thenAnswer(
        (_) async => const Result.success(DurationResponse(duration: '0.01ms')),
      );

      await repository.addDevice('device-id', provider);

      expect(provider, wireValue);
      verify(() => api.createDevice(createDeviceRequest: request)).called(1);
    }

    verifyNoMoreInteractions(api);
  });

  test('addDevice returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    const request = CreateDeviceRequest(
      id: 'device-id',
      pushProvider: CreateDeviceRequestPushProvider.firebase,
    );

    when(() => api.createDevice(createDeviceRequest: request)).thenAnswer(
      (_) async => const Result.failure(error),
    );

    final res = await repository.addDevice(
      'device-id',
      CreateDeviceRequestPushProvider.firebase,
    );

    expect(res.isFailure, isTrue);
    expect(res.exceptionOrNull(), error);
  });

  test('getDevices passes the response through untouched', () async {
    final device = DeviceResponse(
      id: 'device-id',
      pushProvider: 'firebase',
      createdAt: DateTime.utc(2024),
      userId: 'user-id',
    );

    when(api.listDevices).thenAnswer(
      (_) async => Result.success(ListDevicesResponse(duration: '0.01ms', devices: [device])),
    );

    final res = await repository.getDevices();

    expect(res.getOrNull()?.devices.single, device);
    verify(api.listDevices).called(1);
    verifyNoMoreInteractions(api);
  });

  test('getDevices returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    when(api.listDevices).thenAnswer((_) async => const Result.failure(error));

    final res = await repository.getDevices();

    expect(res.isFailure, isTrue);
    expect(res.exceptionOrNull(), error);
  });

  test('removeDevice forwards the id', () async {
    when(() => api.deleteDevice(id: 'device-id')).thenAnswer(
      (_) async => const Result.success(DurationResponse(duration: '0.01ms')),
    );

    final res = await repository.removeDevice('device-id');

    expect(res.isSuccess, isTrue);
    verify(() => api.deleteDevice(id: 'device-id')).called(1);
    verifyNoMoreInteractions(api);
  });

  test('removeDevice returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    when(() => api.deleteDevice(id: 'device-id')).thenAnswer((_) async => const Result.failure(error));

    final res = await repository.removeDevice('device-id');

    expect(res.isFailure, isTrue);
    expect(res.exceptionOrNull(), error);
  });
}
