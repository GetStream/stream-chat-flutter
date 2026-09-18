import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/http/connection_id_manager.dart';
import 'package:stream_chat/src/core/http/interceptor/additional_headers_interceptor.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_core/stream_core.dart'
    show
        ApiErrorInterceptor,
        AuthInterceptor,
        ConnectionIdInterceptor,
        HeadersInterceptor,
        LoggingInterceptor,
        StreamApiException,
        StreamDioException,
        StreamErrorCode,
        StreamLogHandler,
        StreamLogPriority,
        StreamLogRecord,
        StreamLogger,
        StreamNetworkException,
        SystemEnvironment,
        SystemEnvironmentManager,
        TokenManager;
import 'package:test/test.dart';

import '../../mocks.dart';
import '../../utils.dart';

void main() {
  Response successResponse(String path) => Response(
    requestOptions: RequestOptions(path: path),
    statusCode: 200,
  );

  DioException throwableError(
    String path, {
    StreamApiException? error,
    bool streamChatDioError = false,
  }) {
    if (streamChatDioError) assert(error != null, '');
    final options = RequestOptions(path: path);
    if (streamChatDioError) {
      // A rejection raised inside the pipeline, already classified.
      return StreamDioException(exception: error!, requestOptions: options);
    }

    // A real answer from the server, carrying an error payload to decode.
    final data = ErrorResponse()
      ..code = error?.code
      ..statusCode = error?.statusCode
      ..message = error?.message;
    return DioException(
      requestOptions: options,
      response: Response(
        requestOptions: options,
        statusCode: data.statusCode,
        data: data.toJson(),
      ),
    );
  }

  test('UserAgentInterceptor should be added', () {
    const apiKey = 'api-key';
    final client = StreamHttpClient(apiKey);

    expect(client.httpClient.interceptors.whereType<AdditionalHeadersInterceptor>().length, 1);
  });

  // Order is behaviour, not style: `ApiErrorInterceptor` only maps what reaches
  // it, so anything that rejects ahead of it escapes as a raw `DioException`,
  // and anything logging ahead of it logs the transport error rather than the
  // mapped one. A misordered pipeline still works until something fails, which
  // is why it is pinned here rather than left to read correctly.
  test('interceptors are installed in the order the pipeline depends on', () {
    final client = StreamHttpClient(
      'api-key',
      tokenManager: TokenManager.unconfigured(),
      connectionIdManager: ConnectionIdManager(),
      systemEnvironmentManager: SystemEnvironmentManager(
        environment: const SystemEnvironment(
          sdkName: 'stream-chat',
          sdkIdentifier: 'dart',
          sdkVersion: '0.0.0',
        ),
      ),
    );

    expect(
      client.httpClient.interceptors.map((it) => it.runtimeType),
      containsAllInOrder([
        AdditionalHeadersInterceptor,
        HeadersInterceptor,
        AuthInterceptor,
        ConnectionIdInterceptor,
        ApiErrorInterceptor,
        LoggingInterceptor,
      ]),
    );
  });

  test('AuthInterceptor should be added if tokenManager is provided', () {
    const apiKey = 'api-key';
    final client = StreamHttpClient(apiKey, tokenManager: TokenManager.unconfigured());

    expect(client.httpClient.interceptors.whereType<AuthInterceptor>().length, 1);
  });

  test(
    '''connectionIdInterceptor should be added if connectionIdManager is provided''',
    () {
      const apiKey = 'api-key';
      final client = StreamHttpClient(
        apiKey,
        connectionIdManager: ConnectionIdManager(),
      );

      expect(
        client.httpClient.interceptors.whereType<ConnectionIdInterceptor>().length,
        1,
      );
    },
  );

  group('loggingInterceptor', () {
    test('is added by default', () {
      final client = StreamHttpClient('api-key');

      expect(client.httpClient.interceptors.whereType<LoggingInterceptor>().length, 1);
    });

    test('is not added if `interceptors` are provided', () {
      final client = StreamHttpClient(
        'api-key',
        interceptors: [
          // Sample Interceptor.
          InterceptorsWrapper(),
        ],
      );

      expect(client.httpClient.interceptors.whereType<LoggingInterceptor>().length, 0);
    });

    test('writes what it logs to the configured handler', () async {
      final records = <StreamLogRecord>[];
      StreamLogger.handler = _CapturingHandler(records.add);
      StreamLogger.priority = StreamLogPriority.verbose;
      addTearDown(StreamLogger.reset);

      final client = StreamHttpClient('api-key');

      try {
        await client.get('path');
      } catch (_) {}

      // The request is logged, and so is the failure to reach the server.
      expect(records.map((it) => it.tag), everyElement('SCh:Http'));
      expect(records.any((it) => it.priority == StreamLogPriority.debug), isTrue);
      expect(records.any((it) => it.priority == StreamLogPriority.warning), isTrue);
    });
  });

  test('`.close` should close the dio client', () async {
    final client = StreamHttpClient('api-key')..close(force: true);

    // A closed client never reaches the server, so the request fails without
    // a verdict.
    await expectLater(
      client.get('path'),
      throwsA(
        isA<StreamNetworkException>().having(
          (it) => it.message,
          'message',
          contains("Dio can't establish a new connection after it was closed"),
        ),
      ),
    );
  });

  test('`.get` should return response successfully', () async {
    final dio = MockDio();
    final client = StreamHttpClient('api-key', dio: dio);

    const path = 'test-get-api-path';
    when(
      () => dio.get(
        path,
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => successResponse(path));

    final res = await client.get(path);

    expect(res, isNotNull);
    expect(res.statusCode, 200);
    expect(res.requestOptions.path, path);

    verify(
      () => dio.get(
        path,
        options: any(named: 'options'),
      ),
    ).called(1);
    verifyNoMoreInteractions(dio);
  });

  test('`.get` should throw an instance of `StreamApiException`', () async {
    final dio = MockDio();
    final client = StreamHttpClient('api-key', dio: dio);

    const path = 'test-get-api-path';
    final error = throwableError(
      path,
      error: apiException(code: StreamErrorCode.internalError, statusCode: 500),
    );
    when(
      () => dio.get(
        path,
        options: any(named: 'options'),
      ),
    ).thenThrow(error);

    // Matched on the facts the mapper read off the response rather than on
    // object identity: the exception also carries the DioException as its
    // cause, which equality would compare.
    await expectLater(
      client.get(path),
      throwsA(
        isA<StreamApiException>()
            .having((it) => it.statusCode, 'statusCode', 500)
            .having((it) => it.code, 'code', StreamErrorCode.internalError),
      ),
    );

    verify(
      () => dio.get(
        path,
        options: any(named: 'options'),
      ),
    ).called(1);
    verifyNoMoreInteractions(dio);
  });

  test('`.post` should return response successfully', () async {
    final dio = MockDio();
    final client = StreamHttpClient('api-key', dio: dio);

    const path = 'test-post-api-path';
    when(
      () => dio.post(
        path,
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => successResponse(path));

    final res = await client.post(path);

    expect(res, isNotNull);
    expect(res.statusCode, 200);
    expect(res.requestOptions.path, path);

    verify(
      () => dio.post(
        path,
        options: any(named: 'options'),
      ),
    ).called(1);
    verifyNoMoreInteractions(dio);
  });

  test(
    '`.post` should throw an instance of `StreamApiException`',
    () async {
      final dio = MockDio();
      final client = StreamHttpClient('api-key', dio: dio);

      const path = 'test-post-api-path';
      final error = throwableError(
        path,
        error: apiException(code: StreamErrorCode.internalError, statusCode: 500),
      );
      when(
        () => dio.post(
          path,
          options: any(named: 'options'),
        ),
      ).thenThrow(error);

      await expectLater(
        client.post(path),
        throwsA(
          isA<StreamApiException>()
              .having((it) => it.statusCode, 'statusCode', 500)
              .having((it) => it.code, 'code', StreamErrorCode.internalError),
        ),
      );

      verify(
        () => dio.post(
          path,
          options: any(named: 'options'),
        ),
      ).called(1);
      verifyNoMoreInteractions(dio);
    },
  );

  test('`.delete` should return response successfully', () async {
    final dio = MockDio();
    final client = StreamHttpClient('api-key', dio: dio);

    const path = 'test-delete-api-path';
    when(
      () => dio.delete(
        path,
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => successResponse(path));

    final res = await client.delete(path);

    expect(res, isNotNull);
    expect(res.statusCode, 200);
    expect(res.requestOptions.path, path);

    verify(
      () => dio.delete(
        path,
        options: any(named: 'options'),
      ),
    ).called(1);
    verifyNoMoreInteractions(dio);
  });

  test(
    '`.delete` should throw an instance of `StreamApiException`',
    () async {
      final dio = MockDio();
      final client = StreamHttpClient('api-key', dio: dio);

      const path = 'test-delete-api-path';
      final error = throwableError(
        path,
        error: apiException(code: StreamErrorCode.internalError, statusCode: 500),
      );
      when(
        () => dio.delete(
          path,
          options: any(named: 'options'),
        ),
      ).thenThrow(error);

      await expectLater(
        client.delete(path),
        throwsA(
          isA<StreamApiException>()
              .having((it) => it.statusCode, 'statusCode', 500)
              .having((it) => it.code, 'code', StreamErrorCode.internalError),
        ),
      );

      verify(
        () => dio.delete(
          path,
          options: any(named: 'options'),
        ),
      ).called(1);
      verifyNoMoreInteractions(dio);
    },
  );

  test('`.patch` should return response successfully', () async {
    final dio = MockDio();
    final client = StreamHttpClient('api-key', dio: dio);

    const path = 'test-patch-api-path';
    when(
      () => dio.patch(
        path,
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => successResponse(path));

    final res = await client.patch(path);

    expect(res, isNotNull);
    expect(res.statusCode, 200);
    expect(res.requestOptions.path, path);

    verify(
      () => dio.patch(
        path,
        options: any(named: 'options'),
      ),
    ).called(1);
    verifyNoMoreInteractions(dio);
  });

  test(
    '`.patch` should throw an instance of `StreamApiException`',
    () async {
      final dio = MockDio();
      final client = StreamHttpClient('api-key', dio: dio);

      const path = 'test-patch-api-path';
      final error = throwableError(
        path,
        error: apiException(code: StreamErrorCode.internalError, statusCode: 500),
      );
      when(
        () => dio.patch(
          path,
          options: any(named: 'options'),
        ),
      ).thenThrow(error);

      await expectLater(
        client.patch(path),
        throwsA(
          isA<StreamApiException>()
              .having((it) => it.statusCode, 'statusCode', 500)
              .having((it) => it.code, 'code', StreamErrorCode.internalError),
        ),
      );

      verify(
        () => dio.patch(
          path,
          options: any(named: 'options'),
        ),
      ).called(1);
      verifyNoMoreInteractions(dio);
    },
  );

  test('`.put` should return response successfully', () async {
    final dio = MockDio();
    final client = StreamHttpClient('api-key', dio: dio);

    const path = 'test-put-api-path';
    when(
      () => dio.put(
        path,
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => successResponse(path));

    final res = await client.put(path);

    expect(res, isNotNull);
    expect(res.statusCode, 200);
    expect(res.requestOptions.path, path);

    verify(
      () => dio.put(
        path,
        options: any(named: 'options'),
      ),
    ).called(1);
    verifyNoMoreInteractions(dio);
  });

  test(
    '`.put` should throw an instance of `StreamApiException`',
    () async {
      final dio = MockDio();
      final client = StreamHttpClient('api-key', dio: dio);

      const path = 'test-put-api-path';
      final error = throwableError(
        path,
        error: apiException(code: StreamErrorCode.internalError, statusCode: 500),
      );
      when(
        () => dio.put(
          path,
          options: any(named: 'options'),
        ),
      ).thenThrow(error);

      await expectLater(
        client.put(path),
        throwsA(
          isA<StreamApiException>()
              .having((it) => it.statusCode, 'statusCode', 500)
              .having((it) => it.code, 'code', StreamErrorCode.internalError),
        ),
      );

      verify(
        () => dio.put(
          path,
          options: any(named: 'options'),
        ),
      ).called(1);
      verifyNoMoreInteractions(dio);
    },
  );

  test('`.postFile` should return response successfully', () async {
    final dio = MockDio();
    final client = StreamHttpClient('api-key', dio: dio);

    const path = 'test-delete-api-path';
    final file = MultipartFile.fromBytes([]);

    when(
      () => dio.post(
        path,
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => successResponse(path));

    final res = await client.postFile(path, file);

    expect(res, isNotNull);
    expect(res.statusCode, 200);
    expect(res.requestOptions.path, path);

    verify(
      () => dio.post(
        path,
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).called(1);
    verifyNoMoreInteractions(dio);
  });

  test(
    '`.postFile` should throw an instance of `StreamApiException`',
    () async {
      final dio = MockDio();
      final client = StreamHttpClient('api-key', dio: dio);

      const path = 'test-post-file-api-path';
      final file = MultipartFile.fromBytes([]);

      final error = throwableError(
        path,
        error: apiException(code: StreamErrorCode.internalError, statusCode: 500),
      );
      when(
        () => dio.post(
          path,
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(error);

      await expectLater(
        client.postFile(path, file),
        throwsA(
          isA<StreamApiException>()
              .having((it) => it.statusCode, 'statusCode', 500)
              .having((it) => it.code, 'code', StreamErrorCode.internalError),
        ),
      );

      verify(
        () => dio.post(
          path,
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).called(1);
      verifyNoMoreInteractions(dio);
    },
  );

  test('`.request` should return response successfully', () async {
    final dio = MockDio();
    final client = StreamHttpClient('api-key', dio: dio);

    const path = 'test-request-api-path';
    when(
      () => dio.request(
        path,
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => successResponse(path));

    final res = await client.request(path);

    expect(res, isNotNull);
    expect(res.statusCode, 200);
    expect(res.requestOptions.path, path);

    verify(
      () => dio.request(
        path,
        options: any(named: 'options'),
      ),
    ).called(1);
    verifyNoMoreInteractions(dio);
  });

  test(
    '`.request` should throw an instance of `StreamApiException`',
    () async {
      final dio = MockDio();
      final client = StreamHttpClient('api-key', dio: dio);

      const path = 'test-put-api-path';
      final error = throwableError(
        path,
        streamChatDioError: true,
        error: apiException(code: StreamErrorCode.internalError, statusCode: 500),
      );
      when(
        () => dio.request(
          path,
          options: any(named: 'options'),
        ),
      ).thenThrow(error);

      await expectLater(
        client.request(path),
        throwsA(isA<StreamApiException>().having((it) => it, 'error', error.error)),
      );

      verify(
        () => dio.request(
          path,
          options: any(named: 'options'),
        ),
      ).called(1);
      verifyNoMoreInteractions(dio);
    },
  );
}

class _CapturingHandler extends StreamLogHandler {
  const _CapturingHandler(this._onRecord);

  final void Function(StreamLogRecord) _onRecord;

  @override
  void handle(StreamLogRecord record) => _onRecord(record);
}
