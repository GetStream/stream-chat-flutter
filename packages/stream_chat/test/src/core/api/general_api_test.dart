import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/general_api.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

void main() {
  Response successResponse(String path, {Object? data}) => Response(
    data: data,
    requestOptions: RequestOptions(path: path),
    statusCode: 200,
  );

  late final client = MockHttpClient();
  late GeneralApi generalApi;

  setUp(() {
    generalApi = GeneralApi(client);
  });

  test('sync', () async {
    const cids = ['test-cid-1', 'test-cid-2', 'test-cid-3'];
    final lastSyncAt = DateTime.now();

    const path = '/sync';

    final events = [
      for (var index = 0; index < 3; index++) {'type': 'test-event-type-$index'},
    ];

    final data = {
      'channel_cids': cids,
      'last_sync_at': lastSyncAt.toUtc().toIso8601String(),
    };

    when(
      () => client.post(
        path,
        data: data,
      ),
    ).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'events': events,
        },
      ),
    );

    final res = await generalApi.sync(cids, lastSyncAt);

    expect(res, isNotNull);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });
}
