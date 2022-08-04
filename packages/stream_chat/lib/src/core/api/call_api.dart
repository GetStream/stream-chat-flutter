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
    );
    return CallTokenPayload.fromJson(response.data); 
  }

  Future<CreateCallPayload> createCall(
    String callId,
    String callType,
    Map<String, Object?>? options,
  ) async {
    final response = await _client.post(
      '/channels/$callType/$callId/call',
    );
    return CreateCallPayload.fromJson(response.data); 
  }
}
