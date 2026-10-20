import '../http/stream_http_client.dart';
import '../models/message.dart';
import 'responses.dart';

/// Defines the api dedicated to messages operations
class MessageApi {
  /// Initialize a new message api
  MessageApi(this._client);

  final StreamHttpClient _client;

  /// Sends the [message] to the given [channelId] of given [channelType]
  Future<SendMessageResponse> sendMessage(
    String channelId,
    String channelType,
    Message message, {
    bool skipPush = false,
    bool skipEnrichUrl = false,
  }) async {
    final response = await _client.post(
      '/channels/$channelType/$channelId/message',
      data: {
        'message': message,
        'skip_push': skipPush,
        'skip_enrich_url': skipEnrichUrl,
      },
    );
    return SendMessageResponse.fromJson(response.data);
  }

  /// Updates the given [message]
  Future<UpdateMessageResponse> updateMessage(
    Message message, {
    bool skipPush = false,
    bool skipEnrichUrl = false,
  }) async {
    final response = await _client.post(
      '/messages/${message.id}',
      data: {
        'message': message,
        'skip_push': skipPush,
        'skip_enrich_url': skipEnrichUrl,
      },
    );
    return UpdateMessageResponse.fromJson(response.data);
  }

  /// Partially update the given [messageId]
  /// Use [set] to define values to be set
  /// Use [unset] to define values to be unset
  Future<UpdateMessageResponse> partialUpdateMessage(
    String messageId, {
    Map<String, Object?>? set,
    List<String>? unset,
    bool skipEnrichUrl = false,
  }) async {
    final response = await _client.put(
      '/messages/$messageId',
      data: {
        if (set != null) 'set': set,
        if (unset != null) 'unset': unset,
        'skip_enrich_url': skipEnrichUrl,
      },
    );
    return UpdateMessageResponse.fromJson(response.data);
  }

  /// Deletes the given [messageId]
  Future<EmptyResponse> deleteMessage(
    String messageId, {
    bool? hard,
    bool? deleteForMe,
  }) async {
    if (hard == true && deleteForMe == true) {
      throw ArgumentError(
        'Both hard and deleteForMe cannot be set at the same time.',
      );
    }

    final response = await _client.delete(
      '/messages/$messageId',
      queryParameters: {
        if (hard != null) 'hard': hard,
        if (deleteForMe != null) 'delete_for_me': deleteForMe,
      },
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Send action for a specific [messageId]
  /// of the given [channelId] of given [channelType]
  Future<SendActionResponse> sendAction(
    String channelId,
    String channelType,
    String messageId,
    Map<String, Object?> formData,
  ) async {
    final response = await _client.post(
      '/messages/$messageId/action',
      data: {
        'id': channelId,
        'type': channelType,
        'form_data': formData,
        'message_id': messageId,
      },
    );
    return SendActionResponse.fromJson(response.data);
  }
}
