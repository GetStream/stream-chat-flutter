# Headers, Icons & Configuration Migration Guide

This guide covers several cross-cutting API changes in the Stream Chat Flutter SDK design refresh: the icon system migration, header widget defaults, the new `StreamChat.componentBuilders` parameter, and new `StreamChatConfigurationData` fields.

---

## Table of Contents

- [StreamSvgIcon Deprecated](#streamsvgicon-deprecated)
- [Header Widgets](#header-widgets)
- [StreamChat.componentBuilders](#streamchatcomponentbuilders)
- [StreamChatConfigurationData New Fields](#streamchatconfigurationdata-new-fields)
- [StreamChatCore Behavior Changes](#streamchatcore-behavior-changes)
- [Removed Widgets](#removed-widgets)
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
Icon(context.streamIcons.reply)
Icon(context.streamIcons.copy, color: Colors.red, size: 24)
```

`context.streamIcons` is a `StreamIcons` extension on `BuildContext` — it reads from the nearest `StreamTheme` in the widget tree.

### Icon Name Mapping

| Old (`StreamSvgIcons.*`) | New (`context.streamIcons.*`) |
| ------------------------ | ----------------------------- |
| `arrowRight`             | `arrowRight`                  |
| `attach`                 | `attachment`                  |
| `award`                  | `trophy`                      |
| `camera`                 | `camera`                      |
| `check`                  | `checkmark`                   |
| `checkAll`               | `checks`                      |
| `checkSend`              | `checkmark`                   |
| `circleUp`               | `arrowUp`                     |
| `close`                  | `xmark`                       |
| `closeSmall`             | `xmark`                       |
| `contacts`               | `users`                       |
| `copy`                   | `copy`                        |
| `delete`                 | `delete`                      |
| `down`                   | `chevronDown`                 |
| `download`               | `download`                    |
| `edit`                   | `edit`                        |
| `emptyCircleRight`       | `chevronRight`                |
| `error`                  | `exclamationCircleFill`       |
| `eye`                    | `eyeFill`                     |
| `files`                  | `file`                        |
| `flag`                   | `flag`                        |
| `grid`                   | `gallery`                     |
| `group`                  | `users`                       |
| `left`                   | `chevronLeft`                 |
| `lightning`              | `bolt`                        |
| `link`                   | `link`                        |
| `lock`                   | `lock`                        |
| `mentions`               | `mention`                     |
| `menuPoint`              | `more`                        |
| `message`                | `messageBubble`               |
| `messageUnread`          | `notification`                |
| `mic`                    | `voice`                       |
| `mute`                   | `mute`                        |
| `notification`           | `bell`                        |
| `pause`                  | `pauseFill`                   |
| `penWrite`               | `edit`                        |
| `pictures`               | `image`                       |
| `pin`                    | `pin`                         |
| `play`                   | `playFill`                    |
| `polls`                  | `poll`                        |
| `record`                 | `video`                       |
| `reload`                 | `refresh`                     |
| `reply`                  | `reply`                       |
| `retry`                  | `retry`                       |
| `right`                  | `chevronRight`                |
| `save`                   | `save`                        |
| `search`                 | `search`                      |
| `send`                   | `send`                        |
| `sendMessage`            | `send`                        |
| `share`                  | `export`                      |
| `shareArrow`             | `share`                       |
| `smile`                  | `emoji`                       |
| `stop`                   | `stopFill`                    |
| `threadReply`            | `thread`                      |
| `time`                   | `clock`                       |
| `up`                     | `chevronUp`                   |
| `user`                   | `user`                        |
| `userAdd`                | `userAdd`                     |
| `userDelete`             | `userRemove`                  |
| `userRemove`             | `userRemove`                  |
| `userSettings`           | `userCheck`                   |
| `videoCall`              | `videoFill`                   |
| `volumeUp`               | `audio`                       |

The following icons have been **removed with no equivalent** in the new set:
`cloudDownload`, `lolReaction`, `loveReaction`, `moon`, `settings`, `thumbsDownReaction`, `thumbsUpReaction`, `wutReaction`.

---

## Header Widgets

Three chat headers — `StreamChannelHeader`, `StreamChannelListHeader`, and
`StreamThreadHeader` — have been rebuilt on top of the new design system's
`StreamAppBar`. They now share a single slot model (`leading` / `title` /
`subtitle` / `trailing`) and a single theme type (`StreamAppBarThemeData`),
replacing the legacy `AppBar`-style API.

### What changed across all headers

* **New layout primitive.** The headers render a [`StreamAppBar`] with a
  fixed 72-px height (`kStreamToolbarHeight`) instead of Material's
  `kToolbarHeight` (56 px). Pass the header directly to `Scaffold.appBar`
  as before — it implements `PreferredSizeWidget`.
* **Slot model.** All four headers now expose `leading`, `title`,
  `subtitle`, and `trailing` as plain `Widget?` slots. Anything you used
  to compose with `actions: [...]` should move into `trailing:` (single
  widget) or be wrapped into a `Row` you build yourself.
* **Auto-implied leading.** Headers that previously had `showBackButton`
  / `onBackPressed` now use `automaticallyImplyLeading` (default `true`)
  to insert a default back button. To override, pass `leading:` directly;
  to suppress, pass `automaticallyImplyLeading: false`.
* **Theme.** `StreamChannelHeaderThemeData`, `StreamChannelListHeaderThemeData`,
  and `StreamThreadHeaderThemeData` are deleted. The corresponding
  accessors on `StreamChatThemeData` (`channelHeaderTheme`,
  `channelListHeaderTheme`, `threadHeaderTheme`)
  now return [`StreamAppBarThemeData`].
* **Per-instance overrides.** A new `style: StreamAppBarStyle?` parameter
  lets callers override colours / padding / typography for one instance —
  it merges over the ambient `StreamAppBarTheme`.
* **Removed parameters.** `centerTitle`, `elevation`, `bottomOpacity`,
  `bottom`, and `backgroundColor` are gone — the new bar always centres
  the title, draws a hairline `borderSubtle` divider instead of an
  elevation shadow, and reads its background from the theme / `style`.

### `StreamChannelHeader`

| Old parameter                                                            | New equivalent                                                                             |
| ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------ |
| `showBackButton: false`                                                  | `automaticallyImplyLeading: false`                                                         |
| `onBackPressed: cb`                                                      | `leading: StreamBackButton(onPressed: cb)`                                                 |
| `onTitleTap: cb`                                                         | `title: GestureDetector(onTap: cb, child: ...)`                                            |
| `onImageTap: cb`                                                         | `onChannelAvatarPressed: (channel) => cb()` (or replace `trailing:`)                       |
| `showTypingIndicator: false`                                             | `subtitle: Text(channel.name)` (or any custom widget)                                      |
| `actions: [a, b]`                                                        | `trailing: Row(children: [a, b])`                                                          |
| `centerTitle`, `elevation`, `bottom`, `bottomOpacity`, `backgroundColor` | Use `style: StreamAppBarStyle(backgroundColor: ...)` for the background; the rest are gone |

**Before:**

```dart
StreamChannelHeader(
  showBackButton: true,
  onBackPressed: () => GoRouter.of(context).pop(),
  onImageTap: () => openChannelInfo(channel),
  showTypingIndicator: true,
  elevation: 1,
)
```

**After:**

```dart
StreamChannelHeader(
  leading: StreamBackButton(onPressed: () => GoRouter.of(context).pop()),
  onChannelAvatarPressed: (channel) => openChannelInfo(channel),
)
```

The default leading is now [`StreamBackButton`] with a channel-aware
unread badge; the default trailing is the channel avatar wrapped in a
48×48 tap target wired to `onChannelAvatarPressed`.

### `StreamBackButton`

The unread badge is now supplied as a widget through a single `unreadIndicator`
parameter (typically a `StreamUnreadIndicator`) instead of the `showUnreadCount`
/ `channelId` flags, which are **deprecated** but still functional. The badge is
overlaid on the button's top-end corner and hides itself when its count is zero.

| Old                                     | New equivalent                                              |
| --------------------------------------- | ----------------------------------------------------------- |
| `showUnreadCount: false` (or omitted)   | `unreadIndicator:` omitted — no badge                       |
| `showUnreadCount: true`                 | `unreadIndicator: StreamUnreadIndicator()`                  |
| `showUnreadCount: true, channelId: cid` | `unreadIndicator: StreamUnreadIndicator.channels(cid: cid)` |

`StreamUnreadIndicator` also takes an optional `excludeCid` to omit one channel
from the total. The default `StreamChannelHeader` leading uses
`StreamUnreadIndicator(excludeCid: channel.cid)` so its badge counts the unread
messages in *other* channels.

**Before:**

```dart
StreamBackButton(showUnreadCount: true)
```

**After:**

```dart
StreamBackButton(unreadIndicator: StreamUnreadIndicator())
```

### `StreamChannelListHeader`

| Old parameter                                                                                | New equivalent                                                                     |
| -------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| `titleBuilder: (context, user) => ...`                                                       | `title: ...` (a `Widget`)                                                          |
| `onUserAvatarTap: cb`                                                                        | `onUserAvatarPressed: cb` (renamed)                                                |
| `onNewChatButtonTap: cb`                                                                     | `trailing: StreamButton.icon(icon: Icon(context.streamIcons.plus), onPressed: cb)` |
| `preNavigationCallback`, `leading`, `actions`, `centerTitle`, `elevation`, `backgroundColor` | Removed — see notes below                                                          |

The leading slot is no longer caller-overridable: the SDK always renders
the signed-in user's avatar. When `onUserAvatarPressed` is null the
avatar mirrors Material `AppBar`'s auto-implied leading and opens the
enclosing `Scaffold`'s drawer if one exists, so the previous
`onUserAvatarTap: (_) => Scaffold.of(context).openDrawer()` callsites
can drop the callback entirely.

The trailing slot is empty by default — the SDK no longer ships a
"new chat" button. Pass your own widget if you want one.

**Before:**

```dart
StreamChannelListHeader(
  titleBuilder: (context, user) => Text(user?.name ?? 'Stream Chat'),
  onUserAvatarTap: (_) => Scaffold.of(context).openDrawer(),
  onNewChatButtonTap: () => GoRouter.of(context).pushNamed('new-chat'),
  elevation: 1,
)
```

**After:**

```dart
StreamChannelListHeader(
  title: Text('Chats', style: context.streamTextTheme.headingSm),
  trailing: StreamButton.icon(
    icon: Icon(context.streamIcons.plus),
    onPressed: () => GoRouter.of(context).pushNamed('new-chat'),
  ),
)
```

### `StreamThreadHeader`

| Old parameter                                 | New equivalent                                  |
| --------------------------------------------- | ----------------------------------------------- |
| `showBackButton: false`                       | `automaticallyImplyLeading: false`              |
| `onBackPressed: cb`                           | `leading: StreamBackButton(onPressed: cb)`      |
| `onTitleTap: cb`                              | `title: GestureDetector(onTap: cb, child: ...)` |
| `showTypingIndicator: false`                  | `subtitle: Text(...)` (or any custom widget)    |
| `actions: [a, b]`                             | `trailing: Row(children: [a, b])`               |
| `centerTitle`, `elevation`, `backgroundColor` | Use `style:`; the rest are gone                 |

The default subtitle is a [`StreamTypingIndicator`] that falls back to
the thread's reply count when nobody is typing.

### `StreamMediaGalleryPreviewHeader`

The gallery header was redesigned as `StreamMediaGalleryPreviewHeader`.
It wraps `StreamAppBar` and exposes only `title` and `subtitle` as `Widget?`
slots. All other per-instance overrides (back button, trailing actions,
colours) are handled by the underlying `StreamAppBar` defaults — no
extra parameters are exposed.

```dart
StreamMediaGalleryPreviewHeader(
  title: Text(message.user?.name ?? ''),
  subtitle: Text(
    context.translations.sentAtText(
      date: message.createdAt,
      time: message.createdAt,
    ),
  ),
)
```

The back affordance is auto-implied by `StreamAppBar`; there is no
`showBackButton`, `onBackPressed`, `onTitleTap`, `onImageTap`, or
`attachmentActionsModalBuilder` parameter on this widget.

### Theming

The theme accessors on `StreamChatThemeData` keep their names but their
type changes to [`StreamAppBarThemeData`]:

```dart
// Before
StreamChannelHeaderThemeData(
  color: theme.colorTheme.barsBg,
  titleStyle: theme.textTheme.headlineBold,
)

// After
StreamAppBarThemeData(
  style: StreamAppBarStyle(
    backgroundColor: colorScheme.backgroundElevation1,
    titleTextStyle: textTheme.headingSm,
  ),
)
```

Use `StreamAppBarTheme(data: ..., child: ...)` to override the theme for
a subtree, or pass `style:` directly on a single header instance.

### Header height

`kStreamToolbarHeight` (72 px) is now the canonical header height —
exposed from `package:stream_chat_flutter/stream_chat_flutter.dart`. If
you read `kToolbarHeight` (56 px) to size custom chrome that sits next
to a Stream header, switch to `kStreamToolbarHeight` to stay aligned.

---

## StreamChat.componentBuilders

`StreamChat` now accepts an optional `componentBuilders` parameter. When provided, it automatically inserts a `StreamComponentFactory` into the widget tree below the theme, making app-wide component customization available without wrapping the app manually.

### Migration

**Before (manual wrapping required):**
```dart
StreamComponentFactory(
  builders: StreamComponentBuilders(
    extensions: streamChatComponentBuilders(
      messageItem: (context, props) => MyMessage(props: props),
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
      messageItem: (context, props) => MyMessage(props: props),
    ),
  ),
  child: MyApp(),
)
```

Both approaches are equivalent. If you already have a `StreamComponentFactory` elsewhere in the tree it continues to work. Use `componentBuilders` when `StreamChat` is your natural customization entry point.

---

## StreamChatConfigurationData New Fields

### Removed: `reactionIcons`

`StreamChatConfigurationData.reactionIcons` (`List<StreamReactionIcon>`) has been **removed**. Reaction icons are now resolved by a `ReactionIconResolver` stored on `reactionIconResolver`.

| Removed                                       | Replacement                                         |
| --------------------------------------------- | --------------------------------------------------- |
| `StreamChatConfigurationData.reactionIcons`   | `StreamChatConfigurationData.reactionIconResolver`  |
| `StreamReactionIcon` model class              | `StreamEmojiContent` (returned by `resolver.resolve(type)`) |

To render a reaction emoji in a custom widget, call `resolver.resolve(type)` and pass the result to `StreamEmoji`:

```dart
final resolver = StreamChatConfiguration.of(context).reactionIconResolver;
final content = resolver.resolve('like');           // returns StreamEmojiContent
StreamEmoji(emoji: content, size: StreamEmojiSize.sm)
```

The `StreamEmojiSize` enum has values `.sm`, `.md`, and `.lg`.

To supply a custom resolver, pass `reactionIconResolver:` to `StreamChatConfigurationData`:

```dart
StreamChat(
  configData: StreamChatConfigurationData(
    reactionIconResolver: MyCustomReactionIconResolver(),
  ),
  child: ...,
)
```

---

### New Fields

Three new optional fields have been added to `StreamChatConfigurationData`. Existing code that does not pass them will use the defaults and requires no changes.

| Field                | Type                                   | Default | Description                                                                                                                               |
| -------------------- | -------------------------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `attachmentBuilders` | `List<StreamAttachmentWidgetBuilder>?` | `null`  | Custom attachment widget builders. When non-null, these are **prepended** to the SDK's built-in builders so your types are matched first. |
| `reactionType`       | `StreamReactionsType?`                 | `null`  | Controls the visual style of the reactions display (e.g. segmented). Falls back to the SDK default when `null`.                           |
| `reactionPosition`   | `StreamReactionsPosition?`             | `null`  | Controls where reactions appear relative to the message bubble (e.g. header). Falls back to the SDK default when `null`.                  |

> **Note:** The `imageCDN` field was also added to `StreamChatConfigurationData`. It is covered in the [Image CDN & Thumbnails](image_cdn.md) guide.

### Migration

```dart
// Before: no attachment builder or reaction customization on the config
StreamChat(
  client: client,
  configData: StreamChatConfigurationData(
    enforceUniqueReactions: false,
  ),
  child: MyApp(),
)

// After: optionally add the new fields
StreamChat(
  client: client,
  configData: StreamChatConfigurationData(
    enforceUniqueReactions: false,
    attachmentBuilders: [MyCustomAttachmentBuilder()],
    reactionType: StreamReactionsType.segmented,
    reactionPosition: StreamReactionsPosition.header,
  ),
  child: MyApp(),
)
```

---

## StreamChatCore Behavior Changes

Two behavior changes affect how the chat client interacts with the connection lifecycle. Neither changes the public API surface, but both can affect apps that watch channels outside of the SDK's list controllers.

### `client.recoverStateOnReconnect = false` on mount

`StreamChatCore` now sets `client.recoverStateOnReconnect = false` when it mounts. The SDK's list controllers (`StreamChannelListController`, `StreamMessageListController`, etc.) drive their own refresh from the `EventType.connectionRecovered` event — this avoids a duplicate `queryChannels` round-trip and the historical event-replay flicker on reactions, polls, and quoted messages when reconnecting.

If you watch a `Channel` directly (outside any list controller), subscribe to `connectionRecovered` yourself and call `channel.watch()` to refresh:

```dart
late final StreamSubscription _sub;

@override
void initState() {
  super.initState();
  _sub = client.on(EventType.connectionRecovered).listen((_) {
    channel.watch();
  });
}

@override
void dispose() {
  _sub.cancel();
  super.dispose();
}
```

If you do not want this behaviour, you can override it after mounting:

```dart
client.recoverStateOnReconnect = true;
```

### `StreamChat.backgroundKeepAlive` default reduced

The default `StreamChat.backgroundKeepAlive` has been reduced from **1 minute** to **15 seconds**. This covers quick app-switches and notification-shade checks while closing the WebSocket cleanly before the server's 35-second read timeout. To restore the previous behaviour, pass an explicit value:

```dart
StreamChat(
  client: client,
  backgroundKeepAlive: const Duration(minutes: 1),
  child: MyApp(),
)
```

---

## Removed Widgets

The following miscellaneous widgets have been removed. Replace any direct references with the listed alternatives.

| Removed Widget                | Replacement                                                                                                                                            |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `StreamMessageSearchGridView` | Removed — use `StreamMessageSearchListView` (still available), or build your own grid using `StreamMessageSearchListController` + `PagedValueGridView` |

For composer-related removals, see [message_composer.md](message_composer.md#removed-widgets).
For attachment-related removals, see [attachments_and_polls.md](attachments_and_polls.md#removed-attachment-widgets).
For channel-list-related removals, see [channel_list_item.md](channel_list_item.md#removed-widgets).
For message / reactions-related removals, see [message_widget.md](message_widget.md#removed-widgets) and [reaction_list.md](reaction_list.md#removed-widgets).

---

## Migration Checklist

- [ ] Replace `StreamChatConfigurationData.reactionIcons` with `reactionIconResolver`; render emoji via `resolver.resolve(type)` → `StreamEmoji(emoji: content, size: StreamEmojiSize.sm)`
- [ ] Replace all `StreamSvgIcon(icon: StreamSvgIcons.*)` with `Icon(context.streamIcons.*)` using the mapping table above
- [ ] Replace `showBackButton: false` with `automaticallyImplyLeading: false` on every header that used it
- [ ] Move `onBackPressed: cb` to `leading: StreamBackButton(onPressed: cb)`
- [ ] Move `onTitleTap` / `onImageTap` callbacks into `GestureDetector` wrappers around the new `title:` / `trailing:` slots (or use `onChannelAvatarPressed` on `StreamChannelHeader`)
- [ ] Rename `StreamChannelListHeader.onUserAvatarTap` to `onUserAvatarPressed`; drop manual `Scaffold.of(context).openDrawer()` callbacks if you only want the default drawer behaviour
- [ ] Replace `StreamChannelListHeader.onNewChatButtonTap` with a `trailing: StreamButton.icon(...)` widget — the SDK no longer ships the default button
- [ ] Replace `titleBuilder: (context, user) => ...` with `title: ...` (a `Widget`)
- [ ] Replace `actions: [a, b]` with `trailing: Row(children: [a, b])` — only one trailing slot is exposed
- [ ] Drop `centerTitle`, `elevation`, `bottomOpacity`, `bottom`, and `backgroundColor` from header callsites; use `style: StreamAppBarStyle(backgroundColor: ...)` if you need to override the background
- [ ] Update theme overrides: `StreamChannelHeaderThemeData` / `StreamChannelListHeaderThemeData` / `StreamThreadHeaderThemeData` are deleted — switch to `StreamAppBarThemeData`
- [ ] If you sized custom chrome to `kToolbarHeight` next to a Stream header, switch to `kStreamToolbarHeight` (72 px)
- [ ] Optionally move `StreamComponentFactory` wrapping into the `componentBuilders` parameter on `StreamChat`
- [ ] Use the new `attachmentBuilders`, `reactionType`, and `reactionPosition` fields on `StreamChatConfigurationData` if you need custom attachment rendering or global reaction style control
- [ ] If you watch a `Channel` outside any list controller, subscribe to `EventType.connectionRecovered` and call `channel.watch()` (the SDK no longer auto-recovers on reconnect when `StreamChatCore` is mounted)
- [ ] If you relied on the old `StreamChat.backgroundKeepAlive` default of 1 minute, pass `backgroundKeepAlive: const Duration(minutes: 1)` explicitly — the new default is 15 seconds
- [ ] Remove any `StreamMessageSearchGridView` usage — switch to `StreamMessageSearchListView` or build your own grid
