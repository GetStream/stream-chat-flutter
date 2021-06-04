import 'package:dio/dio.dart';
import 'package:stream_chat/src/core/error/error.dart';
import 'package:stream_chat/src/core/http/stream_chat_dio_error.dart';
import 'package:test/test.dart';

void main() {
  test('should create a new instance of StreamChatDioError', () {
    final error = StreamChatNetworkError(ChatErrorCode.inputError);
    final options = RequestOptions(path: 'test-path');
    final dioError = StreamChatDioError(
      error: error,
      requestOptions: options,
    );

    expect(dioError, isA<DioError>());
    expect(dioError, isNotNull);
    expect(dioError.error, error);
    expect(dioError.requestOptions, options);
  });
}
