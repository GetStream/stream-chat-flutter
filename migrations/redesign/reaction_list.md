# Reaction List Migration Guide

This guide covers the new reaction list controller, view, and detail sheet introduced in the Stream Chat Flutter SDK design refresh.

---

## Table of Contents

- [StreamReactionListController](#streamreactionlistcontroller)
- [StreamReactionListView](#streamreactionlistview)
- [ReactionDetailSheet](#reactiondetailsheet)
- [Removed Widgets](#removed-widgets)
- [Migration Checklist](#migration-checklist)

---

## StreamReactionListController

`StreamReactionListController` is a new controller in `stream_chat_flutter_core` for fetching and paginating reactions for a message. It extends `PagedValueNotifier<String?, Reaction>`, following the same pattern as `StreamChannelListController` and other list controllers.

### Constructor

```dart
StreamReactionListController({
  required StreamChatClient client,
  required String messageId,
  Filter? filter,
  SortOrder<Reaction>? sort,
  int limit = 25,              // defaultReactionPagedLimit
})
```

| Parameter   | Type                   | Default      | Description                                                                      |
| ----------- | ---------------------- | ------------ | -------------------------------------------------------------------------------- |
| `client`    | `StreamChatClient`     | **required** | The Stream chat client                                                           |
| `messageId` | `String`               | **required** | ID of the message to load reactions for                                          |
| `filter`    | `Filter?`              | `null`       | Query filter; supports fields `type`, `user_id`, `created_at`                    |
| `sort`      | `SortOrder<Reaction>?` | `null`       | Sort order; only `created_at` is backend-supported (`ReactionSortKey.createdAt`) |
| `limit`     | `int`                  | `25`         | Page size                                                                        |

### Methods

| Method                              | Description                                                                                             |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------- |
| `doInitialLoad()`                   | Loads the first page of reactions                                                                       |
| `loadMore(String? nextPageKey)`     | Loads the next page using cursor-based pagination                                                       |
| `refresh({bool resetValue = true})` | Reloads from the beginning; resets active filter/sort to constructor values when `resetValue` is `true` |

### Runtime Filter / Sort Changes

You can update `filter` and `sort` at runtime (e.g., when the user taps a reaction-type tab) and then call `doInitialLoad()` to reload:

```dart
controller.filter = Filter.equal('type', 'like');
controller.doInitialLoad();
```

### Basic Usage

```dart
final controller = StreamReactionListController(
  client: StreamChat.of(context).client,
  messageId: message.id,
  sort: const [SortOption.desc(ReactionSortKey.createdAt)],
);

await controller.doInitialLoad();
```

---

## StreamReactionListView

`StreamReactionListView` is a new widget in `stream_chat_flutter` that renders a paginated list of reactions using a `StreamReactionListController`.

### Constructor

```dart
StreamReactionListView({
  required StreamReactionListController controller,
  required StreamReactionListViewIndexedWidgetBuilder itemBuilder,
  PagedValueScrollViewIndexedWidgetBuilder<Reaction>? separatorBuilder,
  WidgetBuilder? emptyBuilder,
  WidgetBuilder? loadingBuilder,
  Widget Function(BuildContext, StreamChatError)? errorBuilder,
  int loadMoreTriggerIndex = 3,
  // Standard ListView params: scrollDirection, reverse, scrollController,
  // primary, physics, shrinkWrap, padding, cacheExtent, etc.
})
```

| Parameter              | Type                                                  | Required | Description                                                            |
| ---------------------- | ----------------------------------------------------- | -------- | ---------------------------------------------------------------------- |
| `controller`           | `StreamReactionListController`                        | yes      | Provides and paginates the reaction data                               |
| `itemBuilder`          | `StreamReactionListViewIndexedWidgetBuilder`          | yes      | Builds each reaction item                                              |
| `separatorBuilder`     | `PagedValueScrollViewIndexedWidgetBuilder<Reaction>?` | no       | Builds separators between items (defaults to `SizedBox.shrink`)        |
| `emptyBuilder`         | `WidgetBuilder?`                                      | no       | Widget shown when there are no reactions                               |
| `loadingBuilder`       | `WidgetBuilder?`                                      | no       | Widget shown during initial load                                       |
| `errorBuilder`         | `Widget Function(BuildContext, StreamChatError)?`     | no       | Widget shown on error                                                  |
| `loadMoreTriggerIndex` | `int`                                                 | no       | How many items from the end to trigger the next page load (default: 3) |

### Usage

```dart
StreamReactionListView(
  controller: controller,
  itemBuilder: (context, reactions, index) {
    final reaction = reactions[index];
    return ListTile(
      leading: Text(reaction.type),
      title: Text(reaction.user?.name ?? ''),
    );
  },
)
```

---

## ReactionDetailSheet

`ReactionDetailSheet` replaces the old `StreamMessageReactionsModal`. It shows a bottom sheet with the total reaction count, emoji filter chips per reaction type, and a scrollable list of reactors using `StreamReactionListController` internally.

### Showing the Sheet

Use the static `show` method — the constructor is private:

```dart
final action = await ReactionDetailSheet.show(
  context: context,
  message: message,
  initialReactionType: 'like',  // optional: pre-select a reaction type
);
```

`show` returns a `MessageAction?`:
- `SelectReaction` — if the user picks or removes a reaction
- `null` — if the sheet is dismissed without selection

### Parameters of `show`

| Parameter             | Type           | Required | Description                                              |
| --------------------- | -------------- | -------- | -------------------------------------------------------- |
| `context`             | `BuildContext` | yes      | Build context                                            |
| `message`             | `Message`      | yes      | The message whose reactions to display                   |
| `initialReactionType` | `String?`      | no       | Pre-selects this reaction type chip when the sheet opens |

### Migration from `StreamMessageReactionsModal`

**Before:**
```dart
showDialog(
  context: context,
  builder: (_) => StreamMessageReactionsModal(message: message),
);
```

**After:**
```dart
await ReactionDetailSheet.show(
  context: context,
  message: message,
);
```

> **Note:** `ReactionDetailSheet` is displayed as a `DraggableScrollableSheet` (snapping between 50% and full height) and supports cursor-based pagination for large reaction lists.

---

## Removed Widgets

The following reactions-related widgets have been removed. Replace any direct references with the listed alternatives.

| Removed Widget                | Replacement                                                                                                                                                                                       |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `DesktopReactionsBuilder`     | Use `ReactionDetailSheet.show(context: context, message: message)` for the full reactors list, or override `reactions` (`StreamComponentBuilder<StreamReactionsProps>?`) via `StreamComponentFactory` to customize the inline reaction chips |
| `StreamMessageReactionsModal` | Use `ReactionDetailSheet` (see [ReactionDetailSheet](#reactiondetailsheet))                                                                                                                       |

For action-related reaction widget changes (e.g. `StreamMessageReactionsModal` migration), see [message_actions.md](message_actions.md#streammessagereactionsmodal).

---

## Migration Checklist

- [ ] Replace `StreamMessageReactionsModal` with `ReactionDetailSheet.show()`
- [ ] Use `StreamReactionListController` to load/paginate reactions programmatically
- [ ] Use `StreamReactionListView` with a `StreamReactionListController` for custom reaction list UIs
- [ ] For runtime reaction-type filtering, set `controller.filter` and call `controller.doInitialLoad()`
- [ ] Remove any `DesktopReactionsBuilder` usage — replace with `ReactionDetailSheet.show(...)` or a custom `reactions` factory override
