import 'package:dio/dio.dart';

import 'package:stream_chat/src/core/http/connection_id_manager.dart';

///
class ConnectionIdInterceptor extends Interceptor {
  ///
  ConnectionIdInterceptor(this.connectionIdManager);

  ///
  final ConnectionIdManager connectionIdManager;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (connectionIdManager.hasConnectionId) {
      options.queryParameters.addAll({
        'connection_id': connectionIdManager.connectionId,
      });
    }
    handler.next(options);
  }
}
