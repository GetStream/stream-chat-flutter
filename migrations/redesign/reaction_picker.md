# Reaction Picker Migration Guide

This guide covers the migration for the redesigned reaction picker and reaction indicator components in Stream Chat Flutter SDK.

---

## Table of Contents

- [Quick Reference](#quick-reference)
- [StreamChatConfigurationData](#streamchatconfigurationdata)
- [Removed Icon-List APIs](#removed-icon-list-apis)
- [ReactionIconResolver and DefaultReactionIconResolver](#reactioniconresolver-and-defaultreactioniconresolver)
- [StreamMessageReactionPicker](#streammessagereactionpicker-formerly-streamreactionpicker)
- [StreamMessageReactions](#streammessagereactions)
- [New Components](#new-components)
- [Migration Checklist](#migration-checklist)

---

## Quick Reference

| Symbol                                                        | Change                                                                                                               |
| ------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `StreamChatConfigurationData.reactionIcons`                   | **Removed** — replaced by `reactionIconResolver`                                                                     |
| `StreamChatConfigurationData.reactionIconResolver`            | **New** — optional (default: `DefaultReactionIconResolver()`). Replaces `reactionIcons`                              |
| `ReactionIconResolver`                                        | **New** — abstract contract for mapping reaction type → `StreamEmojiContent`                                         |
| `DefaultReactionIconResolver`                                 | **New** — ready-to-use default; extend to customize `defaultReactions`, `emojiCode`, or `resolve`                    |
| `ReactionPickerIconList` / `ReactionIndicatorIconList`        | **Removed** — list rendering now lives inside picker/indicator widgets                                               |
| `ReactionPickerIcon` / `ReactionIndicatorIcon`                | **Removed** — use resolver-based reaction mapping instead                                                            |
| `StreamReactionPicker`                                        | **Renamed** to `StreamMessageReactionPicker` — reaction set from `config.reactionIconResolver.defaultReactions` only |
| `StreamReactionPickerTheme` / `StreamReactionPickerThemeData` | **New** (from `stream_core_flutter`) — theme-based visual customization for the picker                               |
| `StreamMessageReactions`                                      | **New** — renders emoji chips for a message's reaction groups; replaces ad-hoc indicator usage                        |
| `ReactionDetailSheet`                                         | **New** — `ReactionDetailSheet.show()` for reaction details bottom sheet                                             |

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
  configData: StreamChatConfigurationData(
    reactionIcons: [ /* type + builder per reaction */ ],
  ),
  child: MyApp(),
)
```

**After:**
```dart
StreamChat(
  client: client,
  configData: StreamChatConfigurationData(
    reactionIconResolver: const MyReactionIconResolver(),
  ),
  child: MyApp(),
)
```

Extend `DefaultReactionIconResolver` (see below), pass as `reactionIconResolver`. Omit to keep defaults.

> **Important:**
> - Resolver replaces the old list: use `defaultReactions` + `resolve(type)` (which uses `emojiCode(type)`)

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
  configData: StreamChatConfigurationData(
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
  configData: StreamChatConfigurationData(
    reactionIconResolver: const MyReactionIconResolver(),
  ),
  child: MyApp(),
)
```

---

## ReactionIconResolver and DefaultReactionIconResolver

Picker uses `defaultReactions`; picker and indicator call `resolve(type)` → uses `emojiCode(type)` to return a `StreamEmojiContent` model. Extend `DefaultReactionIconResolver` and override only what you need.

### Contract

- **`defaultReactions`** — types in quick-pick bar. Every type here must be resolvable by `emojiCode(type)` (return non-null emoji) or fallback is shown.
- **`emojiCode(type)`** — return Unicode emoji (e.g. `'👍'`) or `null`. Used by `resolve`.
- **`supportedReactions`** — full resolver-supported type set. Keep this in sync with your resolver implementation.
- **`resolve(type)`** — returns a `StreamEmojiContent` for display. Default: `emojiCode(type)` → `StreamUnicodeEmoji` else `StreamUnicodeEmoji('❓')`. Override to return `StreamImageEmoji` for custom emoji.

Override points on `DefaultReactionIconResolver`: `defaultReactions`, `emojiCode`, `resolve`, `supportedReactions`.

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
override `resolve(type)` and return `StreamImageEmoji` for custom emoji.

**After:**
```dart
class MyReactionIconResolver extends DefaultReactionIconResolver {
  const MyReactionIconResolver();

  @override
  StreamEmojiContent resolve(String type) {
    switch (type) {
      case 'love':
        return StreamImageEmoji(url: Uri.parse('https://cdn.example.com/twemoji/heart.png'));
      case 'haha':
        return StreamImageEmoji(url: Uri.parse('https://cdn.example.com/twemoji/joy.png'));
      default:
        return super.resolve(type);
    }
  }
}
```

---

## StreamMessageReactionPicker (formerly StreamReactionPicker)

### Breaking Changes:

- **Renamed** from `StreamReactionPicker` to `StreamMessageReactionPicker`
- `StreamReactionPicker` now refers to the domain-agnostic core component from `stream_core_flutter`
- Picker icons are no longer configured with per-widget icon models
- Quick-pick entries now come from `config.reactionIconResolver.defaultReactions`
- Visual properties (`backgroundColor`, `padding`, `shape`) removed from the widget — use `StreamReactionPickerTheme` instead
- The core picker now uses a `StreamComponentFactory` pattern with `StreamReactionPickerProps` for full customization

### Migration

**Before:**
```dart
StreamReactionPicker(
  message: message,
)
```

**After:**
```dart
StreamMessageReactionPicker(
  message: message,
  onReactionPicked: onReactionPicked,
)
```

Configure reactions globally via `reactionIconResolver`:

```dart
StreamChat(
  client: client,
  configData: StreamChatConfigurationData(
    reactionIconResolver: const MyReactionIconResolver(),
  ),
  child: MyApp(),
)
```

Customize visual appearance via theme:

```dart
StreamReactionPickerTheme(
  data: StreamReactionPickerThemeData(
    backgroundColor: Colors.white,
    elevation: 4,
    spacing: 2,
    shape: RoundedSuperellipseBorder(
      borderRadius: BorderRadius.all(Radius.circular(24)),
    ),
    side: BorderSide(color: Colors.grey),
  ),
  child: // ...
)
```

---

## StreamMessageReactions

`StreamMessageReactions` is the widget that renders a message's reaction groups as emoji chips overlaid on, or placed beneath, a message bubble. It replaces any prior ad-hoc indicator usage. Reaction icons are resolved through `StreamChatConfigurationData.reactionIconResolver`.

### Constructor

```dart
StreamMessageReactions({
  Key? key,
  required Message message,
  StreamReactionsType? type,         // defaults to StreamReactionsType.segmented
  StreamReactionsPosition? position, // defaults to StreamReactionsPosition.header
  Comparator<ReactionGroup>? sorting, // defaults to ReactionSorting.byFirstReactionAt
  VoidCallback? onPressed,
  Widget? child,                     // typically the message bubble
})
```

### Usage

`StreamMessageReactions` is used internally by `StreamMessageContent` and `StreamMessageScaffold`. If you need to render reactions outside the standard message widget, use it directly:

```dart
StreamMessageReactions(
  message: message,
  onPressed: () { /* show reaction detail sheet */ },
  child: myMessageBubble,
)
```

### Customization

Reaction icons are resolved globally — configure them on `StreamChatConfigurationData.reactionIconResolver` (see [ReactionIconResolver and DefaultReactionIconResolver](#reactioniconresolver-and-defaultreactioniconresolver)).

Visual layout properties (`type`, `position`) can be set per widget or as defaults via `StreamChatConfigurationData`:

```dart
StreamChat(
  client: client,
  configData: StreamChatConfigurationData(
    reactionIconResolver: const MyReactionIconResolver(),
    reactionType: StreamReactionsType.segmented,
    reactionPosition: StreamReactionsPosition.header,
  ),
  child: MyApp(),
)
```

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

- [ ] Rename `StreamReactionPicker` → `StreamMessageReactionPicker` in your code
- [ ] Remove `reactionIcons` from `StreamChatConfigurationData`
- [ ] Remove `backgroundColor`, `padding`, `shape` props from picker usage — use `StreamReactionPickerTheme` instead
- [ ] Custom quick-pick: extend `DefaultReactionIconResolver`, override `defaultReactions` with types from `streamSupportedEmojis` (so `emojiCode` returns emoji); set `reactionIconResolver`
- [ ] Custom types not in `streamSupportedEmojis`: also override `emojiCode` to return Unicode emoji for each; optionally `supportedReactions`
- [ ] Custom rendering (e.g. Twemoji): extend `DefaultReactionIconResolver`, override `resolve(type)` to return `StreamImageEmoji`, set `reactionIconResolver`
- [ ] Remove old icon-list based customization and configure reactions via `reactionIconResolver` only
- [ ] Optionally use `ReactionDetailSheet.show()`
