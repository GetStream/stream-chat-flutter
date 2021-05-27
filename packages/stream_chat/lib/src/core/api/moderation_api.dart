import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';

///
class ModerationApi {
  ///
  ModerationApi(this._client);

  final StreamHttpClient _client;

  /// Mutes a user
  Future<EmptyResponse> muteUser(String userId) async {
    final response = await _client.post(
      '/moderation/mute',
      data: {'target_id': userId},
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Unmutes a user
  Future<EmptyResponse> unmuteUser(String userId) async {
    final response = await _client.post(
      '/moderation/unmute',
      data: {'target_id': userId},
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Mutes the channel
  Future<EmptyResponse> muteChannel(
    String channelCid, {
    Duration? expiration,
  }) async {
    final response = await _client.post(
      '/moderation/mute/channel',
      data: {
        'channel_cid': channelCid,
        if (expiration != null) 'expiration': expiration.inMilliseconds,
      },
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Unmutes the channel
  Future<EmptyResponse> unmuteChannel(
    String channelCid,
  ) async {
    final response = await _client.post(
      '/moderation/unmute/channel',
      data: {'channel_cid': channelCid},
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Flag a message
  Future<EmptyResponse> flagMessage(
    String messageId,
  ) async {
    final response = await _client.post(
      '/moderation/flag',
      data: {'target_message_id': messageId},
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Unflag a message
  Future<EmptyResponse> unflagMessage(
    String messageId,
  ) async {
    final response = await _client.post(
      '/moderation/unflag',
      data: {'target_message_id': messageId},
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Flag a user
  Future<EmptyResponse> flagUser(
    String userId,
  ) async {
    final response = await _client.post(
      '/moderation/flag',
      data: {'target_user_id': userId},
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Unflag a user
  Future<EmptyResponse> unflagUser(
    String userId,
  ) async {
    final response = await _client.post(
      '/moderation/unflag',
      data: {'target_user_id': userId},
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Bans a user from all channels
  Future<EmptyResponse> banUser(
    String targetUserId, {
    Map<String, Object?>? options,
  }) async {
    final response = await _client.post(
      '/moderation/ban',
      data: {
        'target_user_id': targetUserId,
        if (options != null) ...options,
      },
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Remove global ban for a user
  Future<EmptyResponse> unbanUser(
    String targetUserId, {
    Map<String, Object?>? options,
  }) async {
    final response = await _client.delete(
      '/moderation/ban',
      queryParameters: {
        'target_user_id': targetUserId,
        if (options != null) ...options,
      },
    );
    return EmptyResponse.fromJson(response.data);
  }
}
