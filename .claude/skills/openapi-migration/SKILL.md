---
name: openapi-migration
description: >
  Plan and land the migration of one feature onto the OpenAPI-generated client that ships in `lib/open_api/` —
  scope the feature, inventory it, decide which shape each symbol keeps, sequence the work, then implement and
  verify. Use when planning or executing a feature's migration, or when deciding whether a difference between our
  API and the generated one justifies a breaking change. For regenerating the client or fixing the generator, use
  the `openapi-codegen` skill instead.
allowed-tools:
  - Bash
  - Read
  - Edit
  - Write
  - Grep
  - Glob
---

# openapi-migration

The migration onto the generated client runs **feature by feature**: `stream_chat` talks to the API through both
the hand-written layer and the generated one, and each PR moves one feature across completely. This skill is the
process for planning and landing one of them.

Two documents bracket this work, and you should read both before starting:

- **`openapi-migration/`** — the plan. Its `README.md` has the group order, sizes and status; each numbered file
  is one feature group with its scope tables (hand-written methods ↔ generated operations), decisions, risks and
  definition of done. `01-foundation.md` holds the cross-cutting decisions every group inherits. **Start from your
  group's file** rather than re-deriving the inventory — phase 1 below is largely done there already.
- **`migrations/v11-migration.md`** — the consumer upgrade guide, written *as* features land rather than
  reconstructed at release. Read its Symbol Map and Error Handling sections before designing a change: they define
  the shape consumers have already been promised.

Work the phases in order. Most of the cost is in phases 1–2 — the code is mechanical once the inventory and the
shape decisions exist.

## Phase 1 — scope the feature and inventory it

The groups are already scoped in `openapi-migration/`, with the method-to-operation tables generated from the
code. Open your group's file first; this phase confirms it still matches reality rather than rebuilding it.

If the client has been regenerated since the plan was last refreshed, run
`python3 openapi-migration/tool/generate_plan.py` to update the tables. An operation no group claims is reported
as a problem, and it means the plan needs a home for it.

```bash
cd packages/stream_chat

# what already consumes the generated client — patterns you can copy
grep -rln "open_api" lib/src

# our surface for the feature
ls lib/src/core/api/                          # the *_api.dart that owns it
grep -rn "Poll" lib/stream_chat.dart          # what of it is publicly exported

# the generated operations, with paths and response types
grep -n -B1 "Future<Result<" lib/open_api/api/default_api.dart | grep -i poll
```

The inventory needs five lists:

1. **Operations** — hand-written method → generated operation. Names rarely match: for devices, `addDevice` →
   `createDevice`, `removeDevice` → `deleteDevice`, `getDevices` → `listDevices`, `setPushPreferences` →
   `updatePushNotificationPreferences`. Record paths too; not every v2 path is under `/chat/` (device ops are
   `/api/v2/devices` and `/api/v2/push_preferences`).
2. **Types** — the DTOs in `lib/src/core/api/{requests,responses}.dart` and any `lib/src/core/models/` types the
   feature returns, against their generated counterparts. Write operations usually return `DurationResponse` (just
   `duration`), which is what `EmptyResponse` corresponds to.
3. **Call sites** — everything above the api layer: `StreamChatClient`, `Channel`, and whether the response lands
   in client state or in `stream_chat_persistence`.
4. **Public exports** — which of those types `lib/stream_chat.dart` exports, since that is what makes a change
   breaking.
5. **Tests** — `test/src/core/api/<feature>_api_test.dart`, the feature's cases in
   `test/src/client/client_test.dart`, and its round-trips in `test/src/core/api/responses_test.dart`.

Close the phase by checking for a **blocking mismatch**: if the generated payload omits a field our current request
sends, that endpoint stays hand-written and the inventory says why. Migrating it would silently drop behaviour.

### When the type or operation isn't in the generated client

Work the ladder in order — the answer changes depending on *where* it's missing.

1. **Confirm it is really absent.** Names rarely match ours: responses are `*Response`, empty responses are
   `DurationResponse`, and inline enums become per-operation extension types. Search on a fragment, not the full
   name:

   ```bash
   ls packages/stream_chat/lib/open_api/model/ | grep -i device
   grep -in "device" packages/stream_chat/lib/open_api/api/default_api.dart | head
   ```
2. **Present in the spec, but the generated form is unusable.** Multipart uploads are the known case: the spec says
   `multipart/form-data`, the generated method takes a JSON `@Body()`. Hand-write that one call with retrofit over
   the generated *response* models, and open a generator fix upstream — see the `openapi-codegen` skill. Don't
   contort the call site around a broken signature.
3. **In a newer spec than the one our tree was generated from.** Regenerate — its own PR, never folded into a
   feature slice. Also `openapi-codegen`.
4. **Absent from the clientside spec entirely.** It is server-side only, deprecated (spec generation skips
   deprecated operations), or not yet exposed on v2. Confirm against the spec before concluding:

   ```bash
   python3 -c "import json,sys; s=json.load(open(sys.argv[1])); \
     print('\n'.join(p for p in s['paths'] if 'device' in p))" \
     /path/to/protocol/openapi/v2/chat-clientside-api.json
   ```

   Then leave the endpoint hand-written, record it in the inventory with the reason, and raise it with the backend
   team so the spec grows. Never invent a generated model to fill the hole.

**Never hand-edit anything under `lib/open_api/`.** Regeneration deletes the directory, so an edit there is lost
silently — which is exactly why fixes belong in the generator or in your own code.

## Phase 2 — decide the shape of each symbol

For every type in the inventory, one decision: keep our shape and map at the boundary, or adopt the generated one.

**Default to keeping our shape.** Generated types are wire shapes — nullable wherever the spec is loose, with
`_unknown` enum sentinels and per-operation extension types instead of shared enums (`CreateDeviceRequestPushProvider`
rather than one `PushProvider`). That is usually a worse public API than what we hand-wrote.

**Breaking changes are allowed, but a break needs a reason beyond convenience.** Take it when it buys one of:

- **Long-term maintainability** — the alternative is maintaining two shapes of the same thing indefinitely, or a
  mapping layer that needs editing on every spec change.
- **Consistency with our other products** — the generated name or shape is what our other SDKs expose, so matching
  it makes Stream's API coherent for people working across them.

Not sufficient on their own: avoiding a small mapping function, cosmetic naming, or "the generated one is newer".

When you do break, four things ship in the same PR: a `refactor(scope)!:` commit/PR title, a `🛑️ Breaking`
CHANGELOG entry naming the old and new symbol, a Symbol Map row plus feature section in
`migrations/v11-migration.md` (that guide is written as we go, not reconstructed at release), and the decision
*with its reason* in the PR body.

**The error contract is decided: a migrated API returns `Future<Result<T>>` and does not throw.** This matches
`stream_feeds`, which exports `stream_core` from its barrel and returns `Future<Result<api.SomeResponse>>` from its
client methods — so it clears both halves of the bar above: one error convention across our SDKs, and no
hand-written error-translation layer to keep in step with the spec.

Two details that are settled, so don't re-decide them per feature:

- **What rides inside `Failure`: always a `StreamException`.** `stream_core`'s error layer is a sealed family —
  `StreamApiException`, `StreamNetworkException`, `StreamAuthenticationException`, `StreamClientException` — so a
  migrated method needs no error handling of its own. Do not translate to `StreamChatNetworkError`; that is the
  hand-written layer this migration deletes.
- **What guarantees it: `runApiSafely`.** Core's call wrapper maps a `DioException` through
  `toStreamException()`, keeps a `StreamException` as raised, and wraps anything else — *including a `TypeError`
  from a response body that would not decode* — in a `StreamClientException` with the original as its `cause`.
  That last branch matters: with the older `runSafely`, a payload mismatch surfaced as a bare `TypeError` after a
  successful HTTP call, and no `is StreamException` check would have caught it.

```text
Failure.error  →  StreamException (sealed)
                    ├── StreamApiException      statusCode, code (StreamErrorCode), moreInfo, unrecoverable,
                    │                           retryAfter, apiError + isTokenExpired / isRateLimited / …
                    ├── StreamNetworkException  isCancelled, isTimeout, closeCode
                    ├── StreamAuthenticationException
                    └── StreamClientException   our own bug, or an undecodable body (cause preserved)
```

`StreamException.tryFrom(Object?)` normalizes anything already in hand, and `StreamErrorCode` is an
`extension type const StreamErrorCode(int) implements int` with named constants (`apiKeyInvalid`, `inputError`,
`rateLimited`, `internalError`, …). The root is `sealed`, so a `switch` over it is exhaustive and no new direct
subtype can appear outside core; the four subtypes are `base`, so chat can extend one if a case ever needs it but
cannot implement it.

**This supersedes our `ChatErrorCode`.** Core now owns the code vocabulary, so the plan is to drop ours rather
than re-express it as an extension. Check `StreamErrorCode` for a constant before adding one here.

## Phase 3 — sequence the work

Inside the feature: request bodies first (no public surface, no persistence), then responses, then models. Three
things can block a feature and are cheaper to resolve before starting:

- **`ApiErrorInterceptor` on the Dio behind `DefaultApi`, and `runApiSafely` in the call adapter.** One-time
  setup, and together they are what make every `Failure` carry a `StreamException`. Without them you get raw
  `DioException`s and every method is tempted to re-derive error details. There is no error-translation helper to
  write.
- **`Result` has to reach consumers.** Re-export it from `lib/stream_chat.dart` with a `show` allowlist —
  `show Result, Success, Failure, StreamException, StreamApiException, StreamNetworkException,
  StreamAuthenticationException, StreamClientException, StreamApiError, StreamErrorCode` — not feeds' wholesale
  `export 'package:stream_core/stream_core.dart';`.
  `stream_core` re-exports all of dio plus its own `AttachmentFile`, which collides by name with the
  `AttachmentFile` our barrel already exports, so a blanket export fails to compile. An allowlist is also the
  pattern `stream_chat_flutter` already uses for core re-exports.
- **Where `DefaultApi` is constructed.** It needs a `Dio`, and `StreamHttpClient.httpClient` is
  `@visibleForTesting` while `StreamHttpClient` itself is publicly exported — so `DefaultApi(client.httpClient)`
  fails `melos run analyze` (`dart analyze --fatal-infos`) with `invalid_use_of_visible_for_testing_member`. Add an
  `@internal` accessor, or build `DefaultApi` once in `StreamChatApi` and inject it. Decide once, apply everywhere.
- **Multipart uploads cannot come from the generated client.** The spec declares uploads as `multipart/form-data`,
  but the generated `uploadFile` / `uploadChannelFile` take a JSON `@Body()` with no progress or cancellation. That
  feature needs hand-written retrofit multipart calls over the generated response models — don't route
  `AttachmentFileUploader` through `DefaultApi`.

`EmptyResponse` has ~250 references and is shared by every feature, so it is retired last, after the features are.
Moving the WebSocket to v2 is its own project — v2 sends different event shapes; never fold it into a feature PR.

## Phase 4 — implement

```dart
import '../../open_api/models.dart' as api;   // prefix while both shapes exist

Future<Result<ListDevicesResponse>> getDevices() async {
  final result = await _api.listDevices();     // Future<Result<api.ListDevicesResponse>>
  return result.map(_toListDevicesResponse);   // transforms Success, passes Failure through untouched
}
```

`Result.map` is the whole pattern: the error side needs no code, because `ApiErrorInterceptor` already shaped it.
Reach for `fold` only when a method genuinely has to inspect the failure. `Result.success(value)` and
`Result.failure(error, [stackTrace])` exist as public factories for the cases that build a `Result` directly —
`Success` and `Failure` have private constructors.

`Result.fold` is `({required R Function(T) onSuccess, required R Function(Object, StackTrace?) onFailure})`;
`getOrThrow`, `getOrElse`, `map` and `flatMap` also exist (`stream_core`, `lib/src/utils/result.dart`).

**Don't unwrap inside the SDK.** `getOrThrow()` on a migrated path re-throws the `StreamException`, and
`Failure.error` is a plain `Object` — in practice the raw `DioException`, because `StreamChatNetworkError`
conversion lives in `StreamHttpClient._parseError`, which only its own `get`/`post`/`delete` wrappers call.
`DefaultApi` goes straight to `_dio.fetch` and bypasses it. Hand the `Result` to the caller instead; `getOrThrow()`
is a tool for *consumers* migrating incrementally, not for us.

Two data-shape traps while mapping:

- **`custom` vs `extraData`** (channel / message / user features). The wire puts extra fields in `custom`;
  hand-written models flatten them into `extraData`. Write that promotion explicitly, including which keys are
  excluded.
- **`DateTime` on anything that also arrives over the WebSocket.** Generated models decode through
  `StreamDateTimeConverter` (epoch nanoseconds *or* RFC3339); hand-written models use `DateTime.parse`. A model fed
  by both REST v2 and WS events must tolerate both.

Where a generated type shadows one of ours the prefix is temporary: if phase 2 chose the generated type, delete
ours in the same PR. Current overlaps with types exported from `lib/stream_chat.dart` include `Action`,
`Attachment`, `ChannelMute`, `ChatPreferences`, `Command`, `Reaction`, `Role`, `ThreadParticipant`, `User`,
`UserGroup`, `UserGroupMember`, plus same-name response DTOs (`ListDevicesResponse`,
`UpsertPushPreferencesResponse`) and `PushPreferenceInput`. Regenerate rather than trusting that list — it prints
file names, so `channel_mute` means the generated `ChannelMute` shadows ours:

```bash
comm -12 \
  <(ls packages/stream_chat/lib/open_api/model/ | grep -v '\.\(g\|freezed\)\.dart$' | sed 's/\.dart$//' | sort) \
  <(grep -oE "^export 'src/core/(models|api)/[a-z_]+\.dart';" packages/stream_chat/lib/stream_chat.dart \
    | sed "s|.*/\([a-z_]*\)\.dart';|\1|" | sort)
```

## Phase 5 — rewrite the tests

Budget for this: on a typical feature it is most of the diff, and none of it is mechanical.

- `test/src/core/api/<feature>_api_test.dart` asserts on `client.post('/devices', data: …)` against a
  `MockHttpClient`. Routing through `DefaultApi` moves the mock seam to `Dio`/`DefaultApi`; the old assertions
  cannot survive.
- `test/src/client/client_test.dart` builds fixtures in the `late`-mutable style the hand-written DTOs allow
  (`ListDevicesResponse()..devices = …`). Generated freezed classes have final fields and required named
  arguments, so any fixture switching to a generated type must be rewritten.
- `test/src/core/api/responses_test.dart` round-trips the DTO from JSON — keep it passing while the DTO exists,
  delete it with the DTO.

## Phase 6 — verify and land

`melos run analyze`, `melos run test:dart`, plus `stream_chat_persistence`'s tests if the feature's responses feed
persistence.

**`melos run analyze` does not cover the generated client's own output.** `analysis_options.yaml` excludes
`**/*.g.dart` and `**/*.freezed.dart` repo-wide, so the retrofit `default_api.g.dart` and ~490 generated
`.freezed.dart` files are never analyzed. Exercising the code in a test is what actually compiles it.

The PR body carries the group's scope, the phase 2 decisions with their reasons, and any endpoint left
hand-written and why. Then close the loop in the plan: tick the definition-of-done boxes in the group's file and
its status box in `openapi-migration/README.md`, so the next person sees where the migration actually stands.

Landing a break means four artifacts in the same PR: the `refactor(scope)!:` title, the `🛑️ Breaking` CHANGELOG
entry, the `migrations/v11-migration.md` Symbol Map row plus feature section (template lives at the bottom of that
guide), and the reason in the PR body. A break with no guide entry is unfinished — the guide is what consumers
actually upgrade against, and it cannot be reconstructed later.

## Layout reference

```
packages/stream_chat/lib/open_api/
├── api.dart               # barrel
├── models.dart            # barrel (also re-exports StreamApiError, StreamDateTimeConverter, WsEvent)
├── api/default_api.dart   # ONE retrofit interface — every operation lives here
└── model/                 # 493 models
```

Don't reach for the generator to get a type — that tree holds every model and operation the spec defines. The repo
lints `prefer_relative_imports`, which is what makes the generator's `import '../models.dart'` style compliant.
