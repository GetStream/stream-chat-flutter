// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:collection';
import 'dart:io' show ProcessInfo;
import 'dart:math' show Random;
import 'dart:ui' show FramePhase;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A scratch page for benchmarking [StreamMessageListView] under load.
///
/// The page injects synthetic `message.new` events through
/// `client.handleEvent` (the same entry point the WebSocket pipeline uses)
/// at a configurable rate (default 100 msg/s) when "Start flood" is tapped.
/// Each event picks a random
/// author and a random message text from a varied corpus — short replies,
/// emoji, questions, mentions, links, code blocks, and long paragraphs —
/// so the rendered list mixes own/other bubbles and exercises a realistic
/// spread of text-layout costs.
///
/// Use the **LIMIT** chips to cap how many messages the list keeps in memory,
/// the **FLOOD** chips to set how many synthetic events to inject before the
/// flood auto-stops, and the **SPEED** chips to set the injection rate
/// (msg/s). The combination of LIMIT + FLOOD + SPEED makes a single recording
/// cleanly comparable across builds.
///
/// ## Why the dashboard doesn't taint the measurement
///
/// Naively, a benchmark page that calls `setState` on every metric tick
/// and on every ingested message will pollute the very FPS number it's
/// trying to report — each `setState` here would rebuild the entire
/// page subtree, including [StreamMessageListView], and that rebuild
/// shows up in `addTimingsCallback`.
///
/// To keep the list's frame work isolated:
///
///  * Metric fields ([_avgFrameMs], [_currentRssBytes], [_messageCount],
///    etc.) are plain `State` fields. We never call `setState` for
///    them.
///  * A 500 ms timer pulls those fields into an immutable
///    [_DashboardSnapshot] and writes it to [_snapshotNotifier].
///  * Only [_DashboardPanel] (and the AppBar "LIVE …" counter) listen
///    to that notifier via [ValueListenableBuilder]. Their rebuilds
///    don't bubble up past the listener boundary.
///  * The parent `setState` is reserved for **user-driven** changes
///    (chip selections, start/stop flood). During a recording the
///    parent rebuilds 0–2 times total.
///
/// So [StreamMessageListView] sees a flood-stream of new messages plus
/// the two start/stop rebuilds — nothing else from the benchmark UI.
///
/// Use `flutter run --profile` so frame timings and memory reflect
/// release-grade work. Open Flutter DevTools alongside for the Memory tab.
class BenchmarkPage extends StatefulWidget {
  const BenchmarkPage({
    super.key,
    required this.channel,
  });

  final Channel channel;

  @override
  State<BenchmarkPage> createState() => _BenchmarkPageState();
}

class _BenchmarkPageState extends State<BenchmarkPage> {
  static const _limitOptions = <int?>[null, 100, 500, 1000, 2500];
  static const _floodTargetOptions = <int?>[
    null,
    500,
    1000,
    2500,
    5000,
    10000,
  ];
  static const _speedOptions = <int>[10, 25, 50, 100, 200, 500];

  // Time-based window keeps the sampled set comparable across devices
  // with different refresh rates: 2 s on a 60 Hz panel is 120 frames,
  // on 120 Hz it's 240. A frame-count window would over-smooth on the
  // fast device and lag on the slow one.
  static const _kWindowDuration = Duration(seconds: 2);
  // First N frames after a flood starts are dropped from the window —
  // they include shader warm-up, image decode for new avatars, and JIT
  // promotion that don't represent steady-state work.
  static const _kWarmupFrames = 30;

  // Universal "smooth" target — frames longer than one 60 Hz refresh
  // interval (16.67 ms) are what users perceive as jank. Used in
  // preference to the device's actual vsync deadline on high-refresh
  // displays: at 90 Hz the strict budget is 11.11 ms and almost every
  // chat frame exceeds it, which would report 100 % jank for a chat
  // that's still perfectly smooth at 60 fps. Matches Flutter DevTools'
  // own "slow frame" convention.
  static const _kJankBudgetMs = 1000.0 / 60.0;

  // Configuration — changed by the user via chips. `setState` is fine
  // here because chip taps are not part of the measured window.
  int? _limit = 100;
  int? _floodTarget = 1000;
  int _speed = 100;

  // Frame samples — written every frame by `addTimingsCallback`. Each
  // sample carries `vsyncStart` so we can prune by wall-clock time
  // and separately track build / raster cost.
  final Queue<_FrameSample> _samples = Queue<_FrameSample>();
  int _warmupFramesRemaining = 0;
  double _avgFrameMs = 0;
  double _worstFrameMs = 0;
  double _p95FrameMs = 0;
  double _jankPct = 0;
  // Fraction of frames whose totalSpan was within one *device* vsync —
  // i.e., frames that actually hit the panel's native refresh rate. On
  // 60 Hz this is the same as "not jank"; on 90/120 Hz it's stricter
  // than [_jankPct] and tells you how often you're delivering buttery
  // motion at the device's max.
  double _refreshHitPct = 0;
  // Display refresh rate snapshot, captured once at init. `1 / rate`
  // is the per-frame deadline we use to count jank.
  late final double _vsyncMs;

  // Message counts — written from the channel state listener on every
  // ingested batch. Never trigger a `setState`; sampled at 2 Hz.
  int _messageCount = 0;
  final Set<String> _seenMessageIds = <String>{};
  int _totalSeen = 0;

  // Memory — sampled inside the 2 Hz tick (the `currentRss` syscall is
  // not free, so we don't want it on the hot path).
  int _currentRssBytes = 0;
  int _peakRssBytes = 0;
  int _baselineRssBytes = 0;

  // Flood control. `_isFlooding` is derived from `_floodTimer != null`
  // and changes only on the start/stop button taps — a `setState` per
  // recording, not per frame.
  Timer? _floodTimer;
  int _floodSentCount = 0;
  bool get _isFlooding => _floodTimer != null;
  final _floodRandom = Random(42);

  // Default to collapsed so the message list gets the full viewport —
  // the realistic case we want to measure. The slim header strip stays
  // visible so you can still watch FPS/mem during a run. Expand to
  // change chip values or reset between recordings.
  bool _controlsExpanded = false;

  // When true, each row is replaced with a single-line `ListTile`-style
  // bubble instead of [StreamMessageWidget]. That isolates the SPL +
  // SDK + list-view costs from the heavy per-message widget tree
  // (markdown, attachments, reactions, timestamps, etc.). Toggle this
  // and re-run a flood to see how much of the profile is "list
  // machinery" vs "message bubble construction".
  bool _lightweightItems = false;

  // When true, [_publishSnapshot] is a no-op so the post-flood values
  // (the ones the user cares about) survive any drift from scrolling
  // or other interactions after the run ends. Cleared at next
  // start / reset.
  bool _snapshotFrozen = false;

  // RSS is sampled on the UI thread — to keep that syscall load low we
  // skip it on most snapshot ticks and only read every Nth one. At
  // 500 ms ticks, every 4th = once every 2 s, plenty resolution for
  // memory growth.
  static const _rssSampleInterval = 4;
  int _rssSampleCounter = _rssSampleInterval;

  late StreamSubscription<List<Message>> _messagesSub;

  // Single immutable snapshot consumed by the dashboard. Republished by
  // the 500 ms stats timer; the dashboard rebuilds at 2 Hz instead of
  // on every frame / every message.
  final _snapshotNotifier = ValueNotifier<_DashboardSnapshot>(_DashboardSnapshot.empty);
  Timer? _statsTimer;

  @override
  void initState() {
    super.initState();
    final view = WidgetsBinding.instance.platformDispatcher.implicitView;
    final refreshRate = view?.display.refreshRate ?? 60.0;
    _vsyncMs = 1000.0 / refreshRate;
    SchedulerBinding.instance.addTimingsCallback(_onFrameTimings);
    _statsTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => _publishSnapshot(),
    );
    final initial = widget.channel.state?.messages ?? const <Message>[];
    _ingest(initial);
    _messagesSub = widget.channel.state!.messagesStream.listen((messages) {
      if (!mounted) return;
      // No `setState` here — see the class-level doc comment. The 2 Hz
      // tick will publish the new counts into the dashboard snapshot.
      _ingest(messages);
    });
    _baselineRssBytes = _readRss();
    _currentRssBytes = _baselineRssBytes;
    _peakRssBytes = _baselineRssBytes;
    _publishSnapshot();

    // Pre-warm avatar decode so the first batch of flood messages
    // doesn't pay decode cost inside the measured window. Uses the
    // post-frame callback because `precacheImage` needs the inherited
    // ImageCache, which is only available once the tree is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      for (final user in _floodAuthors) {
        final url = user.extraData['image'];
        if (url is String && url.isNotEmpty) {
          precacheImage(NetworkImage(url), context).ignore();
        }
      }
    });
  }

  @override
  void dispose() {
    _floodTimer?.cancel();
    SchedulerBinding.instance.removeTimingsCallback(_onFrameTimings);
    _statsTimer?.cancel();
    _messagesSub.cancel();
    _snapshotNotifier.dispose();
    super.dispose();
  }

  int _readRss() {
    if (kIsWeb) return 0;
    try {
      return ProcessInfo.currentRss;
    } catch (_) {
      return 0;
    }
  }

  void _ingest(List<Message> messages) {
    for (final message in messages) {
      _seenMessageIds.add(message.id);
    }
    _totalSeen = _seenMessageIds.length;
    _messageCount = messages.length;
  }

  void _resetCounters() {
    final rss = _readRss();
    _seenMessageIds.clear();
    _totalSeen = 0;
    _ingest(widget.channel.state?.messages ?? const <Message>[]);
    _baselineRssBytes = rss;
    _currentRssBytes = rss;
    _peakRssBytes = rss;
    _floodSentCount = 0;
    _resetFrameStats();
    _snapshotFrozen = false;
    _publishSnapshot();
  }

  void _resetFrameStats() {
    _samples.clear();
    _avgFrameMs = 0;
    _worstFrameMs = 0;
    _p95FrameMs = 0;
    _jankPct = 0;
    _refreshHitPct = 0;
  }

  void _onFrameTimings(List<FrameTiming> timings) {
    for (final t in timings) {
      // Skip the warm-up tail right after a flood start — shader
      // compilation, avatar image decode, and JIT promotion spike here
      // and would otherwise drag the steady-state average up.
      if (_warmupFramesRemaining > 0) {
        _warmupFramesRemaining--;
        continue;
      }
      _samples.add(
        _FrameSample(
          vsyncStartUs: t.timestampInMicroseconds(FramePhase.vsyncStart),
          totalMs: t.totalSpan.inMicroseconds / 1000.0,
          buildMs: t.buildDuration.inMicroseconds / 1000.0,
          rasterMs: t.rasterDuration.inMicroseconds / 1000.0,
        ),
      );
    }
    // Prune to the time-based window using vsyncStart from the most
    // recent frame as "now" — frame timings can arrive batched and
    // wall-clock may have drifted from engine time.
    if (_samples.isNotEmpty) {
      final cutoffUs = _samples.last.vsyncStartUs - _kWindowDuration.inMicroseconds;
      while (_samples.length > 1 && _samples.first.vsyncStartUs < cutoffUs) {
        _samples.removeFirst();
      }
    }
  }

  void _publishSnapshot() {
    if (!mounted) return;
    // After a run ends, freeze the values so the user can read the
    // result without it drifting if they scroll or interact.
    if (_snapshotFrozen) return;
    // Jank threshold: relax to the universal 60 fps budget on
    // high-refresh devices. The device's strict vsync (e.g. 11.11 ms
    // at 90 Hz) is fine for the FPS clamp but would mark every
    // typical chat frame as jank, washing out the metric. See
    // [_kJankBudgetMs].
    final jankBudget = _vsyncMs > _kJankBudgetMs ? _vsyncMs : _kJankBudgetMs;
    var sum = 0.0;
    var worst = 0.0;
    var buildSum = 0.0;
    var rasterSum = 0.0;
    var janks = 0;
    var refreshHits = 0;
    final totals = <double>[];
    for (final s in _samples) {
      sum += s.totalMs;
      buildSum += s.buildMs;
      rasterSum += s.rasterMs;
      if (s.totalMs > worst) worst = s.totalMs;
      if (s.totalMs > jankBudget) janks++;
      if (s.totalMs <= _vsyncMs) refreshHits++;
      totals.add(s.totalMs);
    }
    if (totals.isNotEmpty) {
      _avgFrameMs = sum / totals.length;
      _worstFrameMs = worst;
      totals.sort();
      final p95Index = (totals.length * 0.95).floor().clamp(0, totals.length - 1);
      _p95FrameMs = totals[p95Index];
      _jankPct = janks / totals.length;
      _refreshHitPct = refreshHits / totals.length;
    }
    final avgBuildMs = totals.isEmpty ? 0.0 : buildSum / totals.length;
    final avgRasterMs = totals.isEmpty ? 0.0 : rasterSum / totals.length;
    // Sample RSS at a quarter cadence — see [_rssSampleInterval].
    if (++_rssSampleCounter >= _rssSampleInterval) {
      _rssSampleCounter = 0;
      final rss = _readRss();
      _currentRssBytes = rss;
      if (rss > _peakRssBytes) _peakRssBytes = rss;
    }
    _snapshotNotifier.value = _DashboardSnapshot(
      messageCount: _messageCount,
      totalSeen: _totalSeen,
      floodSentCount: _floodSentCount,
      avgFrameMs: _avgFrameMs,
      worstFrameMs: _worstFrameMs,
      p95FrameMs: _p95FrameMs,
      jankPct: _jankPct,
      refreshHitPct: _refreshHitPct,
      refreshRate: 1000.0 / _vsyncMs,
      buildMs: avgBuildMs,
      rasterMs: avgRasterMs,
      currentRssBytes: _currentRssBytes,
      peakRssBytes: _peakRssBytes,
      baselineRssBytes: _baselineRssBytes,
    );
  }

  void _forcePrune() {
    final limit = _limit;
    if (limit == null) return;
    widget.channel.state?.pruneOldest(limit);
  }

  void _startFlood() {
    if (_floodTimer != null) return;
    // microseconds keeps the math exact for higher rates (e.g. 500 msg/s
    // would round-trip cleanly to 2 ms but 250 msg/s would not in plain ms).
    final intervalMicros = Duration.microsecondsPerSecond ~/ _speed;
    _floodTimer = Timer.periodic(
      Duration(microseconds: intervalMicros),
      (_) => _injectFloodMessage(),
    );
    // Drop the rolling window and arm the warm-up gate so the
    // recording's average isn't biased by shader/decoder spin-up. Also
    // force-collapse the HUD: the expanded body's `_DashboardPanel`
    // rebuilds at 2 Hz on the UI thread, which would add small but
    // measurable work to the very frames we're trying to time.
    _resetFrameStats();
    _warmupFramesRemaining = _kWarmupFrames;
    _rssSampleCounter = _rssSampleInterval;
    _snapshotFrozen = false;
    setState(() {
      _controlsExpanded = false;
    });
  }

  void _stopFlood() {
    _floodTimer?.cancel();
    _floodTimer = null;
    // Publish one final snapshot reflecting the just-finished run,
    // then freeze. Any post-run scrolling or interaction won't
    // perturb the numbers the user is reading.
    _publishSnapshot();
    _snapshotFrozen = true;
    if (mounted) setState(() {});
  }

  void _injectFloodMessage() {
    // Auto-stop when we've reached the target (chosen via the "FLOOD" chips
    // in the controls panel). Lets every recorded trace hit the same
    // steady-state N, which is what makes before/after comparisons valid.
    final target = _floodTarget;
    if (target != null && _floodSentCount >= target) {
      _stopFlood();
      return;
    }

    final channel = widget.channel;
    final cid = channel.cid;
    if (cid == null) return;
    final now = DateTime.now();
    _floodSentCount++;

    final user = _floodAuthors[_floodRandom.nextInt(_floodAuthors.length)];
    final text = _floodCorpus[_floodRandom.nextInt(_floodCorpus.length)];

    final message = Message(
      id: 'flood-${now.microsecondsSinceEpoch}-$_floodSentCount',
      text: text,
      user: user,
      createdAt: now,
      updatedAt: now,
    );
    channel.client.handleEvent(
      Event(
        type: EventType.messageNew,
        cid: cid,
        channelType: channel.type,
        channelId: channel.id,
        message: message,
        createdAt: now,
      ),
    );
  }

  // A deliberately minimal row used when [_lightweightItems] is on.
  // One line of text, fixed height, no markdown / attachments /
  // reactions / timestamps. The point is to take the heavy per-row
  // widget construction off the table so the profile shows just
  // SPL + SDK + list-view overhead.
  Widget _lightweightMessageBuilder(
    BuildContext context,
    Message message,
    StreamMessageItemProps defaultProps,
  ) {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Text(
          '${message.user?.name ?? '?'}: ${message.text ?? ''}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      channel: widget.channel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Message list benchmark'),
        ),
        body: Stack(
          children: [
            // Compositor isolation: wrapping the list+input column in a
            // RepaintBoundary gives them their own layer. When the HUD
            // above pulses its status dot or republishes its 2 Hz
            // snapshot, the list's layer is reused from the
            // compositor cache instead of being re-rasterized.
            RepaintBoundary(
              child: Column(
                children: [
                  Expanded(
                    child: StreamMessageListView(
                      // Bump the list's key when lightweight mode
                      // toggles so the message list re-mounts with the
                      // new builder — otherwise existing Elements
                      // would keep their old `StreamMessageItem`
                      // subtrees alive on first switch.
                      key: ValueKey(
                        '${_limit ?? "inf"}-${_lightweightItems ? "lite" : "full"}',
                      ),
                      config: StreamMessageListViewConfiguration(
                        maximumMessageLimit: _limit,
                      ),
                      messageBuilder: _lightweightItems ? _lightweightMessageBuilder : null,
                    ),
                  ),
                  StreamMessageComposer(),
                ],
              ),
            ),
            // Mirror boundary on the HUD side: keeps HUD repaints
            // contained within its own layer so they can't pull the
            // list's layer into the same raster pass either direction.
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: SafeArea(
                top: false,
                bottom: false,
                child: RepaintBoundary(
                  child: _BenchHud(
                    snapshotNotifier: _snapshotNotifier,
                    expanded: _controlsExpanded,
                    isFlooding: _isFlooding,
                    limit: _limit,
                    limitOptions: _limitOptions,
                    floodTarget: _floodTarget,
                    floodTargetOptions: _floodTargetOptions,
                    speed: _speed,
                    speedOptions: _speedOptions,
                    canForcePrune: _limit != null,
                    lightweightItems: _lightweightItems,
                    onToggleExpand: () => setState(
                      () => _controlsExpanded = !_controlsExpanded,
                    ),
                    onLimitChanged: (v) => setState(() => _limit = v),
                    onFloodTargetChanged: (v) => setState(() => _floodTarget = v),
                    onSpeedChanged: (v) => setState(() => _speed = v),
                    onLightweightItemsChanged: (v) => setState(() => _lightweightItems = v),
                    onStartFlood: _startFlood,
                    onStopFlood: _stopFlood,
                    onForcePrune: _forcePrune,
                    onReset: _resetCounters,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// HUD (Dynamic-Island style floating overlay)
// ─────────────────────────────────────────────────────────────────────

// iOS-style system palette. The HUD stays dark on both light and dark
// app themes so it reads like a system overlay, not chrome.
const _kHudBg = Color(0xF21C1C1E);
const _kHudFg = Color(0xFFF2F2F7);
const _kHudFgMuted = Color(0xFF8E8E93);
const _kHudDivider = Color(0x1FFFFFFF);
const _kHudOutline = Color(0xFF2C2C2E);
const _kHudGood = Color(0xFF34C759);
const _kHudWarn = Color(0xFFFF9F0A);
const _kHudBad = Color(0xFFFF453A);
const _kHudAccent = Color(0xFF0A84FF);

/// Floating, tap-to-expand HUD inspired by iOS Dynamic Island. Two
/// visual states share a single rounded surface that animates between
/// them:
///
///  * **Pill** — a thin row with a status dot, FPS, msg count, memory,
///    and an inline start/stop button. Tap anywhere on the pill (but
///    not on the button) to expand.
///  * **Card** — the pill stays on top; below it sits the full metric
///    grid plus chip controls (LIMIT / FLOOD / SPEED, reset, prune).
///
/// Sits inside a [Stack] above [StreamMessageListView]; the list
/// scrolls underneath, the HUD never steals viewport. All metric reads
/// go through a [ValueListenableBuilder] on the snapshot, so the HUD's
/// 2 Hz refresh doesn't bubble back into the list's render tree.
class _BenchHud extends StatelessWidget {
  const _BenchHud({
    required this.snapshotNotifier,
    required this.expanded,
    required this.isFlooding,
    required this.limit,
    required this.limitOptions,
    required this.floodTarget,
    required this.floodTargetOptions,
    required this.speed,
    required this.speedOptions,
    required this.canForcePrune,
    required this.lightweightItems,
    required this.onToggleExpand,
    required this.onLimitChanged,
    required this.onFloodTargetChanged,
    required this.onSpeedChanged,
    required this.onLightweightItemsChanged,
    required this.onStartFlood,
    required this.onStopFlood,
    required this.onForcePrune,
    required this.onReset,
  });

  final ValueListenable<_DashboardSnapshot> snapshotNotifier;
  final bool expanded;
  final bool isFlooding;
  final int? limit;
  final List<int?> limitOptions;
  final int? floodTarget;
  final List<int?> floodTargetOptions;
  final int speed;
  final List<int> speedOptions;
  final bool canForcePrune;
  final bool lightweightItems;
  final VoidCallback onToggleExpand;
  final ValueChanged<int?> onLimitChanged;
  final ValueChanged<int?> onFloodTargetChanged;
  final ValueChanged<int> onSpeedChanged;
  final ValueChanged<bool> onLightweightItemsChanged;
  final VoidCallback onStartFlood;
  final VoidCallback onStopFlood;
  final VoidCallback onForcePrune;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    const radius = 22.0;
    return Align(
      key: UniqueKey(),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _kHudBg,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: _kHudOutline, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.28),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            // ClipRRect because [DecoratedBox] only paints its own
            // background with rounded corners — it does NOT clip
            // children. Without this, the inner panels' solid
            // backgrounds bleed past the rounded corners (visible at
            // the bottom of the expanded card).
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Material(
                type: MaterialType.transparency,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Loud warning when running in debug mode — the
                    // JIT, asserts, and missing tree-shaking make
                    // every number on this HUD meaningless for
                    // comparison. Only `--profile` / `--release`
                    // builds are honest.
                    if (kDebugMode) const _DebugBanner(),
                    _BenchHudPill(
                      snapshotNotifier: snapshotNotifier,
                      expanded: expanded,
                      isFlooding: isFlooding,
                      onToggleExpand: onToggleExpand,
                      onStartFlood: onStartFlood,
                      onStopFlood: onStopFlood,
                    ),
                    if (expanded)
                      // Expanded body rebuilds at 2 Hz (dashboard
                      // snapshot). Its own layer keeps that repaint
                      // out of the pill above and the outer HUD
                      // surface (border, shadow) below.
                      RepaintBoundary(
                        child: _BenchHudBody(
                          snapshotNotifier: snapshotNotifier,
                          limit: limit,
                          limitOptions: limitOptions,
                          floodTarget: floodTarget,
                          floodTargetOptions: floodTargetOptions,
                          speed: speed,
                          speedOptions: speedOptions,
                          isFlooding: isFlooding,
                          canForcePrune: canForcePrune,
                          lightweightItems: lightweightItems,
                          onLimitChanged: onLimitChanged,
                          onFloodTargetChanged: onFloodTargetChanged,
                          onSpeedChanged: onSpeedChanged,
                          onLightweightItemsChanged: onLightweightItemsChanged,
                          onForcePrune: onForcePrune,
                          onReset: onReset,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The always-visible top of the HUD. Renders three terse metrics
/// (`fps`, `msg`, `mem`) plus a status dot and a start/stop button. Tap
/// the row to expand; tap the button to flood.
class _BenchHudPill extends StatelessWidget {
  const _BenchHudPill({
    required this.snapshotNotifier,
    required this.expanded,
    required this.isFlooding,
    required this.onToggleExpand,
    required this.onStartFlood,
    required this.onStopFlood,
  });

  final ValueListenable<_DashboardSnapshot> snapshotNotifier;
  final bool expanded;
  final bool isFlooding;
  final VoidCallback onToggleExpand;
  final VoidCallback onStartFlood;
  final VoidCallback onStopFlood;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggleExpand,
      // Ripple stays inside the outer HUD rounding (see [_BenchHud]).
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: 44,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 4, 6, 4),
          child: ValueListenableBuilder<_DashboardSnapshot>(
            valueListenable: snapshotNotifier,
            builder: (context, snapshot, _) {
              final avgMs = snapshot.avgFrameMs;
              final fps = _achievedFps(context, avgMs);
              final dotColor = isFlooding
                  ? _kHudBad
                  : avgMs <= 0
                  ? _kHudFgMuted
                  : avgMs > 33
                  ? _kHudBad
                  : avgMs > 16.7
                  ? _kHudWarn
                  : _kHudGood;
              return Row(
                children: [
                  _StatusDot(color: dotColor, active: isFlooding),
                  const SizedBox(width: 10),
                  _HudMetric(
                    label: 'fps',
                    value: avgMs > 0 ? fps.toStringAsFixed(0) : '—',
                  ),
                  const SizedBox(width: 14),
                  _HudMetric(
                    label: 'msg',
                    value: _formatCompact(snapshot.messageCount),
                  ),
                  const SizedBox(width: 14),
                  _HudMetric(
                    label: 'mem',
                    value: snapshot.currentRssBytes > 0 ? _formatMb(snapshot.currentRssBytes, decimals: 0) : '—',
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 220),
                    turns: expanded ? 0.5 : 0,
                    child: const Icon(
                      Icons.expand_more_rounded,
                      size: 20,
                      color: _kHudFgMuted,
                    ),
                  ),
                  const SizedBox(width: 4),
                  _FloodButton(
                    isFlooding: isFlooding,
                    onStart: onStartFlood,
                    onStop: onStopFlood,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HudMetric extends StatelessWidget {
  const _HudMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: _kHudFg,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            fontFeatures: [FontFeature.tabularFigures()],
            height: 1,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: _kHudFgMuted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            height: 1,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

/// Static status dot with an optional glow halo when [active]. Held
/// deliberately stateless — an earlier pulsing version ticked at
/// vsync, which during a flood meant the dot did paint work on every
/// single frame and contaminated the FPS measurement the HUD is
/// supposed to be reporting on. The red play/stop button on the right
/// already signals "live", so the dot only needs to stay legible, not
/// breathe.
class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color, required this.active});

  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: active
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.55),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}

/// Achievable FPS for the current frame budget — clamped to the active
/// display's refresh rate so we never report numbers the device
/// physically can't deliver (e.g. "200 fps" on a 60 Hz panel just
/// because the build budget happens to be 5 ms).
double _achievedFps(BuildContext context, double avgMs) {
  if (avgMs <= 0) return 0;
  final refresh = View.of(context).display.refreshRate;
  return (1000 / avgMs).clamp(0, refresh).toDouble();
}

/// Yellow caution strip at the top of the HUD when running in debug
/// mode. Debug builds run unoptimized Dart through the JIT with
/// `assert`s enabled — the numbers below it are useful for noticing
/// regressions in *your own* edits but not for absolute comparison.
class _DebugBanner extends StatelessWidget {
  const _DebugBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      color: const Color(0xFFFFD60A),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 13,
            color: Color(0xFF1C1C1E),
          ),
          SizedBox(width: 6),
          Text(
            'DEBUG · numbers are not meaningful',
            style: TextStyle(
              color: Color(0xFF1C1C1E),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloodButton extends StatelessWidget {
  const _FloodButton({
    required this.isFlooding,
    required this.onStart,
    required this.onStop,
  });

  final bool isFlooding;
  final VoidCallback onStart;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final bg = isFlooding ? _kHudBad : _kHudGood;
    final icon = isFlooding ? Icons.stop_rounded : Icons.play_arrow_rounded;
    return Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: isFlooding ? onStop : onStart,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

/// Body shown when the HUD is expanded: detail metric grid + chip
/// controls. Wrapped in a dark [Theme] so the existing
/// [_DashboardPanel] / [_ControlsPanel] re-skin themselves to match
/// the HUD palette without per-call overrides.
class _BenchHudBody extends StatelessWidget {
  const _BenchHudBody({
    required this.snapshotNotifier,
    required this.limit,
    required this.limitOptions,
    required this.floodTarget,
    required this.floodTargetOptions,
    required this.speed,
    required this.speedOptions,
    required this.isFlooding,
    required this.canForcePrune,
    required this.lightweightItems,
    required this.onLimitChanged,
    required this.onFloodTargetChanged,
    required this.onSpeedChanged,
    required this.onLightweightItemsChanged,
    required this.onForcePrune,
    required this.onReset,
  });

  final ValueListenable<_DashboardSnapshot> snapshotNotifier;
  final int? limit;
  final List<int?> limitOptions;
  final int? floodTarget;
  final List<int?> floodTargetOptions;
  final int speed;
  final List<int> speedOptions;
  final bool isFlooding;
  final bool canForcePrune;
  final bool lightweightItems;
  final ValueChanged<int?> onLimitChanged;
  final ValueChanged<int?> onFloodTargetChanged;
  final ValueChanged<int> onSpeedChanged;
  final ValueChanged<bool> onLightweightItemsChanged;
  final VoidCallback onForcePrune;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    final darkScheme = const ColorScheme.dark().copyWith(
      surface: _kHudBg,
      surfaceContainer: _kHudBg,
      onSurface: _kHudFg,
      onSurfaceVariant: _kHudFgMuted,
      outlineVariant: _kHudOutline,
      primary: _kHudAccent,
      onPrimary: Colors.white,
      secondaryContainer: _kHudAccent,
      onSecondaryContainer: Colors.white,
    );

    return Theme(
      data: base.copyWith(
        colorScheme: darkScheme,
        chipTheme: base.chipTheme.copyWith(
          // [WidgetStateProperty] so the *selected* chip keeps its
          // accent fill even while the row is disabled (which is the
          // case during a flood). Material's default branches on
          // `disabled` before `selected`, so without this the chosen
          // value would collapse back into the neutral track.
          color: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            final disabled = states.contains(WidgetState.disabled);
            if (selected) {
              return disabled ? _kHudAccent.withValues(alpha: 0.65) : _kHudAccent;
            }
            return disabled ? _kHudOutline.withValues(alpha: 0.5) : _kHudOutline;
          }),
          labelStyle: const TextStyle(
            color: _kHudFg,
            fontFeatures: [FontFeature.tabularFigures()],
            fontWeight: FontWeight.w500,
          ),
          secondaryLabelStyle: const TextStyle(
            color: Colors.white,
            fontFeatures: [FontFeature.tabularFigures()],
            fontWeight: FontWeight.w700,
          ),
          side: const BorderSide(color: Colors.transparent),
          checkmarkColor: Colors.white,
        ),
        dividerTheme: const DividerThemeData(
          color: _kHudDivider,
          thickness: 0.5,
          space: 1,
        ),
        textTheme: base.textTheme.apply(
          bodyColor: _kHudFg,
          displayColor: _kHudFg,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(),
          ValueListenableBuilder<_DashboardSnapshot>(
            valueListenable: snapshotNotifier,
            builder: (context, snapshot, _) {
              return _DashboardPanel(snapshot: snapshot, limit: limit);
            },
          ),
          _ControlsPanel(
            limitOptions: limitOptions,
            limit: limit,
            floodTargetOptions: floodTargetOptions,
            floodTarget: floodTarget,
            speedOptions: speedOptions,
            speed: speed,
            isFlooding: isFlooding,
            canForcePrune: canForcePrune,
            lightweightItems: lightweightItems,
            onLimitChanged: onLimitChanged,
            onSpeedChanged: onSpeedChanged,
            onFloodTargetChanged: onFloodTargetChanged,
            onLightweightItemsChanged: onLightweightItemsChanged,
            // Start/stop live on the pill — the body never shows them.
            // These callbacks are wired but `_ControlsPanel` hides them
            // via [_ControlsPanel.compact].
            onStartFlood: () {},
            onStopFlood: () {},
            onForcePrune: onForcePrune,
            onReset: onReset,
            compact: true,
          ),
        ],
      ),
    );
  }
}

String _formatCompact(int value) {
  if (value < 1000) return '$value';
  if (value < 10000) {
    final v = value / 1000;
    return '${v.toStringAsFixed(1)}k';
  }
  if (value < 1000000) return '${(value / 1000).round()}k';
  return '${(value / 1000000).toStringAsFixed(1)}M';
}

// ─────────────────────────────────────────────────────────────────────
// Dashboard
// ─────────────────────────────────────────────────────────────────────

@immutable
class _FrameSample {
  const _FrameSample({
    required this.vsyncStartUs,
    required this.totalMs,
    required this.buildMs,
    required this.rasterMs,
  });

  /// `vsyncStart` in microseconds since engine boot — used as a
  /// monotonic timestamp to prune the rolling window.
  final int vsyncStartUs;
  final double totalMs;
  final double buildMs;
  final double rasterMs;
}

@immutable
class _DashboardSnapshot {
  const _DashboardSnapshot({
    required this.messageCount,
    required this.totalSeen,
    required this.floodSentCount,
    required this.avgFrameMs,
    required this.worstFrameMs,
    required this.p95FrameMs,
    required this.jankPct,
    required this.refreshHitPct,
    required this.refreshRate,
    required this.buildMs,
    required this.rasterMs,
    required this.currentRssBytes,
    required this.peakRssBytes,
    required this.baselineRssBytes,
  });

  static const empty = _DashboardSnapshot(
    messageCount: 0,
    totalSeen: 0,
    floodSentCount: 0,
    avgFrameMs: 0,
    worstFrameMs: 0,
    p95FrameMs: 0,
    jankPct: 0,
    refreshHitPct: 0,
    refreshRate: 60,
    buildMs: 0,
    rasterMs: 0,
    currentRssBytes: 0,
    peakRssBytes: 0,
    baselineRssBytes: 0,
  );

  final int messageCount;
  final int totalSeen;
  final int floodSentCount;
  final double avgFrameMs;
  final double worstFrameMs;
  final double p95FrameMs;
  // Fraction of frames whose total exceeded the 60 fps "smooth"
  // budget (16.67 ms). The metric users actually feel: average can
  // hide sporadic stalls, jank% surfaces them. Threshold is
  // device-agnostic so high-refresh devices don't report alarming
  // numbers for chat that's still smooth at 60 fps.
  final double jankPct;
  // Fraction of frames that came in within the *device's* vsync. On
  // 60 Hz this overlaps with not-jank; on 90/120 Hz it's a stricter
  // "did we hit native refresh?" badge that you can drive separately.
  final double refreshHitPct;
  // The device's display refresh rate (Hz). Surfaced so the PERFORMANCE
  // card can label the refresh-hit % with the right number.
  final double refreshRate;
  // UI-thread vs GPU-thread average. Splitting build from raster lets
  // you tell *which* side is the bottleneck — high build = Dart work,
  // high raster = paint/shader cost.
  final double buildMs;
  final double rasterMs;
  final int currentRssBytes;
  final int peakRssBytes;
  final int baselineRssBytes;
}

class _DashboardPanel extends StatelessWidget {
  const _DashboardPanel({
    required this.snapshot,
    required this.limit,
  });

  final _DashboardSnapshot snapshot;
  final int? limit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final messageCount = snapshot.messageCount;
    final totalSeen = snapshot.totalSeen;
    final floodSentCount = snapshot.floodSentCount;
    final avgFrameMs = snapshot.avgFrameMs;
    final worstFrameMs = snapshot.worstFrameMs;
    final p95FrameMs = snapshot.p95FrameMs;
    final jankPct = snapshot.jankPct;
    final refreshHitPct = snapshot.refreshHitPct;
    final refreshRate = snapshot.refreshRate;
    final buildMs = snapshot.buildMs;
    final rasterMs = snapshot.rasterMs;
    final currentRssBytes = snapshot.currentRssBytes;
    final peakRssBytes = snapshot.peakRssBytes;
    final baselineRssBytes = snapshot.baselineRssBytes;

    final pruned = (totalSeen - messageCount).clamp(0, totalSeen);
    final fps = _achievedFps(context, avgFrameMs);
    final rssDeltaBytes = currentRssBytes - baselineRssBytes;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      color: theme.colorScheme.surfaceContainer,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _MetricCard(
                title: 'MESSAGES',
                primary: _formatInt(messageCount),
                primarySuffix: limit == null ? null : '/ ${_formatInt(limit!)}',
                primaryColor: _messageStateColor(theme, messageCount, limit),
                secondaryLines: [
                  _MetricLine(
                    label: 'Seen',
                    value: _formatInt(totalSeen),
                  ),
                  _MetricLine(
                    label: 'Pruned',
                    value: _formatInt(pruned),
                    valueColor: pruned > 0 ? Colors.deepOrange : null,
                  ),
                  if (floodSentCount > 0)
                    _MetricLine(
                      label: 'Sent',
                      value: _formatInt(floodSentCount),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricCard(
                title: 'PERFORMANCE',
                titleSuffix: () {
                  final refresh = View.of(context).display.refreshRate;
                  final vsyncMs = 1000 / refresh;
                  return '${refresh.toStringAsFixed(0)} Hz · '
                      '${vsyncMs.toStringAsFixed(1)} ms budget';
                }(),
                primary: avgFrameMs > 0 ? avgFrameMs.toStringAsFixed(1) : '—',
                primarySuffix: avgFrameMs > 0 ? 'ms' : null,
                primaryColor: _frameTimeColor(avgFrameMs),
                secondaryLines: [
                  _MetricLine(
                    label: 'FPS',
                    value: avgFrameMs > 0 ? fps.toStringAsFixed(0) : '—',
                  ),
                  _MetricLine(
                    label: 'Jank',
                    value: avgFrameMs > 0 ? '${(jankPct * 100).toStringAsFixed(0)}%' : '—',
                    valueColor: _jankColor(jankPct),
                  ),
                  _MetricLine(
                    label: 'Hit ${refreshRate.toStringAsFixed(0)}',
                    value: avgFrameMs > 0 ? '${(refreshHitPct * 100).toStringAsFixed(0)}%' : '—',
                    valueColor: _refreshHitColor(refreshHitPct),
                  ),
                  _MetricLine(
                    label: 'P95',
                    value: p95FrameMs > 0 ? '${p95FrameMs.toStringAsFixed(1)} ms' : '—',
                    valueColor: _frameTimeColor(p95FrameMs),
                  ),
                  _MetricLine(
                    label: 'Worst',
                    value: worstFrameMs > 0 ? '${worstFrameMs.toStringAsFixed(1)} ms' : '—',
                    valueColor: _frameTimeColor(worstFrameMs),
                  ),
                  _MetricLine(
                    label: 'Build / Raster',
                    value: avgFrameMs > 0
                        ? '${buildMs.toStringAsFixed(1)} / '
                              '${rasterMs.toStringAsFixed(1)} ms'
                        : '—',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricCard(
                title: 'MEMORY',
                primary: _formatMb(currentRssBytes, decimals: 0),
                primarySuffix: currentRssBytes > 0 ? 'MB' : null,
                primaryColor: theme.colorScheme.onSurface,
                secondaryLines: [
                  _MetricLine(
                    label: 'Δ',
                    value: _formatDeltaMb(currentRssBytes, baselineRssBytes),
                    valueColor: _rssDeltaColor(rssDeltaBytes),
                  ),
                  _MetricLine(
                    label: 'Peak',
                    value: _formatMb(peakRssBytes, decimals: 0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _frameTimeColor(double ms) {
    if (ms <= 0) return Colors.grey;
    if (ms > 33) return Colors.red;
    if (ms > 16.7) return Colors.orange;
    return Colors.green.shade700;
  }

  static Color _jankColor(double pct) {
    if (pct >= 0.05) return Colors.red;
    if (pct >= 0.01) return Colors.orange;
    return Colors.green.shade700;
  }

  static Color _refreshHitColor(double pct) {
    if (pct >= 0.9) return Colors.green.shade700;
    if (pct >= 0.5) return Colors.orange;
    return Colors.red;
  }

  static Color? _rssDeltaColor(int bytes) {
    if (bytes > 100 * 1024 * 1024) return Colors.red;
    if (bytes > 50 * 1024 * 1024) return Colors.orange;
    if (bytes > 0) return Colors.amber.shade800;
    return null;
  }

  static Color _messageStateColor(ThemeData theme, int count, int? limit) {
    if (limit == null) {
      // Unbounded — flag if growing past common thresholds.
      if (count > 1000) return Colors.red;
      if (count > 500) return Colors.orange;
    }
    return theme.colorScheme.onSurface;
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.primary,
    required this.secondaryLines,
    this.titleSuffix,
    this.primarySuffix,
    this.primaryColor,
  });

  final String title;

  /// Small annotation rendered alongside [title] — used by the
  /// PERFORMANCE card to show "60 Hz · 16.7 ms budget" so jank% has
  /// meaning at a glance.
  final String? titleSuffix;
  final String primary;
  final String? primarySuffix;
  final Color? primaryColor;
  final List<_MetricLine> secondaryLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = primaryColor ?? theme.colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (titleSuffix != null) ...[
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    titleSuffix!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 28,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    primary,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  if (primarySuffix != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      primarySuffix!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          for (final line in secondaryLines)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                children: [
                  Text(
                    line.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    line.value,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: line.valueColor ?? theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MetricLine {
  const _MetricLine({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;
}

// ─────────────────────────────────────────────────────────────────────
// Controls
// ─────────────────────────────────────────────────────────────────────

class _ControlsPanel extends StatelessWidget {
  const _ControlsPanel({
    required this.limitOptions,
    required this.limit,
    required this.floodTargetOptions,
    required this.floodTarget,
    required this.speedOptions,
    required this.speed,
    required this.isFlooding,
    required this.canForcePrune,
    required this.lightweightItems,
    required this.onLimitChanged,
    required this.onFloodTargetChanged,
    required this.onSpeedChanged,
    required this.onLightweightItemsChanged,
    required this.onStartFlood,
    required this.onStopFlood,
    required this.onForcePrune,
    required this.onReset,
    this.compact = false,
  });

  final List<int?> limitOptions;
  final int? limit;
  final List<int?> floodTargetOptions;
  final int? floodTarget;
  final List<int> speedOptions;
  final int speed;
  final bool isFlooding;
  final bool canForcePrune;
  final bool lightweightItems;
  final ValueChanged<int?> onLimitChanged;
  final ValueChanged<int?> onFloodTargetChanged;
  final ValueChanged<int> onSpeedChanged;
  final ValueChanged<bool> onLightweightItemsChanged;
  final VoidCallback onStartFlood;
  final VoidCallback onStopFlood;
  final VoidCallback onForcePrune;
  final VoidCallback onReset;

  /// When true, hides the start/stop button — used inside the HUD body
  /// where the pill already owns that affordance.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      color: theme.colorScheme.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // All chip rows are locked while a flood is running: changing the
          // limit / target / rate mid-recording muddies the trace. The user
          // stops, adjusts, and starts a fresh run.
          _ChipRow(
            label: 'LIMIT',
            options: limitOptions,
            selected: limit,
            enabled: !isFlooding,
            onSelected: onLimitChanged,
          ),
          const SizedBox(height: 6),
          _ChipRow(
            label: 'FLOOD',
            options: floodTargetOptions,
            selected: floodTarget,
            enabled: !isFlooding,
            onSelected: onFloodTargetChanged,
          ),
          const SizedBox(height: 6),
          _ChipRow(
            label: 'SPEED',
            options: speedOptions,
            selected: speed,
            enabled: !isFlooding,
            onSelected: onSpeedChanged,
            optionSuffix: ' /s',
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (!compact)
                if (isFlooding)
                  FilledButton.icon(
                    onPressed: onStopFlood,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.stop_rounded, size: 18),
                    label: const Text('Stop flood'),
                  )
                else
                  FilledButton.icon(
                    onPressed: onStartFlood,
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    label: const Text('Start flood'),
                  ),
              OutlinedButton.icon(
                onPressed: canForcePrune ? onForcePrune : null,
                icon: const Icon(
                  Icons.cleaning_services_outlined,
                  size: 16,
                ),
                label: const Text('Force prune'),
              ),
              OutlinedButton.icon(
                onPressed: onReset,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Reset'),
              ),
              FilterChip(
                label: const Text('Lite items'),
                avatar: const Icon(Icons.layers_clear_outlined, size: 16),
                selected: lightweightItems,
                onSelected: isFlooding ? null : onLightweightItemsChanged,
                tooltip:
                    'Render each row as a single-line text bubble '
                    'instead of StreamMessageWidget. Use this to isolate '
                    'SPL + SDK + list-view overhead from per-message '
                    'widget construction (markdown, attachments, etc.).',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChipRow<T> extends StatelessWidget {
  const _ChipRow({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.enabled = true,
    this.optionSuffix = '',
  });

  final String label;
  final List<T> options;
  final T selected;
  final ValueChanged<T> onSelected;
  final bool enabled;
  final String optionSuffix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final option in options)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    // No per-chip `labelStyle` here — letting it fall
                    // through to the ambient [ChipThemeData] is what
                    // lets the theme's `labelStyle` /
                    // `secondaryLabelStyle` drive font weight + colors
                    // (including the disabled+selected case). A local
                    // `labelStyle` *replaces* the theme entry.
                    child: ChoiceChip(
                      label: Text(_chipLabel(option)),
                      selected: selected == option,
                      onSelected: enabled ? (_) => onSelected(option) : null,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _chipLabel(T option) {
    if (option == null) return '∞';
    if (option is int) return '${_formatInt(option)}$optionSuffix';
    return '$option$optionSuffix';
  }
}

// ─────────────────────────────────────────────────────────────────────
// Formatting helpers
// ─────────────────────────────────────────────────────────────────────

String _formatInt(int value) {
  final s = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
    buffer.write(s[i]);
  }
  return buffer.toString();
}

String _formatMb(int bytes, {int decimals = 1}) {
  if (bytes <= 0) return '—';
  final mb = bytes / (1024 * 1024);
  if (mb >= 1000) return '${(mb / 1024).toStringAsFixed(decimals)} GB';
  return mb.toStringAsFixed(decimals);
}

String _formatDeltaMb(int current, int baseline) {
  if (current <= 0 || baseline <= 0) return '—';
  final deltaMb = (current - baseline) / (1024 * 1024);
  final sign = deltaMb >= 0 ? '+' : '';
  return '$sign${deltaMb.toStringAsFixed(1)} MB';
}

// ─────────────────────────────────────────────────────────────────────
// Flood corpus
// ─────────────────────────────────────────────────────────────────────

// Authors used by the local flood. The first entry matches the logged-in
// user (sahil) so a portion of the flood renders as own messages; the
// rest render as other-user bubbles.
final _floodAuthors = <User>[
  // User(
  //   id: 'sahil',
  //   extraData: const {
  //     'name': 'Sahil Kumar',
  //     'image':
  //         'https://avatars.githubusercontent.com/u/25670178?s=400&u=30ded3784d8d2310c5748f263fd5e6433c119aa1&v=4',
  //   },
  // ),
  User(
    id: 'salvatore',
    extraData: const {
      'name': 'Salvatore Giordano',
      'image': 'https://avatars.githubusercontent.com/u/20601437?s=460&u=3f66c22a7483980624804054ae7f357cf102c784&v=4',
    },
  ),
  User(
    id: 'thierry',
    extraData: const {
      'name': 'Thierry Schellenbach',
      'image': 'https://avatars.githubusercontent.com/u/265409?s=400&u=2d0e3bb1820db992066196bff7b004f0eee8e28d&v=4',
    },
  ),
  User(
    id: 'tommaso',
    extraData: const {
      'name': 'Tommaso Barbugli',
      'image': 'https://avatars.githubusercontent.com/u/88735?s=400&v=4',
    },
  ),
  User(
    id: 'deven',
    extraData: const {
      'name': 'Deven Joshi',
      'image': 'https://avatars.githubusercontent.com/u/26357843?s=400&u=0c61d890866e67bf69f58878be58915e9bfd39ee&v=4',
    },
  ),
  User(
    id: 'neevash',
    extraData: const {
      'name': 'Neevash Ramdial',
      'image': 'https://avatars.githubusercontent.com/u/25674767?s=400&u=1d7333baf7dd9d143db8bfcdb31a838b89cfff9c&v=4',
    },
  ),
];

// Mixed-shape corpus: short replies, emoji, questions, code, links,
// mentions, and long paragraphs. Picked randomly so the rendered list
// exercises different bubble sizes and text-layout costs.
const _floodCorpus = <String>[
  // Short / emoji
  'ok',
  'yes',
  'no',
  'lol',
  'haha',
  'thanks!',
  'on it',
  '👍',
  '🔥🔥🔥',
  '🚀',
  '😂',
  '🤔',
  'lgtm',
  'wfm',
  '+1',
  // Medium statements
  'just merged the PR, taking a quick break',
  'heading out for lunch in 5',
  'coffee run anyone?',
  'standup in 2 minutes folks',
  'can someone review my PR when you get a chance',
  'I think we should ship this on Monday',
  "let's sync up on this tomorrow",
  'reverting that commit, it broke the build',
  // Questions
  'did anyone see the test failures on main?',
  'what time is the demo today?',
  'is staging up? getting 502s',
  'who is on call this week?',
  'has anyone tried the new flutter version?',
  // Mentions / links
  '@sahil can you take a look at this when you have a sec',
  'docs are at https://getstream.io/chat/docs/flutter-dart/',
  'check the dashboard https://dashboard.getstream.io for the latest metrics',
  'related issue: https://github.com/GetStream/stream-chat-flutter/issues/1234',
  // Code-ish (single line)
  'try `flutter clean && flutter pub get` first',
  'we should add `assert(state != null)` here',
  // Multi-line code
  '''
```dart
final channel = client.channel('messaging', id: 'general');
await channel.watch();
```''',
  '''
```
git rebase -i HEAD~3
git push --force-with-lease
```''',
  // Long-ish prose
  // ignore: lines_longer_than_80_chars
  "I've been digging into the perf issue and I think the root cause is that the channel state is unbounded — every message that comes in stays in memory for the lifetime of the channel object, and the filter+reverse pass scales linearly. We should look at adding a cap.",
  // ignore: lines_longer_than_80_chars
  "Just got off a call with the customer. They're seeing the issue mostly on long sessions in busy support channels — typically 2-3 hours, high message volume. Memory grows steadily and eventually the UI starts to jank around the 4-5k message mark. They're on Pixel 6.",
  // Numbered list
  '''
plan:
1. add pruneOldest at the channel state level
2. wire it into MessageListCore with maximumMessageLimit
3. test against the customer's repro
4. ship behind a flag, default off
''',
  // Long emoji / decorative
  '🎉🎉🎉 we shipped! 🎉🎉🎉',
  '────────── EOD ──────────',
];
