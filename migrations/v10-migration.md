# 🚀 Flutter SDK v10 Migration Guide

**Important!** This guide outlines all breaking changes introduced in the Flutter SDK **v10.0.0** release, including pre-release stages like `v10.0.0-beta.1`. Follow each section based on the version you're migrating from.

---

## 📋 Breaking Changes Overview

This guide includes breaking changes grouped by release phase:

### 🚧 Upcoming Beta

- [onAttachmentTap](#-onattachmenttap)
- [ReactionPickerIconList](#-reactionpickericonlist)

### 🚧 v10.0.0-beta.8

- [customAttachmentPickerOptions](#-customattachmentpickeroptions)
- [onCustomAttachmentPickerResult](#-oncustomattachmentpickerresult)

### 🚧 v10.0.0-beta.7

- [AttachmentFileUploader](#-attachmentfileuploader)
- [MessageState](#-messagestate)

### 🚧 v10.0.0-beta.4

- [SendReaction](#-sendreaction)

### 🚧 v10.0.0-beta.3

- [AttachmentPickerType](#-attachmentpickertype)
- [StreamAttachmentPickerOption](#-streamattachmentpickeroption)
- [showStreamAttachmentPickerModalBottomSheet](#-showstreamattachmentpickermodalbottomsheet)
- [AttachmentPickerBottomSheet](#-attachmentpickerbottomsheet)

### 🚧 v10.0.0-beta.1

- [StreamReactionPicker](#-streamreactionpicker)
- [StreamMessageAction](#-streammessageaction)
- [StreamMessageReactionsModal](#-streammessagereactionsmodal)
- [StreamMessageWidget](#-streammessagewidget)

---

## 🧪 Migration for Upcoming Beta

### 🛠 onAttachmentTap

#### Key Changes:

- `onAttachmentTap` callback signature has changed to support custom attachment handling with automatic fallback to default behavior.
- Callback now receives `BuildContext` as the first parameter.
- Returns `FutureOr<bool>` to indicate whether the attachment was handled.
- Returning `true` skips default behavior, `false` uses default handling (URLs, images, videos, giphys).

#### Migration Steps:

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

**Example: Handling multiple custom types**
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

> ⚠️ **Important:**  
> - The callback now requires `BuildContext` as the first parameter
> - Must return `FutureOr<bool>` - `true` if handled, `false` for default behavior
> - Default behavior automatically handles URL previews, images, videos, and giphys
> - Supports both synchronous and asynchronous operations

---

### 🛠 ReactionPickerIconList

#### Key Changes:

- `message` parameter has been removed
- `reactionIcons` type changed from `List<StreamReactionIcon>` to `List<ReactionPickerIcon>`
- `onReactionPicked` callback renamed to `onIconPicked` with new signature: `ValueSetter<ReactionPickerIcon>`
- `iconBuilder` parameter changed from default value to nullable with internal fallback
- Message-specific logic (checking for own reactions) moved to parent widget

#### Migration Steps:

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

> ⚠️ **Important:**  
> - This is typically an internal widget used by `StreamReactionPicker`
> - If you were using it directly, you now need to handle reaction selection state externally
> - Use `StreamReactionPicker` for most use cases instead of `ReactionPickerIconList`

---

## 🧪 Migration for v10.0.0-beta.8

### 🛠 customAttachmentPickerOptions

#### Key Changes:

- `customAttachmentPickerOptions` has been removed. Use `attachmentPickerOptionsBuilder` instead.
- New builder pattern provides access to default options which can be modified, reordered, or extended.

#### Migration Steps:

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
    // You can now modify, filter, reorder, or extend default options
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

**Example: Filtering default options**
```dart
StreamMessageInput(
  attachmentPickerOptionsBuilder: (context, defaultOptions) {
    // Remove poll option
    return defaultOptions.where((option) => option.key != 'poll').toList();
  },
)
```

**Example: Reordering options**
```dart
StreamMessageInput(
  attachmentPickerOptionsBuilder: (context, defaultOptions) {
    // Reverse the order
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

> ⚠️ **Important:**  
> - The builder pattern gives you access to default options, allowing more flexible customization
> - The builder works with both mobile (tabbed) and desktop (system) pickers

---

### 🛠 onCustomAttachmentPickerResult

#### Key Changes:

- `onCustomAttachmentPickerResult` has been removed. Use `onAttachmentPickerResult` which returns `FutureOr<bool>`.
- Result handler can now short-circuit default behavior by returning `true`.

#### Migration Steps:

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
      return true; // Indicate we handled it - skips default processing
    }
    return false; // Let default handler process other result types
  },
)
```

> ⚠️ **Important:**  
> - `onAttachmentPickerResult` replaces `onCustomAttachmentPickerResult` and must return a boolean
> - Return `true` from `onAttachmentPickerResult` to skip default handling
> - Return `false` to allow the default handler to process the result

---

## 🧪 Migration for v10.0.0-beta.7

### 🛠 AttachmentFileUploader

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

> ⚠️ **Important:**  
> - Custom `AttachmentFileUploader` implementations must now implement four additional methods
> - The new methods support standalone uploads/removals without requiring channel context
> - `UploadImageResponse` and `UploadFileResponse` are aliases for `SendAttachmentResponse`

---

### 🛠 MessageState

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

> ⚠️ **Important:**  
> - All `MessageState` factory constructors now require `MessageDeleteScope` parameter
> - Pattern matching callbacks receive `MessageDeleteScope` instead of `bool hard`
> - Use `scope.hard` to access the hard delete boolean value
> - New delete-for-me methods are available on both `Channel` and `StreamChatClient`

---

## 🧪 Migration for v10.0.0-beta.4

### 🛠 SendReaction

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

> ⚠️ **Important:**  
> - The `sendReaction` method now requires a `Reaction` object
> - Optional parameters like `enforceUnique` and `skipPush` remain as method parameters
> - You can now specify custom emoji codes for reactions using the `emojiCode` field

---

## 🧪 Migration for v10.0.0-beta.3

### 🛠 AttachmentPickerType

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

> ⚠️ **Important:**  
> The enum is now a sealed class, but the basic usage remains the same for built-in types.

---

### 🛠 StreamAttachmentPickerOption

#### Key Changes:

- `StreamAttachmentPickerOption` replaced with two sealed classes:
  - `SystemAttachmentPickerOption` for system pickers (camera, files)
  - `TabbedAttachmentPickerOption` for tabbed pickers (gallery, polls, location)

#### Migration Steps:

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

> ⚠️ **Important:**  
> - Use `SystemAttachmentPickerOption` for system pickers (camera, file dialogs)
> - Use `TabbedAttachmentPickerOption` for custom UI pickers (gallery, polls)

---

### 🛠 showStreamAttachmentPickerModalBottomSheet

#### Key Changes:

- Now returns `StreamAttachmentPickerResult` instead of `AttachmentPickerValue`
- Improved type safety and clearer intent handling

#### Migration Steps:

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

> ⚠️ **Important:**  
> Always handle the new `StreamAttachmentPickerResult` return type with proper switch cases.

---

### 🛠 AttachmentPickerBottomSheet

#### Key Changes:

- `StreamMobileAttachmentPickerBottomSheet` → `StreamTabbedAttachmentPickerBottomSheet`
- `StreamWebOrDesktopAttachmentPickerBottomSheet` → `StreamSystemAttachmentPickerBottomSheet`

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

> ⚠️ **Important:**  
> The new names better reflect their respective layouts and functionality.

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

### For Upcoming Beta:
- ✅ Update `onAttachmentTap` callback signature to include `BuildContext` as first parameter
- ✅ Return `FutureOr<bool>` from `onAttachmentTap` - `true` if handled, `false` for default behavior
- ✅ Leverage automatic fallback to default handling for standard attachment types (images, videos, URLs)
- ✅ Update any direct usage of `ReactionPickerIconList` to handle reaction selection state externally

### For v10.0.0-beta.8:
- ✅ Replace `customAttachmentPickerOptions` with `attachmentPickerOptionsBuilder` to access and modify default options
- ✅ Replace `onCustomAttachmentPickerResult` with `onAttachmentPickerResult` that returns `FutureOr<bool>`

### For v10.0.0-beta.7:
- ✅ Update custom `AttachmentFileUploader` implementations to include the four new abstract methods: `uploadImage`, `uploadFile`, `removeImage`, and `removeFile`
- ✅ Update `MessageState` factory constructors to use `MessageDeleteScope` parameter
- ✅ Update pattern matching callbacks to handle `MessageDeleteScope` instead of `bool hard`
- ✅ Leverage new delete-for-me functionality with `deleteMessageForMe` methods
- ✅ Use new state checking methods for delete-for-me operations

### For v10.0.0-beta.4:
- ✅ Update `sendReaction` method calls to use `Reaction` object instead of individual parameters

### For v10.0.0-beta.3:
- ✅ Update attachment picker options to use `SystemAttachmentPickerOption` or `TabbedAttachmentPickerOption`
- ✅ Handle new `StreamAttachmentPickerResult` return type from attachment picker
- ✅ Use renamed bottom sheet classes (`StreamTabbedAttachmentPickerBottomSheet`, `StreamSystemAttachmentPickerBottomSheet`)

### For v10.0.0-beta.1:
- ✅ Use `StreamReactionPicker.builder` or supply `onReactionPicked`
- ✅ Convert all `StreamMessageAction` instances to type-safe generic usage
- ✅ Centralize handling with `onCustomActionTap`
- ✅ Remove deprecated props like `showReactionTail` and `messageTheme`
