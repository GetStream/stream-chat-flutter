# 08 — Query DSL: filter, sort, comparable field

**Goal:** adopt core's typed `Filter<T>` / `Sort<T>` / `ComparableField<T>` so a chat query can be
evaluated client-side as well as sent to the server.

**Size:** ~600 chat LOC deleted against ~1,420 core LOC. The widest public break after phase
[03](03-errors.md). Three changes went upstream to `stream_core` alongside it, and three
operators were removed rather than ported.

## Scope

| Delete | Adopt |
| --- | --- |
| `lib/src/core/models/filter.dart` (241) — `Filter`, `FilterOperator` | `stream_core` `query/filter/` — `sealed Filter<T>`, `FilterField<T>`, `FilterOperator` |
| `lib/src/core/api/sort_order.dart` (183) — `SortOption`, `NullOrdering`, `CompositeComparator` | `stream_core` `query/sort.dart` — `Sort<T>`, `SortField<T>`, `SortDirection`, `NullOrdering`, `CompositeComparator` |
| `lib/src/core/models/comparable_field.dart` (~85) — `ComparableField`, `ComparableFieldProvider` | folded into `StreamSortField` (see [below](#why-a-chat-side-streamsortfield-survives)) |
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

## The filter half, decided

An earlier pass planned to deprecate `$ne`, `$nin` and `$nor` and upstream `$nor` to core. The
first is right for a stronger reason than the one recorded; the second is wrong. What follows
replaces it.

**Remove `$ne` and `$nin`, citing the backend.** [GetStream/chat#15657](https://github.com/GetStream/chat/pull/15657)
is merged: `FilterColumns()` stops publishing both to the OpenAPI spec for every product, because
each scans a whole table to exclude a few rows and times out at customer scale. The same removal
already ran on iOS (#3414), React (#2504), React Native (#2672) and JS LLC (#1363). That is a far
better citation than Android's deprecation messages, which is all the earlier pass had.

It is **spec-only** — the query layer still accepts both — and the withdrawal is **per field, not
blanket**. `isPublishedOperator` keeps `$ne` on classifier boolean fields and `$ne`/`$nin` on
anti-join indexed ones, which for chat means `$ne` and `$nin` on `queryUsers.id`, and `$ne` on
`banned`, `shadow_banned` and `bypass_moderation`. Those exceptions have to be named wherever the
removal is documented.

**Remove `$nor` too, and do not upstream it.** Neither StreamCore (Swift) nor stream-android-core
models it, and adding it to Dart core alone breaks a parity the three otherwise keep. It is not
deprecated anywhere and #15657 leaves it accepted, so the operator is not dead — but a chat client
does not need to *offer* it, and a preset that uses it is handled by the raw fallback below.

## `PredefinedFilter` is what makes the decode interesting

The server echoes the filter it resolved for a preset. That filter is authored server-side, and
since #15657 is spec-only it can legitimately contain `$ne`, `$nin` or `$nor` — operators core's
sealed `Filter` has no variant for. So the echo cannot always be represented by a typed filter,
and `Filter` being sealed means chat cannot add a variant to hold it.

Typing the field `Map<String, Object?>` was considered. It is honest and it deletes real code —
`_filterFromJson`, `_touchesField` (whose `Filter`-walking branches are already dead for a raw
value), and `FilterConverter`, which the existing `MapConverter<Object?>` replaces byte-for-byte
on disk. It was rejected for asymmetry: `PredefinedFilter.sort` decodes into typed `ChannelSort`
objects, and a filter that stays a map next to it is an inconsistency, not a simplification.

**So the decode mirrors the sort side, and stays total by having a fallback at each level:**

| | unknown value | fallback |
| --- | --- | --- |
| sort direction | not `-1` | `asc` |
| sort field | not declared | `XSortField.custom(remote)` (channel, member, user and message search — the resources whose sort validation stays open) |
| filter field | not declared | `XFilterField.custom(remote)` |
| **filter operator** | `$ne` / `$nin` / `$nor` / anything new | **`Filter.raw({that node})`** |

That is what `Filter.raw` is for, and it is the only reason core needs it — see
[UPSTREAM.md](UPSTREAM.md). A preset using a withdrawn operator decodes into a tree that is typed
everywhere except that one leaf, rather than throwing or collapsing to a blob.

**chat-android is the reference implementation, and shows why we need one thing it does not.**
Its `FilterObjectConverter` decodes a map by dispatching on the operator key — `$and`/`$or`/`$nor`
recurse, leaves map to `Filters.eq/ne/contains/gt/gte/lt/lte/in/nin/autocomplete/exists` — and
**throws `IllegalArgumentException`** on anything else. No fallback. Two things make that safe
there and unsafe here:

- It is a Room `TypeConverter` on `ChatDatabase`, so it only ever reads back a filter Android
  itself wrote. The input cannot contain an operator Android's own API cannot produce. Our
  predefined filter is authored server-side by the app owner, so it can.
- Its field is a bare `fieldName: String`, so an unrecognised field is not a problem. Our
  `FilterField<T>` carries a value getter, which is why the field needs a `custom` fallback and
  Android's does not.

Worth noting while reading it as a reference: Android models no `$q` at all, so its operator set
is not a target to match.

`Filter.fromJson` therefore depends on a per-model `FilterField` registry with a `fromRemote`,
exactly as `ChannelSortField.fromRemote` works. The registry is not optional scaffolding for
`matches()`; it is what makes the decode possible.

## A field is only safe to give a value getter if local agrees with the server

Core's generic `$in` compiles to `fmt.Sprintf("%s IN (?)", …)` (`mq/sql.go:1090`), plain scalar
membership. So a value getter is only correct when the server evaluates that field the same way
over the same value the getter returns. Three ways a field can diverge, each found while writing
`ChannelFilterField`:

**No local value.** `app_banned` and `joined` are the only two of this group the channel
response does not carry. `disabled`, `hidden`, `blocked` and `muted` arrive as extra data, and
`ChannelModel` reads all four — `muted` and `blocked` were added for this — so they are declared.
`pinned` and `archived` come off the membership row.

**A collection the server resolves element-wise.** `members` looks like `$in` over a list of ids,
and the generic operator would compare the whole list against each candidate, which is never
true. The server special-cases it: `channelDenormMembers` (`channel_denorm.go:1682`) compiles to
`EXISTS (SELECT 1 FROM channel_members m WHERE m.user_id IN (?) …)`, and `$eq` counts instead,
matching a channel whose member set is exactly the given users. Every array field the API exposes
is matched the same way — `filter_tags` with `@> AND <@` then `&&`, `teams` with `?|`,
`attachments.type` with a nested `@>` — and none is order-sensitive. Core now does that for any
array-valued field, so `members`, `member.user.name` and `attachments.type` are declared with
real getters.

**Derived from the query, not the row.** `distinct`, `has_unread` and `invite` are computed
server-side from the request and the caller's read state, so no getter can agree with them. They
stay undeclared, reachable through `Filter.raw`.

## The filterable fields, from the spec

Taken from `openapi/chat-openapi-clientside.yaml` in the **protocol** repo, which is what SDK
generators consume. 166 fields across twelve endpoints.

An earlier pass extracted these from `mq.TableConfig.Columns` per resource and was wrong
everywhere: 16 message fields against the spec's 44, 23 channel fields against 29, and
`QueryMessageFlagsPayload` missed entirely. Reading one `Columns` map misses fields a second
config contributes, and it does not apply the publication rules. Two properties make the spec the
right source instead — it is keyed by *endpoint* rather than by table, which is how a caller
thinks, and it has already applied `isPublishedOperator`, so
[#15657](https://github.com/GetStream/chat/pull/15657) is baked in: exactly four `$ne` and one
`$nin` survive, the index-safe exceptions on `QueryUsersPayload`.

Regenerate by re-reading that file from a current `GetStream/protocol` checkout, not by
re-deriving it from the Go source:

```bash
PROTOCOL_DIR=${PROTOCOL_DIR:-~/GolandProjects/protocol}   # or wherever you cloned it
git -C "$PROTOCOL_DIR" pull
```

**The same file's `x-stream-sort-fields` is *not* a usable oracle, and the sort registries must
not be narrowed to it.** It publishes `AllowedSortColumns`, the indexed-column subset, while the
gate a query actually passes through is `Model.AllowedSortCombinations` (`sql.go:652`). The two
disagree in both directions: `relevance` is absent because it is a special case rather than a
column, and channels, users and banned users publish no sort block at all because their
`TableConfig` has no `Model` and `SortCombinations()` returns nil without one. Obeying it would
delete channel sorting outright. Zita raised both discrepancies with Yun on 2026-08-12
([thread](https://getstream.slack.com/archives/C07AL9Q0T2T/p1786540942575199)), naming the
missing `relevance` and the thirteen member fields behind `QueryMembersPayload`'s single
published `created_at`; it is acknowledged and unfixed as of openapi-v238.0.2. Re-check when a
later spec version lands.

<details>
<summary>166 fields</summary>

| endpoint | field | type | operators |
| --- | --- | --- | --- |
| QueryBannedUsersPayload | `banned_by_id` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryBannedUsersPayload | `channel_cid` | string | `$eq` `$in` |
| QueryBannedUsersPayload | `created_at` | date | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryBannedUsersPayload | `reason` | string | `$autocomplete` `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryBannedUsersPayload | `user_id` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryChannelsRequest | `app_banned` | string | `$eq` |
| QueryChannelsRequest | `archived` | boolean | `$eq` |
| QueryChannelsRequest | `blocked` | boolean | `$eq` |
| QueryChannelsRequest | `channel_role` | string | `$eq` `$in` |
| QueryChannelsRequest | `cid` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryChannelsRequest | `created_at` | date | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryChannelsRequest | `created_by_id` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryChannelsRequest | `custom` | object | `$autocomplete` `$contains` `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` `$q` |
| QueryChannelsRequest | `disabled` | boolean | `$eq` |
| QueryChannelsRequest | `distinct` | boolean | `$eq` |
| QueryChannelsRequest | `filter_tags` | string | `$eq` `$in` |
| QueryChannelsRequest | `frozen` | boolean | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryChannelsRequest | `has_unread` | boolean | `$eq` |
| QueryChannelsRequest | `hidden` | boolean | `$eq` |
| QueryChannelsRequest | `id` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryChannelsRequest | `invite` | string | `$eq` |
| QueryChannelsRequest | `joined` | boolean | `$eq` |
| QueryChannelsRequest | `last_message_at` | date | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryChannelsRequest | `last_updated` | date | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryChannelsRequest | `member.user.name` | string | `$autocomplete` `$eq` |
| QueryChannelsRequest | `member_count` | number | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryChannelsRequest | `members` | string | `$eq` `$in` |
| QueryChannelsRequest | `message_count` | number | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryChannelsRequest | `muted` | boolean | `$eq` |
| QueryChannelsRequest | `name` | string | `$autocomplete` `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` `$q` |
| QueryChannelsRequest | `pinned` | boolean | `$eq` |
| QueryChannelsRequest | `team` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryChannelsRequest | `type` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryChannelsRequest | `updated_at` | date | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryDraftsRequest | `channel_cid` | string | `$eq` `$in` |
| QueryDraftsRequest | `created_at` | date | `$eq` `$gt` `$gte` `$lt` `$lte` |
| QueryDraftsRequest | `parent_id` | string | `$eq` `$exists` `$in` |
| QueryMembersPayload | `banned` | boolean | `$eq` |
| QueryMembersPayload | `channel_role` | string | `$eq` `$in` |
| QueryMembersPayload | `cid` | string | `$eq` |
| QueryMembersPayload | `created_at` | date | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryMembersPayload | `custom` | object | `$autocomplete` `$contains` `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` `$q` |
| QueryMembersPayload | `id` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryMembersPayload | `invite` | string | `$eq` |
| QueryMembersPayload | `is_moderator` | boolean | `$eq` |
| QueryMembersPayload | `joined` | boolean | `$eq` |
| QueryMembersPayload | `last_active` | date | `$eq` `$gt` `$gte` `$lt` `$lte` |
| QueryMembersPayload | `name` | string | `$autocomplete` `$eq` `$in` `$q` |
| QueryMembersPayload | `notifications_muted` | boolean | `$eq` |
| QueryMembersPayload | `updated_at` | date | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryMembersPayload | `user.email` | string | `$autocomplete` `$eq` `$in` `$q` |
| QueryMembersPayload | `user.nd_deactivated` | boolean | `$eq` |
| QueryMembersPayload | `user_id` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryMessageFlagsPayload | `action` | string | `$eq` |
| QueryMessageFlagsPayload | `blocklist_name` | string | `$eq` |
| QueryMessageFlagsPayload | `channel_cid` | string | `$eq` `$in` |
| QueryMessageFlagsPayload | `date_range` | string | `$eq` |
| QueryMessageFlagsPayload | `harm_label` | string | `$eq` |
| QueryMessageFlagsPayload | `harm_type` | string | `$eq` |
| QueryMessageFlagsPayload | `image_labels` | string | `$eq` |
| QueryMessageFlagsPayload | `is_reviewed` | boolean | `$eq` |
| QueryMessageFlagsPayload | `keyword` | string | `$eq` |
| QueryMessageFlagsPayload | `matched_phrase` | string | `$eq` |
| QueryMessageFlagsPayload | `message_id` | string | `$eq` `$in` |
| QueryMessageFlagsPayload | `phrase_list_ids` | number | `$eq` |
| QueryMessageFlagsPayload | `reason` | string | `$eq` `$in` |
| QueryMessageFlagsPayload | `reporter_id` | string | `$eq` |
| QueryMessageFlagsPayload | `reporter_type` | string | `$eq` |
| QueryMessageFlagsPayload | `team` | string | `$eq` `$in` |
| QueryMessageFlagsPayload | `user_id` | string | `$eq` `$in` |
| QueryPollVotesRequest | `created_at` | date | `$eq` `$gt` `$gte` `$lt` `$lte` |
| QueryPollVotesRequest | `id` | string | `$eq` `$in` |
| QueryPollVotesRequest | `is_answer` | boolean | `$eq` |
| QueryPollVotesRequest | `option_id` | string | `$eq` `$exists` `$in` |
| QueryPollVotesRequest | `poll_id` | string | `$eq` `$in` |
| QueryPollVotesRequest | `updated_at` | date | `$eq` `$gt` `$gte` `$lt` `$lte` |
| QueryPollVotesRequest | `user_id` | string | `$eq` `$in` |
| QueryPollsRequest | `allow_answers` | boolean | `$eq` |
| QueryPollsRequest | `allow_user_suggested_options` | boolean | `$eq` |
| QueryPollsRequest | `created_at` | date | `$eq` `$gt` `$gte` `$lt` `$lte` |
| QueryPollsRequest | `created_by_id` | string | `$eq` `$in` |
| QueryPollsRequest | `custom` | object | `$autocomplete` `$contains` `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` `$q` |
| QueryPollsRequest | `id` | string | `$eq` `$in` |
| QueryPollsRequest | `is_closed` | boolean | `$eq` |
| QueryPollsRequest | `max_votes_allowed` | number | `$eq` `$gt` `$gte` `$lt` `$lte` |
| QueryPollsRequest | `name` | string | `$eq` `$in` |
| QueryPollsRequest | `updated_at` | date | `$eq` `$gt` `$gte` `$lt` `$lte` |
| QueryPollsRequest | `voting_visibility` | string | `$eq` |
| QueryReactionsRequest | `created_at` | date | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryReactionsRequest | `type` | string | `$eq` `$in` |
| QueryReactionsRequest | `user_id` | string | `$eq` `$in` |
| QueryRemindersRequest | `channel_cid` | string | `$eq` `$in` |
| QueryRemindersRequest | `created_at` | date | `$eq` `$gt` `$gte` `$lt` `$lte` |
| QueryRemindersRequest | `message_id` | string | `$eq` `$in` |
| QueryRemindersRequest | `remind_at` | date | `$eq` `$exists` `$gt` `$gte` `$lt` `$lte` |
| QueryThreadsRequest | `active_participant_count` | number | `$eq` `$gt` `$gte` `$lt` `$lte` |
| QueryThreadsRequest | `channel.disabled` | boolean | `$eq` |
| QueryThreadsRequest | `channel.team` | string | `$eq` `$in` |
| QueryThreadsRequest | `channel_cid` | string | `$eq` `$in` |
| QueryThreadsRequest | `created_at` | date | `$eq` `$gt` `$gte` `$lt` `$lte` |
| QueryThreadsRequest | `created_by_user_id` | string | `$eq` `$in` |
| QueryThreadsRequest | `custom` | object | `$autocomplete` `$contains` `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` `$q` |
| QueryThreadsRequest | `has_unread` | boolean | `$eq` |
| QueryThreadsRequest | `last_message_at` | date | `$eq` `$gt` `$gte` `$lt` `$lte` |
| QueryThreadsRequest | `parent_message_id` | string | `$eq` `$in` |
| QueryThreadsRequest | `participant_count` | number | `$eq` `$gt` `$gte` `$lt` `$lte` |
| QueryThreadsRequest | `reply_count` | number | `$eq` `$gt` `$gte` `$lt` `$lte` |
| QueryThreadsRequest | `updated_at` | date | `$eq` `$gt` `$gte` `$lt` `$lte` |
| QueryUsersPayload | `banned` | boolean | `$eq` `$ne` |
| QueryUsersPayload | `bypass_moderation` | boolean | `$eq` `$ne` |
| QueryUsersPayload | `created_at` | date | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryUsersPayload | `custom` | object | `$contains` `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryUsersPayload | `email` | string | `$eq` `$in` |
| QueryUsersPayload | `id` | string | `$autocomplete` `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` `$ne` `$nin` |
| QueryUsersPayload | `language` | string | `$eq` |
| QueryUsersPayload | `last_active` | date | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryUsersPayload | `name` | string | `$autocomplete` `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryUsersPayload | `role` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryUsersPayload | `shadow_banned` | boolean | `$eq` `$ne` |
| QueryUsersPayload | `teams` | string | `$contains` `$eq` `$in` |
| QueryUsersPayload | `updated_at` | date | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| QueryUsersPayload | `username` | string | `$autocomplete` `$eq` |
| SearchPayload | `app_banned` | string | `$eq` |
| SearchPayload | `archived` | boolean | `$eq` |
| SearchPayload | `blocked` | boolean | `$eq` |
| SearchPayload | `channel_role` | string | `$eq` `$in` |
| SearchPayload | `cid` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `created_at` | date | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `created_by_id` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `custom` | object | `$autocomplete` `$contains` `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` `$q` |
| SearchPayload | `disabled` | boolean | `$eq` |
| SearchPayload | `distinct` | boolean | `$eq` |
| SearchPayload | `filter_tags` | string | `$eq` `$in` |
| SearchPayload | `frozen` | boolean | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `has_unread` | boolean | `$eq` |
| SearchPayload | `hidden` | boolean | `$eq` |
| SearchPayload | `id` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `invite` | string | `$eq` |
| SearchPayload | `joined` | boolean | `$eq` |
| SearchPayload | `last_message_at` | date | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `last_updated` | date | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `member.user.name` | string | `$autocomplete` `$eq` |
| SearchPayload | `member_count` | number | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `members` | string | `$eq` `$in` |
| SearchPayload | `message_count` | number | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `muted` | boolean | `$eq` |
| SearchPayload | `name` | string | `$autocomplete` `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` `$q` |
| SearchPayload | `pinned` | boolean | `$eq` |
| SearchPayload | `team` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `type` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `updated_at` | date | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `attachments` | boolean | `$exists` |
| SearchPayload | `attachments.type` | string | `$eq` `$in` |
| SearchPayload | `cid` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `created_at` | date | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `custom` | object | `$eq` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `id` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `mentioned_users.id` | string | `$contains` |
| SearchPayload | `parent_id` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `pinned` | boolean | `$eq` |
| SearchPayload | `reply_count` | number | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `text` | string | `$any` `$autocomplete` `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` `$q` |
| SearchPayload | `type` | string | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `updated_at` | date | `$eq` `$exists` `$gt` `$gte` `$in` `$lt` `$lte` |
| SearchPayload | `user.id` | string | `$eq` `$in` |
| SearchPayload | `user_id` | string | `$eq` `$in` |

</details>

## What `matches()` is, and is not, for

The earlier pass called client-side filtering "the payoff". No Stream chat SDK does it:

- **chat-flutter** — `StreamChannelListEventHandler` never reads the query's filter. Membership is
  decided from event type alone.
- **chat-android** — identical. `DefaultChatEventHandler` is handed the `FilterObject` and ignores
  it; `FilterObject` has no `matches` at all.
- **chat-swift** — evaluates, but not generically: it re-attaches a per-key CoreData
  `predicateMapper` and builds an `NSPredicate?`, and `compactMap(\.predicate)` **drops** nodes it
  cannot wire.

So adopting core's `Filter` does not oblige us to call `matches()`, and nothing will at first.

Two consequences to carry.

**`matches()` throws on a `Filter.raw` leaf.** Returning `true` is correct under `and` and wrong
under `or`, and returning `false` inverts that; Swift's drop semantics needs the third state its
nullable predicate provides, which `bool matches(T)` does not have. Refusing is the only outcome
that cannot silently produce a wrong result, so core throws.

**A name filter matches approximately.** `user.name` and `channel.name` are stored normalized —
the column is `name_nf` — and `NormalizedNameHandlers` (`mq/name.go:23`) normalizes the filter
value before comparing, so the server compares normalized against normalized. Locally we control
only the field side: the caller's value reaches core's operator verbatim. Normalizing the getter
would not reproduce the server, it would only move which inputs disagree, and it would break
`equal(name, 'José')` — the natural call — to fix `equal(name, 'jose')`. So the getters stay raw.
This is the opposite of the sort registry, where both compared values come from the getter, which
is why normalizing is right there and wrong here. Fixing it properly means normalizing the query
value too, which is a per-field transform in core's operators.

If list-membership correctness is ever taken on as a feature — a real gap in both SDKs, where a
channel joins a list it does not match — these are the first things to revisit.

## The registries are verified against the backend

Feeds' registries mirror the backend's `mq.TableConfig` per resource, so chat's were checked the
same way against `~/GolandProjects/chat/lib/core/mq/<resource>/`. The gate is
`TableConfig.ToSortParameter` (`lib/core/mq/config.go:311`): a field resolves if the resource's
`ToSortParams` hook claims it, else if `Columns[field]` exists, else if the resource has a
`CustomFieldName` or lists the field in `AllowedCustomSortColumns` — otherwise the request is
rejected with *"sorting by %q is not allowed"*.

`AllowedSortColumns` is **not** that gate; it feeds `SortableFields()` for the OpenAPI spec and the
index classifier, so it is the *documented and indexed* set. That is what the registries mirror,
plus anything in `Columns` that a controller handles explicitly.

The endpoints were traced to their configs rather than guessed: message search resolves its sort
against `mq.GetTableConfig("message")` (`lib/chat/controller/v1/payload/search.go:58`), and
`queryBannedUsers` against `ban`.

> **Superseded in part.** The gate described here is the one `ToSortParameter` applies. A later
> pass found a second, stricter one — `ValidateSort`'s `AllowedSortCombinations` — that rejects
> whole *combinations* rather than fields, and that this table does not account for. See
> [Re-verified against the right backend field](#re-verified-against-the-right-backend-field).

| Resource | Backend `AllowedSortColumns` | Chat registry | |
| --- | --- | --- | --- |
| `channel` | `last_message_at` `last_updated` `created_at` `updated_at` `member_count` | + `pinned_at` `has_unread` `unread_count` | ✓ the three extras are claimed by `ToSortParams` / the denorm and DFX rewrites (`channel.go:1019`, `channel_denorm_gate.go:896`, `dfx_rewrite.go:570`) |
| `message` | `id` `updated_at` `created_at` | + `relevance` **added** | was missing one |
| `user` | — (no list; `Columns` + `CustomFieldName: custom`) | `id` `created_at` `updated_at` `name` `role` `banned` `last_active` | ✓ all in `Columns` |
| `poll` | `id` `name` `created_at` `updated_at` `is_closed` | same | ✓ exact |
| `poll_vote` | `id` `created_at` `updated_at`, custom `answer_text` | `id` `created_at` `updated_at` | ✓ `answer_text` was dropped — see the re-verification below |
| `member` | `created_at`, custom `name` | + `user_id` `channel_role` | ✓ both in `Columns`; the server also sorts by `updated_at`, `banned`, `last_active`, `is_moderator`, which chat does not expose |
| `draft` | `created_at` | same | ✓ exact — and `custom` was **removed**, see below |
| `thread` | `last_message_at` `created_at` `updated_at` `reply_count` `participant_count` `active_participant_count` `parent_message_id` `has_unread` | same 8 | ✓ exact |
| `reaction` | `created_at` | same | ✓ exact |
| `reminder` | `channel_cid` `remind_at` `created_at` `message_id` | + `message_id` **added** | was missing one |
| `ban` | — (`Columns`: `user_id` `banned_by_id` `channel_cid` `created_at` `reason`) | `created_at` | ✓ subset |

### The two pinned null orderings are verified

`ChannelSort` keeps `pinned_at` and `last_message_at` nulls-last in either direction, the only
place the SDK overrides a direction default. The rule lives on the sort rather than the field, and
is keyed on the **remote name** — which is what the API keys on, so a field built by hand for one
of those names is ordered the same way a declared one is. It also means the predefined-filter path
inherits it for free, since `ChannelSort.fromJson` is the parser.

Both orderings were checked in the general channel sort path
(`lib/core/mq/channel/channel.go`, `ToSortParams`) and the denormalized one
(`channel_denorm.go`, `renderDenormSortSQL`):

- **`pinned_at`** → `OrderNullsLast("pinned_at", direction)`, i.e. `NULLS LAST` either way
  (`channel.go:1129`, `:1131`).
- **`last_message_at`** → `DESC NULLS LAST` explicitly on a descending sort; ascending is
  nulls-last regardless, on Postgres by default and on CRDB because `null_ordered_last = true` is
  set on every connection.

The denorm path passes `nullsLast` unconditionally for `pinned_at`
(`formatOrderBy(cmAlias+".pinned_at", direction, true)`) with a comment saying it mirrors the
standard path "in both directions"; `last_message_at` passes `direction == -1`, so descending is
explicit and ascending relies on Postgres ordering a bare `ASC` nulls-last. A third path,
`channel_denorm_gate.go:352`, *declines* the optimization for a server-side-bound `pinned_at` sort
rather than serving a different order — so no path diverges.

Without the override a local re-sort by `pinned_at` descending puts unpinned channels *first* —
core's descending default is `nullsFirst` — while the API returns them last. That is a visible
offline/online disagreement in the channel list.

Also verified while checking: `pinned_at` is read from `it.membership?.pinnedAt`, and the API sorts
on the *connected caller's* member row (`member_pins` is keyed on `currentUser.ID`,
`channel.go:1035`), so the two agree — sorting on any other member's row would have been wrong. And
`ChannelModel.lastUpdatedAt` is `max(lastMessageAt, createdAt)`, matching
`GREATEST(last_message_at, channel_created_at)` including the null case, since Postgres `GREATEST`
ignores nulls.

One thing to know if the `hasUnread` / `unreadCount` TODOs are ever finished: the API inverts
core's defaults for the unread sort — `readstate.count DESC NULLS LAST` and `ASC NULLS FIRST`
(`channel.go:1114-1119`). That is direction-dependent, so a single `nullOrdering` on the field
cannot express it. It does not matter today, because both fields read `null` locally and so order
nothing.

**Android has no way to express this, and gets one direction wrong.** Neither
`stream-android-core` nor `stream-chat-android` models null ordering at all — both treat a null as
smaller than everything and let the direction flip it
(`Comparations.kt`: `first == null && second != null -> LESS_ON_COMPARISON * sortDirection.value`,
where `LESS_ON_COMPARISON = -1`, `ASC = 1`, `DESC = -1`):

| | Android | API | `stream_core` default | chat-flutter |
| --- | --- | --- | --- | --- |
| any field, ascending | nulls first | nulls **last** (Postgres default) | nulls last ✓ | nulls last ✓ |
| any field, descending | nulls last | nulls **first** (Postgres default) | nulls first ✓ | nulls first ✓ |
| `pinned_at` / `last_message_at`, ascending | nulls first ✗ | nulls **last** | nulls last ✓ | nulls last ✓ |
| `pinned_at` / `last_message_at`, descending | nulls last ✓ | nulls last | nulls first ✗ | nulls last ✓ (field) |

So Android's general defaults are inverted relative to the API, which cancels out into the right
answer for the two nulls-last fields sorted descending — the common case — and the wrong one
ascending. `stream_core`'s defaults match the API's general path, and chat's per-field
`nullOrdering` covers the two exceptions. That makes chat-flutter the only one of the three that
agrees with the API in both directions, which is the argument for keeping the field.

### Cross-checked against `stream-chat-js`

The JS client is the reference client, so its sort types were diffed against both the backend and
chat's registries — `src/types.ts` at [`18bc3cf`](https://github.com/GetStream/stream-chat-js/blob/18bc3cf7acbabdfd957f1e092821f68b81ea456e/src/types.ts).
It agreed on channels, drafts, polls and banned users exactly. Elsewhere:

| | JS | Backend | Action |
| --- | --- | --- | --- |
| `SearchMessageSortBase` | `text` `type` `parent_id` `reply_count` `pinned` `user.id` `attachments` `attachments.type` `mentioned_users.id` beyond chat's four | all nine present in the `message` `Columns` map | **added all nine** |
| `MemberSort` | `updated_at` `last_active` beyond chat's four | both in `member`'s `Columns` | **added both** |
| `ThreadSortBase` | no `has_unread` | `AllowedSortColumns` has it | JS gap — chat keeps it |
| `ReminderSort` | has `updated_at`, no `message_id` | `Columns` are `message_id` `channel_cid` `created_at` `remind_at` — **no `updated_at`** | JS is wrong both ways; chat follows the backend |
| `VoteSortBase` | `is_closed` and `name`, no `answer_text` | `poll_vote` allows `id` `created_at` `updated_at` | JS looks copy-pasted from `PollSortBase`; chat follows the backend |
| `ReactionSortBase` | `Sort<CustomReactionData>`, i.e. custom fields | `reaction` has **no** `CustomFieldName` and an empty custom list | JS is wrong; chat exposes no `custom` for reactions |
| `UserSort` | `Sort<UserResponse>` — *any* response field, including `privacy_settings` and `push_notifications` | 13 `Columns` + custom | Too loose to copy. Added the two both sides agree on and chat's `User` can read: `language`, `teams` |

`UserSort` is worth calling out: it is a structural type over the response model rather than a
curated allowlist, so it permits sorts the server rejects. `email`, `username`, `shadow_banned`
and `bypass_moderation` are all sortable server-side but absent from chat's `User`, so a field for
them would have no local value to read — left out rather than added as server-only.

Nine of the fields added are server-side only, because the value they sort on is a list with no
ordering (`attachments`, `attachments.type`, `mentioned_users.id`, `teams`) or is scored per
request (`relevance`). Each says so in its dartdoc; sorting a list locally by one leaves it
untouched rather than throwing.

Three things the check found:

- **`MessageReminderSortField.message_id` was missing.** The backend allows it and uses it as the
  reminder tiebreaker (`TiebreakerField: "message_id"`), so naming it is what makes a page boundary
  reproducible.
- **`MessageSearchSortField.relevance` was missing.** `Columns["relevance"]` exists with
  `TargetName: "scored.relevance"` and `mq.NoColumnOperators` — sort-only, never filterable — and
  `client.search` / `channel.search` resolve their sort against the `message` config
  (`payload/search.go:58`). It is absent from `AllowedSortColumns` because it is not an indexed
  column, but `ToSortParameter` resolves it and the search controller handles it explicitly:
  `GetSearchSort` *strips* a relevance sort when the request carries no text filter rather than
  failing (`payload/search.go:93-103`), so exposing it is safe. It is also the sort a search most
  obviously wants, and the Flutter SDK could not ask for it.

- **`DraftSortField.custom` could never work.** Draft is the one resource with
  `CustomFieldName: ""` *and* an empty `AllowedCustomSortColumns`, so any custom sort field is
  rejected. The old `getComparableField` fell back to `message.extraData[sortKey]`, which sorted
  locally and 400'd on the wire. Removed rather than ported.

Every other resource that exposes `custom(key)` has a non-empty `CustomFieldName` server-side:
`channel.custom`, `channel_member.custom`, message's, poll's and user's `custom`.

**Filters are not covered by this table.** The same `Columns` map carries a `SupportedOperators`
set per field, which is what feeds' per-field *"Supported operators:"* doc lines mirror. Verifying
chat's filterable fields and annotating them the same way is part of the filter half.

### Why each model gets its own `Sort` subclass

`ChannelSort`, `MemberSort` and friends exist to name the model's field type. `Sort.asc` takes a
`SortField<T>`, which any `SortField<User>` satisfies; `UserSort.asc` takes a `UserSortField`, so
a field belonging to another model does not compile and a caller is steered through the model's
registry.

The registry itself stays **open** — `UserSortField(remote, localValue)` is public, as it is in
feeds. That is deliberate: a consumer can sort by a field the API has grown and the SDK has not
modelled yet, rather than waiting for a release. `custom(key)` remains for the common case of a
field held in the model's extra data, declared for the six models whose `mq.TableConfig` carries a
`CustomFieldName`.

So the narrowing is a signpost, not a lock: it makes the declared fields the obvious path and
rules out cross-model mistakes, while leaving the escape hatch the API's own growth requires. A
field the API does not accept still fails at runtime with *"sorting by %q is not allowed"*, which
is why the [verification table](#the-registries-are-verified-against-the-backend) matters more
than the type system here.

The wrappers used to be twelve lines each because they restated core's defaults:

```dart
const UserSort.asc(
  UserSortField super.field, {
  super.nullOrdering = NullOrdering.nullsLast,   // core's own default
}) : super.asc();
```

A super-parameter **inherits the super constructor's default**, so the annotation was redundant.
Dropping it is behaviour-identical — confirmed by probe: `Sort.asc` still yields `nullsLast` and
`Sort.desc` still yields `nullsFirst` — and takes the wrappers from 147 lines to 87.

```dart
const UserSort.asc(UserSortField super.field, {super.nullOrdering}) : super.asc();
const UserSort.desc(UserSortField super.field, {super.nullOrdering}) : super.desc();
```

`ChannelSort` stays longer than the rest because it resolves the field's own `nullOrdering`, which
is the one thing a wrapper can do that core cannot.

**The wrappers are the cross-platform shape, so they stay.** Checked against the other two SDKs:

| | `Sort` generic over | Wrapper class per model | Default sort lives on |
| --- | --- | --- | --- |
| Dart (`stream_core`) | the model — `Sort<T>` | yes | the wrapper |
| Kotlin (`stream-android-core`) | the model — `Sort<T>(field: SortField<T>, …)` | yes — `class PollVotesSort : Sort<PollVoteData>` | the wrapper's companion — `PollVotesSort.Default` |
| Swift (`StreamCore`) | the **field** — `Sort<Field: SortField>`, via an associated type | **no** | `extension Sort where Field == …` |

Only Swift avoids the wrapper, and only because associated types make the narrowing free. An
earlier draft here proposed porting Swift's shape to Dart — it works (the model type is recovered
from an extension's *on-type*; a bound infers `Object`), but it needs a non-generic `SortFieldBase`
that no other SDK has, and it would put Dart out of step with Kotlin, which is the closer analogue.
Dropped.

Android goes further and closes its field set with a `sealed interface` whose members are
`data object`s — no escape hatch at all. Chat and feeds both keep theirs open.

### The registries expose no value getter

An earlier pass gave each `XSortField` a public `value` getter so the model tests could assert a
field's extraction in one line. That was testing surface masquerading as API: nothing in `lib`
read it, `stream_core` deliberately keeps `value` off `SortField` (it exposes one on `FilterField`
only because `Filter.matches(T)` needs it), and `STYLE_GUIDE.md` §"Avoid `@visibleForTesting`"
says to design for testability through the public API rather than exposing internals.

It is gone. The observable contract of a sort field is the *ordering*, so that is what the tests
assert, through two helpers in `test/src/utils.dart`:

```dart
expectOrders(MemberSortField.name, alice, zara);     // asc, desc and self-comparison
expectOrdersNothing(MessageSearchSortField.relevance, msg); // a server-side-only field
```

`expectOrdersNothing` also documents the nine fields that cannot order a list locally, which an
extraction test could only have asserted as "returns null".

### The default sorts were checked against the other SDKs

Chat's six defaults were introduced in one pass — `83bba81c7`, *"Improve query sorts and provide
defaults"* (#2188, April 2025) — where the controllers previously had none. That pass was never
checked cross-SDK, so it was checked here.

| Query | chat-flutter | chat-android | chat-swift | backend |
| --- | --- | --- | --- | --- |
| channel | `last_updated` desc | `last_updated` desc | sends none; local fallback `defaultSortingAt` desc | **`{last_updated: -1}`** (`channel_denorm_gate.go:341`, `fts_or_union_rewrite.go:296`) |
| draft | `created_at` desc | `created_at` desc | — | — |
| member | `created_at` **asc** | caller must supply one | local fallback `memberCreatedAt` desc | no default; tiebreak `user_id` asc |
| user | `created_at` desc | none | local fallback `id` desc | — |
| reminder | `remind_at` **asc** | `QuerySortByField()` — empty | — | no default; tiebreak `message_id` desc |
| poll vote | `created_at` desc *(was asc)* | `null` — none | — | no default; tiebreak `id` desc |
| thread | declared, not applied | `has_unread`, `last_message_at`, `parent_message_id` — all desc | — | — |
| reaction | `created_at` desc | — | — | **`ReactionResponse.DefaultSort()` = `created_at` desc** |

Channel is confirmed against the authority and agrees with both other SDKs. Outcomes:

- **`ThreadSort.defaultSort` added**, mirroring Android's three-field default. Declared only — the
  controller still sends nothing unless given a sort, so no list changes order.
- **`ReactionSort.defaultSort` added.** The API defines it, so it is a fact rather than a choice;
  `reaction_detail_sheet.dart` had been restating it inline.
- **Poll vote flipped to descending.** It was the one default that contradicted the house
  convention: reactions and poll votes are the same UI shape, the API defaults reactions to
  `created_at` desc, and it tiebreaks poll votes `id` desc.
- **Member and reminder keep ascending**, deliberately. Oldest-member-first is *stable* as people
  join — new members append instead of pushing every row down — and soonest-reminder-first is what
  a to-do list wants. Neither matches another SDK because neither other SDK sends a default at all.

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
| `typedef SortOrder<T extends ComparableFieldProvider> = List<SortOption<T>>` | `List<ChannelSort>` etc. — no typedef; `extension CompositeComparator on Iterable<Sort<T>>` |
| `SortOption.asc(String field)` / `.desc(String field)`, `static const ASC = 1 / DESC = -1` | `Sort.asc(SortField<T>)` / `.desc(SortField<T>)`, `enum SortDirection { asc(1), desc(-1) }` |
| field is a `String`, resolved at runtime via `ComparableFieldProvider.getComparableField(sortKey)` | field is a typed `SortField<T>{remote, comparator}` |
| `SortOption.fromJson` (drops the comparator) | `createFactory: false` — no `fromJson` |

`NullOrdering` and `CompositeComparator` exist in **both** packages by the same names → collision,
so our `sort_order.dart` must stop being exported in the same PR.

**No `SortOrder` typedef.** It was dropped rather than carried over, for three reasons. It named
the wrong concept — in SQL parlance a *sort order* is the direction, which this API now spells
`SortDirection`, while the thing being aliased is a list of criteria (the backend calls one a
`SortParam`, and the wire field is just `sort`). It existed to hide a nested generic, and with a
per-model `Sort` subclass there is no nesting left to hide: `List<ChannelSort>?` is three
characters *shorter* than `SortOrder<ChannelState>?`. And a generic `SortOrder<T> = List<Sort<T>>`
would be **wider** than `List<ChannelSort>`, so `[Sort.desc(ChannelSortField.pinnedAt)]` would
compile and silently lose that field's nulls-last ordering — `sort_test.dart` pins that difference.
`stream_core`, `stream_core_flutter` and `stream_feeds` declare no collection typedefs between
them.

**Per-field null-ordering defaults stay chat-side.** Ours are server parity, not preference:
`ChannelSortKey.pinnedAt` and `lastMessageAt` force `nullsLast` in *both* directions, where core's
defaults are the plain `asc → nullsLast` / `desc → nullsFirst`. Supply the right `nullOrdering`
from a thin chat-side factory per field. Cheaper than an upstream ask and it doesn't wait on a core
release.

**`SortOption.fromJson` has no core equivalent.** Find out who calls it — if anything deserialises
a stored sort (a persisted channel-list configuration, for instance), that needs a chat-side
resolver mapping a remote name back to a `SortField`.

## What shipped instead of a chat-side `StreamSortField`

**This section previously argued for a chat-side `StreamSortField` base class** — a `const`
private constructor, per-field `nullOrdering`, an overridden `value` method — whose whole purpose
was preserving `const` sort lists. None of it was built. `git grep "class StreamSortField"` returns
nothing.

What shipped is `class ChannelSortField extends SortField<ChannelState>` — core's base directly,
with a non-const constructor and `static final` members. There is no `SortOrder<T>` typedef either;
signatures name `List<ChannelSort>` and friends.

**So `const` sort lists are gone, and that is a consumer break.** Core's `SortField` takes a value
closure and a closure literal is not a constant expression, so every registry member is
`static final` and a caller cannot write `const [ChannelSort.desc(...)]`. Every v10 example and the
sample app wrote `const`. That is now a row in `migrations/v11-migration.md`'s Symbol Map; it was
missing for as long as this section claimed const-ness had been preserved, which is exactly how a
stale plan turns into a missing migration note.

Per-field null ordering did survive, but on the `Sort` subclass rather than the field:
`ChannelSort.asc` / `.desc` resolve `nullOrdering ?? _orderingFor(field, …)`, pinning `pinned_at`
and `last_message_at` to nulls-last in either direction. An explicit `nullOrdering:` **wins** over
that default — the earlier claim that it is ignored was backwards. `ThreadSort` gained the same
treatment for `last_message_at` after a review caught that a thread with no replies had started
sorting to the top.

## `ComparableField`: both divergences resolve chat-side

| | Ours | Core |
| --- | --- | --- |
| Strings | routed through `normalizeStringForSort` (`core/util/string_sort_normalizer.dart`, 95 LOC — folds diacritics and ligatures: `Ł→l`, `Ø→o`, `Æ→ae`, case-insensitive) | plain `String.compareTo` |
| Incomparable types | returns **`0`** | `ComparableField.compareTo` throws `ArgumentError` |
| `ComparableFieldProvider` | ours, and 14 files implement it | absent |

An earlier draft made both of these upstream asks. Neither is:

**The throw never reaches the sort path.** `SortComparator.call` wraps the comparison in
`runSafelySync(() => aValue.compareTo(bValue))` and takes `.getOrDefault(0)` — "If comparison
fails, treat as equal in sorting" (`query/sort.dart`). So core already degrades to `0` exactly
where ours does. `ArgumentError` only escapes if something calls `ComparableField.compareTo`
directly, which the sort layer never does. `StreamSortField` compares values itself and keeps the
`_ => 0` fallback explicitly, so the behaviour holds either way.

**Normalization belongs in the value extractor.** `SortField(remote, localValue)` takes a
`SortFieldValueGetter<T, Object>`, so a chat name field declares
`SortField('name', (u) => normalizeStringForSort(u.name))` and server parity is preserved without
touching core. That is the same mechanism core-swift relies on — its `SortComparator(localValue:)`
compares with plain `Comparable`, so any normalization is the extractor's job there too.

**`normalizeStringForSort` should move to core.** Chat folds inside each name field's value
getter — `UserSortField('name', (it) => it.name.let(normalizeStringForSort))` — which is correct
but has to be remembered field by field; see [`UPSTREAM.md`](UPSTREAM.md). In core it becomes the
default for every SDK and core's own `ComparableField` stops being wrong for names. Nothing in
this phase waits on it.

## Decisions taken

- **Escape hatches.** `Filter.custom` and `Filter.empty` are gone. An unmodelled *field* is
  reached with a registry's `custom` factory, an unmodelled *query* with core's `Filter.raw`.
  Nullability replaces `empty`, which matters on `queryThreads`.
- **`ComparableFieldProvider` is removed**, along with `getComparableField` on all eleven models.
  A field reads its own value, so an override had nowhere to go.
- **A `typedef` per queryable type**, as feeds does — `ChannelFilter`, `MemberFilter` and so on.
  Each names its registry and carries a worked example.
- **`predefined_filter.dart` is rebuilt on the registry.** Its filter is a `ChannelFilter` and the
  sort-fallback walk reads `toJson()`, since a preset is always a raw filter.
- **`matches()` is enabled, not used.** Nothing in the SDK calls it yet; wiring it into list
  handling is a behaviour change that deserves its own PR.

## Risks

- **Every query signature in the public API changes**, and `Filter` is one of the most-used types
  in consumer code. The `dart fix` transforms from phase [10](10-cleanup.md) matter more here than
  anywhere else — consider landing the kit before this phase rather than after.
- **Silent ordering regressions.** If `normalizeStringForSort` is dropped from a `SortField`'s
  value extractor, channel lists reorder for any user with an accented name and nothing fails.
  Golden-test it. This is now a *review* risk rather than a blocked dependency: the normalization
  is one call inside each string field's extractor, so it is easy to forget on a field-by-field
  basis.
- **`toJson()` drift.** Core builds the same three JSON shapes ours does (`{$op: [...]}`,
  `{key: {$op: value}}`, `{key: value}`), but "the same shapes" is not "the same output". Diff
  every existing filter's serialisation before and after.
- The registry is mechanical but large — one entry per filterable field across channels, users,
  members, messages, threads, drafts, polls and reminders.

## Upstream `stream_core` work

Three changes landed in core alongside this phase, in
[#181](https://github.com/GetStream/stream-core-flutter/pull/181):

- `normalizeStringForSort`, ported from chat so a locally sorted list of names matches the order
  a query returns.
- `Filter.raw`, the fallback leaf that lets a decoder stay total. `matches` throws for it.
- `Filter.equal` and `Filter.in_` now match an array-valued field element-wise. Comparing the
  whole list could never match, so `members`, `member.user.name` and `attachments.type` were
  undeclarable before it.

`$ne` and `$nin` were **not** added, and should not be: they are deprecated server-side and being
withdrawn. `$nor` is modelled by none of the three cores.

## Definition of done

- [x] `Filter.notEqual`, `Filter.notIn` and `Filter.nor` are **removed**, not deprecated:
      `$ne`, `$nin` and `$nor` are deprecated server-side and being withdrawn. The three
      sample-app call sites that hid the signed-in user or existing members now list everyone the
      query returns, as the iOS and React Native sample apps do.
- [x] `filter.dart`, `sort_order.dart`, our `comparable_field.dart` and
      `location_coordinates.dart` are deleted; `stream_chat.dart` exports core's via the
      allowlist.
- [x] A `FilterField` / `SortField` registry exists for every queryable type, with local
      extractors. Eleven of each. `QueryMessageFlagsPayload` is the one endpoint left unmodelled,
      because chat has no API for it.
- [x] **A golden ordering test** over accented and ligatured names proves `normalizeStringForSort`
      behaviour survives — `string_sort_normalizer_test.dart` and `sort_test.dart`.
- [x] Per-field `NullOrdering` defaults preserved — `pinnedAt` and `lastMessageAt` asserted in
      both directions (`sort_test.dart:103`).
- [x] Nothing throws where the old `ComparableField` returned `0` (`sort_test.dart:419`,
      "should treat unorderable values as equal rather than throwing").
- [x] `SortOption.fromJson` callers accounted for — there are two, and both now go through
      `ChannelSort.fromJson`: `PredefinedFilter.sort`, where the API echoes the sort it resolved
      for a preset (found by `json_serializable` by convention, so no `@JsonKey` hook), and
      `stream_chat_persistence`'s Drift converter for the same spec persisted for offline reads.
      A bare `Sort.fromJson` would not have served either — see [UPSTREAM.md](UPSTREAM.md).
- [x] `melos run analyze`, `melos run format` and `melos run test:dart` are green, as are
      `stream_chat_flutter_core`'s tests. `stream_chat_flutter` and `docs_screenshots` each carry
      11 pre-existing golden failures, in files this phase does not touch.
- [ ] **Serialisation diff.** Not run as a systematic before/after byte diff. The api tests assert
      request payloads and pass unchanged, and every documented example was executed and its JSON
      checked, but a filter the SDK can build and no test exercises is unverified.

### Re-verified against the right backend field

An earlier pass in this phase checked each registry against `mq.TableConfig.AllowedSortColumns`.
That is the wrong source: it implements `querymeta.SortConfig.SortableFields()` and feeds query
tooling, and it is *not* what rejects a sort. Messages make the divergence obvious —
`AllowedSortColumns` lists three fields while ten work. The two things that actually decide are:

1. **`Columns`** — `IsCustomField(f)` is literally `Columns[f] == nil` (`mq/config.go:376`), so an
   unlisted field becomes a custom-JSON sort rather than an error.
2. **`Model.AllowedSortCombinations(app)`** — checked in `ValidateSort` (`mq/sql.go:652`). It
   returns `(combos, skip)`. When `skip` is false the sort must match a listed combination
   **exactly**, after `addTiebreakerToSortParams` has appended the tiebreaker tail. Resources with
   no `Model` (channel, member, user, ban) never reach it.

| Resource | What the server enforces | Ours | |
| --- | --- | --- | --- |
| Channel | no `Model`; `Columns` + a custom `SortAndPager` that special-cases `has_unread` (alias `unread_count`, `channel.go:1300`) and `pinned_at` | 8 | ✓ |
| Member | no `Model`; `Columns` (15) | 6 | ✓ subset |
| User | no `Model`; `Columns` (13) | 8 | ✓ subset |
| BannedUser | no `Model`; `Columns` = `user_id, banned_by_id, channel_cid, created_at, reason` | 1 | ✓ subset |
| Message | `skip = true` — no validation at all | 10 | ✓ |
| Draft | `{created_at}` | `created_at` | ✓ exact |
| Poll | `{id} {name} {created_at} {updated_at} {is_closed}` | same 5 | ✓ exact |
| Reaction | `{created_at}`, `skip = true` | `created_at` | ✓ |
| Thread | 8 combinations | 8 fields | ⚠ combinations |
| MessageReminder | `{channel_cid,message_id} {remind_at,message_id} {created_at}` | 4 fields | ⚠ combinations |
| PollVote | `{id} {created_at} {updated_at}` | our 3 == the 3 ✓ | `answer_text` dropped |

### Cross-checked against iOS and Android

Android's registry is not a typed list — it is `getComparableField` on eleven models
(`stream-chat-android-core/.../models/*.kt`), the same eleven we declare. iOS's is eight
`SortingKey` types under `Sources/StreamChat/Query/`. Both were compared field by field.

The one change that came out of it: **`ChannelSortField.cid` added** (both SDKs have it, and it is
a real denorm column). Nothing was removed on their account — an earlier pass trimmed to a strict
intersection and it was wrong in three places, which is worth recording so it is not retried:

- **Android's list is not evidence of API support.** `getComparableField` says what Android can
  compare *in memory*; its message entry includes `html`, `command`, `silent` and
  `updated_locally_at`, which are plainly not sortable server-side.
- **iOS is missing fields the server requires.** It has no `lastUpdated` for channels — which is
  both `ChannelSort.defaultSort` and the server's own fallback — and no `messageId` for reminders,
  which two of the three allowed reminder combinations require.
- **Both expose a field the server rejects.** Their message-reminder `updated_at` appears in no
  allowed combination.

So parity is a useful cross-check and a poor rule. The declared set is the backend-verified one.

`MessageSearchSortField.pinned` is kept (JS and Android have it; iOS does not) with a documented
limit: `pinned` is the only column in the whole mq layer with an explicitly empty `ESTargetName`
(`message/message.go:430`), because the pinned *filter* is a custom ES bool query over
`pinned_at` / `pin_expires` rather than a mapped field. `elasticsearch.go:92` reads that value with
no empty-check, so an index-backed search has nothing to order on. Whether the client errors or
drops the sorter was not verified — there is no test covering it — so the dartdoc says the field
is unsupported there rather than predicting a behaviour. It is correct on the
database-backed path. Unlike `answer_text`, this fails on one backend rather than doing nothing on
all of them, which is a limitation to document rather than a reason to drop the field.

**What is deliberately not declared.** Every combination-enforced resource is exact: our fields
are precisely those appearing in the server's allowed combinations, no more. Thread and draft each
have columns we omit — `channel_cid`, `created_by_user_id`, `channel.disabled`, `channel.team`,
and draft's `channel_cid` / `parent_id` — and omitting them is required, not cautious, since none
appears in any combination and the server would reject them.

The four resources with no combination enforcement have real gaps, all readable off our models:
reaction `type` and `user_id` (its `AllowedSortCombinations` answers `skip = true`, so its
one-combination list enforces nothing); member `is_moderator` and `banned`; banned-user `user_id`,
`banned_by_id`, `channel_cid` and `reason`; and a long tail on channel. None is declared, on the
grounds that adding a sort field later is additive while removing one is breaking, so an
unrequested field is a liability in a `.0`.

One is worth a backend question before anyone adds it: **`ChannelSortField.name`**. Sorting a
channel list alphabetically is the obvious ask, and `name` is a real denorm column — but it is
*not* in channel's `AllowedSortColumns`, the documented-and-indexed set, so it may be accepted and
unindexed on the SDK's hottest query.

**`PollVoteSortField.answerText` was removed because it does not work.** `answer_text` is not a poll-vote column
(`id, poll_id, user_id, created_at, updated_at, option_id, is_answer`), so it takes the custom
path — and while `poll_vote.go:22` whitelists it via `AllowedCustomSortColumns`, the package never
sets `CustomFieldName`, so `ValidateSort`'s `config.CustomFieldName == ""` short-circuits to
`sorting by "answer_text" is not allowed`. It would fail the combination check immediately after
regardless, since custom fields get no exemption there. The backend config reads as unfinished
rather than deliberate, so confirm with the server team before removing the field — but as
deployed it errors.

**Combination constraints are not modelled by any SDK, including ours.** For the five
`skip = false` resources the server accepts only whole listed combinations, so
`[ThreadSort.desc(createdAt), ThreadSort.desc(replyCount)]` compiles here and comes back as
`invalid sort parameter: …, allowed sort combinations: …`. A typed field registry prevents an
invalid *field*, not an invalid *combination*. Worth its own decision — the cheap version is
documenting the legal combinations on each `XSort` class; the expensive one is named constructors
per combination. Not in scope for the sort migration.

**No sort field is restricted to server-side auth, and one is restricted to client-side.** The
whole chat codebase has exactly one auth-gated sort — `query_channels.go:379`, which rejects
`has_unread` / `unread_count` for a *secret-key* request ("not support server-side"), since there
is no user to compute unread against. So those two are client-only, which is why this SDK
declares them and a server SDK could not. Nothing is gated the other way: message search runs
`req.GetSearchSort()` into `NewSearchOptions` with no auth check, so every field the message table
addresses is reachable with an API key and a user token.

That makes "server-side field" the wrong axis for deciding what to declare. The real one is
whether the value is readable off the model, and two message columns fail it while being perfectly
valid on the wire: `cid` (`Message` carries no channel id — search returns channel context beside
the message, not inside it) and `attachments` (declared `TypeBoolean` for filter coercion, but
sorting resolves to the raw `message.attachments` column, which is JSONB, so the server orders by
Postgres's structural jsonb collation and not by "has attachments"). Both would need
`(_) => null`, joining `relevance` as fields whose local re-sort silently no-ops. `relevance`
earns that; a second and third would just be lies with a wire payload attached, so neither is
declared.

**Messages are sortable on exactly one endpoint, and the sort is message-only.** `/search` takes
*two* filters and *one* sort: `filter_conditions` binds to the channel table,
`message_filter_conditions` and `sort` both bind to the message table
(`payload/search.go:56-58`). `mq.GetTableConfig("message")` is referenced nowhere else in the
codebase, so there is no other message query to sort. Every other SDK scopes the name to that:
JS `SearchMessageSort`, Swift `MessageSearchSortingKey` (inside `MessageSearchQuery`), Android
only on `searchMessages`. Ours read broader than the capability, so this phase renamed it to
`MessageSearchSort` / `MessageSearchSortField`. Feeds is precedent for naming a sort after the
query rather than the model — `ActivityReactionsSort` and `CommentReactionsSort` are both
`Sort<FeedsReactionData>` — and it keeps `MessageSort` free for a general message query, and
leaves room for the `PinnedMessagesSort` that a pinned-messages endpoint would need.

A wrong sort field on `/search` fails **silently**, which is why the typed registry earns its
keep here more than elsewhere. Nothing rejects it: payload validation checks only that the field
is non-empty and the direction is ±1 (`commonpayloads/sort.go:153`), and `ValidateSort` returns
before its checks because `Message.AllowedSortCombinations` answers `skip = true`
(`types/message.go:255`) — messages are the resource with *no* combination allowlist. The field
then falls through `IsCustomField`, which is just `Columns[field] == nil`
(`mq/config.go:376`), and is emitted as `message.custom->>'<field>'`. For a channel field like
`member_count` that key is null on every row, so the term contributes nothing and ordering falls
to the tiebreaker. The old untyped `SortOrder?` let exactly this through.

**`StreamChannelListController` seeds `ChannelSort.defaultSort` unconditionally**, including when
a `predefinedFilter` is set — the same shape as before this phase, when it was a default parameter
value. The preset's own sort then replaces it in the response and `_resolveSort` adopts that, so
the ordering self-corrects after the first page.

What the backend does with the two arguments, since it is asymmetric and not documented anywhere:
a `predefinedFilter` replaces `filter` **outright** (`query_channels.go:195`,
`req.Filters = interpolatedFilter`) — passing both is accepted with no validation and the caller's
filter is silently discarded. The sort is only overwritten when the preset *defines* one (`:224`);
a preset with no sort template leaves the caller's sort in force.

That leaves one known gap, accepted deliberately. For a preset with **no** sort template whose
interpolated filter carries a `last_message_at` term, the server honours the `last_updated` we
sent, while the response carries no sort — so `PredefinedFilter.effectiveSort` falls through to
`_defaultSortFor`, which mirrors the server's *no-sort* fallback (`channel.go:756`: `last_updated`,
or `last_message_at` when the filter mentions it) and answers `last_message_at`. Server and client
then order by different fields, and `loadMore`'s offset indexes into a list ordered differently
from the one displayed.

The alternative was tried and **rejected**: falling back to the sort we actually sent
(`resolved.sort ?? <sent>` at both `effectiveSort` call sites) closes the gap and retires
`_defaultSortFor`, but it also gives up the only sensible ordering an offline read has when a
caller queries a preset directly without a sort — there the sent sort is null, and the cache would
be left unordered. `_defaultSortFor` stays. It is a hand-written Dart mirror of `channel.go:756`
and has to be re-checked whenever that fallback changes.

Worth recording either way: because the client always sends a sort, a channel query never reaches
`sql.go:620`'s `config.Model.DefaultSort()` — which would be a nil dereference, as the channel
`TableConfig` declares no `Model`.

**`ThreadSort.defaultSort` is declared and deliberately not applied.** Every other controller
resolves `sort ?? XSort.defaultSort`, because every other one *had* a local default constant
before this phase. The thread controller did not, and threads are the one resource where
supplying a sort is not equivalent to omitting one: `query_threads.go:110` branches on
`request.Filter != nil || request.Sort != nil`, and the no-sort path is answered by
`SelectThreadsForUser`, a narrower query whose `ORDER BY` is hardcoded to
`has_unread DESC, thread.last_message_at DESC, thread.parent_message_id DESC`
(`threadstate/store.go:513`) — which is exactly what `defaultSort` declares. So sending it buys
the same ordering off a wider code path. It exists to sort a thread list locally, and its
dartdoc says so, since the asymmetry otherwise reads as an oversight.

The persisted shape did not change, so no row needs rewriting — but `schemaVersion` still moves
from `1000 + 35` to the `1100 + N` band, and drift's `onUpgrade` drops and recreates every table
when it does. Cached channels, messages and reads are discarded on upgrade and refetched; that is
the v11 behaviour generally, not something this phase introduces. Verified against the
deleted serializer rather than assumed — `git show HEAD:…/core/api/sort_order.g.dart` shows
`_$SortOptionToJson` emitted exactly `field` and `direction`, and **not** `nullOrdering` despite
`SortOption` carrying it as a field. `ChannelSortConverter`
(`stream_chat_persistence/lib/src/converter/channel_sort_converter.dart`, renamed from
`ChannelStateSortOrderConverter`) writes those same two keys, which its test now pins as a
literal — rows outlive the SDK version that wrote them, so the shape may not drift by accident.
- [x] `refactor(llc)!:` titles, `🛑️ Breaking` CHANGELOG entries in `stream_chat`,
      `stream_chat_persistence` and `stream_chat_flutter_core`, and `migrations/v11-migration.md`
      Symbol Map rows. No feature section: none of the phases has written one, and the Symbol Map
      rows carry the before/after.
- [x] Decisions recorded here, status box ticked in `README.md`.
