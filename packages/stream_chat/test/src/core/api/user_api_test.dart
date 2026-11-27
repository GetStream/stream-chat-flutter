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

  test('queryUsers', () async {
    const presence = true;
    final filter = UserFilter.in_(UserFilterField.id, const ['test-id-1', 'test-id-2']);
    final sort = [UserSort.desc(UserSortField.custom('test-field'))];
    const pagination = PaginationParams();

    const path = '/users';

    final users = List.generate(3, (index) => User(id: 'test-user-id-$index'));

    when(
      () => client.get(
        path,
        queryParameters: {
          'payload': jsonEncode({
            'presence': presence,
            'sort': sort,
            'filter_conditions': filter,
            ...pagination.toJson(),
          }),
        },
      ),
    ).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'users': [...users.map((it) => it.toJson())],
        },
      ),
    );

    final res = await userApi.queryUsers(
      presence: presence,
      filter: filter,
      sort: sort,
      pagination: pagination,
    );

    expect(res, isNotNull);
    expect(res.users.length, users.length);

    verify(
      () => client.get(path, queryParameters: any(named: 'queryParameters')),
    ).called(1);
    verifyNoMoreInteractions(client);
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
