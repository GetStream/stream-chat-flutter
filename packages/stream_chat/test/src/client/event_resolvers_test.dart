// ignore_for_file: avoid_redundant_argument_values

import 'package:stream_chat/src/client/event_resolvers.dart';
import 'package:stream_chat/src/core/models/event.dart';
import 'package:stream_chat/src/core/models/location.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/poll.dart';
import 'package:stream_chat/src/core/models/poll_option.dart';
import 'package:stream_chat/src/core/models/poll_vote.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/event_type.dart';
import 'package:test/test.dart';

void main() {
  group('Poll resolver events', () {
    group('pollCreatedResolver', () {
      test('should resolve messageNew event with poll to pollCreated', () {
        final poll = Poll(
          id: 'poll-123',
          name: 'Test Poll',
          options: const [
            PollOption(id: 'option-1', text: 'Option 1'),
            PollOption(id: 'option-2', text: 'Option 2'),
          ],
        );

        final event = Event(
          type: EventType.messageNew,
          poll: poll,
          cid: 'channel-123',
        );

        final resolved = pollCreatedResolver(event);

        expect(resolved, isNotNull);
        expect(resolved!.type, EventType.pollCreated);
        expect(resolved.poll, equals(poll));
        expect(resolved.cid, equals('channel-123'));
      });

      test(
        'should resolve notificationMessageNew event with poll to pollCreated',
        () {
          final poll = Poll(
            id: 'poll-123',
            name: 'Test Poll',
            options: const [
              PollOption(id: 'option-1', text: 'Option 1'),
            ],
          );

          final event = Event(
            type: EventType.notificationMessageNew,
            poll: poll,
            cid: 'channel-123',
          );

          final resolved = pollCreatedResolver(event);

          expect(resolved, isNotNull);
          expect(resolved!.type, EventType.pollCreated);
          expect(resolved.poll, equals(poll));
        },
      );

      test('should return null for messageNew event without poll', () {
        final event = Event(
          type: EventType.messageNew,
          cid: 'channel-123',
        );

        final resolved = pollCreatedResolver(event);

        expect(resolved, isNull);
      });

      test('should return null for invalid event types', () {
        final poll = Poll(
          id: 'poll-123',
          name: 'Test Poll',
          options: const [
            PollOption(id: 'option-1', text: 'Option 1'),
          ],
        );

        final event = Event(
          type: EventType.messageUpdated,
          poll: poll,
          cid: 'channel-123',
        );

        final resolved = pollCreatedResolver(event);

        expect(resolved, isNull);
      });

      test('should return null for event with null poll', () {
        final event = Event(
          type: EventType.messageNew,
          poll: null,
          cid: 'channel-123',
        );

        final resolved = pollCreatedResolver(event);

        expect(resolved, isNull);
      });
    });

    group('pollAnswerCastedResolver', () {
      test(
        'should resolve pollVoteCasted event with answer to pollAnswerCasted',
        () {
          final pollVote = PollVote(
            id: 'vote-123',
            answerText: 'My answer',
            pollId: 'poll-123',
          );

          final event = Event(
            type: EventType.pollVoteCasted,
            pollVote: pollVote,
            cid: 'channel-123',
          );

          final resolved = pollAnswerCastedResolver(event);

          expect(resolved, isNotNull);
          expect(resolved!.type, EventType.pollAnswerCasted);
          expect(resolved.pollVote, equals(pollVote));
          expect(resolved.cid, equals('channel-123'));
        },
      );

      test(
        'should resolve pollVoteChanged event with answer to pollAnswerCasted',
        () {
          final pollVote = PollVote(
            id: 'vote-123',
            answerText: 'My updated answer',
            pollId: 'poll-123',
          );

          final event = Event(
            type: EventType.pollVoteChanged,
            pollVote: pollVote,
            cid: 'channel-123',
          );

          final resolved = pollAnswerCastedResolver(event);

          expect(resolved, isNotNull);
          expect(resolved!.type, EventType.pollAnswerCasted);
          expect(resolved.pollVote, equals(pollVote));
        },
      );

      test('should return null for pollVoteCasted event with option vote', () {
        final pollVote = PollVote(
          id: 'vote-123',
          optionId: 'option-1',
          pollId: 'poll-123',
        );

        final event = Event(
          type: EventType.pollVoteCasted,
          pollVote: pollVote,
          cid: 'channel-123',
        );

        final resolved = pollAnswerCastedResolver(event);

        expect(resolved, isNull);
      });

      test('should return null for invalid event types', () {
        final pollVote = PollVote(
          id: 'vote-123',
          answerText: 'My answer',
          pollId: 'poll-123',
        );

        final event = Event(
          type: EventType.pollVoteRemoved,
          pollVote: pollVote,
          cid: 'channel-123',
        );

        final resolved = pollAnswerCastedResolver(event);

        expect(resolved, isNull);
      });

      test('should return resolved event for event with null pollVote', () {
        final event = Event(
          type: EventType.pollVoteCasted,
          pollVote: null,
          cid: 'channel-123',
        );

        final resolved = pollAnswerCastedResolver(event);

        expect(resolved, isNotNull);
        expect(resolved!.type, EventType.pollAnswerCasted);
        expect(resolved.pollVote, isNull);
      });
    });

    group('pollAnswerRemovedResolver', () {
      test(
        'should resolve pollVoteRemoved event with answer to pollAnswerRemoved',
        () {
          final pollVote = PollVote(
            id: 'vote-123',
            answerText: 'My answer',
            pollId: 'poll-123',
          );

          final event = Event(
            type: EventType.pollVoteRemoved,
            pollVote: pollVote,
            cid: 'channel-123',
          );

          final resolved = pollAnswerRemovedResolver(event);

          expect(resolved, isNotNull);
          expect(resolved!.type, EventType.pollAnswerRemoved);
          expect(resolved.pollVote, equals(pollVote));
          expect(resolved.cid, equals('channel-123'));
        },
      );

      test('should return null for pollVoteRemoved event with option vote', () {
        final pollVote = PollVote(
          id: 'vote-123',
          optionId: 'option-1',
          pollId: 'poll-123',
        );

        final event = Event(
          type: EventType.pollVoteRemoved,
          pollVote: pollVote,
          cid: 'channel-123',
        );

        final resolved = pollAnswerRemovedResolver(event);

        expect(resolved, isNull);
      });

      test('should return null for invalid event types', () {
        final pollVote = PollVote(
          id: 'vote-123',
          answerText: 'My answer',
          pollId: 'poll-123',
        );

        final event = Event(
          type: EventType.pollVoteCasted,
          pollVote: pollVote,
          cid: 'channel-123',
        );

        final resolved = pollAnswerRemovedResolver(event);

        expect(resolved, isNull);
      });

      test('should return resolved event for event with null pollVote', () {
        final event = Event(
          type: EventType.pollVoteRemoved,
          pollVote: null,
          cid: 'channel-123',
        );

        final resolved = pollAnswerRemovedResolver(event);

        expect(resolved, isNotNull);
        expect(resolved!.type, EventType.pollAnswerRemoved);
        expect(resolved.pollVote, isNull);
      });
    });
  });

  group('Location resolver events', () {
    group('locationSharedResolver', () {
      test(
        'should resolve messageNew event with sharedLocation to locationShared',
        () {
          final location = Location(
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device-123',
          );

          final message = Message(
            id: 'message-123',
            text: 'Check out this location',
            sharedLocation: location,
            user: User(id: 'user-123'),
          );

          final event = Event(
            type: EventType.messageNew,
            message: message,
            cid: 'channel-123',
          );

          final resolved = locationSharedResolver(event);

          expect(resolved, isNotNull);
          expect(resolved!.type, EventType.locationShared);
          expect(resolved.message, equals(message));
          expect(resolved.cid, equals('channel-123'));
        },
      );

      test(
        'should resolve notificationMessageNew event with sharedLocation to locationShared',
        () {
          final location = Location(
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device-123',
          );

          final message = Message(
            id: 'message-123',
            text: 'Check out this location',
            sharedLocation: location,
            user: User(id: 'user-123'),
          );

          final event = Event(
            type: EventType.notificationMessageNew,
            message: message,
            cid: 'channel-123',
          );

          final resolved = locationSharedResolver(event);

          expect(resolved, isNotNull);
          expect(resolved!.type, EventType.locationShared);
          expect(resolved.message, equals(message));
        },
      );

      test(
        'should return null for messageNew event without sharedLocation',
        () {
          final message = Message(
            id: 'message-123',
            text: 'Just a regular message',
            user: User(id: 'user-123'),
          );

          final event = Event(
            type: EventType.messageNew,
            message: message,
            cid: 'channel-123',
          );

          final resolved = locationSharedResolver(event);

          expect(resolved, isNull);
        },
      );

      test('should return null for invalid event types', () {
        final location = Location(
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device-123',
        );

        final message = Message(
          id: 'message-123',
          text: 'Check out this location',
          sharedLocation: location,
          user: User(id: 'user-123'),
        );

        final event = Event(
          type: EventType.messageUpdated,
          message: message,
          cid: 'channel-123',
        );

        final resolved = locationSharedResolver(event);

        expect(resolved, isNull);
      });

      test('should return null for event with null message', () {
        final event = Event(
          type: EventType.messageNew,
          message: null,
          cid: 'channel-123',
        );

        final resolved = locationSharedResolver(event);

        expect(resolved, isNull);
      });
    });

    group('locationUpdatedResolver', () {
      test(
        'should resolve messageUpdated event with active live location to locationUpdated',
        () {
          final location = Location(
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device-123',
            endAt: DateTime.now().add(const Duration(hours: 1)),
          );

          final message = Message(
            id: 'message-123',
            text: 'Live location sharing',
            sharedLocation: location,
            user: User(id: 'user-123'),
          );

          final event = Event(
            type: EventType.messageUpdated,
            message: message,
            cid: 'channel-123',
          );

          final resolved = locationUpdatedResolver(event);

          expect(resolved, isNotNull);
          expect(resolved!.type, EventType.locationUpdated);
          expect(resolved.message, equals(message));
          expect(resolved.cid, equals('channel-123'));
        },
      );

      test(
        'should resolve messageUpdated event with static location to locationUpdated',
        () {
          final location = Location(
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device-123',
            // No endAt means static location
          );

          final message = Message(
            id: 'message-123',
            text: 'Static location sharing',
            sharedLocation: location,
            user: User(id: 'user-123'),
          );

          final event = Event(
            type: EventType.messageUpdated,
            message: message,
            cid: 'channel-123',
          );

          final resolved = locationUpdatedResolver(event);

          expect(resolved, isNotNull);
          expect(resolved!.type, EventType.locationUpdated);
          expect(resolved.message, equals(message));
        },
      );

      test(
        'should return null for messageUpdated event with expired live location',
        () {
          final location = Location(
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device-123',
            endAt: DateTime.now().subtract(const Duration(hours: 1)),
          );

          final message = Message(
            id: 'message-123',
            text: 'Expired location sharing',
            sharedLocation: location,
            user: User(id: 'user-123'),
          );

          final event = Event(
            type: EventType.messageUpdated,
            message: message,
            cid: 'channel-123',
          );

          final resolved = locationUpdatedResolver(event);

          expect(resolved, isNull);
        },
      );

      test('should return null for invalid event types', () {
        final location = Location(
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device-123',
        );

        final message = Message(
          id: 'message-123',
          text: 'Check out this location',
          sharedLocation: location,
          user: User(id: 'user-123'),
        );

        final event = Event(
          type: EventType.messageNew,
          message: message,
          cid: 'channel-123',
        );

        final resolved = locationUpdatedResolver(event);

        expect(resolved, isNull);
      });

      test('should return null for event with null message', () {
        final event = Event(
          type: EventType.messageUpdated,
          message: null,
          cid: 'channel-123',
        );

        final resolved = locationUpdatedResolver(event);

        expect(resolved, isNull);
      });
    });

    group('locationExpiredResolver', () {
      test(
        'should resolve messageUpdated event with expired live location to locationExpired',
        () {
          final location = Location(
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device-123',
            endAt: DateTime.now().subtract(const Duration(hours: 1)),
          );

          final message = Message(
            id: 'message-123',
            text: 'Expired location sharing',
            sharedLocation: location,
            user: User(id: 'user-123'),
          );

          final event = Event(
            type: EventType.messageUpdated,
            message: message,
            cid: 'channel-123',
          );

          final resolved = locationExpiredResolver(event);

          expect(resolved, isNotNull);
          expect(resolved!.type, EventType.locationExpired);
          expect(resolved.message, equals(message));
          expect(resolved.cid, equals('channel-123'));
        },
      );

      test(
        'should return null for messageUpdated event with active live location',
        () {
          final location = Location(
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device-123',
            endAt: DateTime.now().add(const Duration(hours: 1)),
          );

          final message = Message(
            id: 'message-123',
            text: 'Active location sharing',
            sharedLocation: location,
            user: User(id: 'user-123'),
          );

          final event = Event(
            type: EventType.messageUpdated,
            message: message,
            cid: 'channel-123',
          );

          final resolved = locationExpiredResolver(event);

          expect(resolved, isNull);
        },
      );

      test(
        'should return null for messageUpdated event with static location',
        () {
          final location = Location(
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device-123',
            // No endAt means static location
          );

          final message = Message(
            id: 'message-123',
            text: 'Static location sharing',
            sharedLocation: location,
            user: User(id: 'user-123'),
          );

          final event = Event(
            type: EventType.messageUpdated,
            message: message,
            cid: 'channel-123',
          );

          final resolved = locationExpiredResolver(event);

          expect(resolved, isNull);
        },
      );

      test('should return null for invalid event types', () {
        final location = Location(
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device-123',
          endAt: DateTime.now().subtract(const Duration(hours: 1)),
        );

        final message = Message(
          id: 'message-123',
          text: 'Expired location sharing',
          sharedLocation: location,
          user: User(id: 'user-123'),
        );

        final event = Event(
          type: EventType.messageNew,
          message: message,
          cid: 'channel-123',
        );

        final resolved = locationExpiredResolver(event);

        expect(resolved, isNull);
      });

      test('should return null for event with null message', () {
        final event = Event(
          type: EventType.messageUpdated,
          message: null,
          cid: 'channel-123',
        );

        final resolved = locationExpiredResolver(event);

        expect(resolved, isNull);
      });
    });
  });
}
