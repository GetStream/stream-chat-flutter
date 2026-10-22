import '../http/stream_http_client.dart';
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
}
