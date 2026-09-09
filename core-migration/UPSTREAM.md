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
| ☐ | **`normalizeStringForSort`** (`core/util/string_sort_normalizer.dart`, 95 LOC) | Folds diacritics and ligatures (`Ł→l`, `Ø→o`, `Æ→ae`) and lowercases, mirroring the backend's `NormalizeName`, so a client-side name sort matches the server's collation. Nothing about it is chat-specific — any product sorting user names needs the same folding, and core's `ComparableField` does a plain `String.compareTo`. **Now the strongest sort-related ask:** [08](08-query-dsl.md) landed the folding inside each name field's value getter (`UserSortField('name', (it) => it.name.let(normalizeStringForSort))`), which works but has to be remembered per field. In core it would be the default for every SDK, and core's own `ComparableField` would stop being wrong for names. | Nothing — it has no dependencies beyond `package:diacritic`. |
| ☐ | **`Filter` `$nor`** | A *logical* operator, so it sits beside core's existing `AndOperator` / `OrOperator`. Chat, Swift and JS all expose it and none has deprecated it; core is the only one missing it. | Nothing. Small and obviously correct. |
| ☐ | **The two-pointer `merge`** (`core/util/list_extensions.dart`) | If the benchmark [01](01-utilities.md) is parked on shows it beats core's keyed-map-merge-then-sort at real list sizes, core should take *ours* rather than chat taking core's — every product merges paginated lists. | The benchmark. |
| ☐ | **`HeadersInterceptor` and `ConnectionIdInterceptor` tests** | Core ships both interceptors with **no tests**. Chat had tests for its forks, so this phase kept them chat-side (`additional_headers_interceptor_test.dart`, `connection_id_interceptor_test.dart`) pointed at core's types — they belong next to the code they cover. | Nothing. Port them up. |
| ☐ | **A hand-written multipart CDN interface** | Feeds hand-wrote `CdnApi` because the generator emits a JSON `@Body()` for `multipart/form-data` operations, with no progress or cancellation. Chat will hand-write the same thing in [09](09-uploads.md). Two identical hand-written retrofit interfaces is a smell — either core owns one, or the generator is fixed. | Prefer the generator fix; see the `openapi-codegen` skill. |
| ☐ | **`_ResultCallAdapter`** | Three lines wrapping `runApiSafely`, and feeds already declares it **twice** (generated `default_api.dart` and hand-written `cdn_api.dart`). Chat's generated client has a third. Core owns `runApiSafely`; it may as well own the adapter. | Nothing. Trivial. |
| ☐ | **Value equality on `Sort`** | `Sort` has no `==`, so two independently-written identical sorts are unequal. It bit twice while landing [08](08-query-dsl.md)'s sort half — the old `SortOption` got away with it because a `const` list canonicalized. Nothing in chat compares sorts today (the Drift query-cache key hashes the predefined-filter name and raw `sortValues`), so this is a sharp edge rather than a bug. `props => [field.remote, direction, nullOrdering]`. | Nothing. |
| ☐ | **`SortDirection.fromJson`** — the direction rule, not a whole `Sort.fromJson` | `Sort` is `@JsonSerializable(createFactory: false)`, so nothing reads back the `{field, direction}` shape it writes. Chat needs that twice — the Drift converter for a persisted channel-query sort, and `PredefinedFilter`, where the API echoes the sort it resolved for a preset. **A full `Sort.fromJson` would not serve it**: it returns a bare `Sort`, and for channels `ChannelSort.asc`/`.desc` are what apply the nulls-last rule for `pinned_at` and `last_message_at`, so chat would keep its own anyway. Field resolution is per-model too. What *is* shared is the direction rule, and it is **server semantics that should not be re-derived per SDK**: anything other than `-1` is ascending (`config.go:330`, `:370`, `elasticsearch.go:87` — `isAscending := sortValue.Direction != -1`). chat-android re-derived it and got it wrong — `else -> return null` (`DomainMapping.kt:1397`) drops a sort the API would have honoured as ascending. A static on the enum (probed; an extension static would only be reachable as `SortDirectionJson.fromJson`):<br><br>`static SortDirection fromJson(Object? value) => value == desc.value ? desc : asc;`<br><br>Callers then switch exhaustively, so no direction can be forgotten:<br><br>`switch (SortDirection.fromJson(json['direction'])) { .asc => ChannelSort.asc(field), .desc => ChannelSort.desc(field) }`<br><br>Chat already does the switch, against a private `ChannelSort._directionFromJson`; adopting core's is deleting that method. | Nothing — additive. |
| ☐ | **Drop the restated `nullOrdering` defaults in feeds' `XSort` classes** | All twelve declare `super.nullOrdering = NullOrdering.nullsLast/First`, which is exactly what `Sort.asc`/`Sort.desc` already default to. A super-parameter inherits the super constructor's default, so `{super.nullOrdering}` is behaviour-identical and saves ~130 of feeds' 219 lines. Verified by probe. | Nothing. |
| ☐ | **A const-constructible `SortField`** | `SortField(remote, closure)` can never be const — a closure literal is not a constant expression — so every registry member is `static final` and every `defaultSort` list is `final` too. Nothing is broken by that; it just means a caller cannot write a `const` sort list, and it cost [08](08-query-dsl.md) the list controllers' `const` default parameters. Const-ness needs the value lookup to be an overridden method rather than a constructor argument, which both chat and feeds would have to adopt together. | Would change `SortField`'s constructor, so it is a core-wide API decision, not a chat ask. |
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

**`$ne` and `$nin`.** Core is *right* not to have them. Android deprecates both — `ne` with
"the notEquals filter is inefficient and causes performance issues. It will not be supported in the
future", `nin` with "this filter will stop to be supported in the future" — and the JS SDK, which
is the reference client, does not declare either in its `QueryFilter` type at all. Chat should
follow Android and deprecate them rather than push them upstream. (Swift still exposes both
undeprecated, which looks like an oversight there rather than a signal.)

**`Event`, `EventType`, `event_resolvers.dart`, `Serializer`, `message_rules.dart`.** Chat's domain
vocabulary. `ERROR_LAYER.md`'s rule generalizes well here: a thing belongs in core when a second
product would react to it the same way. Nothing outside chat reacts to `message.deleted`.

## How to raise one

Core is a separate repo with its own release cadence, so batch these: a row here is rarely urgent on
its own, and each release chat has to wait for costs more than the change itself. The two worth
pushing first are the ones this plan is actually blocked on — `Filter`'s `$nor`, and a release
carrying `debugCurrentPlatformOverride`.

Cross-repo workflow is in [`STYLE_GUIDE.md`](../STYLE_GUIDE.md) (§Dependency management): a path
dependency while both repos change together, back to a hosted constraint in `melos.yaml` before
release. And read core against `~/.pub-cache/hosted/pub.dev/stream_core-<version>/`, not the sibling
checkout — this plan has already been wrong twice by reading unreleased `main`.
