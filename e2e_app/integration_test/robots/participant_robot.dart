import '../mock_server/data_types.dart';
import '../mock_server/mock_server.dart';

class ParticipantRobot {
  ParticipantRobot(this._mockServer);

  final MockServer _mockServer;

  static const name = 'Count Dooku';
  static const id = 'count_dooku';

  Future<ParticipantRobot> startTyping() async {
    await _mockServer.post('participant/typing/start');
    return this;
  }

  Future<ParticipantRobot> startTypingInThread() async {
    await _mockServer.post('participant/typing/start?thread=true');
    return this;
  }

  Future<ParticipantRobot> stopTyping() async {
    await _mockServer.post('participant/typing/stop');
    return this;
  }

  Future<ParticipantRobot> stopTypingInThread() async {
    await _mockServer.post('participant/typing/stop?thread=true');
    return this;
  }

  Future<ParticipantRobot> readMessage() async {
    await _mockServer.post('participant/read');
    return this;
  }

  /// Sends [text] to the current channel, or to the channel named
  /// [channelName].
  Future<ParticipantRobot> sendMessage(String text, {int delay = 0, String? channelName}) async {
    final query = [
      if (delay > 0) 'delay=$delay',
      if (channelName != null) 'channel_name=${Uri.encodeQueryComponent(channelName)}',
    ].join('&');
    await _mockServer.post(query.isEmpty ? 'participant/message' : 'participant/message?$query', body: text);
    return this;
  }

  /// Sends [count] messages, `"$text-1"` to `"$text-$count"`, spaced out so
  /// they arrive in order.
  Future<ParticipantRobot> sendMultipleMessages(String text, {required int count}) async {
    for (var i = 1; i <= count; i++) {
      await sendMessage('$text-$i');
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }
    return this;
  }

  /// Posts a system message, as an action of the participant would.
  Future<ParticipantRobot> sendSystemMessage(String text) async {
    await _mockServer.post('participant/message?system=true', body: text);
    return this;
  }

  /// Marks the newest message as delivered to the participant.
  Future<ParticipantRobot> markAsDelivered() async {
    await _mockServer.post('participant/delivered');
    return this;
  }

  Future<ParticipantRobot> sendMessageInThread(
    String text, {
    bool alsoSendInChannel = false,
  }) async {
    await _mockServer.post(
      'participant/message?thread=true&thread_and_channel=$alsoSendInChannel',
      body: text,
    );
    return this;
  }

  Future<ParticipantRobot> editMessage(String text) async {
    await _mockServer.post('participant/message?action=edit', body: text);
    return this;
  }

  Future<ParticipantRobot> editMessageInThread(String text, {bool alsoSendInChannel = false}) async {
    await _mockServer.post(
      'participant/message?action=edit&thread=true&thread_and_channel=$alsoSendInChannel',
      body: text,
    );
    return this;
  }

  Future<ParticipantRobot> deleteMessage({bool hard = false}) async {
    await _mockServer.post('participant/message?action=delete&hard_delete=$hard');
    return this;
  }

  Future<ParticipantRobot> quoteMessage(String text, {bool last = true}) async {
    final quote = last ? 'quote_last=true' : 'quote_first=true';
    await _mockServer.post('participant/message?$quote', body: text);
    return this;
  }

  Future<ParticipantRobot> quoteMessageInThread(
    String text, {
    bool alsoSendInChannel = false,
    bool last = true,
  }) async {
    final quote = last ? 'quote_last=true' : 'quote_first=true';
    await _mockServer.post(
      'participant/message?$quote&thread=true&thread_and_channel=$alsoSendInChannel',
      body: text,
    );
    return this;
  }

  Future<ParticipantRobot> uploadGiphy() async {
    await _mockServer.post('participant/message?giphy=true');
    return this;
  }

  Future<ParticipantRobot> uploadGiphyInThread() async {
    await _mockServer.post('participant/message?giphy=true&thread=true');
    return this;
  }

  Future<ParticipantRobot> quoteMessageWithGiphy({bool last = true}) async {
    final quote = last ? 'quote_last=true' : 'quote_first=true';
    await _mockServer.post('participant/message?giphy=true&$quote');
    return this;
  }

  Future<ParticipantRobot> quoteMessageWithGiphyInThread({
    bool alsoSendInChannel = false,
    bool last = true,
  }) async {
    final quote = last ? 'quote_last=true' : 'quote_first=true';
    await _mockServer.post(
      'participant/message?giphy=true&$quote&thread=true&thread_and_channel=$alsoSendInChannel',
    );
    return this;
  }

  Future<ParticipantRobot> pinMessage() async {
    await _mockServer.post('participant/message?action=pin');
    return this;
  }

  Future<ParticipantRobot> unpinMessage() async {
    await _mockServer.post('participant/message?action=unpin');
    return this;
  }

  Future<ParticipantRobot> uploadAttachment(
    AttachmentType type, {
    int count = 1,
  }) async {
    await _mockServer.post('participant/message?${type.attachment}=$count');
    return this;
  }

  Future<ParticipantRobot> quoteMessageWithAttachment(
    AttachmentType type, {
    int count = 1,
    bool last = true,
  }) async {
    final quote = last ? 'quote_last=true' : 'quote_first=true';
    await _mockServer.post(
      'participant/message?$quote&${type.attachment}=$count',
    );
    return this;
  }

  Future<ParticipantRobot> uploadAttachmentInThread(
    AttachmentType type, {
    int count = 1,
    bool alsoSendInChannel = false,
  }) async {
    await _mockServer.post(
      'participant/message?${type.attachment}=$count&thread=true&thread_and_channel=$alsoSendInChannel',
    );
    return this;
  }

  Future<ParticipantRobot> quoteMessageWithAttachmentInThread(
    AttachmentType type, {
    int count = 1,
    bool alsoSendInChannel = false,
    bool last = true,
  }) async {
    final quote = last ? 'quote_last=true' : 'quote_first=true';
    await _mockServer.post(
      'participant/message?$quote&${type.attachment}=$count'
      '&thread=true&thread_and_channel=$alsoSendInChannel',
    );
    return this;
  }

  /// Votes for [option] in the poll on the newest message.
  Future<ParticipantRobot> castPollVote(String option) async {
    await _mockServer.post('participant/poll_vote?option=${Uri.encodeQueryComponent(option)}');
    return this;
  }

  /// Adds [answer] as a comment to the poll on the newest message.
  Future<ParticipantRobot> addPollAnswer(String answer) async {
    await _mockServer.post('participant/poll_vote?answer=${Uri.encodeQueryComponent(answer)}');
    return this;
  }

  Future<ParticipantRobot> addReaction(ReactionType type, {int delay = 0}) async {
    var endpoint = 'participant/reaction?type=${type.reaction}';
    if (delay > 0) endpoint += '&delay=$delay';
    await _mockServer.post(endpoint);
    return this;
  }

  Future<ParticipantRobot> deleteReaction(ReactionType type) async {
    await _mockServer.post('participant/reaction?type=${type.reaction}&delete=true');
    return this;
  }
}

/// Fluent chaining over async [ParticipantRobot] actions so test steps read like
/// the native robots (`participantRobot.readMessage().addReaction(type)`).
///
/// Only the methods currently used by the ported suites are mirrored here; add
/// more from [ParticipantRobot] as new suites need to chain them.
extension ParticipantRobotChain on Future<ParticipantRobot> {
  Future<ParticipantRobot> readMessage() => then((it) => it.readMessage());

  Future<ParticipantRobot> sendMessage(String text, {int delay = 0, String? channelName}) =>
      then((it) => it.sendMessage(text, delay: delay, channelName: channelName));

  Future<ParticipantRobot> sendMultipleMessages(String text, {required int count}) =>
      then((it) => it.sendMultipleMessages(text, count: count));

  Future<ParticipantRobot> pinMessage() => then((it) => it.pinMessage());

  Future<ParticipantRobot> unpinMessage() => then((it) => it.unpinMessage());

  Future<ParticipantRobot> uploadGiphy() => then((it) => it.uploadGiphy());

  Future<ParticipantRobot> uploadAttachment(AttachmentType type, {int count = 1}) =>
      then((it) => it.uploadAttachment(type, count: count));

  Future<ParticipantRobot> editMessage(String text) => then((it) => it.editMessage(text));

  Future<ParticipantRobot> deleteMessage({bool hard = false}) => then((it) => it.deleteMessage(hard: hard));

  Future<ParticipantRobot> sendMessageInThread(String text, {bool alsoSendInChannel = false}) =>
      then((it) => it.sendMessageInThread(text, alsoSendInChannel: alsoSendInChannel));

  Future<ParticipantRobot> startTyping() => then((it) => it.startTyping());

  Future<ParticipantRobot> stopTyping() => then((it) => it.stopTyping());

  Future<ParticipantRobot> addReaction(ReactionType type, {int delay = 0}) =>
      then((it) => it.addReaction(type, delay: delay));

  Future<ParticipantRobot> deleteReaction(ReactionType type) => then((it) => it.deleteReaction(type));
}
