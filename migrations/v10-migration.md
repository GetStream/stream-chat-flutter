# 🚀 Flutter SDK v10.0 Migration Guide

**Important!** This guide details breaking changes in **SDK v10.0**. Carefully follow each step to ensure a smooth and efficient migration.

---

## 📋 Breaking Changes Overview

This guide includes breaking changes grouped by release phase:

### 🚧 v10.0.0-beta.1

- [**StreamReactionPicker**](#-streamreactionpicker-refactor)
- [**StreamMessageAction**](#-streammessageaction-refactor)
- [**StreamMessageReactionsModal**](#-streammessagereactionsmodal-refactor)
- [**StreamMessageWidget**](#-streammessagewidget-refactor)

---

## 🧪 Migration for v10.0.0-beta.1

### 🛠 StreamReactionPicker Refactor

The reaction picker has been refactored for modularity, flexibility, and explicit reaction handling.

### Key Changes:
**Key Changes:**
- New `StreamReactionPicker.builder` constructor
- Added properties: `padding`, `scrollable`, `borderRadius`
- Removed automatic reaction handling → use `onReactionPicked`

### Migration Steps:

**Before:**
```dart
StreamReactionPicker(
  message: message,
);
```

**After (Recommended using Builder):**
```dart
StreamReactionPicker.builder(
  context,
  message,
  (Reaction reaction) {
    // Explicitly handle reaction here
  },
);
```

**After (Alternative Direct Configuration):**
```dart
StreamReactionPicker(
  message: message,
  reactionIcons: StreamChatConfiguration.of(context).reactionIcons,
  onReactionPicked: (Reaction reaction) {
    // Explicit reaction handling
  },
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  scrollable: true,
  borderRadius: BorderRadius.circular(24),
);
```

> ⚠️ **Important:**  
> Automatic reaction handling has been removed. You must explicitly handle reactions.

### Summary of Changes:

| Aspect                 | Previous      | New Behavior                                 |
|------------------------|---------------|----------------------------------------------|
| Reaction Handling      | Automatic     | Explicit (`onReactionPicked`)                |
| Platform Constructor   | None          | Yes (`StreamReactionPicker.builder`)         |
| Customization          | Limited       | Enhanced (`padding`, `borderRadius`, `scrollable`) |

---

## ✅ StreamMessageAction Refactor

The `StreamMessageAction` is refactored for type safety, centralization, and enhanced customization.

### Key Changes:
- **Type-safe Actions:** Now generic (`StreamMessageAction<T extends MessageAction>`) for stronger typing.
- **Centralized Action Handling:** Individual action callbacks replaced with centralized handling via `onCustomActionTap`.
- **Customization Options:** New props:
    - `isDestructive`: Flag destructive actions.
    - `iconColor`: Customize icon color.
    - `titleTextColor`: Title color customization.
    - `titleTextStyle`: Title text styling.
    - `backgroundColor`: Background color customization.

### Migration Steps:

**Before:**
```dart
final customAction = StreamMessageAction(
  title: Text('Custom Action'),
  leading: Icon(Icons.settings),
  onTap: (Message message) {
    // Handle action
  },
);

StreamMessageWidget(
  message: message,
  customActions: [customAction],
);
```

**After (Recommended - Type-safe):**
```dart
final customAction = StreamMessageAction<CustomMessageAction>(
  action: CustomMessageAction(
    message: message,
    extraData: {'type': 'custom_action'},
  ),
  title: Text('Custom Action'),
  leading: Icon(Icons.settings),
  isDestructive: false,
  iconColor: Colors.blue,
);

StreamMessageWidget(
  message: message,
  customActions: [customAction],
  onCustomActionTap: (CustomMessageAction action) {
    // Handle action based on extraData
  },
);
```

> ⚠️ **Important:**  
> Individual `onTap` callbacks have been removed. Always use centralized `onCustomActionTap`.

### Summary of Changes:

| Aspect           | Previous                       | New Behavior                             |
|------------------|--------------------------------|------------------------------------------|
| Action Typing    | Untyped                        | Generic (type-safe)                      |
| Action Handling  | Individual `onTap` callbacks   | Centralized (`onCustomActionTap`)        |
| Customization    | Limited                        | Enhanced (`iconColor`, `backgroundColor`, etc.) |

---

## ✅ StreamMessageReactionsModal Refactor

Refactored to leverage `StreamMessageModal`, improving consistency and explicit reaction handling.

### Key Changes:
- **Base Widget Changed:** Now uses `StreamMessageModal` internally.
- **Removed `messageTheme` Property:** Theme now automatically derived from `reverse`.
- **Explicit Reaction Handling:** Reactions must be handled explicitly through `onReactionPicked`.

### Migration Steps:

**Step 1: Remove `messageTheme`:**
```dart
// Before
StreamMessageReactionsModal(
  message: message,
  messageWidget: myMessageWidget,
  messageTheme: myCustomMessageTheme, // remove this
  reverse: true,
);

// After
StreamMessageReactionsModal(
  message: message,
  messageWidget: myMessageWidget,
  reverse: true,
);
```

**Step 2: Explicit Reaction Handling:**
```dart
// Before (automatic handling)
StreamMessageReactionsModal(
  message: message,
  messageWidget: myMessageWidget,
  // reactions handled internally
);

// After (explicit handling)
StreamMessageReactionsModal(
  message: message,
  messageWidget: myMessageWidget,
  onReactionPicked: (SelectReaction reactionAction) {
    // Explicitly send or delete reaction
  },
);
```

> ⚠️ **Important:**  
> Automatic handling is removed—explicit reaction handling required.

### Summary of Changes:

| Aspect             | Previous                  | New Behavior                       |
|--------------------|---------------------------|------------------------------------|
| Reaction Handling  | Automatic                 | Explicit (`onReactionPicked`)      |
| Base Widget        | Custom implementation     | Uses `StreamMessageModal`          |
| `messageTheme` Prop| Required                  | Removed; derived from `reverse`    |

---

## ✅ StreamMessageWidget Refactor

The `StreamMessageWidget` has been simplified by removing the `showReactionTail` parameter and always showing the reaction picker tail when the reaction picker is visible.

### Key Changes:
- **Removed `showReactionTail` Parameter:** The parameter is no longer needed as the tail is always shown when the reaction picker is visible.
- **Automatic Tail Display:** The reaction picker tail now automatically appears when the reaction picker is visible, providing consistent UX.

### Migration Steps:

**Before:**
```dart
StreamMessageWidget(
  message: message,
  showReactionTail: true, // Remove this parameter
);

// or

StreamMessageWidget(
  message: message,
  showReactionTail: false, // Remove this parameter
);
```

**After:**
```dart
StreamMessageWidget(
  message: message,
  // showReactionTail parameter removed - tail shown automatically
);
```

> ⚠️ **Important:**  
> The `showReactionTail` parameter has been completely removed. The reaction picker tail will always be shown when the reaction picker is visible, ensuring consistent behavior across your app.

### Summary of Changes:

| Aspect                 | Previous                          | New Behavior                                 |
|------------------------|-----------------------------------|----------------------------------------------|
| Tail Display Control   | Manual (`showReactionTail`)       | Automatic (always shown when picker visible) |
| Parameter Required     | Optional boolean parameter        | Parameter removed                            |
| Consistency            | Could be inconsistent             | Always consistent                            |

---

✅ **You're ready to migrate!**  
Ensure you test your application thoroughly after applying these changes.

---
