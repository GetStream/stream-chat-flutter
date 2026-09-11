# Message ordering

**What this is:** the findings from chasing why messages sharing a `createdAt` sometimes
change places, written down because most of the obvious fixes are wrong and the reasons are
not visible from the code.

**Status:** one real defect left, named at the bottom. Everything above it is either already
fixed or a dead end that looked promising.

## The comparator is not a total order

```dart
// channel_client_state.dart
int _sortByCreatedAt(Message a, Message b) => a.createdAt.compareTo(b.createdAt);
```

Two distinct messages can compare equal, so their relative order is whatever last touched the
list. A merge, an upsert and a fresh query can each settle it differently.

`createdAt` is worse than it looks:

```dart
// message.dart
DateTime get createdAt => remoteCreatedAt ?? localCreatedAt ?? DateTime.now();
```

When both are null the getter answers **a fresh value on every read**, so the comparator is not
even self-consistent — `compare(a, b)` and `compare(b, a)` can both return `-1`. Measured on a
message carrying neither timestamp: `compare(a, b) == 0` in **19388 of 20000** reads, because
two `DateTime.now()` calls usually land in the same microsecond. Sorting against that is
undefined behaviour, and two tests in `channel_test.dart` depend on the current outcome.

## Rejected: tie-break on `id`

Deterministic, and wrong. `Message.id` is `id ?? const Uuid().v4()` — a random v4 uuid. Ordering
ties by it says nothing about when a message was sent or arrived, and a tie almost always means
two messages sent at nearly the same moment, where arrival order is what a reader expects. It
trades *usually right* for *reliably arbitrary*.

Tried it: two `channel_test.dart` cases fail, both jump-to-message, because the fixtures build
messages with no timestamps and expect insertion order to survive.

**`message_dao` is not a precedent for this.** It orders `getMessagesByCid` and
`getThreadMessagesByParentId` by `(createdAt, id)`, which reads like the SDK has already chosen
`id` as a display tiebreak. It has not — the tuple is keyset-pagination machinery, and the file
says so:

> Cursor predicates compare the full `(createdAt, id)` tuple — the same key used in ORDER BY —
> so replies sharing a `createdAt` fall on the correct side of the boundary.

A cursor needs *some* total order to avoid skipping or repeating rows across pages. Which one is
irrelevant there, so a uuid is fine. That is a different problem from what the reader sees.

## Rejected: stamp `localCreatedAt` at construction

The field exists and is local-only (not serialised), so defaulting it in the constructor looks
like it would make `createdAt` stable without touching the wire. It does make it stable per
instance, and identical payloads stay equal if the default is conditional on `createdAt` being
absent — but it still does not give a total order:

**500 of 500** rounds building five messages in a list literal produced at least one duplicate
timestamp. `DateTime.now()` cannot resolve construction that fast. Anything that wants a total
order needs a monotonic sequence, not a clock.

## Not the same defect: `client.dart:646`

```dart
final events = res.events.sorted((a, b) => a.createdAt.compareTo(b.createdAt));
```

Same shape, different subject — these are `/sync` **events**, not messages, and their replay
sequence is meaningful. An `id` tiebreak would impose an arbitrary order on same-instant events.
Worth knowing separately that `sorted` is not stable, so same-instant events already lose the
order the server sent them in.

## Already fixed, recorded so nobody re-derives it

The duplicate-key crash in [#2660](https://github.com/GetStream/stream-chat-flutter/pull/2660)
was the merge manufacturing duplicates itself, not persistence handing them over. `merge`'s
non-overlapping concat fast path skipped dedup, and Drift stored `DateTime` as unix **seconds**,
so one message id carried a microsecond-precision `createdAt` in memory and a second-truncated
one from the cache — violating the "same key ⇒ same compare value" precondition on every round
trip. #2660 removed the fast path; [`7f0804d2d`](https://github.com/GetStream/stream-chat-flutter/commit/7f0804d2d)
made persistence store ISO-8601 text. Reproduced end to end on a worktree at `d07f633dd^`.

## What is actually left

A replacement that ties with its neighbours is placed **behind** them by `sortedMerge`, where
`merge` leaves it in front. So editing a message whose `createdAt` ties with the next one moves
it down the list.

The fix is tie-stability in the merge, not a comparator change: keep the resolved element in the
receiver's slot when it sorts where the original sat. Prototyped and working, but it needs the
resolved intersection up front and a consumed-key set, which measured **1.28–1.39x** at n=100 and
**1.08–1.17x** at n=1000 after two rounds of tuning. That is why `stream_core`'s `sortedMerge`
ships without it, and why the behaviour is pinned by a test rather than left to drift.

Worth confirming before anyone spends that: **Android prioritises `createdLocallyAt` over
`createdAt`** when sorting, the opposite of this SDK's `remoteCreatedAt ?? localCreatedAt`. If
that is right, the server echo does not re-place a message on Android the way it does here, and
the two SDKs disagree about something more basic than ties. Taken from documentation rather than
source — read the Android comparator before acting on it.
