import 'package:stream_core/stream_core.dart' show PatternMatching, Result;

import '../../open_api/api.dart' as api;
import '../core/models/draft.dart';
import '../core/models/draft_message.dart';
import '../core/models/response/create_draft_response.dart';
import '../core/models/response/get_draft_response.dart';
import '../core/models/response/query_drafts_response.dart';
import 'mapper/drafts_mapper.dart';
import 'mapper/result_mapper.dart';
import 'mapper/sort_mapper.dart';

/// Repository dedicated to message operations.
class MessagesRepository {
  /// Initialize a new messages repository.
  const MessagesRepository(this._api);

  final api.DefaultApi _api;

  /// Saves [message] as the current user's draft in the channel with the id [channelId] and type [channelType],
  /// replacing the draft it already has there.
  Future<Result<CreateDraftResponse>> createDraft(String channelId, String channelType, DraftMessage message) async {
    final result = await _api.createDraft(
      type: channelType,
      id: channelId,
      createDraftRequest: api.CreateDraftRequest(message: message.toRequest()),
    );

    return result.map((response) => response.toModel());
  }

  /// Fetches the current user's draft in the channel with the id [channelId] and type [channelType], or in the
  /// thread of the message with the id [parentId].
  Future<Result<GetDraftResponse>> getDraft(String channelId, String channelType, {String? parentId}) async {
    final result = await _api.getDraft(type: channelType, id: channelId, parentId: parentId);

    return result.map((response) => response.toModel());
  }

  /// Deletes the current user's draft in the channel with the id [channelId] and type [channelType], or in the
  /// thread of the message with the id [parentId].
  Future<Result<void>> deleteDraft(String channelId, String channelType, {String? parentId}) async {
    final result = await _api.deleteDraft(type: channelType, id: channelId, parentId: parentId);

    return result.ignoreValue();
  }

  /// Fetches one page of the current user's drafts matching [filter], ordered by [sort].
  ///
  /// [next] and [prev] are the cursors a previous page returned; at most one of them may be given.
  Future<Result<QueryDraftsResponse>> queryDrafts({
    DraftFilter? filter,
    List<DraftSort>? sort,
    int? limit,
    String? next,
    String? prev,
  }) async {
    final result = await _api.queryDrafts(
      queryDraftsRequest: api.QueryDraftsRequest(
        filter: filter?.toJson(),
        sort: sort?.map((it) => it.toRequest()).toList(),
        limit: limit,
        next: next,
        prev: prev,
      ),
    );

    return result.map((response) => response.toModel());
  }
}
