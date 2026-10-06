#!/usr/bin/env python3
"""Regenerates the scope tables in openapi-migration/*.md from the SDK itself.

    python3 openapi-migration/tool/generate_plan.py            # regenerate + report
    python3 openapi-migration/tool/generate_plan.py --check     # report only, non-zero on a gap

Run from the repo root. Prose sections (goal, decisions, risks) live in GROUPS
below; the tables are always derived from the code, so they cannot drift.

The report asserts these invariants:
  * every public method in the hand-written api layer belongs to exactly one group
  * every operation in the generated client is claimed by exactly one group
  * the stream_chat barrel exports nothing from the generated client
  * no other package or the sample app imports the generated client
  * no temporary adapter outlives the group that removes it

A non-zero unclaimed count after a regeneration means the plan needs a new group
or a wider path prefix — treat it as a plan bug, not a script bug.
"""

import pathlib
import re
import sys
import textwrap

PKG = pathlib.Path('packages/stream_chat')
API_DIR = PKG / 'lib/src/core/api'
GENERATED_API = PKG / 'lib/open_api/api/default_api.dart'
OUT = pathlib.Path('openapi-migration')
BARREL = PKG / 'lib/stream_chat.dart'
CONSUMERS = [
    pathlib.Path('packages/stream_chat_flutter_core/lib'),
    pathlib.Path('packages/stream_chat_flutter/lib'),
    pathlib.Path('packages/stream_chat_persistence/lib'),
    pathlib.Path('packages/stream_chat_localizations/lib'),
    pathlib.Path('sample_app/lib'),
]
ADAPTER_TODO = re.compile(r'TODO\(openapi-migration\): remove in group (\d+)')


def read_handwritten():
    """{file: [(method, returnType)]} for the hand-written api layer."""
    out = {}
    sources = sorted(API_DIR.glob('*_api.dart')) + [API_DIR / 'attachment_file_uploader.dart']
    for f in sources:
        methods = [
            (m.group(2), m.group(1))
            for m in re.finditer(r'\n  Future<([^\n]+?)>\s+(\w+)\(', f.read_text())
        ]
        if f.name == 'attachment_file_uploader.dart':
            # the abstract interface declares each method, the impl repeats it
            methods = methods[:8]
        if methods:
            out[f.name] = methods
    return out


def read_generated():
    """[(verb, path, operation, responseType)] for the generated client."""
    return re.findall(
        r"@(GET|POST|PATCH|PUT|DELETE)\('([^']+)'\)\s*\n\s*Future<Result<(\w+)>>\s+(\w+)\(",
        GENERATED_API.read_text(),
    )


def owns(*prefixes, unless=()):
    def match(path):
        if any(path.startswith(x) for x in unless):
            return False
        return any(path.startswith(x) for x in prefixes)
    return match


DONE = textwrap.dedent("""\
    - [ ] Every method above either routes through `DefaultApi` or is listed here as deliberately left
          hand-written, with the reason.
    - [ ] Public methods return `Future<Result<T>>`; no `getOrThrow()` inside the SDK.
    - [ ] Hand-written request/response DTOs for this group are deleted, or their retention is justified.
    - [ ] `melos run analyze` clean, `melos run test:dart` green, persistence tests green if this group
          persists anything.
    - [ ] `migrations/v11-migration.md`: Symbol Map rows plus a feature section for every break.
    - [ ] CHANGELOG entry under `🛑️ Breaking` for each break; PR title `refactor(llc)!:`.
    - [ ] Decisions recorded in this file, and the status box ticked in `README.md`.
    - [ ] Public dartdoc follows [`STYLE_GUIDE.md` § Documentation](../STYLE_GUIDE.md#documentation)
          and [`EFFECTIVE_DART_DOC.md`](../EFFECTIVE_DART_DOC.md), including on symbols this group
          retyped but whose docs it left alone.
    - [ ] Tests follow [`TESTING.md`](../TESTING.md): no `group` organizing a file by method, each
          name states its subject and behaviour.
    """)

GROUPS = [
    dict(
        num='02', slug='devices', title='Devices',
        hand=[],
        match=owns('/api/v2/devices'),
        goal='Prove the whole pattern end to end on the smallest real surface: three methods, no persistence, '
             'no channel scope.',
        decisions=[],
        taken=textwrap.dedent("""\
            Revisited after landing: the group first adopted the generated `DeviceResponse`,
            `ListDevicesResponse` and `CreateDeviceRequestPushProvider` as public types. It now follows the
            [domain-model rules](README.md#domain-models), and the decisions below are the ones in force.

            - **`Device` stays our public type, in its v10 shape** (`id`, `pushProvider`), as a plain class with
              no JSON. The repository maps the generated `DeviceResponse` into it. The seven further fields the
              server sends (`user_id`, `created_at`, `disabled`, `disabled_reason`, `hardware_id`,
              `push_provider_name`, `voip`) are not exposed; adding any of them later is non-breaking.
            - **`ListDevicesResponse` is hand-written,** under its v10 name, as a plain class carrying `duration`
              and `devices`. An envelope rather than a bare list, so a field the server adds to the response can
              be exposed without changing the method's signature.
            - **`PushProvider` becomes an extension type over its wire string,** where v10 declared an enum, and
              `Device.pushProvider` is typed with it rather than `String`. The server answers the provider as a
              free-form string, so a device registered with a provider the SDK does not name still decodes, and a
              provider added later is a new constant rather than a breaking enum value. The repository maps it to
              the generated `CreateDeviceRequestPushProvider` by its wire value. **This is the enum precedent for
              every later group:** a generated request enum gets a hand-written public type, so the generator's
              naming never reaches a signature.
            - **The write calls answer nothing.** `addDevice` and `removeDevice` return `Result<void>`: the
              generated `DurationResponse` carries only a server-timing string no integrator acts on, and v10's
              `EmptyResponse` is a json_serializable, mutable envelope the domain-model rules retire. **The
              precedent for every later group: a write whose response carries only `duration` returns
              `Result<void>`.**
            - **`hardwareId` and `voipToken` are left unset.** `voipToken` is typed `bool?` — a flag meaning "this
              id is a VoIP token", not the token — and surfacing it would imply a VoIP-push story the SDK does not
              have. Neither has an in-tree consumer. Adding them later is non-breaking.
            - **The empty-string `pushProviderName` normalization is preserved,** in the repository. `''` and
              `null` were identical on the wire because the key was omitted for both; keeping the normalization
              means no new wire value ships untested. Note the server does configure providers under the empty
              name — omitting the key resolves to that default — so `''` is normalized because it always was,
              not because the server would reject it.
            - **Mapping happens in the repository,** on the `Result` the generated call returns, through the
              extensions in `lib/src/repository/mapper/devices_mapper.dart`. `StreamChatClient` stays a pure
              delegate and never names a generated type.
            - **`OwnUser.devices` decodes through `DeviceV1JsonConverter`,** a temporary converter that reads and
              writes the v1 keys `id` and `push_provider`. `OwnUser` still decodes the v1 `me` payload with
              json_serializable and is persisted whole in `connection_events.own_user`, so its `devices` field
              needs JSON that `Device` no longer carries. The converter is removed by [group 09](09-users.md).
            - **The wire contract is generator-owned, and deliberately not re-pinned here.** The deleted
              `device_api_test.dart` asserted verb, path and body-versus-query placement, because the
              hand-written api owned them. They now come from the spec through retrofit annotations, so
              asserting them in this package would test the generator. The residual risk is named rather than
              covered: a regeneration that moved a parameter between query and body would pass CI. **This is
              the testing precedent for every later group** — mock at the `DefaultApi` seam, and let the
              generated client own the transport.
            - **Test mapping through the public client method,** from a generated response that sets every field the
              model carries with a distinct value, so a field the mapper drops or swaps fails an assertion. No separate
              repository or mapper tests.
            - **`setPushPreferences` did not come along,** so `device_api.dart` was renamed
              `push_preferences_api.dart` (`DeviceApi` → `PushPreferencesApi`, `StreamChatApi.device` →
              `StreamChatApi.pushPreferences`) rather than deleted — the file split rather than migrating whole.
              It is [group 13](13-push-preferences.md), which is gated behind a spec question and reaches into
              models this group deliberately avoids.
            """),
        risks=[
            '**Request bodies carry explicit nulls — verified harmless.** No model under `lib/open_api/model/` '
            'sets `includeIfNull: false`, so `CreateDeviceRequest.toJson` emits '
            '`{"hardware_id":null,"id":"…","push_provider":"firebase","push_provider_name":null,'
            '"voip_token":null}` where the hand-written path omitted those keys. This is the first request '
            '*body* through the generated client, so it applies to **every** group from here on; a live '
            '`createDevice` accepted it. Recorded rather than fixed — if a later endpoint does mind, the fix '
            "is the generator's model template, never a hand-rolled request builder.",
            'Devices are **not** persisted on their own — no entity, DAO or mapper. `OwnUser` *is*, inside '
            '`connection_events.own_user`, and its devices are written by `DeviceV1JsonConverter` under the '
            'same two keys v10 wrote.',
        ],
        done=DONE.replace('- [ ]', '- [x]'),
    ),
    dict(
        num='03', slug='user-groups', title='User Groups',
        hand=[],
        match=owns('/api/v2/usergroups'),
        goal='A clean 1:1 group — eight methods against eight generated operations, no client state, '
             'and one persisted field (`messages.mentioned_groups`).',
        decisions=[],
        taken=textwrap.dedent("""\
            Follows the [domain-model rules](README.md#domain-models).

            - **`UserGroup` and `UserGroupMember` stay our public types, with their current fields,** as plain
              classes whose only JSON is the temporary storage codec below. The generated
              `UserGroupMember.appPk` — the app's internal id, the same for every member — is not exposed; adding
              it later is non-breaking.
            - **The seven responses keep their names,** one file per class. `ListUserGroupsResponse` and
              `SearchUserGroupsResponse` carry a non-nullable `userGroups`, as the generated types do.
            - **`userGroup` is nullable on the five single-group responses** (`Get`, `Create`, `Update`,
              `AddUserGroupMembers`, `RemoveUserGroupMembers`), where v10 declared it non-null. The spec marks it
              optional, so the public type says what the API promises instead of turning a missing group into a
              failure the server never reported. A break outside the sanctioned list, taken deliberately.
            - **A missing list is never mapped to an empty one.** The only nullable generated list,
              `UserGroupResponse.members`, stays `null` when the response leaves it out (list and search do),
              which is not the same as a group with no members.
            - **`deleteUserGroup` returns `Result<void>`,** through `ignoreValue()`, per the duration-only rule.
            - **`StreamChatApi.userGroups` is removed** with `user_groups_api.dart`; every method now routes
              through `DefaultApi`.
            - **All mapping lives in `mapper/user_groups_mapper.dart`,** entity and response mappers together.
            - **`Message.mentionedGroups` decodes through `userGroupsFromV1Json`,** a temporary decode-only function
              rather than a `JsonConverter`: `Message.toJson` never writes the field, so a `toJson` would be dead
              code. It reads the v1 keys directly instead of through `api.UserGroupResponse.fromJson`, whose
              members require `app_pk` — a payload without it should not fail the whole message. Dates go through
              `StreamDateTimeConverter`: v1 sends ISO-8601 strings, but v2 sends epoch nanoseconds, which a live
              check against the demo app caught. Removed by [group 10](10-messages.md).
            - **Persistence stores `mentioned_groups` through `UserGroup.fromData` and `toData`,** generated by the
              temporary `@DataSerializable` typedef ([rule 8](README.md#domain-models)). `includeIfNull: false`
              keeps the stored JSON identical to what earlier v11 builds wrote through `UserGroup.toJson`, so no
              `schemaVersion` bump is needed; upgrading from v10 rebuilds the cache anyway, because the schema
              version differs. `members` needs a `@JsonKey` pair calling `UserGroupMember.fromData` and `toData`.
              Removed by [group 10](10-messages.md).
            - **The mention UI keeps `UserGroup`.** `StreamMentionAutocompleteOptions` reads the `Result` the way it
              already reads `searchRoles`; no UI type changes.
            """),
        risks=[
            '**`updateUserGroup` sends explicit nulls — verified harmless.** `UpdateUserGroupRequest.toJson` '
            'emits `"description": null` where the hand-written path omitted the key, and v10 documented an '
            'omitted `description` as "leave unchanged". A live check confirmed a `null` still leaves it '
            'unchanged.',
        ],
        done=DONE.replace('- [ ]', '- [x]'),
    ),
    dict(
        num='04', slug='roles-guest-and-app', title='Roles, Guest & App Settings',
        hand=[],
        match=owns('/api/v2/roles', '/api/v2/guest', '/api/v2/app', '/api/v2/og', '/api/v2/longpoll'),
        goal='Sweep up the singletons — one-method families that share no state and can land in one PR.',
        decisions=[],
        taken=textwrap.dedent("""\
            - **`Role` and `SearchRolesResponse` stay our public types, in their v10 shapes,** as plain classes
              with no JSON, mapped from the generated types in `lib/src/repository/mapper/roles_mapper.dart`. The
              group first adopted the generated types; it now follows the
              [domain-model rules](README.md#domain-models).
            - **`RoleType` stays hand-written.** `searchRoles(roleType:)` accepts exactly `'user'` or `'channel'`
              and the server rejects anything else with a 400, but the v2 spec models `role_type` as an open
              string, so there is nothing generated to adopt. It is an `extension type const RoleType(String)
              implements String` in `lib/src/core/models/role_type.dart`, following `PushLevel`.

              **This is the precedent for every later group that meets an untyped-but-constrained parameter:** the
              absence of a generated type is not a reason to make the public parameter a bare `String`. An
              extension type costs nothing — it *is* the string, so it passes straight into the generated query
              parameter with no mapper — while keeping the valid values discoverable at the call site. It stays
              honest about the wire contract too: the set is open, so a third value the server adds later needs no
              SDK release.

              The trade-off, for the record: no `.values`, no exhaustive `switch`, and `RoleType('nonsense')` is
              constructible and reaches the wire. That matches the four extension types this package already ships.
            - **`OGAttachmentResponse` stays our public type, with its v10 name and fields,** as a plain class with no
              JSON, mapped from the generated `GetOGResponse` in `lib/src/repository/mapper/general_mapper.dart`.
              `enrichUrl` routes through `getOG` via `GeneralRepository`. The v10 name is kept although the generated
              one differs: it is the name customers already use.
            - **`ogScrapeUrl` stays non-null, as in v10.** The server sets it on every successful scrape; the spec marks
              it optional only because the response embeds the shared attachment payload. The mapper falls back to the
              requested URL, which cannot happen in practice.
            - **The twelve fields the generated response adds are not exposed** (`actions`, `author_icon`, `color`,
              `custom`, `fallback`, `fields`, `footer`, `footer_icon`, `giphy`, `original_height`, `original_width`,
              `pretext`). Adding them later is non-breaking. `Attachment.fromOGAttachment` is unchanged.
            - **`Action` is left alone.** `OGAttachmentResponse` carries no actions, so nothing here needs it; it is
              converted with its parent `Attachment` in [group 10](10-messages.md).
            - **`AppSettings` and `UploadConfig` stay our public types, in their v10 shapes,** as plain classes with
              no JSON, and the envelope is `AppSettingsResponse`, renamed from v10's `GetAppSettingsResponse`. They
              are mapped from the generated `AppResponseFields`, `FileUploadConfig` and `GetApplicationResponse` in
              `lib/src/repository/mapper/app_settings_mapper.dart`. `AppResponseFields.id` and `placement` are not
              exposed. This settles the group's open question.
            - **`getAppSettings` answers the envelope,** `Result<AppSettingsResponse>`, where v10 answered the
              bare `AppSettings`. This is a break beyond the [sanctioned ones](README.md#domain-models), approved for
              this group so that every migrated read answers its envelope. `client.appSettings` stays a
              non-nullable `AppSettings` that reads `const AppSettings()` until the load `connectUser` starts
              succeeds.
            - **The other public names stay v10's.** Renaming them to the generated `getApp`,
              `GetApplicationResponse` and `FileUploadConfig` was considered and rejected: each would be a rename
              break with no change in behaviour. Only the envelope drops its `Get` prefix.
            - **An unset size limit stays `0`.** The server reports one as `size_limit: 0`, and
              `UploadConfig.sizeLimit` passes it through as v10 did; `StreamAttachmentValidator` applies
              `UploadConfig.defaultSizeLimit` in that case. No `effectiveSizeLimit` getter was added.
            - **`connectGuestUser` keeps its v10 signature and keeps throwing.** It returns `Future<OwnUser>` and
              throws a `StreamException`, like `connectUser`, `connectUserWithProvider` and `connectAnonymousUser`.
              It unwraps `GeneralRepository.createGuest`'s `Result` with `getOrElse`, the one sanctioned unwrap
              inside the SDK: a `Result` on a connect call could be ignored and hide a failed sign-in.
            - **`createGuest` lives in `GeneralRepository`**, next to `enrichUrl`. Its mappers are in
              `lib/src/repository/mapper/user_mapper.dart`, with the `User` mappers they use.
            - **The envelope is the internal `CreateGuestUserResponse`:** a freezed envelope that only
              `createGuest` returns. It replaces v10's public `ConnectGuestUserResponse`, whose only public reach was
              `StreamChatApi.guest`, removed together with `GuestApi`.
            - **The request carries every field the backend honours for a client-side guest:** id, name, image,
              custom data, language, `invisible` and, for an `OwnUser`, privacy settings. `role`, `teams` and
              `teams_role` are ignored for client-side calls and are not sent.
            - **The rest of the user is no longer sent.** v10 sent the whole flattened user, and v1 filed every key
              the request does not declare (`online`, `banned`, devices, unread counts, push preferences and so on)
              into the guest's custom data, where some were echoed back: `pushPreferences` on the returned
              `OwnUser` and in `queryUsers`' `extraData`, the unread counts when the socket is off, and `ban_expires`
              in the raw `me`. None was ever applied. Verified live against the demo app and in the backend source;
              recorded as a 🐞 Fixed entry.
            - **`UserResponse.toModel()` leaves custom keys named like `OwnUser` fields (`OwnUser.topLevelFields`),
              plus `deleted_at`, `deactivated_at` and `revoke_tokens_issued_before`, out of `extraData`.** v1's flat
              user JSON shadowed them; v2 nests custom data, and without the guard a custom `online` string crashed
              `OwnUser.fromUser`. `User.toRequest()` leaves the same keys out of the custom data it sends.
            - **The three extra names are guarded because the socket connect refuses them.** A custom
              `deleted_at`, `deactivated_at` or `revoke_tokens_issued_before` left in `extraData` is re-sent in the
              connect's user details, and the backend answers 400 ("reserved field", or "expected date" for a
              non-date value). v10's flat response shadowed them, so the same guest connected; confirmed live.
            - **Not a regression: a custom `ban_expires` that isn't a date** fails the connect in v10 and now alike,
              because the socket's `me` lets it through into `OwnUser.fromJson`.
            - **`User` is not restructured here.** `user_mapper.dart` maps the generated types onto today's `User`,
              following [01-foundation](01-foundation.md).
            """),
        done=DONE.replace('- [ ]', '- [x]'),
        risks=[
            '`general_api.dart` has no methods left in this group — `sync` and `queryMembers` go to group 11, '
            '`searchMessages` to group 10. Do not migrate the file as a unit.',
        ],
    ),
    dict(
        num='05', slug='polls', title='Polls',
        hand=['polls_api.dart'],
        match=owns('/api/v2/polls', '/api/v2/chat/messages/{message_id}/polls'),
        goal='First group with real domain models and persistence behind it.',
        decisions=[
            '`Poll`, `PollOption` and `PollVote` are public and persisted; adopting generated shapes means '
            'touching `stream_chat_persistence` in the same PR.',
            '`VotingVisibility` is ours; the generated equivalent is an inline per-operation enum.',
            'One generated `PollResponse` answers `createPoll`, `getPoll`, `updatePoll` and `updatePollPartial`, '
            'where v10 has `CreatePollResponse`, `GetPollResponse` and `UpdatePollResponse`. The v10 envelopes '
            'stay; decide with the user how the mapper names its conversions, since one `toModel()` cannot return '
            'three types. `PollOptionResponse` (create, get, update an option) and `PollVoteResponse` (cast, remove '
            'a vote) have the same shape.',
        ],
        risks=[
            'Vote operations live under `/chat/messages/{message_id}/polls/...`, not `/polls` — easy to miss when '
            'grepping by path.',
            'Poll updates also arrive over the WebSocket, so `DateTime` and `custom` handling must tolerate both '
            'encodings.',
            'Touching a file under `lib/src/entity/` trips `check_db_entities`, which demands a `schemaVersion` '
            'bump for any change there — including an import-only one. Do not bump it for a no-op; the guard is '
            'coarse, the schema is what matters.',
        ],
    ),
    dict(
        num='06', slug='reminders', title='Message Reminders',
        hand=['reminders_api.dart'],
        match=owns('/api/v2/chat/messages/{message_id}/reminders', '/api/v2/chat/reminders'),
        goal='Small and self-contained, and it exercises the `PATCH` shape our hand-written layer expresses '
             'differently.',
        decisions=[
            '`MessageReminder` is public and persisted; decide keep-vs-adopt with persistence in the same PR.',
        ],
        risks=['Reminder events also arrive over the WebSocket.'],
    ),
    dict(
        num='07', slug='threads-and-drafts', title='Threads & Drafts',
        hand=['threads_api.dart',
              'message_api.dart::createDraft', 'message_api.dart::deleteDraft',
              'message_api.dart::getDraft', 'message_api.dart::queryDrafts'],
        match=owns('/api/v2/chat/threads', '/api/v2/chat/drafts', '/api/v2/chat/channels/{type}/{id}/draft'),
        goal='Two related families that share the `Draft` model and the list controllers above them.',
        decisions=[
            'The generated thread response embeds a full `ChannelResponse`. Decide whether the channel inside a '
            'thread adopts the generated shape now, or waits for the channels group — and write the answer down, '
            'because the two groups can otherwise disagree.',
        ],
        risks=[
            'The four draft methods live in `message_api.dart`, not `threads_api.dart` — this group reaches into '
            'that file, and group 10 must leave those four alone.',
            '`Draft` and `DraftMessage` are public, persisted, and read by `StreamDraftListController` in '
            '`stream_chat_flutter_core`.',
        ],
    ),
    dict(
        num='08', slug='moderation-and-blocklists', title='Moderation & Blocklists',
        hand=['moderation_api.dart'],
        match=owns('/api/v2/moderation', '/api/v2/chat/moderation', '/api/v2/blocklists',
                   '/api/v2/chat/query_future_channel_bans'),
        goal='The largest generated surface relative to ours — decide what stays unexposed.',
        decisions=[
            'None outstanding. `queryBannedUsers` is the one method still hand-written; see below for when it '
            'moves.',
        ],
        taken=textwrap.dedent("""\
            - **The moderation *writes* are this group; the one *read* was split into
              [14](14-banned-users.md).** Every method here answers with nothing we keep, so none of them needs
              model mapping — which is why they moved together and cleanly. `queryBannedUsers` answers with
              `BanResponse`, whose `UserResponse` and `ChannelResponse` belong to groups 09 and 11, so it became
              its own group rather than an asterisk on this one.

            - **`muteUser`, `unmuteUser`, `banUser` and the flag methods change service, not just shape.** Ours
              called the chat v1 routes `lib/chat/routes.go` mounts at the root and comments as deprecated; the
              generated operations are the moderation product under `/api/v2/moderation/`. The handlers are
              equivalent — `moderation/controller/mute.go` uses the same `state.InsertUserMutes` and emits the
              same `notification.mutes_updated` and `user.muted` events as `chat/controller/v1/mute_user.go`.
              They are `Beta: true` and gated on `FeatureFlagEnabled -> app.ModerationV2Enabled()`, which defaults
              on (`moderation_enabled` unset means enabled); an app explicitly pinned to the v1 flow gets
              `"this endpoint needs a feature flag"`.

            - **A method answers with whatever the call actually carries.** `muteUser` and `unmuteUser` return
              the ids that matched no user; the flag methods return the review-queue item the flag created.
              Three hand-written models in `core/models/response/` carry them, exported from the barrel, and
              `ModerationClient` returns them unchanged rather than discarding them. Widening a `Result<void>`
              this way is not a source break, because `void` is a top type and `Result` is covariant: every
              existing call site in this repo compiled untouched.

            - **The rest answer with nothing worth returning, and stay `Result<void>`.** `ban` and `unban`
              answer with only `duration`, which is group 02's envelope-only precedent. `unmuteChannel` reuses the same
              response type as `unmuteUser` but the handler never fills it in, so it is an envelope too. The
              rest is blocked rather than unwanted: `mute.mutes`, `mute.ownUser` and everything on
              `muteChannel` need `UserResponse` and `ChannelResponse` mapped first, which is groups 09 and 11
              — and the `User` shape is group 01's to decide, not this group's. No `UserResponse` mapper
              exists yet, so nothing here could have been mapped without pre-empting that decision.

            - **`removeShadowBan` is removed outright, without a deprecation cycle.** Unlike the unflag
              pair, neither this package nor the backend ever deprecated it: v10.4.0 shipped it as plain
              public API, and `unflag` is the only moderation route the server marks `Deprecated: true`
              (`lib/chat/controller/v1/unflag.go:23`). Keeping it as a deprecated alias was tried and
              rejected — it does nothing `unbanUser` does not, so a cycle would only prolong the suggestion
              that shadow bans are lifted differently. A v10 caller gets a compile error and one Symbol Map
              row rather than a release of ambiguity.

            - **`unflagMessage` and `unflagUser` are removed, not migrated.** `POST /moderation/unflag` has no v2
              operation and is a chat-v1-only route the server no longer acts on: it validates the request,
              answers successfully, and leaves the flag in place. Both were already deprecated here for that
              reason, in a released version.

            - **`banUser`'s `Map<String, Object?> options` becomes typed parameters**, mirroring the generated
              `BanRequest`. This drops `remove_future_channels_ban` and `reason` on *unban*, which chat v1
              accepted and the moderation v2 `UnbanRequest` does not, and it fixes `Channel.banMember` /
              `unbanMember`, which sent the `type` + `id` pair chat v1 deprecates in favour of `channel_cid`.
              `timeout` is a `Duration` raised to at least one minute, because the value the conversion would
              otherwise truncate to means no expiry at all.

            - **`deleteMessages` is a hand-written `DeleteType`, not the generated enum.** The generated
              `BanRequestDeleteMessages` is already a correct extension type over `String` with the same three
              values, so this is not about quality — it is about the name. A caller writing
              `BanRequestDeleteMessages.hard` is naming our request DTO rather than the concept, and the type
              is what hovers show. This follows `PushProvider`, which group 02 first adopted from the
              generated side and [#3004](https://github.com/GetStream/stream-chat-flutter/pull/3004) replaced
              with a hand-written one for exactly that reason, and it settles the rule group 02 left open:
              **adopt a generated type only when its name names the concept.** It also leaves the barrel with
              no generated exports, which is what `--check` asserts.

            - **`ipBan` is kept although the endpoint discards it.** `lib/chat/controller/v1/ban_user.go:198`
              passed it through; the v2 handler at `lib/moderation/controller/ban.go:87-94` builds its action
              from `Timeout`, `Reason`, `Shadow` and `DeleteMessages` only, so the flag is accepted and
              dropped. The parameter and the dartdoc that describes it are kept by decision, so that the day
              the handler wires it through nothing here changes. A channel-scoped ban never honoured it
              either — `ban_user.go:107-108` rejects `ip_ban` together with a channel outright.

            - **`StreamChannelListController.muteChannel` and `unmuteChannel` return `Result<void>`.** They
              were `Future<void>` awaiting a call that now answers with a `Result`, so a caller's `try`/`catch`
              stopped firing with no compile error. Returning the `Result` makes the failure reachable again.
              It is breaking rather than a fix: the controller is subclassable, and an override declared
              `Future<void>` no longer satisfies the base.

            - **`nonExistingUsers` is on the plural methods only.** The handler answers with the ids that
              matched no user, but only ever some of them: if none match it fails instead
              (`lib/moderation/controller/mute.go:106`). A single-id call therefore either succeeds with an
              empty list or fails, so `muteUser` and `unmuteUser` return `Result<void>` and only `muteUsers`
              and `unmuteUsers` answer with the model. Swift draws the same line — its singular calls return
              nothing and its plural ones return a response — and its demo app renders the field after a
              batch mute, so this is a field with a demonstrated consumer rather than one exposed on spec.

            - **Users are batched, channels are not.** `muteUsers` and `unmuteUsers` take a list, because
              the endpoints have always been batch endpoints — `target_ids` is a list validated
              `required,max=1000` — and because the response names the ids that matched no user, which is only
              worth reading when more than one was sent. The singular methods stay as they are. Swift exposes
              the same pair and no channel equivalent, and `muteChannel` answers with nothing we keep, so a
              plural there would return `Result<void>` and be sugar for a loop. Do not add one for symmetry.

            - **The type is named `DeleteType`, not for the ban parameter that first needed it.** Soft,
              pruning and hard are how thoroughly anything is deleted, not something about bans: the backend
              declares them once as `DeleteType` in `lib/core/event/delete_type.go` and reuses them for user
              deletion, message deletion and the `user.deleted` event, and the JS client exports the same
              `DeleteType` union. The generated client already carries four copies of the same three values —
              on `BanRequest`, `BanOptions`, `BanActionRequestPayload` and `DeleteUserMessagesRequestPayload`
              — each named after the request it hangs off. One hand-written type covers all four, so the
              later groups that migrate message and user deletion reuse it instead of adding their own.

            - **None of the other generated operations are exposed, and not because they are server-side.**
              That was the original reason recorded here and it is wrong: the spec this client is generated
              from is built with `-clientside`, which drops every route the backend marks `ServerSideOnly`.
              Moderation's genuinely server-side surfaces — moderation logs, queue and moderator stats, flag
              counts, rules and tasks — are filtered out before generation, so nothing reachable through
              `DefaultApi` needs a secret. The remaining 28 are callable from an app; a caller without the
              permission gets refused at runtime, per user, which is a different gate from this one.

              **This group ships the nine methods it migrated and nothing more**, pending agreement with the
              other SDK teams on what a chat client should carry. The surfaces disagree today: two of them
              publish the whole generated moderation API, one publishes part of it, and two publish none of
              it, so there is no shared answer to copy. That conversation decides the scope, and it has not
              happened yet.

              The cost is not the method count either. Each operation needs its own hand-written model here —
              queues, moderation configs and action configs alone are around a dozen model families — and
              eight of the operations embed `UserResponse`, `ChannelResponse` or `MessageResponse`, so they
              wait on groups 09, 10 and 11 exactly as [14](14-banned-users.md) does. Whether that cost applies
              at all depends on whether this package keeps mapping generated responses to its own models;
              settle that before sizing a group around these operations.
            """),
        risks=[
            '~~`query_banned_users` may omit the `created_at_after` / `created_at_before` filters our request '
            'sends~~ — resolved. It did, at `openapi-v237.2.0`: the server reads them off an embedded '
            '`*types.BansPager` in `GetPager()` and the spec did not flatten the embed. `openapi-v239.10.0` does, '
            'so `QueryBannedUsersPayload` now carries all four cursors. Regenerating also added `unban`, without '
            'which `banUser` would have migrated while `unbanUser` did not.',
        ],
        done=DONE.replace('- [ ]', '- [x]'),
    ),
    dict(
        num='09', slug='users', title='Users',
        hand=['user_api.dart'],
        match=owns('/api/v2/users', '/api/v2/chat/unread'),
        goal='`User` is the most widely referenced public model in the SDK; this is where keep-vs-adopt costs the '
             'most.',
        decisions=[
            '`User` and `OwnUser` are public, persisted, and embedded in nearly every other response. This group '
            'restructures them, last: the mappers in `user_mapper.dart` already map the generated types onto the '
            'current class for every group before it, and stay. See [01-foundation](01-foundation.md).',
            '`PrivacySettings` and the push-preference sub-shapes — decide per type.',
            '`UserResponse.toModel()` leaves `OwnUser.topLevelFields`, `deleted_at`, `deactivated_at` and '
            '`revoke_tokens_issued_before` out of every user\'s `extraData` (`_shadowedCustomKeys`), where v1 kept the '
            '`OwnUser`-only keys in a plain user\'s `extraData`. Revisit once the mapper serves plain users.',
            '`UserFilterField.shadowBanned` and `.bypassModeration` read `extraData`, which the generated '
            '`UserResponse` has no field to fill.',
            '`updateUsers` reuses `User.toRequest()`. It is a full upsert, and v10\'s flattened body filed the '
            'user\'s client state (`online`, `banned`, `created_at` and similar) into the stored custom data on '
            'every call, as it did for guests in [04](04-roles-guest-and-app.md). Decide the same way here, for real '
            'users rather than fresh guests, and record it in the CHANGELOG.',
            'The generated `UserRequest` sends explicit `null` for an unset `language` or `invisible`, where v10 '
            'left the key out. For a guest create that made no difference; for an upsert of an existing user, '
            'confirm live that a `null` does not reset a stored value differently from an omitted key.',
        ],
        risks=[
            'Every other group depends on the `User` decision.',
            'User data arrives over the WebSocket on nearly every event.',
            'Landing `UserResponse` -> `User` unblocks the two fields [08](08-moderation-and-blocklists.md) '
            'had to drop from `MuteUsersResponse`: the `mutes` the call created and the `ownUser` it left '
            'behind. Adding them is additive for anyone reading the response, so revisit them here rather '
            'than leaving them dropped for good.',
        ],
        done=DONE + (
            '- [ ] Temporary adapters owned by this group (`DeviceV1JsonConverter`) are deleted and removed from\n'
            '      the table in `README.md`.\n'
            '- [ ] `user_mapper.dart` maps onto the restructured `User`, and its `TODO(openapi-migration)` note is\n'
            '      gone.\n'
        ),
    ),
    dict(
        num='10', slug='messages', title='Messages & Search',
        hand=['message_api.dart', 'general_api.dart::searchMessages'],
        match=owns('/api/v2/chat/messages', '/api/v2/chat/search',
                   unless=('/api/v2/chat/messages/{message_id}/polls',
                           '/api/v2/chat/messages/{message_id}/reminders')),
        goal='The core of the SDK, and the group with the most customisation pressure on its models.',
        decisions=[
            '`Message` is public, persisted, WebSocket-delivered and the most customised type in the SDK. Keep '
            'ours; treat the generated `MessageResponse` as a mapping source only.',
            '`Attachment`: the generated model defines fields our `extraData` currently absorbs. Decide the '
            'promotion rules before writing the mapper.',
            'Replace the temporary `@DataSerializable` storage codec (`UserGroup`, `UserGroupMember`, `ReactionGroup`): decide '
            'between dedicated tables and codecs owned by `stream_chat_persistence` before `Message` and '
            '`Attachment` become plain models, then delete the typedef and every `fromData`/`toData` it generates.',
        ],
        risks=[
            '`message_api.dart` also holds the four draft methods, which belong to group 07 — leave them alone '
            'here.',
            'Attachment `custom`/`extraData` promotion is the known hard part of the whole migration.',
            'Message send has offline and retry paths through `stream_chat_persistence` that must keep working.',
            '`MessageDeleteScope` has to be reconciled with `DeleteType`, which [08](08-moderation-and-blocklists.md) added. It is named for the scope of a delete — `deleteForMe` vs `deleteForAll` — but carries a `hard` bool, which is the same axis `DeleteType` models, in the same words, minus `pruning`. `deleteMessage(hard: true)` therefore cannot express a pruning delete at all, and `softDeleteForAll` / `hardDeleteForAll` read as two spellings of `DeleteType.soft` / `DeleteType.hard`. Decide whether the scope keeps a `DeleteType` field or the two stay separate arguments; either way the public type changes, so it belongs in this group rather than a later fix.',
        ],
        taken=textwrap.dedent("""\
            The models `Message` embeds become plain ahead of the endpoints, one PR each, leaves first. None routes
            an endpoint, so the definition of done below stays open.

            - **`Moderation` is a plain `@freezed` model.** It loses `fromJson`, `toJson` and `Equatable`; equality
              is unchanged. `Message.moderation` decodes through `moderationFromV1Json`, a temporary decode-only
              function in `v1_json_converters.dart`: `Message.toJson` never writes the field. It keeps the
              `moderation_details` fallback and the legacy `MESSAGE_RESPONSE_ACTION_*` names, and reads a missing
              `platform_circumvented` as `false`. `stream_chat_persistence` does not store moderation, so no codec
              is needed. `ModerationAction` keeps its `fromJson`/`toJson` statics, as `MessageType` does, until
              `Message` stops decoding v1 JSON. The `ModerationV2Response` mapper waits for the first endpoint
              that answers a message.
            - **`ReactionGroup` is a plain `@freezed` model.** It loses `fromJson`, `toJson` and `Equatable`;
              equality is unchanged. Its constructor stays non-const, defaulting both dates to now, and it keeps
              v10's hand-written `copyWith` (`@Freezed(copyWith: false)`): freezed's would read a `null` date as
              "now" instead of "keep". `Message.reactionGroups` decodes through `reactionGroupsFromV1Json`,
              decode-only; `_reactionGroupsReadValue` still builds the groups from `reaction_counts` and
              `reaction_scores` when `reaction_groups` is missing. Dates go through `StreamDateTimeConverter`.
              `messages.reaction_groups` and `pinned_messages.reaction_groups` store the groups through the
              temporary `@DataSerializable` codec, whose output is byte-identical to v10's `toJson`, so no
              `schemaVersion` bump.
            - **`Action` is a plain `@freezed` model,** ahead of `Attachment` rather than with it. It loses
              `fromJson` and `toJson`, gains `copyWith` and `const`, and compares by value where v10 compared by
              identity, so attachments holding equal actions now compare equal. `Attachment.actions` reads and
              writes through `ActionV1JsonConverter`: `Attachment.toJson` sends the actions and `toData` stores
              them, and the converter writes the same keys v10 did, `value` included when null, so requests and
              the stored `attachments` columns are unchanged. `Action` needs no codec of its own.
            """),
    ),
    dict(
        num='11', slug='channels-and-members', title='Channels, Members & Sync',
        hand=['channel_api.dart', 'general_api.dart::sync', 'general_api.dart::queryMembers'],
        match=owns('/api/v2/chat/channels', '/api/v2/chat/members', '/api/v2/chat/sync',
                   unless=('/api/v2/chat/channels/{type}/{id}/draft',
                           '/api/v2/chat/channels/{type}/{id}/file',
                           '/api/v2/chat/channels/{type}/{id}/image')),
        goal='The biggest group, and the one every controller above it reads through `ChannelState`.',
        decisions=[
            '`ChannelState`, `ChannelModel` and `Member` are public, persisted, and rebuilt from WebSocket '
            'events. Keep ours and map.',
            '**Whether `ChannelModel` promotes its `extraData`-backed flags to real fields.** `disabled`, '
            '`hidden`, `muted`, `blocked` and `truncatedAt` all arrive as root fields on `ChannelResponse` but '
            'are pushed into `extraData` and read back through getters, which the constructor comment calls '
            '"for backwards compatibility". Promoting them is a break worth making in v11 if it is made at '
            'all, and it belongs with this group\'s model shape rather than with whichever phase happens to '
            'add the next flag. Raised on '
            '[#2958](https://github.com/GetStream/stream-chat-flutter/pull/2958).',
            '`sync` returns `SyncResponse` — one of the two models that needed the WSEvent generator patch. '
            'Verify it decodes before relying on it.',
        ],
        risks=[
            '`sync` and `queryMembers` live in `general_api.dart`, not `channel_api.dart` — this group reaches '
            'into that file.',
            '`queryChannels` drives the channel list controllers and the offline cache; a shape change here is '
            'felt everywhere.',
            'Channel `custom`/`extraData` promotion, same class of problem as messages.',
            'Landing `ChannelResponse` -> `ChannelModel` is the last thing blocking '
            '[08](08-moderation-and-blocklists.md)\'s `muteChannel`, which drops `channelMute`, `channelMutes` '
            'and `ownUser` because the generated `ChannelMute` carries a `ChannelResponse?` and a '
            '`UserResponse?` where ours needs a non-nullable `ChannelModel` and `User`. It needs 09 as well. '
            'Decide the null case there too — ours are non-nullable, the generated ones are not, the same '
            'question [14](14-banned-users.md) records for `BanResponse.user`.',
        ],
    ),
    dict(
        num='12', slug='uploads-cdn', title='Uploads (CDN)',
        hand=['attachment_file_uploader.dart'],
        match=owns('/api/v2/uploads', '/api/v2/chat/channels/{type}/{id}/file',
                   '/api/v2/chat/channels/{type}/{id}/image'),
        goal='Move file and image uploads to v2 behind a hand-written retrofit multipart client.',
        decisions=[],
        taken=textwrap.dedent("""\
            - **The eight methods stay hand-written, over a hand-written multipart client.** The generated
              `uploadFile`, `uploadImage`, `uploadChannelFile` and `uploadChannelImage` take a JSON `@Body()`
              with no progress or cancellation, because the Dart `operation.tpl` ignores
              `Operation.RequestContentType`. `lib/src/cdn/cdn_api.dart` mirrors the generated operations —
              names, paths, parameters, and each request model's fields as parts — adding only the file part,
              progress and cancellation, so a template that emits multipart can replace it as is. It leaves
              out the `user` part, which only a server-side request sets.
              `StreamAttachmentFileUploader` calls it instead of `StreamHttpClient.postFile`.
            - **The v2 routes are the v1 handlers.** `lib/chat/routes.go` mounts the channel routes in the shared
              `coreRoutes` under both surfaces, and `lib/core/api/routes_saas.go` does the same for `/uploads`;
              only the JSON encoder differs. None is gated, in beta or deprecated.
            - **The public shape stays v10's.** `AttachmentFileUploader` keeps its eight methods, chat's
              `AttachmentFile` and its parameters, including the `extraData` neither surface reads; only the
              return types change, to `Result`. Taking `stream_core`'s `CdnClient` and `AttachmentFile` is
              deliberately left out; see [`core-migration/09`](../core-migration/09-uploads.md#design-worked-out-for-a-later-pr).
            - **The provider receives the client's `Dio`.** `StreamHttpClient`'s `Dio` is `@visibleForTesting`
              and is not the one `DefaultApi` uses, so `AttachmentFileUploaderProvider` takes the `Dio` the
              generated client runs on, and the uploader moves from `StreamChatApi` to `StreamChatClient`.
            - **Uploads answer `stream_core`'s `UploadedFile`** (`fileUrl`, `thumbUrl`) instead of v10's five
              response types. A break beyond the domain-model list, taken here because every upload call site
              already changes for `Result` — replacing the types later would break the same lines twice — and
              because it is what core's `CdnClient` and feeds' `FeedsCdnClient` answer. `duration` goes with
              them; it is server timing no integrator acts on, the reasoning behind `Result<void>` for
              duration-only writes.
            - **A file that cannot be read answers a `Failure`,** through `runSafely` around the multipart
              conversion.
            """),
        risks=[
            'Attachment upload is the highest-traffic path in the SDK; a regression is immediately visible to end '
            'users.',
        ],
        done=DONE.replace('- [ ]', '- [x]'),
    ),
    dict(
        num='13', slug='push-preferences', title='Push Preferences',
        hand=['push_preferences_api.dart'],
        match=owns('/api/v2/push_preferences'),
        goal='Migrate the one method group 02 left behind — last, because its dependencies are group 11\'s, '
             'not group 02\'s.',
        decisions=[
            '**Whether the spec can express a push-preference map the server only partly fills.** The generated '
            '`UpsertPushPreferencesResponse.userPreferences` is `Map<String, PushPreferencesResponse>` with '
            'non-nullable values, but our `_userPreferencesFromJson` (`responses.dart`) exists specifically to '
            'drop `null` entries — its doc comment states the server returns `null` for users the upsert did '
            'not touch, and `responses_test.dart` pins it. Adopting the generated type as it stands would turn '
            'a routine channel-only upsert into a decode failure. Resolve it with a live capture of a '
            'channel-only upsert **before** writing code; if the server does send `null`, the fix belongs in '
            'the spec (`user_preferences` wants nullable `additionalProperties`) and is `openapi-codegen` '
            'work, not a hand-rolled decoder here.',
            'Whether `setPushPreferences` keeps reading its response into client state and emitting '
            '`EventType.pushPreferenceUpdated` from the api layer, or that moves up.',
        ],
        risks=[
            '`ChannelConfig.chatPreferences` **is** persisted, inside the `channels.config` JSON blob. Deleting '
            '`chat_preferences.dart` retypes it and touches `channel_mapper_test.dart`, dragging '
            '`ChannelConfig` — a group 11 model — along. No schema change, but it is a persistence change, and '
            'it is why this group sorts after 11 rather than beside devices.',
            '`PushPreference` / `ChannelPushPreference` ride on `Event`, `OwnUser.pushPreferences` and '
            '`ChannelState.pushPreferences`, so adopting them reaches into the event and channel-state layers.',
            '`ChannelState.pushPreferences` is **not** persisted — checked, no entity, DAO or mapper.',
        ],
    ),
    dict(
        num='14', slug='banned-users', title='Banned Users',
        hand=['moderation_api.dart::queryBannedUsers'],
        match=owns('/api/v2/chat/query_banned_users'),
        goal='Migrate the one method group 08 left behind — the only moderation call that answers with a model.',
        decisions=[
            '**What `BannedUser` becomes.** Keep it and map `BanResponse` at the boundary, or adopt `BanResponse` '
            'and re-parameterise `BannedUserFilter` / `BannedUserSort` onto it. The answer follows group 09\'s '
            '`User` decision — it is not a free choice here.',
            '**What to do with a `BanResponse` whose `user` is null.** Ours is non-nullable; skip the entry or '
            'fail the decode, but decide it rather than reaching for `!`.',
        ],
        taken=textwrap.dedent("""\
            - **This is a group, not an asterisk on [08](08-moderation-and-blocklists.md).** Every other
              moderation method answers with nothing we keep, so they needed no mapping and moved together.
              This one cannot move until the shapes it embeds are decided, and a group that is *mostly* done
              hides that from the next reader. Splitting it keeps both records honest.
            """),
        risks=[
            '`BannedUser` is the type parameter for `BannedUserFilter` and `BannedUserSort`, whose fields read '
            'values off it (`it.user.id`, `it.bannedBy?.id`, `it.channel?.cid`, `it.createdAt`). Retyping the '
            'response retypes that registry too.',
            '`UserResponse.custom` → `User.extraData` drops `name` and `image` unless the mapper promotes them: '
            'they arrive as root fields, `Serializer.moveToExtraDataFromRoot` normally moves them, and '
            '`User.name` falls back to `id`. A mapper that misses this makes every banned user\'s name their '
            'id, and passes any test that does not assert on `.name`.',
            'It is the last method in `moderation_api.dart`. Closing this group deletes that file and the '
            '`StreamChatApi.moderation` getter.',
        ],
    ),
]



def hand_for(group, hand):
    """Methods this group owns. 'file.dart::method' claims one; 'file.dart' claims the
    remainder of that file after every explicit claim elsewhere."""
    explicit = {e.split('::')[1] for g in GROUPS for e in g['hand'] if '::' in e}
    out = []
    for entry in group['hand']:
        if '::' in entry:
            f, name = entry.split('::')
            out += [(f, n, r) for n, r in hand.get(f, []) if n == name]
        else:
            out += [(entry, n, r) for n, r in hand.get(entry, []) if n not in explicit]
    return out


def render(g, hand, ops):
    hand_methods = hand_for(g, hand)
    gops = [o for o in ops if g['match'](o[1])]
    L = [
        f"# {g['num']} — {g['title']}\n",
        f"**Goal:** {g['goal']}\n",
        f"**Size:** {len(hand_methods)} hand-written method(s) across "
        f"{len({f for f, _, _ in hand_methods})} file(s) → {len(gops)} generated operation(s).\n",
        '> This whole file is generated by `openapi-migration/tool/generate_plan.py`, prose included.\n'
        '> Edit its `GROUPS` entry and re-run the script — edits made here are lost on the next run.\n',
        '## Scope\n',
        '### Hand-written today\n',
        '| File | Method | Returns |',
        '| --- | --- | --- |',
    ]
    L += [f'| `{f}` | `{n}` | `{r}` |' for f, n, r in hand_methods]
    L += ['\n### Generated operations that cover it\n',
          '| Verb | Path | Operation | Response |', '| --- | --- | --- | --- |']
    L += [f'| `{verb}` | `{path}` | `{name}` | `{ret}` |' for verb, path, ret, name in
          [(v, p, r, n) for v, p, r, n in gops]]
    if g['decisions']:
        L.append('\n## Decisions to make\n')
        L += [f'- {d}' for d in g['decisions']]
    if g.get('taken'):
        L.append('\n## Decisions taken\n')
        L.append(g['taken'].strip())
    L.append('\n## Risks\n')
    L += [f'- {r}' for r in g['risks']]
    L.append('\n## Definition of done\n')
    L.append(g.get('done', DONE))
    return '\n'.join(L)


def generated_exports():
    """Barrel lines that export the generated client."""
    return [
        line.strip()
        for line in BARREL.read_text().splitlines()
        if re.match(r"export\s+'open_api/", line.strip())
    ]


def generated_imports():
    """(file, line) for every consumer file importing the generated client."""
    out = []
    for root in CONSUMERS:
        for f in sorted(root.rglob('*.dart')):
            for line in f.read_text().splitlines():
                if 'package:stream_chat/open_api/' in line:
                    out.append((f, line.strip()))
    return out


def stale_adapters():
    """(file, group) for every temporary adapter whose removing group is done."""
    readme = (OUT / 'README.md').read_text()
    done = set(re.findall(r'^\| \[(\d+)\]\([^)]*\) \|.*\| ☑ \|$', readme, re.MULTILINE))
    out = []
    for f in sorted(PKG.glob('lib/**/*.dart')):
        for m in ADAPTER_TODO.finditer(f.read_text()):
            if m.group(1) in done:
                out.append((f, m.group(1)))
    return out


def main():
    check_only = '--check' in sys.argv
    if not GENERATED_API.exists():
        sys.exit(f'{GENERATED_API} not found — run from the repo root.')

    hand, ops = read_handwritten(), read_generated()

    if not check_only:
        for g in GROUPS:
            (OUT / f"{g['num']}-{g['slug']}.md").write_text(render(g, hand, ops))

    claimed_ops = {}
    claimed_methods = {}
    for g in GROUPS:
        for o in [o for o in ops if g['match'](o[1])]:
            claimed_ops.setdefault((o[0], o[1]), []).append(g['num'])
        for f, n, _ in hand_for(g, hand):
            claimed_methods.setdefault((f, n), []).append(g['num'])

    all_methods = {(f, n) for f, ms in hand.items() for n, _ in ms}
    problems = []
    for k, v in claimed_ops.items():
        if len(v) > 1:
            problems.append(f'operation claimed by {v}: {k[0]} {k[1]}')
    for o in ops:
        if (o[0], o[1]) not in claimed_ops:
            problems.append(f'operation unclaimed: {o[0]} {o[1]}')
    for k, v in claimed_methods.items():
        if len(v) > 1:
            problems.append(f'method claimed by {v}: {k[0]}::{k[1]}')
    for k in sorted(all_methods - set(claimed_methods)):
        problems.append(f'method unclaimed: {k[0]}::{k[1]}')
    for line in generated_exports():
        problems.append(f'barrel exports the generated client: {line}')
    for f, line in generated_imports():
        problems.append(f'{f} imports the generated client: {line}')
    for f, group in stale_adapters():
        problems.append(f'{f} keeps an adapter group {group} was meant to remove')

    print(f'groups: {len(GROUPS)}')
    print(f'hand-written methods: {len(all_methods)} across {len(hand)} files')
    print(f'generated operations: {len(ops)}')
    print(f'problems: {len(problems)}')
    for p_ in problems:
        print(f'  {p_}')
    return 1 if problems else 0


if __name__ == '__main__':
    sys.exit(main())
