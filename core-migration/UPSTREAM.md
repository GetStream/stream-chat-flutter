# What should move the other way: chat → `stream_core`

The rest of this plan moves chat *onto* core. This file tracks the opposite direction — things chat
has that every Stream product needs, and things core has that chat's use has shown to be wrong or
missing.

Worth keeping because the migration surfaces these continuously: you only find out that a helper is
generic when a second product needs it, and this is the pass where chat reads core closely enough
to notice. Each row says what the evidence is, so nobody has to re-derive it.

Status: ☐ not raised · ◐ raised upstream · ☑ landed in core · ✗ investigated and dropped

Rows marked ✗ were recommended by an earlier pass and disproved by a later one. They are kept
rather than deleted so the same asks are not re-raised.

| | What | Why it belongs in core | Blocked on |
| --- | --- | --- | --- |
| ☐ | **The retry table** — `isRetriable` over the sealed exception kinds | `ERROR_LAYER.md` §Retrying *specifies* this table, and core owns the doc. Chat now implements it ([03](03-errors.md)); feeds independently re-derived a partial version in `capabilities_repository.dart`'s `shouldRetry`. Two products deriving the same table from the same spec is the definition of a core concern. | Nothing. Strongest candidate here. |
| ☐ | **Text operators over an array-valued field** — `QueryOperator` / `AutoCompleteOperator` in `matches()` | Both bail on `fieldValue is! String` (`filter.dart:540`, `:556`), so a getter returning an `Iterable` never matches, whatever the value. Core already resolves arrays element-wise for `$eq`/`$in`/`$contains`; the evaluation operators were not extended with them. The API supports `$autocomplete` on array fields — chat's `ChannelFilterField.memberUserName` is one — so the query is right and only local evaluation disagrees. `stream_feeds` calls `matches()` in 36 event handlers, which is where this would surface first. | Nothing. |
| ☑ | **`normalizeStringForSort`** | Landed in [core#181](https://github.com/GetStream/stream-core-flutter/pull/181) as a utility, ported with its tests. **Not** as a change to `ComparableField`, which the row originally proposed: `Filter` compares through the same code (`filter.dart:299,320`), so folding there would make `$eq`, `$gt` and `$lt` case- and diacritic-insensitive locally while the API stayed exact. | Landed. Chat deleted its copy in phase [10](10-cleanup.md), which also dropped `diacritic` as a direct dependency. |
| ✗ | **`Filter` `$nor`** | **Dropped, and chat removes it too.** Neither StreamCore (Swift) nor stream-android-core models `$nor`, and adding it to Dart alone breaks a parity the three otherwise keep. The backend withdrew `$ne`/`$nin` from the published spec in [GetStream/chat#15657](https://github.com/GetStream/chat/pull/15657) and left `$nor` accepted-but-unpublished, so a preset can still contain it — which is what `Filter.raw` is for, not a modelled operator. | Closed. |
| ☑ | **Element-wise matching for array fields** | Open in [core#181](https://github.com/GetStream/stream-core-flutter/pull/181). `Filter.equal` and `Filter.in_` compared an array field with order-sensitive deep equality, so a list-valued getter could never match. Every array field the API exposes is matched element-wise — `members` by an `EXISTS` join, `filter_tags` by `@> AND <@` then `&&`, `teams` by `?|`, `attachments.type` by a nested `@>` — and none is order-sensitive. Without it `members`, `member.user.name` and `attachments.type` were undeclarable. | Nothing. |
| ☑ | **A `sortedMerge` alongside core's `merge`** (`utils/list_extensions.dart`) | Landed. Offered as a second method rather than a replacement: the two differ on contract, not quality — `sortedMerge` requires a sorted receiver and merges in O(n + m), `merge` assumes no order and sorts. Parity with the chat method it replaced is 0.97–1.01x, and a disjoint-key fast path makes pagination ~8% faster. Duplicate keys collapse as `merge` does, detected for free off the maps the walk already builds. | — |
| ☑ | **`LocationCoordinate` equality** | `==` compared with a `1e-7` epsilon while `hashCode` hashed the raw doubles, so the two disagreed: `a == b` yet `{a, b}.length == 2`, and `map[b]` misses after `map[a] =` (probed). The epsilon also made equality **non-transitive** — `a == b`, `b == c`, `a != c` across two 6e-8 steps — so no `hashCode` could ever have agreed with it. It reached `distanceTo` as well, which opens with `if (this == other) return 0.meters`: any two points closer than ~1.1cm reported exactly 0m. Feeds inherited all of it, since `ActivityData` and `FeedData` carry a `LocationCoordinate` field and freezed generates both members over it. No comparable type does this — JTS `Coordinate`, Google Maps Android `LatLng`, `latlong2`, Apple's `CLLocationCoordinate2D`, stream-core-android and stream-core-swift all keep equality exact and answer proximity with a distance or a named method. It is also the only class in core that hand-writes `==`/`hashCode`; sixteen others use `Equatable`, which makes the split unrepresentable. **Fix:** `extends Equatable` with `props => [latitude, longitude]`, delete both members, keep `distanceTo` for proximity. | Landed in [core#181](https://github.com/GetStream/stream-core-flutter/pull/181); this phase moves the pin onto it. |
| ☐ | **`HeadersInterceptor` and `ConnectionIdInterceptor` tests** | Core ships both interceptors with **no tests**. Chat had tests for its forks, so this phase kept them chat-side (`additional_headers_interceptor_test.dart`, `connection_id_interceptor_test.dart`) pointed at core's types — they belong next to the code they cover. | Nothing. Port them up. |
| ☐ | **A hand-written multipart CDN interface** | Feeds hand-wrote `CdnApi` because the generator emits a JSON `@Body()` for `multipart/form-data` operations, with no progress or cancellation. Chat will hand-write the same thing in [09](09-uploads.md). Two identical hand-written retrofit interfaces is a smell — either core owns one, or the generator is fixed. | Prefer the generator fix; see the `openapi-codegen` skill. |
| ✗ | **`_ResultCallAdapter`** | **Not worth moving.** Core does not depend on `retrofit`, so this would add that dependency for every core consumer to save three lines that a *generator* emits and nobody hand-maintains. If anywhere, the fix belongs in the generator template. | Closed. |
| ✗ | **Value equality on `Sort`** | **Dropped: it cannot be written correctly.** Comparing `field.remote` ignores the comparator, so two sorts naming one wire field with different value getters compared equal and hashed equal while ordering a list in opposite directions (probed). Comparing the field itself is identity, since `SortField` has no `==`, and its comparator is a closure. Use `same()` or compare `toJson()` in tests. | Closed. |
| ✗ | **`SortDirection.fromJson`** | **Dropped: the generator would never call it.** `json_serializable` uses a `fromJson` static for class-typed fields, but decodes enums through `$enumDecode` against the generated map, taking its fallback from `@JsonKey(unknownValue:)` at each field site. A static would be reachable only by hand while generated code disagreed with it. The rule stays in chat as `ChannelSort._directionFromJson`. | Closed. |
| ☐ | **Drop the restated `nullOrdering` defaults in feeds' `XSort` classes** | All twelve declare `super.nullOrdering = NullOrdering.nullsLast/First`, which is exactly what `Sort.asc`/`Sort.desc` already default to. A super-parameter inherits the super constructor's default, so `{super.nullOrdering}` is behaviour-identical and saves ~130 of feeds' 219 lines. Verified by probe. | Nothing. |
| ☐ | **A const-constructible `SortField`** | `SortField(remote, closure)` can never be const — a closure literal is not a constant expression — so every registry member is `static final` and every `defaultSort` list is `final` too. Nothing is broken by that; it just means a caller cannot write a `const` sort list, and it cost [08](08-query-dsl.md) the list controllers' `const` default parameters. Const-ness needs the value lookup to be an overridden method rather than a constructor argument, which both chat and feeds would have to adopt together. | Would change `SortField`'s constructor, so it is a core-wide API decision, not a chat ask. |
| ☑ | **`CurrentPlatform.debugCurrentPlatformOverride`** | Landed on core's `main` in #178. | Landed; chat can use it on the next release. |

| ☐ | **`Filter.raw`** | Open in [core#181](https://github.com/GetStream/stream-core-flutter/pull/181). `Filter` is `sealed`, so a gap has no downstream workaround, and chat needs one: a predefined filter is authored server-side and the query layer still accepts `$ne`/`$nin`/`$nor` ([#15657](https://github.com/GetStream/chat/pull/15657) is spec-only), so an echoed filter can carry an operator core does not model. `raw` is the fallback leaf that lets [08](08-query-dsl.md)'s `Filter.fromJson` stay total, the way `XSortField.custom` does for sort fields. `matches` on a raw leaf **throws**: `true` is right under `and` and wrong under `or`, `false` inverts that, and Swift's third state comes from a nullable predicate that `bool matches(T)` cannot express. Refusing is the only outcome that cannot silently produce a wrong result. | Nothing. |

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
its own, and each release chat has to wait for costs more than the change itself. Neither of the two this file used to
name is live any more: `$nor` is dropped (chat removes it in the same PR that adopts core's
`Filter`, because the API is withdrawing it), and `debugCurrentPlatformOverride` has landed on
core's `main`. What matters now is a single release carrying everything the branch pins to —
[DEFERRED.md](DEFERRED.md) holds that list. The retry table is the strongest of the rest.

Cross-repo workflow is in [`STYLE_GUIDE.md`](../STYLE_GUIDE.md) (§Dependency management): a path
dependency while both repos change together, back to a hosted constraint in `melos.yaml` before
release. And read the copy that actually resolves, not the sibling checkout — this plan has already been wrong
twice by reading unreleased `main`. Take the path from
`packages/stream_chat/.dart_tool/package_config.json` rather than assuming it: while `melos.yaml` pins a
git `ref` that is under `~/.pub-cache/git/`, and it returns to `~/.pub-cache/hosted/` when core releases.
