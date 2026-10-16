import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:test/test.dart';

void main() {
  setUpAll(() => registerFallbackValue(RequestOptions()));

  test('DefaultApi.queryUsers sends the payload as one JSON query value', () async {
    final adapter = _adapterAnswering('{"duration":"1ms","users":[]}');
    final defaultApi = _defaultApi(adapter);

    await defaultApi.queryUsers(
      payload: const api.QueryUsersPayload(
        filterConditions: {'id': 'user-1'},
        sort: [api.SortParamRequest(field: 'name', direction: 1)],
      ),
    );

    final query = _lastRequest(adapter).uri.queryParametersAll;
    expect(query.keys, ['payload']);
    expect(query['payload'], hasLength(1));
    final payload = jsonDecode(query['payload']!.single) as Map<String, Object?>;
    expect(payload['filter_conditions'], {'id': 'user-1'});
    expect(payload['sort'], [allOf(containsPair('field', 'name'), containsPair('direction', 1))]);
  });

  test('DefaultApi.getReplies sends the sort as one JSON query value', () async {
    final adapter = _adapterAnswering('{"duration":"1ms","messages":[]}');
    final defaultApi = _defaultApi(adapter);

    await defaultApi.getReplies(
      parentId: 'parent-1',
      sort: const [api.SortParamRequest(field: 'created_at', direction: -1)],
    );

    final query = _lastRequest(adapter).uri.queryParametersAll;
    expect(query.keys, ['sort']);
    expect(jsonDecode(query['sort']!.single), [
      allOf(containsPair('field', 'created_at'), containsPair('direction', -1)),
    ]);
  });

  test('DefaultApi.getReplies sends plain query params as they are', () async {
    final adapter = _adapterAnswering('{"duration":"1ms","messages":[]}');
    final defaultApi = _defaultApi(adapter);

    await defaultApi.getReplies(parentId: 'parent-1', limit: 30, idLt: 'message-1');

    expect(_lastRequest(adapter).uri.queryParameters, {'limit': '30', 'id_lt': 'message-1'});
  });

  test('DefaultApi.queryUsers sends a local DateTime in the filter in UTC', () async {
    final adapter = _adapterAnswering('{"duration":"1ms","users":[]}');
    final defaultApi = _defaultApi(adapter);
    final createdAt = DateTime.utc(2026, 10, 14, 12, 30).toLocal();

    await defaultApi.queryUsers(
      payload: api.QueryUsersPayload(
        filterConditions: {
          'created_at': {r'$gt': createdAt},
        },
      ),
    );

    expect(_sentPayload(adapter)['filter_conditions'], {
      'created_at': {r'$gt': '2026-10-14T12:30:00.000Z'},
    });
  });

  test('DefaultApi.queryUsers sends a Set in the filter as a JSON list', () async {
    final adapter = _adapterAnswering('{"duration":"1ms","users":[]}');
    final defaultApi = _defaultApi(adapter);

    await defaultApi.queryUsers(
      payload: const api.QueryUsersPayload(
        filterConditions: {
          'id': {
            r'$in': {'user-1', 'user-2'},
          },
        },
      ),
    );

    expect(_sentPayload(adapter)['filter_conditions'], {
      'id': {
        r'$in': ['user-1', 'user-2'],
      },
    });
  });

  test('DefaultApi.queryUsers fails without sending a request for an enum it cannot encode', () async {
    final adapter = _adapterAnswering('{"duration":"1ms","users":[]}');
    final defaultApi = _defaultApi(adapter);

    final result = await defaultApi.queryUsers(
      payload: const api.QueryUsersPayload(filterConditions: {'role': _Role.admin}),
    );

    expect(result.isFailure, isTrue);
    verifyNever(() => adapter.fetch(any(), any(), any()));
  });

  test('DefaultApi.queryUsers fails without sending a request for a Duration in the filter', () async {
    final adapter = _adapterAnswering('{"duration":"1ms","users":[]}');
    final defaultApi = _defaultApi(adapter);

    final result = await defaultApi.queryUsers(
      payload: const api.QueryUsersPayload(filterConditions: {'timeout': Duration(minutes: 1)}),
    );

    expect(result.isFailure, isTrue);
    verifyNever(() => adapter.fetch(any(), any(), any()));
  });
}

// A hand-written enum, which has no `toJson()`.
enum _Role { admin }

api.DefaultApi _defaultApi(HttpClientAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://chat.example.com'))..httpClientAdapter = adapter;
  return api.DefaultApi(dio);
}

_MockHttpClientAdapter _adapterAnswering(String body) {
  final adapter = _MockHttpClientAdapter();
  when(() => adapter.fetch(any(), any(), any())).thenAnswer(
    (_) async => ResponseBody.fromString(body, 200, headers: _jsonHeaders),
  );
  return adapter;
}

RequestOptions _lastRequest(_MockHttpClientAdapter adapter) {
  final calls = verify(() => adapter.fetch(captureAny(), any(), any())).captured;
  return calls.last as RequestOptions;
}

// The JSON-decoded `payload` query value of the last request.
Map<String, dynamic> _sentPayload(_MockHttpClientAdapter adapter) {
  final payload = _lastRequest(adapter).uri.queryParameters['payload']!;
  return jsonDecode(payload) as Map<String, dynamic>;
}

const _jsonHeaders = {
  Headers.contentTypeHeader: [Headers.jsonContentType],
};

class _MockHttpClientAdapter extends Mock implements HttpClientAdapter {}
