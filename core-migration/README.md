# Migrating `stream_chat` onto `stream_core`

The plan for moving the low-level client's **foundation** — HTTP, errors, token/auth, WebSocket
transport, uploads, query DSL, logger, platform detection, utils — off its hand-written
implementations and onto `stream_core`, the shared package `stream_feeds` is already built on.

One file per phase, in the order they should land. Each carries a goal, the exact types in scope
with their core counterparts, the decisions that phase has to make, its risks, the upstream
`stream_core` work it needs, and a definition of done.

Two indexes cut across the phases:

- [`DEFERRED.md`](DEFERRED.md) — everything consciously postponed, and what unblocks each item.
- [`UPSTREAM.md`](UPSTREAM.md) — what should move the *other* way, chat → core.

| | Phase | Chat LOC | Core LOC | Breaking | Status |
| --- | --- | --- | --- | --- | --- |
| [01](01-utilities.md) | Utilities — in-flight cache, list extensions | ~340 | ~200 | decision | ◐ |
| [02](02-platform-and-environment.md) | Platform detector & system environment | ~330 | ~300 | yes (rename) | ◐ |
| [03](03-errors.md) | Errors & the `Result` surface | ~410 | ~900 | **yes** | ◐ |
| [04](04-token-and-auth.md) | Token & auth | ~225 | ~500 | **yes** | ◐ |
| [05](05-http-client.md) | HTTP client & interceptor pipeline | ~600 | ~150 | yes | ◐ |
| [06](06-logger.md) | Logger | ~120 | ~670 | **yes** | ☑ |
| [07](07-websocket.md) | WebSocket transport | ~790 | ~1,940 | **yes** | ☐ |
| [08](08-query-dsl.md) | Query DSL — filter, sort, comparable field | ~600 | ~1,420 | **yes** | ☐ |
| [09](09-uploads.md) | Uploads & CDN | ~520 | ~1,400 | yes | ☐ |
| [10](10-cleanup.md) | Cleanup — deps, barrel, deprecation kit | — | — | no | ☐ |

Status key: ☐ not started · ◐ partly landed · ☑ done.

**Net:** ~4.0k LOC of hand-written `lib/src` deleted (of ~29.0k), replaced by ~5.5k LOC of core
that is already written and tested. Six direct dependencies become transitive.

**In progress.** Phases 01–06 have each landed their core adoption; what is left in them is
indexed in [`DEFERRED.md`](DEFERRED.md), which says what unblocks each item. Notably 06 removed
chat's own logger outright rather than bridging it, so no package in the repo imports
`package:logging` any more.

## Scope

**In scope: the foundation `stream_core` owns.** Every subsystem where chat has a second
implementation of something core already ships.

**Out of scope: the endpoint and DTO migration.** That is [`openapi-migration/`](../openapi-migration/README.md)
— 12 feature groups moving 109 hand-written methods onto the generated client. The two tracks are
independent by design; phase [05](05-http-client.md) is what keeps them so, and phase
[03](03-errors.md) owns the error/`Result` slice that `openapi-migration/01-foundation.md`
previously claimed.

**Out of scope: architectural parity with `stream_feeds`.** Feeds is repositories + `*Data` models
+ `StateNotifier` state objects + a `StateUpdateEvent` domain bus. `StreamChatClient`, `Channel`,
`ChannelClientState`, `ChatPersistenceClient`, `Event` and all 48 public models **stay as they
are**. Adopting feeds' layout would be a ~15k-LOC rewrite plus a Drift schema migration, and it
buys nothing this plan is after.

**Out of scope: moving the WebSocket to v2.** Phase [07](07-websocket.md) adopts core's WS
*machinery* on the existing **v1** protocol and v1 event shapes. See that file for why this is
possible; it is the finding that un-deferred the phase.

## Goals

1. **One implementation of each foundation concern**, so a fix to token refresh or reconnection
   lands once for every Stream product rather than once per SDK.
2. **Errors from `stream_core`**, so a Flutter integrator handling a Stream error handles it the
   same way in chat, feeds and video.
3. **Stop the drift.** Six of these subsystems are near-verbatim forks of core, and they have
   already diverged in ways that are bugs on our side — core's `AuthInterceptor` has a
   retry-loop guard, a user-switch guard and a `FormData` re-clone that ours lacks.
4. **An upgrade path that is boring**, because every break appends to
   `migrations/v11-migration.md` and ships a `dart fix` transform as it lands.

## Non-goals

- Rewriting our public models. Chat's `User`, `Event`, `AttachmentFile` and the rest are richer
  than core's lowest-common-denominator versions or are persisted to Drift. See
  [Decisions inherited by every phase](#decisions-inherited-by-every-phase).
- Exporting `stream_core` wholesale from `lib/stream_chat.dart`. Feeds does; we cannot.
- Moving chat-specific machinery into core. `RetryPolicy` / `RetryQueue`, `PaginationParams`,
  `ConnectionIdManager`, `EventType` and `Serializer` stay here.

## Order, and why

**01–03 are strictly sequential. Once [03](03-errors.md) lands, 04–09 can each proceed on their
own.** [10](10-cleanup.md) is last by definition.

The order runs cheapest-and-invisible → breaking-but-isolated → breaking-and-entangled, so the
pattern is proven on surfaces nobody sees before it reaches the WebSocket and the query DSL:

- **01** touches no public signature and one of its two files already carries a TODO asking for
  exactly this. It is the pattern-proving slice.
- **02** is the first rename, on a surface almost nobody imports.
- **03** is the keystone: the sealed `StreamException` family replaces our error tree, and
  everything downstream assumes it.
- **04–06** are each self-contained, and each is one clear break with one clear migration entry.
- **07** and **08** are the two substantial phases. 07 rewrites `connectUser` around state
  observation; 08 requires declaring every filterable field as a typed `FilterField`.
- **09** is gated on a decision (whether core grows channel-scoped CDN ops) rather than on volume,
  and it has to agree with `openapi-migration/12-uploads-cdn.md` before either starts.

## Decisions inherited by every phase

Decided once here, not re-argued per phase.

### The barrel is a `show` allowlist

`stream_feeds` opens its barrel with `export 'package:stream_core/stream_core.dart';`. **We
cannot.** Exporting core wholesale from `lib/stream_chat.dart` still collides on `AttachmentFile`,
`Filter`, `FilterOperator`, `NullOrdering`, `ComparableField`, `CurrentPlatform`, `PlatformType`,
`TokenManager`, `AuthType`, `User`, `LoggingInterceptor`, `InterceptStep`, `LogPrint`,
`AuthInterceptor` and `ConnectionIdInterceptor`. Core also re-exports all of dio, while our barrel
deliberately re-exports a *narrowed* dio — and `package:async`, which our barrel also re-exports,
declares a `Result` of its own.

Each landed phase shortens that list, since an adopted type stops being a duplicate:
`InFlightCache`, `SystemEnvironment`, `SystemEnvironmentManager`, `XStreamClientHeaderExtension`
and `Success` are already off it — the last because phase [03](03-errors.md) renamed
`UploadState`'s variants. The allowlist is the mechanism throughout —
grow it phase by phase rather than switching to a wholesale export at the end.

Narrowing is already the precedent in that file: `filter.dart show Filter, FilterOperator` and
`device_api.dart show PushProvider`.

### What stays ours

| Type | Why |
| --- | --- |
| `User` / `OwnUser` | Ours is far richer and `implements ComparableFieldProvider`. Record the decision in `openapi-migration/09-users.md`. |
| `AttachmentFile` | Ours is `@JsonSerializable` and persisted to Drift; core's wraps `XFile` with async `size` and non-nullable `path`. |
| `ConnectionIdManager` | Connection-id is threaded into request *semantics*, not just headers — `client.dart:774` and `:907` early-return on `hasConnectionId`, `:1071` uses it to pick a query parameter. It cannot collapse into core's `ConnectionIdGetter` closure whatever core ships. Keep the manager; feed core's interceptor from it. |
| `Event`, `EventType`, `event_resolvers.dart`, `EventController` | Chat's event vocabulary. Phase 07 makes `Event extend WsEvent`; it does not replace it. |
| `RetryPolicy`, `RetryQueue` | Request-level message retry. Core has none, and `RetryQueue` closes over `Channel`, `client.retryPolicy` and `EventType.connectionRecovered`. |
| `PaginationParams` | Core has no pagination type at all. |
| `Serializer`, `message_rules.dart`, `AppSettingsManager` | Chat domain. |

### Where the Flutter-side providers live

`NetworkStateProvider` and `LifecycleStateProvider` are **interfaces only** in core; it ships no
implementations. Implement them in **`stream_chat_flutter_core`**, which already has the
`connectivity_plus` + `WidgetsBindingObserver` code that phase 07 replaces.

Not in `stream_core_flutter`: that package is a design system with zero client coupling — no WS,
HTTP or token types anywhere in its public API — and putting transport providers there destroys
the property. It is the eventual right home; it is not this plan's job to move it there.

### Upstream core work is batched, not blocking

Tracked in [`UPSTREAM.md`](UPSTREAM.md), which also covers the reverse direction — things chat has
that every product needs, and things chat's use has shown core to be missing or wrong about.

Each phase names the `stream_core` changes it needs, and those should be grouped into as few core
releases as possible. Only one is a hard block on API we already ship publicly: `Filter`'s
`$ne` / `$nin` / `$nor` operators, for phase [08](08-query-dsl.md).

**Diff against the resolved package, not the sibling repo.** Two of this plan's original upstream
asks turned out to be already satisfied, because they had been derived from
`stream-core-flutter`'s unreleased `main` rather than from
`~/.pub-cache/hosted/pub.dev/stream_core-0.5.0`, which is what `stream_chat` actually resolves.
The distinction also changes the *kind* of ask: something already on core's `main` needs a
release, not a PR.

Cross-repo workflow is in [`STYLE_GUIDE.md`](../STYLE_GUIDE.md) (§Dependency management): a path
dependency while both repos change together, back to a hosted constraint in `melos.yaml` before
release. Never edit a package's `pubspec.yaml` constraints directly.

## Prerequisites

**None. This can start today**, which contradicts what the two existing docs say. Verified against
the tree rather than the docs:

- `melos.yaml:108` declares `stream_core: ^0.5.0` **hosted**. There are zero `stream_core` entries
  in any `dependency_overrides` block — the five that exist are path overrides for sibling chat
  packages. `packages/stream_chat/.dart_tool/package_config.json` resolves `stream_core` to
  `~/.pub-cache/hosted/pub.dev/stream_core-0.5.0`. The 8-place git pin the `openapi-codegen` skill
  describes has been collapsed.
- `stream_core` 0.5.0 shipped both the sealed error layer (core #168) and the
  `AttachmentUploadTask` API (core #170), so nothing in phases 03 or 09 waits on a core release.
- `lib/open_api/api/default_api.dart:783` already calls `runApiSafely`, not `runSafely`.
- The two `if: false` jobs in `.github/workflows/pana.yml` were justified by a git-vs-hosted
  `stream_core` solve that can no longer happen: probing each package standalone, without the
  `dependency_overrides` melos generates, both resolve and pull `stream_core 0.5.0` hosted from
  pub.dev. **Re-enabled** in the same PR that creates this directory. Note that this verified the
  *resolve*, not the score — those jobs gate on `min_score: 100`, so confirming they actually pass
  needs a CI run (carried in phase [10](10-cleanup.md)'s definition of done).

## How to execute a phase

Read this README, then the phase file, then `stream-core-flutter/ERROR_LAYER.md` if the phase
touches errors or the WebSocket — it is normative and nothing in this repo references it.

`stream_feeds` is the worked example for every phase. The files worth reading before you start:

| For | Read |
| --- | --- |
| Client assembly, interceptor order, connect/disconnect/dispose lifecycle, guest exchange | `stream_feeds/lib/src/client/feeds_client_impl.dart` |
| The WS codec and the events the spec doesn't define | `stream_feeds/lib/src/ws/feeds_ws_event.dart`, `ws/events/events.dart` |
| A `CdnClient` implementation and a hand-written multipart retrofit interface | `stream_feeds/lib/src/cdn/` |
| `FilterField` / `SortField` registries with local value extractors | `stream_feeds/lib/src/state/query/` |
| Testing a real client with only the transport mocked | `stream_feeds_test/helpers/`, `testers/base_tester.dart` |
| The rename soft-landing kit | `stream_feeds/lib/src/generated_typedefs.dart`, `lib/fix_data.yaml` |

Consumer-facing changes go in `migrations/v11-migration.md` **in the same PR that makes them** —
the guide is written as the work happens, not reconstructed at release. One phase per PR, titled
`refactor(llc)!:` when it breaks. Close the loop by ticking the phase's definition of done and its
status box in the table above.

---

## Which PR lands which phase

**The status column above describes the finished stack, not the PR you are reading it in.** The
work ships as six stacked PRs and the phase numbering does not line up with them: a phase can
split across two PRs, and one PR can carry three phases. So a phase marked ☑ may describe code
that lands above the rung you are looking at — at the first rung, none of phase 01 is present yet.

| Phase | Lands in |
| --- | --- |
| 01 Utilities | in-flight cache in **#2956**; list extensions in **#2959** |
| 02 Platform & environment | `SystemEnvironment` in **#2956**; platform detector in **#2960** |
| 03 Errors | error layer in **#2956**; old tree deleted, sealed family in **#2960** |
| 04 Token & auth | **#2956** |
| 05 HTTP client & interceptors | **#2956**, partially — see the phase doc |
| 06 Logger | **#2956** |
| 07 WebSocket | parked; nothing lands |
| 08 Query DSL | `Sort` in **#2957**; `Filter` in **#2958**; `LocationCoordinate` and the sort normalizer in **#2959** |
| 09 Uploads · 10 Cleanup | not started |

Two consequences worth knowing before reading a phase doc against the code:

- **A phase doc is accurate about the stack, not about its own PR.** Checking a ☑ against the rung
  you are on will mislead you; check it against the tip.
- **`stream_chat_dio_error` (01) and the precondition-throw reclassification (03) never landed at
  all.** They are tracked in [DEFERRED.md](DEFERRED.md), which is the authority on what is still
  outstanding.
