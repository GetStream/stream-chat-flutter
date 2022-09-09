import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/call_api.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

void main() {
  Response successResponse(String path, {Object? data}) => Response(
        data: data,
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
      );

  late final client = MockHttpClient();
  late CallApi callApi;

  setUp(() {
    callApi = CallApi(client);
  });

  test('getCallToken should work', () async {
    const callId = 'test-call-id';
    const path = '/calls/$callId';

    when(() => client.post(path, data: {})).thenAnswer(
        (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await callApi.getCallToken(callId);

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('createCall should work', () async {
    const callId = 'test-call-id';
    const callType = 'test-call-type';
    const channelType = 'test-channel-type';
    const channelId = 'test-channel-id';
    const path = '/channels/$channelType/$channelId/call';

    when(() => client.post(
              path,
              data: {
                'id': callId,
                'type': callType,
              },
            ))
        .thenAnswer(
            (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await callApi.createCall(
      callId: callId,
      callType: callType,
      channelType: channelType,
      channelId: channelId,
    );

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });
}
