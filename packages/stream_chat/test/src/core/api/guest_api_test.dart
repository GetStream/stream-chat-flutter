import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/guest_api.dart';
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
  late GuestApi guestApi;

  setUp(() {
    guestApi = GuestApi(client);
  });

  test('getGuestUser', () async {
    const accessToken = 'test-guest-token';
    final user = User(id: 'test-user-id');

    const path = '/guest';

    when(() => client.post(path, data: any(named: 'data')))
        .thenAnswer((_) async => successResponse(path, data: {
              'access_token': accessToken,
              'user': user.toJson(),
            }));

    final res = await guestApi.getGuestUser(user);

    expect(res, isNotNull);
    expect(res.accessToken, accessToken);
    expect(res.user.id, user.id);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });
}
