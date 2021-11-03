import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/error/error.dart';
import 'package:stream_chat/src/core/http/connection_id_manager.dart';
import 'package:stream_chat/src/core/http/interceptor/additional_headers_interceptor.dart';
import 'package:stream_chat/src/core/http/interceptor/auth_interceptor.dart';
import 'package:stream_chat/src/core/http/interceptor/connection_id_interceptor.dart';
import 'package:stream_chat/src/core/http/interceptor/logging_interceptor.dart';
import 'package:stream_chat/src/core/http/stream_chat_dio_error.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/core/http/token_manager.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

void main() {
  Response successResponse(String path) => Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
      );

  DioError throwableError(
    String path, {
    StreamChatNetworkError? error,
    bool streamChatDioError = false,
  }) {
    if (streamChatDioError) assert(error != null, '');
    final options = RequestOptions(path: path);
    final data = ErrorResponse()
      ..code = error?.code
      ..statusCode = error?.statusCode
      ..message = error?.message;
    DioError? dioError;
    if (streamChatDioError) {
      dioError = StreamChatDioError(error: error!, requestOptions: options);
    } else {
      dioError = DioError(
        error: error,
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: data.statusCode,
          data: data.toJson(),
        ),
      );
    }
    return dioError;
  }

  test('UserAgentInterceptor should be added', () {
    const apiKey = 'api-key';
    final client = StreamHttpClient(apiKey);

    expect(
        client.httpClient.interceptors
            .whereType<AdditionalHeadersInterceptor>()
            .length,
        1);
  });

  test('AuthInterceptor should be added if tokenManager is provided', () {
    const apiKey = 'api-key';
    final client = StreamHttpClient(apiKey, tokenManager: TokenManager());

    expect(
        client.httpClient.interceptors.whereType<AuthInterceptor>().length, 1);
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
        client.httpClient.interceptors
            .whereType<ConnectionIdInterceptor>()
            .length,
        1,
      );
    },
  );

  test('loggingInterceptor should be added if logger is provided', () {
    const apiKey = 'api-key';
    final client = StreamHttpClient(
      apiKey,
      logger: Logger('test-logger'),
    );

    expect(
      client.httpClient.interceptors.whereType<LoggingInterceptor>().length,
      1,
    );
  });

  test('loggingInterceptor should log requests', () async {
    const apiKey = 'api-key';
    final logger = MockLogger();
    final client = StreamHttpClient(apiKey, logger: logger);

    try {
      await client.get('path');
    } catch (_) {}

    verify(() => logger.info(any())).called(greaterThan(0));
  });

  test('loggingInterceptor should log error', () async {
    const apiKey = 'api-key';
    final logger = MockLogger();
    final client = StreamHttpClient(apiKey, logger: logger);

    try {
      await client.get('path');
    } catch (_) {}

    verify(() => logger.severe(any())).called(greaterThan(0));
  });

  test('`.lock` should lock the dio client', () async {
    final client = StreamHttpClient('api-key');
    expect(client.httpClient.interceptors.requestLock.locked, isFalse);
    client.lock();
    expect(client.httpClient.interceptors.requestLock.locked, isTrue);
  });

  test('`.unlock` should unlock the dio client', () async {
    final client = StreamHttpClient('api-key');
    expect(client.httpClient.interceptors.requestLock.locked, isFalse);
    client.lock();
    expect(client.httpClient.interceptors.requestLock.locked, isTrue);
    client.unlock();
    expect(client.httpClient.interceptors.requestLock.locked, isFalse);
  });

  test('`.clear` should clear and unlock the dio client', () async {
    final client = StreamHttpClient('api-key')..clear();
    expect(client.httpClient.interceptors.requestLock.locked, isFalse);
  });

  test('`.close` should close the dio client', () async {
    final client = StreamHttpClient('api-key')..close(force: true);
    try {
      await client.get('path');
    } on StreamChatNetworkError catch (e) {
      expect(e, isA<StreamChatNetworkError>());
      expect(e.message, "Dio can't establish new connection after closed.");
    }
  });

  test('`.get` should return response successfully', () async {
    final dio = MockDio();
    final client = StreamHttpClient('api-key', dio: dio);

    const path = 'test-get-api-path';
    when(() => dio.get(
          path,
          options: any(named: 'options'),
        )).thenAnswer((_) async => successResponse(path));

    final res = await client.get(path);

    expect(res, isNotNull);
    expect(res.statusCode, 200);
    expect(res.requestOptions.path, path);

    verify(() => dio.get(
          path,
          options: any(named: 'options'),
        )).called(1);
    verifyNoMoreInteractions(dio);
  });

  test('`.get` should throw an instance of `StreamChatNetworkError`', () async {
    final dio = MockDio();
    final client = StreamHttpClient('api-key', dio: dio);

    const path = 'test-get-api-path';
    final error = throwableError(
      path,
      error: StreamChatNetworkError(ChatErrorCode.internalSystemError),
    );
    when(() => dio.get(
          path,
          options: any(named: 'options'),
        )).thenThrow(error);

    try {
      await client.get(path);
    } catch (e) {
      expect(e, isA<StreamChatNetworkError>());
      expect(e, StreamChatNetworkError.fromDioError(error));
    }

    verify(() => dio.get(
          path,
          options: any(named: 'options'),
        )).called(1);
    verifyNoMoreInteractions(dio);
  });

  test('`.post` should return response successfully', () async {
    final dio = MockDio();
    final client = StreamHttpClient('api-key', dio: dio);

    const path = 'test-post-api-path';
    when(() => dio.post(
          path,
          options: any(named: 'options'),
        )).thenAnswer((_) async => successResponse(path));

    final res = await client.post(path);

    expect(res, isNotNull);
    expect(res.statusCode, 200);
    expect(res.requestOptions.path, path);

    verify(() => dio.post(
          path,
          options: any(named: 'options'),
        )).called(1);
    verifyNoMoreInteractions(dio);
  });

  test(
    '`.post` should throw an instance of `StreamChatNetworkError`',
    () async {
      final dio = MockDio();
      final client = StreamHttpClient('api-key', dio: dio);

      const path = 'test-post-api-path';
      final error = throwableError(
        path,
        error: StreamChatNetworkError(ChatErrorCode.internalSystemError),
      );
      when(() => dio.post(
            path,
            options: any(named: 'options'),
          )).thenThrow(error);

      try {
        await client.post(path);
      } catch (e) {
        expect(e, isA<StreamChatNetworkError>());
        expect(e, StreamChatNetworkError.fromDioError(error));
      }

      verify(() => dio.post(
            path,
            options: any(named: 'options'),
          )).called(1);
      verifyNoMoreInteractions(dio);
    },
  );

  test('`.delete` should return response successfully', () async {
    final dio = MockDio();
    final client = StreamHttpClient('api-key', dio: dio);

    const path = 'test-delete-api-path';
    when(() => dio.delete(
          path,
          options: any(named: 'options'),
        )).thenAnswer((_) async => successResponse(path));

    final res = await client.delete(path);

    expect(res, isNotNull);
    expect(res.statusCode, 200);
    expect(res.requestOptions.path, path);

    verify(() => dio.delete(
          path,
          options: any(named: 'options'),
        )).called(1);
    verifyNoMoreInteractions(dio);
  });

  test(
    '`.delete` should throw an instance of `StreamChatNetworkError`',
    () async {
      final dio = MockDio();
      final client = StreamHttpClient('api-key', dio: dio);

      const path = 'test-delete-api-path';
      final error = throwableError(
        path,
        error: StreamChatNetworkError(ChatErrorCode.internalSystemError),
      );
      when(() => dio.delete(
            path,
            options: any(named: 'options'),
          )).thenThrow(error);

      try {
        await client.delete(path);
      } catch (e) {
        expect(e, isA<StreamChatNetworkError>());
        expect(e, StreamChatNetworkError.fromDioError(error));
      }

      verify(() => dio.delete(
            path,
            options: any(named: 'options'),
          )).called(1);
      verifyNoMoreInteractions(dio);
    },
  );

  test('`.patch` should return response successfully', () async {
    final dio = MockDio();
    final client = StreamHttpClient('api-key', dio: dio);

    const path = 'test-patch-api-path';
    when(() => dio.patch(
          path,
          options: any(named: 'options'),
        )).thenAnswer((_) async => successResponse(path));

    final res = await client.patch(path);

    expect(res, isNotNull);
    expect(res.statusCode, 200);
    expect(res.requestOptions.path, path);

    verify(() => dio.patch(
          path,
          options: any(named: 'options'),
        )).called(1);
    verifyNoMoreInteractions(dio);
  });

  test(
    '`.patch` should throw an instance of `StreamChatNetworkError`',
    () async {
      final dio = MockDio();
      final client = StreamHttpClient('api-key', dio: dio);

      const path = 'test-patch-api-path';
      final error = throwableError(
        path,
        error: StreamChatNetworkError(ChatErrorCode.internalSystemError),
      );
      when(() => dio.patch(
            path,
            options: any(named: 'options'),
          )).thenThrow(error);

      try {
        await client.patch(path);
      } catch (e) {
        expect(e, isA<StreamChatNetworkError>());
        expect(e, StreamChatNetworkError.fromDioError(error));
      }

      verify(() => dio.patch(
            path,
            options: any(named: 'options'),
          )).called(1);
      verifyNoMoreInteractions(dio);
    },
  );

  test('`.put` should return response successfully', () async {
    final dio = MockDio();
    final client = StreamHttpClient('api-key', dio: dio);

    const path = 'test-put-api-path';
    when(() => dio.put(
          path,
          options: any(named: 'options'),
        )).thenAnswer((_) async => successResponse(path));

    final res = await client.put(path);

    expect(res, isNotNull);
    expect(res.statusCode, 200);
    expect(res.requestOptions.path, path);

    verify(() => dio.put(
          path,
          options: any(named: 'options'),
        )).called(1);
    verifyNoMoreInteractions(dio);
  });

  test(
    '`.put` should throw an instance of `StreamChatNetworkError`',
    () async {
      final dio = MockDio();
      final client = StreamHttpClient('api-key', dio: dio);

      const path = 'test-put-api-path';
      final error = throwableError(
        path,
        error: StreamChatNetworkError(ChatErrorCode.internalSystemError),
      );
      when(() => dio.put(
            path,
            options: any(named: 'options'),
          )).thenThrow(error);

      try {
        await client.put(path);
      } catch (e) {
        expect(e, isA<StreamChatNetworkError>());
        expect(e, StreamChatNetworkError.fromDioError(error));
      }

      verify(() => dio.put(
            path,
            options: any(named: 'options'),
          )).called(1);
      verifyNoMoreInteractions(dio);
    },
  );

  test('`.postFile` should return response successfully', () async {
    final dio = MockDio();
    final client = StreamHttpClient('api-key', dio: dio);

    const path = 'test-delete-api-path';
    final file = MultipartFile.fromBytes([]);

    when(() => dio.post(
          path,
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => successResponse(path));

    final res = await client.postFile(path, file);

    expect(res, isNotNull);
    expect(res.statusCode, 200);
    expect(res.requestOptions.path, path);

    verify(() => dio.post(
          path,
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).called(1);
    verifyNoMoreInteractions(dio);
  });

  test(
    '`.postFile` should throw an instance of `StreamChatNetworkError`',
    () async {
      final dio = MockDio();
      final client = StreamHttpClient('api-key', dio: dio);

      const path = 'test-post-file-api-path';
      final file = MultipartFile.fromBytes([]);

      final error = throwableError(
        path,
        error: StreamChatNetworkError(ChatErrorCode.internalSystemError),
      );
      when(() => dio.post(
            path,
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenThrow(error);

      try {
        await client.postFile(path, file);
      } catch (e) {
        expect(e, isA<StreamChatNetworkError>());
        expect(e, StreamChatNetworkError.fromDioError(error));
      }

      verify(() => dio.post(
            path,
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).called(1);
      verifyNoMoreInteractions(dio);
    },
  );

  test('`.request` should return response successfully', () async {
    final dio = MockDio();
    final client = StreamHttpClient('api-key', dio: dio);

    const path = 'test-request-api-path';
    when(() => dio.request(
          path,
          options: any(named: 'options'),
        )).thenAnswer((_) async => successResponse(path));

    final res = await client.request(path);

    expect(res, isNotNull);
    expect(res.statusCode, 200);
    expect(res.requestOptions.path, path);

    verify(() => dio.request(
          path,
          options: any(named: 'options'),
        )).called(1);
    verifyNoMoreInteractions(dio);
  });

  test(
    '`.request` should throw an instance of `StreamChatNetworkError`',
    () async {
      final dio = MockDio();
      final client = StreamHttpClient('api-key', dio: dio);

      const path = 'test-put-api-path';
      final error = throwableError(
        path,
        streamChatDioError: true,
        error: StreamChatNetworkError(ChatErrorCode.internalSystemError),
      );
      when(() => dio.request(
            path,
            options: any(named: 'options'),
          )).thenThrow(error);

      try {
        await client.request(path);
      } catch (e) {
        expect(e, isA<StreamChatNetworkError>());
        expect(e, error.error);
      }

      verify(() => dio.request(
            path,
            options: any(named: 'options'),
          )).called(1);
      verifyNoMoreInteractions(dio);
    },
  );
}
