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

- **`openapi-migration/`** — the plan. Its `README.md` has the group order and status, and the
  [domain-model rules](../../../openapi-migration/README.md#domain-models) every group follows, including the only
  list of breaks a migration may make. Each numbered file is one feature group with its scope tables (hand-written
  methods ↔ generated operations), decisions, risks and definition of done. **Start from your group's file**
  rather than re-deriving the inventory — phase 1 below is largely done there already.
- **`migrations/v11-migration.md`** — the consumer upgrade guide, written *as* features land rather than
  reconstructed at release. Read its Symbol Map and Error Handling sections before designing a change: they define
  the shape consumers have already been promised.

**`STYLE_GUIDE.md`** (§ Documentation, § Testing), **`EFFECTIVE_DART_DOC.md`** and **`TESTING.md`** are the
repo's conventions, and a migration follows them like any other change. `EFFECTIVE_DART_DOC.md` is Effective
Dart's documentation guide vendored into the repo; the style guide wins where the two disagree, and the guides
win over this skill. Phases 4 and 5 name the rules migrations keep breaking; that is a shortlist, not a substitute
for the guides.

**The code already migrated shows the layout.** Devices (group 02), user groups (03) and every part of group 04
but the guest user are done; copy the file structure of their repositories, mappers and envelopes (paths in
[Where each piece lives](#where-each-piece-lives)). Check docs and tests against the guides rather than copying
them from these files: precedent is what drifts.

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
   feature returns, against their generated counterparts. Note each operation's generated response type: one
   answering the shared `DurationResponse` becomes `Result<void>` (phase 2).
3. **Call sites** — everything above the api layer: `StreamChatClient`, `Channel`, and whether the response lands
   in client state or in `stream_chat_persistence`.
4. **Public exports** — which of those types `lib/stream_chat.dart` exports, since that is what makes a change
   breaking.
5. **Tests** — `test/src/core/api/<feature>_api_test.dart`, the feature's cases in
   `test/src/client/client_test.dart`, and its round-trips in `test/src/core/api/responses_test.dart`.

Close the phase with three checks. Any of them can take an endpoint off the table.

**1. Blocking mismatch.** If the generated payload omits a field our current request sends, that endpoint stays
hand-written and the inventory says why. Migrating it would silently drop behaviour — but check the newest spec
before concluding it is permanent; see the ladder below.
Check the other direction too: a field a v10 model or envelope exposes that the generated response lacks can no
longer be filled, so raise it with the user before deciding the shape.

**2. Is the generated operation even the same endpoint?** A matching name is not proof. Our hand-written client
calls `baseUrl` + a bare path, which is the **chat v1** surface; a generated operation under `/api/v2/<product>/`
may belong to a *different product* with its own handler. Moderation is the live example: `muteUser` called the
chat v1 route that `lib/chat/routes.go` mounts at the root and comments as deprecated, while the generated `mute`
is `/api/v2/moderation/mute` in `lib/moderation/routes.go`. The paths look like a rename; the services are not.

Compare the two handlers in the backend checkout and answer one question — does the generated one write the same
state and emit the same WS events the SDK already depends on?

```bash
# the route tables, to see which product owns each path
grep -n '/mute' "$CHAT_BACKEND_DIR"/lib/chat/routes.go "$CHAT_BACKEND_DIR"/lib/<product>/routes.go
# then read both controllers side by side
```

Equivalent handlers make the switch safe. Divergent ones mean the endpoint stays hand-written, with the reason
recorded.

**3. Is it gated or in beta?** A generated operation can be fully present and still refused at runtime. Check the
controller for `FeatureFlagEnabled` and `Beta: true`:

```bash
grep -n "FeatureFlagEnabled\|Beta:" "$CHAT_BACKEND_DIR"/lib/<product>/controller/<op>.go
```

`monolith/server/base.go` rejects a gated endpoint with `NotAllowedError("this endpoint needs a feature flag…")`,
so migrating onto one changes who can call it. Read the flag's default before judging — moderation v2's
`ModerationV2Enabled()` returns true when unset, so only apps that explicitly opted out are affected. Either way it
is a behavioural break for the CHANGELOG and the migration guide, not a silent detail.

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
   `multipart/form-data`, but the generated `uploadFile` / `uploadChannelFile` take a JSON `@Body()` with no
   progress or cancellation. Group 12 hand-wrote them as `lib/src/cdn/cdn_api.dart`, mirroring the generated
   operations over their *response* models; a new multipart endpoint belongs there, not on `DefaultApi`. Open a
   generator fix upstream too — see the `openapi-codegen` skill.
   Don't contort the call site around a broken signature.
3. **In a newer spec than the one our tree was generated from.** Regenerate — its own PR, never folded into a
   feature slice. Also `openapi-codegen`.

   **Check this before declaring anything blocked**, including a phase-1 blocking mismatch. The committed tree can
   be many spec versions behind, and both kinds of gap close the same way. Compare against the newest released
   spec, not against another SDK's generated output — a sibling's tree is just as likely to be stale:

   ```bash
   python3 -c "import json,sys; s=json.load(open(sys.argv[1])); print(s['info']['version']); \
     print('\n'.join(p for p in s['paths'] if 'unban' in p))" \
     "$PROTOCOL_DIR"/openapi/v2/chat-clientside-api.json
   head -5 packages/stream_chat/lib/open_api/api.dart   # what our tree was generated from
   ```

   Group 08 hit both at once: `unban` was absent, and `QueryBannedUsersPayload` dropped four `created_at_*` cursors
   the server reads off an embedded pager. Both looked permanent against the committed tree; regenerating from
   `v237.2.0` to `v239.10.0` fixed both, and turned a two-method-blocked group into one.
4. **Absent from the clientside spec entirely.** It is server-side only, deprecated (spec generation skips
   deprecated operations), or not yet exposed on v2. Confirm against the spec before concluding:

   ```bash
   python3 -c "import json,sys; s=json.load(open(sys.argv[1])); \
     print('\n'.join(p for p in s['paths'] if 'device' in p))" \
     /path/to/protocol/openapi/v2/chat-clientside-api.json
   ```

   The spec lives in a checkout of the protocol repo; the `openapi-codegen` skill's `PROTOCOL_DIR` points at it.
   Then leave the endpoint hand-written, record it in the inventory with the reason, and raise it with the backend
   team so the spec grows. Never invent a generated model to fill the hole.

**Never hand-edit anything under `lib/open_api/`.** Regeneration deletes the directory, so an edit there is lost
silently — which is exactly why fixes belong in the generator or in your own code.

## Phase 2 — decide the shape of each symbol

The generated models stay private: the public API keeps our models, and a repository maps the generated types onto
them. The rules are the [domain-model rules](../../../openapi-migration/README.md#domain-models) in the plan's
README, and **its list of breaks is the only one**: a migration makes those breaks against v10 and no others.
Anything else it would change about what the caller holds needs its own reason and the user's approval.

Generated types are wire shapes — nullable wherever the spec is loose, with per-operation extension types instead
of shared enums (`CreateDeviceRequestPushProvider` rather than one `PushProvider`) — which is why they never reach
a public signature.

**Per type, decide:**

- **Which v10 type it maps to, and under what name.** The spec's name is the default, unless it is awkward or
  describes something else, and sibling calls share one scheme: `UpdateChannelPartialResponse` and
  `UpdateMemberPartialResponse` replaced v10's `PartialUpdateChannelResponse` and `PartialUpdateMemberResponse`,
  and `updateMemberPartial` replaced `partialMemberUpdate`. v10's name stays where the generated one does not fit
  (`OGAttachmentResponse` for `GetOGResponse`, `AppSettings` for `AppResponseFields`), and names an earlier group
  settled stand. Renaming a v10 type or method is a break: list it with the reason, wait for approval, and call it
  out in the PR description.
- **Which fields it exposes.** v10's fields, with v10's defaults. A field only the generated type has
  (`AppResponseFields.id`, the twelve extra fields on `GetOGResponse`) stays out; exposing it later is additive. A
  field the spec marks optional is nullable by default, even if v10 typed it non-null; keeping it non-null needs a
  recorded reason and a mapper fallback, as `OGAttachmentResponse.ogScrapeUrl` has in group 04.
- **Whether it is embedded in a model that still decodes v1 JSON** with json_serializable. If it is, the parent's
  field needs a temporary converter (README rule 7) — add it to the adapters table with the group that removes it.
- **Whether persistence stores it as JSON text,** alone, as the elements of a list column, or nested inside
  another persisted model. Search `stream_chat_persistence/lib/src/{mapper,converter,dao}` for `jsonEncode`,
  `fromJson`, `toJson` and `toData`, and trace each hit to the type it encodes: a search on the type's name misses
  `options.map(jsonEncode)`, which is how `polls.options` stores `PollOption`. If it is stored as JSON text, the
  model gets the temporary `@DataSerializable` codec (rule 8; see
  [Persisted models](#persisted-models-the-dataserializable-codec)). A model stored only as a table row, mapped
  column by column like `Poll` in `polls`, needs no codec.
- **Which request enums need a hand-written public type** (rule 6).

**Per method, decide what it returns:**

| Generated response | Public return | Example |
| --- | --- | --- |
| `DurationResponse` | `Result<void>`, through `result.ignoreValue()` | `deleteUserGroup` |
| any other `*Response`, read or write | `Result<Envelope>` | `getUserGroup` → `Result<GetUserGroupResponse>` |

The second row holds even where v10 returned the bare payload (`StreamChatClient.getAppSettings` returned
`AppSettings`, now `AppSettingsResponse`), `EmptyResponse` (`hideChannel` → `HideChannelResponse`) or a bare
model, and even when the response carries only `duration` today. Only `DurationResponse` can never gain a field;
README § Domain models gives the reason. When v10 had no envelope to keep, propose the new envelope's name and
wait for approval.

**Establish a claim before you rely on it, and know which source answers which question.**

- **What the API actually does** — the backend is the authority, and the only external source this skill reaches
  for. Route tables, request payload structs and controller code answer units, validation, deprecation and
  gating. Verify there rather than inferring from a field name or from the spec's prose.
- **What our public API should look like** — the backend cannot answer this, and neither can this skill. When the
  shape is a genuine judgement call — whether a convenience method earns its place, whether to expose a generated
  type, whether a break is worth it — **put the options to the user with the trade-offs and let them decide**.
  Do not settle it by copying another Stream SDK: their constraints differ, their trees go stale, and a claim
  about one is not verifiable from this repo.

Whatever is decided goes in the PR body, never in a doc comment — see `STYLE_GUIDE.md`
§ *No server or transport details in docs or comments*.

### Where each piece lives

```text
packages/stream_chat/lib/src/
├── core/models/<model>.dart                  plain model, one class per file, file named after the class
├── core/models/response/<name>_response.dart envelope — every class suffixed Response
├── core/models/request/<name>.dart           public request type or request parameter
└── repository/
    ├── <feature>_repository.dart             one per feature; GeneralRepository for endpoints with no feature
    └── mapper/
        ├── <feature>_mapper.dart             every mapper the feature needs, in one file
        └── result_mapper.dart                ignoreValue(), for Result<void>
```

- **The role decides the folder.** An envelope goes in `response/` (`CreateUserGroupResponse`). A type the caller
  passes in to shape a request goes in `request/`, whatever its name: `MessageDelivery`, `UpdateUserPartialRequest`,
  and also `PaginationParams` and `ThreadOptions` when their groups migrate them. Every other model stays in
  `models/` (`UserGroup`). Copy `lib/src/core/models/request/message_delivery.dart`.
- **Models and envelopes** are `@freezed` classes with a const constructor and `@override final` fields. Copy
  `lib/src/core/models/user_group.dart` and `lib/src/core/models/response/create_user_group_response.dart`.
  Envelopes carry `required this.duration`, documented with an example value such as `4.21ms`, plus one field per
  payload, nullable when the spec doesn't guarantee it (`final UserGroup? userGroup`).
- **The barrel** (`lib/stream_chat.dart`) exports the models and envelopes. It never exports a repository, a
  mapper or anything under `open_api/`.
- **A repository** is `const <Feature>Repository(this._api)` over a `final api.DefaultApi _api`, one method per
  operation. `StreamChatClient` builds it from the shared `api` beside the others (`_userGroupsRepository =
  UserGroupsRepository(api)`) and delegates each public method to it. Copy
  `lib/src/repository/user_groups_repository.dart`.
- **A mapper** is an extension named after the type it extends, one per direction: `extension
  <Generated>Mapper on api.<Generated>` with `toModel()` from generated to ours, and `extension <Ours>Mapper on
  <Ours>` with `toRequest()` from ours to a generated request (`PushProviderMapper on PushProvider` in
  `devices_mapper.dart`). A nested type gets its own extension that the parents call (`FileUploadConfigMapper`
  serves both upload configs of `AppSettings`). Copy `lib/src/repository/mapper/user_groups_mapper.dart`.
- **One generated response can feed several v10 envelopes.** `PollResponse` answers `createPoll`, `getPoll`,
  `updatePoll` and `updatePollPartial`, where v10 has `CreatePollResponse`, `GetPollResponse` and
  `UpdatePollResponse`, so a single `toModel()` cannot serve them. `PollOptionResponse` (create, get and update
  an option) and `PollVoteResponse` (cast and remove a vote) have the same shape. The v10 envelopes stay; how the
  mapper names its conversions is still open, and is decided with the user when group 05 is migrated.

### The error contract

It is decided in [`core-migration/03-errors.md`](../../../core-migration/03-errors.md): a migrated method returns
`Future<Result<T>>` and never throws, and `Failure.error` is always a `StreamException` (`StreamApiException`,
`StreamNetworkException`, `StreamAuthenticationException` or `StreamClientException`). `ApiErrorInterceptor` on
the client's Dio shapes HTTP errors, and the generated call adapter's `runApiSafely` wraps anything else —
including a `TypeError` from a body that would not decode — in a `StreamClientException` with the original as its
`cause`. So a migrated method has no error handling of its own: don't translate to `StreamChatNetworkError`, and
check `StreamErrorCode` for a constant before adding an error code here.

## Phase 3 — sequence the work

Inside the feature: internal request bodies first (no public surface, no persistence), then public request
types and responses, then models.

The wiring every feature needs is already in place; add to it, don't rebuild it:

- `StreamChatClient` builds one `DefaultApi` from its Dio, which carries `ApiErrorInterceptor`, and passes it to
  every repository. Tests replace it through the `@internal` `defaultApi:` constructor parameter.
- `lib/stream_chat.dart` re-exports `Result`, `Success`, `Failure` and the `StreamException` family from
  `stream_core` with a `show` allowlist. Add a type to that list when you need one; never export `stream_core`
  wholesale, because it re-exports all of dio plus an `AttachmentFile` that collides with ours.

`EmptyResponse` has ~250 references and is shared by every feature, so it is retired last, after the features are.
Moving the WebSocket to v2 is its own project — v2 sends different event shapes; never fold it into a feature PR.

## Phase 4 — implement

```dart
import 'package:stream_core/stream_core.dart' show PatternMatching, Result;

import '../../open_api/api.dart' as api; // the generated names collide with ours
import '../core/models/response/get_user_group_response.dart';
import 'mapper/result_mapper.dart';
import 'mapper/user_groups_mapper.dart';

class UserGroupsRepository {
  const UserGroupsRepository(this._api);

  final api.DefaultApi _api;

  Future<Result<GetUserGroupResponse>> getUserGroup(String id, {String? teamId}) async {
    final result = await _api.getUserGroup(id: id, teamId: teamId); // Result<api.GetUserGroupResponse>
    return result.map((response) => response.toModel()); // maps Success, passes Failure through untouched
  }

  Future<Result<void>> deleteUserGroup(String id, {String? teamId}) async {
    final result = await _api.deleteUserGroup(id: id, teamId: teamId); // Result<api.DurationResponse>
    return result.ignoreValue();
  }
}
```

`Result.map` is the whole pattern: the error side needs no code. Reach for `fold` only when a method genuinely has
to inspect the failure. `Result.success(value)` and `Result.failure(error, [stackTrace])` are the public factories
for building a `Result` directly — `Success` and `Failure` have private constructors. `Result.fold` is
`({required R Function(T) onSuccess, required R Function(Object, StackTrace?) onFailure})`; `getOrThrow`,
`getOrElse`, `map` and `flatMap` also exist (`stream_core`, `lib/src/utils/result.dart`).

**Don't unwrap inside the SDK.** `getOrThrow()` turns the `Result` back into a thrown `StreamException`, which is
the contract this migration removes. Return the `Result` to the caller; SDK code that consumes one, such as the
composer calling `enrichUrl`, branches on it instead. `getOrThrow()` is a tool for *consumers* migrating
incrementally, not for us.

Three data-shape traps while mapping:

- **`custom` vs `extraData`** (channel / message / user features). The wire puts extra fields in `custom`;
  hand-written models flatten them into `extraData`. Write that promotion explicitly, including which keys are
  excluded.
- **Units on anything that takes a `Duration`.** The wire carries a bare integer and the field name rarely says
  in what. Read the Go payload type: `commonpayloads.DurationInMinutes` and `DurationMilliseconds` sit on sibling
  endpoints in the same feature — `ban.timeout` and `mute.timeout` are minutes, `muteChannel.expiration` is
  milliseconds. Getting it wrong is silent, and `Duration.inMinutes` truncates, so a sub-minute value arrives as
  `0` — which `DurationInMinutes.ToTime()` reads as *no expiry*, turning a short ban permanent. Test that edge,
  not just the round number.
- **`DateTime` on anything that also arrives over the WebSocket.** Generated models decode through
  `StreamDateTimeConverter` (epoch nanoseconds *or* RFC3339); hand-written models use `DateTime.parse`. A model fed
  by both REST v2 and WS events must tolerate both.

Many generated types shadow ours by name, which is why repositories and mappers import the generated code with a
prefix. The prefix is permanent: the generated types are never exported. List the current overlaps with (it prints
file names, so `channel_mute` means the generated `ChannelMute` shadows ours; envelopes such as
`list_devices_response` share their generated counterpart's name on purpose):

```bash
comm -12 \
  <(ls packages/stream_chat/lib/open_api/model/ | grep -v '\.\(g\|freezed\)\.dart$' | sed 's/\.dart$//' | sort) \
  <(grep -oE "^export 'src/core/(models|api)/[a-z_/]+\.dart';" packages/stream_chat/lib/stream_chat.dart \
    | sed "s|.*/\([a-z_]*\)\.dart';|\1|" | sort)
```

### Persisted models: the `@DataSerializable` codec

`DataSerializable` (`packages/stream_chat/lib/src/db/data_serializable.dart`) is a typedef for `JsonSerializable`,
so json_serializable generates the storage codec and the model exposes it as `fromData`/`toData`. It is the only
class-level json_serializable annotation a public model may carry — field-level `@JsonKey` pairs are expected,
see below — and it is temporary: group 10 decides what replaces it.

**Use it** when `stream_chat_persistence` stores a plain model in a JSON text column, as the elements of a list
column (`polls.options` holds one JSON string per `PollOption`), or nested inside another plain model that is.
Today that covers `messages.mentioned_groups` (`UserGroup`). The group that makes a stored model plain adds its
codec: `PollOption` in `polls.options` (05); `User` in the `mentioned_users` columns of `messages`,
`pinned_messages` and `draft_messages`, and `OwnUser` in `connection_events.own_user` (09). `Attachment` and the
reaction groups (`attachments`, `reaction_groups`) become plain in group 10 itself, and `channels.config` (11)
lands after it, so those use whatever group 10 puts in the codec's place. `channel_queries_metadata.filter` and
`.sort` store `ChannelFilter` and `ChannelSort`, which are query objects rather than models, so they need no codec.

A plain model nested in a parent that is **still json_serializable** needs no codec: the parent's rule-7 converter
already writes it, in both directions if the parent is stored. `Device` inside `OwnUser` is stored this way,
through `DeviceV1JsonConverter`.

**Don't use it** for:

- envelopes, which are never persisted;
- a model persistence stores as a table row;
- decoding the wire, which goes through the repository mappers or a rule-7 converter.

**Where it doesn't fit:**

- **freezed unions** (`MessageState`, `UploadState`, `MessageDeleteScope`). freezed only generates union JSON from
  a factory named `fromJson`, so a union whose factory is renamed to `fromData` gets no JSON at all. These
  local-only unions keep their freezed `fromJson`/`toJson` until the user decides how to handle them. This comes
  from freezed's documented behaviour and hasn't been tried in this repo, so test it before relying on it.
- **Deeply nested models get expensive.** json_serializable hardcodes the names `fromJson`/`toJson` for nested
  types (`json_serializable/lib/src/type_helpers/json_helper.dart`), so every field holding a plain model needs a
  hand-written `@JsonKey(fromJson: ..., toJson: ...)` pair, and every nested model needs its own annotation. The
  cost grows with the depth of the graph. `OwnUser` is the worst case: `Device`, `Mute` (two `User`s),
  `ChannelMute` (a `User` and a full `ChannelModel`), `PushPreference` and `PrivacySettings`. Before annotating a
  graph like that, raise the alternative of storing less with the user: rows in existing tables plus ids.

The pattern, from `lib/src/core/models/user_group.dart`:

```dart
@freezed
// TODO(openapi-migration): remove in group 10
@DataSerializable(includeIfNull: false)
class UserGroup with _$UserGroup {
  const UserGroup({...});

  /// Creates a [UserGroup] from the offline-database format written by [toData].
  ///
  /// It is not a codec for API payloads.
  factory UserGroup.fromData(Map<String, dynamic> json) => _$UserGroupFromJson(json);

  @override
  @JsonKey(fromJson: _membersFromData, toJson: _membersToData)
  final List<UserGroupMember>? members;

  /// Serializes this group to the format `stream_chat_persistence` stores.
  ///
  /// It is not a codec for API payloads.
  Map<String, dynamic> toData() => _$UserGroupToJson(this);
}

List<UserGroupMember>? _membersFromData(List<dynamic>? data) =>
    data?.map((it) => UserGroupMember.fromData(it as Map<String, dynamic>)).toList();

List<Map<String, dynamic>>? _membersToData(List<UserGroupMember>? members) =>
    members?.map((it) => it.toData()).toList();
```

- **Tag every use** on the model in `stream_chat` with `// TODO(openapi-migration): remove in group 10`, and add
  the models to the adapters table. Group 10 replaces every use and deletes the typedef, so no group after it adds
  one. The typedef carries the same tag, so `generate_plan.py --check` (which scans `packages/stream_chat/lib`)
  fails while it outlives group 10, and deleting it breaks every remaining use at compile time.
- **A field holding another plain model needs a `@JsonKey(fromJson: ..., toJson: ...)` pair** calling the nested
  model's `fromData`/`toData`, as `members` does above. Both models carry `@DataSerializable`: the parent for its
  own codec, the nested model for the one the pair calls. Without the pair the generated code calls a
  `fromJson`/`toJson` that doesn't exist and fails to compile.
- **`stream_chat`'s `build.yaml` already sets `field_rename: snake` and `explicit_to_json: true`,** and
  `includeIfNull: false` leaves out null keys. Extension-type fields such as `PushLevel` pass through as their
  representation, and `DateTime` is stored as an ISO-8601 string.
- **Decide whether the stored format changes.** The generated codec stores `extraData` nested under `extra_data`,
  where v10 flattened custom fields into the root. If the bytes differ from what the column holds today, bump
  `schemaVersion` in `drift_chat_database.dart` in the same PR; the upgrade is destructive, so the cache is simply
  rebuilt. If they are identical, prove it with a test against the old format and leave the version alone.
- **A model that already has storage methods** (`Attachment.fromData`/`toData`) switches them to the generated
  functions rather than adding a second pair.
- **In persistence,** replace the model's `fromJson`/`toJson` calls, including an implicit `jsonEncode(model)`,
  with `fromData`/`toData`.
- **Generate with a full `dart run build_runner build`** in `packages/stream_chat`, then `dart format`. Commit the
  `.g.dart` and `.freezed.dart` files of the models you changed; `--build-filter` deletes every generated output
  outside the filter, so never use it.

### Documenting the public surface

Write these as you write the code. `public_member_api_docs` only checks a doc *exists*, so a placeholder survives
`melos run analyze`. `EFFECTIVE_DART_DOC.md` covers dartdoc form (single-sentence first paragraph, "Whether…"
for booleans, noun phrases for properties, square brackets for in-scope identifiers) and `STYLE_GUIDE.md`
§ Documentation the repo's rules on top. Three things migrations get wrong beyond both:

- **Scope is the surface the group touches**, not just the new repository. The `StreamChatClient` delegates
  duplicate its docs verbatim, so a fix belongs in both.
- **Retyping a field leaves its doc describing the old type**, and that line is not in the diff. Re-read the docs
  on everything you retyped, including fields that only gained a converter.
- **Describe behaviour, and every non-obvious parameter** — a bare `nameGt` cursor tells a reader nothing. Why a
  shape was adopted belongs in the plan file and the PR body, not in a doc comment.

Stop at docs the migration neither touched nor invalidated; one feature group per PR applies to docs too.

## Phase 5 — rewrite the tests

Budget for this: on a typical feature it is most of the diff, and none of it is mechanical.

- `test/src/core/api/<feature>_api_test.dart` asserts on `client.post('/polls', data: …)` against a
  `MockHttpClient`. Routing through `DefaultApi` moves the mock seam to `MockDefaultApi` (`test/src/mocks.dart`),
  passed to `StreamChatClient` through `defaultApi:`. Test every behaviour through the public client; don't add
  repository or mapper tests. The old assertions cannot survive.
- `test/src/client/client_test.dart` builds fixtures in the `late`-mutable style the hand-written DTOs allow
  (`CreatePollResponse()..poll = …`). Stubs of `DefaultApi` now answer generated types, and the envelopes are
  const-constructed `@freezed` classes, so those fixtures must be rewritten.
- `test/src/core/api/responses_test.dart` round-trips the DTO from JSON — delete those cases with the DTO's JSON.
- **Stub each generated response with every field our model carries,** each with a distinct value, and compare
  the whole returned envelope, so a field the mapper drops or swaps fails an assertion. Give every method a
  failure test too.
- **Test each temporary converter through its parent's `fromJson`/`toJson`.**
- **Test each `@DataSerializable` model's stored format:** pin `toData()` to a literal map, so a rename that changes
  the stored keys fails; round-trip `fromData(toData())`; cover null versus empty for nullable lists. Extend the
  existing persistence mapper and DAO tests with the field rather than writing tests scoped to it.

Rewrite onto `TESTING.md` rather than carrying the old file's habits across. What breaks most often:

- **No `group` organizing a file by method.** `group('addDevice')`, `group('getDevices')` is the shape a migrated
  test falls into, and `TESTING.md` names it an anti-pattern. A `group` states a shared precondition;
  anything else belongs in a separate file.
- **Each name states subject and behaviour**, so `dart test` output says what broke:
  `StreamChatClient.searchRoles sends only the query when nothing else is given`.
- **No two tests share a name**, which dropping the groups is what exposes — three identical
  `returns the failure without throwing`.
- **One behaviour per test.**

## Phase 6 — verify and land

`melos run analyze`, `melos run test:dart`, plus `stream_chat_persistence`'s tests if the feature's responses feed
persistence, and `python3 openapi-migration/tool/generate_plan.py --check`.

**`melos run analyze` does not cover the generated client's own output.** `analysis_options.yaml` excludes
`**/*.g.dart` and `**/*.freezed.dart` repo-wide, so the retrofit `default_api.g.dart` and the generated models'
`.freezed.dart` files are never analyzed. Exercising the code in a test is what actually compiles it.

**Neither does it cover the guides.** `--fatal-infos` checks a public member *has* a doc, never what it says or
how a test is named. Re-read the diff against `STYLE_GUIDE.md` § Documentation, `EFFECTIVE_DART_DOC.md` and
`TESTING.md` before opening the PR — that read is what the last two definition-of-done boxes stand for.

**Every break ships four artifacts in the same PR:** the `refactor(<scope>)!:` title (usually `llc`), a
`🛑️ Breaking` CHANGELOG entry naming the old and new symbol, the three edits `migrations/v11-migration.md` asks
for in its closing section (Symbol Map rows, a Quick Reference row for a new feature area, a feature section), and
the reason in the PR body. A
break with no guide entry is unfinished — the guide is what consumers actually upgrade against, and it cannot be
reconstructed later.

The PR body carries the group's scope, a table mapping each generated name to the public one (including the
repository and any type that kept its v10 name), the phase 2 decisions with their reasons, and any endpoint left
hand-written and why.

**Write the group's record into `openapi-migration/tool/generate_plan.py`, not into the `0N-*.md` file.** Those
files are generated in full — goal, decisions, risks and definition of done all come from the `GROUPS` list in the
generator. Editing the markdown works until the next regeneration silently reverts it. Add a `taken=textwrap.dedent(...)`
block and a `done=DONE.replace('- [ ]', '- [x]')` to the group's entry, then re-run the script. Then tick the
group's status box in `openapi-migration/README.md`, so the next person sees where the migration actually stands.

**When a method cannot move, split it into its own group rather than leaving one partly done.** Phase 1's three
checks exist to find those, and the first definition-of-done box allows an endpoint to be "deliberately left
hand-written, with the reason" — but a group sitting at nine-of-ten is a status nobody can act on, and the reason
decays into a footnote. Give the remainder a group of its own, with its own blocker, decisions and definition of
done:

- add it to `GROUPS` in `generate_plan.py` claiming the method explicitly (`'moderation_api.dart::queryBannedUsers'`)
  and owning its generated path; the parent group's file-level claim covers the remainder automatically;
- number it at the end and say in `README.md` what it was split from and what it waits on — plan order is
  dependency order, not file order;
- say in `migrations/v11-migration.md` that it still throws. Two groups where one returns `Result` and the other
  does not is a mixed error contract, and consumers must not discover it by catching;
- leave its `*_api.dart` in place with only that method, and its `StreamChatApi` getter. Reviewers look for the
  deleted file — the new group's file is what explains why it survived.

Both groups then read as true: one done, one not started. Group 08 (moderation) and 14 (banned users) are the
worked example.

What is *not* acceptable is splitting a **pair**. `banUser` migrating while `unbanUser` stays hand-written leaves
consumers writing one call each way, which the plan's README rightly calls worse than not migrating. If half a
pair is blocked, either unblock it (usually a regeneration) or hold both. Split on what the *caller* thinks of
separately — a read versus a set of writes — never on what happens to be easy.

## Layout reference

```
packages/stream_chat/lib/open_api/
├── api.dart               # barrel
├── models.dart            # barrel (also re-exports StreamApiError, StreamDateTimeConverter, WsEvent)
├── api/default_api.dart   # ONE retrofit interface — every operation lives here
└── model/                 # every model the spec defines
```

Don't reach for the generator to get a type — that tree holds every model and operation the spec defines. The repo
lints `prefer_relative_imports`, which is what makes the generator's `import '../models.dart'` style compliant.
