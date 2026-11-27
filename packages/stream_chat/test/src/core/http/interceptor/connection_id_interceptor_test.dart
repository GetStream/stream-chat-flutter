// ignore_for_file: invalid_use_of_protected_member

import 'package:dio/dio.dart';
import 'package:stream_core/stream_core.dart' show ConnectionIdInterceptor;
import 'package:test/test.dart';

void main() {
  // Wired the way `StreamHttpClient` wires it: a closure reading the id off the connection.
  String? connectionId;
  final connectionIdInterceptor = ConnectionIdInterceptor(() => connectionId);

  tearDown(() => connectionId = null);

  test(
    '`onRequest` should add connectionId in the request',
    () async {
      final options = RequestOptions(path: 'test-path');
      final handler = RequestInterceptorHandler();

      final queryParams = options.queryParameters;
      expect(queryParams.containsKey('connection_id'), isFalse);

      connectionId = 'test-connection-id';

      connectionIdInterceptor.onRequest(options, handler);

      final updatedOptions = (await handler.future).data as RequestOptions;
      final updatedQueryParams = updatedOptions.queryParameters;

      expect(updatedQueryParams.containsKey('connection_id'), isTrue);
      expect(updatedQueryParams['connection_id'], connectionId);
    },
  );

  test(
    '`onRequest` should not add connectionId when there is none',
    () async {
      final options = RequestOptions(path: 'test-path');
      final handler = RequestInterceptorHandler();

      final queryParams = options.queryParameters;
      expect(queryParams.containsKey('connection_id'), isFalse);

      connectionId = null;

      connectionIdInterceptor.onRequest(options, handler);

      final updatedOptions = (await handler.future).data as RequestOptions;
      final updatedQueryParams = updatedOptions.queryParameters;

      expect(updatedQueryParams.containsKey('connection_id'), isFalse);
    },
  );
}
