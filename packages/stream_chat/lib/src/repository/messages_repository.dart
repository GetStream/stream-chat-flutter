import 'package:stream_core/stream_core.dart' show PatternMatching, Result;

import '../../open_api/api.dart' as api;
import '../core/models/channel_state.dart';
import '../core/models/draft.dart';
import '../core/models/draft_message.dart';
import '../core/models/message.dart';
import '../core/models/reaction.dart';
import '../core/models/response/create_draft_response.dart';
import '../core/models/response/delete_reaction_response.dart';
import '../core/models/response/get_draft_response.dart';
import '../core/models/response/get_many_messages_response.dart';
import '../core/models/response/get_message_response.dart';
import '../core/models/response/get_reactions_response.dart';
import '../core/models/response/get_replies_response.dart';
import '../core/models/response/query_drafts_response.dart';
import '../core/models/response/query_reactions_response.dart';
import '../core/models/response/search_messages_response.dart';
import '../core/models/response/send_reaction_response.dart';
import '../core/models/response/translate_message_response.dart';
import '../core/models/translation_language.dart';
import 'mapper/drafts_mapper.dart';
import 'mapper/filter_mapper.dart';
import 'mapper/messages_mapper.dart';
import 'mapper/reactions_mapper.dart';
import 'mapper/result_mapper.dart';
import 'mapper/sort_mapper.dart';

/// Repository dedicated to messages: reading, translating and searching them,
/// the current user's drafts, and the reactions on a message.
class MessagesRepository {
  /// Creates a new messages repository.
  const MessagesRepository(this._api);

  final api.DefaultApi _api;

  /// Saves [message] as the current user's draft in the channel with the id
  /// [channelId] and type [channelType], replacing the draft it already has
  /// there.
  Future<Result<CreateDraftResponse>> createDraft(String channelId, String channelType, DraftMessage message) async {
    final result = await _api.createDraft(
      type: channelType,
      id: channelId,
      createDraftRequest: api.CreateDraftRequest(message: message.toRequest()),
    );

    return result.map((response) => response.toModel());
  }

  /// Fetches the current user's draft in the channel with the id [channelId]
  /// and type [channelType], or in the thread of the message with the id
  /// [parentId].
  Future<Result<GetDraftResponse>> getDraft(String channelId, String channelType, {String? parentId}) async {
    final result = await _api.getDraft(type: channelType, id: channelId, parentId: parentId);

    return result.map((response) => response.toModel());
  }

  /// Deletes the current user's draft in the channel with the id [channelId]
  /// and type [channelType], or in the thread of the message with the id
  /// [parentId].
  Future<Result<void>> deleteDraft(String channelId, String channelType, {String? parentId}) async {
    final result = await _api.deleteDraft(type: channelType, id: channelId, parentId: parentId);

    return result.ignoreValue();
  }

  /// Fetches one page of the current user's drafts matching [filter], ordered
  /// by [sort].
  ///
  /// [next] and [prev] are the cursors a previous page returned; at most one of
  /// them may be given.
  Future<Result<QueryDraftsResponse>> queryDrafts({
    DraftFilter? filter,
    List<DraftSort>? sort,
    int? limit,
    String? next,
    String? prev,
  }) async {
    final result = await _api.queryDrafts(
      queryDraftsRequest: api.QueryDraftsRequest(
        filter: filter?.toRequest(),
        sort: sort?.map((it) => it.toRequest()).toList(),
        limit: limit,
        next: next,
        prev: prev,
      ),
    );

    return result.map((response) => response.toModel());
  }

  /// Sends [reaction] to the message with the id [messageId].
  ///
  /// If [enforceUnique] is true, it replaces the current user's other reactions
  /// on the message.
  ///
  /// If [skipPush] is true, no push notification is sent.
  Future<Result<SendReactionResponse>> sendReaction(
    String messageId,
    Reaction reaction, {
    bool skipPush = false,
    bool enforceUnique = false,
  }) async {
    final result = await _api.sendReaction(
      id: messageId,
      sendReactionRequest: api.SendReactionRequest(
        reaction: reaction.toRequest(),
        skipPush: skipPush,
        enforceUnique: enforceUnique,
      ),
    );

    return result.map((response) => response.toModel());
  }

  /// Removes the current user's reaction of type [reactionType] from the
  /// message with the id [messageId].
  Future<Result<DeleteReactionResponse>> deleteReaction(String messageId, String reactionType) async {
    final result = await _api.deleteReaction(id: messageId, type: reactionType);

    return result.map((response) => response.toModel());
  }

  /// Fetches one page of the reactions on the message with the id [messageId].
  ///
  /// Up to [limit] reactions are returned, after skipping the first [offset].
  Future<Result<GetReactionsResponse>> getReactions(String messageId, {int? limit, int? offset}) async {
    final result = await _api.getReactions(id: messageId, limit: limit, offset: offset);

    return result.map((response) => response.toModel());
  }

  /// Fetches one page of the reactions on the message with the id [messageId]
  /// that match [filter], ordered by [sort].
  ///
  /// [next] and [prev] are the cursors a previous page returned; at most one of
  /// them may be given.
  Future<Result<QueryReactionsResponse>> queryReactions(
    String messageId, {
    ReactionFilter? filter,
    List<ReactionSort>? sort,
    int? limit,
    String? next,
    String? prev,
  }) async {
    final result = await _api.queryReactions(
      id: messageId,
      queryReactionsRequest: api.QueryReactionsRequest(
        filter: filter?.toRequest(),
        sort: sort?.map((it) => it.toRequest()).toList(),
        limit: limit,
        next: next,
        prev: prev,
      ),
    );

    return result.map((response) => response.toModel());
  }

  /// Fetches the message with the id [messageId].
  ///
  /// The response carries the channel the message belongs to as well.
  Future<Result<GetMessageResponse>> getMessage(String messageId) async {
    final result = await _api.getMessage(id: messageId);

    return result.map((response) => response.toModel());
  }

  /// Fetches the messages with the ids [messageIds] from the channel with the
  /// id [channelId] and type [channelType].
  Future<Result<GetManyMessagesResponse>> getManyMessages(
    String channelId,
    String channelType,
    List<String> messageIds,
  ) async {
    final result = await _api.getManyMessages(type: channelType, id: channelId, ids: messageIds);

    return result.map((response) => response.toModel());
  }

  /// Fetches one page of the replies to the message with the id [parentId].
  ///
  /// Up to [limit] replies are returned, oldest first, and never more than 300.
  /// The [limit] must be positive for the reply ids below to take effect.
  ///
  /// The reply ids [idLt] and [idLte] bound the page to the replies before that
  /// reply, [idGt] and [idGte] to the replies after it, and [idAround] to the
  /// replies around it. [idLte] and [idGte] include the reply itself.
  Future<Result<GetRepliesResponse>> getReplies(
    String parentId, {
    required int limit,
    String? idLt,
    String? idLte,
    String? idGt,
    String? idGte,
    String? idAround,
  }) async {
    final result = await _api.getReplies(
      parentId: parentId,
      limit: limit,
      idLt: idLt,
      idLte: idLte,
      idGt: idGt,
      idGte: idGte,
      idAround: idAround,
    );

    return result.map((response) => response.toModel());
  }

  /// Translates the message with the id [messageId] into [language].
  Future<Result<TranslateMessageResponse>> translateMessage(String messageId, TranslationLanguage language) async {
    final result = await _api.translateMessage(
      id: messageId,
      translateMessageRequest: api.TranslateMessageRequest(language: language.toRequest()),
    );

    return result.map((response) => response.toModel());
  }

  /// Searches the messages of the channels that match [filter].
  ///
  /// It looks for the messages that contain the text [query], or for those that
  /// match [messageFilters], ordered by [sort].
  ///
  /// A page holds up to [limit] results, after skipping the first [offset] or
  /// from the cursor [next] a previous page returned.
  Future<Result<SearchMessagesResponse>> search(
    ChannelFilter filter, {
    String? query,
    MessageSearchFilter? messageFilters,
    List<MessageSearchSort>? sort,
    int? limit,
    int? offset,
    String? next,
  }) async {
    assert(
      offset == null || offset == 0 || sort == null,
      'Cannot specify `offset` with `sort` parameter',
    );
    assert(() {
      if (query == null && messageFilters == null) {
        throw ArgumentError('Provide at least `query` or `messageFilters`');
      }
      if (query != null && messageFilters != null) {
        throw ArgumentError(
          "Can't provide both `query` and `messageFilters` at the same time",
        );
      }
      return true;
    }(), 'Check incoming params.');

    final result = await _api.search(
      payload: api.SearchPayload(
        filterConditions: filter.toRequest(),
        query: query,
        messageFilterConditions: messageFilters?.toRequest(),
        sort: sort?.map((it) => it.toRequest()).toList(),
        limit: limit,
        offset: offset,
        next: next,
      ),
    );

    return result.map((response) => response.toModel());
  }
}
