import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/http/interceptor/auth_interceptor.dart';
import 'package:stream_chat/src/core/http/stream_chat_dio_error.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/core/http/token.dart';
import 'package:stream_chat/src/core/http/token_manager.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../../mocks.dart';

void main() {
  late StreamHttpClient client;
  late TokenManager tokenManager;
  late AuthInterceptor authInterceptor;

  setUp(() {
    client = MockHttpClient();
    tokenManager = MockTokenManager();
    authInterceptor = AuthInterceptor(client, tokenManager);
  });

  test(
    '`onRequest` should add userId, authToken, authType in the request',
    () async {
      final options = RequestOptions(path: 'test-path');
      final handler = RequestInterceptorHandler();

      final headers = options.headers;
      final queryParams = options.queryParameters;
      expect(headers.containsKey('Authorization'), isFalse);
      expect(headers.containsKey('stream-auth-type'), isFalse);
      expect(queryParams.containsKey('user_id'), isFalse);

      final token = Token.development('test-user-id');
      when(() => tokenManager.loadToken(refresh: any(named: 'refresh')))
          .thenAnswer((_) async => token);

      authInterceptor.onRequest(options, handler);

      final updatedOptions = (await handler.future).data as RequestOptions;
      final updateHeaders = updatedOptions.headers;
      final updatedQueryParams = updatedOptions.queryParameters;

      expect(updateHeaders.containsKey('Authorization'), isTrue);
      expect(updateHeaders['Authorization'], token.rawValue);
      expect(updateHeaders.containsKey('stream-auth-type'), isTrue);
      expect(updateHeaders['stream-auth-type'], token.authType.name);
      expect(updatedQueryParams.containsKey('user_id'), isTrue);
      expect(updatedQueryParams['user_id'], token.userId);

      verify(() => tokenManager.loadToken(refresh: any(named: 'refresh')))
          .called(1);
      verifyNoMoreInteractions(tokenManager);
    },
  );

  test(
    '`onRequest` should reject with error if `tokenManager.loadToken` throws',
    () async {
      final options = RequestOptions(path: 'test-path');
      final handler = RequestInterceptorHandler();

      authInterceptor.onRequest(options, handler);

      try {
        await handler.future;
      } catch (e) {
        // need to cast it as the type is private in dio
        var error = (e as dynamic).data;
        expect(error, isA<StreamChatDioError>());
        error = (error as StreamChatDioError).error;
        expect(error.code, ChatErrorCode.undefinedToken.code);
        expect(error.message, ChatErrorCode.undefinedToken.message);
      }
    },
  );

  test('`onError` should retry the request with refreshed token', () async {
    const path = 'test-request-path';
    final options = RequestOptions(path: path);
    const code = ChatErrorCode.tokenExpired;
    final errorResponse = ErrorResponse()
      ..code = code.code
      ..message = code.message;
    final response = Response(
      requestOptions: options,
      data: errorResponse.toJson(),
    );
    final err = DioError(requestOptions: options, response: response);
    final handler = ErrorInterceptorHandler();

    when(() => tokenManager.isStatic).thenReturn(false);

    final token = Token.development('test-user-id');
    when(() => tokenManager.loadToken(refresh: true))
        .thenAnswer((_) async => token);

    when(() => client.fetch(options)).thenAnswer((_) async => Response(
          requestOptions: options,
          statusCode: 200,
        ));

    authInterceptor.onError(err, handler);

    final res = await handler.future;

    var data = res.data;
    expect(data, isA<Response>());
    data = data as Response;
    expect(data, isNotNull);
    expect(data.statusCode, 200);
    expect(data.requestOptions.path, path);

    verify(() => tokenManager.isStatic).called(1);

    verify(() => tokenManager.loadToken(refresh: true)).called(1);
    verifyNoMoreInteractions(tokenManager);

    verify(() => client.fetch(options)).called(1);
    verifyNoMoreInteractions(client);
  });

  test(
    '`onError` should reject with error if retried request throws',
    () async {
      const path = 'test-request-path';
      final options = RequestOptions(path: path);
      const code = ChatErrorCode.tokenExpired;
      final errorResponse = ErrorResponse()
        ..code = code.code
        ..message = code.message;
      final response = Response(
        requestOptions: options,
        data: errorResponse.toJson(),
      );
      final err = DioError(requestOptions: options, response: response);
      final handler = ErrorInterceptorHandler();

      when(() => tokenManager.isStatic).thenReturn(false);

      final token = Token.development('test-user-id');
      when(() => tokenManager.loadToken(refresh: true))
          .thenAnswer((_) async => token);

      when(() => client.fetch(options)).thenThrow(err);

      authInterceptor.onError(err, handler);

      try {
        await handler.future;
      } catch (e) {
        // need to cast it as the type is private in dio
        final error = (e as dynamic).data;
        expect(error, isA<DioError>());
      }

      verify(() => tokenManager.isStatic).called(1);

      verify(() => tokenManager.loadToken(refresh: true)).called(1);
      verifyNoMoreInteractions(tokenManager);

      verify(() => client.fetch(options)).called(1);
      verifyNoMoreInteractions(client);
    },
  );

  test(
    '`onError` should reject with error if `tokenManager.isStatic` is true',
    () async {
      const path = 'test-request-path';
      final options = RequestOptions(path: path);
      const code = ChatErrorCode.tokenExpired;
      final errorResponse = ErrorResponse()
        ..code = code.code
        ..message = code.message;
      final response = Response(
        requestOptions: options,
        data: errorResponse.toJson(),
      );
      final err = DioError(requestOptions: options, response: response);
      final handler = ErrorInterceptorHandler();

      when(() => tokenManager.isStatic).thenReturn(true);

      authInterceptor.onError(err, handler);

      try {
        await handler.future;
      } catch (e) {
        // need to cast it as the type is private in dio
        final error = (e as dynamic).data;
        expect(error, isA<DioError>());
        final response = StreamChatNetworkError.fromDioError(error);
        expect(response.errorCode, code);
      }

      verify(() => tokenManager.isStatic).called(1);
      verifyNoMoreInteractions(tokenManager);
    },
  );

  test(
    '`onError` should reject with error if error is not a `tokenExpired error`',
    () async {
      const path = 'test-request-path';
      final options = RequestOptions(path: path);
      final response = Response(requestOptions: options);
      final err = DioError(requestOptions: options, response: response);
      final handler = ErrorInterceptorHandler();

      authInterceptor.onError(err, handler);

      try {
        await handler.future;
      } catch (e) {
        // need to cast it as the type is private in dio
        final error = (e as dynamic).data;
        expect(error, isA<DioError>());
      }
    },
  );
}
