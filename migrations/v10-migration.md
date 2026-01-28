# 🚀 Stream Chat Flutter SDK v10.0.0 Migration Guide

This guide covers all breaking changes in **Stream Chat Flutter SDK v10.0.0**. Whether you're upgrading from v9.x or from a v10 beta, this document provides the complete migration path.

---

## 📋 Table of Contents

- [Who Should Read This](#-who-should-read-this)
- [Quick Reference](#-quick-reference)
- [Attachment Picker](#-attachment-picker)
  - [Picker Type System](#-picker-type-system)
  - [Picker Options](#-picker-options)
  - [Picker Result Handling](#-picker-result-handling)
  - [Bottom Sheet Classes](#-bottom-sheet-classes)
  - [Options Builder Pattern](#-options-builder-pattern)
  - [Result Callback](#-result-callback)
  - [Controller Error Handling](#-controller-error-handling)
- [Reactions](#-reactions)
  - [Sending Reactions](#-sending-reactions)
  - [Reaction Picker](#-reaction-picker)
  - [Reaction Picker Icon List](#-reaction-picker-icon-list)
  - [Message Reactions Modal](#-message-reactions-modal)
- [Message UI](#-message-ui)
  - [Attachment Tap Handler](#-attachment-tap-handler)
  - [Message Widget](#-message-widget)
  - [Message Actions](#-message-actions)
- [Message State & Deletion](#️-message-state--deletion)
  - [Message Delete Scope](#-message-delete-scope)
- [File Upload](#-file-upload)
  - [Attachment File Uploader Interface](#-attachment-file-uploader-interface)
- [Appendix: Beta Release Timeline](#-appendix-beta-release-timeline)

---

## 👥 Who Should Read This

| Upgrading From | Sections to Review |
|----------------|-------------------|
| **v9.x** | All sections |
| **v10.0.0-beta.1** | All sections introduced after beta.1 |
| **v10.0.0-beta.3** | Sections introduced in beta.4 and later |
| **v10.0.0-beta.4** | Sections introduced in beta.7 and later |
| **v10.0.0-beta.7** | Sections introduced in beta.8 and later |
| **v10.0.0-beta.8** | Sections introduced in beta.9 and later |
| **v10.0.0-beta.9** | Sections introduced in beta.12 |
| **v10.0.0-beta.12** | No additional changes |

Each breaking change section includes an **"Introduced in"** tag so you can quickly identify which changes apply to your upgrade path.

---

## ⚡ Quick Reference

| Feature Area | Key Changes |
|-------------|-------------|
| **Attachment Picker** | Sealed class hierarchy, builder pattern for options, typed result handling |
| **Reactions** | `Reaction` object API, explicit `onReactionPicked` callbacks required |
| **Message UI** | New `onAttachmentTap` signature with fallback support, generic `StreamMessageAction` |
| **Message State** | `MessageDeleteScope` replaces `bool hard`, delete-for-me support |
| **File Upload** | Four new abstract methods on `AttachmentFileUploader` |

---

## 📎 Attachment Picker

The attachment picker system has been redesigned with a sealed class hierarchy, improved type safety, and a flexible builder pattern for customization.

### 🛠 Picker Type System

> **Introduced in:** v10.0.0-beta.3

`AttachmentPickerType` has been converted from an enum to a sealed class hierarchy, enabling extensible custom picker types.

**Before:**

```dart
// Enum-based attachment types
final attachmentType = AttachmentPickerType.images;
```

**After:**

```dart
// Sealed class attachment types (same syntax for built-in types)
final attachmentType = AttachmentPickerType.images;

// Custom types via extension
class LocationAttachmentPickerType extends CustomAttachmentPickerType {
  const LocationAttachmentPickerType();
}
```

> ℹ️ **Note:** Basic usage remains unchanged for built-in types. The sealed class enables custom picker types like contact or location pickers.

---

### 🛠 Picker Options

> **Introduced in:** v10.0.0-beta.3

`StreamAttachmentPickerOption` has been replaced with two specialized sealed classes:

- **`SystemAttachmentPickerOption`** — For system pickers (camera, file dialogs)
- **`TabbedAttachmentPickerOption`** — For custom UI pickers (gallery, polls)

**Before:**

```dart
final option = AttachmentPickerOption(
  title: 'Gallery',
  icon: Icon(Icons.photo_library),
  supportedTypes: [AttachmentPickerType.images, AttachmentPickerType.videos],
  optionViewBuilder: (context, controller) {
    return GalleryPickerView(controller: controller);
  },
);

final webOrDesktopOption = WebOrDesktopAttachmentPickerOption(
  title: 'File Upload',
  icon: Icon(Icons.upload_file),
  type: AttachmentPickerType.files,
);
```

**After:**

```dart
// For custom UI pickers (gallery, polls)
final tabbedOption = TabbedAttachmentPickerOption(
  title: 'Gallery',
  icon: Icon(Icons.photo_library),
  supportedTypes: [AttachmentPickerType.images, AttachmentPickerType.videos],
  optionViewBuilder: (context, controller) {
    return GalleryPickerView(controller: controller);
  },
);

// For system pickers (camera, file dialogs)
final systemOption = SystemAttachmentPickerOption(
  title: 'Camera',
  icon: Icon(Icons.camera_alt),
  supportedTypes: [AttachmentPickerType.images],
  onTap: (context, controller) => pickFromCamera(),
);
```

> ⚠️ **Warning:** Choose the correct option class based on your picker's behavior. System pickers invoke platform dialogs; tabbed pickers render custom UI within the bottom sheet.

---

### 🛠 Picker Result Handling

> **Introduced in:** v10.0.0-beta.3

`showStreamAttachmentPickerModalBottomSheet` now returns `StreamAttachmentPickerResult` instead of `AttachmentPickerValue`, providing improved type safety.

**Before:**

```dart
final result = await showStreamAttachmentPickerModalBottomSheet(
  context: context,
  controller: controller,
);

// result is AttachmentPickerValue
```

**After:**

```dart
final result = await showStreamAttachmentPickerModalBottomSheet(
  context: context,
  controller: controller,
);

// result is StreamAttachmentPickerResult
switch (result) {
  case AttachmentsPicked():
    // Handle picked attachments
  case PollCreated():
    // Handle created poll
  case AttachmentPickerError():
    // Handle error
  case CustomAttachmentPickerResult():
    // Handle custom result
}
```

> ⚠️ **Warning:** Always handle the new `StreamAttachmentPickerResult` return type with exhaustive switch cases.

---

### 🛠 Bottom Sheet Classes

> **Introduced in:** v10.0.0-beta.3

Bottom sheet class names have been updated to better reflect their functionality:

| Old Name | New Name |
|----------|----------|
| `StreamMobileAttachmentPickerBottomSheet` | `StreamTabbedAttachmentPickerBottomSheet` |
| `StreamWebOrDesktopAttachmentPickerBottomSheet` | `StreamSystemAttachmentPickerBottomSheet` |

**Before:**

```dart
StreamMobileAttachmentPickerBottomSheet(
  context: context,
  controller: controller,
  customOptions: [option],
);

StreamWebOrDesktopAttachmentPickerBottomSheet(
  context: context,
  controller: controller,
  customOptions: [option],
);
```

**After:**

```dart
StreamTabbedAttachmentPickerBottomSheet(
  context: context,
  controller: controller,
  customOptions: [tabbedOption],
);

StreamSystemAttachmentPickerBottomSheet(
  context: context,
  controller: controller,
  customOptions: [systemOption],
);
```

---

### 🛠 Options Builder Pattern

> **Introduced in:** v10.0.0-beta.8

`customAttachmentPickerOptions` has been replaced with `attachmentPickerOptionsBuilder`, which provides access to default options for modification, filtering, or extension.

**Before:**

```dart
StreamMessageInput(
  customAttachmentPickerOptions: [
    TabbedAttachmentPickerOption(
      key: 'custom-location',
      icon: const Icon(Icons.location_on),
      supportedTypes: [AttachmentPickerType.images],
      optionViewBuilder: (context, controller) {
        return CustomLocationPicker();
      },
    ),
  ],
)
```

**After:**

```dart
StreamMessageInput(
  attachmentPickerOptionsBuilder: (context, defaultOptions) {
    // Modify, filter, reorder, or extend default options
    return [
      ...defaultOptions,
      TabbedAttachmentPickerOption(
        key: 'custom-location',
        icon: const Icon(Icons.location_on),
        supportedTypes: [AttachmentPickerType.images],
        optionViewBuilder: (context, controller) {
          return CustomLocationPicker();
        },
      ),
    ];
  },
)
```

**Filtering default options:**

```dart
StreamMessageInput(
  attachmentPickerOptionsBuilder: (context, defaultOptions) {
    // Remove poll option
    return defaultOptions.where((option) => option.key != 'poll').toList();
  },
)
```

**Reordering options:**

```dart
StreamMessageInput(
  attachmentPickerOptionsBuilder: (context, defaultOptions) {
    return defaultOptions.reversed.toList();
  },
)
```

**Using with `showStreamAttachmentPickerModalBottomSheet`:**

```dart
final result = await showStreamAttachmentPickerModalBottomSheet(
  context: context,
  optionsBuilder: (context, defaultOptions) {
    return [
      ...defaultOptions,
      TabbedAttachmentPickerOption(
        key: 'custom-option',
        icon: const Icon(Icons.star),
        supportedTypes: [AttachmentPickerType.images],
        optionViewBuilder: (context, controller) {
          return CustomPickerView();
        },
      ),
    ];
  },
);
```

> ℹ️ **Note:** The builder pattern works with both mobile (tabbed) and desktop (system) pickers.

---

### 🛠 Result Callback

> **Introduced in:** v10.0.0-beta.8

`onCustomAttachmentPickerResult` has been replaced with `onAttachmentPickerResult`, which returns `FutureOr<bool>` to control default processing.

**Before:**

```dart
StreamMessageInput(
  onCustomAttachmentPickerResult: (result) {
    if (result is CustomAttachmentPickerResult) {
      final data = result.data;
      // Handle custom result
    }
  },
)
```

**After:**

```dart
StreamMessageInput(
  onAttachmentPickerResult: (result) {
    if (result is CustomAttachmentPickerResult) {
      final data = result.data;
      // Handle custom result
      return true; // Skip default processing
    }
    return false; // Allow default handler to process
  },
)
```

> ⚠️ **Warning:** Return `true` to skip default handling, `false` to allow it.

---

### 🛠 Controller Error Handling

> **Introduced in:** v10.0.0-beta.12

`StreamAttachmentPickerController` now throws typed errors instead of generic `ArgumentError`:

| Old Error | New Error | Properties |
|-----------|-----------|------------|
| `ArgumentError('The size of the attachment is...')` | `AttachmentTooLargeError` | `fileSize`, `maxSize` |
| `ArgumentError('The maximum number of attachments is...')` | `AttachmentLimitReachedError` | `maxCount` |

**Before:**

```dart
try {
  await controller.addAttachment(attachment);
} on ArgumentError catch (e) {
  // Generic error handling
  showError(e.message);
}
```

**After:**

```dart
try {
  await controller.addAttachment(attachment);
} on AttachmentTooLargeError catch (e) {
  // File size exceeded
  showError('File is too large. Max size is ${e.maxSize} bytes.');
} on AttachmentLimitReachedError catch (e) {
  // Too many attachments
  showError('Cannot add more attachments. Maximum is ${e.maxCount}.');
}
```

> ⚠️ **Warning:** Replace generic `ArgumentError` catches with the specific typed errors.

---

## 😍 Reactions

The reaction system has been updated to use explicit callbacks and a unified `Reaction` object API.

### 🛠 Sending Reactions

> **Introduced in:** v10.0.0-beta.4

`sendReaction` now accepts a `Reaction` object instead of individual parameters.

**Before:**

```dart
// Using individual parameters
channel.sendReaction(
  message,
  'like',
  score: 1,
  extraData: {'custom_field': 'value'},
);

client.sendReaction(
  messageId,
  'love',
  enforceUnique: true,
  extraData: {'custom_field': 'value'},
);
```

**After:**

```dart
// Using Reaction object
channel.sendReaction(
  message,
  Reaction(
    type: 'like',
    score: 1,
    emojiCode: '👍',
    extraData: {'custom_field': 'value'},
  ),
);

client.sendReaction(
  messageId,
  Reaction(
    type: 'love',
    emojiCode: '❤️',
    extraData: {'custom_field': 'value'},
  ),
  enforceUnique: true,
);
```

> ℹ️ **Note:** Optional parameters like `enforceUnique` and `skipPush` remain as method parameters. The `emojiCode` field enables custom emoji codes for reactions.

---

### 🛠 Reaction Picker

> **Introduced in:** v10.0.0-beta.1

`StreamReactionPicker` has been redesigned with explicit reaction handling. Automatic reaction handling has been removed.

New features:
- `StreamReactionPicker.builder` constructor
- `padding`, `scrollable`, `borderRadius` properties
- Required `onReactionPicked` callback

**Before:**

```dart
StreamReactionPicker(
  message: message,
);
```

**After (Recommended — Builder):**

```dart
StreamReactionPicker.builder(
  context,
  message,
  (Reaction reaction) {
    // Explicitly handle reaction
  },
);
```

**After (Direct Configuration):**

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

> ⚠️ **Warning:** You must explicitly handle reactions using `onReactionPicked`. Automatic handling has been removed.

---

### 🛠 Reaction Picker Icon List

> **Introduced in:** v10.0.0-beta.9

`ReactionPickerIconList` has been refactored for better separation of concerns:

| Change | Details |
|--------|---------|
| `message` parameter | Removed |
| `reactionIcons` type | Changed from `List<StreamReactionIcon>` to `List<ReactionPickerIcon>` |
| `onReactionPicked` | Renamed to `onIconPicked` with signature `ValueSetter<ReactionPickerIcon>` |
| `iconBuilder` | Changed from default value to nullable with internal fallback |

Message-specific logic (checking for own reactions) has been moved to the parent widget.

**Before:**

```dart
ReactionPickerIconList(
  message: message,
  reactionIcons: icons,
  onReactionPicked: (reaction) {
    // Handle reaction
    channel.sendReaction(message, reaction);
  },
)
```

**After:**

```dart
// Map StreamReactionIcon to ReactionPickerIcon with selection state
final ownReactions = [...?message.ownReactions];
final ownReactionsMap = {for (final it in ownReactions) it.type: it};

final pickerIcons = icons.map((icon) {
  return ReactionPickerIcon(
    type: icon.type,
    builder: icon.builder,
    isSelected: ownReactionsMap[icon.type] != null,
  );
}).toList();

ReactionPickerIconList(
  reactionIcons: pickerIcons,
  onIconPicked: (pickerIcon) {
    final reaction = ownReactionsMap[pickerIcon.type] ?? 
                     Reaction(type: pickerIcon.type);
    // Handle reaction
    channel.sendReaction(message, reaction);
  },
)
```

> ℹ️ **Note:** This is typically an internal widget used by `StreamReactionPicker`. If you were using it directly, you now need to handle reaction selection state externally. Use `StreamReactionPicker` for most use cases.

---

### 🛠 Message Reactions Modal

> **Introduced in:** v10.0.0-beta.1

`StreamMessageReactionsModal` now uses explicit reaction handling and inherits from `StreamMessageModal` for consistency.

| Change | Details |
|--------|---------|
| `messageTheme` | Removed (now inferred automatically) |
| `onReactionPicked` | Required for reaction handling |

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

> ⚠️ **Warning:** `messageTheme` has been removed. Reaction handling must be explicit using `onReactionPicked`.

---

## 💬 Message UI

### 🛠 Attachment Tap Handler

> **Introduced in:** v10.0.0-beta.9

`onAttachmentTap` has a new callback signature that supports custom attachment handling with automatic fallback to default behavior.

| Change | Details |
|--------|---------|
| First parameter | `BuildContext` added |
| Return type | `FutureOr<bool>` — `true` if handled, `false` for default behavior |
| Default behavior | Automatically handles URL previews, images, videos, and giphys |

**Before:**

```dart
StreamMessageWidget(
  message: message,
  onAttachmentTap: (message, attachment) {
    // Could only override - no way to fallback to default behavior
    if (attachment.type == 'location') {
      showLocationDialog(context, attachment);
    }
    // Other attachment types (images, videos, URLs) lost default behavior
  },
)
```

**After:**

```dart
StreamMessageWidget(
  message: message,
  onAttachmentTap: (context, message, attachment) async {
    if (attachment.type == 'location') {
      await showLocationDialog(context, attachment);
      return true; // Handled by custom logic
    }
    return false; // Use default behavior for images, videos, URLs, etc.
  },
)
```

**Handling multiple custom types:**

```dart
StreamMessageWidget(
  message: message,
  onAttachmentTap: (context, message, attachment) async {
    switch (attachment.type) {
      case 'location':
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MapView(attachment)),
        );
        return true;
      
      case 'product':
        await showProductDialog(context, attachment);
        return true;
      
      default:
        return false; // Images, videos, URLs use default viewer
    }
  },
)
```

> ℹ️ **Note:** Supports both synchronous and asynchronous operations.

---

### 🛠 Message Widget

> **Introduced in:** v10.0.0-beta.1

The `showReactionTail` parameter has been removed from `StreamMessageWidget`. The tail now automatically shows when the reaction picker is visible.

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

---

### 🛠 Message Actions

> **Introduced in:** v10.0.0-beta.1

`StreamMessageAction` is now generic (`StreamMessageAction<T extends MessageAction>`) with centralized action handling.

| Change | Details |
|--------|---------|
| Type system | Now generic with `<T extends MessageAction>` |
| Individual `onTap` | Removed — use `onCustomActionTap` instead |
| Styling | New props: `isDestructive`, `iconColor` |

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

**After:**

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

> ⚠️ **Warning:** Individual `onTap` callbacks have been removed. Always handle actions using the centralized `onCustomActionTap`.

---

## 🗑️ Message State & Deletion

### 🛠 Message Delete Scope

> **Introduced in:** v10.0.0-beta.7

`MessageState` factory constructors now accept `MessageDeleteScope` instead of `bool hard`. This change also introduces delete-for-me functionality.

| Change | Details |
|--------|---------|
| Factory constructors | Accept `MessageDeleteScope` instead of `bool hard` |
| Pattern matching | Callbacks receive `MessageDeleteScope scope` instead of `bool hard` |
| Delete-for-me | New methods and state checks |

**Before:**

```dart
// Factory constructors with bool hard
final deletingState = MessageState.deleting(hard: true);
final deletedState = MessageState.deleted(hard: false);
final failedState = MessageState.deletingFailed(hard: true);

// Pattern matching with bool hard
message.state.whenOrNull(
  deleting: (hard) => handleDeleting(hard),
  deleted: (hard) => handleDeleted(hard),
  deletingFailed: (hard) => handleDeletingFailed(hard),
);
```

**After:**

```dart
// Factory constructors with MessageDeleteScope
final deletingState = MessageState.deleting(
  scope: MessageDeleteScope.hardDeleteForAll,
);
final deletedState = MessageState.deleted(
  scope: MessageDeleteScope.softDeleteForAll,
);
final failedState = MessageState.deletingFailed(
  scope: MessageDeleteScope.deleteForMe(),
);

// Pattern matching with MessageDeleteScope
message.state.whenOrNull(
  deleting: (scope) => handleDeleting(scope.hard),
  deleted: (scope) => handleDeleted(scope.hard),
  deletingFailed: (scope) => handleDeletingFailed(scope.hard),
);

// New delete-for-me functionality
channel.deleteMessageForMe(message); // Delete only for current user
client.deleteMessageForMe(messageId); // Delete only for current user

// Check delete-for-me states
if (message.state.isDeletingForMe) {
  // Handle deleting for me state
}
if (message.state.isDeletedForMe) {
  // Handle deleted for me state  
}
if (message.state.isDeletingForMeFailed) {
  // Handle delete for me failed state
}
```

> ℹ️ **Note:** Use `scope.hard` to access the hard delete boolean value from `MessageDeleteScope`.

---

## 📤 File Upload

### 🛠 Attachment File Uploader Interface

> **Introduced in:** v10.0.0-beta.7

`AttachmentFileUploader` now includes four new abstract methods for standalone upload/removal operations without requiring channel context.

| New Method | Purpose |
|------------|---------|
| `uploadImage` | Standalone image upload |
| `uploadFile` | Standalone file upload |
| `removeImage` | Standalone image removal |
| `removeFile` | Standalone file removal |

**Before:**

```dart
class CustomAttachmentFileUploader implements AttachmentFileUploader {
  @override
  Future<SendImageResponse> sendImage(/* ... */) async {
    // Implementation
  }
  
  @override
  Future<SendFileResponse> sendFile(/* ... */) async {
    // Implementation
  }
  
  @override
  Future<EmptyResponse> deleteImage(/* ... */) async {
    // Implementation
  }
  
  @override
  Future<EmptyResponse> deleteFile(/* ... */) async {
    // Implementation
  }
}
```

**After:**

```dart
class CustomAttachmentFileUploader implements AttachmentFileUploader {
  @override
  Future<SendImageResponse> sendImage(/* ... */) async {
    // Implementation
  }
  
  @override
  Future<SendFileResponse> sendFile(/* ... */) async {
    // Implementation
  }
  
  @override
  Future<EmptyResponse> deleteImage(/* ... */) async {
    // Implementation
  }
  
  @override
  Future<EmptyResponse> deleteFile(/* ... */) async {
    // Implementation
  }
  
  // New required methods
  @override
  Future<UploadImageResponse> uploadImage(
    AttachmentFile image, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    // Implementation for standalone image upload
  }
  
  @override
  Future<UploadFileResponse> uploadFile(
    AttachmentFile file, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    // Implementation for standalone file upload
  }
  
  @override
  Future<EmptyResponse> removeImage(
    String url, {
    CancelToken? cancelToken,
  }) async {
    // Implementation for standalone image removal
  }
  
  @override
  Future<EmptyResponse> removeFile(
    String url, {
    CancelToken? cancelToken,
  }) async {
    // Implementation for standalone file removal
  }
}
```

> ℹ️ **Note:** `UploadImageResponse` and `UploadFileResponse` are aliases for `SendAttachmentResponse`.

---

## 📅 Appendix: Beta Release Timeline

This appendix provides a chronological reference of breaking changes by beta version for users upgrading from specific pre-release versions.

### 🚧 v10.0.0-beta.1

- [Reaction Picker](#-reaction-picker)
- [Message Actions](#-message-actions)
- [Message Reactions Modal](#-message-reactions-modal)
- [Message Widget](#-message-widget)

### 🚧 v10.0.0-beta.3

- [Picker Type System](#-picker-type-system)
- [Picker Options](#-picker-options)
- [Picker Result Handling](#-picker-result-handling)
- [Bottom Sheet Classes](#-bottom-sheet-classes)

### 🚧 v10.0.0-beta.4

- [Sending Reactions](#-sending-reactions)

### 🚧 v10.0.0-beta.7

- [Attachment File Uploader Interface](#-attachment-file-uploader-interface)
- [Message Delete Scope](#-message-delete-scope)

### 🚧 v10.0.0-beta.8

- [Options Builder Pattern](#-options-builder-pattern)
- [Result Callback](#-result-callback)

### 🚧 v10.0.0-beta.9

- [Attachment Tap Handler](#-attachment-tap-handler)
- [Reaction Picker Icon List](#-reaction-picker-icon-list)

### 🚧 v10.0.0-beta.12

- [Controller Error Handling](#-controller-error-handling)

---

## ✅ Migration Checklist

Use this checklist to verify your migration is complete:

### 📎 Attachment Picker
- [ ] Update `AttachmentPickerType` usage if using custom types
- [ ] Replace `AttachmentPickerOption` with `SystemAttachmentPickerOption` or `TabbedAttachmentPickerOption`
- [ ] Handle `StreamAttachmentPickerResult` return type with switch cases
- [ ] Rename bottom sheet classes (`StreamTabbedAttachmentPickerBottomSheet`, `StreamSystemAttachmentPickerBottomSheet`)
- [ ] Replace `customAttachmentPickerOptions` with `attachmentPickerOptionsBuilder`
- [ ] Replace `onCustomAttachmentPickerResult` with `onAttachmentPickerResult` returning `FutureOr<bool>`
- [ ] Update error handling to use `AttachmentTooLargeError` and `AttachmentLimitReachedError`

### 😍 Reactions
- [ ] Update `sendReaction` calls to use `Reaction` object
- [ ] Use `StreamReactionPicker.builder` or supply `onReactionPicked` callback
- [ ] Update `ReactionPickerIconList` usage if using directly
- [ ] Add `onReactionPicked` to `StreamMessageReactionsModal`

### 💬 Message UI
- [ ] Update `onAttachmentTap` signature (add `BuildContext`, return `FutureOr<bool>`)
- [ ] Remove `showReactionTail` from `StreamMessageWidget`
- [ ] Convert `StreamMessageAction` to generic type-safe usage
- [ ] Use `onCustomActionTap` for centralized action handling

### 🗑️ Message State & Deletion
- [ ] Update `MessageState` factory constructors to use `MessageDeleteScope`
- [ ] Update pattern matching callbacks to handle `MessageDeleteScope`
- [ ] Leverage new delete-for-me functionality if needed

### 📤 File Upload
- [ ] Implement four new methods in custom `AttachmentFileUploader` implementations

---

🎉 **You're ready to migrate!** For additional help, visit the [Stream Chat Flutter documentation](https://getstream.io/chat/docs/sdk/flutter/) or open an issue on [GitHub](https://github.com/GetStream/stream-chat-flutter/issues).
