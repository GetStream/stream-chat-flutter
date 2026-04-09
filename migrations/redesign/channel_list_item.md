# Channel List Item Migration Guide

This guide covers the migration for the redesigned channel list item components in Stream Chat Flutter SDK.

---

## Table of Contents

- [Quick Reference](#quick-reference)
- [StreamChannelListTile → StreamChannelListItem](#streamchannellisttile--streamchannellistitem)
- [Customizing Slots](#customizing-slots)
- [Low-level Presentational Component](#low-level-presentational-component)
- [Theme Migration](#theme-migration)
- [Migration Checklist](#migration-checklist)

---

## Quick Reference

| Old | New |
|-----|-----|
| `StreamChannelListTile` | `StreamChannelListItem` |
| Constructor props: `leading`, `title`, `subtitle`, `trailing` | `StreamChannelListItemProps` (via `StreamComponentFactory`) |
| `tileColor`, `visualDensity`, `contentPadding` | Removed — use `StreamChannelListItemThemeData` |
| `selectedTileColor` | Removed — use `StreamChannelListItemThemeData.backgroundColor` |
| `unreadIndicatorBuilder` | Removed |
| `StreamChannelPreviewThemeData` | `StreamChannelListItemThemeData` |
| `StreamChannelPreviewTheme.of(context)` | `StreamChannelListItemTheme.of(context)` |
| `StreamChatThemeData.channelPreviewTheme` | `StreamChatThemeData.channelListItemTheme` |

---

## StreamChannelListTile → StreamChannelListItem

The old `StreamChannelListTile` accepted all slot widgets directly in its constructor. The new `StreamChannelListItem` takes only the essential interaction properties. Slot customization is now done via `StreamChannelListItemProps` and the `StreamComponentFactory`.

### Breaking Changes

- `leading`, `title`, `subtitle`, `trailing` removed from constructor
- `tileColor` removed — use `StreamChannelListItemThemeData.backgroundColor`
- `visualDensity` removed
- `contentPadding` removed
- `selectedTileColor` removed
- `unreadIndicatorBuilder` removed
- `sendingIndicatorBuilder` removed from constructor — pass via `StreamChannelListItemProps`

### Migration

**Before:**
```dart
StreamChannelListTile(
  channel: channel,
  onTap: () => openChannel(channel),
  onLongPress: () => showOptions(channel),
  tileColor: Colors.white,
  selectedTileColor: Colors.blue.shade50,
  selected: isSelected,
  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
  leading: StreamChannelAvatar(channel: channel),
  title: StreamChannelName(channel: channel),
  subtitle: ChannelListTileSubtitle(channel: channel),
  trailing: ChannelLastMessageDate(channel: channel),
)
```

**After:**
```dart
StreamChannelListItem(
  channel: channel,
  onTap: () => openChannel(channel),
  onLongPress: () => showOptions(channel),
  selected: isSelected,
)
```

---

## Customizing Slots

To customize the slot widgets (avatar, title, subtitle, timestamp), provide a custom builder via `StreamComponentFactory`:

**Before:**
```dart
StreamChannelListTile(
  channel: channel,
  leading: MyCustomAvatar(channel: channel),
  subtitle: MyCustomSubtitle(channel: channel),
)
```

**After:**
```dart
StreamComponentFactory(
  builders: StreamComponentBuilders(
    extensions: streamChatComponentBuilders(
      channelListItem: (context, props) => StreamChannelListTile(
        avatar: StreamChannelAvatar(channel: props.channel),
        title: Text(props.channel.name ?? ''),
        subtitle: Text(props.channel.lastMessageAt?.toString() ?? ''),
      ),
    ),
  ),
  child: ...,
)
```

---

## Low-level Presentational Component

The new `StreamChannelListTile` is a low-level component that renders pre-resolved data without any channel-specific logic. Use this when you want to display a channel-shaped list item with fully controlled content (e.g., in a skeleton loader or a custom list):

```dart
StreamChannelListTile(
  avatar: StreamChannelAvatar(channel: channel),
  title: Text('General'),
  subtitle: Text('Last message preview'),
  timestamp: Text('9:41 AM'),
  unreadCount: 3,
  isMuted: false,
  onTap: () {},
)
```

> **Note:** This widget does not subscribe to any streams — all values must be provided explicitly.

---

## Theme Migration

`StreamChannelPreviewThemeData` has been replaced by `StreamChannelListItemThemeData`. Additionally, the `StreamChannelPreviewTheme` inherited widget itself is deprecated — replace it with `StreamChannelListItemTheme`.

### Property Mapping

| Old (`StreamChannelPreviewThemeData`) | New (`StreamChannelListItemThemeData`) |
|---------------------------------------|----------------------------------------|
| `titleStyle` | `titleStyle` |
| `subtitleStyle` | `subtitleStyle` |
| `lastMessageAtStyle` | `timestampStyle` |
| `avatarTheme` | Removed — use `StreamAvatarThemeData` directly |
| `unreadCounterColor` | Removed — use `StreamBadgeNotificationThemeData` |
| `indicatorIconSize` | Removed |
| `lastMessageAtFormatter` | Removed from theme — pass to `ChannelLastMessageDate(formatter: ...)` |

### New Properties

| Property | Type | Description |
|----------|------|-------------|
| `backgroundColor` | `WidgetStateProperty<Color?>?` | Background color resolved per state (default, hover, pressed, selected) |
| `borderColor` | `Color?` | Bottom border color |
| `muteIconPosition` | `MuteIconPosition?` | Whether the mute icon appears in `title` or `subtitle` row |

### Global Theme Migration

**Before:**
```dart
StreamChatTheme(
  data: StreamChatThemeData(
    channelPreviewTheme: StreamChannelPreviewThemeData(
      titleStyle: TextStyle(fontWeight: FontWeight.bold),
      subtitleStyle: TextStyle(color: Colors.grey),
      lastMessageAtStyle: TextStyle(fontSize: 12),
      unreadCounterColor: Colors.red,
    ),
  ),
  child: ...,
)
```

**After:**
```dart
StreamChatTheme(
  data: StreamChatThemeData(
    channelListItemTheme: StreamChannelListItemThemeData(
      titleStyle: TextStyle(fontWeight: FontWeight.bold),
      subtitleStyle: TextStyle(color: Colors.grey),
      timestampStyle: TextStyle(fontSize: 12),
      // unreadCounterColor → customize via StreamBadgeNotificationThemeData
    ),
  ),
  child: ...,
)
```

### Subtree Theme Override

**Before:**
```dart
StreamChannelPreviewTheme(
  data: StreamChannelPreviewThemeData(
    titleStyle: TextStyle(color: Colors.blue),
  ),
  child: StreamChannelListView(...),
)
```

**After:**
```dart
StreamChannelListItemTheme(
  data: StreamChannelListItemThemeData(
    titleStyle: TextStyle(color: Colors.blue),
  ),
  child: StreamChannelListView(...),
)
```

### Background and Selected Color

**Before:**
```dart
StreamChannelListTile(
  channel: channel,
  tileColor: Colors.white,
  selectedTileColor: Colors.blue.shade50,
  selected: isSelected,
)
```

**After:**
```dart
StreamChannelListItemTheme(
  data: StreamChannelListItemThemeData(
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return Colors.blue.shade50;
      return Colors.white;
    }),
  ),
  child: StreamChannelListItem(
    channel: channel,
    selected: isSelected,
  ),
)
```

### Custom Timestamp Formatter

**Before:**
```dart
StreamChannelPreviewThemeData(
  lastMessageAtFormatter: (context, date) {
    return Jiffy.parseFromDateTime(date).format('d MMMM');
  },
)
```

**After:**
```dart
// Pass directly to the widget — no longer a theme property
ChannelLastMessageDate(
  channel: channel,
  formatter: (context, date) {
    return Jiffy.parseFromDateTime(date).format('d MMMM');
  },
)
```

---

## Migration Checklist

- [ ] Replace `StreamChannelListTile` with `StreamChannelListItem`
- [ ] Remove `tileColor`, `visualDensity`, `contentPadding`, `selectedTileColor`, `unreadIndicatorBuilder` parameters
- [ ] Move slot customization (`leading`, `title`, `subtitle`, `trailing`) to `StreamComponentFactory`
- [ ] Replace `StreamChannelPreviewTheme` inherited widget with `StreamChannelListItemTheme` — `StreamChannelPreviewTheme` is `@Deprecated` and will be removed in a future release
- [ ] Replace `StreamChatThemeData.channelPreviewTheme` with `StreamChatThemeData.channelListItemTheme`
- [ ] Rename `lastMessageAtStyle` to `timestampStyle`
- [ ] Move `lastMessageAtFormatter` from theme to `ChannelLastMessageDate(formatter: ...)`
- [ ] Replace `tileColor`/`selectedTileColor` with `StreamChannelListItemThemeData.backgroundColor` using `WidgetStateProperty`
- [ ] Replace `unreadCounterColor` with `StreamBadgeNotificationThemeData`
- [ ] Replace `avatarTheme` in `StreamChannelPreviewThemeData` with `StreamAvatarThemeData` on the avatar widget directly
