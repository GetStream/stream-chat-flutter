#!/usr/bin/env python3
"""Regenerates the scope tables in openapi-migration/*.md from the SDK itself.

    python3 openapi-migration/tool/generate_plan.py            # regenerate + report
    python3 openapi-migration/tool/generate_plan.py --check     # report only, non-zero on a gap

Run from the repo root. Prose sections (goal, decisions, risks) live in GROUPS
below; the tables are always derived from the code, so they cannot drift.

The report asserts two invariants:
  * every public method in the hand-written api layer belongs to exactly one group
  * every operation in the generated client is claimed by exactly one group

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


def read_handwritten():
    """{file: [(method, returnType)]} for the hand-written api layer."""
    out = {}
    sources = sorted(API_DIR.glob('*_api.dart')) + [API_DIR / 'attachment_file_uploader.dart']
    for f in sources:
        methods = [
            (m.group(2), m.group(1))
            for m in re.finditer(r'\n  Future<([^>]+)>\s+(\w+)\(', f.read_text())
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


GROUPS = [
    dict(
        num='02', slug='devices-and-push-preferences', title='Devices & Push Preferences',
        hand=['device_api.dart'],
        match=owns('/api/v2/devices', '/api/v2/push_preferences'),
        goal='Prove the whole pattern end to end on the smallest real surface: four methods, no persistence, '
             'no channel scope.',
        decisions=[
            '`PushProvider` (our public enum) against the generated per-operation extension type — write the '
            'adapter here, it sets the precedent for every enum that follows.',
            '`setPushPreferences` reads its response into client state and emits `EventType.pushPreferenceUpdated`; '
            'decide whether that stays in the api layer or moves up.',
        ],
        risks=[
            "Generated `DeviceResponse` has 9 fields against our `Device`'s 2 — drop or widen, and record which.",
        ],
    ),
    dict(
        num='03', slug='user-groups', title='User Groups',
        hand=['user_groups_api.dart'],
        match=owns('/api/v2/usergroups'),
        goal='A clean 1:1 group — eight methods against eight generated operations, no client state, '
             'no persistence.',
        decisions=[
            'Several generated responses (`AddUserGroupMembersResponse`, `CreateUserGroupResponse`, …) wrap the '
            'same `UserGroupResponse`; decide whether our public API keeps distinct types or collapses them.',
        ],
        risks=[
            '`UserGroup` and `UserGroupMember` collide by name with generated types — the export decision lands '
            'here first.',
        ],
    ),
    dict(
        num='04', slug='roles-guest-and-app', title='Roles, Guest & App Settings',
        hand=['roles_api.dart', 'guest_api.dart',
              'general_api.dart::enrichUrl', 'general_api.dart::getAppSettings'],
        match=owns('/api/v2/roles', '/api/v2/guest', '/api/v2/app', '/api/v2/og', '/api/v2/longpoll'),
        goal='Sweep up the singletons — one-method families that share no state and can land in one PR.',
        decisions=[
            '`AppSettings` is public and hand-shaped; the generated `AppResponseFields` is the wire shape. Keep '
            'ours unless the generated one is genuinely better.',
        ],
        risks=[
            '`general_api.dart` is split across four groups — only `enrichUrl` and `getAppSettings` belong here. '
            '`sync` and `queryMembers` go to group 11, `searchMessages` to group 10. Do not migrate the file as a '
            'unit.',
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
                   '/api/v2/chat/query_banned_users', '/api/v2/chat/query_future_channel_bans'),
        goal='The largest generated surface relative to ours — decide what stays unexposed.',
        decisions=[
            'Most generated moderation operations have no hand-written counterpart. Decide explicitly which we '
            'expose now and which stay internal; do not surface ~20 new public methods as a side effect of '
            'migrating 11.',
            'Flag/unflag was deprecated recently on our side — check its current state before mapping it.',
        ],
        risks=[
            '`query_banned_users` may omit the `created_at_after` / `created_at_before` filters our request sends; '
            'verify before migrating or those filters silently disappear.',
        ],
    ),
    dict(
        num='09', slug='users', title='Users',
        hand=['user_api.dart'],
        match=owns('/api/v2/users', '/api/v2/chat/unread'),
        goal='`User` is the most widely referenced public model in the SDK; this is where keep-vs-adopt costs the '
             'most.',
        decisions=[
            '`User` and `OwnUser` are public, persisted, and embedded in nearly every other response. The '
            'decision is made in 01-foundation and frozen there; this group executes it.',
            '`PrivacySettings` and the push-preference sub-shapes — decide per type.',
        ],
        risks=[
            'Every other group depends on the `User` decision.',
            'User data arrives over the WebSocket on nearly every event.',
        ],
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
        ],
        risks=[
            '`message_api.dart` also holds the four draft methods, which belong to group 07 — leave them alone '
            'here.',
            'Attachment `custom`/`extraData` promotion is the known hard part of the whole migration.',
            'Message send has offline and retry paths through `stream_chat_persistence` that must keep working.',
        ],
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
            '`sync` returns `SyncResponse` — one of the two models that needed the WSEvent generator patch. '
            'Verify it decodes before relying on it.',
        ],
        risks=[
            '`sync` and `queryMembers` live in `general_api.dart`, not `channel_api.dart` — this group reaches '
            'into that file.',
            '`queryChannels` drives the channel list controllers and the offline cache; a shape change here is '
            'felt everywhere.',
            'Channel `custom`/`extraData` promotion, same class of problem as messages.',
        ],
    ),
    dict(
        num='12', slug='uploads-cdn', title='Uploads (CDN)',
        hand=['attachment_file_uploader.dart'],
        match=owns('/api/v2/uploads', '/api/v2/chat/channels/{type}/{id}/file',
                   '/api/v2/chat/channels/{type}/{id}/image'),
        goal='Move file and image uploads to v2 behind a hand-written retrofit multipart client.',
        decisions=[
            '`AttachmentFileUploader` is public and pluggable through `attachmentFileUploaderProvider`; changing '
            'its signature is a break that needs the usual justification.',
            'The v2 multipart schema defines only `file`, `upload_sizes` and `user`, but our public `sendImage` / '
            '`sendFile` accept `extraData`. Decide: drop the parameter, or keep those two calls on v1.',
        ],
        risks=[
            'Attachment upload is the highest-traffic path in the SDK; a regression is immediately visible to end '
            'users.',
            'The generated `uploadFile` / `uploadChannelFile` take a JSON body with no progress or cancellation, '
            'so this group cannot use them — it needs its own `CdnApi`.',
        ],
    ),
]

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
    """)


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
        '> Tables are generated by `openapi-migration/tool/generate_plan.py`. Edit the prose, not the tables.\n',
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
    L.append('\n## Decisions to make\n')
    L += [f'- {d}' for d in g['decisions']]
    L.append('\n## Risks\n')
    L += [f'- {r}' for r in g['risks']]
    L.append('\n## Definition of done\n')
    L.append(DONE)
    return '\n'.join(L)


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

    print(f'groups: {len(GROUPS)}')
    print(f'hand-written methods: {len(all_methods)} across {len(hand)} files')
    print(f'generated operations: {len(ops)}')
    print(f'problems: {len(problems)}')
    for p_ in problems:
        print(f'  {p_}')
    return 1 if problems else 0


if __name__ == '__main__':
    sys.exit(main())
