import 'dart:convert';

import '../http/stream_http_client.dart';
import '../models/member.dart';
import 'requests.dart';
import 'responses.dart';

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

  /// Query channel members
  Future<QueryMembersResponse> queryMembers(
    String channelType, {
    MemberFilter? filter,
    String? channelId,
    List<Member>? members,
    List<MemberSort>? sort,
    PaginationParams? pagination,
  }) async {
    final response = await _client.get(
      '/members',
      queryParameters: {
        'payload': jsonEncode({
          'type': channelType,
          'filter_conditions': filter ?? {},
          if (channelId != null) 'id': channelId else if (members != null) 'members': members,
          if (sort != null) 'sort': sort,
          if (pagination != null) ...pagination.toJson(),
        }),
      },
    );

    return QueryMembersResponse.fromJson(response.data);
  }
}
