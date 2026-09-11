# Migrating `stream_chat` to the OpenAPI-generated client

The plan for moving the low-level client off its hand-written HTTP layer and onto the OpenAPI-generated client in
`packages/stream_chat/lib/open_api/`.

One file per feature group, in the order they should land. Each carries a goal, the exact hand-written methods and
generated operations in scope, the decisions that group has to make, its risks, and a definition of done.

| | Group | Hand-written | Generated ops | Status |
| --- | --- | --- | --- | --- |
| [01](01-foundation.md) | Foundation — `Result`, errors, wiring | — | — | ☐ |
| [02](02-devices-and-push-preferences.md) | Devices & Push Preferences | 4 | 4 | ☐ |
| [03](03-user-groups.md) | User Groups | 8 | 8 | ☐ |
| [04](04-roles-guest-and-app.md) | Roles, Guest & App Settings | 4 | 5 | ☐ |
| [05](05-polls.md) | Polls | 13 | 13 | ☐ |
| [06](06-reminders.md) | Message Reminders | 4 | 4 | ☐ |
| [07](07-threads-and-drafts.md) | Threads & Drafts | 7 | 7 | ☐ |
| [08](08-moderation-and-blocklists.md) | Moderation & Blocklists | 11 | 34 | ☐ |
| [09](09-users.md) | Users | 9 | 9 | ☐ |
| [10](10-messages.md) | Messages & Search | 14 | 12 | ☐ |
| [11](11-channels-and-members.md) | Channels, Members & Sync | 27 | 24 | ☐ |
| [12](12-uploads-cdn.md) | Uploads (CDN) | 8 | 8 | ☐ |

**Coverage:** 109 hand-written methods across 13 files, and all 128 generated operations, each claimed by exactly
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
- **Rewriting our public models wholesale.** Generated types are wire shapes; ours are often the better public
  API. The default is to keep ours and map at the boundary.
- **Regenerating the client.** That is `openapi-codegen`, and it lands as its own PR.

## Principles

- **One feature group per PR.** A group is a set of endpoints a caller thinks of together, and it moves across
  completely — half-migrated features are worse than unmigrated ones.
- **Default to keeping our shape.** Break only when it buys long-term maintainability (the alternative is
  maintaining two shapes forever) or consistency with our other products. Not for cosmetics.
- **Every break ships four artifacts**: `refactor(llc)!:` title, `🛑️ Breaking` CHANGELOG entry, a Symbol Map row
  plus feature section in `migrations/v11-migration.md`, and the reason in the PR body.
- **Decide once, at the right level.** Cross-cutting shapes — `User`, errors, `Result` — are decided in
  [01-foundation](01-foundation.md), not re-argued per group.

## Order, and why

**[01-foundation](01-foundation.md) first, and it blocks everything.** After it, groups 02–07 can run in parallel;
08–12 are best run in sequence because they share models.

The order runs from smallest and most isolated to largest and most entangled, so the pattern is proven on cheap
surfaces before it reaches `Message` and `ChannelState`:

- **02–04** have no persistence and almost no public model surface. Group 02 is the pattern-proving slice.
- **05–07** introduce persisted models and WebSocket-delivered updates, one at a time.
- **08** is where we decide what *not* to expose: 34 generated operations against 11 hand-written methods.
- **09** freezes the `User` mapping that everything else already depends on (the *decision* is made in 01; this
  group executes it).
- **10–11** are the core of the SDK, and carry the `custom` / `extraData` promotion problem.
- **12** is last because it needs its own hand-written multipart client and is the highest-traffic path in the SDK.

## Prerequisites

- **A `stream_core` release.** `stream_chat` cannot be published while `stream_core` is a git dependency, and the
  generated client needs `StreamDateTimeConverter`, which is not in the last published version.
- **The generated client committed and building** — it is, in `lib/open_api/`.

## How to execute a group

Use the **`openapi-migration`** skill: it is the per-group process (scope → decide shapes → sequence → implement →
tests → verify). Use **`openapi-codegen`** when a type or operation is missing, or the generated code is wrong.

Consumer-facing changes go in `migrations/v11-migration.md` in the same PR that makes them.

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
than a script bug. Prose sections are hand-written and survive regeneration.
