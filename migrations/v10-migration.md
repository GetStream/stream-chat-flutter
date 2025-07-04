# 🚀 Flutter SDK v10 Migration Guide

**Important!** This guide outlines all breaking changes introduced in the Flutter SDK **v10.0.0** release, including pre-release stages like `v10.0.0-beta.1`. Follow each section based on the version you're migrating from.

---

## 📋 Breaking Changes Overview

This guide includes breaking changes grouped by release phase:

### 🚧 v10.0.0-beta.1

- [StreamReactionPicker](#-streamreactionpicker)
- [StreamMessageAction](#-streammessageaction)
- [StreamMessageReactionsModal](#-streammessagereactionsmodal)
- [StreamMessageWidget](#-streammessagewidget)

---

## 🧪 Migration for v10.0.0-beta.1

### 🛠 StreamReactionPicker

#### Key Changes:

- New `StreamReactionPicker.builder` constructor
- Added properties: `padding`, `scrollable`, `borderRadius`
- Automatic reaction handling removed — must now use `onReactionPicked`

#### Migration Steps:

**Before:**
```dart
StreamReactionPicker(
  message: message,
);
```

**After (Recommended – Builder):**
```dart
StreamReactionPicker.builder(
  context,
  message,
  (Reaction reaction) {
    // Explicitly handle reaction
  },
);
```

**After (Alternative – Direct Configuration):**
```dart
StreamReactionPicker(
  message: message,
  reactionIcons: StreamChatConfiguration.of(context).reactionIcons,
  onReactionPicked: (Reaction reaction) {
    // Handle reaction here
  },
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  scrollable: true,
  borderRadius: BorderRadius.circular(24),
);
```

> ⚠️ **Important:**  
> Automatic reaction handling has been removed. You must explicitly handle reactions using `onReactionPicked`.

---

### 🛠 StreamMessageAction

#### Key Changes:

- Now generic: `StreamMessageAction<T extends MessageAction>`
- Individual `onTap` handlers removed — use `onCustomActionTap` instead
- Added new styling props for better customization

#### Migration Steps:

**Before:**
```dart
final customAction = StreamMessageAction(
  title: Text('Custom Action'),
  leading: Icon(Icons.settings),
  onTap: (message) {
    // Handle action
  },
);
```

**After (Type-safe):**
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
    // Handle action here
  },
);
```

> ⚠️ **Important:**  
> Individual `onTap` callbacks have been removed. Always handle actions using the centralized `onCustomActionTap`.

---

### 🛠 StreamMessageReactionsModal

#### Key Changes:

- Based on `StreamMessageModal` for consistency
- `messageTheme` removed — inferred automatically
- Reaction handling must now be handled via `onReactionPicked`

#### Migration Steps:

**Before:**
```dart
StreamMessageReactionsModal(
  message: message,
  messageWidget: myMessageWidget,
  messageTheme: myCustomMessageTheme,
  reverse: true,
);
```

**After:**
```dart
StreamMessageReactionsModal(
  message: message,
  messageWidget: myMessageWidget,
  reverse: true,
  onReactionPicked: (SelectReaction reactionAction) {
    // Handle reaction explicitly
  },
);
```

> ⚠️ **Important:**  
> `messageTheme` has been removed. Reaction handling must now be explicit using `onReactionPicked`.

---

### 🛠 StreamMessageWidget

#### Key Changes:

- `showReactionTail` parameter has been removed
- Tail now automatically shows when the picker is visible

#### Migration Steps:

**Before:**
```dart
StreamMessageWidget(
  message: message,
  showReactionTail: true,
);
```

**After:**
```dart
StreamMessageWidget(
  message: message,
);
```

> ⚠️ **Important:**  
> The `showReactionTail` parameter is no longer supported. Tail is now always shown when the picker is visible.

---

## 🎉 You're Ready to Migrate!

- ✅ Use `StreamReactionPicker.builder` or supply `onReactionPicked`
- ✅ Convert all `StreamMessageAction` instances to type-safe generic usage
- ✅ Centralize handling with `onCustomActionTap`
- ✅ Remove deprecated props like `showReactionTail` and `messageTheme`
