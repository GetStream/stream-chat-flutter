import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  group('ClientState mutation guards', () {
    // The old suite exercised these guards on a client that was never
    // connected; skipping the connect phase preserves that setup.
    chatClientTest(
      '`state.channels` returns an unmodifiable view',
      connect: (_) {},
      body: (tester) async {
        final channel = Channel.fromState(
          tester.client,
          createDefaultChannelState(channel: createDefaultChannelModel(cid: 'messaging:c1')),
        );
        tester.clientState.addChannels({'messaging:c1': channel});

        expect(tester.clientState.channels, hasLength(1));
        expect(() => tester.clientState.channels.remove('messaging:c1'), throwsUnsupportedError);
        expect(() => tester.clientState.channels.clear(), throwsUnsupportedError);
        expect(() => tester.clientState.channels['messaging:c2'] = channel, throwsUnsupportedError);
      },
    );

    chatClientTest(
      '`state.users` returns an unmodifiable view',
      connect: (_) {},
      body: (tester) async {
        tester.clientState.updateUser(User(id: 'u1'));

        expect(tester.clientState.users.containsKey('u1'), isTrue);
        expect(() => tester.clientState.users.remove('u1'), throwsUnsupportedError);
        expect(() => tester.clientState.users.clear(), throwsUnsupportedError);
      },
    );

    chatClientTest(
      '`state.activeLiveLocations` returns an unmodifiable view',
      connect: (_) {},
      body: (tester) async {
        expect(() => tester.clientState.activeLiveLocations.clear(), throwsUnsupportedError);
      },
    );

    chatClientTest(
      '`removeChannel` emits a fresh map so distinct subscribers see the change',
      connect: (_) {},
      body: (tester) async {
        final channel = Channel.fromState(
          tester.client,
          createDefaultChannelState(channel: createDefaultChannelModel(cid: 'messaging:c1')),
        );
        tester.clientState.addChannels({'messaging:c1': channel});

        final received = <Map<String, Channel>>[];
        // Skip the BehaviorSubject's replay of the current value to new subscribers.
        final sub = tester.clientState.channelsStream.distinct().skip(1).listen(received.add);

        tester.clientState.removeChannel('messaging:c1');
        await Future<void>.delayed(Duration.zero);

        expect(received, hasLength(1));
        expect(received.single, isEmpty);

        await sub.cancel();
      },
    );

    chatClientTest(
      'initial seeded values are unmodifiable (before any write)',
      connect: (_) {},
      body: (tester) async {
        // Fresh client, no mutations yet — subscribers connecting at this point
        // still see unmodifiable seeds.
        expect(() => tester.clientState.channels.clear(), throwsUnsupportedError);
        expect(() => tester.clientState.users.clear(), throwsUnsupportedError);
        expect(() => tester.clientState.activeLiveLocations.clear(), throwsUnsupportedError);
      },
    );

    chatClientTest(
      '`channelsStream` emits unmodifiable maps',
      connect: (_) {},
      body: (tester) async {
        final received = <Map<String, Channel>>[];
        final sub = tester.clientState.channelsStream.listen(received.add);

        final channel = Channel.fromState(
          tester.client,
          createDefaultChannelState(channel: createDefaultChannelModel(cid: 'messaging:c1')),
        );
        tester.clientState.addChannels({'messaging:c1': channel});
        await Future<void>.delayed(Duration.zero);

        // Both the initial seed and the post-write emission must be unmodifiable.
        expect(received, hasLength(greaterThanOrEqualTo(2)));
        for (final emitted in received) {
          expect(emitted.clear, throwsUnsupportedError);
        }

        await sub.cancel();
      },
    );

    chatClientTest(
      '`usersStream` emits unmodifiable maps',
      connect: (_) {},
      body: (tester) async {
        final received = <Map<String, User>>[];
        final sub = tester.clientState.usersStream.listen(received.add);

        tester.clientState.updateUser(User(id: 'u1'));
        await Future<void>.delayed(Duration.zero);

        expect(received, hasLength(greaterThanOrEqualTo(2)));
        for (final emitted in received) {
          expect(emitted.clear, throwsUnsupportedError);
        }

        await sub.cancel();
      },
    );

    chatClientTest(
      '`activeLiveLocationsStream` emits unmodifiable lists',
      connect: (_) {},
      body: (tester) async {
        final received = <List<Location>>[];
        final sub = tester.clientState.activeLiveLocationsStream.listen(received.add);

        tester.clientState.activeLiveLocations = const [];
        await Future<void>.delayed(Duration.zero);

        expect(received, isNotEmpty);
        for (final emitted in received) {
          expect(emitted.clear, throwsUnsupportedError);
        }

        await sub.cancel();
      },
    );
  });

  // The unread counts are derived from the current user, so assigning a new
  // one has to republish them.
  chatClientTest(
    'setting the `currentUser` should also compute and update the unreadCounts',
    body: (tester) async {
      final state = tester.clientState;
      // Derived from the harness user rather than read back out of the state,
      // so this still asserts that connecting produced the expected user.
      final initialUser = OwnUser.fromUser(tester.user);

      expect(state.currentUser, initialUser);
      expect(state.totalUnreadCount, 0);
      expect(state.unreadChannels, 0);

      final updateUser = initialUser.copyWith(
        totalUnreadCount: 33,
        unreadChannels: 33,
      );
      state.currentUser = updateUser;

      expect(state.currentUser, updateUser);
      expect(state.totalUnreadCount, 33);
      expect(state.unreadChannels, 33);
    },
  );
}
