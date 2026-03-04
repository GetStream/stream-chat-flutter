# Reaction Picker Migration Guide

This guide covers the migration for the redesigned reaction picker and reaction indicator components in Stream Chat Flutter SDK.

---

## Table of Contents

- [Quick Reference](#quick-reference)
- [StreamChatConfigurationData](#streamchatconfigurationdata)
- [Removed Icon-List APIs](#removed-icon-list-apis)
- [ReactionIconResolver and DefaultReactionIconResolver](#reactioniconresolver-and-defaultreactioniconresolver)
- [StreamReactionPicker](#streamreactionpicker)
- [StreamReactionIndicator](#streamreactionindicator)
- [New Components](#new-components)
- [Migration Checklist](#migration-checklist)

---

## Quick Reference

| Symbol | Change |
|--------|--------|
| `StreamChatConfigurationData.reactionIcons` | **Removed** — replaced by `reactionIconResolver` |
| `StreamChatConfigurationData.reactionIconResolver` | **New** — optional (default: `DefaultReactionIconResolver()`). Replaces `reactionIcons` |
| `ReactionIconResolver` | **New** — abstract contract for mapping reaction type → widget/emoji |
| `DefaultReactionIconResolver` | **New** — ready-to-use default; extend to customize `defaultReactions`, `emojiCode`, or rendering hooks |
| `ReactionPickerIconList` / `ReactionIndicatorIconList` | **Removed** — list rendering now lives inside picker/indicator widgets |
| `ReactionPickerIcon` / `ReactionIndicatorIcon` | **Removed** — use resolver-based reaction mapping instead |
| `StreamReactionPicker` | **Changed** — reaction set from `config.reactionIconResolver.defaultReactions` only |
| `StreamReactionIndicator` | **Changed** — uses `config.reactionIconResolver.resolve(context, type)` only |
| `ReactionDetailSheet` | **New** — `ReactionDetailSheet.show()` for reaction details bottom sheet |

> **Note:** If you were using default reactions only, behavior stays the same (`like`, `haha`, `love`, `wow`, `sad`). Migration is required only for custom reaction icon/type setups.

---

## StreamChatConfigurationData

### Breaking Changes:

- `reactionIcons` **removed** — was a list of reaction type + builder pairs for picker/indicator
- `reactionIconResolver` **new** — optional; defaults to `DefaultReactionIconResolver()`. All reaction UI uses it

### Migration

**Before:**
```dart
StreamChat(
  client: client,
  streamChatConfigData: StreamChatConfigurationData(
    reactionIcons: [ /* type + builder per reaction */ ],
  ),
  child: MyApp(),
)
```

**After:**
```dart
StreamChat(
  client: client,
  streamChatConfigData: StreamChatConfigurationData(
    reactionIconResolver: const MyReactionIconResolver(),
  ),
  child: MyApp(),
)
```

Extend `DefaultReactionIconResolver` (see below), pass as `reactionIconResolver`. Omit to keep defaults.

> **Important:**
> - Resolver replaces the old list: use `defaultReactions` + `resolve(context, type)` (which uses `emojiCode(type)`)

---

## Removed Icon-List APIs

### Breaking Changes:

- `ReactionPickerIconList` and `ReactionIndicatorIconList` were removed
- `ReactionPickerIcon` and `ReactionIndicatorIcon` were removed
- Per-widget icon list injection moved to a single global resolver (`StreamChatConfigurationData.reactionIconResolver`)

### Migration

**Before:**
```dart
StreamChat(
  client: client,
  streamChatConfigData: StreamChatConfigurationData(
    reactionIcons: [
      // old reaction icon entries
    ],
  ),
  child: MyApp(),
)
```

**After:**
```dart
class MyReactionIconResolver extends DefaultReactionIconResolver {
  const MyReactionIconResolver();

  @override
  Set<String> get defaultReactions => const {'like', 'love', 'celebrate'};

  @override
  String? emojiCode(String type) {
    if (type == 'celebrate') return '🎉';
    return super.emojiCode(type);
  }
}

StreamChat(
  client: client,
  streamChatConfigData: StreamChatConfigurationData(
    reactionIconResolver: const MyReactionIconResolver(),
  ),
  child: MyApp(),
)
```

---

## ReactionIconResolver and DefaultReactionIconResolver

Picker uses `defaultReactions`; picker and indicator call `resolve(context, type)` → uses `emojiCode(type)` then `buildEmojiReaction` or `buildFallbackReaction`. Extend `DefaultReactionIconResolver` and override only what you need.

### Contract

- **`defaultReactions`** — types in quick-pick bar. Every type here must be resolvable by `emojiCode(type)` (return non-null emoji) or fallback is shown.
- **`emojiCode(type)`** — return Unicode emoji (e.g. `'👍'`) or `null`. Used by `resolve`.
- **`supportedReactions`** — full resolver-supported type set. Keep this in sync with your resolver implementation.
- **`resolve(context, type)`** — widget for display. Default: `emojiCode(type)` → `buildEmojiReaction` else `buildFallbackReaction`.

Override points on `DefaultReactionIconResolver`: `defaultReactions`, `emojiCode`, `buildEmojiReaction`, `buildFallbackReaction`, `supportedReactions`.

### Migration (custom quick-pick set)

Restrict `defaultReactions` to keys in `streamSupportedEmojis` so inherited `emojiCode` returns the emoji.

**Before:** Custom list of reaction types on config or picker.

**After:**
```dart
class MyReactionIconResolver extends DefaultReactionIconResolver {
  const MyReactionIconResolver();
  static const _defaults = {'like', 'haha', 'love', 'wow', 'sad'};

  @override
  Set<String> get defaultReactions => _defaults;
}
// StreamChatConfigurationData(reactionIconResolver: const MyReactionIconResolver(), ...)
```

> **Important:** If you add a type not in `streamSupportedEmojis`, override `emojiCode` to return the Unicode emoji for it (see next section).

### Migration (custom types not in streamSupportedEmojis)

Override `defaultReactions` (and/or `supportedReactions`) and `emojiCode` so every type has an emoji.

**After:**
```dart
class MyReactionIconResolver extends DefaultReactionIconResolver {
  const MyReactionIconResolver();
  static const _defaults = {'like', 'love', 'custom_celebration'};
  static const _supported = {'like', 'love', 'custom_celebration'};
  static const _customEmojis = {'custom_celebration': '🎉'};

  @override
  Set<String> get defaultReactions => _defaults;

  @override
  Set<String> get supportedReactions => _supported;

  @override
  String? emojiCode(String type) => _customEmojis[type] ?? streamSupportedEmojis[type]?.emoji;
}
```

### Migration (custom rendering, e.g. Twemoji)

For type-based custom rendering (e.g. Twemoji assets keyed by reaction type),
override `resolve(context, type)` and branch by `type`.

**After:**
```dart
class MyReactionIconResolver extends DefaultReactionIconResolver {
  const MyReactionIconResolver();

  @override
  Widget resolve(BuildContext context, String type) {
    switch (type) {
      case 'love':
        return MyTwemojiWidget(assetName: 'heart');
      case 'haha':
        return MyTwemojiWidget(assetName: 'joy');
      default:
        return super.resolve(context, type);
    }
  }
}
```

---

## StreamReactionPicker

### Breaking Changes:

- Picker icons are no longer configured with per-widget icon models
- Quick-pick entries now come from `config.reactionIconResolver.defaultReactions`

### Migration

**Before:**
```dart
StreamChat(
  client: client,
  streamChatConfigData: StreamChatConfigurationData(
    reactionIcons: [ /* old icon list */ ],
  ),
  child: MyApp(),
)
```

**After:**
```dart
StreamChat(
  client: client,
  streamChatConfigData: StreamChatConfigurationData(
    reactionIconResolver: const MyReactionIconResolver(),
  ),
  child: MyApp(),
)
```

Then keep picker usage unchanged:

```dart
StreamReactionPicker(
  message: message,
  onReactionPicked: onReactionPicked,
)
```

Set `reactionIconResolver` on `StreamChatConfigurationData` to customize.

---

## StreamReactionIndicator

### Breaking Changes:

- Indicator icons are resolved only through `config.reactionIconResolver.resolve(context, type)`
- Old icon-list based customization paths were removed

### Migration

**Before:**
```dart
StreamChat(
  client: client,
  streamChatConfigData: StreamChatConfigurationData(
    reactionIcons: [ /* old icon list */ ],
  ),
  child: MyApp(),
)
```

**After:**
```dart
StreamChat(
  client: client,
  streamChatConfigData: StreamChatConfigurationData(
    reactionIconResolver: const MyReactionIconResolver(),
  ),
  child: MyApp(),
)
```

Then keep indicator usage unchanged:

```dart
StreamReactionIndicator(
  message: message,
  onTap: onTap,
)
```

Customize via `reactionIconResolver` in config.

---

## New Components

### ReactionDetailSheet

Bottom sheet: reaction counts, filter chips per type, list of users. Returns `Future<MessageAction?>` (e.g. `SelectReaction`).

```dart
final action = await ReactionDetailSheet.show(
  context: context,
  message: message,
  initialReactionType: selectedType, // optional
);
if (action is SelectReaction) handleSelectReaction(action);
```

### ReactionIconResolver / DefaultReactionIconResolver

Exported for `StreamChatConfigurationData`. See [ReactionIconResolver and DefaultReactionIconResolver](#reactioniconresolver-and-defaultreactioniconresolver).

---

## Migration Checklist

- [ ] Remove `reactionIcons` from `StreamChatConfigurationData`
- [ ] Custom quick-pick: extend `DefaultReactionIconResolver`, override `defaultReactions` with types from `streamSupportedEmojis` (so `emojiCode` returns emoji); set `reactionIconResolver`
- [ ] Custom types not in `streamSupportedEmojis`: also override `emojiCode` to return Unicode emoji for each; optionally `supportedReactions`
- [ ] Custom rendering (e.g. Twemoji): extend `DefaultReactionIconResolver`, override `resolve(context, type)` and branch by type, set `reactionIconResolver`
- [ ] Remove old icon-list based customization and configure reactions via `reactionIconResolver` only
- [ ] Optionally use `ReactionDetailSheet.show()`
