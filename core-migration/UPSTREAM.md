# What should move the other way: chat → `stream_core`

The rest of this plan moves chat *onto* core. This file tracks the opposite direction — things chat
has that every Stream product needs, and things core has that chat's use has shown to be wrong or
missing.

Worth keeping because the migration surfaces these continuously: you only find out that a helper is
generic when a second product needs it, and this is the pass where chat reads core closely enough
to notice. Each row says what the evidence is, so nobody has to re-derive it.

Status: ☐ not raised · ◐ raised upstream · ☑ landed in core

| | What | Why it belongs in core | Blocked on |
| --- | --- | --- | --- |
| ☐ | **The retry table** — `isRetriable` over the sealed exception kinds | `ERROR_LAYER.md` §Retrying *specifies* this table, and core owns the doc. Chat now implements it ([03](03-errors.md)); feeds independently re-derived a partial version in `capabilities_repository.dart`'s `shouldRetry`. Two products deriving the same table from the same spec is the definition of a core concern. | Nothing. Strongest candidate here. |
| ☐ | **`normalizeStringForSort`** (`core/util/string_sort_normalizer.dart`, 95 LOC) | Folds diacritics and ligatures (`Ł→l`, `Ø→o`, `Æ→ae`) so client-side name sorts match the server's collation. Nothing about it is chat-specific — any product sorting user names needs the same folding, and core's `ComparableField` currently uses a plain `String.compareTo`. | [08](08-query-dsl.md) needs it either way; upstreaming is the better half of that decision. |
| ☐ | **`Filter` `$ne` / `$nin` / `$nor`** | Chat exposes all three publicly and core has none. Not a nicety: it is the one hard block in this plan. | Nothing. |
| ☐ | **The two-pointer `merge`** (`core/util/list_extensions.dart`) | If the benchmark [01](01-utilities.md) is parked on shows it beats core's keyed-map-merge-then-sort at real list sizes, core should take *ours* rather than chat taking core's — every product merges paginated lists. | The benchmark. |
| ☐ | **`HeadersInterceptor` and `ConnectionIdInterceptor` tests** | Core ships both interceptors with **no tests**. Chat had tests for its forks, so this phase kept them chat-side (`additional_headers_interceptor_test.dart`, `connection_id_interceptor_test.dart`) pointed at core's types — they belong next to the code they cover. | Nothing. Port them up. |
| ☐ | **A hand-written multipart CDN interface** | Feeds hand-wrote `CdnApi` because the generator emits a JSON `@Body()` for `multipart/form-data` operations, with no progress or cancellation. Chat will hand-write the same thing in [09](09-uploads.md). Two identical hand-written retrofit interfaces is a smell — either core owns one, or the generator is fixed. | Prefer the generator fix; see the `openapi-codegen` skill. |
| ☐ | **`_ResultCallAdapter`** | Three lines wrapping `runApiSafely`, and feeds already declares it **twice** (generated `default_api.dart` and hand-written `cdn_api.dart`). Chat's generated client has a third. Core owns `runApiSafely`; it may as well own the adapter. | Nothing. Trivial. |
| ☐ | **`ComparableField` returning `0` for incomparable types** | Core throws `ArgumentError`; chat returns `0`. A throw turns a cosmetic ordering glitch into a crash inside a list view. Argue chat's behaviour is the right default rather than working around it. | Argument, not code. |
| ◐ | **`CurrentPlatform.debugCurrentPlatformOverride`** | Already on core's `main` — chat just cannot use it until there is a release. Recorded here so nobody re-raises it as missing. | A `stream_core` release. |

## Deliberately *not* moving

Recording these so the question does not get asked twice.

**`AdditionalHeadersInterceptor` — don't move it, delete it.** After [05](05-http-client.md) it does one
thing: read `StreamChatClient.additionalHeaders`, a static mutable global. The mechanism is generic,
but core already answers this concern differently — feeds threads `config.customHeaders` into
`BaseOptions.headers` as Dio *defaults*, deliberately, so the SDK's own interceptors always win over
a user-supplied header whose casing differs. An interceptor exists here only because our static can
be reassigned after the client is built. The end state is a per-client `headers` option and no
interceptor, which also retires the `defaultUserAgent` static beside it. Moving it to core would
enshrine the shape we want to get rid of.

**`ConnectionIdManager`.** The type is 27 trivial lines, so moving it would be easy and pointless.
The reason it stays is not the storage but the *semantics*: `client.dart:774` and `:907` early-return
on `hasConnectionId` and `:1071` uses it to pick a query parameter, so chat asks questions of it that
core's `ConnectionIdGetter` closure cannot express.

**`RetryPolicy` / `RetryQueue`.** The retry *table* belongs upstream (above); the queue does not. It
takes a `Channel`, reads `client.retryPolicy`, calls `channel.state.retryFailedMessages()` and
listens for `EventType.connectionRecovered` — chat domain in every direction.

**`StreamLoggerBridge`.** Forwarding core's records into a `package:logging` `Logger` matters because
chat's public logging API is typed on that package. Feeds has no such history and would not use it.

**`Event`, `EventType`, `event_resolvers.dart`, `Serializer`, `message_rules.dart`.** Chat's domain
vocabulary. `ERROR_LAYER.md`'s rule generalizes well here: a thing belongs in core when a second
product would react to it the same way. Nothing outside chat reacts to `message.deleted`.

## How to raise one

Core is a separate repo with its own release cadence, so batch these: a row here is rarely urgent on
its own, and each release chat has to wait for costs more than the change itself. The two worth
pushing first are the ones this plan is actually blocked on — the `Filter` operators, and a release
carrying `debugCurrentPlatformOverride`.

Cross-repo workflow is in [`STYLE_GUIDE.md`](../STYLE_GUIDE.md) (§Dependency management): a path
dependency while both repos change together, back to a hosted constraint in `melos.yaml` before
release. And read core against `~/.pub-cache/hosted/pub.dev/stream_core-<version>/`, not the sibling
checkout — this plan has already been wrong twice by reading unreleased `main`.
