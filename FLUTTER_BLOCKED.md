# Workarounds blocked on a Flutter release

Workarounds that exist only because an upstream Flutter fix has not shipped. The
[`flutter-version-bump`](.claude/skills/flutter-version-bump/SKILL.md) floor raise reads
this to decide what is now removable.

One registry for the whole monorepo: append an entry with the same fields, never add a
file. Tag the code site `// TODO(flutter):` too, so `grep -rn 'TODO(flutter)'` finds it if
this file drifts. Delete the entry when the workaround goes — git history is the archive.

## `SelectionArea` keyed on `BrowserContextMenu.enabled`

- **Removable at:** Flutter 3.48 — predicted, not confirmed
- **Site:** `packages/stream_chat_flutter/lib/src/message_widget/components/stream_message_text.dart`
- **Upstream:** [flutter#186459](https://github.com/flutter/flutter/issues/186459), fixed by [flutter#186553](https://github.com/flutter/flutter/pull/186553) (`2a469b88`)
- **Confirm the release:** `git tag --contains 2a469b88` in a Flutter checkout — empty as of 3.47.1
- **Verify removal:** needs the browser test in FLU-713; the VM test passes even with the key hardcoded
- **Keep:** `_BrowserContextMenu` in `context_menu_region.dart` — reference counting, not Flutter-blocked
- **Tracked:** FLU-710, [#2906](https://github.com/GetStream/stream-chat-flutter/issues/2906)
