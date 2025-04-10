import 'package:stream_chat/src/core/models/attachment.dart';
import 'package:stream_chat/src/core/models/draft_message.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/poll.dart';
import 'package:stream_chat/src/core/models/poll_option.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

void main() {
  group('DraftMessage', () {
    const id = 'draft-message-id';
    const text = 'Hello, world!';

    final draftMessage = DraftMessage(
      id: id,
      text: text,
    );

    test('should create a valid instance with minimal parameters', () {
      expect(draftMessage.id, equals(id));
      expect(draftMessage.text, equals(text));
      expect(draftMessage.type, equals(MessageType.regular));
      expect(draftMessage.attachments, isEmpty);
      expect(draftMessage.parentId, isNull);
      expect(draftMessage.showInChannel, isNull);
      expect(draftMessage.mentionedUsers, isEmpty);
      expect(draftMessage.quotedMessage, isNull);
      expect(draftMessage.quotedMessageId, isNull);
      expect(draftMessage.silent, false);
      expect(draftMessage.poll, isNull);
      expect(draftMessage.pollId, isNull);
      expect(draftMessage.extraData, isEmpty);
    });

    test('should create a valid instance with UUID when id is not provided',
        () {
      final messageWithoutId = DraftMessage(text: text);
      expect(messageWithoutId.id, isNotNull);
      expect(messageWithoutId.id, isNotEmpty);
    });

    test('should create a valid instance with all parameters', () {
      final attachments = [
        Attachment(type: 'image'),
        Attachment(type: 'file'),
      ];
      final mentionedUsers = [
        User(id: 'user1'),
        User(id: 'user2'),
      ];
      const parentId = 'parent-123';
      final quotedMessage = Message(id: 'quote-123');
      const extraData = {'key1': 'value1', 'key2': 42};

      final poll = Poll(
        id: 'poll-123',
        name: 'Do you like polls?',
        options: const [
          PollOption(id: 'option-1', text: 'Yes'),
          PollOption(id: 'option-2', text: 'No'),
        ],
      );

      final fullDraftMessage = DraftMessage(
        id: id,
        text: text,
        attachments: attachments,
        parentId: parentId,
        showInChannel: true,
        mentionedUsers: mentionedUsers,
        quotedMessage: quotedMessage,
        silent: true,
        poll: poll,
        extraData: extraData,
      );

      expect(fullDraftMessage.id, equals(id));
      expect(fullDraftMessage.text, equals(text));
      expect(fullDraftMessage.type, equals(MessageType.regular));
      expect(fullDraftMessage.attachments, equals(attachments));
      expect(fullDraftMessage.parentId, equals(parentId));
      expect(fullDraftMessage.showInChannel, isTrue);
      expect(fullDraftMessage.mentionedUsers, equals(mentionedUsers));
      expect(fullDraftMessage.quotedMessage, equals(quotedMessage));
      expect(fullDraftMessage.quotedMessageId, equals(quotedMessage.id));
      expect(fullDraftMessage.silent, isTrue);
      expect(fullDraftMessage.poll, equals(poll));
      expect(fullDraftMessage.pollId, equals(poll.id));
      expect(fullDraftMessage.extraData, equals(extraData));
    });

    test('should handle quotedMessageId parameter', () {
      const quotedMessageId = 'quoted-123';
      final messageWithQuotedId = DraftMessage(
        id: id,
        text: text,
        quotedMessageId: quotedMessageId,
      );

      expect(messageWithQuotedId.quotedMessage, isNull);
      expect(messageWithQuotedId.quotedMessageId, equals(quotedMessageId));
    });

    test('should handle pollId parameter', () {
      const pollId = 'poll-123';
      final messageWithPollId = DraftMessage(
        id: id,
        text: text,
        pollId: pollId,
      );

      expect(messageWithPollId.poll, isNull);
      expect(messageWithPollId.pollId, equals(pollId));
    });

    test('should correctly serialize to JSON', () {
      final json = draftMessage.toJson();

      expect(json['id'], equals(id));
      expect(json['text'], equals(text));
      expect(json['type'], equals('regular'));
      expect(json['attachments'], isEmpty);
      expect(json['silent'], equals(false));
    });

    test('should serialize extraData correctly', () {
      const extraData = {'custom_field': 'custom_value', 'priority': 5};
      final messageWithExtraData = DraftMessage(
        id: id,
        text: text,
        extraData: extraData,
      );

      final json = messageWithExtraData.toJson();

      expect(json['id'], equals(id));
      expect(json['text'], equals(text));
      expect(json['custom_field'], equals('custom_value'));
      expect(json['priority'], equals(5));
    });

    test('should serialize poll ID correctly', () {
      const pollId = 'poll-123';
      final messageWithPollId = DraftMessage(
        id: id,
        text: text,
        pollId: pollId,
      );

      final json = messageWithPollId.toJson();

      expect(json['id'], equals(id));
      expect(json['poll_id'], equals(pollId));
    });

    test('should correctly deserialize from JSON', () {
      final json = {
        'id': id,
        'text': text,
        'type': 'regular',
        'attachments': [],
        'mentioned_users': [],
        'silent': false,
      };

      final deserializedMessage = DraftMessage.fromJson(json);

      expect(deserializedMessage.id, equals(id));
      expect(deserializedMessage.text, equals(text));
      expect(deserializedMessage.type, equals(MessageType.regular));
      expect(deserializedMessage.attachments, isEmpty);
      expect(deserializedMessage.silent, isFalse);
    });

    test('should deserialize extraData correctly', () {
      final json = {
        'id': id,
        'text': text,
        'custom_field': 'custom_value',
        'priority': 5,
      };

      final deserializedMessage = DraftMessage.fromJson(json);

      expect(deserializedMessage.id, equals(id));
      expect(deserializedMessage.text, equals(text));
      expect(deserializedMessage.extraData['custom_field'],
          equals('custom_value'));
      expect(deserializedMessage.extraData['priority'], equals(5));
    });

    test('should deserialize poll_id correctly', () {
      final json = {
        'id': id,
        'text': text,
        'poll_id': 'poll-123',
      };

      final deserializedMessage = DraftMessage.fromJson(json);

      expect(deserializedMessage.id, equals(id));
      expect(deserializedMessage.text, equals(text));
      expect(deserializedMessage.pollId, equals('poll-123'));
    });

    test('should implement equality correctly', () {
      final message1 = DraftMessage(
        id: id,
        text: text,
      );

      final message2 = DraftMessage(
        id: id,
        text: text,
      );

      final message3 = DraftMessage(
        id: 'different-id',
        text: text,
      );

      expect(message1, equals(message2));
      expect(message1, isNot(equals(message3)));
    });

    test('should implement copyWith correctly', () {
      const newText = 'Updated text';
      const newParentId = 'new-parent-id';

      final copiedMessage = draftMessage.copyWith(
        text: newText,
        parentId: newParentId,
      );

      expect(copiedMessage.id, equals(draftMessage.id));
      expect(copiedMessage.text, equals(newText));
      expect(copiedMessage.parentId, equals(newParentId));

      // Original should be unchanged
      expect(draftMessage.text, equals(text));
      expect(draftMessage.parentId, isNull);
    });
  });
}
