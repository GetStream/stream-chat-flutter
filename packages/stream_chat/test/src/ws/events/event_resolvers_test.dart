// ignore_for_file: avoid_redundant_argument_values, lines_longer_than_80_chars

import 'package:stream_chat/src/ws/events/event_resolvers.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

void main() {
  group('Poll resolver events', () {
    group('pollAnswerCastedResolver', () {
      test(
        'should resolve pollVoteCasted event with answer to pollAnswerCasted',
        () {
          final pollVote = PollVote(
            id: 'vote-123',
            answerText: 'My answer',
            pollId: 'poll-123',
          );

          final event = PollVoteCastedEvent(
            poll: _poll,
            pollVote: pollVote,
            cid: 'channel-123',
          );

          final resolved = pollAnswerCastedResolver(event);

          expect(
            resolved,
            isA<PollAnswerCastedEvent>()
                .having((it) => it.type, 'type', EventType.pollAnswerCasted)
                .having((it) => it.pollVote, 'pollVote', pollVote)
                .having((it) => it.cid, 'cid', 'channel-123'),
          );
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

          final event = PollVoteChangedEvent(
            poll: _poll,
            pollVote: pollVote,
            cid: 'channel-123',
          );

          final resolved = pollAnswerCastedResolver(event);

          expect(
            resolved,
            isA<PollAnswerCastedEvent>()
                .having((it) => it.type, 'type', EventType.pollAnswerCasted)
                .having((it) => it.pollVote, 'pollVote', pollVote),
          );
        },
      );

      test('should resolve a received answer into an event that is not local', () {
        final event = PollVoteCastedEvent(
          poll: _poll,
          pollVote: PollVote(id: 'vote-123', answerText: 'My answer', pollId: 'poll-123'),
          cid: 'channel-123',
          isLocal: false,
        );

        final resolved = pollAnswerCastedResolver(event);

        expect(resolved, isA<PollAnswerCastedEvent>().having((it) => it.isLocal, 'isLocal', isFalse));
      });

      test('should return null for pollVoteCasted event with option vote', () {
        final pollVote = PollVote(
          id: 'vote-123',
          optionId: 'option-1',
          pollId: 'poll-123',
        );

        final event = PollVoteCastedEvent(
          poll: _poll,
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

        final event = PollVoteRemovedEvent(
          poll: _poll,
          pollVote: pollVote,
          cid: 'channel-123',
        );

        final resolved = pollAnswerCastedResolver(event);

        expect(resolved, isNull);
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

          final event = PollVoteRemovedEvent(
            poll: _poll,
            pollVote: pollVote,
            cid: 'channel-123',
          );

          final resolved = pollAnswerRemovedResolver(event);

          expect(
            resolved,
            isA<PollAnswerRemovedEvent>()
                .having((it) => it.type, 'type', EventType.pollAnswerRemoved)
                .having((it) => it.pollVote, 'pollVote', pollVote)
                .having((it) => it.cid, 'cid', 'channel-123'),
          );
        },
      );

      test('should return null for pollVoteRemoved event with option vote', () {
        final pollVote = PollVote(
          id: 'vote-123',
          optionId: 'option-1',
          pollId: 'poll-123',
        );

        final event = PollVoteRemovedEvent(
          poll: _poll,
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

        final event = PollVoteCastedEvent(
          poll: _poll,
          pollVote: pollVote,
          cid: 'channel-123',
        );

        final resolved = pollAnswerRemovedResolver(event);

        expect(resolved, isNull);
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

          final event = MessageNewEvent(
            message: message,
            watcherCount: 1,
            cid: 'channel-123',
          );

          final resolved = locationSharedResolver(event);

          expect(
            resolved,
            isA<LocationSharedEvent>()
                .having((it) => it.type, 'type', EventType.locationShared)
                .having((it) => it.message, 'message', message)
                .having((it) => it.cid, 'cid', 'channel-123'),
          );
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

          final event = NotificationMessageNewEvent(
            channel: ChannelModel(cid: 'messaging:channel-123'),
            message: message,
            watcherCount: 1,
            cid: 'channel-123',
          );

          final resolved = locationSharedResolver(event);

          expect(
            resolved,
            isA<LocationSharedEvent>()
                .having((it) => it.type, 'type', EventType.locationShared)
                .having((it) => it.message, 'message', message),
          );
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

          final event = MessageNewEvent(
            message: message,
            watcherCount: 1,
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

        final event = MessageUpdatedEvent(
          message: message,
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

          final event = MessageUpdatedEvent(
            message: message,
            cid: 'channel-123',
          );

          final resolved = locationUpdatedResolver(event);

          expect(
            resolved,
            isA<LocationUpdatedEvent>()
                .having((it) => it.type, 'type', EventType.locationUpdated)
                .having((it) => it.message, 'message', message)
                .having((it) => it.cid, 'cid', 'channel-123'),
          );
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

          final event = MessageUpdatedEvent(
            message: message,
            cid: 'channel-123',
          );

          final resolved = locationUpdatedResolver(event);

          expect(
            resolved,
            isA<LocationUpdatedEvent>()
                .having((it) => it.type, 'type', EventType.locationUpdated)
                .having((it) => it.message, 'message', message),
          );
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

          final event = MessageUpdatedEvent(
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

        final event = MessageNewEvent(
          message: message,
          watcherCount: 1,
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

          final event = MessageUpdatedEvent(
            message: message,
            cid: 'channel-123',
          );

          final resolved = locationExpiredResolver(event);

          expect(
            resolved,
            isA<LocationExpiredEvent>()
                .having((it) => it.type, 'type', EventType.locationExpired)
                .having((it) => it.message, 'message', message)
                .having((it) => it.cid, 'cid', 'channel-123'),
          );
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

          final event = MessageUpdatedEvent(
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

          final event = MessageUpdatedEvent(
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

        final event = MessageNewEvent(
          message: message,
          watcherCount: 1,
          cid: 'channel-123',
        );

        final resolved = locationExpiredResolver(event);

        expect(resolved, isNull);
      });
    });
  });
}

final _poll = Poll(
  id: 'poll-123',
  name: 'Test Poll',
  options: const [
    PollOption(id: 'option-1', text: 'Option 1'),
  ],
);
