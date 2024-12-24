import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/stream_poll_controller.dart';

void main() {
  group('Initialization Tests', () {
    test('Default Initialization', () {
      final pollController = StreamPollController();
      expect(pollController.value.name, '');
      expect(pollController.value.options.length, 1);
    });

    test('Initialization with Custom Poll and Config', () {
      final poll = Poll(name: 'Initial Poll', options: const [
        PollOption(text: 'Option 1'),
        PollOption(text: 'Option 2'),
      ]);
      const config = PollConfig(nameRange: (min: 2, max: 50));
      final pollController = StreamPollController(poll: poll, config: config);

      expect(pollController.value.name, 'Initial Poll');
      expect(pollController.config.nameRange?.min, 2);
      expect(pollController.config.nameRange?.max, 50);
    });
  });

  group('Poll Property Setter Tests', () {
    final pollController = StreamPollController();

    test('Set Question', () {
      pollController.question = 'New Question';
      expect(pollController.value.name, 'New Question');
    });

    test('Set Options', () {
      pollController.options = [const PollOption(text: 'Option A')];
      expect(pollController.value.options.length, 1);
    });

    test('Set enforceUniqueVote', () {
      pollController.enforceUniqueVote = true;
      expect(pollController.value.enforceUniqueVote, isTrue);
    });

    test('Set maxVotesAllowed', () {
      pollController.maxVotesAllowed = 5;
      expect(pollController.value.maxVotesAllowed, 5);
    });

    test('Set allowSuggestions', () {
      pollController.allowSuggestions = true;
      expect(pollController.value.allowUserSuggestedOptions, isTrue);
    });

    test('Set votingVisibility', () {
      pollController.votingVisibility = VotingVisibility.anonymous;
      expect(pollController.value.votingVisibility, VotingVisibility.anonymous);
    });

    test('Set allowComments', () {
      pollController.allowComments = true;
      expect(pollController.value.allowAnswers, isTrue);
    });
  });

  group('Add/Update/Remove Option Tests', () {
    test('Add Option', () {
      final pollController = StreamPollController()..addOption('Option 1');
      expect(pollController.value.options.length, 2);
      expect(pollController.value.options.last.text, 'Option 1');
    });

    test('Add Option with Extra Data', () {
      final pollController = StreamPollController()
        ..addOption(
          'Option 1',
          extraData: {'key': 'value'},
        );

      expect(pollController.value.options.length, 2);
      expect(pollController.value.options.last.extraData['key'], 'value');
    });

    test('Update Option', () {
      final pollController = StreamPollController()..addOption('Option 1');
      expect(pollController.value.options.last.text, 'Option 1');

      pollController.updateOption('Updated Option 1', index: 1);
      expect(pollController.value.options.last.text, 'Updated Option 1');
    });

    test('Remove Option', () {
      final pollController = StreamPollController()..removeOption(0);
      expect(pollController.value.options.length, 0);
    });
  });

  group('Validation Tests', () {
    test('Validate Poll Name Length', () {
      final pollController = StreamPollController()..question = 'A' * 100;
      final errors = pollController.validateGranularly();
      expect(errors.isEmpty, isFalse);

      final containsNameRangeError = errors
          .map((e) => e.mapOrNull(nameRange: (e) => e))
          .nonNulls
          .isNotEmpty;

      expect(containsNameRangeError, isTrue);
    });

    test('Validate Unique Options', () {
      final pollController = StreamPollController()
        ..addOption('Option 1')
        ..addOption('Option 1');

      final errors = pollController.validateGranularly();
      expect(errors.isEmpty, isFalse);

      final containsDuplicateOptions = errors
          .map((e) => e.mapOrNull(duplicateOptions: (e) => e))
          .nonNulls
          .isNotEmpty;

      expect(containsDuplicateOptions, isTrue);
    });

    test('Validate Options Count', () {
      final pollController = StreamPollController()..options = const [];
      final errors = pollController.validateGranularly();
      expect(errors.isEmpty, isFalse);

      final containsOptionsRangeError = errors
          .map((e) => e.mapOrNull(optionsRange: (e) => e))
          .nonNulls
          .isNotEmpty;

      expect(containsOptionsRangeError, isTrue);
    });

    test('Validate Max Votes Allowed', () {
      final pollController = StreamPollController()
        ..enforceUniqueVote = false
        ..maxVotesAllowed = 20;

      final errors = pollController.validateGranularly();
      expect(errors.isEmpty, isFalse);

      final containsMaxVotesAllowedError = errors
          .map((e) => e.mapOrNull(maxVotesAllowed: (e) => e))
          .nonNulls
          .isNotEmpty;

      expect(containsMaxVotesAllowedError, isTrue);
    });
  });

  group('Reset Tests', () {
    test('Reset Poll Without Changing ID', () {
      final poll = Poll(
        name: 'Initial Poll',
        options: const [PollOption(text: 'Option 1')],
      );

      final pollController = StreamPollController(poll: poll)
        ..question = 'New Question'
        ..addOption('New Option');

      expect(pollController.value.name, 'New Question');
      expect(pollController.value.options.length, 2);

      pollController.reset(resetId: false);

      expect(pollController.value.name, 'Initial Poll');
      expect(pollController.value.options.length, 1);
      expect(pollController.value.id, poll.id);
    });

    test('Reset Poll With New ID', () {
      final poll = Poll(
        name: 'Initial Poll',
        options: const [PollOption(text: 'Option 1')],
      );

      final pollController = StreamPollController(poll: poll)
        ..question = 'New Question'
        ..addOption('New Option');

      expect(pollController.value.name, 'New Question');
      expect(pollController.value.options.length, 2);

      pollController.reset();

      expect(pollController.value.name, 'Initial Poll');
      expect(pollController.value.options.length, 1);
      expect(pollController.value.id, isNot(poll.id));
    });
  });

  group('Sanitization Tests', () {
    test('Sanitized Poll Removes New Option IDs', () {
      final pollController = StreamPollController()
        ..options = [
          const PollOption(id: 'new_id', text: 'New Option'),
        ];

      final sanitizedPoll = pollController.sanitizedPoll;
      expect(sanitizedPoll.options.last.id, isNull);
      expect(sanitizedPoll.options.last.text, 'New Option');
    });

    test('Sanitized Poll Preserves Existing Option IDs', () {
      final poll = Poll(
        name: 'Initial Poll',
        options: const [
          PollOption(id: 'existing_id', text: 'Existing Option'),
        ],
      );

      final pollController = StreamPollController(poll: poll)
        ..options = [
          ...poll.options,
          const PollOption(id: 'new_id', text: 'New Option'),
        ];

      final sanitizedPoll = pollController.sanitizedPoll;
      expect(sanitizedPoll.options.first.text, 'Existing Option');
      expect(sanitizedPoll.options.first.id, isNotNull);
      expect(sanitizedPoll.options.last.text, 'New Option');
      expect(sanitizedPoll.options.last.id, isNull);
    });
  });

  group('Edge Cases and Config Tests', () {
    test('Config Allows Unlimited Poll Name Length', () {
      final pollController = StreamPollController(
        config: const PollConfig(nameRange: null),
      )..question = 'A' * 200;

      final errors = pollController.validateGranularly();
      final containsNameRangeError = errors
          .map((e) => e.mapOrNull(nameRange: (e) => e))
          .nonNulls
          .isNotEmpty;

      expect(containsNameRangeError, isFalse);
    });

    test('Config Allows Unlimited Options', () {
      final pollController = StreamPollController(
        config: const PollConfig(optionsRange: null),
      );

      for (var i = 0; i < 50; i++) {
        pollController.addOption('Option $i');
      }

      final errors = pollController.validateGranularly();
      final containsOptionsRangeError = errors
          .map((e) => e.mapOrNull(optionsRange: (e) => e))
          .nonNulls
          .isNotEmpty;

      expect(containsOptionsRangeError, isFalse);
    });

    test('Config Allows Unlimited Votes', () {
      final pollController = StreamPollController(
        config: const PollConfig(allowedVotesRange: null),
      )..maxVotesAllowed = 100;

      final errors = pollController.validateGranularly();
      final containsMaxVotesAllowedError = errors
          .map((e) => e.mapOrNull(maxVotesAllowed: (e) => e))
          .nonNulls
          .isNotEmpty;

      expect(containsMaxVotesAllowedError, isFalse);
    });
  });
}
