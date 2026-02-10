// ignore_for_file: avoid_redundant_argument_values

import 'package:stream_chat/src/core/models/attachment.dart';
import 'package:stream_chat/src/core/models/attachment_file.dart';
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

    test('should create a valid instance with UUID when id is not provided', () {
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

    test('should append command to text field in toJson when command exists', () {
      final draftWithCommand = DraftMessage(
        id: id,
        text: 'Hello world',
        command: 'giphy',
      );

      final json = draftWithCommand.toJson();
      expect(json['text'], equals('/giphy Hello world'));
    });

    test('should not modify text field when command is empty', () {
      final draftWithEmptyCommand = DraftMessage(
        id: id,
        text: 'Hello world',
        command: '',
      );

      final json = draftWithEmptyCommand.toJson();
      expect(json['text'], equals('Hello world'));
    });

    test('should not modify text field when command is null', () {
      final draftWithNullCommand = DraftMessage(
        id: id,
        text: 'Hello world',
        command: null,
      );

      final json = draftWithNullCommand.toJson();
      expect(json['text'], equals('Hello world'));
    });

    test('should remove mentioned users not found in text', () {
      final user1 = User(id: 'user1', name: 'User One');
      final user2 = User(id: 'user2', name: 'User Two');
      final user3 = User(id: 'user3', name: 'User Three');

      final draftWithMentions = DraftMessage(
        id: id,
        text: 'Hello @user1 and @User Two',
        mentionedUsers: [user1, user2, user3],
      );

      final json = draftWithMentions.toJson();

      // Decode the json to verify the mentions
      //
      // We should have only user1 and user2 in mentioned_users since user3 is
      // not in the text
      final mentionedUserIds = (json['mentioned_users'] as List).cast<String>();
      expect(mentionedUserIds, containsAll(['user1', 'user2']));
      expect(mentionedUserIds, isNot(contains('user3')));
      expect(mentionedUserIds.length, equals(2));
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
      expect(deserializedMessage.extraData['custom_field'], equals('custom_value'));
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

    group('Message and DraftMessage conversion', () {
      test('should convert Message to DraftMessage correctly', () {
        final attachments = [
          Attachment(type: 'image', uploadState: const UploadState.success()),
          Attachment(type: 'file', uploadState: const UploadState.success()),
        ];
        final mentionedUsers = [
          User(id: 'user1'),
          User(id: 'user2'),
        ];
        const parentId = 'parent-123';
        final quotedMessage = Message(id: 'quote-123');
        const extraData = {'key1': 'value1', 'key2': 42};

        final message = Message(
          id: 'message-123',
          text: 'Hello world',
          type: MessageType.regular,
          attachments: attachments,
          parentId: parentId,
          showInChannel: true,
          mentionedUsers: mentionedUsers,
          quotedMessage: quotedMessage,
          silent: true,
          command: 'giphy',
          poll: Poll(
            id: 'poll-123',
            name: 'Test Poll',
            options: const [
              PollOption(id: 'option-1', text: 'Option 1'),
              PollOption(id: 'option-2', text: 'Option 2'),
            ],
          ),
          extraData: extraData,
        );

        final draftMessage = message.toDraftMessage();

        // Verify all properties are correctly transferred
        expect(draftMessage.id, equals(message.id));
        expect(draftMessage.text, equals(message.text));
        expect(draftMessage.type, equals(message.type));
        expect(draftMessage.attachments, equals(message.attachments));
        expect(draftMessage.parentId, equals(message.parentId));
        expect(draftMessage.showInChannel, equals(message.showInChannel));
        expect(draftMessage.mentionedUsers, equals(message.mentionedUsers));
        expect(draftMessage.quotedMessage, equals(message.quotedMessage));
        expect(draftMessage.quotedMessageId, equals(message.quotedMessageId));
        expect(draftMessage.silent, equals(message.silent));
        expect(draftMessage.command, equals(message.command));
        expect(draftMessage.poll, equals(message.poll));
        expect(draftMessage.pollId, equals(message.pollId));
        expect(draftMessage.extraData, equals(message.extraData));
      });

      test('should only include successfully uploaded attachments', () {
        final successfulAttachment = Attachment(
          id: 'success-attachment',
          type: 'image',
          uploadState: const UploadState.success(),
        );
        final preparingAttachment = Attachment(
          id: 'preparing-attachment',
          type: 'file',
          uploadState: const UploadState.preparing(),
        );
        final inProgressAttachment = Attachment(
          id: 'progress-attachment',
          type: 'image',
          uploadState: const UploadState.inProgress(uploaded: 50, total: 100),
        );
        final failedAttachment = Attachment(
          id: 'failed-attachment',
          type: 'file',
          uploadState: const UploadState.failed(error: 'Upload failed'),
        );

        final message = Message(
          id: 'test-message',
          text: 'Test message with mixed upload states',
          attachments: [
            successfulAttachment,
            preparingAttachment,
            inProgressAttachment,
            failedAttachment,
          ],
        );

        final draftMessage = message.toDraftMessage();

        // Only the successfully uploaded attachment should be included
        expect(draftMessage.attachments.length, equals(1));
        expect(draftMessage.attachments.first.id, equals('success-attachment'));
        expect(draftMessage.attachments.first.uploadState.isSuccess, isTrue);
      });

      test('should convert DraftMessage to Message correctly', () {
        final attachments = [
          Attachment(type: 'image', uploadState: const UploadState.success()),
          Attachment(type: 'file', uploadState: const UploadState.success()),
        ];
        final mentionedUsers = [
          User(id: 'user1'),
          User(id: 'user2'),
        ];
        const parentId = 'parent-123';
        final quotedMessage = Message(id: 'quote-123');
        const extraData = {'key1': 'value1', 'key2': 42};

        final draftMessage = DraftMessage(
          id: 'draft-123',
          text: 'Hello world',
          type: MessageType.regular,
          attachments: attachments,
          parentId: parentId,
          showInChannel: true,
          mentionedUsers: mentionedUsers,
          quotedMessage: quotedMessage,
          silent: true,
          command: 'giphy',
          poll: Poll(
            id: 'poll-123',
            name: 'Test Poll',
            options: const [
              PollOption(id: 'option-1', text: 'Option 1'),
              PollOption(id: 'option-2', text: 'Option 2'),
            ],
          ),
          extraData: extraData,
        );

        final message = draftMessage.toMessage();

        // Verify all properties are correctly transferred
        expect(message.id, equals(draftMessage.id));
        expect(message.text, equals(draftMessage.text));
        expect(message.type, equals(draftMessage.type));
        expect(message.attachments, equals(draftMessage.attachments));
        expect(message.parentId, equals(draftMessage.parentId));
        expect(message.showInChannel, equals(draftMessage.showInChannel));
        expect(message.mentionedUsers, equals(draftMessage.mentionedUsers));
        expect(message.quotedMessage, equals(draftMessage.quotedMessage));
        expect(message.quotedMessageId, equals(draftMessage.quotedMessageId));
        expect(message.silent, equals(draftMessage.silent));
        expect(message.command, equals(draftMessage.command));
        expect(message.poll, equals(draftMessage.poll));
        expect(message.pollId, equals(draftMessage.pollId));
        expect(message.extraData, equals(draftMessage.extraData));
      });
    });
  });
}
