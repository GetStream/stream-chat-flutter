# 06 — Logger

**Goal:** log through core's `StreamLogger` so the whole SDK — including the core code phases
04–07 pull in — writes to one place.

**Size:** ~120 chat LOC deleted across two packages, 84 call sites rewritten, ~670 core LOC
adopted. `package:logging` leaves the repo entirely.

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

## Decisions taken

- **The prefix is `SCh`**, declared once as `streamChatLogTag`. Not `SC` (core's) and not `CH`
  (collides with nothing today and everything later). Retagging invalidates every consumer's log
  filter, so this is worth fixing in one place.
- **`logLevel` and `logHandlerFunction` become one `logConfig`.** An earlier pass kept their types
  with a bridge behind them; that was reversed — see [What landed](#what-landed).
- **The per-subsystem emoji naming stays for chat's own loggers.** Core types get `SCh:`-prefixed
  string tags, because that is what `StreamLogFilter.prefix` matches on; the emoji still read
  better in a console for chat's own records.

## Risks

- **Anyone wiring `Logger.root.onRecord` sees their logs stop.** Chat's loggers were detached, so
  they never reached `Logger.root` anyway — but anyone who passed `logHandlerFunction` gets a
  compile error rather than silence, which is the outcome to want.
- Global logger state means a chat client constructed after a feeds client overwrites the feeds
  configuration. Nothing in this plan fixes that; the tag prefix only makes the result legible.
  Worth raising upstream if it bites.
- `StreamLogger.configure` should be called **once**, from the client constructor, and not at all
  when the consumer passed no config — installing a default handler where there was none turns a
  silent SDK noisy.

## Upstream `stream_core` work

None required. Worth raising, not blocking: the process-global handler means two Stream SDKs
cannot log independently in one app.

## What landed

**The whole thing: `package:logging` is gone from every package in the repo.** An earlier pass
shipped a bridge instead — a `StreamLogHandler` forwarding core's records into chat's `Logger` —
which was the wrong call and is deleted. It left two logging systems alive, which is the problem
this phase exists to solve, and it was code whose only purpose was to be deleted later.

**Why it was urgent either way.** An unconfigured `StreamLogger` uses `StreamLogHandler.silent`
with `minPriority(.none)` — it drops *everything*. Every record from the HTTP client, the token
manager and (after [07](07-websocket.md)) the whole WebSocket stack was going nowhere. That makes
06 a prerequisite for **07** as much as for 05: adopting core's WS without it would have made
chat's connection logging silent.

**What replaced it:**

| Was | Now |
| --- | --- |
| `logLevel: Level`, `logHandlerFunction: LogHandlerFunction` | `logConfig: StreamLogConfig` |
| `client.logger` (a `Logger`) | `client.logger` (a `StreamLogger`) |
| `detachedLogger(name)`, `defaultLogHandler`, `LogHandlerFunction`, `_levelEmojiMapper` | gone — `StreamLogHandler.console()` is the default |
| `export 'package:logging/logging.dart' show Logger, Level, LogRecord;` | core's `StreamLogger`, `StreamLogConfig`, `StreamLogHandler`, `StreamLogFilter`, `StreamLogPriority`, `StreamLogRecord` |
| `Logger?` injected into `WebSocket`, `RetryQueue`, `ChannelDeliveryReporter`, `StreamHttpClient`, `StreamChatApi` | each owns a `StreamLogger`, built from a `tag` parameter |

**The default is unchanged.** `const StreamLogConfig()` is `priority: warning` with
`StreamLogHandler.console()` — exactly what chat documented before ("write all messages with level
Warn or Error to stdout"). Nobody who never touched logging sees a difference.

**Tags are parameters, not constants.** Core's pattern: a class takes `{String tag = 'SC:WsClient'}`
and builds `StreamLogger(tag)`; the product passes its own at the construction site. Chat's
infrastructure classes follow it, so a tag can be overridden. `StreamChatClient.logger` and
`Channel` hold a `const StreamLogger(...)` instead, matching feeds' `const StreamLogger('SF:Client')`
— they *are* the site.

**Prefix: `SCh`.** Not `SC` — that is `stream_core`'s, and the handler is process-global, so the
prefix is the only thing keeping two SDKs' records apart. Feeds uses `SF`.

`stream_chat_persistence` moved too: it had its own `Logger.detached('💽')`, its own
`_defaultLogHandler` and its own emoji map, and its constructor no longer takes logging parameters
at all.

### Which classes take a `tag`, and which do not

Core's rule: a class takes `{String tag = '...'}` when it both logs with that tag *and* derives
children's tags from it (`'$tag:Engine'`, `'$tag:Health'`). Chat follows it for infrastructure —
`WebSocket`, `RetryQueue`, `ChannelDeliveryReporter`, `AppSettingsManager`.

Two deliberate exceptions:

- **`StreamChatClient.logger` and `Channel`** hold a `StreamLogger` directly, matching feeds'
  `const StreamLogger('SF:Client')`. They are the construction site, so there is nothing above them
  to pass a tag down.
- **`ChannelClientState` takes no tag**, because it logs nothing — it would be a knob whose only
  job is to be forwarded. It passes the queue `'SCh:RetryQueue:${channel.cid}'`, which is where the
  channel identity chat used to put in the logger *name* now lives.

Per-instance identity is appended, not nested: `SCh:RetryQueue:messaging:general`, not
`SCh:Channel:messaging:general:RetryQueue`. Nesting reads like a hierarchy but makes
`StreamLogFilter.prefix` on `SCh:RetryQueue` stop matching, and filtering by subsystem is more
useful than filtering by channel.

## What this cost, for the record

`package:logging` was woven through chat's **public** API, which is why an earlier pass tried to
avoid touching it:

| Surface | Kind |
| --- | --- |
| `StreamChatClient(logLevel: Level, logHandlerFunction: LogHandlerFunction)` | constructor params |
| `client.logger`, `client.detachedLogger(name)` | both return a `Logger` |
| `StreamChatClient.defaultLogHandler(LogRecord)` | static |
| `typedef LogHandlerFunction = void Function(LogRecord)` | typedef |
| `export 'package:logging/logging.dart' show Logger, Level, LogRecord;` | barrel re-export |
| `Logger?` parameters on `StreamHttpClient`, `StreamChatApi`, `WebSocket`, `RetryQueue`, `ChannelDeliveryReporter` | internal, but public types |

It came to four things, and only the first was mechanical:

1. **84 internal call sites** across 7 files moved from `logger.info('x')` to `logger.i(() => 'x')`.
2. **The public API changed shape** — the table above.
3. **The `package:logging` re-export and dependency went**, from `melos.yaml` and both manifests.
4. **The bridge was deleted**, along with its tests.

Doing it in v11 rather than after was the right call: v11 already breaks the error layer, the token
layer and the query DSL, so this costs a consumer one more entry in a guide they are already
reading. Shipping the bridge and breaking logging in v12 would have spent the same budget twice.

## Definition of done

- [x] `StreamLogger.configure` is called once from `StreamChatClient`, with the priority taken
      from `logConfig.priority`.
- [x] Every core type chat constructs is passed a `SCh:`-prefixed tag.
- [x] Lazy messages (`() => '...'`) throughout the logger call sites.
- [x] `melos run analyze` and `melos run format` clean; `stream_chat` 1670 tests green.
- [ ] `logLevel` / `logHandlerFunction` / `logger` / `detachedLogger` deprecated — deferred with
      the rest of the removal above, since deprecating them needs the replacement to exist.
- [ ] Status box updated in `README.md`.
