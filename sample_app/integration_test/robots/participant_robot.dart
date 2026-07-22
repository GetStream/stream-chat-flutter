import '../mock_server/data_types.dart';
import '../mock_server/mock_server.dart';

class ParticipantRobot {
  ParticipantRobot(this._mockServer);

  final MockServer _mockServer;

  static const name = 'Count Dooku';

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

  Future<ParticipantRobot> sendMessage(String text, {int delay = 0}) async {
    var endpoint = 'participant/message';
    if (delay > 0) endpoint += '?delay=$delay';
    await _mockServer.post(endpoint, body: text);
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

  Future<ParticipantRobot> sendMessage(String text, {int delay = 0}) =>
      then((it) => it.sendMessage(text, delay: delay));

  Future<ParticipantRobot> addReaction(ReactionType type, {int delay = 0}) =>
      then((it) => it.addReaction(type, delay: delay));

  Future<ParticipantRobot> deleteReaction(ReactionType type) =>
      then((it) => it.deleteReaction(type));
}
