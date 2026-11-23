import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/user_api.dart';
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
  late UserApi userApi;

  setUp(() {
    userApi = UserApi(client);
  });

  test('getActiveLiveLocations', () async {
    const path = '/users/live_locations';

    when(() => client.get(path)).thenAnswer(
      (_) async => successResponse(
        path,
        data: {'active_live_locations': []},
      ),
    );

    final res = await userApi.getActiveLiveLocations();

    expect(res, isNotNull);

    verify(() => client.get(path)).called(1);
    verifyNoMoreInteractions(client);
  });

  test('updateLiveLocation', () async {
    const path = '/users/live_locations';
    const messageId = 'test-message-id';
    const createdByDeviceId = 'test-device-id';
    final endAt = DateTime.timestamp().add(const Duration(hours: 1));
    const coordinates = LocationCoordinate(
      latitude: 40.7128,
      longitude: -74.0060,
    );

    when(
      () => client.put(
        path,
        data: json.encode({
          'message_id': messageId,
          'created_by_device_id': createdByDeviceId,
          'latitude': coordinates.latitude,
          'longitude': coordinates.longitude,
          'end_at': endAt.toIso8601String(),
        }),
      ),
    ).thenAnswer(
      (_) async => successResponse(
        path,
        data: <String, dynamic>{
          'message_id': messageId,
          'created_by_device_id': createdByDeviceId,
          'latitude': coordinates.latitude,
          'longitude': coordinates.longitude,
          'end_at': endAt.toIso8601String(),
        },
      ),
    );

    final res = await userApi.updateLiveLocation(
      messageId: messageId,
      createdByDeviceId: createdByDeviceId,
      location: coordinates,
      endAt: endAt,
    );

    expect(res, isNotNull);

    verify(
      () => client.put(
        path,
        data: json.encode({
          'message_id': messageId,
          'created_by_device_id': createdByDeviceId,
          'latitude': coordinates.latitude,
          'longitude': coordinates.longitude,
          'end_at': endAt.toIso8601String(),
        }),
      ),
    ).called(1);
    verifyNoMoreInteractions(client);
  });
}
