import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// The current user's read boundary: where in the channel they had read up to.
// A mark-unread moves it backward, which is how a fresh one is told apart
// from the read-stream emissions that keep arriving during a session.
//
// A record rather than a class so equality stays structural — the whole point
// is comparing a newly observed boundary against the previous one.
typedef _ReadBoundary = ({DateTime? lastRead, String? lastReadMessageId});

// Every input the mark-read gate reads, captured as the key of one attempt.
// Comparing a new key against the last one is what stops a mark-read that
// keeps failing from being retried on every scroll frame, while still letting
// a genuine change through.
//
// Also a record for its structural equality, which the comparison relies on.
typedef _MarkReadAttempt = ({
  String? newestMessageId,
  int unreadCount,
  bool isMarkedAsUnread,
  bool viewportDiverged,
});

/// Owns the unread-message state machine behind [StreamMessageListView]:
/// the unread messages divider and its floating pill, the scroll-to-bottom
/// badge count, and the auto mark-read gate (including protection for an
/// active manual mark-unread).
///
/// The list forwards raw signals in — channel attach, message arrivals, item
/// position ticks, read-stream emissions and pill taps — and renders from the
/// exposed [ValueListenable]s. This class never touches the widget tree, and
/// reaches the list's live state only through the accessors it is given.
@internal
class MessageListUnreadController {
  /// Creates a controller wired to the message list's live state.
  ///
  /// Every dependency is a function rather than a value because the state
  /// behind it changes over the list's lifetime: the channel is reassigned on
  /// a channel change, `messages` on every stream emission, and the widget's
  /// configuration on any rebuild.
  MessageListUnreadController({
    required this._channel,
    required this._getFirstUnreadMessage,
    required this._parentMessage,
    required this._messages,
    required this._itemPositions,
    required this._markReadWhenAtTheBottom,
    required this._scrollToMessage,
    required this._attachToken,
  });

  final Channel? Function() _channel;
  final Message? Function(Read? currentUserRead) _getFirstUnreadMessage;
  final Message? Function() _parentMessage;
  final List<Message> Function() _messages;
  final Iterable<ItemPosition> Function() _itemPositions;
  final bool Function() _markReadWhenAtTheBottom;

  // Scrolls the list to a message without highlighting it, reporting whether
  // the scroll actually landed.
  final Future<bool> Function(String messageId) _scrollToMessage;

  // Identity of the current channel attachment, compared across awaits so a
  // result that arrives after the list re-attached elsewhere is dropped.
  final Object? Function() _attachToken;

  bool get _isThreadConversation => _parentMessage() != null;

  bool _disposed = false;

  // --- Divider A: pre-existing unread, frozen at channel open ---
  //
  // [_unreadBaseline] is the current user's [Read] captured once when the
  // channel is attached (or on the first `currentUserReadStream` emission if
  // read state wasn't available yet). It never changes afterwards, so
  // resolving the anchor against it — rather than against the live,
  // ever-shrinking `unreadCount` — is what keeps the divider and pill on
  // screen across an auto mark-read.
  Read? _unreadBaseline;
  bool _unreadBaselineCaptured = false;

  // Resolved anchor for divider A. The anchor (and `count`, the frozen
  // baseline used by the pill) is frozen once non-null: recomputation is
  // skipped as soon as `anchorId` is set. May take a few rebuilds to resolve
  // if top pagination hasn't finished loading the boundary yet.
  final _unreadDivider = ValueNotifier<({int count, String? anchorId})>((count: 0, anchorId: null));

  // Grows by one for every message that arrives out of view while divider
  // A is on screen, so the divider's displayed count keeps counting up
  // during the session instead of staying frozen at the open-time count.
  // Added on top of `_unreadDivider.value.count` for display only — the
  // pill keeps using the frozen count.
  final ValueNotifier<int> _unreadDividerGrowth = ValueNotifier(0);

  // Sticky: becomes true once the user has seen (rendered) or scrolled past
  // divider A's anchor. Drives the pill's permanent dismissal and (see
  // [_maybeMarkMessagesAsRead]) gates auto mark-read.
  final ValueNotifier<bool> _hasSeenFirstUnread = ValueNotifier(false);

  // Whether the list has reported item positions at least once.
  //
  // The pill waits on this. Its count is published synchronously while the
  // channel is attached, but `_hasSeenFirstUnread` can only be decided from
  // item positions, which arrive in a post-frame callback — so without this
  // the pill paints for exactly one frame on every channel opened at its
  // first unread message, then disappears.
  final ValueNotifier<bool> _hasLaidOut = ValueNotifier(false);

  // Scroll-to-bottom badge count. Counts messages that arrive while the user
  // is scrolled away from the bottom; resets to 0 once they reach the bottom.
  final ValueNotifier<int> _scrollToBottomBadge = ValueNotifier(0);

  // Sticky "bottom was reached" flag for the mark-read gate. Cleared after
  // each successful mark-read so returning to the bottom is required again
  // before the next one.
  bool _hasSeenLastMessage = false;

  // While non-null, the viewport captured at the moment an active manual
  // mark-unread (`channel.state.isMarkedAsUnread`) was first observed.
  // `_maybeMarkMessagesAsRead` blocks until [_markUnreadViewportDiverged]
  // is true — evidence the user did something (scrolled, reopened the
  // channel, etc.) since marking the message unread, rather than the
  // anchor merely being immediately "visible" again because it's usually
  // the very message just marked and nothing has moved.
  //
  // This can't gate on `isMarkedAsUnread` directly and permanently: that
  // flag only clears via a successful mark-read, which is the very thing
  // it would be gating, so treating it as a persistent block would
  // deadlock the channel unread forever the moment it's set — the exact
  // bug this snapshot exists to avoid.
  //
  // Set eagerly in [handleCurrentUserReadChanged] right when a live
  // transition is observed (captures the precise pre-scroll viewport), and
  // in [handleItemPositionsChanged] on the first genuinely laid-out frame
  // as a fallback for when the channel simply mounts with
  // `isMarkedAsUnread` already true and no transition ever fires — that
  // has to happen there and not lazily inside [_maybeMarkMessagesAsRead],
  // since the first time that gate is evaluated might already be the
  // user's first genuine arrival at the bottom, which would otherwise be
  // burned on capturing the baseline instead of acting on it. Cleared once
  // a mark-read actually goes through, or once `isMarkedAsUnread` itself
  // clears (so a future mark-unread starts its own fresh snapshot).
  //
  // Holds visible item *indices* rather than full [ItemPosition]s: comparing
  // full positions would latch divergence on a sub-pixel edge change from an
  // unrelated relayout (async attachment sizing, keyboard inset, image
  // load) even though the user never scrolled, undoing the manual
  // mark-unread almost instantly.
  List<int>? _markUnreadViewportSnapshot;

  // Sticky once true: sighted the first time [handleItemPositionsChanged]
  // (or, as a fallback, [_maybeMarkMessagesAsRead] itself) sees item
  // positions that genuinely differ from [_markUnreadViewportSnapshot].
  // Deliberately tracked as "did this ever happen" rather than
  // re-comparing the *current* positions against the snapshot on each
  // check — a user who scrolls away and back settles at the exact same
  // rest position, which would otherwise look unchanged and re-block a
  // mark-read that should already have been earned by that round trip.
  bool _markUnreadViewportDiverged = false;

  // State the last mark-read attempt was made against. Item positions tick
  // on every scroll frame, so without this a mark-read that keeps failing
  // would be retried for as long as the user keeps scrolling at the bottom
  // (once a second, as bounded by the debounce). Every input the gate in
  // [_maybeMarkMessagesAsRead] actually reads is part of the key, so a
  // genuine change — a new message, a mark-unread, the viewport diverging
  // after one — still gets its attempt.
  _MarkReadAttempt? _lastMarkReadAttempt;

  // Previous value of `channel.state.isMarkedAsUnread`, so
  // [handleCurrentUserReadChanged] can act on a new mark-unread rather than
  // on every read-stream emission that happens while the flag stays set.
  // Seeded from the channel on attach, since it can already be set there.
  bool _wasMarkedAsUnread = false;

  // Read boundary observed alongside [_wasMarkedAsUnread]. A mark-unread
  // moves the boundary backward, so a change here while the flag is already
  // set is how a *second* mark-unread is told apart from the read-stream
  // emissions that keep arriving during one.
  _ReadBoundary? _lastReadBoundary;

  static _ReadBoundary? _readBoundaryOf(Read? read) {
    if (read == null) return null;
    return (lastRead: read.lastRead, lastReadMessageId: read.lastReadMessageId);
  }

  // Whether divider A's current session came from an explicit mark-unread
  // rather than from pre-existing unread at channel open. The anchor of a
  // manual mark-unread is the message the user was looking at when they
  // marked it, so it's already on screen — see
  // [_maybeUpdateHasSeenFirstUnread] for why that changes what counts as
  // having reached the boundary.
  bool _unreadFromManualMarkUnread = false;

  /// The unread divider's frozen open-time count and, once resolved, the id
  /// of the message it anchors to.
  ValueListenable<({int count, String? anchorId})> get unreadDivider => _unreadDivider;

  /// Qualifying messages that have arrived since the divider's baseline was
  /// frozen, added on top of [unreadDivider]'s count for display.
  ValueListenable<int> get unreadDividerGrowth => _unreadDividerGrowth;

  /// Whether the divider's anchor has been seen or scrolled past.
  ValueListenable<bool> get hasSeenFirstUnread => _hasSeenFirstUnread;

  /// Whether the list has reported item positions at least once.
  ValueListenable<bool> get hasLaidOut => _hasLaidOut;

  /// Messages that arrived while the user was scrolled away from the bottom.
  ValueListenable<int> get scrollToBottomBadge => _scrollToBottomBadge;

  /// Whether a baseline was captured but its anchor still needs resolving,
  /// meaning [resolveDividerAnchor] is worth retrying once layout settles.
  bool get needsAnchorResolution => _unreadBaseline != null && _unreadDivider.value.anchorId == null;

  // Debounced channel mark-read.
  late final _debouncedMarkRead = debounce(
    ([String? id]) => _channel()?.markRead(messageId: id),
    const Duration(seconds: 1),
    leading: true,
  );

  // Debounced thread mark-read.
  late final _debouncedMarkThreadRead = debounce(
    (String parentId) => _channel()?.markThreadRead(parentId),
    const Duration(seconds: 1),
    leading: true,
  );

  /// Resets every piece of unread state for a newly attached channel.
  ///
  /// Must be called after the new channel is reachable through the accessors
  /// this controller was given, and before subscribing to that channel's read
  /// stream — the seeding below exists precisely to survive that stream's
  /// immediate replay.
  void attach() {
    _debouncedMarkRead.cancel();
    _debouncedMarkThreadRead.cancel();

    final channelState = _channel()?.state;

    _unreadBaselineCaptured = false;
    _unreadBaseline = null;
    _unreadDivider.value = (count: 0, anchorId: null);
    _unreadDividerGrowth.value = 0;
    _scrollToBottomBadge.value = 0;
    _hasSeenFirstUnread.value = false;
    _hasSeenLastMessage = false;
    _hasLaidOut.value = false;
    _lastMarkReadAttempt = null;
    _markUnreadViewportSnapshot = null;
    _markUnreadViewportDiverged = false;
    // Seeded from the channel's own state rather than hardcoded to false:
    // a channel can mount with a manual mark-unread already active (mark
    // unread, leave, come back — the flag lives on the cached
    // `ChannelClientState`). `currentUserReadStream` is backed by a
    // `BehaviorSubject`, so the subscription the list sets up replays the
    // current value straight away; without this seed that replay would read
    // as a brand-new mark-unread and restart a session that never ended.
    _wasMarkedAsUnread = channelState?.isMarkedAsUnread ?? false;
    _lastReadBoundary = _readBoundaryOf(channelState?.currentUserRead);
    _unreadFromManualMarkUnread = _wasMarkedAsUnread;
    _captureUnreadBaselineIfNeeded();
  }

  // Captures [_unreadBaseline] the first time the current user's read state
  // becomes available, then attempts to resolve divider A's anchor against
  // it. No-ops in a thread, where divider A doesn't apply.
  void _captureUnreadBaselineIfNeeded() {
    if (_unreadBaselineCaptured || _isThreadConversation) return;

    final currentUserRead = _channel()?.state?.currentUserRead;
    if (currentUserRead == null) return;

    _unreadBaselineCaptured = true;
    _unreadBaseline = currentUserRead.unreadMessages > 0 ? currentUserRead : null;
    // Publish the frozen count right away, even though the anchor itself
    // can't resolve until top pagination has loaded that far back — the
    // pill only needs the count, not the anchor, so it shouldn't wait on
    // pagination to appear (see [onPillJumpTapped] for how a tap before the
    // anchor resolves still jumps there).
    if (_unreadBaseline case final baseline?) {
      _unreadDivider.value = (count: baseline.unreadMessages, anchorId: _unreadDivider.value.anchorId);
    }
    resolveDividerAnchor();
  }

  /// Resolves divider A's anchor against the frozen baseline. A no-op once
  /// resolved, and while top pagination hasn't loaded the boundary yet.
  void resolveDividerAnchor() {
    if (_isThreadConversation || _unreadDivider.value.anchorId != null) return;

    final baseline = _unreadBaseline;
    if (baseline == null) return;

    final anchor = _getFirstUnreadMessage(baseline);
    if (anchor == null) return;

    _unreadDivider.value = (count: baseline.unreadMessages, anchorId: anchor.id);
  }

  /// Reacts to a `currentUserReadStream` emission. An explicit mark-unread
  /// moves the read boundary backward — treat it as a new session start for
  /// divider A/the pill.
  ///
  /// The reset is deliberately gated on a *new* mark-unread — the flag
  /// turning on, or the read boundary moving again while it's already on —
  /// rather than on the flag merely being set: the read stream also emits
  /// while it stays set (every new message, for one), and re-running the
  /// reset then would clear `_hasSeenFirstUnread` again and flicker the pill
  /// back in and straight out on each arrival. An arriving message bumps
  /// `unreadMessages` but leaves the boundary untouched, so gating on the
  /// boundary avoids that flicker while still catching a second mark-unread.
  ///
  /// Watching the boundary rather than only the transition matters because
  /// `isMarkedAsUnread` is cleared solely by a mark-read (see
  /// `ChannelClientState.markReadLocally`), and both the baseline capture and
  /// [resolveDividerAnchor] freeze once resolved — so this reset is the only
  /// thing that can move divider A once a mark-unread session is under way.
  void handleCurrentUserReadChanged() {
    if (_isThreadConversation) return;

    final channel = _channel();
    if (channel == null) return;

    final isMarkedAsUnread = channel.state?.isMarkedAsUnread ?? false;
    final readBoundary = _readBoundaryOf(channel.state?.currentUserRead);
    final boundaryMoved = readBoundary != _lastReadBoundary;
    final justMarkedAsUnread = isMarkedAsUnread && (!_wasMarkedAsUnread || boundaryMoved);
    _wasMarkedAsUnread = isMarkedAsUnread;
    _lastReadBoundary = readBoundary;

    if (justMarkedAsUnread) {
      _unreadBaselineCaptured = false;
      _unreadBaseline = null;
      _unreadDivider.value = (count: 0, anchorId: null);
      _unreadDividerGrowth.value = 0;
      _hasSeenFirstUnread.value = false;
      _unreadFromManualMarkUnread = true;
      // Each mark-unread starts its own session, so the snapshot is taken
      // fresh here rather than kept from a previous one — but only from a
      // viewport that has actually been laid out. `itemPositions` is still
      // empty before the first frame, and capturing that would make the
      // very first laid-out frame look like divergence, defeating guard 4
      // and leaving the fallback in [handleItemPositionsChanged]
      // unreachable. Left null instead, for that fallback to fill in.
      final visibleIndices = _itemPositions().map((it) => it.index).toList();
      _markUnreadViewportSnapshot = visibleIndices.isEmpty ? null : visibleIndices;
      _markUnreadViewportDiverged = false;
    } else if (!isMarkedAsUnread) {
      _unreadFromManualMarkUnread = false;
      _markUnreadViewportSnapshot = null;
      _markUnreadViewportDiverged = false;
    }

    _captureUnreadBaselineIfNeeded();
  }

  /// Counts a freshly arrived [message] towards the divider's growing count
  /// and, when the user isn't at the bottom, the scroll-to-bottom badge.
  ///
  /// Qualifying arrivals are filtered the same way the channel's own unread
  /// count filters them, so silent, shadowed, ephemeral, thread-only,
  /// restricted, muted-sender and own messages don't inflate either counter.
  /// The badge and divider also only apply to the channel's message stream,
  /// never to thread replies.
  void handleMessageArrived(
    Message message, {
    required OwnUser? currentUser,
    required bool isAtBottom,
  }) {
    final countsAsUnread = _countsTowardsUnreadIndicators(message, currentUser);
    if (_isThreadConversation || !countsAsUnread) return;

    // The divider counts every qualifying arrival — including ones seen
    // live at the bottom — so it keeps counting up for the whole session.
    // The badge is narrower: it only exists to flag what was missed while
    // scrolled away, so it skips arrivals that were already in view and
    // resets once the bottom is reached (see [handleItemPositionsChanged]).
    _unreadDividerGrowth.value += 1;
    if (!isAtBottom) _scrollToBottomBadge.value += 1;
  }

  /// Processes an item-positions tick, with [isAtBottom] reporting whether
  /// the newest message is fully visible.
  void handleItemPositionsChanged(
    Iterable<ItemPosition> itemPositions, {
    required bool isAtBottom,
  }) {
    // Guarded here as well as at the call site: an empty viewport is not a
    // laid-out one, and letting it through would both flip [hasLaidOut] on a
    // frame that renders nothing and let
    // [_checkMarkUnreadViewportDivergence] snapshot an empty index set —
    // which the very next non-empty frame would read as divergence, undoing
    // an active manual mark-unread. See [handleCurrentUserReadChanged],
    // which avoids capturing that same empty viewport for this reason.
    if (itemPositions.isEmpty) return;

    _hasLaidOut.value = true;

    // Snapshot the viewport (or check it against an existing snapshot for
    // divergence) the first time it's genuinely laid out while marked as
    // unread, in case the channel simply mounted in that state rather than
    // [handleCurrentUserReadChanged] observing a live transition to hook
    // the snapshot on. Doing this here — on every non-empty layout, before
    // checking anything else below — rather than lazily inside
    // [_maybeMarkMessagesAsRead], matters: that gate is only ever evaluated
    // when a mark-read could fire, which for a channel the user opens and
    // immediately scrolls all the way through might be the very first time
    // they reach the bottom. Capturing the baseline there would burn that
    // first genuine read on the snapshot itself instead of acting on it.
    if (_channel()?.state?.isMarkedAsUnread ?? false) {
      _checkMarkUnreadViewportDivergence(itemPositions);
    }

    final justSeenFirstUnread = _maybeUpdateHasSeenFirstUnread(itemPositions);

    if (isAtBottom) {
      _hasSeenLastMessage = true;
      _scrollToBottomBadge.value = 0;
    }

    // Attempt a mark-read whenever either half of the gate could have just
    // become satisfied; [_maybeMarkMessagesAsRead] does the actual deciding.
    if ((isAtBottom || justSeenFirstUnread) && _markReadWhenAtTheBottom()) {
      _maybeMarkMessagesAsRead(isAtBottom: isAtBottom).ignore();
    }
  }

  /// Handles a tap on the pill's jump affordance.
  Future<void> onPillJumpTapped() async {
    // The anchor may not have resolved yet if top pagination hasn't loaded
    // that far back — the pill is visible already (see its gating in the
    // list), so fall back to the frozen baseline's own last-read boundary,
    // known immediately from the server `Read`, rather than doing nothing.
    final anchorId = _unreadDivider.value.anchorId ?? _unreadBaseline?.lastReadMessageId;

    // A channel the user has never opened reports unread messages but has
    // no read boundary at all: the anchor can't resolve until top
    // pagination ends, and there's no `lastReadMessageId` to fall back on
    // either. Everything loaded is unread, so head for the oldest message
    // currently loaded — as far back as the boundary can be, and it pulls
    // the next page in on arrival — rather than leaving the tap inert.
    //
    // `_hasSeenFirstUnread` is deliberately not latched here: the real
    // boundary is further back than where this lands, so the pill stays up
    // until it's genuinely reached.
    if (anchorId == null) {
      final oldestLoaded = _messages().lastOrNull;
      if (oldestLoaded == null) return;
      await _scrollToMessage(oldestLoaded.id);
      return;
    }

    // Delegates to the list's scroll-to-message, which falls back to
    // [StreamChannelState.loadChannelAtMessage] when the anchor isn't in the
    // currently loaded window — after which the real anchor resolves
    // naturally via the list's retry of [resolveDividerAnchor], rendering
    // divider A too. That can await pagination and a frame, and this
    // controller survives a channel change — so remember which channel the
    // tap was for and drop the result if it isn't the current one any more.
    final tappedFor = _attachToken();
    final didJump = await _scrollToMessage(anchorId);
    if (_disposed || _attachToken() != tappedFor) return;
    // Only claim the boundary as seen once the jump actually landed —
    // otherwise (message not found even after pagination, or the list not
    // attached) the pill would vanish and the mark-read gate would open for
    // a boundary the user never actually reached.
    if (didJump) _hasSeenFirstUnread.value = true;
  }

  /// Handles a tap on the pill's dismiss affordance.
  Future<void> onPillDismissTapped() async {
    _hasSeenFirstUnread.value = true;
    // Dismissing is a local decision; if the request behind it fails there
    // is nothing to show the user, and letting it escape here would surface
    // as an unhandled async error instead.
    markAsRead().ignore();
  }

  /// Marks the channel — or, in a thread, the thread — as read immediately,
  /// bypassing the debouncers.
  Future<void> markAsRead() async {
    if (_parentMessage() case final parent?) {
      // If we are in a thread, mark the thread as read immediately.
      await _channel()?.markThreadRead(parent.id);
      return;
    }

    // Otherwise, mark the channel as read immediately.
    await _channel()?.markRead();
  }

  Future<void> _debouncedMarkMessagesAsRead() async {
    if (_parentMessage() case final parent?) {
      // If we are in a thread, mark the thread as read.
      _debouncedMarkThreadRead.call([parent.id]);
    } else {
      // Otherwise, mark the channel as read.
      _debouncedMarkRead.call();
    }
  }

  // Whether a freshly-arrived [message] should bump the scroll-to-bottom
  // badge and divider A's growing count.
  //
  // This is the message- and sender-level half of
  // [MessageRules.canCountAsUnread], which is what keeps silent, shadowed,
  // ephemeral, thread-only, restricted, muted-sender and own messages from
  // inflating either counter.
  //
  // The channel-level half of that rule (`isMuted`, `canUseReadReceipts`,
  // `usesLocalUnreadCount`) is deliberately left out. Those govern whether
  // the server tracks an unread count for the channel at all, whereas these
  // two counters are purely local "what arrived while you weren't looking"
  // indicators that should keep working either way — and
  // `usesLocalUnreadCount` is an extension getter reading `Channel`'s
  // private client field, so it can't be resolved against a channel double
  // at all.
  //
  // The user-level half (`isReadReceiptsEnabled`) is *not* left out: it
  // isn't about how the channel is configured but about the user opting out
  // of unread tracking entirely, and honouring it here is what keeps these
  // indicators from counting up while the channel itself reports zero.
  //
  // Silent messages are excluded even though — unlike shadowed ones — they
  // are rendered in the list: not bumping the unread count is the definition
  // of the flag rather than a side effect of hiding the message. It is also
  // what [MessageRules.canCountAsUnread] and the channel's own unread count
  // already do, so counting them here would make the divider disagree with
  // `channel.state.unreadCount` in the same view.
  bool _countsTowardsUnreadIndicators(Message message, OwnUser? currentUser) {
    if (currentUser == null) return false;
    if (!currentUser.isReadReceiptsEnabled) return false;

    if (message.silent) return false;
    if (message.shadowed) return false;
    if (message.isEphemeral) return false;

    // Thread replies don't count towards the channel's unread state unless
    // they were explicitly also sent to the channel.
    if (message.parentId != null && message.showInChannel != true) return false;

    final sender = message.user;
    if (sender == null) return false;
    if (sender.id == currentUser.id) return false;

    if (message.isNotVisibleTo(currentUser.id)) return false;

    final isSenderMuted = currentUser.mutes.any((it) => it.target.id == sender.id);
    if (isSenderMuted) return false;

    return true;
  }

  // Captures [_markUnreadViewportSnapshot] the first time this is called,
  // and otherwise checks [itemPositions] against it, latching
  // [_markUnreadViewportDiverged] the first time they genuinely differ.
  // Deliberately latching rather than re-comparing *current* positions
  // against the snapshot on every check: a user who scrolls away and back
  // settles at the exact same rest position, which would otherwise look
  // unchanged and re-block a mark-read the round trip should already have
  // earned. Safe to call on every position-changed tick — a no-op once
  // already diverged.
  //
  // Compares the set of visible item *indices* rather than full
  // [ItemPosition]s (which also carry leading/trailing edge offsets) — an
  // unrelated relayout that nudges an edge by a fraction of a pixel isn't
  // evidence the user did anything, and shouldn't count as divergence.
  void _checkMarkUnreadViewportDivergence(Iterable<ItemPosition> itemPositions) {
    final visibleIndices = itemPositions.map((it) => it.index).toList();

    if (_markUnreadViewportSnapshot == null) {
      _markUnreadViewportSnapshot = visibleIndices;
      return;
    }
    if (_markUnreadViewportDiverged) return;

    const indicesEquality = UnorderedIterableEquality<int>();
    if (!indicesEquality.equals(visibleIndices, _markUnreadViewportSnapshot)) {
      _markUnreadViewportDiverged = true;
    }
  }

  // Marks divider A's anchor as seen once it renders on screen, or once the
  // user scrolls past it without it ever rendering (a fast fling can skip
  // intermediate frames). Sticky: never reverts once true, and reset only
  // when the baseline is recaptured (channel change, or an explicit
  // mark-unread — see [handleCurrentUserReadChanged]).
  //
  // Sessions started by an explicit mark-unread require scrolling *past*
  // the anchor, since it starts out on screen — see
  // [_unreadFromManualMarkUnread].
  //
  // Returns true iff this call flips [_hasSeenFirstUnread] from false to
  // true.
  bool _maybeUpdateHasSeenFirstUnread(Iterable<ItemPosition> itemPositions) {
    if (_isThreadConversation || _hasSeenFirstUnread.value) return false;

    final anchorId = _unreadDivider.value.anchorId;
    if (anchorId == null) return false;

    final anchorMessageIndex = _messages().indexWhere((it) => it.id == anchorId);
    if (anchorMessageIndex == -1) return false;
    final anchorItemIndex = anchorMessageIndex + 2;

    final visibleIndices = itemPositions.map((position) => position.index).toList();
    if (visibleIndices.isEmpty) return false;

    // Smaller item indices are newer. That is a property of the
    // index-to-message mapping (`messages[i - 2]`, newest first), not of the
    // scroll direction, so it holds regardless of `config.reverse`. If even
    // the newest visible item is older than the anchor, the anchor is no
    // longer in view and the user has scrolled back past it into read
    // history.
    final isScrolledPast = visibleIndices.reduce(min) > anchorItemIndex;

    if (_unreadFromManualMarkUnread) {
      // The anchor of a manual mark-unread is the message the user was
      // looking at when they marked it, so it's on screen from the outset.
      // Counting that sighting would dismiss the pill on the very next
      // layout tick — the smallest scroll, or none at all. Only actually
      // scrolling past the boundary retires it.
      if (!isScrolledPast) return false;
    } else if (!visibleIndices.contains(anchorItemIndex) && !isScrolledPast) {
      return false;
    }

    _hasSeenFirstUnread.value = true;
    return true;
  }

  // Marks messages as read if the conditions are met.
  //
  // In a thread: the parent must have at least one reply — the server-side
  // thread object doesn't exist until the first reply lands, so
  // `markThreadRead` on a reply-less parent 404s. A thread read is
  // independent of where the parent channel's own loaded window sits.
  //
  // In the channel, all of:
  //  1. The newest page is loaded (`isUpToDate`).
  //  2. There is something unread to mark.
  //  3. The bottom has been seen — either it's visible now ([isAtBottom]),
  //     or it was visible earlier and the user has since scrolled away
  //     (`hasSeenLastMessage`).
  //  4. If there's an active manual mark-unread (`isMarkedAsUnread`), the
  //     viewport must genuinely differ from the one snapshotted when it
  //     was first observed (`_markUnreadViewportSnapshot`) — otherwise the
  //     anchor being immediately "visible" again (it's usually the very
  //     message just marked, with nothing yet scrolled) would undo the
  //     user's action instantly.
  //  5. Divider A's anchor has actually been seen or scrolled past
  //     (`hasSeenFirstUnreadMessage`) — trivially satisfied when there is
  //     no boundary to see in the first place: the channel opened fully
  //     read, the user has never opened it at all (no `lastReadMessageId`,
  //     so the anchor could only resolve once top pagination reached the
  //     very start of the channel — effectively never for real history),
  //     or the channel uses local unread counts and so has no server read
  //     state to anchor against.
  Future<void> _maybeMarkMessagesAsRead({required bool isAtBottom}) async {
    final channel = _channel();
    if (channel == null) return;

    final isInThread = _isThreadConversation;

    if (isInThread) {
      // A server-side thread object only exists once the parent has at
      // least one reply; markThreadRead on a reply-less parent returns 404.
      if ((_parentMessage()?.replyCount ?? 0) == 0) return;
      return _debouncedMarkMessagesAsRead();
    }

    final isUpToDate = channel.state?.isUpToDate ?? false;
    if (!isUpToDate) return;

    final unreadCount = channel.state?.unreadCount ?? 0;
    if (unreadCount <= 0) return;

    // True both when the channel opened fully read (no baseline) and when
    // the user has never opened it (a baseline with no `lastReadMessageId`).
    // Neither has a boundary the user could reach, so requiring one would
    // leave the channel permanently unread — see condition 5 above.
    final hasNoUnreadBoundary = _unreadBaselineCaptured && _unreadBaseline?.lastReadMessageId == null;
    // Equivalent to `channel.usesLocalUnreadCount`, spelled out via
    // `channel.client` rather than `Channel`'s private client field so it
    // stays evaluable against a test double that only implements the public
    // API surface.
    final usesLocalUnreadCount = channel.client.isLocalUnreadCountEnabled && !channel.canUseReadReceipts;
    final hasSeenFirstUnreadMessage = hasNoUnreadBoundary || _hasSeenFirstUnread.value || usesLocalUnreadCount;
    final isMarkedAsUnread = channel.state?.isMarkedAsUnread ?? false;
    final hasSeenLastMessage = _hasSeenLastMessage || isAtBottom;

    if (!hasSeenLastMessage) return;
    if (!hasSeenFirstUnreadMessage) return;

    if (isMarkedAsUnread) {
      // [handleItemPositionsChanged] already keeps this up to date on
      // every position-changed tick; this call only matters as a fallback
      // if this is ever reached some other way. See
      // `_markUnreadViewportSnapshot`'s doc comment for why the guard has
      // to latch on divergence rather than checking `isMarkedAsUnread`
      // directly as a persistent gate.
      _checkMarkUnreadViewportDivergence(_itemPositions());
      if (!_markUnreadViewportDiverged) return;
    }

    // Everything the gate above reads is in the key, so an attempt is only
    // skipped when repeating it could not produce a different outcome.
    final attempt = (
      newestMessageId: _messages().firstOrNull?.id,
      unreadCount: unreadCount,
      isMarkedAsUnread: isMarkedAsUnread,
      viewportDiverged: _markUnreadViewportDiverged,
    );
    if (attempt == _lastMarkReadAttempt) return;
    _lastMarkReadAttempt = attempt;

    await _debouncedMarkMessagesAsRead();
    _hasSeenLastMessage = false;
    _markUnreadViewportSnapshot = null;
    _markUnreadViewportDiverged = false;
  }

  /// Cancels the pending debounced mark-reads and disposes the notifiers.
  ///
  /// The list must tear down anything that could still write to this
  /// controller — stream subscriptions, position listeners — before calling
  /// this.
  void dispose() {
    _disposed = true;
    _debouncedMarkRead.cancel();
    _debouncedMarkThreadRead.cancel();
    _unreadDivider.dispose();
    _unreadDividerGrowth.dispose();
    _hasSeenFirstUnread.dispose();
    _scrollToBottomBadge.dispose();
    _hasLaidOut.dispose();
  }
}
