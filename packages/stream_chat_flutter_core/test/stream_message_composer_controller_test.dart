// ignore_for_file: cascade_invocations

import 'dart:convert';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/stream_message_composer_controller.dart';

class ValueNotifierListenerMock extends Mock {
  void call();
}

void main() {
  late StreamMessageComposerController controller;

  setUp(() {
    controller = StreamMessageComposerController();
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
      final textController = StreamMessageComposerController.fromText('Hello');
      expect(textController.text, 'Hello');
      textController.dispose();
    });

    test('fromAttachments constructor initializes with proper attachments', () {
      final attachments = [
        Attachment(type: 'image', title: 'test'),
      ];

      final controller = StreamMessageComposerController.fromAttachments(
        attachments,
      );

      expect(controller.attachments, attachments);
      controller.dispose();
    });

    test('can initialize with text pattern styles', () {
      final patterns = {
        RegExp(r'\*\*(.*?)\*\*'): (context, text) {
          return const TextStyle(fontWeight: FontWeight.bold);
        },
      };

      final controller = StreamMessageComposerController(
        textPatternStyle: patterns,
      );

      expect(controller.textFieldController.textPatternStyle, patterns);
      controller.dispose();
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

    test('selection setter updates text field controller selection', () async {
      controller.text = 'Updated text';

      const newSelection = TextSelection.collapsed(offset: 3);
      controller.selection = newSelection;
      expect(controller.selection.baseOffset, newSelection.baseOffset);
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
    final giphyStub = Command(name: 'giphy');
    final banStub = Command(name: 'ban');

    test('setCommand updates message and clears text and attachments', () {
      controller.text = 'Some text';
      controller.addAttachment(Attachment(type: 'image'));

      controller.setCommand(giphyStub);

      expect(controller.message.command, 'giphy');
      expect(controller.text, isEmpty);
      expect(controller.attachments, isEmpty);
    });

    test('clearCommand restores the content that was in the composer before', () {
      controller.text = 'Draft text';
      controller.addAttachment(Attachment(type: 'image'));

      controller.setCommand(giphyStub);
      controller.text = 'giphy search';

      controller.clearCommand();

      expect(controller.message.command, isNull);
      expect(controller.text, 'Draft text');
      expect(controller.attachments, hasLength(1));
    });

    test('clearCommand without an active command is a no-op', () {
      controller.text = 'Draft text';

      controller.clearCommand();

      expect(controller.text, 'Draft text');
      expect(controller.message.command, isNull);
    });

    test('setCommand during an active command keeps the original snapshot', () {
      controller.text = 'Draft text';

      controller.setCommand(giphyStub);
      controller.text = 'mid-command typing';
      controller.setCommand(banStub);

      controller.clearCommand();

      expect(controller.text, 'Draft text');
      expect(controller.message.command, isNull);
    });

    test('reset clears active command tracking', () {
      controller.text = 'Draft text';
      controller.command = 'giphy';

      controller.reset();

      controller.clearCommand();

      expect(controller.text, isNot('Draft text'));
    });

    test('clear clears active command tracking', () {
      controller.text = 'Draft text';
      controller.command = 'giphy';

      controller.clear();

      controller.clearCommand();

      expect(controller.text, isEmpty);
      expect(controller.message.command, isNull);
    });

    test('setCommand clears mentions and clearCommand restores them', () {
      final alice = User(id: 'alice');
      controller.text = '@alice hi';
      controller.addMentionedUser(alice);

      controller.setCommand(
        Command(
          name: 'giphy',
          description: '',
          args: '',
          set: CommandSet.fun,
        ),
      );

      // Mentions are cleared in command mode (no orphan mentions get sent).
      expect(controller.mentionedUsers, isEmpty);

      controller.clearCommand();

      // Cancel restores the pre-command draft, mentions included.
      expect(controller.text, '@alice hi');
      expect(controller.mentionedUsers, [alice]);
    });

    test('legacy command setter also clears mentions', () {
      controller.text = '@alice hi';
      controller.addMentionedUser(User(id: 'alice'));

      controller.command = 'giphy';

      expect(controller.mentionedUsers, isEmpty);
    });

    test('activeCommand returns null when no command is active', () {
      expect(controller.activeCommand, isNull);
    });

    test('activeCommand returns the Command instance passed to setCommand', () {
      controller.setCommand(giphyStub);

      expect(controller.activeCommand, same(giphyStub));
    });

    test('activeCommand is cleared after clearCommand', () {
      controller.setCommand(giphyStub);
      controller.clearCommand();

      expect(controller.activeCommand, isNull);
    });

    test('legacy command setter produces a stub activeCommand', () {
      controller.command = 'giphy';

      // The legacy setter has no Command metadata; the stub carries only the
      // name so [activeCommand] mirrors [message.command].
      expect(controller.activeCommand, isNotNull);
      expect(controller.activeCommand!.name, 'giphy');
      expect(controller.activeCommand!.description, isEmpty);
      expect(controller.activeCommand!.args, isEmpty);
      expect(controller.activeCommand!.set, const CommandSet(''));
    });

    test('activeCommand is cleared after legacy setter is set to null', () {
      controller.command = 'giphy';
      controller.command = null;

      expect(controller.activeCommand, isNull);
    });
  });

  group('Command availability and mutual exclusion', () {
    final funCommand = Command(
      name: 'giphy',
      description: 'Search Giphy',
      args: '[text]',
      set: CommandSet.fun,
    );
    final moderationCommand = Command(
      name: 'ban',
      description: 'Ban a user',
      args: '[@username]',
      set: CommandSet.moderation,
    );
    final customCommand = Command(
      name: 'escalate',
      description: 'App-defined custom command',
      args: '',
      set: const CommandSet('support_set'),
    );
    final quotedMessage = Message(id: 'quoted-id', text: 'Quoted');

    test('setCommand on a fun_set command keeps the quoted message', () {
      controller.quotedMessage = quotedMessage;

      controller.setCommand(funCommand);

      expect(controller.message.command, 'giphy');
      expect(controller.message.quotedMessageId, 'quoted-id');
      expect(controller.message.quotedMessage, quotedMessage);
    });

    test('setCommand keeps the quoted message regardless of CommandSet', () {
      // setCommand does not enforce availability rules itself — callers are
      // expected to gate on validateCommand first. Activation is purely a
      // state mutation; the disabled check lives in the caller.
      controller.quotedMessage = quotedMessage;
      controller.setCommand(moderationCommand);
      expect(controller.message.command, 'ban');
      expect(controller.message.quotedMessageId, 'quoted-id');

      controller.clearCommand();
      controller.quotedMessage = quotedMessage;
      controller.setCommand(funCommand);
      expect(controller.message.command, 'giphy');
      expect(controller.message.quotedMessageId, 'quoted-id');

      controller.clearCommand();
      controller.quotedMessage = quotedMessage;
      controller.setCommand(customCommand);
      expect(controller.message.command, 'escalate');
      expect(controller.message.quotedMessageId, 'quoted-id');
    });

    test('setting a quoted message clears an active moderation command', () {
      controller.text = 'Draft text';
      controller.setCommand(moderationCommand);

      controller.quotedMessage = quotedMessage;

      expect(controller.message.command, isNull);
      expect(controller.message.quotedMessageId, 'quoted-id');
      // The pre-command draft is restored.
      expect(controller.text, 'Draft text');
    });

    test('setting a quoted message keeps an active fun_set command', () {
      controller.setCommand(funCommand);

      controller.quotedMessage = quotedMessage;

      expect(controller.message.command, 'giphy');
      expect(controller.message.quotedMessageId, 'quoted-id');
    });

    test('setting a quoted message keeps an active custom-set command', () {
      controller.setCommand(customCommand);

      controller.quotedMessage = quotedMessage;

      expect(controller.message.command, 'escalate');
      expect(controller.message.quotedMessageId, 'quoted-id');
    });

    test('editMessage clears any active command and its snapshot', () {
      controller.text = 'Draft text';
      controller.setCommand(moderationCommand);

      controller.editMessage(Message(id: 'm', text: 'editing this'));

      expect(controller.message.command, isNull);
      expect(controller.activeCommand, isNull);
      expect(controller.isEditing, isTrue);

      controller.cancelEditMessage();
      // Cancel-edit unwinds to the pre-command draft, not back into command
      // mode.
      expect(controller.text, 'Draft text');
      expect(controller.message.command, isNull);
      expect(controller.activeCommand, isNull);

      // The command snapshot was fully torn down on editMessage — a stray
      // clearCommand call after cancel-edit must not resurrect stale state.
      controller.clearCommand();
      expect(controller.text, 'Draft text');
      expect(controller.message.command, isNull);
    });

    test('validateCommand: moderation blocked while quoting', () {
      controller.quotedMessage = quotedMessage;

      expect(controller.validateCommand(moderationCommand), CommandUnavailableReason.quotedMessage);
      expect(controller.validateCommand(funCommand), isNull);
      expect(controller.validateCommand(customCommand), isNull);
    });

    test('validateCommand: every command blocked while editing', () {
      controller.editMessage(Message(id: 'm', text: 'editing'));

      expect(controller.validateCommand(moderationCommand), CommandUnavailableReason.editing);
      expect(controller.validateCommand(funCommand), CommandUnavailableReason.editing);
      expect(controller.validateCommand(customCommand), CommandUnavailableReason.editing);
    });

    test('validateCommand: every command available in a clean composer', () {
      expect(controller.validateCommand(moderationCommand), isNull);
      expect(controller.validateCommand(funCommand), isNull);
      expect(controller.validateCommand(customCommand), isNull);
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
      final poll = Poll(
        id: 'poll-1',
        name: 'Test question?',
        options: const [
          PollOption(id: 'option-1', text: 'Option 1'),
          PollOption(id: 'option-2', text: 'Option 2'),
        ],
      );

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

    test('mentionedChannel setter mirrors onto the message', () {
      expect(controller.mentionedChannel, isFalse);
      expect(controller.message.mentionedChannel, isNull);

      controller.mentionedChannel = true;

      expect(controller.mentionedChannel, isTrue);
      expect(controller.message.mentionedChannel, isTrue);
    });

    test('mentionedHere setter mirrors onto the message', () {
      expect(controller.mentionedHere, isFalse);
      expect(controller.message.mentionedHere, isNull);

      controller.mentionedHere = true;

      expect(controller.mentionedHere, isTrue);
      expect(controller.message.mentionedHere, isTrue);
    });

    test('addMentionedRole appends role.name and is idempotent', () {
      final admin = Role(
        name: 'admin',
        custom: false,
        scopes: const [],
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      );
      final moderator = Role(
        name: 'moderator',
        custom: false,
        scopes: const [],
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      );

      controller.addMentionedRole(admin);
      controller.addMentionedRole(moderator);
      controller.addMentionedRole(admin);

      expect(controller.mentionedRoles, equals(['admin', 'moderator']));
      expect(controller.message.mentionedRoles, equals(['admin', 'moderator']));
    });

    test(
      'addMentionedUserGroup populates groups and ids and is idempotent',
      () {
        final engineering = UserGroup(
          id: 'group-eng',
          name: 'Engineering',
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        );
        final design = UserGroup(
          id: 'group-design',
          name: 'Design',
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        );

        controller.addMentionedUserGroup(engineering);
        controller.addMentionedUserGroup(design);
        controller.addMentionedUserGroup(engineering);

        expect(controller.mentionedUserGroups.length, equals(2));
        expect(controller.mentionedUserGroups.map((it) => it.id), equals(['group-eng', 'group-design']));
        expect(controller.message.mentionedGroupIds, equals(['group-eng', 'group-design']));
      },
    );
  });

  group('Cooldown Timer', () {
    test('startCooldown sets cooldownTimeOut', () {
      fakeAsync((async) {
        controller.startCooldown(2);

        expect(controller.cooldownTimeOut, 2);

        // Wait for the cooldown to finish
        async.elapse(const Duration(seconds: 2));

        expect(controller.cooldownTimeOut, 0);
      });
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

    test('cooldown timer triggers notifications on changes', () {
      fakeAsync((async) {
        // Setup a mock listener to track notifications
        final listener = ValueNotifierListenerMock();
        controller.addListener(listener.call);

        // Start cooldown
        controller.startCooldown(10);

        // Verify the listener was called when cooldown was set
        verify(listener.call).called(1);

        async.elapse(const Duration(seconds: 10));

        // Verify the listener was called 10 times (once for each second)
        verify(listener.call).called(10);

        // Clean up
        controller.removeListener(listener.call);
      });
    });
  });

  group('Edit Message', () {
    test('constructing with a non-initial message throws an assertion', () {
      final existingMessage = Message(
        id: 'msg-1',
        text: 'Existing text',
        state: MessageState.updating,
      );

      expect(
        () => StreamMessageComposerController(message: existingMessage),
        throwsA(isA<AssertionError>()),
      );
    });

    test('constructing with a fresh message does not enter edit mode', () {
      final editController = StreamMessageComposerController.fromText('Some draft');
      addTearDown(editController.dispose);

      expect(editController.messageBeingEdited, isNull);
    });

    test('editMessage sets state to MessageState.updating', () {
      final existingMessage = Message(id: 'msg-1', text: 'Original text');
      controller.editMessage(existingMessage);

      expect(controller.message.state.isInitial, isFalse);
      expect(controller.message.state.isUpdating, isTrue);
    });

    test('editMessage preserves the message id and text', () {
      final existingMessage = Message(id: 'msg-1', text: 'Original text');
      controller.editMessage(existingMessage);

      expect(controller.message.id, 'msg-1');
      expect(controller.message.text, 'Original text');
    });

    test('editMessage stores original in messageBeingEdited', () {
      final existingMessage = Message(id: 'msg-1', text: 'Original text');
      controller.editMessage(existingMessage);

      expect(controller.messageBeingEdited, isNotNull);
      expect(controller.messageBeingEdited!.id, 'msg-1');
      expect(controller.messageBeingEdited!.text, 'Original text');
    });

    test('messageBeingEdited text is not affected by subsequent typing', () {
      final existingMessage = Message(id: 'msg-1', text: 'Original text');
      controller.editMessage(existingMessage);

      controller.text = 'Edited text';

      expect(controller.messageBeingEdited!.text, 'Original text');
      expect(controller.message.text, 'Edited text');
    });

    test('cancelEditMessage clears messageBeingEdited', () {
      final existingMessage = Message(id: 'msg-1', text: 'Original text');
      controller.editMessage(existingMessage);

      controller.cancelEditMessage();

      expect(controller.messageBeingEdited, isNull);
    });

    test('cancelEditMessage resets controller to empty state, not the edited message', () {
      final existingMessage = Message(id: 'msg-1', text: 'Original text');
      controller.editMessage(existingMessage);
      controller.text = 'Edited text';

      controller.cancelEditMessage();

      expect(controller.text, isEmpty);
      expect(controller.message.state.isInitial, isTrue);
    });

    test('cancelEditMessage restores the draft that was in the composer before edit', () {
      final draftController = StreamMessageComposerController.fromText('Draft text');
      addTearDown(draftController.dispose);

      draftController.editMessage(Message(id: 'msg-1', text: 'Original text'));
      draftController.text = 'Edited text';
      draftController.cancelEditMessage();

      expect(draftController.text, 'Draft text');
      expect(draftController.messageBeingEdited, isNull);
    });

    test('editMessage called again during an edit keeps the original pre-edit draft', () {
      final draftController = StreamMessageComposerController.fromText('Draft text');
      addTearDown(draftController.dispose);

      draftController.editMessage(Message(id: 'msg-1', text: 'Original text'));
      draftController.text = 'Edited text';
      // Simulates a remote update arriving for the message being edited.
      draftController.editMessage(Message(id: 'msg-1', text: 'Remote update'));
      draftController.cancelEditMessage();

      expect(draftController.text, 'Draft text');
      expect(draftController.messageBeingEdited, isNull);
    });

    test('cancelEditMessage without an active edit is a no-op', () {
      final draftController = StreamMessageComposerController.fromText('Draft text');
      addTearDown(draftController.dispose);

      draftController.cancelEditMessage();

      expect(draftController.text, 'Draft text');
      expect(draftController.messageBeingEdited, isNull);
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
      final initialController = StreamMessageComposerController(
        message: Message(text: 'Initial text'),
      );

      initialController.text = 'Updated text';
      initialController.reset();

      expect(initialController.text, 'Initial text');
      initialController.dispose();
    });

    test('reset with resetId=false keeps the same message ID', () {
      final message = Message(id: 'message-id', text: 'Initial text');
      final initialController = StreamMessageComposerController(message: message);

      initialController.text = 'Updated text';
      initialController.reset(resetId: false);

      expect(initialController.message.id, 'message-id');
      initialController.dispose();
    });

    test('reset clears active edit tracking', () {
      controller.editMessage(Message(id: 'msg-1', text: 'Original text'));
      expect(controller.messageBeingEdited, isNotNull);

      controller.reset();

      expect(controller.messageBeingEdited, isNull);
    });

    test('clear preserves the active edit session', () {
      controller.editMessage(Message(id: 'msg-1', text: 'Original text'));
      controller.text = 'Edited text';

      controller.clear();

      expect(controller.text, isEmpty);
      expect(controller.messageBeingEdited, isNotNull);
      expect(controller.messageBeingEdited!.id, 'msg-1');
    });
  });

  group('Listener Notifications', () {
    test('modifying message triggers value notifier', () {
      final listener = ValueNotifierListenerMock();
      controller.addListener(listener.call);

      // Changing the message should trigger the listener
      controller.message = Message(text: 'New message');

      verify(listener.call).called(1);

      controller.removeListener(listener.call);
    });

    test('setting various properties triggers listeners', () {
      final listener = ValueNotifierListenerMock();
      controller.addListener(listener.call);

      // Test various setters
      controller.text = 'New text';
      controller.quotedMessage = Message(id: 'quoted');
      controller.showInChannel = true;
      controller.addAttachment(Attachment(type: 'image'));

      // Verify listener was called multiple times
      verify(listener.call).called(4);

      controller.removeListener(listener.call);
    });
  });

  group('RestorableMessageComposerController', () {
    testWidgets(
      'restores old state correctly',
      (tester) async {
        const text = 'Hello World! How are you? Life is good!';
        const alternativeText = 'Everything is awesome!!';

        final stateKey = GlobalKey<_RestorableWidgetState>();

        await tester.pumpWidget(
          MaterialApp(
            restorationScopeId: 'app',
            home: _RestorableWidget(
              key: stateKey,
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text(text), findsNothing);

        stateKey.currentState?.controller.value.text = text;
        await tester.pumpAndSettle();

        expect(find.text(text), findsOneWidget);

        await tester.restartAndRestore();
        expect(find.text(text), findsOneWidget);

        final data = await tester.getRestorationData();

        stateKey.currentState?.controller.value.text = alternativeText;
        await tester.pumpAndSettle();

        expect(find.text(alternativeText), findsOneWidget);

        await tester.restoreFrom(data);

        expect(find.text(text), findsOneWidget);
      },
    );

    testWidgets(
      'edit mode survives restartAndRestore',
      (tester) async {
        final stateKey = GlobalKey<_RestorableEditWidgetState>();

        await tester.pumpWidget(
          MaterialApp(
            restorationScopeId: 'app',
            home: _RestorableEditWidget(key: stateKey),
          ),
        );

        await tester.pumpAndSettle();

        stateKey.currentState!.controller.value
          ..editMessage(Message(id: 'msg-1', text: 'Original message'))
          ..text = 'My edits';
        await tester.pumpAndSettle();

        // Verify edit mode is active and rendering before the restart.
        expect(find.text('editing:msg-1:My edits'), findsOneWidget);

        await tester.restartAndRestore();

        // After restoration both the edit context and the composed text must
        // still be present.
        expect(find.text('editing:msg-1:My edits'), findsOneWidget);
      },
    );

    group('fromPrimitives', () {
      // fromPrimitives is a pure factory: it does not access `this.value`, so
      // it can be called directly without going through the Flutter restoration
      // machinery.
      late StreamRestorableMessageComposerController restorable;

      setUp(() => restorable = StreamRestorableMessageComposerController());
      tearDown(() => restorable.dispose());

      StreamMessageComposerController restore(Map<String, dynamic> data) {
        final controller = restorable.fromPrimitives(jsonEncode(data));
        addTearDown(controller.dispose);
        return controller;
      }

      test('restores text and attachments from a normal draft', () {
        final controller = restore({
          'message': Message(
            text: 'Hello!',
            // Attachment.id is a client-side tracking field that is not
            // serialised by the SDK, so verify the type survives instead.
            attachments: [Attachment(type: 'image')],
          ).toJson(),
        });

        expect(controller.text, 'Hello!');
        expect(controller.attachments, hasLength(1));
        expect(controller.attachments.first.type, 'image');
        expect(controller.message.state.isInitial, isTrue);
        expect(controller.isEditing, isFalse);
      });

      test('always resets message state to initial, even for old serialized non-initial state', () {
        // Old format stored a message_state key alongside the message. New code
        // ignores it and always constructs with MessageState.initial().
        final controller = restore({
          'message': Message(text: 'Hi').toJson(),
          'message_state': MessageState.sending.toJson(),
        });

        expect(controller.message.state.isInitial, isTrue);
        expect(controller.isEditing, isFalse);
      });

      test('restores isEditing, messageBeingEdited, and current composed text', () {
        final messageBeingEdited = Message(id: 'msg-1', text: 'Original');

        final controller = restore({
          'message': messageBeingEdited
              .copyWith(
                text: 'Edited text',
                state: MessageState.updating,
              )
              .toJson(),
          'message_being_edited': messageBeingEdited.toJson(),
          'message_before_edit': Message(text: 'Draft before edit').toJson(),
        });

        expect(controller.isEditing, isTrue);
        expect(controller.messageBeingEdited?.id, 'msg-1');
        expect(controller.messageBeingEdited?.text, 'Original');
        expect(controller.text, 'Edited text');
      });

      test('cancelEditMessage after restore returns to the pre-edit draft', () {
        final messageBeingEdited = Message(id: 'msg-1', text: 'Original');

        final controller = restore({
          'message': messageBeingEdited
              .copyWith(
                text: 'Edited text',
                state: MessageState.updating,
              )
              .toJson(),
          'message_being_edited': messageBeingEdited.toJson(),
          'message_before_edit': Message(text: 'Draft before edit').toJson(),
        });

        controller.cancelEditMessage();

        expect(controller.isEditing, isFalse);
        expect(controller.text, 'Draft before edit');
        expect(controller.message.state.isInitial, isTrue);
      });
    });
  });
}

class _RestorableWidget extends StatefulWidget {
  const _RestorableWidget({super.key});

  @override
  State<_RestorableWidget> createState() => _RestorableWidgetState();
}

class _RestorableWidgetState extends State<_RestorableWidget> with RestorationMixin {
  final controller = StreamRestorableMessageComposerController();

  @override
  String get restorationId => 'widget';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(controller, 'controller');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final value = controller.value;

        return Text(
          value.text,
          textDirection: TextDirection.ltr,
        );
      },
    );
  }
}

class _RestorableEditWidget extends StatefulWidget {
  const _RestorableEditWidget({super.key});

  @override
  State<_RestorableEditWidget> createState() => _RestorableEditWidgetState();
}

class _RestorableEditWidgetState extends State<_RestorableEditWidget> with RestorationMixin {
  final controller = StreamRestorableMessageComposerController();

  @override
  String get restorationId => 'edit_widget';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(controller, 'controller');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder ensures setState is called when the controller changes,
    // which causes RestorationMixin to flush the latest primitives to the
    // bucket before restartAndRestore captures the state.
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final value = controller.value;
        // Encode the relevant state into a single text node so tests can
        // use find.text() to assert on the restored state.
        final label = value.isEditing ? 'editing:${value.messageBeingEdited?.id}:${value.text}' : 'draft:${value.text}';
        return Text(label, textDirection: TextDirection.ltr);
      },
    );
  }
}
