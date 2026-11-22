/// Channel State Benchmark
///
/// Measures how a channel's state takes updates, with and without a
/// truncation time, for channels holding a few hundred messages up to a
/// livestream's tens of thousands. Each score is the time of a single update,
/// in microseconds, averaged over batches that let the event loop run in
/// between, as it does in an app.
///
/// Usage (run from `packages/stream_chat`):
///   dart run benchmark/channel_state_benchmark.dart
///
/// For numbers close to a release build, compile it ahead of time first:
///   dart compile exe benchmark/channel_state_benchmark.dart -o benchmark.exe
///   ./benchmark.exe
library;

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:stream_chat/stream_chat.dart';

Future<void> main() async {
  final client = StreamChatClient(
    'benchmark',
    logConfig: const StreamLogConfig(priority: StreamLogPriority.none),
  );

  for (final count in [300, 1000, 30000]) {
    for (final truncated in [false, true]) {
      final fixture = _Fixture(client, count: count, truncated: truncated);
      final label = 'n=$count, ${truncated ? 'truncated' : 'not truncated'}';

      await _UpdateBenchmark('local update ($label)', fixture, (state) {
        state.updateChannelState(state.channelState.copyWith(watcherCount: 3));
      }).report();

      await _UpdateBenchmark('local page of 25 ($label)', fixture, (state) {
        state.updateChannelState(ChannelState(messages: fixture.newPage));
      }).report();

      await _UpdateBenchmark('server page of 25 ($label)', fixture, (state) {
        state.updateChannelStateFromServer(fixture.serverPage(fixture.cutoff, fixture.newPage));
      }).report();

      await _UpdateBenchmark('server page of 25 older messages ($label)', fixture, (state) {
        state.updateChannelStateFromServer(fixture.serverPage(fixture.cutoff, fixture.olderPage));
      }).report();

      await _UpdateBenchmark('new message ($label)', fixture, (state) {
        state.addNewMessage(fixture.newMessage);
      }).report();
    }

    // These change the channel for good, so each update gets a new channel,
    // whose creation is measured on its own to subtract.
    final fixture = _Fixture(client, count: count, truncated: true);
    final label = 'n=$count';
    await _NewChannelBenchmark('create channel ($label)', fixture, (_) {}).report();
    await _NewChannelBenchmark('server page moving the cutoff past half ($label)', fixture, (state) {
      state.updateChannelStateFromServer(fixture.serverPage(fixture.halfway, fixture.newPage));
    }).report();
    await _NewChannelBenchmark('truncate past half ($label)', fixture, (state) {
      state.truncate(truncatedAt: fixture.halfway);
    }).report();
  }

  client.dispose();
}

// Builds the channels and payloads the benchmarks update with.
class _Fixture {
  _Fixture(this.client, {required this.count, required bool truncated})
    : cutoff = truncated ? _start.subtract(const Duration(days: 1)) : null,
      halfway = _start.add(Duration(seconds: count ~/ 2));

  static final _start = DateTime.utc(2026);
  static final _user = User(id: 'other-user');

  final StreamChatClient client;
  final int count;

  // Before every stored message, as after a truncation already applied.
  final DateTime? cutoff;
  final DateTime halfway;

  late final _messages = [for (var i = 0; i < count; i++) _message(i)];
  late final newPage = [for (var i = count; i < count + 25; i++) _message(i)];
  late final olderPage = [
    for (var i = 0; i < 25; i++)
      _message(i).copyWith(id: 'older-$i', createdAt: _start.subtract(const Duration(days: 2))),
  ];
  late final newMessage = _message(count + 100);

  Channel channel() => Channel.fromState(
    client,
    ChannelState(channel: _model(cutoff), messages: _messages),
  );

  ChannelState serverPage(DateTime? truncatedAt, List<Message> messages) {
    return ChannelState(channel: _model(truncatedAt), messages: messages);
  }

  static ChannelModel _model(DateTime? truncatedAt) {
    return ChannelModel(id: 'live', type: 'livestream', truncatedAt: truncatedAt);
  }

  static Message _message(int i) => Message(
    id: 'message-$i',
    text: 'hello $i',
    user: _user,
    createdAt: _start.add(Duration(seconds: i)),
  );
}

// Runs [runOnce] in batches, letting the event loop run after each batch so
// the timers the updates schedule fire, as they would in an app.
abstract class _BatchBenchmark extends AsyncBenchmarkBase {
  _BatchBenchmark(super.name);

  static const _batch = 100;

  void runOnce();

  @override
  Future<void> run() async {
    for (var i = 0; i < _batch; i++) {
      runOnce();
    }
    await Future<void>.delayed(Duration.zero);
  }

  // Reports the time of a single [runOnce], not of a batch.
  @override
  Future<void> report() async {
    final score = await measure() / _batch;
    print('$name(RunTime): ${score.toStringAsFixed(2)} us.');
  }
}

// Measures one [update] of the same channel.
class _UpdateBenchmark extends _BatchBenchmark {
  _UpdateBenchmark(super.name, this.fixture, this.update);

  final _Fixture fixture;
  final void Function(ChannelClientState state) update;
  late Channel _channel;

  @override
  Future<void> setup() async => _channel = fixture.channel();

  @override
  Future<void> teardown() async => _channel.dispose();

  @override
  void runOnce() => update(_channel.state!);
}

// Measures creating a channel and applying one [update] to it.
class _NewChannelBenchmark extends _BatchBenchmark {
  _NewChannelBenchmark(super.name, this.fixture, this.update);

  final _Fixture fixture;
  final void Function(ChannelClientState state) update;

  @override
  void runOnce() {
    final channel = fixture.channel();
    update(channel.state!);
    channel.dispose();
  }
}
