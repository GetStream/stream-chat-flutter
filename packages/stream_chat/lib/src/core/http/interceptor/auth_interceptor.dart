import 'package:dio/dio.dart';
import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/http/stream_chat_dio_error.dart';
import 'package:stream_chat/src/core/http/token.dart';

import 'package:stream_chat/src/core/http/token_manager.dart';
import 'package:stream_chat/src/errors/chat_error_code.dart';
import 'package:stream_chat/src/errors/stream_chat_error.dart';

///
class AuthInterceptor extends Interceptor {
  ///
  AuthInterceptor(this._httpClient, this._tokenManager);

  final Dio _httpClient;

  ///
  final TokenManager _tokenManager;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    late Token token;
    try {
      token = await _tokenManager.loadToken();
    } catch (_) {
      final error = StreamChatError(ChatErrorCode.undefinedToken);
      final dioError = StreamChatDioError(
        error: error,
        requestOptions: options,
      );
      return handler.reject(dioError);
    }
    final params = {'user_id': token.userId};
    final headers = {
      'Authorization': token.rawValue,
      'stream-auth-type': token.authType.raw,
    };
    options..queryParameters.addAll(params)..headers.addAll(headers);
    return handler.next(options);
  }

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    ErrorResponse? error;
    final data = err.response?.data;
    if (data != null) error = ErrorResponse.fromJson(data);
    if (error?.code == ChatErrorCode.tokenExpired.code) {
      if (_tokenManager.isStatic) return handler.next(err);
      _httpClient.lock();
      await _tokenManager.loadToken(refresh: true);
      _httpClient.unlock();
      try {
        final options = err.requestOptions;
        final response = await _httpClient.request(
          options.path,
          cancelToken: options.cancelToken,
          data: options.data,
          onReceiveProgress: options.onReceiveProgress,
          onSendProgress: options.onSendProgress,
          queryParameters: options.queryParameters,
          options: Options(
            method: options.method,
            sendTimeout: options.sendTimeout,
            receiveTimeout: options.receiveTimeout,
            extra: options.extra,
            headers: options.headers,
            responseType: options.responseType,
            contentType: options.contentType,
            validateStatus: options.validateStatus,
            receiveDataWhenStatusError: options.receiveDataWhenStatusError,
            followRedirects: options.followRedirects,
            maxRedirects: options.maxRedirects,
            requestEncoder: options.requestEncoder,
            responseDecoder: options.responseDecoder,
            listFormat: options.listFormat,
          ),
        );
        return handler.resolve(response);
      } on DioError catch (error) {
        return handler.reject(error);
      }
    }
    return handler.next(err);
  }
}
