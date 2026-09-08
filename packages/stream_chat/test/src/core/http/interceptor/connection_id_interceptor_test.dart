// ignore_for_file: invalid_use_of_protected_member

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/http/connection_id_manager.dart';
import 'package:stream_core/stream_core.dart' show ConnectionIdInterceptor;
import 'package:test/test.dart';

import '../../../mocks.dart';

void main() {
  late ConnectionIdManager connectionIdManager;
  late ConnectionIdInterceptor connectionIdInterceptor;

  setUp(() {
    connectionIdManager = MockConnectionIdManager();
    // Wired the way `StreamHttpClient` wires it: a closure over our manager.
    connectionIdInterceptor = ConnectionIdInterceptor(() => connectionIdManager.connectionId);
  });

  test(
    '`onRequest` should add connectionId in the request',
    () async {
      final options = RequestOptions(path: 'test-path');
      final handler = RequestInterceptorHandler();

      final queryParams = options.queryParameters;
      expect(queryParams.containsKey('connection_id'), isFalse);

      const connectionId = 'test-connection-id';
      when(() => connectionIdManager.connectionId).thenReturn(connectionId);

      connectionIdInterceptor.onRequest(options, handler);

      final updatedOptions = (await handler.future).data as RequestOptions;
      final updatedQueryParams = updatedOptions.queryParameters;

      expect(updatedQueryParams.containsKey('connection_id'), isTrue);
      expect(updatedQueryParams['connection_id'], connectionId);

      verify(() => connectionIdManager.connectionId).called(1);
      verifyNoMoreInteractions(connectionIdManager);
    },
  );

  test(
    '`onRequest` should not add connectionId when there is none',
    () async {
      final options = RequestOptions(path: 'test-path');
      final handler = RequestInterceptorHandler();

      final queryParams = options.queryParameters;
      expect(queryParams.containsKey('connection_id'), isFalse);

      when(() => connectionIdManager.connectionId).thenReturn(null);

      connectionIdInterceptor.onRequest(options, handler);

      final updatedOptions = (await handler.future).data as RequestOptions;
      final updatedQueryParams = updatedOptions.queryParameters;

      expect(updatedQueryParams.containsKey('connection_id'), isFalse);

      verify(() => connectionIdManager.connectionId).called(1);
      verifyNoMoreInteractions(connectionIdManager);
    },
  );
}
