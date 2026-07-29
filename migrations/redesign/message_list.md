# Message List Migration Guide

This guide covers migrating `StreamMessageListView` from the old design to the new redesigned API, including the stable-release changes that split behavior flags and builders into dedicated configuration objects.

For changes to the individual message item / message widget, see [message_widget.md](message_widget.md).

---

## Table of Contents

- [Quick Reference](#quick-reference)
- [Customizing the Message Item](#customizing-the-message-item)
- [Config & Builders Split](#config--builders-split)
  - [Behavior flags → `config`](#behavior-flags--config)
  - [Builder callbacks → `builders`](#builder-callbacks--builders)
- [Builder Signature Changes](#builder-signature-changes)
- [New List-Level Callbacks](#new-list-level-callbacks)
- [Changed: `showUnreadCountOnScrollToBottom` Default](#changed-showunreadcountonscrolltobottom-default)
- [Removed: `MessageDetails`](#removed-messagedetails)
- [StreamDraftListView Removed](#streamdraftlistview-removed)
- [Migration Checklist](#migration-checklist)

---

## Quick Reference

| Old                                                                        | New                                                                                             |
| -------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| `StreamMessageListView(swipeToReply: true, paginationLimit: 20, ...)`      | `StreamMessageListView(config: StreamMessageListViewConfiguration(...))`                        |
| `StreamMessageListView(loadingBuilder: ..., emptyBuilder: ..., ...)`       | `StreamMessageListView(builders: StreamMessageListViewBuilders(...))`                           |
| `messageBuilder` / `parentMessageBuilder`                                  | Component factory (preferred) or `messageBuilder` (root) / `builders.parentMessage`            |
| `MessageBuilder` typedef                                                   | `StreamMessageItemBuilder` typedef                                                              |
| `ParentMessageBuilder` typedef                                             | `StreamMessageItemBuilder` typedef                                                              |
| `OnQuotedMessageTap = void Function(String?)`                              | `void Function(Message quotedMessage)`                                                          |
| `MessageDetails` argument                                                  | Removed — alignment via `StreamMessageLayout.of(context)`, user via `StreamChat.of(context)`    |
| `showUnreadCountOnScrollToBottom: false` (old default)                     | `showUnreadCountOnScrollToBottom: true` (new default)                                           |
| `StreamDraftListView` / `StreamDraftListTile` / `StreamDraftListTileTheme` | Removed — use `StreamDraftListController` + `PagedValueListView`                                |

---

## Customizing the Message Item

v10 introduces two ways to customize how individual messages render. Choose based on scope:

### Component factory — preferred for app-wide customization

Register a `messageItem` builder on `StreamChat` via `StreamComponentBuilders`. This applies globally: the message list, thread list, action modal previews, and any other place that renders a `StreamMessageItem` all use the same builder automatically — with no extra wiring required.

```dart
StreamChat(
  client: client,
  componentBuilders: StreamComponentBuilders(
    extensions: streamChatComponentBuilders(
      messageItem: (context, props) {
        // Option A: modify props and use the default layout
        return DefaultStreamMessageItem(
          props: props.copyWith(
            actionsBuilder: (context, defaultActions) => [
              ...defaultActions,
              myCustomAction,
            ],
          ),
        );
        // Option B: replace entirely with a custom widget
        // return MyCustomBubble(message: props.message);
      },
    ),
  ),
  child: ...,
)
```

This is the approach that was not possible before v10. In v9 you had to pass `messageBuilder` to every `StreamMessageListView` separately, and any modal that displayed a message preview (e.g. the long-press actions sheet) would always fall back to the default widget because there was no way to hook into it globally.

### `messageBuilder` — for per-list overrides

`StreamMessageListView.messageBuilder` is still supported. Use it when you need behavior specific to one list — for example, adding swipe-to-reply only on the main channel view while keeping the default layout in thread views:

```dart
StreamMessageListView(
  messageBuilder: (context, message, defaultProps) {
    // StreamMessageItem.fromProps respects the global factory if one is set.
    final defaultWidget = StreamMessageItem.fromProps(props: defaultProps);

    if (message.isDeleted || message.state.isFailed) return defaultWidget;

    return Swipeable(
      key: ValueKey(message.id),
      onSwiped: (_) => onReply(message),
      child: defaultWidget,
    );
  },
)
```

`messageBuilder` takes precedence over the component factory for that list. If `messageBuilder` is set, `StreamMessageItem.fromProps` still goes through the factory — so the two compose cleanly: the factory supplies the global style, and `messageBuilder` wraps or modifies it per-list.

### Precedence

```
messageBuilder (per-list, highest priority)
  └─ calls StreamMessageItem.fromProps()
       └─ component factory (app-wide, if registered)
            └─ DefaultStreamMessageItem (SDK default)
```

> **Rule of thumb:** use the component factory for anything that should look the same everywhere (custom bubbles, extra actions, branding). Use `messageBuilder` only when behavior genuinely differs per list (swipe gestures, list-specific wrappers).

---

## Config & Builders Split

`StreamMessageListView` no longer accepts behavior flags and builder callbacks as flat constructor parameters. Behavior flags now live on `StreamMessageListViewConfiguration` (passed via `config:`) and slot builder callbacks on `StreamMessageListViewBuilders` (passed via `builders:`). The root `messageBuilder` for regular messages is unchanged.

**Before:**

```dart
StreamMessageListView(
  swipeToReply: true,
  paginationLimit: 20,
  markReadWhenAtTheBottom: false,
  showScrollToBottom: true,
  showUnreadIndicator: true,
  reverse: true,
  loadingBuilder: (context) => const MyLoader(),
  emptyBuilder: (context) => const MyEmpty(),
  errorBuilder: (context, error) => MyError(error),
  dateDividerBuilder: (date) => MyDateDivider(date: date),
  threadSeparatorBuilder: (context, parent) => MyThreadSeparator(parent: parent),
  scrollToBottomBuilder: (unread, tap) => MyScrollToBottom(unread: unread, onTap: tap),
)
```

**After:**

```dart
StreamMessageListView(
  config: StreamMessageListViewConfiguration(
    swipeToReply: true,
    paginationLimit: 20,
    markReadWhenAtTheBottom: false,
    showScrollToBottom: true,
    showUnreadIndicator: true,
    reverse: true,
  ),
  builders: StreamMessageListViewBuilders(
    loading: (context) => const MyLoader(),
    empty: (context) => const MyEmpty(),
    error: (context, error) => MyError(error),
    dateDivider: (date) => MyDateDivider(date: date),
    threadSeparator: (context, parent) => MyThreadSeparator(parent: parent),
    scrollToBottomButton: (unread, tap) => MyScrollToBottom(unread: unread, onTap: tap),
  ),
)
```

### Behavior flags → `config`

All boolean/scalar flags move to `StreamMessageListViewConfiguration`:

| Old flat parameter                  | New field on `StreamMessageListViewConfiguration` |
| ----------------------------------- | ------------------------------------------------- |
| `markReadWhenAtTheBottom`           | `markReadWhenAtTheBottom`                         |
| `swipeToReply`                      | `swipeToReply`                                    |
| `showScrollToBottom`                | `showScrollToBottom`                              |
| `showUnreadCountOnScrollToBottom`   | `showUnreadCountOnScrollToBottom`                 |
| `showUnreadIndicator`               | `showUnreadIndicator`                             |
| `highlightInitialMessage`           | `highlightInitialMessage`                         |
| `showConnectionStateTile`           | `showConnectionStateTile`                         |
| `showFloatingDateDivider`           | `showFloatingDateDivider`                         |
| `fadeFloatingDateDividerNearInline` | `fadeFloatingDateDividerNearInline`               |
| `reverse`                           | `reverse`                                         |
| `shrinkWrap`                        | `shrinkWrap`                                      |
| `paginationLimit`                   | `paginationLimit`                                 |
| `keyboardDismissBehavior`           | `keyboardDismissBehavior`                         |
| `scrollPhysics`                     | `scrollPhysics`                                   |

### Builder callbacks → `builders`

All slot builder callbacks (except the root `messageBuilder` for regular messages) move to `StreamMessageListViewBuilders`. Several callbacks are also renamed:

| Old flat parameter                  | New field on `StreamMessageListViewBuilders` |
| ----------------------------------- | -------------------------------------------- |
| `emptyBuilder`                      | `empty`                                      |
| `loadingBuilder`                    | `loading`                                    |
| `errorBuilder`                      | `error`                                      |
| `headerBuilder`                     | `header`                                     |
| `footerBuilder`                     | `footer`                                     |
| `messageListBuilder`                | `content`                                    |
| `dateDividerBuilder`                | `dateDivider`                                |
| `floatingDateDividerBuilder`        | `floatingDateDivider`                        |
| `threadSeparatorBuilder`            | `threadSeparator`                            |
| `unreadMessagesSeparatorBuilder`    | `unreadMessagesSeparator`                    |
| `scrollToBottomBuilder`             | `scrollToBottomButton`                       |
| `paginationLoadingIndicatorBuilder` | `paginationLoadingIndicator`                 |
| `spacingWidgetBuilder`              | `spacing`                                    |
| `systemMessageBuilder`              | `systemMessage`                              |
| `ephemeralMessageBuilder`           | `ephemeralMessage`                           |
| `moderatedMessageBuilder`           | `moderatedMessage`                           |
| `parentMessageBuilder`              | `parentMessage`                              |

`messageBuilder` (for regular messages) stays as a flat parameter on `StreamMessageListView` itself.

---

## Builder Signature Changes

Both `messageBuilder` and `parentMessage` (the new home for `parentMessageBuilder`) now use the same typedef:

**Before:**

```dart
typedef MessageBuilder = Widget Function(
  BuildContext context,
  MessageDetails details,
  List<Message> messages,
  StreamMessageItem defaultMessageWidget,
);

typedef ParentMessageBuilder = Widget Function(
  BuildContext context,
  Message? parentMessage,
  StreamMessageItem defaultMessageWidget,
);
```

**After:**

```dart
typedef StreamMessageItemBuilder = Widget Function(
  BuildContext context,
  Message message,
  StreamMessageItemProps defaultProps,
);
```

The old builders received a pre-built `StreamMessageItem` that you could `copyWith`. The new builders receive `StreamMessageItemProps` — raw configuration data. Use `StreamMessageItem.fromProps(props:)` to build the default widget through the component factory.

**Before:**

```dart
StreamMessageListView(
  messageBuilder: (context, details, messages, defaultWidget) {
    return defaultWidget.copyWith(showReactions: false);
  },
  parentMessageBuilder: (context, parent, defaultWidget) {
    return defaultWidget.copyWith(showReactions: false);
  },
)
```

**After:**

```dart
StreamMessageListView(
  // Option 1: use the default widget as-is
  messageBuilder: (context, message, defaultProps) {
    return StreamMessageItem.fromProps(props: defaultProps);
  },

  // Option 2: customize props before building
  messageBuilder: (context, message, defaultProps) {
    return StreamMessageItem.fromProps(
      props: defaultProps.copyWith(
        actionsBuilder: (context, actions) => [...actions, myAction],
      ),
    );
  },

  // Option 3: replace entirely with a custom widget
  messageBuilder: (context, message, defaultProps) {
    return MyCustomMessageWidget(message: message);
  },
  builders: StreamMessageListViewBuilders(
    parentMessage: (context, parent, defaultProps) {
      return StreamMessageItem.fromProps(props: defaultProps);
    },
  ),
)
```

> **Important:** The `messageBuilder` callback now receives a `BuildContext` that has `StreamMessageLayout` in its ancestor chain. You can call `StreamMessageLayout.alignmentDirectionalOf(context)` to determine message alignment.

---

## New List-Level Callbacks

These callbacks were previously only configurable per-message on `StreamMessageItem`. They are now available at the list level and forwarded to all messages:

| New Parameter        | Type                              |
| -------------------- | --------------------------------- |
| `onEditMessageTap`   | `void Function(Message)?`         |
| `onReplyTap`         | `void Function(Message)?`         |
| `onUserAvatarTap`    | `void Function(User)?`            |
| `onReactionsTap`     | `void Function(Message)?`         |
| `onQuotedMessageTap` | `void Function(Message)?`         |
| `onMessageLinkTap`   | `void Function(Message, String)?` |
| `onUserMentionTap`   | `void Function(User)?`            |

---

## Changed: `showUnreadCountOnScrollToBottom` Default

The default flipped from `false` to `true`. The flag now lives inside `StreamMessageListViewConfiguration`.

```dart
// Old
StreamMessageListView(showUnreadCountOnScrollToBottom: false)

// New
StreamMessageListView(
  config: StreamMessageListViewConfiguration(
    showUnreadCountOnScrollToBottom: true, // new default
  ),
)
```

---

## Removed: `MessageDetails`

The `MessageDetails` class has been removed. The old `messageBuilder` received it as an argument with `userId`, `message`, `messages`, and `index`. The new builder receives just `Message` and `StreamMessageItemProps`. The user ID is accessible via `StreamChat.of(context).currentUser?.id`. Message alignment is provided by `StreamMessageLayout.of(context)`.

```dart
// Inside a messageBuilder:
final currentUser = StreamChat.of(context).currentUser;
final alignment = StreamMessageLayout.alignmentDirectionalOf(context);
final isMyMessage = message.user?.id == currentUser?.id;
```

---

## StreamDraftListView Removed

`StreamDraftListView`, `StreamDraftListTile`, `StreamDraftListTileTheme`, `StreamDraftListTileThemeData`, and `StreamChatThemeData.draftListTileTheme` have been removed. The opinionated draft list UI was extracted out of the SDK — build your own list using `StreamDraftListController` (from `stream_chat_flutter_core`) with a generic `PagedValueListView`. See the sample app for a reference implementation.

**Before:**

```dart
StreamDraftListView(
  controller: draftListController,
  onDraftTap: (draft) => openDraft(draft),
)
```

**After:**

```dart
PagedValueListView<String, Draft>(
  controller: draftListController,
  itemBuilder: (context, drafts, index) {
    final draft = drafts[index];
    return ListTile(
      title: Text(draft.message.text ?? ''),
      onTap: () => openDraft(draft),
    );
  },
)
```

`StreamDraftListController` itself is unchanged.

---

## Migration Checklist

- [ ] If you previously passed `messageBuilder` to every `StreamMessageListView` for app-wide styling, migrate that logic to the component factory via `StreamComponentBuilders(extensions: streamChatComponentBuilders(messageItem: ...))` on `StreamChat` — this automatically covers the action modal preview and all other lists
- [ ] Move all `StreamMessageListView` behavior flags into `config: StreamMessageListViewConfiguration(...)`
- [ ] Move all `StreamMessageListView` builder callbacks into `builders: StreamMessageListViewBuilders(...)` and rename per the table above (e.g. `loadingBuilder` → `loading`, `emptyBuilder` → `empty`, `dateDividerBuilder` → `dateDivider`)
- [ ] Keep `messageBuilder` as a top-level parameter only for per-list behavior (e.g. swipe wrappers); move `parentMessageBuilder` into `builders.parentMessage`
- [ ] Update `messageBuilder` / `parentMessage` callbacks to the new `StreamMessageItemBuilder` signature `(BuildContext, Message, StreamMessageItemProps)`
- [ ] Inside `messageBuilder`, call `StreamMessageItem.fromProps(props: defaultProps)` instead of using the old `defaultWidget` — this ensures the global component factory is still invoked
- [ ] Replace `defaultWidget.copyWith(...)` calls with `StreamMessageItem.fromProps(props: defaultProps.copyWith(...))`
- [ ] Replace `MessageDetails` usage — use `StreamMessageLayout.of(context)` for alignment, `StreamChat.of(context).currentUser` for user ID
- [ ] Update `onQuotedMessageTap` from `void Function(String?)` to `void Function(Message)`
- [ ] Review the new `showUnreadCountOnScrollToBottom` default (`true`) and explicitly set `false` in `config` if you want the old behaviour
- [ ] Replace `StreamDraftListView` / `StreamDraftListTile` with a `PagedValueListView` driven by `StreamDraftListController`
