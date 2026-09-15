# 06 — Logger

**Goal:** log through core's `StreamLogger` so the whole SDK — including the core code phases
04–07 pull in — writes to one place.

**Size:** no chat LOC deleted (chat has no logger abstraction); ~670 core LOC adopted. Breaking on
a public re-export.

## Scope

Chat has no logger of its own. It uses `package:logging` directly and **re-exports it**:

```dart
export 'package:logging/logging.dart' show Logger, Level, LogRecord;   // stream_chat.dart:15
```

`Logger.detached` instances are built per subsystem in `client.dart:275,303,342` (with emoji
names — 📡 🕸️ 🔌 🧾), and `StreamChatClient(logger:)`, `RetryQueue(logger:)`,
`WebSocket(logger:)` and `StreamHttpClient(logger:)` all take a `Logger?`.

Core ships a family instead:

| Type | Role |
| --- | --- |
| `StreamLogger(String tag)` | `v` / `d` / `i` / `w` / `e` / `log`; resolves handler and filter at write time |
| `StreamLogMessage = String Function()` | lazy — the message is never built if it won't be logged |
| `StreamLogHandler` | `.console()`, `.composite()`, `.filtered()`, `.from(callback)`, `silent`. **Subclass this to bridge.** |
| `StreamLogFilter` | `.always()`, `.minPriority(p)`, `.prefix({tag: priority})` — longest matching prefix wins |
| `StreamLogPriority` | `verbose` … `none`, comparable, with emoji and label |
| `StreamLogConfig` | `{priority, handler, filter}` |
| `StreamLogger.configure(StreamLogConfig?)` | called once by the client; installs nothing when given nothing |

**Half of this arrives whether we plan for it or not.** Core's `AuthInterceptor` (phase 04) and
every core WS class (phase 07) already log through `StreamLogger`. Without this phase, chat's logs
split across two systems with no way to see both.

### Bridge, don't break

Ship a `StreamLogHandler` subclass that forwards a `StreamLogRecord` to a user-supplied `Logger`,
so `StreamChatClient(logger:)` keeps working through a deprecation cycle:

```dart
// sketch — a handler that keeps package:logging consumers working
class _LoggingBridgeHandler extends StreamLogHandler {
  const _LoggingBridgeHandler(this._logger);
  final Logger _logger;

  @override
  void handle(StreamLogRecord record) => _logger.log(
    _levelFor(record.priority),
    record.message,
    record.error,
    record.stackTrace,
  );
}
```

That way `logger:` becomes "route core's records into my `Logger`" rather than "the SDK ignores
you", and the `package:logging` re-export can stay for one release before phase
[10](10-cleanup.md) drops it.

### Claim a tag prefix

`StreamLogger`'s handler, priority and filter are **process-global write-only statics**, and
`StreamLogRecord`'s sequence number is a static counter. Two Stream SDKs in one app settle on
whichever client was constructed last.

A tag prefix does not fix that — it decides which records a *given* filter passes, not who owns
the handler. So the prefix is half the answer and the other half is a rule: **`StreamLogger` is
configured by the last `StreamChatClient` constructed, and chat never configures it implicitly.**
`logConfig` defaults to `const StreamLogConfig()`, which is the same configuration the previous
client would have installed, so a second client is a no-op unless the caller passed one — and a
caller who passes one is asking for it. Say that on `StreamChatClient.logConfig`, and leave
process-wide arbitration to whoever owns the process.

The prefix `StreamLogFilter.prefix` filters on:

| SDK | Prefix |
| --- | --- |
| `stream_core` | `SC:` |
| `stream_feeds` | `SF:` |
| `stream_chat` | **pick one and use it everywhere** — e.g. `SCh:` |

Core's constructors take `tag:` parameters (`StreamWebSocketClient(tag: ...)`,
`AuthInterceptor(tag: ...)`, `LoggingInterceptor(tag: ...)`, `ConnectionRecoveryHandler(tag: ...)`)
precisely so a product can namespace them — feeds passes `SF:Ws`, `SF:Http`, `SF:HttpAuth`,
`SF:WsRecovery`. Pass chat's equivalents everywhere phases 04, 05 and 07 construct a core type.

## Decisions to make

- **The chat prefix.** `SCh:` is unambiguous but ugly; `CH:` is cleaner but collides with nothing
  today and everything tomorrow. Pick it here and write it down — retagging later invalidates
  every consumer's log filter.
- Whether `StreamChatClient(logger:)` keeps its `Logger?` type behind the bridge, or changes to
  `StreamLogConfig?` immediately with `logger:` deprecated alongside. The bridge is friendlier; two
  parameters for one concern is uglier.
- Whether to keep the per-subsystem emoji naming. Core's tags serve the same purpose and filter
  better; the emoji do read nicely in a console.

## Risks

- **Anyone wiring `Logger.root.onRecord` sees their logs stop** unless the bridge is in place.
  That is the visible break, and it is silent — no compile error, just no output.
- Global logger state means a chat client constructed after a feeds client overwrites the feeds
  configuration. Nothing in this plan fixes that; the tag prefix only makes the result legible.
  Worth raising upstream if it bites.
- `StreamLogger.configure` should be called **once**, from the client constructor, and not at all
  when the consumer passed no config — installing a default handler where there was none turns a
  silent SDK noisy.

## Upstream `stream_core` work

None required. Worth raising, not blocking: the process-global handler means two Stream SDKs
cannot log independently in one app.

## Definition of done

- [ ] `StreamLogger.configure` is called once from `StreamChatClient`, and not at all when no
      config was supplied — a test asserts the no-config case installs nothing.
- [ ] Every core type chat constructs is passed a chat-prefixed `tag:`.
- [ ] The `package:logging` bridge handler exists, and a test asserts a record logged by core's
      `AuthInterceptor` reaches a consumer-supplied `Logger`.
- [ ] `logger:` parameters are deprecated with a message naming the replacement.
- [ ] Lazy messages are used (`() => '...'`), not eagerly-built strings.
- [ ] `melos bootstrap && melos run analyze && melos run test:dart && melos run test:flutter`.
- [ ] `refactor(llc)!:` title, `🛑️ Breaking` CHANGELOG entry, `migrations/v11-migration.md`
      Symbol Map rows for the `package:logging` re-export and each `logger:` parameter.
- [ ] Decisions recorded here — **especially the tag prefix** — and status box ticked in
      `README.md`.
