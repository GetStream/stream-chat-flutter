# 08 — Query DSL: filter, sort, comparable field

**Goal:** adopt core's typed `Filter<T>` / `Sort<T>` / `ComparableField<T>` so a chat query can be
evaluated client-side as well as sent to the server.

**Size:** ~600 chat LOC deleted against ~1,420 core LOC. The widest public break after phase
[03](03-errors.md). One small upstream ask (), and two operators chat should deprecate
rather than port.

## Scope

| Delete | Adopt |
| --- | --- |
| `lib/src/core/models/filter.dart` (241) — `Filter`, `FilterOperator` | `stream_core` `query/filter/` — `sealed Filter<T>`, `FilterField<T>`, `FilterOperator` |
| `lib/src/core/api/sort_order.dart` (183) — `SortOrder`, `SortOption`, `NullOrdering` | `stream_core` `query/sort.dart` — `Sort<T>`, `SortField<T>`, `SortDirection`, `NullOrdering` |
| `lib/src/core/models/comparable_field.dart` (~85) | `stream_core` `utils/comparable_field.dart` (90) |
| `lib/src/core/models/location_coordinates.dart` | `stream_core` `query/filter/location/location_coordinate.dart` |
| `lib/src/core/models/predefined_filter.dart` (84) | reworked onto `FilterField` registries |

`Filter` and `FilterOperator` are exported (`stream_chat.dart:52`) and appear in every
`queryChannels` / `queryUsers` / `queryMembers` signature. This is the phase consumers notice most
after the error layer.

## The shape change that matters

Ours is one class with stringly-typed addressing:

```dart
class Filter extends Equatable {
  final String? operator;   // '$eq', '$in', ...
  final String? key;        // 'members', 'last_message_at', ...
  final Object value;
}
```

Core's is a sealed hierarchy — 13 final subclasses across 5 sealed families (`ComparisonOperator`,
`ListOperator`, `ExistsOperator`, `EvaluationOperator`, `LogicalOperator`) — and it addresses
fields through a typed registry:

```dart
class FilterField<T> {
  const FilterField(String remote, FilterFieldValueGetter<T, Object> value);
}
```

**The field carries a local value extractor**, which is the whole point: the same declaration
drives both the server query (`toJson()`) and client-side evaluation (`Filter.matches(T)`). So
every chat filterable field has to be declared once, typed:

```dart
// sketch
class ChannelFilterField extends FilterField<Channel> {
  static final createdAt = ChannelFilterField('created_at', (c) => c.createdAt);
  static final memberCount = ChannelFilterField('member_count', (c) => c.memberCount);
  // ...
}
```

`stream_feeds/lib/src/state/query/` is the template — one file per queryable type, each declaring
`XQuery`, `typedef XFilter = Filter<XData>`, `XFilterField`, `XSort`, `XSortField` and a
`defaultSort`.

That registry is the bulk of this phase's work, and it is also the payoff: client-side filtering is
something chat cannot do at all today.

## The three operators core lacks, and what to do about each

Chat exposes `$ne`, `$nin` and `$nor`; core has none of them
(`lib/src/core/models/filter.dart:17,35,53` and `:132,138`). An earlier draft called all three a
hard block. Checked against the other SDKs, only one is:

| Ours | Wire | JS (reference client) | Swift | Android | Verdict |
| --- | --- | --- | --- | --- | --- |
| `Filter.notEqual` | `$ne` | **not declared** in `QueryFilter` | present | **`@Deprecated`** | **deprecate here too** |
| `Filter.notIn` | `$nin` | **not declared** in `QueryFilter` | present | **`@Deprecated`** | **deprecate here too** |
| `Filter.nor` | `$nor` | declared, beside `$and` / `$or` | present | present | **upstream to core** |

Android's messages say why, and they are about the server rather than the client: `ne` is
"inefficient and causes performance issues. It will not be supported in the future", and `nin`
"will stop to be supported in the future". The JS SDK simply never declared either. So core is
*right* not to have them, and chat should follow Android — `@Deprecated` on both, pointing at the
same guidance, and drop them in a later major.

That leaves `$nor`, which is a **logical** operator like `$and` and `$or`, so it belongs beside
core's existing `AndOperator` / `OrOperator` rather than among the comparisons. Landing it needs
`matches()` too: NOR is "none of these match", so it is the negation of `OrOperator`'s result.

The backend supports all three (`monolith/utils/mquery/operator.go`, and `field_mappings.go` lists
them under `SupportedOperators`) — deprecation here is a client-side steer away from queries that
perform badly, not a wire-level removal.

Core has one we lack — `pathExists` `$path_exists` — which comes for free.

## Escape hatches

Ours has three with no core equivalent:

| Ours | Options |
| --- | --- |
| `Filter.custom({value, operator, key})` | Keep chat-side as a `Filter<T>` subclass, or drop |
| `Filter.raw({value})` | Same |
| `Filter.empty()` | Feeds' convention is a **nullable** filter meaning "everything", plus `extension MatchesExtensions { bool matches(Filter<T>? f) => f == null || f.matches(this); }` — adopt that instead |

`Filter.custom` and `Filter.raw` exist so consumers can query a field the SDK doesn't model. Under
a typed registry that is exactly the case `FilterField` can't express, so at least one of them
should survive — decide which, and note that a custom filter cannot support `matches()`.

## Sort

| Ours | Core |
| --- | --- |
| `typedef SortOrder<T extends ComparableFieldProvider> = List<SortOption<T>>` | `Sort<T>` + `extension CompositeComparator on Iterable<Sort<T>>` |
| `SortOption.asc(String field)` / `.desc(String field)`, `static const ASC = 1 / DESC = -1` | `Sort.asc(SortField<T>)` / `.desc(SortField<T>)`, `enum SortDirection { asc(1), desc(-1) }` |
| field is a `String`, resolved at runtime via `ComparableFieldProvider.getComparableField(sortKey)` | field is a typed `SortField<T>{remote, comparator}` |
| `SortOption.fromJson` (drops the comparator) | `createFactory: false` — no `fromJson` |

`NullOrdering` and `CompositeComparator` exist in **both** packages by the same names → collision,
so our `sort_order.dart` must stop being exported in the same PR.

**Per-field null-ordering defaults stay chat-side.** Ours are server parity, not preference:
`ChannelSortKey.pinnedAt` and `lastMessageAt` force `nullsLast` in *both* directions, where core's
defaults are the plain `asc → nullsLast` / `desc → nullsFirst`. Supply the right `nullOrdering`
from a thin chat-side factory per field. Cheaper than an upstream ask and it doesn't wait on a core
release.

**`SortOption.fromJson` has no core equivalent.** Find out who calls it — if anything deserialises
a stored sort (a persisted channel-list configuration, for instance), that needs a chat-side
resolver mapping a remote name back to a `SortField`.

## `ComparableField` is a semantic fork, not a rename

| | Ours | Core |
| --- | --- | --- |
| Strings | routed through `normalizeStringForSort` (`core/util/string_sort_normalizer.dart`, 95 LOC — folds diacritics and ligatures: `Ł→l`, `Ø→o`, `Æ→ae`, case-insensitive) | plain `String.compareTo` |
| Incomparable types | returns **`0`** | **throws `ArgumentError`** |
| `ComparableFieldProvider` | ours, and 48 models implement it | absent |

Adopting core's as-is silently changes channel and user name ordering (server parity lost) *and*
turns a benign `0` into a runtime throw. Neither is acceptable. Upstream a pluggable string
comparator — or `normalizeStringForSort` itself, which is generically useful — before adopting.

The incomparable-types divergence is worth arguing upstream too: a throw is defensible in a
strict library, but it converts a cosmetic ordering glitch into a crash in a list view.

## Decisions to make

- Which escape hatches survive, and in what form.
- Whether `ComparableFieldProvider` survives. 48 models implement it; core has no such interface.
  Under a typed `SortField` registry it may be unnecessary — but removing it touches every model.
- Whether `Filter` keeps a chat-side `typedef` per queryable type (`typedef ChannelFilter =
  Filter<Channel>`) as feeds does. It reads much better in public signatures.
- Whether `predefined_filter.dart` is rebuilt on the registry or dropped.
- Whether client-side `matches()` gets *used* anywhere in this phase, or is just enabled. Enabling
  it is the cheap half; using it (e.g. deciding whether a new channel belongs in a filtered list,
  the way feeds' handlers do) is a behaviour improvement that deserves its own change.

## Risks

- **Every query signature in the public API changes**, and `Filter` is one of the most-used types
  in consumer code. The `dart fix` transforms from phase [10](10-cleanup.md) matter more here than
  anywhere else — consider landing the kit before this phase rather than after.
- **Silent ordering regressions.** If `normalizeStringForSort` is lost, channel lists reorder for
  any user with an accented name, and nothing fails. Golden-test it.
- **`toJson()` drift.** Core builds the same three JSON shapes ours does (`{$op: [...]}`,
  `{key: {$op: value}}`, `{key: value}`), but "the same shapes" is not "the same output". Diff
  every existing filter's serialisation before and after.
- The registry is mechanical but large — one entry per filterable field across channels, users,
  members, messages, threads, drafts, polls and reminders.

## Upstream `stream_core` work

- **`Filter` `$nor`**, with `matches()` semantics (the negation of `OrOperator`). The only hard
  block. `$ne` and `$nin` are *not* upstream asks — see above.
- A pluggable string comparator on `ComparableField` (or `normalizeStringForSort` upstreamed).
- Worth arguing: returning `0` rather than throwing for incomparable types.

## Definition of done

- [ ] Core ships `$nor` and chat is on that release.
- [ ] `Filter.notEqual` and `Filter.notIn` are `@Deprecated`, carrying Android's rationale rather
      than a bare "use something else".
- [ ] `filter.dart`, `sort_order.dart`, our `comparable_field.dart` and
      `location_coordinates.dart` are deleted; `stream_chat.dart` exports core's via the
      allowlist.
- [ ] A `FilterField` / `SortField` registry exists for every queryable type, with local
      extractors.
- [ ] **Serialisation diff:** every filter and sort the SDK can build round-trips through
      `toJson()` to byte-identical output against the pre-migration implementation.
- [ ] **A golden ordering test** over a list of accented and ligatured names proves
      `normalizeStringForSort` behaviour survives.
- [ ] Per-field `NullOrdering` defaults preserved — asserted for `pinnedAt` and `lastMessageAt` in
      both directions.
- [ ] Nothing throws where the old `ComparableField` returned `0` — asserted.
- [ ] `SortOption.fromJson` callers accounted for.
- [ ] `melos bootstrap && melos run analyze && melos run test:dart && melos run test:flutter`,
      plus `stream_chat_persistence` tests if any stored query shape changed.
- [ ] `refactor(llc)!:` title, `🛑️ Breaking` CHANGELOG entries, `migrations/v11-migration.md`
      Symbol Map rows and a feature section with before/after query examples — this is the section
      consumers will actually read.
- [ ] Decisions recorded here, status box ticked in `README.md`.
