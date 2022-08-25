import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';

/// Defines the api dedicated to video call operations
class CallApi {
  /// Initialize a new call api
  CallApi(this._client);

  final StreamHttpClient _client;

  /// Returns a token dedicated to the [callId]
  Future<CallTokenPayload> getCallToken(String callId) async {
    final response = await _client.post(
      '/calls/$callId',
      data: {},
    );
    // return response.data;
    return CallTokenPayload.fromJson(response.data);
  }

  /// Creates a new call
  Future<CreateCallPayload> createCall({
    required String callId,
    required String callType,
    required String channelType,
    required String channelId,
  }) async {
    final response =
        await _client.post(_getChannelUrl(channelId, channelType), data: {
      'id': callId,
      'type': callType,
    });
    // return response.data;
    return CreateCallPayload.fromJson(response.data);
  }

  String _getChannelUrl(String channelId, String channelType) =>
      '/channels/$channelType/$channelId/call';
}
