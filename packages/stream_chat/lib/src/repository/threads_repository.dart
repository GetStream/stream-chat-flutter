import 'package:stream_core/stream_core.dart' show PatternMatching, Result;

import '../../open_api/api.dart' as api;
import '../core/models/request/thread_options.dart';
import '../core/models/response/get_thread_response.dart';
import '../core/models/response/query_threads_response.dart';
import '../core/models/response/update_thread_partial_response.dart';
import '../core/models/thread.dart';
import 'mapper/sort_mapper.dart';
import 'mapper/threads_mapper.dart';

/// Repository dedicated to thread operations.
class ThreadsRepository {
  /// Initialize a new threads repository.
  const ThreadsRepository(this._api);

  final api.DefaultApi _api;

  /// Fetches one page of the current user's threads matching [filter], ordered by [sort], each shaped by [options].
  ///
  /// [next] and [prev] are the cursors a previous page returned; at most one of them may be given.
  Future<Result<QueryThreadsResponse>> queryThreads({
    ThreadFilter? filter,
    List<ThreadSort>? sort,
    ThreadOptions options = const ThreadOptions(),
    int? limit,
    String? next,
    String? prev,
  }) async {
    final result = await _api.queryThreads(
      queryThreadsRequest: api.QueryThreadsRequest(
        filter: filter?.toJson(),
        sort: sort?.map((it) => it.toRequest()).toList(),
        watch: options.watch,
        replyLimit: options.replyLimit,
        participantLimit: options.participantLimit,
        memberLimit: options.memberLimit,
        limit: limit,
        next: next,
        prev: prev,
      ),
    );

    return result.map((response) => response.toModel());
  }

  /// Fetches the thread of the message with the id [messageId], shaped by [options].
  Future<Result<GetThreadResponse>> getThread(String messageId, {ThreadOptions options = const ThreadOptions()}) async {
    final result = await _api.getThread(
      messageId: messageId,
      watch: options.watch,
      replyLimit: options.replyLimit,
      participantLimit: options.participantLimit,
      memberLimit: options.memberLimit,
    );

    return result.map((response) => response.toModel());
  }

  /// Sets the fields in [set] and removes the fields in [unset] on the thread of the message with the id
  /// [messageId].
  Future<Result<UpdateThreadPartialResponse>> updateThreadPartial(
    String messageId, {
    Map<String, Object?>? set,
    List<String>? unset,
  }) async {
    final result = await _api.updateThreadPartial(
      messageId: messageId,
      updateThreadPartialRequest: api.UpdateThreadPartialRequest(set: set, unset: unset),
    );

    return result.map((response) => response.toModel());
  }
}
