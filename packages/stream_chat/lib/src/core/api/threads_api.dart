import 'dart:convert';

import 'package:stream_chat/src/core/api/requests.dart';
import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';

/// Defines the api dedicated to threads operations
class ThreadsApi {
  /// Initialize a new threads api
  ThreadsApi(this._client);

  final StreamHttpClient _client;

  /// Queries threads with the given [options] and [pagination] params.
  Future<QueryThreadsResponse> queryThreads({
    ThreadOptions options = const ThreadOptions(),
    PaginationParams pagination = const PaginationParams(),
  }) async {
    final response = await _client.post(
      '/threads',
      data: jsonEncode({
        ...options.toJson(),
        ...pagination.toJson(),
      }),
    );

    return QueryThreadsResponse.fromJson(response.data);
  }

  /// Retrieves a thread with the given [messageId].
  ///
  /// Optionally pass [options] to limit the response.
  Future<GetThreadResponse> getThread(
    String messageId, {
    ThreadOptions options = const ThreadOptions(),
  }) async {
    final response = await _client.get(
      '/threads/$messageId',
      queryParameters: {...options.toJson()},
    );

    return GetThreadResponse.fromJson(response.data);
  }

  /// Partially updates the thread with the given [messageId].
  ///
  /// Use [set] to define values to be set.
  /// Use [unset] to define values to be unset.
  Future<UpdateThreadResponse> partialUpdateThread(
    String messageId, {
    Map<String, Object?>? set,
    List<String>? unset,
  }) async {
    final response = await _client.patch(
      '/threads/$messageId',
      data: jsonEncode({
        'set': set,
        'unset': unset,
      }),
    );

    return UpdateThreadResponse.fromJson(response.data);
  }
}
