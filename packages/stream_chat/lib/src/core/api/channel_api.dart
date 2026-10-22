import '../http/stream_http_client.dart';
import 'responses.dart';

/// Defines the api dedicated to channel operations
class ChannelApi {
  /// Initialize a new channel api
  ChannelApi(this._client);

  final StreamHttpClient _client;

  String _getChannelUrl(String channelId, String channelType) => '/channels/$channelType/$channelId';

  /// Stop watching the channel
  Future<EmptyResponse> stopWatching(
    String channelId,
    String channelType,
  ) async {
    final response = await _client.post(
      '${_getChannelUrl(channelId, channelType)}/stop-watching',
      data: {},
    );
    return EmptyResponse.fromJson(response.data);
  }
}
