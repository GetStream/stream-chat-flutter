// Performance regression tests for [StreamMessageListView].
//
// These exercise the ingest → filter → build → layout pipeline that
// dominates CPU profiles of the manual benchmark (see
// `sample_app/lib/benchmark/benchmark_page.dart`). Each scenario warms
// up first, then runs N iterations and reports median + p95 so noise
// on shared CI doesn't false-positive.
//
// Thresholds are deliberately generous (~3-5× a fast laptop's local
// run) — the point is to catch big-O regressions, not penalise a
// slower CI runner.
//
// `flutter test` runs under `AutomatedTestWidgetsFlutterBinding`,
// which doesn't drive a real GPU. Numbers here reflect Dart-thread
// build + layout cost only, NOT raster. That's still where most
// regressions on this widget tree show up.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../test_utils/data_generator.dart';
import '../mocks.dart';

void main() {
  late StreamChatClient client;
  late ClientState clientState;
  late Channel channel;
  late ChannelClientState channelClientState;
  late StreamController<List<Message>> messageStreamController;

  // Mutable backing for `channelClientState.messages` so we can update
  // the snapshot the list reads after each emit, mimicking the SDK's
  // own behaviour (channel.state.messages is always the latest).
  var currentMessages = <Message>[];

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(OwnUser(id: 'ownid'));
    when(() => clientState.currentUserStream)
        .thenAnswer((_) => Stream.value(OwnUser(id: 'ownid')));

    channel = MockChannel();
    when(() => channel.client).thenReturn(client);
    when(() => channel.on(any(), any(), any(), any()))
        .thenAnswer((_) => const Stream.empty());

    channelClientState = MockChannelState();
    when(() => channel.state).thenReturn(channelClientState);

    messageStreamController = StreamController<List<Message>>.broadcast();
    when(() => channelClientState.messagesStream)
        .thenAnswer((_) => messageStreamController.stream);
    // Re-evaluated every call — gives the list a fresh snapshot
    // whenever it asks `channel.state.messages`.
    when(() => channelClientState.messages)
        .thenAnswer((_) => List.of(currentMessages));
    when(() => channelClientState.threadsStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.isUpToDate).thenReturn(true);
    when(() => channelClientState.isUpToDateStream)
        .thenAnswer((_) => Stream.value(true));
    when(() => channelClientState.unreadCountStream)
        .thenAnswer((_) => Stream.value(0));
    when(() => channelClientState.unreadCount).thenReturn(0);
    when(() => channelClientState.readStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.read).thenReturn([]);
    when(() => channelClientState.membersStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.members).thenReturn([]);
    when(() => channelClientState.currentUserRead).thenReturn(null);
    when(() => channelClientState.currentUserReadStream)
        .thenAnswer((_) => const Stream.empty());
  });

  tearDown(() async {
    await messageStreamController.close();
    currentMessages = <Message>[];
  });

  Widget appWith(Channel c) => MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: c,
            child: const StreamMessageListView(),
          ),
        ),
      );

  testWidgets(
    'cold build · 1000 messages',
    (tester) async {
      const iterations = 5;
      const warmup = 1;
      final users = generateUsers(5);
      final base = generateConversation(1000, users: users);

      final samples = <int>[];
      for (var i = 0; i < warmup + iterations; i++) {
        currentMessages = List.of(base);
        final sw = Stopwatch()..start();
        await tester.pumpWidget(appWith(channel));
        await tester.pump();
        sw.stop();
        if (i >= warmup) samples.add(sw.elapsedMicroseconds);
        // Tear down between runs so each iteration is a fresh mount.
        await tester.pumpWidget(const SizedBox());
        await tester.pump();
      }

      _report('cold-build-1000', samples);
      // Generous budget — flags >5× regression. Locally <300 ms on a
      // recent laptop; CI runners are often 2-3× slower.
      expect(
        _medianMs(samples),
        lessThan(2000),
        reason: 'cold build median exceeded budget',
      );
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  testWidgets(
    'batch insert · 100 base → +1000 at once',
    (tester) async {
      const iterations = 5;
      const warmup = 1;
      final users = generateUsers(5);

      final samples = <int>[];
      for (var i = 0; i < warmup + iterations; i++) {
        currentMessages = generateConversation(100, users: users);
        await tester.pumpWidget(appWith(channel));
        await tester.pump();

        final batch = generateConversation(1000, users: users);
        currentMessages = [...batch, ...currentMessages];

        final sw = Stopwatch()..start();
        messageStreamController.add(List.of(currentMessages));
        await tester.pump();
        sw.stop();
        if (i >= warmup) samples.add(sw.elapsedMicroseconds);

        await tester.pumpWidget(const SizedBox());
        await tester.pump();
      }

      _report('batch-insert-1000', samples);
      expect(
        _medianMs(samples),
        lessThan(2000),
        reason: 'batch insert median exceeded budget',
      );
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  testWidgets(
    'stream insert · 100 base · +200 trickled one at a time',
    (tester) async {
      const insertCount = 200;
      const iterations = 3;
      const warmup = 1;
      final users = generateUsers(5);

      final samples = <int>[];
      for (var i = 0; i < warmup + iterations; i++) {
        currentMessages = generateConversation(100, users: users);
        await tester.pumpWidget(appWith(channel));
        await tester.pump();

        final perInsertUs = <int>[];
        for (var k = 0; k < insertCount; k++) {
          final newMsg = Message(
            id: 'bench-${i}_$k',
            text: 'bench $k',
            user: users[k % users.length],
            createdAt: DateTime.now().add(Duration(microseconds: k)),
          );
          currentMessages = [newMsg, ...currentMessages];
          final sw = Stopwatch()..start();
          messageStreamController.add(List.of(currentMessages));
          await tester.pump();
          sw.stop();
          perInsertUs.add(sw.elapsedMicroseconds);
        }

        if (i >= warmup) {
          // Sum of all per-insert times for this iteration.
          samples.add(perInsertUs.reduce((a, b) => a + b));
          _report('stream-insert-per-step (iter $i)', perInsertUs);
        }

        await tester.pumpWidget(const SizedBox());
        await tester.pump();
      }

      _report('stream-insert-total ($insertCount inserts)', samples);
      // Each step is O(N) right now because `_rebuildKeyIndexMap` and
      // `MessageListCoreState._filterAndReverse` re-walk the full
      // list every build (both visible in the CPU profile at ~6 %
      // and ~3 %). Baseline on a fast laptop ≈ 3.2 s for 200 trickled
      // inserts; budget at ~2.5× to catch regressions while still
      // passing on slower CI runners.
      expect(
        _medianMs(samples),
        lessThan(8000),
        reason: 'stream insert total median exceeded budget',
      );
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}

/// Reports min / median / p95 / max in milliseconds for a list of
/// microsecond-valued samples. Goes to stdout — `flutter test` prints
/// it alongside the test name so trends are visible in CI logs.
void _report(String label, List<int> microsSamples) {
  if (microsSamples.isEmpty) return;
  final sorted = [...microsSamples]..sort();
  final medianMs = sorted[sorted.length ~/ 2] / 1000.0;
  final p95Index = (sorted.length * 0.95).floor().clamp(0, sorted.length - 1);
  final p95Ms = sorted[p95Index] / 1000.0;
  final minMs = sorted.first / 1000.0;
  final maxMs = sorted.last / 1000.0;
  // ignore: avoid_print
  print(
    '  bench[$label] '
    'median=${medianMs.toStringAsFixed(1)}ms '
    'p95=${p95Ms.toStringAsFixed(1)}ms '
    'min=${minMs.toStringAsFixed(1)}ms '
    'max=${maxMs.toStringAsFixed(1)}ms '
    'n=${sorted.length}',
  );
}

double _medianMs(List<int> microsSamples) {
  if (microsSamples.isEmpty) return double.infinity;
  final sorted = [...microsSamples]..sort();
  return sorted[sorted.length ~/ 2] / 1000.0;
}
