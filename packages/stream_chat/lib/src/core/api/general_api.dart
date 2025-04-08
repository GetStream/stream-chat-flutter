import 'dart:convert';

import 'package:stream_chat/src/core/api/requests.dart';
import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/api/sort_order.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/core/models/filter.dart';
import 'package:stream_chat/src/core/models/member.dart';

/// Defines the api dedicated to general operations
class GeneralApi {
  /// Initialize a new general api
  GeneralApi(this._client);

  final StreamHttpClient _client;

  /// Get all the missed events
  Future<SyncResponse> sync(
    List<String> cids,
    DateTime lastSyncAt,
  ) async {
    final response = await _client.post(
      '/sync',
      data: {
        'channel_cids': cids,
        'last_sync_at': lastSyncAt.toUtc().toIso8601String(),
      },
    );
    return SyncResponse.fromJson(response.data);
  }

  /// A message search.
  Future<SearchMessagesResponse> searchMessages(
    Filter filter, {
    String? query,
    SortOrder? sort,
    PaginationParams? pagination,
    Filter? messageFilters,
  }) async {
    assert(
      pagination?.offset == null || pagination?.offset == 0 || sort == null,
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

    final response = await _client.get(
      '/search',
      queryParameters: {
        'payload': jsonEncode({
          'filter_conditions': filter,
          if (sort != null) 'sort': sort,
          if (query != null) 'query': query,
          if (messageFilters != null)
            'message_filter_conditions': messageFilters,
          if (pagination != null) ...pagination.toJson(),
        }),
      },
    );

    return SearchMessagesResponse.fromJson(response.data);
  }

  /// Query channel members
  Future<QueryMembersResponse> queryMembers(
    String channelType, {
    Filter? filter,
    String? channelId,
    List<Member>? members,
    SortOrder<Member>? sort,
    PaginationParams? pagination,
  }) async {
    final response = await _client.get(
      '/members',
      queryParameters: {
        'payload': jsonEncode({
          'type': channelType,
          'filter_conditions': filter ?? {},
          if (channelId != null)
            'id': channelId
          else if (members != null)
            'members': members,
          if (sort != null) 'sort': sort,
          if (pagination != null) ...pagination.toJson(),
        }),
      },
    );

    return QueryMembersResponse.fromJson(response.data);
  }

  /// Get OpenGraph data of the given [url].
  Future<OGAttachmentResponse> enrichUrl(String url) async {
    final response = await _client.get(
      '/og',
      queryParameters: {
        'url': url,
      },
    );

    return OGAttachmentResponse.fromJson(response.data);
  }
}
