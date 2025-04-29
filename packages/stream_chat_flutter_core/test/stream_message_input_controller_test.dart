import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/stream_message_input_controller.dart';

void main() {
  group('StreamMessageInputController Tests', () {
    late StreamMessageInputController controller;

    setUp(() {
      controller = StreamMessageInputController();
    });

    tearDown(() {
      controller.dispose();
    });

    group('Initialization', () {
      test('default constructor initializes with empty message', () {
        expect(controller.message, isA<Message>());
        expect(controller.text, isEmpty);
        expect(controller.attachments, isEmpty);
        expect(controller.mentionedUsers, isEmpty);
      });

      test('fromText constructor initializes with proper text', () {
        final textController = StreamMessageInputController.fromText('Hello');
        expect(textController.text, 'Hello');
        textController.dispose();
      });

      test('fromAttachments constructor initializes with proper attachments', () {
        final attachments = [
          Attachment(type: 'image', title: 'test'),
        ];
        final attachmentsController = StreamMessageInputController.fromAttachments(attachments);
        expect(attachmentsController.attachments, attachments);
        attachmentsController.dispose();
      });

      test('can initialize with text pattern styles', () {
        final patterns = {
          RegExp(r'\*\*(.*?)\*\*'): (textStyle) => textStyle.copyWith(fontWeight: FontWeight.bold),
        };
        
        final patternController = StreamMessageInputController(textPatternStyle: patterns);
        expect(patternController.textFieldController.textPatternStyle, patterns);
        patternController.dispose();
      });
    });

    group('Text Manipulation', () {
      test('set text updates message text', () {
        controller.text = 'Updated text';
        expect(controller.text, 'Updated text');
        expect(controller.message.text, 'Updated text');
      });

      test('TextEditingValue updates text and selection', () {
        const newValue = TextEditingValue(
          text: 'New text',
          selection: TextSelection.collapsed(offset: 4),
        );
        
        controller.textEditingValue = newValue;
        expect(controller.text, 'New text');
        expect(controller.selection.baseOffset, 4);
      });
    });

    group('Quoted Message', () {
      test('set quotedMessage updates message', () {
        final quotedMessage = Message(id: 'quoted-id', text: 'Quoted message');
        
        controller.quotedMessage = quotedMessage;
        
        expect(controller.message.quotedMessageId, 'quoted-id');
        expect(controller.message.quotedMessage, quotedMessage);
      });

      test('clearQuotedMessage removes quoted message', () {
        final quotedMessage = Message(id: 'quoted-id', text: 'Quoted message');
        controller.quotedMessage = quotedMessage;
        
        controller.clearQuotedMessage();
        
        expect(controller.message.quotedMessageId, isNull);
        expect(controller.message.quotedMessage, isNull);
      });
    });

    group('Command Handling', () {
      test('set command updates message and clears text and attachments', () {
        controller.text = 'Some text';
        controller.addAttachment(Attachment(type: 'image'));
        
        controller.command = 'giphy';
        
        expect(controller.message.command, 'giphy');
        expect(controller.text, isEmpty);
        expect(controller.attachments, isEmpty);
      });
    });
    
    group('Show In Channel', () {
      test('showInChannel updates message flag', () {
        expect(controller.showInChannel, isFalse);
        
        controller.showInChannel = true;
        
        expect(controller.showInChannel, isTrue);
        expect(controller.message.showInChannel, isTrue);
      });
    });
    
    group('Attachments Management', () {
      test('addAttachment adds single attachment', () {
        final attachment = Attachment(type: 'image');
        
        controller.addAttachment(attachment);
        
        expect(controller.attachments.length, 1);
        expect(controller.attachments.first, attachment);
      });

      test('addAttachmentAt inserts attachment at specific position', () {
        final attachment1 = Attachment(id: '1', type: 'image');
        final attachment2 = Attachment(id: '2', type: 'file');
        final attachment3 = Attachment(id: '3', type: 'video');
        
        controller.addAttachment(attachment1);
        controller.addAttachment(attachment3);
        controller.addAttachmentAt(1, attachment2);
        
        expect(controller.attachments.length, 3);
        expect(controller.attachments[0], attachment1);
        expect(controller.attachments[1], attachment2);
        expect(controller.attachments[2], attachment3);
      });

      test('removeAttachment removes specific attachment', () {
        final attachment1 = Attachment(id: '1', type: 'image');
        final attachment2 = Attachment(id: '2', type: 'file');
        
        controller.addAttachment(attachment1);
        controller.addAttachment(attachment2);
        controller.removeAttachment(attachment1);
        
        expect(controller.attachments.length, 1);
        expect(controller.attachments.first, attachment2);
      });

      test('removeAttachmentById removes attachment by ID', () {
        final attachment = Attachment(id: 'to-remove', type: 'image');
        
        controller.addAttachment(attachment);
        controller.removeAttachmentById('to-remove');
        
        expect(controller.attachments, isEmpty);
      });

      test('removeAttachmentAt removes attachment at index', () {
        final attachment1 = Attachment(id: '1', type: 'image');
        final attachment2 = Attachment(id: '2', type: 'file');
        
        controller.addAttachment(attachment1);
        controller.addAttachment(attachment2);
        controller.removeAttachmentAt(0);
        
        expect(controller.attachments.length, 1);
        expect(controller.attachments.first, attachment2);
      });

      test('clearAttachments removes all attachments', () {
        controller.addAttachment(Attachment(type: 'image'));
        controller.addAttachment(Attachment(type: 'file'));
        
        controller.clearAttachments();
        
        expect(controller.attachments, isEmpty);
      });

      test('set attachments updates all attachments at once', () {
        final newAttachments = [
          Attachment(id: '1', type: 'image'),
          Attachment(id: '2', type: 'file'),
        ];
        
        controller.attachments = newAttachments;
        
        expect(controller.attachments, newAttachments);
      });
    });
    
    group('OG Attachment', () {
      test('ogAttachment returns null when no OG attachment exists', () {
        expect(controller.ogAttachment, isNull);
      });

      test('ogAttachment returns OG attachment when it exists', () {
        final ogAttachment = Attachment(ogScrapeUrl: 'https://example.com');
        
        controller.addAttachment(ogAttachment);
        
        expect(controller.ogAttachment, ogAttachment);
      });

      test('setOGAttachment adds OG attachment at beginning', () {
        final normalAttachment = Attachment(type: 'image');
        controller.addAttachment(normalAttachment);
        
        final ogAttachment = Attachment(ogScrapeUrl: 'https://example.com');
        controller.setOGAttachment(ogAttachment);
        
        expect(controller.attachments.length, 2);
        expect(controller.attachments.first, ogAttachment);
      });

      test('setOGAttachment replaces existing OG attachment', () {
        final oldOGAttachment = Attachment(ogScrapeUrl: 'https://old.example.com');
        controller.addAttachment(oldOGAttachment);
        
        final newOGAttachment = Attachment(ogScrapeUrl: 'https://new.example.com');
        controller.setOGAttachment(newOGAttachment);
        
        expect(controller.attachments.length, 1);
        expect(controller.attachments.first, newOGAttachment);
        expect(controller.attachments.contains(oldOGAttachment), isFalse);
      });

      test('clearOGAttachment removes OG attachment', () {
        final ogAttachment = Attachment(ogScrapeUrl: 'https://example.com');
        controller.addAttachment(ogAttachment);
        
        controller.clearOGAttachment();
        
        expect(controller.attachments, isEmpty);
      });
    });

    group('Poll Management', () {
      test('set poll updates message', () {
        final poll = Poll(id: 'poll-1', question: 'Test question?');
        
        controller.poll = poll;
        
        expect(controller.poll, poll);
        expect(controller.message.poll, poll);
        expect(controller.message.pollId, 'poll-1');
      });
    });

    group('Mentioned Users', () {
      test('addMentionedUser adds user to mentioned users list', () {
        final user = User(id: 'user-1');
        
        controller.addMentionedUser(user);
        
        expect(controller.mentionedUsers.length, 1);
        expect(controller.mentionedUsers.first, user);
      });

      test('removeMentionedUser removes specific user', () {
        final user1 = User(id: 'user-1');
        final user2 = User(id: 'user-2');
        
        controller.addMentionedUser(user1);
        controller.addMentionedUser(user2);
        controller.removeMentionedUser(user1);
        
        expect(controller.mentionedUsers.length, 1);
        expect(controller.mentionedUsers.first, user2);
      });

      test('removeMentionedUserById removes user by ID', () {
        final user = User(id: 'to-remove');
        
        controller.addMentionedUser(user);
        controller.removeMentionedUserById('to-remove');
        
        expect(controller.mentionedUsers, isEmpty);
      });

      test('clearMentionedUsers removes all mentioned users', () {
        controller.addMentionedUser(User(id: 'user-1'));
        controller.addMentionedUser(User(id: 'user-2'));
        
        controller.clearMentionedUsers();
        
        expect(controller.mentionedUsers, isEmpty);
      });

      test('set mentionedUsers updates all mentioned users at once', () {
        final users = [User(id: 'user-1'), User(id: 'user-2')];
        
        controller.mentionedUsers = users;
        
        expect(controller.mentionedUsers, users);
      });
    });
    
    group('Cooldown Timer', () {
      test('startCooldown sets cooldownTimeOut', () async {
        controller.startCooldown(2);
        
        expect(controller.cooldownTimeOut, 2);
        
        // Wait for the cooldown to finish
        await Future.delayed(const Duration(seconds: 3));
        
        expect(controller.cooldownTimeOut, 0);
      });

      test('cancelCooldown resets timer', () {
        controller.startCooldown(10);
        expect(controller.cooldownTimeOut, 10);
        
        controller.cancelCooldown();
        expect(controller.cooldownTimeOut, 0);
      });
      
      test('startCooldown with non-positive value does nothing', () {
        controller.startCooldown(0);
        expect(controller.cooldownTimeOut, 0);
      });
    });
    
    group('Reset and Clear', () {
      test('clear resets the message to empty state', () {
        controller.text = 'Some text';
        controller.addAttachment(Attachment(type: 'image'));
        controller.addMentionedUser(User(id: 'user-1'));
        
        controller.clear();
        
        expect(controller.text, isEmpty);
        expect(controller.attachments, isEmpty);
        expect(controller.mentionedUsers, isEmpty);
      });
      
      test('reset restores the initial message', () {
        final initialController = StreamMessageInputController(
          message: Message(text: 'Initial text'),
        );
        
        initialController.text = 'Updated text';
        initialController.reset();
        
        expect(initialController.text, 'Initial text');
        initialController.dispose();
      });

      test('reset with resetId=false keeps the same message ID', () {
        final message = Message(id: 'message-id', text: 'Initial text');
        final initialController = StreamMessageInputController(message: message);
        
        initialController.text = 'Updated text';
        initialController.reset(resetId: false);
        
        expect(initialController.message.id, 'message-id');
        initialController.dispose();
      });
    });

    group('RestorableMessageInputController', () {
      test('creates controller with default message', () {
        final restorable = StreamRestorableMessageInputController();
        
        final controller = restorable.createDefaultValue();
        
        expect(controller.text, isEmpty);
        expect(controller.attachments, isEmpty);
        
        controller.dispose();
        restorable.dispose();
      });

      test('creates controller with provided message', () {
        final message = Message(text: 'Test');
        final restorable = StreamRestorableMessageInputController(message: message);
        
        final controller = restorable.createDefaultValue();
        
        expect(controller.text, 'Test');
        
        controller.dispose();
        restorable.dispose();
      });

      test('creates from text', () {
        final restorable = StreamRestorableMessageInputController.fromText('Hello');
        
        final controller = restorable.createDefaultValue();
        
        expect(controller.text, 'Hello');
        
        controller.dispose();
        restorable.dispose();
      });

      test('toPrimitives serializes message', () {
        final message = Message(text: 'Test');
        final restorable = StreamRestorableMessageInputController(message: message);
        
        final json = restorable.toPrimitives();
        
        expect(json, isA<String>());
        expect(json.contains('Test'), isTrue);
        
        restorable.dispose();
      });
    });
  });
}