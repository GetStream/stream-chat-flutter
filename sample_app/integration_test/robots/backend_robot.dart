import '../mock_server/mock_server.dart';

class BackendRobot {
  BackendRobot(this._mockServer);

  final MockServer _mockServer;

  Future<BackendRobot> generateChannels({
    required int channelsCount,
    int messagesCount = 0,
    int repliesCount = 0,
    String? messagesText,
    String? repliesText,
  }) async {
    final messagesTextParam =
        messagesText != null ? 'messages_text=$messagesText&' : '';
    final repliesTextParam =
        repliesText != null ? 'replies_text=$repliesText&' : '';
    await _mockServer.post(
      'mock?'
      '$messagesTextParam'
      '$repliesTextParam'
      'channels=$channelsCount&'
      'messages=$messagesCount&'
      'replies=$repliesCount',
    );
    return this;
  }

  Future<BackendRobot> failNewMessages() async {
    await _mockServer.post('fail_messages');
    return this;
  }

  Future<BackendRobot> freezeNewMessages() async {
    await _mockServer.post('freeze_messages');
    return this;
  }

  Future<void> revokeToken({int duration = 5}) =>
      _mockServer.post('jwt/revoke_token?duration=$duration');

  Future<void> invalidateToken({int duration = 5}) =>
      _mockServer.post('jwt/invalidate_token?duration=$duration');

  Future<void> invalidateTokenDate({int duration = 5}) =>
      _mockServer.post('jwt/invalidate_token_date?duration=$duration');

  Future<void> invalidateTokenSignature({int duration = 5}) =>
      _mockServer.post('jwt/invalidate_token_signature?duration=$duration');

  Future<void> breakTokenGeneration({int duration = 5}) =>
      _mockServer.post('jwt/break_token_generation?duration=$duration');
}
