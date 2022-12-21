import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/device_api.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

void main() {
  Response successResponse(String path, {Object? data}) => Response(
        data: data,
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
      );

  late final client = MockHttpClient();
  late DeviceApi deviceApi;

  setUp(() {
    deviceApi = DeviceApi(client);
  });

  test('addDevice should work', () async {
    const deviceId = 'test-device-id';
    const pushProvidersMap = {
      'apn': PushProvider.apn,
      'firebase': PushProvider.firebase,
      'huawei': PushProvider.huawei,
      'xiaomi': PushProvider.xiaomi,
    };
    const path = '/devices';

    for (final pushProviderMapEntry in pushProvidersMap.entries) {
      final data = {
        'id': deviceId,
        'push_provider': pushProviderMapEntry.key,
      };
      when(() {
        return client.post(
          path,
          data: data,
        );
      }).thenAnswer(
          (_) async => successResponse(path, data: <String, dynamic>{}));

      final res =
          await deviceApi.addDevice(deviceId, pushProviderMapEntry.value);

      expect(res, isNotNull);

      verify(() => client.post(path, data: data)).called(1);
    }
    verifyNoMoreInteractions(client);
    expect(pushProvidersMap.length, PushProvider.values.length,
        reason: 'All PushProvider should be tested');
  });

  test('addDevice should work with pushProviderName', () async {
    const deviceId = 'test-device-id';
    const pushProvider = PushProvider.firebase;
    const pushProviderName = 'my-custom-config';

    const path = '/devices';

    when(() => client.post(
              path,
              data: {
                'id': deviceId,
                'push_provider': pushProvider.name,
                'push_provider_name': pushProviderName,
              },
            ))
        .thenAnswer(
            (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await deviceApi.addDevice(
      deviceId,
      pushProvider,
      pushProviderName: pushProviderName,
    );

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('getDevices', () async {
    const path = '/devices';

    final devices = List.generate(
      3,
      (index) => Device(
        id: 'test-device-id-$index',
        pushProvider: PushProvider.firebase.name,
      ),
    );

    when(() => client.get(path)).thenAnswer(
      (_) async => successResponse(path, data: {
        'devices': [...devices.map((it) => it.toJson())]
      }),
    );

    final res = await deviceApi.getDevices();

    expect(res, isNotNull);
    expect(res.devices.length, devices.length);

    verify(() => client.get(path)).called(1);
    verifyNoMoreInteractions(client);
  });

  test('removeDevice', () async {
    const deviceId = 'test-device-id';

    const path = '/devices';

    when(
      () => client.delete(
        path,
        queryParameters: {'id': deviceId},
      ),
    ).thenAnswer((_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await deviceApi.removeDevice(deviceId);

    expect(res, isNotNull);

    verify(
      () => client.delete(path, queryParameters: any(named: 'queryParameters')),
    ).called(1);
    verifyNoMoreInteractions(client);
  });
}
