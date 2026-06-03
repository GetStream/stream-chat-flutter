# Stream Chat Flutter SDK v10.0.0 Migration Guide

This guide covers all breaking changes in **Stream Chat Flutter SDK v10.0.0**. Whether you're upgrading from v9.x or from a v10 beta, this document provides the complete migration path.

---

## Table of Contents

- [Who Should Read This](#who-should-read-this)
- [Quick Reference](#quick-reference)
- [Attachment Picker](#attachment-picker)
    - [AttachmentPickerType](#attachmentpickertype)
    - [StreamAttachmentPickerOption](#streamattachmentpickeroption)
    - [showStreamAttachmentPickerModalBottomSheet](#showstreamattachmentpickermodalbottomsheet)
    - [AttachmentPickerBottomSheet](#attachmentpickerbottomsheet)
    - [customAttachmentPickerOptions](#customattachmentpickeroptions)
    - [onCustomAttachmentPickerResult](#oncustomattachmentpickerresult)
    - [StreamAttachmentPickerController](#streamattachmentpickercontroller)
- [Reactions](#reactions)
    - [SendReaction](#sendreaction)
    - [StreamReactionPicker](#streamreactionpicker)
    - [ReactionPickerIconList](#reactionpickericonlist)
    - [StreamMessageReactionsModal](#streammessagereactionsmodal)
- [Message UI](#message-ui)
    - [onAttachmentTap](#onattachmenttap)
    - [StreamMessageItem](#streammessageitem)
    - [StreamMessageAction](#streammessageaction)
- [Message State & Deletion](#message-state--deletion)
    - [MessageState](#messagestate)
- [File Upload](#file-upload)
    - [AttachmentFileUploader](#attachmentfileuploader)
- [Unread Threads Banner](#unread-threads-banner)
- [Stable Release Changes](#stable-release-changes)
    - [ClientState Collection Immutability](#stream_chat-clientstate-collection-immutability)
    - [SortOption Constructor Rename](#stream_chat-sortoption-constructor-rename)
- [Appendix: Beta Release Timeline](#appendix-beta-release-timeline)
- [Migration Checklist](#migration-checklist)

---

## Who Should Read This

| Upgrading From                       | Sections to Review                                |
| ------------------------------------ | ------------------------------------------------- |
| **v9.x**                             | All sections                                      |
| [**v10.0.0-beta.1**](#v1000-beta1)   | All sections introduced after beta.1              |
| [**v10.0.0-beta.3**](#v1000-beta3)   | Sections introduced in beta.4 and later           |
| [**v10.0.0-beta.4**](#v1000-beta4)   | Sections introduced in beta.7 and later           |
| [**v10.0.0-beta.7**](#v1000-beta7)   | Sections introduced in beta.8 and later           |
| [**v10.0.0-beta.8**](#v1000-beta8)   | Sections introduced in beta.9 and later           |
| [**v10.0.0-beta.9**](#v1000-beta9)   | Sections introduced in beta.12                    |
| [**v10.0.0-beta.12**](#v1000-beta12) | [Stable Release Changes](#stable-release-changes) |
| **v10.0.0** (stable)                 | [Stable Release Changes](#stable-release-changes) |

Each breaking change section includes an **"Introduced in"** tag so you can quickly identify which changes apply to your upgrade path.

---

## Quick Reference

| Feature Area                                        | Key Changes                                                                          |
| --------------------------------------------------- | ------------------------------------------------------------------------------------ |
| [**Attachment Picker**](#attachment-picker)         | Sealed class hierarchy, builder pattern for options, typed result handling           |
| [**Reactions**](#reactions)                         | `Reaction` object API, explicit `onReactionPicked` callbacks required                |
| [**Message UI**](#message-ui)                       | `StreamAttachmentWidgetTapCallback` signature `void Function(Message, Attachment)`; sealed `MessageAction` hierarchy with `actionsBuilder` |
| [**Message State**](#message-state--deletion)       | `MessageDeleteScope` replaces `bool hard`, delete-for-me support                     |
| [**File Upload**](#file-upload)                     | Four new abstract methods on `AttachmentFileUploader`                                |
| [**Unread Threads Banner**](#unread-threads-banner) | Wrapper pattern with `child`, `enabled`, `onRefresh`; removed `onTap`, `minHeight`   |

---

## Attachment Picker

The attachment picker system has been redesigned with a sealed class hierarchy, improved type safety, and a flexible builder pattern for customization.

---

### AttachmentPickerType

> **Introduced in:** [v10.0.0-beta.3](https://pub.dev/packages/stream_chat_flutter/versions/10.0.0-beta.3)

#### Key Changes:

- `AttachmentPickerType` enum replaced with sealed class hierarchy
- Now supports extensible custom types like contact and location pickers
- Use built-in types like `AttachmentPickerType.images` or define your own via `CustomAttachmentPickerType`

#### Migration Steps:

**Before:**
```dart
// Using enum-based attachment types
final attachmentType = AttachmentPickerType.images;
```

**After:**
```dart
// Using sealed class attachment types
final attachmentType = AttachmentPickerType.images;

// For custom types
class LocationAttachmentPickerType extends CustomAttachmentPickerType {
  const LocationAttachmentPickerType();
}
```

> **Important:**  
> The enum is now a sealed class, but the basic usage remains the same for built-in types.

---

### StreamAttachmentPickerOption

> **Introduced in:** [v10.0.0-beta.3](https://pub.dev/packages/stream_chat_flutter/versions/10.0.0-beta.3)

#### Key Changes:

- `StreamAttachmentPickerOption` replaced with two sealed classes:
    - `SystemAttachmentPickerOption` for system pickers (camera, files)
    - `TabbedAttachmentPickerOption` for tabbed pickers (gallery, polls, location)

#### Migration Steps:

**Before:**
```dart
final option = AttachmentPickerOption(
  title: 'Gallery',
  icon: Icons.photo_library,
  supportedTypes: [AttachmentPickerType.images, AttachmentPickerType.videos],
  optionViewBuilder: (context, controller) {
    return GalleryPickerView(controller: controller);
  },
);

final webOrDesktopOption = WebOrDesktopAttachmentPickerOption(
  title: 'File Upload',
  icon: Icons.upload_file,
  type: AttachmentPickerType.files,
);
```

**After:**
```dart
// For custom UI pickers (gallery, polls)
final tabbedOption = TabbedAttachmentPickerOption(
  title: 'Gallery',
  icon: Icons.photo_library,
  supportedTypes: [AttachmentPickerType.images, AttachmentPickerType.videos],
  optionViewBuilder: (context, controller) {
    return GalleryPickerView(controller: controller);
  },
);

// For system pickers (camera, file dialogs)
final systemOption = SystemAttachmentPickerOption(
  title: 'Camera',
  icon: Icons.camera_alt,
  supportedTypes: [AttachmentPickerType.images],
  onTap: (context, controller) => pickFromCamera(),
);
```

> **Important:**
> - Use `SystemAttachmentPickerOption` for system pickers (camera, file dialogs)
> - Use `TabbedAttachmentPickerOption` for custom UI pickers (gallery, polls)

---

### showStreamAttachmentPickerModalBottomSheet

> **Introduced in:** [v10.0.0-beta.3](https://pub.dev/packages/stream_chat_flutter/versions/10.0.0-beta.3)

#### Key Changes:

- `showStreamAttachmentPickerModalBottomSheet` has been **removed**. The attachment picker is now an inline widget embedded directly inside `StreamMessageComposer`. There is no longer a separate modal bottom sheet function to call.
- To customise available picker options, use `attachmentPickerOptionsBuilder` on `StreamMessageComposer` (see [customAttachmentPickerOptions](#customattachmentpickeroptions)).

#### Migration Steps:

**Before:**
```dart
final result = await showStreamAttachmentPickerModalBottomSheet(
  context: context,
  controller: controller,
);
```

**After:**

Remove the direct call. The picker now opens automatically from within `StreamMessageComposer`. To control which options are available, pass `attachmentPickerOptionsBuilder`:

```dart
StreamMessageComposer(
  attachmentPickerOptionsBuilder: (context, defaultOptions) {
    return [...defaultOptions]; // modify as needed
  },
)
```

> **Important:**  
> The picker is now inline. If you previously opened the picker programmatically, integrate it into the composer instead of calling a separate function.

---

### AttachmentPickerBottomSheet

> **Introduced in:** [v10.0.0-beta.3](https://pub.dev/packages/stream_chat_flutter/versions/10.0.0-beta.3)

#### Key Changes:

- `StreamMobileAttachmentPickerBottomSheet` and `StreamWebOrDesktopAttachmentPickerBottomSheet` have been replaced by **inline widgets** — there are no longer separate bottom-sheet classes.
- The new widgets are `StreamTabbedAttachmentPicker` (for mobile, tabbed interface) and `StreamSystemAttachmentPicker` (for web/desktop, system dialogs). Neither has a `BottomSheet` suffix — they are plain inline `Widget`s embedded inside the composer.

#### Migration Steps:

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

The pickers are now managed internally by `StreamMessageComposer`. Direct instantiation is only needed for advanced custom layouts:

```dart
// Tabbed picker (mobile default)
StreamTabbedAttachmentPicker(
  controller: controller,
  options: {tabbedOption},
);

// System picker (web/desktop default)
StreamSystemAttachmentPicker(
  controller: controller,
  options: {systemOption},
);
```

> **Important:**  
> The bottom-sheet classes have been removed entirely. The new `StreamTabbedAttachmentPicker` and `StreamSystemAttachmentPicker` are inline widgets, not sheets. In most cases you do not need to instantiate them directly — use `attachmentPickerOptionsBuilder` on `StreamMessageComposer` to customise picker options.

---

### customAttachmentPickerOptions

> **Introduced in:** [v10.0.0-beta.8](https://pub.dev/packages/stream_chat_flutter/versions/10.0.0-beta.8)

#### Key Changes:

- `customAttachmentPickerOptions` has been removed. Use `attachmentPickerOptionsBuilder` instead.
- New builder pattern provides access to default options which can be modified, reordered, or extended.

#### Migration Steps:

**Before:**
```dart
StreamMessageComposer(
  customAttachmentPickerOptions: [
    TabbedAttachmentPickerOption(
      key: 'custom-location',
      icon: Icons.location_on,
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
StreamMessageComposer(
  attachmentPickerOptionsBuilder: (context, defaultOptions) {
    // You can now modify, filter, reorder, or extend default options
    return [
      ...defaultOptions,
      TabbedAttachmentPickerOption(
        key: 'custom-location',
        icon: Icons.location_on,
        supportedTypes: [AttachmentPickerType.images],
        optionViewBuilder: (context, controller) {
          return CustomLocationPicker();
        },
      ),
    ];
  },
)
```

**Example: Filtering default options**
```dart
StreamMessageComposer(
  attachmentPickerOptionsBuilder: (context, defaultOptions) {
    // Remove poll option
    return defaultOptions.where((option) => option.key != 'poll').toList();
  },
)
```

**Example: Reordering options**
```dart
StreamMessageComposer(
  attachmentPickerOptionsBuilder: (context, defaultOptions) {
    // Reverse the order
    return defaultOptions.reversed.toList();
  },
)
```

> **Important:**
> - The builder pattern gives you access to default options, allowing more flexible customization.
> - The builder works with both mobile (tabbed) and desktop (system) pickers.
> - `showStreamAttachmentPickerModalBottomSheet` has been removed. Use `attachmentPickerOptionsBuilder` on `StreamMessageComposer` as shown above.

---

### onCustomAttachmentPickerResult

> **Introduced in:** [v10.0.0-beta.8](https://pub.dev/packages/stream_chat_flutter/versions/10.0.0-beta.8)

#### Key Changes:

- `onCustomAttachmentPickerResult` has been removed. Use `onAttachmentPickerResult` which returns `FutureOr<bool>`.
- Result handler can now short-circuit default behavior by returning `true`.

#### Migration Steps:

**Before:**
```dart
StreamMessageComposer(
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
StreamMessageComposer(
  onAttachmentPickerResult: (result) {
    if (result is CustomAttachmentPickerResult) {
      final data = result.data;
      // Handle custom result
      return true; // Indicate we handled it - skips default processing
    }
    return false; // Let default handler process other result types
  },
)
```

> **Important:**
> - `onAttachmentPickerResult` replaces `onCustomAttachmentPickerResult` and must return a boolean
> - Return `true` from `onAttachmentPickerResult` to skip default handling
> - Return `false` to allow the default handler to process the result

---

### StreamAttachmentPickerController

> **Introduced in:** [v10.0.0-beta.12](https://pub.dev/packages/stream_chat_flutter/versions/10.0.0-beta.12)

#### Key Changes:

- Replaced `ArgumentError('The size of the attachment is...')` with `AttachmentTooLargeError`.
- Replaced `ArgumentError('The maximum number of attachments is...')` with `AttachmentLimitReachedError`.
- Added `AttachmentBlockedError`, thrown when the attachment's extension or MIME type is rejected by the backend `AppSettings.fileUploadConfig` / `imageUploadConfig`.
- Constructor now takes a single `validator: StreamAttachmentValidator` parameter — derived from `StreamChatClient.appSettings` by default when used through `StreamMessageComposer`.

#### Migration Steps:

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
} on AttachmentBlockedError catch (e) {
  // Extension or MIME type rejected by backend AppSettings
  showError('Attachment type not allowed (${e.fileExtension ?? e.mimeType}).');
}
```

> **Important:**
> - Replace `ArgumentError` catches with the specific typed errors.
> - `AttachmentTooLargeError` provides `fileSize` and `maxSize` properties.
> - `AttachmentLimitReachedError` provides `maxCount` property.
> - `AttachmentBlockedError` provides `fileExtension` and `mimeType` (both nullable — populated regardless of which list triggered the rejection).
> - To bypass the backend rules, construct your own `StreamAttachmentValidator` and pass it to the picker controller.

---

## Reactions

The reaction system has been updated to use explicit callbacks and a unified `Reaction` object API.

---

### SendReaction

> **Introduced in:** [v10.0.0-beta.4](https://pub.dev/packages/stream_chat_flutter/versions/10.0.0-beta.4)

#### Key Changes:

- `sendReaction` method now accepts a full `Reaction` object instead of individual parameters.

#### Migration Steps:

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

> **Important:**
> - The `sendReaction` method now requires a `Reaction` object
> - Optional parameters like `enforceUnique` and `skipPush` remain as method parameters
> - You can now specify custom emoji codes for reactions using the `emojiCode` field

---

### StreamReactionPicker

> **Introduced in:** [v10.0.0-beta.1](https://pub.dev/packages/stream_chat_flutter/versions/10.0.0-beta.1)

#### Key Changes:

- The chat-domain reaction picker widget is now `StreamMessageReactionPicker` (in `stream_chat_flutter`).
- It wraps the domain-agnostic `StreamReactionPicker` from `stream_core_flutter`, resolving reaction icons automatically via `ReactionIconResolver`.
- The widget only accepts `message` and `onReactionPicked` — there are no `padding`, `scrollable`, `borderRadius`, or `reactionIcons` parameters on the chat-level class.
- Automatic reaction handling (sending to the channel) has been removed from the widget — you must supply `onReactionPicked`.

#### Migration Steps:

**Before:**
```dart
StreamReactionPicker(
  message: message,
);
```

**After:**
```dart
StreamMessageReactionPicker(
  message: message,
  onReactionPicked: (Reaction reaction) {
    // Handle reaction — e.g. send or remove via channel
    channel.sendReaction(message, reaction);
  },
);
```

> **Important:**
> - Use `StreamMessageReactionPicker` (not `StreamReactionPicker`) for chat use cases.
> - `StreamReactionPicker` from `stream_core_flutter` is the domain-agnostic primitive; it accepts `List<StreamReactionPickerItem>` and `onReactionPicked` (a `ValueSetter<StreamReactionPickerItem>`), not chat `Message` objects.
> - `onReactionPicked` is now required for any reaction to be handled.

---

### ReactionPickerIconList

> **Introduced in:** [v10.0.0-beta.9](https://pub.dev/packages/stream_chat_flutter/versions/10.0.0-beta.9)

#### Key Changes:

- `ReactionPickerIconList` and `ReactionPickerIcon` have been **removed**. They no longer exist in the public API.
- Their functionality has been absorbed into the domain-agnostic `StreamReactionPicker` (from `stream_core_flutter`) and its `StreamReactionPickerItem` model.

#### Migration Steps:

If you were using `ReactionPickerIconList` directly, replace it with `StreamMessageReactionPicker` for chat use cases:

```dart
// Use the high-level chat wrapper instead
StreamMessageReactionPicker(
  message: message,
  onReactionPicked: (reaction) {
    channel.sendReaction(message, reaction);
  },
)
```

For advanced cases that required direct control over each icon, use `StreamReactionPicker` with `StreamReactionPickerItem` objects:

```dart
// Build items with selection state from the message's own reactions
final ownReactionsMap = {for (final r in [...?message.ownReactions]) r.type: r};

StreamReactionPicker(
  items: reactionTypes.map((type) => StreamReactionPickerItem(
    key: type,
    emoji: resolver.resolve(type),
    isSelected: ownReactionsMap[type] != null,
  )).toList(),
  onReactionPicked: (item) {
    final reaction = ownReactionsMap[item.key] ?? Reaction(type: item.key);
    channel.sendReaction(message, reaction);
  },
)
```

> **Important:**
> - `ReactionPickerIconList` and `ReactionPickerIcon` no longer exist.
> - Use `StreamMessageReactionPicker` for most chat scenarios.
> - If you need the core picker directly, use `StreamReactionPicker` with `StreamReactionPickerItem` (from `stream_core_flutter`).

---

### StreamMessageReactionsModal

> **Introduced in:** [v10.0.0-beta.1](https://pub.dev/packages/stream_chat_flutter/versions/10.0.0-beta.1)

#### Key Changes:

- `StreamMessageReactionsModal` has been **removed**.
- The reaction detail view is now `ReactionDetailSheet`, shown as a modal bottom sheet via `ReactionDetailSheet.show(...)`.

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
ReactionDetailSheet.show(
  context: context,
  message: message,
);
```

> **Important:**
> - `StreamMessageReactionsModal` no longer exists. Remove all references to it.
> - `ReactionDetailSheet` fetches and paginates reactions from the server; it does not need a pre-built message widget.
> - To intercept reaction detail display, provide a custom `onReactionsTap` callback to `StreamMessageItem` — the default implementation calls `ReactionDetailSheet.show`.

---

## Message UI

Updates to message widgets, attachment handling, and custom action patterns.

---

### onAttachmentTap

> **Introduced in:** [v10.0.0-beta.9](https://pub.dev/packages/stream_chat_flutter/versions/10.0.0-beta.9)

#### Key Changes:

- `onAttachmentTap` is a `StreamAttachmentWidgetTapCallback` — a `void Function(Message message, Attachment attachment)` typedef defined on `StreamAttachmentWidgetBuilder`.
- It does **not** receive `BuildContext` and does **not** return `FutureOr<bool>`. The signature is simply `void Function(Message, Attachment)`.
- It is not a parameter on `StreamMessageItem` directly. Pass custom attachment builders via the `attachmentBuilders` parameter, each of which may set its own `onTap` using this signature.

#### Migration Steps:

**Before:**
```dart
// Old attachment builder with custom tap
myBuilder.onTap = (message, attachment) { ... };
```

**After:**
```dart
// The typedef is:
// typedef StreamAttachmentWidgetTapCallback = void Function(Message, Attachment);

// Supply custom attachment builders to StreamMessageItem to intercept taps:
StreamMessageItem(
  message: message,
  attachmentBuilders: [
    MyCustomAttachmentBuilder(
      onAttachmentTap: (Message message, Attachment attachment) {
        if (attachment.type == 'location') {
          showLocationDialog(context, attachment);
        }
      },
    ),
  ],
)
```

> **Important:**
> - The signature is `void Function(Message, Attachment)` — no `BuildContext`, no return value.
> - `onAttachmentTap` is a property on individual `StreamAttachmentWidgetBuilder` subclasses, not on `StreamMessageItem` itself.
> - Each built-in attachment builder (image, video, file, giphy, link preview) accepts an `onAttachmentTap` in its constructor if you need to override its tap behavior.

---

### StreamMessageItem

> **Introduced in:** [v10.0.0-beta.1](https://pub.dev/packages/stream_chat_flutter/versions/10.0.0-beta.1)

#### Key Changes:

- `showReactionTail` parameter has been removed
- Tail now automatically shows when the picker is visible

#### Migration Steps:

**Before:**
```dart
StreamMessageItem(
  message: message,
  showReactionTail: true,
);
```

**After:**
```dart
StreamMessageItem(
  message: message,
);
```

> **Important:**  
> The `showReactionTail` parameter is no longer supported. Tail is now always shown when the picker is visible.

---

### StreamMessageAction

> **Introduced in:** [v10.0.0-beta.1](https://pub.dev/packages/stream_chat_flutter/versions/10.0.0-beta.1)

#### Key Changes:

- `StreamMessageAction` as a standalone widget class does **not** exist. The message action system uses the sealed `MessageAction` class hierarchy combined with `StreamContextMenuAction<T extends MessageAction>`.
- Built-in actions are concrete `final` subclasses of the `MessageAction` sealed class: `SelectReaction`, `CopyMessage`, `DeleteMessage`, `EditMessage`, `FlagMessage`, `PinMessage`, `ThreadReply`, `QuotedReply`, and others.
- To inject custom actions into the long-press menu, provide an `actionsBuilder` callback on `StreamMessageItem`. The builder receives the default list of `StreamContextMenuAction`s and must return a `List<Widget>`.
- There is no `customActions` parameter or `onCustomActionTap` callback on `StreamMessageItem`.

#### Migration Steps:

**Before (v9 pattern):**
```dart
// v9-style action with individual onTap
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
StreamMessageItem(
  message: message,
  actionsBuilder: (context, defaultActions) {
    return [
      ...defaultActions,
      StreamContextMenuAction<MessageAction>(
        value: CopyMessage(message: message), // use nearest built-in or subclass
        leading: const Icon(Icons.settings),
        label: const Text('Custom Action'),
        onTap: () {
          // Handle custom action directly in onTap
        },
      ),
    ];
  },
)
```

> **Important:**
> - There is no `StreamMessageAction` widget class; use `StreamContextMenuAction<T>` from `stream_core_flutter`.
> - `StreamContextMenuAction` accepts `onTap` directly — no separate callback dispatch is needed.
> - `actionsBuilder` on `StreamMessageItem` provides the default actions list, which you can extend, filter, or reorder before returning.

---

## Message State & Deletion

Message deletion now supports scoped deletion modes including delete-for-me functionality.

---

### MessageState

> **Introduced in:** [v10.0.0-beta.7](https://pub.dev/packages/stream_chat_flutter/versions/10.0.0-beta.7)

#### Key Changes:

- `MessageState` factory constructors now accept `MessageDeleteScope` instead of `bool hard` parameter
- Pattern matching callbacks in state classes now receive `MessageDeleteScope scope` instead of `bool hard`
- New delete-for-me functionality with dedicated states and methods

#### Migration Steps:

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

> **Important:**
> - All `MessageState` factory constructors now require `MessageDeleteScope` parameter
> - Pattern matching callbacks receive `MessageDeleteScope` instead of `bool hard`
> - Use `scope.hard` to access the hard delete boolean value
> - New delete-for-me methods are available on both `Channel` and `StreamChatClient`

---

## File Upload

The file uploader interface has been expanded with standalone upload and removal methods.

---

### AttachmentFileUploader

> **Introduced in:** [v10.0.0-beta.7](https://pub.dev/packages/stream_chat_flutter/versions/10.0.0-beta.7)

#### Key Changes:

- `AttachmentFileUploader` interface now includes four new abstract methods: `uploadImage`, `uploadFile`, `removeImage`, and `removeFile`.
- Custom implementations must implement these new standalone upload/removal methods.

#### Migration Steps:

**Before:**
```dart
class CustomAttachmentFileUploader implements AttachmentFileUploader {
  // Only needed to implement sendImage, sendFile, deleteImage, deleteFile
  
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
  // Must now implement all 8 methods including the new standalone ones
  
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

> **Important:**
> - Custom `AttachmentFileUploader` implementations must now implement four additional methods
> - The new methods support standalone uploads/removals without requiring channel context
> - `UploadImageResponse` and `UploadFileResponse` are aliases for `SendAttachmentResponse`

---

## Unread Threads Banner

#### Key Changes:

- `StreamUnreadThreadsBanner` is now a **wrapper widget** instead of a standalone banner placed in a `Column`.
- New `child` parameter — wrap your `StreamThreadListView` instead of placing the banner as a sibling.
- `onTap` (`VoidCallback?`) replaced by `onRefresh` (`Future<void> Function()?`) — shows a loading spinner while the future is pending.
- `minHeight` parameter **removed**.
- `margin` default changed from `EdgeInsets.symmetric(horizontal: 8, vertical: 6)` to `EdgeInsets.zero`.
- `padding` default changed from `EdgeInsets.symmetric(horizontal: 16)` to `EdgeInsets.all(spacing.sm)`.

#### Migration Steps:

**Before:**
```dart
Column(
  children: [
    ValueListenableBuilder(
      valueListenable: controller.unseenThreadIds,
      builder: (_, unreadThreads, __) => StreamUnreadThreadsBanner(
        unreadThreads: unreadThreads,
        onTap: () => controller
            .refresh(resetValue: false)
            .then((_) => controller.clearUnseenThreadIds()),
      ),
    ),
    Expanded(
      child: StreamThreadListView(controller: controller),
    ),
  ],
);
```

**After:**
```dart
ValueListenableBuilder<Set<String>>(
  valueListenable: controller.unseenThreadIds,
  builder: (context, unseenThreadIds, child) => StreamUnreadThreadsBanner(
    enabled: unseenThreadIds.isNotEmpty,
    unreadThreads: unseenThreadIds,
    onRefresh: () async {
      await controller.refresh(resetValue: false);
      controller.clearUnseenThreadIds();
    },
    child: child!,
  ),
  child: StreamThreadListView(controller: controller),
);
```

---

## Stable Release Changes

> **Introduced in:** v10.0.0 (stable)

The following breaking changes landed between beta.12 and the stable release.

### StreamMessageListView Config / Builders Split

Behavior flags moved to `StreamMessageListViewConfiguration`; builder callbacks moved to `StreamMessageListViewBuilders`. `messageBuilder` stays at the root.

```dart
// Before
StreamMessageListView(
  swipeToReply: true,
  paginationLimit: 20,
  loadingBuilder: (context) => const MyLoader(),
  emptyBuilder: (context) => const MyEmpty(),
)

// After
StreamMessageListView(
  config: StreamMessageListViewConfiguration(
    swipeToReply: true,
    paginationLimit: 20,
  ),
  builders: StreamMessageListViewBuilders(
    loading: (context) => const MyLoader(),
    empty: (context) => const MyEmpty(),
  ),
)
```

---

### StreamMessageComposerController Rename

| Old                                            | New                                         |
| ---------------------------------------------- | ------------------------------------------- |
| `StreamMessageInputController`                 | `StreamMessageComposerController`           |
| `StreamRestorableMessageInputController`       | `StreamRestorableMessageComposerController` |
| `editingOriginalMessage`                       | `messageBeingEdited`                        |
| `StreamMessageComposer.messageInputController` | `messageComposerController`                 |

**Edit-mode semantics changed:**

```dart
// Before — constructor accepted a non-initial message
final controller = StreamMessageComposerController(message: existingMessage);
controller.clear(); // also exited edit mode

// After — enter edit mode explicitly
final controller = StreamMessageComposerController();
controller.editMessage(existingMessage);
controller.cancelEditMessage(); // explicit exit
```

---

### StreamMessageComposerInput Split

`StreamMessageComposerInput` has been **split** — both names now exist and serve different roles:

| Class                                     | Role                                                              |
| ----------------------------------------- | ----------------------------------------------------------------- |
| `StreamMessageComposerInput`              | Outer container (the full input row including leading/trailing)   |
| `StreamMessageComposerInputCenter`        | Center content only (text field, attachments preview, etc.)       |
| `DefaultStreamMessageComposerInput`       | Default outer container implementation                            |
| `DefaultStreamMessageComposerInputCenter` | Default center implementation                                     |
| `MessageComposerInputProps`               | Props for the outer container                                     |
| `MessageComposerInputCenterProps`         | Props for the center widget                                       |

If you were previously using `StreamMessageComposerInput` to customise the **text field area**, you need to target `StreamMessageComposerInputCenter` (and the `messageComposerInputCenter` builder key) instead. The `messageComposerInput` builder key now controls the outer container.

> **Important:**
> This is a split, not a rename. `StreamMessageComposerInput` still exists; targeting it replaces the entire input row. To replace only the text field area, use `StreamMessageComposerInputCenter`.

---

### StreamDraftListView and Related Classes Removed

`StreamDraftListView`, `StreamDraftListTile`, `StreamDraftListTileTheme`, `StreamDraftListTileThemeData`, and `StreamChatThemeData.draftListTileTheme` have been removed. Use `StreamDraftListController` with a generic `PagedValueListView`. See the sample app for a reference implementation.

---

### Removed Widgets

| Removed Widget                                      | Notes                                                                                                             |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `AttachmentButton`                                  | Replaced by the attachment button inside `StreamMessageComposer`                                                  |
| `StreamQuotedMessageWidget`                         | Use `StreamQuotedMessage`                                                                                         |
| `EditMessageSheet`                                  | Editing is handled inline by the composer                                                                         |
| `StreamMessageSendButton`                           | Part of the composer internals                                                                                    |
| `DesktopReactionsBuilder`                           | Use `ReactionDetailSheet`                                                                                         |
| `StreamChannelGridView` / `StreamChannelGridTile`   | Removed                                                                                                           |
| `StreamMessageSearchGridView`                       | Removed                                                                                                           |
| `AttachmentModalSheet`                              | Removed                                                                                                           |
| `ErrorAlertSheet`                                   | No longer publicly exported; still used internally by `StreamMessageComposer`                                     |
| `StreamChannelInfoBottomSheet`                      | Removed                                                                                                           |
| `StreamMarkdownMessage`                             | Use `StreamMessageText`                                                                                           |
| `StreamAttachmentUploadStateBuilder.successBuilder` | Removed (unreachable)                                                                                             |
| `StreamFileAttachmentThumbnail`                     | Use `StreamImageAttachmentThumbnail` / `StreamVideoAttachmentThumbnail` or `StreamFileTypeIcon.fromMimeType(...)` |

---

### Theme Removals

| Removed                                                            | Notes                                         |
| ------------------------------------------------------------------ | --------------------------------------------- |
| `StreamMessageThemeData` / `ownMessageTheme` / `otherMessageTheme` | Use `StreamMessageItemThemeData`              |
| `StreamMessageInputThemeData` / `messageInputTheme`                | Use design-system primitives on `StreamTheme` |
| `StreamChannelPreviewThemeData` / `channelPreviewTheme`            | Use `StreamChannelListItemThemeData`          |

---

### Poll Dialogs → Sheets

| Old                                                               | New                                                             |
| ----------------------------------------------------------------- | --------------------------------------------------------------- |
| `StreamPollCreatorDialog` / `showStreamPollCreatorDialog`         | `StreamPollCreatorSheet` / `showStreamPollCreatorSheet`         |
| `StreamPollOptionsDialog` / `showStreamPollOptionsDialog`         | `StreamPollOptionsSheet` / `showStreamPollOptionsSheet`         |
| `StreamPollResultsDialog` / `showStreamPollResultsDialog`         | `StreamPollResultsSheet` / `showStreamPollResultsSheet`         |
| `StreamPollOptionVotesDialog` / `showStreamPollOptionVotesDialog` | `StreamPollOptionVotesSheet` / `showStreamPollOptionVotesSheet` |
| `StreamPollCommentsDialog` / `showStreamPollCommentsDialog`       | `StreamPollCommentsSheet` / `showStreamPollCommentsSheet`       |

---

### Translations: attachmentsUploadProgressText

The parameter `remaining:` has been renamed to `completed:`.

```dart
// Before
translations.attachmentsUploadProgressText(remaining: 2, total: 5)

// After
translations.attachmentsUploadProgressText(completed: 3, total: 5)
```

---

### StreamChatCore: recoverStateOnReconnect and backgroundKeepAlive

`StreamChatCore` now sets `client.recoverStateOnReconnect = false` on mount. If you watch a `Channel` outside any list controller, subscribe to `client.on(EventType.connectionRecovered)` and call `channel.watch()` to refresh on reconnect.

The default `StreamChat.backgroundKeepAlive` has been reduced from 1 minute to 15 seconds.

---

### stream_chat: ClientState Collection Immutability

`ClientState.channels`, `ClientState.users`, and `ClientState.activeLiveLocations` are now backed by immutable subject types (`ImmutableMapBehaviorSubject` / `ImmutableListBehaviorSubject`). The map and list values they expose are unmodifiable — mutating them at runtime throws an `UnsupportedError`.

In addition, the following setters and methods are now `@internal` and must not be called from application code:

- `ClientState.channels=` (setter)
- `ClientState.addChannels(...)`
- `ClientState.removeChannel(...)`
- `ClientState.activeLiveLocations=` (setter)

#### Migration Steps:

If your code mutated these collections directly, remove those mutations. All state changes must go through the public SDK APIs (`StreamChatClient`, `Channel`, etc.):

```dart
// Before — direct mutation (no longer allowed)
client.state.channels[channel.cid] = channel;
client.state.addChannels({channel.cid: channel});
client.state.removeChannel(channel.cid);

// After — use the SDK APIs; state is managed internally
await client.queryChannels(...);  // populates channels automatically
await channel.watch();            // adds/refreshes a single channel in state
```

> **Important:**
> - Reading `channels`, `users`, and `activeLiveLocations` is unchanged — the getters still work.
> - Do not cast the returned collections to `Map`/`List` and call mutating methods; those calls will throw at runtime.
> - Code that previously relied on `addChannels` or `removeChannel` for optimistic state management must be reworked to use the SDK's own query and watch methods.

---

### stream_chat: SortOption Constructor Rename

The unnamed positional constructor `SortOption(field, direction)` has been removed. Use the named constructors instead.

```dart
// Before
const [SortOption('last_message_at', direction: SortOption.DESC)]
const [SortOption('name', direction: SortOption.ASC)]

// After
const [SortOption.desc('last_message_at')]
const [SortOption.asc('name')]
```

> **Important:**
> - `SortOption.desc()` defaults `nullOrdering` to `NullOrdering.nullsFirst`
> - `SortOption.asc()` defaults `nullOrdering` to `NullOrdering.nullsLast`

---

### stream_chat: Channel.isOneToOne and Message.updateWith

- `Channel.isOneToOne` added — returns `true` for distinct two-member channels.
- `Channel.isGroup` semantics changed: two-member non-distinct channels now return `true`. Use `!channel.isOneToOne` for "DM" checks.
- `Message.syncWith` deprecated in favor of `Message.updateWith` (note the flipped arguments: `local.updateWith(remote)` replaces `remote.syncWith(local)`).

---

## Appendix: Beta Release Timeline

This appendix provides a chronological reference of breaking changes by beta version for users upgrading from specific pre-release versions.

### v10.0.0-beta.1

- [StreamReactionPicker](#streamreactionpicker)
- [StreamMessageAction](#streammessageaction)
- [StreamMessageReactionsModal](#streammessagereactionsmodal)
- [StreamMessageItem](#streammessageitem)

### v10.0.0-beta.3

- [AttachmentPickerType](#attachmentpickertype)
- [StreamAttachmentPickerOption](#streamattachmentpickeroption)
- [showStreamAttachmentPickerModalBottomSheet](#showstreamattachmentpickermodalbottomsheet)
- [AttachmentPickerBottomSheet](#attachmentpickerbottomsheet)

### v10.0.0-beta.4

- [SendReaction](#sendreaction)

### v10.0.0-beta.7

- [AttachmentFileUploader](#attachmentfileuploader)
- [MessageState](#messagestate)

### v10.0.0-beta.8

- [customAttachmentPickerOptions](#customattachmentpickeroptions)
- [onCustomAttachmentPickerResult](#oncustomattachmentpickerresult)

### v10.0.0-beta.9

- [onAttachmentTap](#onattachmenttap)
- [ReactionPickerIconList](#reactionpickericonlist)

### v10.0.0-beta.12

- [StreamAttachmentPickerController](#streamattachmentpickercontroller)

### v10.0.0 (stable)

- [Stable Release Changes](#stable-release-changes)

---

## Migration Checklist

### For v10.0.0 (stable)
- [ ] Move `StreamMessageListView` behavior flags to `config: StreamMessageListViewConfiguration(...)`
- [ ] Move `StreamMessageListView` builder callbacks to `builders: StreamMessageListViewBuilders(...)`
- [ ] Rename `StreamMessageInputController` → `StreamMessageComposerController`
- [ ] Rename `StreamRestorableMessageInputController` → `StreamRestorableMessageComposerController`
- [ ] Rename `StreamMessageComposer.messageInputController` → `messageComposerController`
- [ ] Replace `StreamMessageComposerController(message: ...)` with `.editMessage()` to enter edit mode
- [ ] Replace `controller.clear()` (used to exit edit mode) with `controller.cancelEditMessage()`
- [ ] Rename `editingOriginalMessage` → `messageBeingEdited`
- [ ] If you customised the text field area via `StreamMessageComposerInput`, switch to `StreamMessageComposerInputCenter` (and builder key `messageComposerInputCenter`); `StreamMessageComposerInput` now controls the entire outer input row
- [ ] Remove `StreamDraftListView`, `StreamDraftListTile`, and theme classes — use `StreamDraftListController` + `PagedValueListView`
- [ ] Replace removed widgets: `AttachmentButton`, `StreamQuotedMessageWidget`, `EditMessageSheet`, `StreamMessageSendButton`, etc. (see table)
- [ ] Remove `StreamMessageThemeData` / `StreamMessageInputThemeData` / `StreamChannelPreviewThemeData` usage
- [ ] Replace `StreamPollCreatorDialog` and other poll dialog helpers with the `...Sheet` equivalents
- [ ] Rename `attachmentsUploadProgressText(remaining: ...)` → `attachmentsUploadProgressText(completed: ...)`
- [ ] If watching a channel outside a list controller, subscribe to `connectionRecovered` and call `channel.watch()`
- [ ] Replace `SortOption('field', direction: SortOption.DESC)` with `SortOption.desc('field')` and `SortOption('field', direction: SortOption.ASC)` with `SortOption.asc('field')`
- [ ] Migrate `Message.syncWith(local)` → `local.updateWith(remote)` (arguments are flipped)
- [ ] Review `Channel.isGroup` usage — use `channel.isOneToOne` for two-member DM checks
- [ ] Remove any code that mutates `ClientState.channels`, `ClientState.users`, or `ClientState.activeLiveLocations` directly (setters and `addChannels`/`removeChannel` are now `@internal`)

### Unread Threads Banner
- [ ] Replace `Column` + `Expanded` layout with `StreamUnreadThreadsBanner(child: StreamThreadListView(...))`
- [ ] Replace `onTap` with `onRefresh` (returns `Future<void>`)
- [ ] Add `enabled: true` to show the banner (defaults to hidden)
- [ ] Remove `minHeight` parameter if used

### For v10.0.0-beta.12:
- [ ] Replace `ArgumentError('The size of the attachment is...')` with `AttachmentTooLargeError` (provides `fileSize` and `maxSize` properties)
- [ ] Replace `ArgumentError('The maximum number of attachments is...')` with `AttachmentLimitReachedError` (provides `maxCount` property)

### For v10.0.0-beta.9:
- [ ] Update any custom `StreamAttachmentWidgetBuilder` subclasses whose `onAttachmentTap` callback now has the signature `void Function(Message, Attachment)` (no `BuildContext`, no return value)
- [ ] Replace any direct usage of `ReactionPickerIconList` / `ReactionPickerIcon` with `StreamMessageReactionPicker` or `StreamReactionPicker` + `StreamReactionPickerItem`

### For v10.0.0-beta.8:
- [ ] Replace `customAttachmentPickerOptions` with `attachmentPickerOptionsBuilder` to access and modify default options
- [ ] Replace `onCustomAttachmentPickerResult` with `onAttachmentPickerResult` that returns `FutureOr<bool>`

### For v10.0.0-beta.7:
- [ ] Update custom `AttachmentFileUploader` implementations to include the four new abstract methods: `uploadImage`, `uploadFile`, `removeImage`, and `removeFile`
- [ ] Update `MessageState` factory constructors to use `MessageDeleteScope` parameter
- [ ] Update pattern-matching callbacks to handle `MessageDeleteScope` instead of `bool hard`
- [ ] Leverage new delete-for-me functionality with `deleteMessageForMe` methods
- [ ] Use new state-checking methods for delete-for-me operations

### For v10.0.0-beta.4:
- [ ] Update `sendReaction` method calls to use `Reaction` object instead of individual parameters

### For v10.0.0-beta.3:
- [ ] Update attachment picker options to use `SystemAttachmentPickerOption` or `TabbedAttachmentPickerOption`
- [ ] Remove calls to `showStreamAttachmentPickerModalBottomSheet` — the picker is now inline inside `StreamMessageComposer`
- [ ] Replace `StreamMobileAttachmentPickerBottomSheet` / `StreamWebOrDesktopAttachmentPickerBottomSheet` with inline `StreamTabbedAttachmentPicker` / `StreamSystemAttachmentPicker` (no `BottomSheet` suffix)
- [ ] Fix `icon:` values from `Icon(Icons.xxx)` (Widget) to `Icons.xxx` (IconData) on all picker option constructors

### For v10.0.0-beta.1:
- [ ] Replace `StreamReactionPicker(message: ...)` with `StreamMessageReactionPicker(message: ..., onReactionPicked: ...)` and supply the `onReactionPicked` callback
- [ ] Remove `StreamMessageReactionsModal` usage — replaced by `ReactionDetailSheet.show(context: context, message: message)`
- [ ] Replace `StreamMessageAction` + `customActions` + `onCustomActionTap` patterns with `actionsBuilder` on `StreamMessageItem`, returning `StreamContextMenuAction` widgets
- [ ] Remove deprecated `showReactionTail` parameter from `StreamMessageItem`

---

**You're ready to migrate!** For additional help, visit the [Stream Chat Flutter documentation](https://getstream.io/chat/docs/sdk/flutter/) or open an issue on [GitHub](https://github.com/GetStream/stream-chat-flutter/issues).
