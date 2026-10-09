# Migrating `stream_chat` to the OpenAPI-generated client

The plan for moving the low-level client off its hand-written HTTP layer and onto the OpenAPI-generated client in
`packages/stream_chat/lib/open_api/`.

One file per feature group, in the order they should land. Each carries a goal, the exact hand-written methods and
generated operations in scope, the decisions that group has to make, its risks, and a definition of done.

> **Related plan:** [`core-migration/`](../core-migration/README.md) moves the low-level client's *foundation*
> (HTTP, errors, token/auth, WebSocket, uploads, query DSL, logger) onto `stream_core`. It owns the error layer and
> the `Result` surface that group 01 below previously claimed. The two tracks are otherwise independent.

| | Group | Hand-written | Generated ops | Status |
| --- | --- | --- | --- | --- |
| [01](01-foundation.md) | Foundation — `DefaultApi` wiring, `User` shape | — | — | ☐ |
| [02](02-devices.md) | Devices | 0 | 3 | ☑ |
| [03](03-user-groups.md) | User Groups | 0 | 8 | ☑ |
| [04](04-roles-guest-and-app.md) | Roles, Guest & App Settings | 0 | 5 | ☑ |
| [05](05-polls.md) | Polls | 0 | 13 | ☑ |
| [06](06-reminders.md) | Message Reminders | 0 | 4 | ☑ |
| [07](07-threads-and-drafts.md) | Threads & Drafts | 7 | 7 | ☐ |
| [08](08-moderation-and-blocklists.md) | Moderation & Blocklists | 0 | 34 | ☑ |
| [09](09-users.md) | Users | 3 | 3 | ☐ |
| [10](10-messages.md) | Messages & Search | 14 | 12 | ☐ |
| [11](11-channels-and-members.md) | Channels, Members & Sync | 13 | 15 | ☐ |
| [12](12-uploads-cdn.md) | Uploads (CDN) | 8 | 8 | ☑ |
| [13](13-push-preferences.md) | Push Preferences | 1 | 1 | ☐ |
| [14](14-banned-users.md) | Banned Users — split out of 08 | 1 | 1 | ☐ |
| [15](15-partial-updates.md) | Partial Updates — split out of 11 | 0 | 2 | ☑ |
| [16](16-channel-lifecycle.md) | Channel Lifecycle — split out of 11 | 0 | 3 | ☑ |
| [17](17-read-receipts.md) | Read Receipts — split out of 11 | 0 | 4 | ☑ |
| [18](18-unread-counts.md) | Unread Counts — split out of 09 | 0 | 1 | ☑ |
| [19](19-user-blocking.md) | User Blocking — split out of 09 | 0 | 3 | ☑ |
| [20](20-user-updates.md) | User Updates — split out of 09 | 0 | 2 | ☑ |
| [21](21-custom-data-rename.md) | `extraData` → `custom`, every model at once | — | — | ☐ |

**Coverage:** 47 hand-written methods across 8 files, and all 129 generated operations, each claimed by exactly
one group. Verified mechanically — see [Keeping this plan honest](#keeping-this-plan-honest).


## Goals

1. **One API layer, not two.** Every endpoint the SDK calls goes through the generated client, so new API surface
   arrives by regenerating rather than by hand-writing a DTO.
2. **Shapes consistent with our other SDKs**, because they come from the same spec.
3. **Errors from `stream_core`**, so a Flutter integrator handling a Stream error handles it the same way they
   would in another Stream SDK.
4. **`Result`-returning public APIs**, matching `stream_feeds`.
5. **An upgrade path that is boring**, because `migrations/v11-migration.md` is written as each group lands rather
   than reconstructed at release.

## Non-goals

- **Moving the WebSocket to v2.** It sends different event shapes and is its own project. Never fold it into a
  feature group.
- **Exposing the generated models.** Generated types are wire shapes, named after the requests they hang off.
  They stay private, and the public API keeps our models — see [Domain models](#domain-models).
- **Regenerating the client.** That is `openapi-codegen`, and it lands as its own PR.

## Principles

- **One feature group per PR.** A group is a set of endpoints a caller thinks of together, and it moves across
  completely — half-migrated features are worse than unmigrated ones.
- **Keep our shape.** The public API keeps the v10 models and envelopes, and their names by default. The only
  sanctioned breaks are the ones [Domain models](#domain-models) lists.
- **Every break ships four artifacts**: `refactor(<scope>)!:` title (usually `llc`), `🛑️ Breaking` CHANGELOG
  entry, the edits `migrations/v11-migration.md` asks for (Symbol Map row, Quick Reference row, feature section),
  and the reason in the PR body.
- **Decide once, at the right level.** The `User` shape is decided in [01-foundation](01-foundation.md), not
  re-argued per group. Errors and `Result` are decided in
  [`core-migration/03-errors.md`](../core-migration/03-errors.md).

## Domain models

The generated client is an implementation detail. Every group follows these rules, and makes exactly these
breaks against v10:

- public methods return `Result<T>` instead of throwing;
- a write whose generated response is `DurationResponse` returns `Result<void>` rather than `EmptyResponse`;
- a read returns its envelope, even where v10 returned the bare payload (`getAppSettings` now answers
  `AppSettingsResponse`, not `AppSettings`); a new envelope's name is proposed case by case;
- a write whose generated response is a named `*Response` returns that envelope, even where v10 returned
  `EmptyResponse` or a bare model (`hideChannel` answers `HideChannelResponse`);
- a field the spec marks optional is nullable by default, even where v10 typed it non-null
  (`CreateUserGroupResponse.userGroup`); keeping one non-null needs a recorded reason and a mapper fallback, as
  group 04 does for `OGAttachmentResponse.ogScrapeUrl`;
- public models and envelopes lose `fromJson` and `toJson`;
- envelopes are immutable, built through a const constructor rather than `late` setters;
- `duration` is a non-nullable `String` on every envelope, where v10 typed it `String?`;
- public models and envelopes are `@freezed`, so they compare by value; one that extended `Equatable` in v10 no
  longer does, and loses `props`.

Each ships the four artifacts listed under [Principles](#principles), like any other break.

**Why `DurationResponse` becomes `void`, and nothing else does.** `DurationResponse` is the base response every
other response embeds, so no field is ever added to it and dropping it loses nothing. An endpoint that later needs
to return data moves to its own named response: a spec change, and a break taken then. Every other response can
gain fields, so the caller gets its envelope and a field the server adds later is an additive change. That
includes a named response that carries only `duration` today, such as `HideChannelResponse` or
`DeleteReminderResponse`.

1. **No generated type in a public signature.** `lib/stream_chat.dart` exports nothing from `open_api/`, and no
   other package or the sample app imports it. `generate_plan.py --check` enforces both.
2. **Public models keep their v10 fields and defaults,** as `@freezed` classes (value equality, `copyWith`,
   `toString`) with no `fromJson`, `toJson` or json_serializable. Nullability follows v10 unless the spec is looser
   (see the breaks above). A field the server adds is exposed later, as an additive change. The one exception to
   "no JSON" is the temporary `@DataSerializable` storage codec in rule 8.

   **A model that had a `copyWith` in v10 keeps that exact method,** `_nullConst` sentinels included, under
   `@Freezed(copyWith: false)`. freezed's own `copyWith` sets a field passed as `null`, where v10's keeps it, and
   the SDK's state handling depends on the difference. Only a model with no v10 `copyWith` uses freezed's.

   **Names follow the spec's, unless the spec's name is awkward or describes something else,** and calls the
   caller sees as siblings share one scheme: `updateChannelPartial` and `updateMemberPartial` answer
   `UpdateChannelPartialResponse` and `UpdateMemberPartialResponse`, where v10 had `PartialUpdateChannelResponse`,
   `partialMemberUpdate` and `PartialUpdateMemberResponse`. v10's name stays where the generated one does not fit:
   `OGAttachmentResponse` rather than `GetOGResponse`, `AppSettings` rather than `AppResponseFields`. Names an
   earlier group settled stand, such as group 04's `getAppSettings` and `UploadConfig`. Renaming a v10 type or
   method is a break, so it needs approval, a Symbol Map row, and a line in the PR description.
3. **Responses keep their v10 envelopes,** as `@freezed` classes carrying a non-nullable `duration` and the
   payload. Every envelope lives in `lib/src/core/models/response/`, and every public type a caller passes in to
   shape a request — a `*Request` class, or a parameter type such as `PaginationParams` or `ThreadOptions` — in
   `lib/src/core/models/request/`, one file per class. Every other model stays in `lib/src/core/models/`.
   `EmptyResponse` stays behind for the unmigrated APIs.
4. **Public methods return `Result<T>`,** per [`core-migration/03-errors.md`](../core-migration/03-errors.md).
5. **Mapping happens in the repository,** on the `Result` the generated call returns
   (`result.map((response) => response.toModel())`, or `result.ignoreValue()` from
   `lib/src/repository/mapper/result_mapper.dart` for `Result<void>`), through extensions in
   `lib/src/repository/mapper/<feature>_mapper.dart`: `toModel()` from a generated type to ours, `toRequest()`
   from ours to a generated request. The mappers are package-internal so later groups can compose them.
   Repositories import the generated code with a prefix (`as api`), which keeps its names from colliding with
   ours.
6. **Request enums are hand-written extension types** over the wire string, per `STYLE_GUIDE.md` § Prefer
   extension types over enums for server-defined values, and mapped to the generated type in the repository
   (`PushProvider` → `CreateDeviceRequestPushProvider`).
7. **A plain model embedded in a json_serializable parent gets a temporary converter.** Some parents still decode
   v1 REST or WebSocket JSON with json_serializable; their field gets a `JsonConverter` — or a decode-only
   `fromJson` function when the parent never writes the field — in
   `lib/src/core/models/converters/v1_json_converters.dart`, marked
   `// TODO(openapi-migration): remove in group NN` and listed below. The group that migrates the parent deletes
   it, and `generate_plan.py --check` fails if a ticked group leaves one behind.
8. **Persistence stores a model as JSON text through its `@DataSerializable` codec.** `DataSerializable`
   (`lib/src/db/data_serializable.dart`) is a typedef for `JsonSerializable`, and the only class-level json_serializable
   annotation a public model may carry. The model exposes the generated code as `fromData` and `toData`, which only
   `stream_chat_persistence` calls; it never gains `fromJson` or `toJson`. A field holding another plain model
   needs `@JsonKey(fromJson: ..., toJson: ...)` functions that call the nested `fromData` and `toData`, because
   json_serializable only looks for `fromJson` and `toJson` on nested types; the parent then carries
   `@DataSerializable` too. A plain model nested in a parent that is still json_serializable needs no codec: the
   parent's rule-7 converter writes it. The codec is temporary: every use is marked
   `// TODO(openapi-migration): remove in group 10` and listed below, and group 10 replaces every use and deletes
   the typedef, so no later group adds one. The cache is disposable, so the stored format is ours to choose.

### Temporary adapters

| Adapter | Field | Removed by |
| --- | --- | --- |
| `DeviceV1JsonConverter` | `OwnUser.devices` | [09](09-users.md) |
| `userGroupsFromV1Json` | `Message.mentionedGroups` | [10](10-messages.md) |
| `moderationFromV1Json` | `Message.moderation` | [10](10-messages.md) |
| `reactionGroupsFromV1Json` | `Message.reactionGroups` | [10](10-messages.md) |
| `ActionV1JsonConverter` | `Attachment.actions` | [10](10-messages.md) |
| `LocationV1JsonConverter` | `Message.sharedLocation`, `ChannelState.activeLiveLocations`, `GetActiveLiveLocationsResponse.activeLiveLocations`, `updateLiveLocation`'s response | [10](10-messages.md) |
| `MessageReminderV1JsonConverter` | `Message.reminder`, `Event.reminder` | WebSocket v2 (no group) |
| `ReactionV1JsonConverter` | `Message.latestReactions` / `ownReactions`, `Event.reaction`, `QueryReactionsResponse.reactions`, `SendReactionResponse.reaction`, the `sendReaction` body | WebSocket v2 (no group) |
| `DataSerializable` | `UserGroup`, `UserGroupMember`, `ReactionGroup`, `PollOption` (`fromData`, `toData`) | [10](10-messages.md) |
| `PollV1JsonConverter` | `Message.poll`, `DraftMessage.poll`, `Event.poll` | WebSocket v2 (no group) |
| `PollVoteV1JsonConverter` | `Event.pollVote` | WebSocket v2 (no group) |
| `users_mapper.dart` (kept, re-pointed) | today's `User`, which still reads and writes JSON | [09](09-users.md) |
| `channels_mapper.dart` (kept, re-pointed) | today's `ChannelModel`, `ChannelConfig` and `Member`, which still read and write JSON | [11](11-channels-and-members.md) |
| `messages_mapper.dart`, `attachments_mapper.dart`, `reactions_mapper.dart`, `locations_mapper.dart`, `drafts_mapper.dart` (kept, re-pointed) | today's `Message`, `Attachment`, `Reaction`, `Location`, `Draft` and `DraftMessage`, which still read and write JSON | [10](10-messages.md) |

How v1 JSON decodes `User` once it becomes a plain model is decided in [01-foundation](01-foundation.md): until
group 09 restructures it, v1 payloads keep decoding through `User.fromJson`.

## Order, and why

**[01-foundation](01-foundation.md) first, and it blocks everything.** After it, groups 02–07 can run in parallel;
08–12 are best run in sequence because they share models.

The order runs from smallest and most isolated to largest and most entangled, so the pattern is proven on cheap
surfaces before it reaches `Message` and `ChannelState`:

- **02–04** have almost no persistence (03 stores mentioned groups) and almost no public model surface. Group 02
  is the pattern-proving slice.
- **05–07** introduce persisted models and WebSocket-delivered updates, one at a time.
- **08** is where we decide what *not* to expose: 34 generated operations against 10 hand-written methods.
- **14** is `queryBannedUsers`, split out of 08 because it is the only moderation call that answers with a
  model. The `User` mappers it needs landed with group 04.
- **10–11** are the core of the SDK, and carry the `custom` / `extraData` promotion problem.
- **15** is the partial channel and member updates, split out of 11 so `channels_mapper.dart` lands on calls that
  read nothing into `ChannelState`. It landed first; the full update waits in 11 for group 10's message mappers.
- **16** is hiding, showing and deleting a channel, split out of 11 after 15 because they answer nothing
  `channels_mapper.dart` cannot map.
- **17** is the read and delivery receipts, split out of 11 after 16. They answer only a `duration` and a read
  event, which waits for group 10's message mappers.
- **18** is the current user's unread counts, split out of 09 because it embeds no `User` and nothing persists it.
- **19** is blocking and unblocking users and listing the blocked ones, split out of 09 because it embeds `User`
  only through the existing mappers and nothing persists it.
- **20** is creating, updating and partially updating users, split out of 09 because its response maps onto the
  current `User` and nothing persists it. It also promotes `deactivatedAt`, `deletedAt` and `shadowBanned` onto
  `User` as getters over `extraData`.
- **12** comes late because it needs its own hand-written multipart client and is the highest-traffic path in the
  SDK.
- **09** is last. Every group before it maps users through `users_mapper.dart` onto today's `User`; 09 migrates the
  user endpoints and restructures `User` and `OwnUser` themselves, when every parent that embeds them has moved.
- **21** renames `extraData` to `custom` on every model at once. The groups keep `extraData`, so the SDK stays
  consistent until then; it runs after 09.

## Prerequisites

- **The generated client committed and building** — it is, in `lib/open_api/`.
- **The generator's `client.tpl` calling `runApiSafely`, not `runSafely`** — see
  [01-foundation](01-foundation.md#prerequisites).

## How to execute a group

Use the **`openapi-migration`** skill: it is the per-group process (scope → decide shapes → sequence → implement →
tests → verify). Use **`openapi-codegen`** when a type or operation is missing, or the generated code is wrong.

Consumer-facing changes go in `migrations/v11-migration.md` in the same PR that makes them.

A migration follows [`STYLE_GUIDE.md`](../STYLE_GUIDE.md), [`EFFECTIVE_DART_DOC.md`](../EFFECTIVE_DART_DOC.md)
and [`TESTING.md`](../TESTING.md) like any other change. Nothing in CI checks them — `dart analyze --fatal-infos`
checks a public member *has* a doc, never what it says or how a test is named — so the last two boxes of every
definition of done stand for reading the diff against them.

## Keeping this plan honest

The scope tables are generated from the SDK, not typed by hand:

```bash
python3 openapi-migration/tool/generate_plan.py           # regenerate the tables + report
python3 openapi-migration/tool/generate_plan.py --check    # report only, non-zero exit on a gap
```

It re-derives:

- every public method in `lib/src/core/api/*_api.dart` and `attachment_file_uploader.dart`, and
- every operation in `lib/open_api/api/default_api.dart`, with its verb, path and response type,

then asserts that each hand-written file belongs to exactly one group and each generated operation is claimed
exactly once. Nested paths are owned by the specific feature, not the broad one — poll votes belong to Polls even
though they sit under `/chat/messages/...`, and draft operations belong to Threads & Drafts even though they sit
under `/chat/channels/...`.

Re-run it after a regeneration adds or renames operations, and treat a reported problem as a plan bug rather
than a script bug.

**The group files are generated in full, prose included.** Goal, decisions, risks and the definition
of done live in the `GROUPS` list inside `generate_plan.py`, not in the markdown — editing a `0N-*.md`
file directly works until the next person regenerates, then it is silently lost. Record a group's decisions
in the generator and re-run it.
