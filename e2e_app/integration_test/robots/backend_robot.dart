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
    List<String> channelNames = const [],
    bool withDirectMessageChannel = false,
  }) async {
    final messagesTextParam = messagesText != null ? 'messages_text=${Uri.encodeQueryComponent(messagesText)}&' : '';
    final repliesTextParam = repliesText != null ? 'replies_text=${Uri.encodeQueryComponent(repliesText)}&' : '';
    final channelNamesParam = channelNames.isNotEmpty
        ? 'channel_names=${Uri.encodeQueryComponent(channelNames.join(','))}&'
        : '';
    final dmParam = withDirectMessageChannel ? 'dm=true&' : '';
    await _mockServer.post(
      'mock?'
      '$messagesTextParam'
      '$repliesTextParam'
      '$channelNamesParam'
      '$dmParam'
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

  /// Holds every new message on the server for [seconds] before answering, so
  /// it stays pending meanwhile.
  Future<BackendRobot> delayNewMessages({int seconds = 10}) async {
    await _mockServer.post('delay_messages?delay=$seconds');
    return this;
  }

  /// Turns slow mode on (or off) for the channel, with a cooldown of
  /// [duration] seconds between the user's messages.
  Future<BackendRobot> setCooldown({required bool enabled, int duration = 15}) async {
    await _mockServer.post('config/cooldown?enabled=$enabled&duration=$duration');
    return this;
  }

  /// Turns the channel's read events (read receipts) on or off.
  Future<BackendRobot> setReadEvents({required bool enabled}) async {
    await _mockServer.post('config/read_events?value=$enabled');
    return this;
  }

  /// Makes the mock server treat the app as logged in as [id] from now on, so
  /// a test can log in as a second user after logging out.
  Future<BackendRobot> setAppUser({required String id, required String name}) async {
    await _mockServer.post('app_user?id=$id&name=${Uri.encodeQueryComponent(name)}');
    return this;
  }

  /// Delays the channel list query by [seconds].
  Future<BackendRobot> delayChannelList({required int seconds}) async {
    await _mockServer.post('delay_channel_list?delay=$seconds');
    return this;
  }

  /// Mutes the current channel for the user, server-side.
  Future<BackendRobot> muteChannel() async {
    await _mockServer.post('mute_channel');
    return this;
  }

  Future<BackendRobot> addMember(String userId) async {
    await _mockServer.post('add_member?user_id=$userId');
    return this;
  }

  Future<BackendRobot> removeMember(String userId) async {
    await _mockServer.post('remove_member?user_id=$userId');
    return this;
  }

  /// Creates a reminder on the last message, due in [remindAtSeconds], or a
  /// "saved for later" one with no due date when it is null.
  Future<BackendRobot> createReminder({int? remindAtSeconds}) async {
    await _mockServer.post(remindAtSeconds == null ? 'create_reminder' : 'create_reminder?remind_at=$remindAtSeconds');
    return this;
  }

  Future<void> revokeToken({int duration = 5}) => _mockServer.post('jwt/revoke_token?duration=$duration');

  Future<void> invalidateToken({int duration = 5}) => _mockServer.post('jwt/invalidate_token?duration=$duration');

  Future<void> invalidateTokenDate({int duration = 5}) =>
      _mockServer.post('jwt/invalidate_token_date?duration=$duration');

  Future<void> invalidateTokenSignature({int duration = 5}) =>
      _mockServer.post('jwt/invalidate_token_signature?duration=$duration');

  Future<void> breakTokenGeneration({int duration = 5}) =>
      _mockServer.post('jwt/break_token_generation?duration=$duration');
}
