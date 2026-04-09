# Headers, Icons & Configuration Migration Guide

This guide covers several cross-cutting API changes in the Stream Chat Flutter SDK design refresh: the icon system migration, header widget defaults, the new `StreamChat.componentBuilders` parameter, and new `StreamChatConfigurationData` fields.

---

## Table of Contents

- [StreamSvgIcon Deprecated](#streamsvgicon-deprecated)
- [Header Widgets](#header-widgets)
- [StreamChat.componentBuilders](#streamchatcomponentbuilders)
- [StreamChatConfigurationData New Fields](#streamchatconfigurationdata-new-fields)
- [Migration Checklist](#migration-checklist)

---

## StreamSvgIcon Deprecated

`StreamSvgIcon` and `StreamSvgIcons` are now `@Deprecated`. Replace all usages with the standard Flutter `Icon` widget and the new `StreamIcons` token set accessed via `context.streamIcons`.

### Breaking Change

`StreamSvgIcon` is deprecated — usages will produce deprecation warnings. The class will be removed in a future release.

### Migration

**Before:**
```dart
StreamSvgIcon(icon: StreamSvgIcons.reply)
StreamSvgIcon(icon: StreamSvgIcons.copy, color: Colors.red, size: 24)
```

**After:**
```dart
Icon(context.streamIcons.reply20)
Icon(context.streamIcons.copy20, color: Colors.red, size: 24)
```

`context.streamIcons` is a `StreamIcons` extension on `BuildContext` — it reads from the nearest `StreamTheme` in the widget tree.

### Icon Name Mapping

| Old (`StreamSvgIcons.*`) | New (`context.streamIcons.*`) |
|--------------------------|-------------------------------|
| `arrowRight` | `arrowRight20` |
| `attach` | `attachment20` |
| `award` | `trophy20` |
| `camera` | `camera20` |
| `check` | `checkmark20` |
| `checkAll` | `checks20` |
| `checkSend` | `checkmark20` |
| `circleUp` | `arrowUp20` |
| `close` | `xmark20` |
| `closeSmall` | `xmark16` |
| `contacts` | `users20` |
| `copy` | `copy20` |
| `delete` | `delete20` |
| `down` | `chevronDown20` |
| `download` | `download20` |
| `edit` | `edit20` |
| `emptyCircleRight` | `chevronRight20` |
| `error` | `exclamationCircleFill20` |
| `eye` | `eyeFill20` |
| `files` | `file20` |
| `flag` | `flag20` |
| `grid` | `gallery20` |
| `group` | `users20` |
| `left` | `chevronLeft20` |
| `lightning` | `bolt20` |
| `link` | `link20` |
| `lock` | `lock20` |
| `mentions` | `mention20` |
| `menuPoint` | `more20` |
| `message` | `messageBubble20` |
| `messageUnread` | `notification20` |
| `mic` | `voice20` |
| `mute` | `mute20` |
| `notification` | `bell20` |
| `pause` | `pauseFill20` |
| `penWrite` | `edit20` |
| `pictures` | `image20` |
| `pin` | `pin20` |
| `play` | `playFill20` |
| `polls` | `poll20` |
| `record` | `video20` |
| `reload` | `refresh20` |
| `reply` | `reply20` |
| `retry` | `retry20` |
| `right` | `chevronRight20` |
| `save` | `save20` |
| `search` | `search20` |
| `send` | `send20` |
| `sendMessage` | `send20` |
| `share` | `export20` |
| `shareArrow` | `share20` |
| `smile` | `emoji20` |
| `stop` | `stopFill20` |
| `threadReply` | `thread20` |
| `time` | `clock20` |
| `up` | `chevronUp20` |
| `user` | `user20` |
| `userAdd` | `userAdd20` |
| `userDelete` | `userRemove20` |
| `userRemove` | `userRemove20` |
| `userSettings` | `userCheck20` |
| `videoCall` | `videoFill20` |
| `volumeUp` | `audio20` |

The following icons have been **removed with no equivalent** in the new set:
`cloudDownload`, `lolReaction`, `loveReaction`, `moon`, `settings`, `thumbsDownReaction`, `thumbsUpReaction`, `wutReaction`.

---

## Header Widgets

`StreamChannelHeader`, `StreamChannelListHeader`, and `StreamThreadHeader` all received the same set of default-value changes.

### Breaking Changes

| Parameter | Old default | New default | Notes |
|-----------|-------------|-------------|-------|
| `centerTitle` | `bool?` (`null` → platform-adaptive) | `bool` (`true`) | Was `null` by default, which let Flutter centre on iOS and left-align on Android. Now always `true` — explicitly pass `centerTitle: false` to restore left-aligned titles. |
| `elevation` | `1` | `0` | Removes the drop shadow by default. Pass `elevation: 1` to restore the old appearance. |
| `scrolledUnderElevation` | — | `0` (new param) | Controls the elevation when content is scrolled under the header. |

### Migration

```dart
// Before: title was platform-adaptive, header had a shadow
StreamChannelHeader()
StreamChannelListHeader()
StreamThreadHeader(parent: parentMessage)

// After: title always centred, no shadow
// If you relied on left-aligned titles on Android, pass centerTitle: false:
StreamChannelHeader(centerTitle: false)
StreamChannelListHeader(centerTitle: false)
StreamThreadHeader(parent: parentMessage, centerTitle: false)

// If you relied on the elevation shadow, restore it:
StreamChannelHeader(elevation: 1)
```

---

## StreamChat.componentBuilders

`StreamChat` now accepts an optional `componentBuilders` parameter. When provided, it automatically inserts a `StreamComponentFactory` into the widget tree below the theme, making app-wide component customization available without wrapping the app manually.

### Migration

**Before (manual wrapping required):**
```dart
StreamComponentFactory(
  builders: StreamComponentBuilders(
    extensions: streamChatComponentBuilders(
      messageWidget: (context, props) => MyMessage(props: props),
    ),
  ),
  child: StreamChat(
    client: client,
    child: MyApp(),
  ),
)
```

**After (pass via `StreamChat` directly):**
```dart
StreamChat(
  client: client,
  componentBuilders: StreamComponentBuilders(
    extensions: streamChatComponentBuilders(
      messageWidget: (context, props) => MyMessage(props: props),
    ),
  ),
  child: MyApp(),
)
```

Both approaches are equivalent. If you already have a `StreamComponentFactory` elsewhere in the tree it continues to work. Use `componentBuilders` when `StreamChat` is your natural customization entry point.

---

## StreamChatConfigurationData New Fields

Three new optional fields have been added to `StreamChatConfigurationData`. Existing code that does not pass them will use the defaults and requires no changes.

### New Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `attachmentBuilders` | `List<StreamAttachmentWidgetBuilder>?` | `null` | Custom attachment widget builders. When non-null, these are **prepended** to the SDK's built-in builders so your types are matched first. |
| `reactionType` | `StreamReactionsType?` | `null` | Controls the visual style of the reactions display (e.g. segmented). Falls back to the SDK default when `null`. |
| `reactionPosition` | `StreamReactionsPosition?` | `null` | Controls where reactions appear relative to the message bubble (e.g. header). Falls back to the SDK default when `null`. |

> **Note:** The `imageCDN` field was also added to `StreamChatConfigurationData`. It is covered in the [Image CDN & Thumbnails](image_cdn.md) guide.

### Migration

```dart
// Before: no attachment builder or reaction customization on the config
StreamChat(
  client: client,
  streamChatConfigData: StreamChatConfigurationData(
    enforceUniqueReactions: false,
  ),
  child: MyApp(),
)

// After: optionally add the new fields
StreamChat(
  client: client,
  streamChatConfigData: StreamChatConfigurationData(
    enforceUniqueReactions: false,
    attachmentBuilders: [MyCustomAttachmentBuilder()],
    reactionType: StreamReactionsType.segmented,
    reactionPosition: StreamReactionsPosition.header,
  ),
  child: MyApp(),
)
```

---

## Migration Checklist

- [ ] Replace all `StreamSvgIcon(icon: StreamSvgIcons.*)` with `Icon(context.streamIcons.*)` using the mapping table above
- [ ] If you relied on platform-adaptive `centerTitle` behaviour on `StreamChannelHeader` / `StreamChannelListHeader` / `StreamThreadHeader`, pass `centerTitle: false` explicitly for Android-style left-aligned titles
- [ ] If you relied on the `elevation: 1` shadow on headers, pass `elevation: 1` explicitly
- [ ] Optionally move `StreamComponentFactory` wrapping into the `componentBuilders` parameter on `StreamChat`
- [ ] Use the new `attachmentBuilders`, `reactionType`, and `reactionPosition` fields on `StreamChatConfigurationData` if you need custom attachment rendering or global reaction style control
