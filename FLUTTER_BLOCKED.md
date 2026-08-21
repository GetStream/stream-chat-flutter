# Workarounds blocked on a Flutter release

Every workaround in this repo that exists only because an upstream Flutter fix has not
shipped yet. Each one is removable the moment our published minimum Flutter includes the
fix, so this file is the checklist for the floor raise in the
[`flutter-version-bump`](.claude/skills/flutter-version-bump/SKILL.md) workflow.

Code sites are tagged `// TODO(flutter): …`, so `grep -rn 'TODO(flutter)' packages/` finds
them all even if this file falls behind. Keep both in sync: add the tag *and* a row here.

This is the single registry for the whole monorepo — every workaround lives here, not in a
file of its own. There is one entry today; that is the current count, not the format.

## Adding an entry

Append a row to the table and a `###` section below it, matching the shape of the existing
one. A section is worth writing only if it answers the four questions the person deleting
the workaround will have: what breaks without it, which upstream release fixes it, how to
confirm that release really carries the fix, and what must *not* be deleted alongside it.

When a workaround is removed, delete its row and section — git history is the archive.

## Open

| Removable at | What | Where | Upstream |
| --- | --- | --- | --- |
| Flutter 3.48 (expected) | `SelectionArea` keyed on `BrowserContextMenu.enabled` | `stream_chat_flutter` · `src/message_widget/components/stream_message_text.dart` | [#186459](https://github.com/flutter/flutter/issues/186459) → [#186553](https://github.com/flutter/flutter/pull/186553) |

### `SelectionArea` keyed on `BrowserContextMenu.enabled`

**Symptom without the workaround.** On desktop web, `Assertion failed: _selectable == null`
red-screens the message text as soon as the message list rebuilds after the browser
context menu is toggled — in practice, opening a channel and then tapping the attachment
button. Reported as [#2906](https://github.com/GetStream/stream-chat-flutter/issues/2906).

**Cause.** `SelectableRegion.build` conditionally wraps its subtree in
`PlatformSelectableRegionContextMenu` based on
`kIsWeb && BrowserContextMenu.enabled && <desktop target>`. Flipping that setting while a
`SelectionArea` is mounted re-inflates the inner `SelectionContainer` before the old one
unregisters. The regression arrived in stable **3.41.0** via
[#176855](https://github.com/flutter/flutter/pull/176855), which changed that condition
from the compile-time constant `kIsWeb` to the runtime-mutable `_webContextMenuEnabled`.

**Workaround.** `key: ValueKey(BrowserContextMenu.enabled)` on the `SelectionArea`, so a
flip *replaces* the region — fresh state, nothing registered — instead of restructuring a
live one.

**Upstream fix.** [#186553](https://github.com/flutter/flutter/pull/186553), merged
2026-08-07, adds a `GlobalKey` to the internal `SelectableRegionSelectionStatusScope` so
the selection subtree reparents instead of being recreated. Confirm the release with
`git tag --contains 2a469b880c19cbbec6aaa6329d4a4a9d1db22a4e` in a Flutter checkout —
empty as of 3.47.1, so 3.48 is expected but **not** confirmed.

**Why it is worth removing.** Upstream's fix preserves the selection subtree and any active
selection across a flip; the key forces a full replacement, so the workaround is marginally
worse than stock Flutter once the floor moves. Not urgent — it only churns when the flag
flips, which is once per channel enter/exit on desktop web.

**How to verify the removal.** Needs a `--platform chrome` lane, tracked in FLU-713, which
carries a working browser test for exactly this transition. Do not trust the VM test
(`'StreamMessageText keys the selection area to the browser context menu state'`) to prove
the framework fix works — it passes even with the key hardcoded to a constant.

**Do not remove** the reference-counted `_BrowserContextMenu` helper in
`src/context_menu/context_menu_region.dart` along with the key. That fixes SDK-side bugs
unrelated to the framework regression and is not blocked on any Flutter release.

Tracked in FLU-710.
