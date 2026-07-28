import 'package:dio/dio.dart';
import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/error/error.dart';
import 'package:test/test.dart';

DioException _dioException(DioExceptionType type) => DioException(
      requestOptions: RequestOptions(path: 'test-path'),
      type: type,
    );

void main() {
  group('StreamChatError', () {
    test('should match if message is same', () {
      const message = 'test-error-message';
      const error = StreamChatError(message);
      const error2 = StreamChatError(message);

      expect(error, error2);
    });

    test('`.toString`', () {
      const message = 'test-error-message';
      const error = StreamChatError(message);

      expect(error.toString(), 'StreamChatError(message: $message)');
    });
  });

  group('StreamWebSocketError', () {
    test('.fromStreamError', () {
      final data = ErrorResponse()..code = 333;
      final error = StreamWebSocketError.fromStreamError(data.toJson());
      expect(error, isNotNull);
      expect(error.code, data.code);
    });

    test('should match if message and data.code is same', () {
      const message = 'test-error-message';
      final data = ErrorResponse()..code = 333;
      final error = StreamWebSocketError(message, data: data);
      final error2 = StreamWebSocketError(message, data: data);

      expect(error, error2);
    });

    test('`.toString`', () {
      const message = 'test-error-message';
      final data = ErrorResponse()..code = 333;
      final error = StreamWebSocketError(message, data: data);

      expect(
        error.toString(),
        'StreamWebSocketError(code: ${data.code}, message: $message, '
        'data: $data)',
      );
    });

    test('`.toString` omits code when absent', () {
      const error = StreamWebSocketError('boom');
      expect(error.toString(), 'StreamWebSocketError(message: boom)');
    });
  });

  group('StreamChatNetworkError', () {
    test('.raw', () {
      const code = 333;
      const message = 'test-error-message';
      final error = StreamChatNetworkError.raw(code: code, message: message);
      expect(error, isNotNull);
      expect(error.code, code);
      expect(error.message, message);
    });

    test('.fromDioException', () {
      const code = 333;
      const statusCode = 666;
      const message = 'test-error-message';
      final options = RequestOptions(path: 'test-path');
      final data = ErrorResponse()
        ..code = code
        ..statusCode = statusCode
        ..message = message;
      final dioError = DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: data.statusCode,
          data: data.toJson(),
        ),
      );
      final error = StreamChatNetworkError.fromDioException(dioError);
      expect(error, isNotNull);
      expect(error.code, code);
      expect(error.message, message);
      expect(error.statusCode, statusCode);
      expect(error.data?.code, data.code);
      expect(error.data?.statusCode, data.statusCode);
      expect(error.data?.message, data.message);
    });

    test('.fromDioException with String data', () {
      const code = 333;
      const statusCode = 666;
      const message = 'test-error-message';
      final options = RequestOptions(path: 'test-path');
      const data = '''
      {
        "code": $code,
        "StatusCode": $statusCode,
        "message": "$message"
      }''';
      final dioError = DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: statusCode,
          data: data,
        ),
      );
      final error = StreamChatNetworkError.fromDioException(dioError);
      expect(error, isNotNull);
      expect(error.code, code);
      expect(error.message, message);
      expect(error.statusCode, statusCode);
      expect(error.data?.code, code);
      expect(error.data?.statusCode, statusCode);
      expect(error.data?.message, message);
    });

    test('.fromDioException with null data and existing response message', () {
      const statusCode = 666;
      const message = 'test-error-message';
      final options = RequestOptions(path: 'test-path');
      final dioError = DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: statusCode,
          statusMessage: message,
        ),
      );
      final error = StreamChatNetworkError.fromDioException(dioError);
      expect(error, isNotNull);
      expect(error.code, -1);
      expect(error.message, message);
      expect(error.statusCode, statusCode);
      expect(error.data, isNull);
    });

    test('.fromDioException with null data and existing exception message', () {
      const statusCode = 666;
      const message = 'test-error-message';
      final options = RequestOptions(path: 'test-path');
      final dioError = DioException(
        requestOptions: options,
        message: message,
        response: Response(
          requestOptions: options,
          statusCode: statusCode,
        ),
      );
      final error = StreamChatNetworkError.fromDioException(dioError);
      expect(error, isNotNull);
      expect(error.code, -1);
      expect(error.message, message);
      expect(error.statusCode, statusCode);
      expect(error.data, isNull);
    });

    test('should match if message, code and statusCode is same', () {
      const code = 333;
      const statusCode = 666;
      const message = 'test-error-message';
      final error = StreamChatNetworkError.raw(
        code: code,
        statusCode: statusCode,
        message: message,
      );
      final error2 = StreamChatNetworkError.raw(
        code: code,
        statusCode: statusCode,
        message: message,
      );

      expect(error, error2);
    });

    test('`.retriable` should return true if data is not present', () {
      const errorCode = ChatErrorCode.tokenExpired;
      final error = StreamChatNetworkError(errorCode);

      expect(error.isRetriable, isTrue);
    });

    test('`.toString`', () {
      const errorCode = ChatErrorCode.tokenExpired;
      final error = StreamChatNetworkError(errorCode);
      expect(
        error.toString(),
        'StreamChatNetworkError('
        'code: ${errorCode.code}, '
        'message: ${errorCode.message})',
      );
    });

    test('`.toString` includes the transport type when known', () {
      final error = StreamChatNetworkError.fromDioException(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(error.toString(), contains('type: connectionError'));
    });

    group('.type from .fromDioException maps dio types 1:1', () {
      const cases = {
        DioExceptionType.connectionError:
            StreamChatNetworkErrorType.connectionError,
        DioExceptionType.connectionTimeout:
            StreamChatNetworkErrorType.connectionTimeout,
        DioExceptionType.sendTimeout: StreamChatNetworkErrorType.sendTimeout,
        DioExceptionType.receiveTimeout:
            StreamChatNetworkErrorType.receiveTimeout,
        DioExceptionType.transformTimeout:
            StreamChatNetworkErrorType.transformTimeout,
        DioExceptionType.badResponse: StreamChatNetworkErrorType.badResponse,
        DioExceptionType.cancel: StreamChatNetworkErrorType.cancel,
        DioExceptionType.badCertificate:
            StreamChatNetworkErrorType.badCertificate,
        DioExceptionType.unknown: StreamChatNetworkErrorType.unknown,
      };

      for (final MapEntry(key: dioType, value: expected) in cases.entries) {
        test('$dioType -> $expected', () {
          final error = StreamChatNetworkError.fromDioException(
            _dioException(dioType),
          );
          expect(error.type, expected);
        });
      }
    });

    test('.type defaults to unknown for non-network errors', () {
      final error = StreamChatNetworkError(ChatErrorCode.internalSystemError);
      expect(error.type, StreamChatNetworkErrorType.unknown);
    });

    test('.type is part of equality', () {
      final error = StreamChatNetworkError.raw(code: 1, message: 'msg');
      final error2 = StreamChatNetworkError.raw(
        code: 1,
        message: 'msg',
        type: StreamChatNetworkErrorType.connectionTimeout,
      );

      expect(error, isNot(error2));
    });
  });
}
