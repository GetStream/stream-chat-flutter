# 01 — Foundation

> **The error layer and the `Result` surface are now owned by
> [`core-migration/03-errors.md`](../core-migration/03-errors.md)**, which covers them as part of adopting
> `stream_core` wholesale. Track that phase rather than re-deriving the work here. This group covers the
> `DefaultApi` wiring and the `User` shape decision.

**Goal:** land everything that every feature group depends on, so no group has to invent it. Nothing user-visible
migrates in this phase.

Feature groups can run in parallel once this is done. Until it is, they will each reinvent the same two things
differently.

## Scope

### 1. Where `DefaultApi` is constructed

`DefaultApi(Dio)` needs a Dio. `StreamHttpClient.httpClient` is `@visibleForTesting` and `StreamHttpClient` is
publicly exported, so `DefaultApi(client.httpClient)` fails `melos run analyze` with
`invalid_use_of_visible_for_testing_member`. Pick one and apply it everywhere:

- an `@internal` accessor on `StreamHttpClient`, or
- build `DefaultApi` once in `StreamChatApi` and inject it into each `*_api.dart`.

### 2. Freeze the `User` shape decision

`User` and `OwnUser` are embedded in nearly every response in the SDK, so the keep-vs-adopt decision cannot wait
for group 09 — a poll vote, a channel member and a message all carry a user. Decide it here, write it down, and
let group 09 merely execute it.

The same applies, in a smaller way, to the channel shape embedded in threads (group 07) versus the channels group
(group 11).

**Decide `name` and `image` with it.** Both arrive as root fields on the wire and are pushed into `extraData` by
`Serializer.moveToExtraDataFromRoot`; `User.name` is a getter over `extraData['name']` that falls back to `id`,
and the constructor writes the arguments back into `extraData` "for backwards compatibility". Promoting them to
real fields is a break worth making in v11 if it is made at all, and it belongs to this decision rather than to
whichever group happens to touch `User` first. Raised on
[#2957](https://github.com/GetStream/stream-chat-flutter/pull/2957).

## Prerequisites

- **The generator's `client.tpl` calls `runApiSafely`, not `runSafely`.** Until it does, a regenerated client
  hands back raw `DioException`s instead of the sealed `StreamException` family that
  [`core-migration/03-errors.md`](../core-migration/03-errors.md) lands — see the `openapi-codegen` skill.

## Decisions to make

- Whether the `DefaultApi` wiring and the `User` shape decision land as one PR or two. The wiring is small and
  internal; the `User` decision is the one every later group reads.

## Risks

- The `User` shape is frozen here but executed in [09](09-users.md), and every group in between assumes it.
  Reversing it late means re-touching every group that has already landed.

## Definition of done

- [ ] `DefaultApi` construction is settled in one place, with no `invalid_use_of_visible_for_testing_member`.
- [ ] The `User` / `OwnUser` decision is written into `09-users.md`.
- [ ] `melos run analyze` clean, `melos run test:dart` green.
