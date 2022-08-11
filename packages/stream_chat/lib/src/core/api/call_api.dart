import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/core/models/call_token_payload.dart';
import 'package:stream_chat/src/core/models/create_call_payload.dart';

class CallApi {
  /// Initialize a new call api
  CallApi(this._client);

  final StreamHttpClient _client;

  Future<CallTokenPayload> getCallToken(String callId) async {
    final response = await _client.post(
      '/calls/$callId',
      data: {},
    );
    // return response.data;
    return CallTokenPayload.fromJson(response.data);
  }

  Future<CreateCallPayload> createCall({
    required String callId,
    required String callType,
    required String channelType,
    required String channelId,
    Map<String, Object?>? options,
  }) async {
    final response =
        await _client.post(_getChannelUrl(channelId, channelType), data: {
      'id': '$callId',
      'type': '$callType',
    });
    // return response.data;
    return CreateCallPayload.fromJson(response.data);
  }

  String _getChannelUrl(String channelId, String channelType) =>
      '/channels/$channelType/$channelId/call';
}
