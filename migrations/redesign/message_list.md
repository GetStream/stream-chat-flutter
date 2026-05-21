# Message List Migration Guide

This guide covers migrating `StreamMessageListView` from the old design to the new redesigned API, including the stable-release changes that split behavior flags and builders into dedicated configuration objects.

For changes to the individual message item / message widget, see [message_widget.md](message_widget.md).

---

## Table of Contents

- [Quick Reference](#quick-reference)
- [Config & Builders Split](#config--builders-split)
  - [Behavior flags → `config`](#behavior-flags--config)
  - [Builder callbacks → `builders`](#builder-callbacks--builders)
- [Builder Signature Changes](#builder-signature-changes)
- [New List-Level Callbacks](#new-list-level-callbacks)
- [Changed: `showUnreadCountOnScrollToBottom` Default](#changed-showunreadcountonscrolltobottom-default)
- [Removed: MessageDetails](#removed-messagedetails)
- [StreamDraftListView Removed](#streamdraftlistview-removed)
- [Migration Checklist](#migration-checklist)

---

## Quick Reference

| Old                                                                        | New                                                                                             |
| -------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| `StreamMessageListView(swipeToReply: true, paginationLimit: 20, ...)`      | `StreamMessageListView(config: StreamMessageListViewConfiguration(...))`                        |
| `StreamMessageListView(loadingBuilder: ..., emptyBuilder: ..., ...)`       | `StreamMessageListView(builders: StreamMessageListViewBuilders(...))`                           |
| `messageBuilder` / `parentMessageBuilder`                                  | `messageBuilder` (root) / `builders.parentMessage`                                              |
| `MessageBuilder` typedef                                                   | `StreamMessageItemBuilder` typedef                                                              |
| `ParentMessageBuilder` typedef                                             | `StreamMessageItemBuilder` typedef                                                              |
| `OnQuotedMessageTap = void Function(String?)`                              | `void Function(Message quotedMessage)`                                                          |
| `MessageDetails` argument                                                  | Removed — alignment via `StreamMessagePlacement.of(context)`, user via `StreamChat.of(context)` |
| `showUnreadCountOnScrollToBottom: false` (old default)                     | `showUnreadCountOnScrollToBottom: true` (new default)                                           |
| `StreamDraftListView` / `StreamDraftListTile` / `StreamDraftListTileTheme` | Removed — use `StreamDraftListController` + `PagedValueListView`                                |

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
  messageBuilder: (context, message, defaultProps) {
    return StreamMessageItem.fromProps(props: defaultProps);

    // Or customize props before building
    return StreamMessageItem.fromProps(
      props: defaultProps.copyWith(
        actionsBuilder: (context, actions) => [...actions, myAction],
      ),
    );

    // Or replace entirely
    return MyCustomMessageWidget(message: message);
  },
  builders: StreamMessageListViewBuilders(
    parentMessage: (context, parent, defaultProps) {
      return StreamMessageItem.fromProps(props: defaultProps);
    },
  ),
)
```

> **Important:** The `messageBuilder` callback now receives a `BuildContext` that has `StreamMessagePlacement` in its ancestor chain. You can call `StreamMessagePlacement.alignmentDirectionalOf(context)` to determine message alignment.

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

## Removed: MessageDetails

The old `messageBuilder` received `MessageDetails` which contained `userId`, `message`, `messages`, and `index`. The new builder receives just `Message` and `StreamMessageItemProps`. The user ID is accessible via `StreamChat.of(context).currentUser?.id`. Message alignment is provided by `StreamMessagePlacement.of(context)`.

```dart
// Inside a messageBuilder:
final currentUser = StreamChat.of(context).currentUser;
final alignment = StreamMessagePlacement.alignmentDirectionalOf(context);
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

- [ ] Move all `StreamMessageListView` behavior flags into `config: StreamMessageListViewConfiguration(...)`
- [ ] Move all `StreamMessageListView` builder callbacks into `builders: StreamMessageListViewBuilders(...)` and rename per the table above (e.g. `loadingBuilder` → `loading`, `emptyBuilder` → `empty`, `dateDividerBuilder` → `dateDivider`)
- [ ] Keep `messageBuilder` as a top-level parameter; move `parentMessageBuilder` into `builders.parentMessage`
- [ ] Update `messageBuilder` / `parentMessage` callbacks to the new `StreamMessageItemBuilder` signature `(BuildContext, Message, StreamMessageItemProps)`
- [ ] Replace `defaultWidget.copyWith(...)` calls with `StreamMessageItem.fromProps(props: defaultProps.copyWith(...))`
- [ ] Replace `MessageDetails` usage — use `StreamMessagePlacement.of(context)` for alignment, `StreamChat.of(context).currentUser` for user ID
- [ ] Update `onQuotedMessageTap` from `void Function(String?)` to `void Function(Message)`
- [ ] Review the new `showUnreadCountOnScrollToBottom` default (`true`) and explicitly set `false` in `config` if you want the old behaviour
- [ ] Replace `StreamDraftListView` / `StreamDraftListTile` with a `PagedValueListView` driven by `StreamDraftListController`
