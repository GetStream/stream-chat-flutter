## 7.0.0-beta.1

🛑️ Breaking

- Removed deprecated `ChannelPreview` widget. Use `StreamChannelListTile` instead.
- Removed deprecated `ChannelPreviewBuilder`, Use `StreamChannelListViewIndexedWidgetBuilder` instead.
- Removed deprecated `StreamUserItem` widget. Use `StreamUserListTile` instead.
- Removed deprecated `ReturnActionType` enum, No longer used.
- Removed deprecated `StreamMessageInput.attachmentThumbnailBuilders` parameter. Use
  `StreamMessageInput.mediaAttachmentBuilder` instead.
- Removed deprecated `MessageListView.onMessageSwiped` parameter. Try wrapping the `MessageWidget` with
  a `Swipeable`, `Dismissible` or a custom widget to achieve the swipe to reply behaviour.
- Removed deprecated `MessageWidget.showReactionPickerIndicator` parameter. Use `MessageWidget.showReactionPicker`
  instead.
- Removed deprecated `MessageWidget.bottomRowBuilder` parameter. Use `MessageWidget.bottomRowBuilderWithDefaultWidget`
  instead.
- Removed deprecated `MessageWidget.deletedBottomRowBuilder` parameter.
  Use `MessageWidget.deletedBottomRowBuilderWithDefaultWidget` instead.
- Removed deprecated `MessageWidget.usernameBuilder` parameter. Use `MessageWidget.usernameBuilderWithDefaultWidget`
  instead.
- Removed deprecated `MessageTheme.linkBackgroundColor` parameter. Use `MessageTheme.urlAttachmentBackgroundColor`
  instead.
- Removed deprecated `showConfirmationDialog` method. Use `showConfirmationBottomSheet` instead.
- Removed deprecated `showInfoDialog` method. Use `showInfoBottomSheet` instead.
- Removed deprecated `wrapAttachmentWidget` method. Use `WrapAttachmentWidget` class instead.

✅ Added

- Added support for `StreamMessageInput.contentInsertionConfiguration` to specify the content insertion configuration.
  [#1613](https://github.com/GetStream/stream-chat-flutter/issues/1613)

  ```dart
  StreamMessageInput(
    ...,
    contentInsertionConfiguration: ContentInsertionConfiguration(
      onContentInserted: (content) {
        // Do something with the content.
        controller.addAttachment(...);
      },
    ),
  )
  ```

🔄 Changed

- Updated minimum supported `SDK` version to Flutter 3.10/Dart 3.0
- Updated `jiffy` dependency to `^6.2.1`.

## 6.7.0

🔄 Changed

- Updated `stream_chat_flutter_core` dependency
  to [`6.6.0`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

## 6.6.0

🔄 Changed

- Updated minimum supported `SDK` version to Flutter 3.7/Dart 2.19

## 6.5.0

🐞 Fixed

- [[#1620]](https://github.com/GetStream/stream-chat-flutter/issues/1620) Fixed messages Are Not Hard Deleting even
  after overriding the `onConfirmDeleteTap` callback.
- [[#1621]](https://github.com/GetStream/stream-chat-flutter/issues/1621) Fixed `createdAtStyle` null check error
  in `SendingIndicatorBuilder`.
- [[#1069]](https://github.com/GetStream/stream-chat-flutter/issues/1069) Fixed message swipe to reply using same
  direction for both current user and other users. It now uses `SwipeDirection.startToEnd` for current user
  and `SwipeDirection.endToStart` for other users.
- [[#1590]](https://github.com/GetStream/stream-chat-flutter/issues/1590)
  Fixed `StreamMessageWidget.showReactionPickerIndicator` not toggling the reaction picker indicator visibility.
- [[#1639]](https://github.com/GetStream/stream-chat-flutter/issues/1639) Fixed attachments not showing in gallery view
  even after saving them to the device.
  > **Note**
  > This fix depends on the [image_gallery_saver](https://pub.dev/packages/image_gallery_saver) plugin. Make sure to add
  necessary permissions in your App as per the plugin documentation.
- [[#1642]](https://github.com/GetStream/stream-chat-flutter/issues/1642) Fixed `StreamMessageWidget.widthFactor` not
  working on web and desktop platforms.

✅ Added

- Added support for customizing attachments in `StreamMessageInput`. Use various properties mentioned
  below. [#1511](https://github.com/GetStream/stream-chat-flutter/issues/1511)
    * `StreamMessageInput.attachmentListBuilder` to customize the attachment list.
    * `StreamMessageInput.fileAttachmentListBuilder` to customize the file attachment list.
    * `StreamMessageInput.mediaAttachmentListBuilder` to customize the media attachment list. Includes images, videos
      and gifs.
    * `StreamMessageInput.fileAttachmentBuilder` to customize the file attachment item shown in `FileAttachmentList`.
    * `StreamMessageInput.mediaAttachmentBuilder` to customize the media attachment item shown in
      `MediaAttachmentList`.


- Added `StreamMessageInput.quotedMessageAttachmentThumbnailBuilders` to customize the thumbnail builders for quoted
  message attachments.

🔄 Changed

- Deprecated `StreamMessageInput.attachmentThumbnailBuilders` in favor of `StreamMessageInput.mediaAttachmentBuilder`.
- Deprecated `StreamMessageListView.onMessageSwiped`. Try wrapping the `MessageWidget` with a `Swipeable`, `Dismissible`
  or a custom widget to achieve the swipe to reply behaviour.

  ```dart
  // Migration from onMessageSwiped to Swipeable.
  StreamMessageListView(
    ...,
    messageBuilder: (context, messageDetails, messages, defaultWidget) {
      // The threshold after which the message should be considered as swiped.
      const threshold = 0.2;
  
      // The direction in which the message should be swiped to reply.
      final swipeDirection = messageDetails.isMyMessage
          ? SwipeDirection.endToStart //
          : SwipeDirection.startToEnd;
  
      return Swipeable(
        key: ValueKey(messageDetails.message.id),
        direction: swipeDirection,
        swipeThreshold: threshold,
        onSwiped: (direction) {
          // Handle the swipe action here.
        },
        backgroundBuilder: (context, details) {
          // The alignment of the swipe action.
          final alignment = messageDetails.isMyMessage
              ? Alignment.centerRight //
              : Alignment.centerLeft;
  
          // The progress of the swipe action.
          final progress = math.min(details.progress, threshold) / threshold;
  
          return Align(
            alignment: alignment,
            child: Opacity(
              opacity: progress,
              child: const Icon(
                Icons.reply,
                color: Colors.white,
              ),
            ),
          );
        },
        child: defaultWidget,
      );
    },
  )
  ```
- Deprecated `StreamMessageWidget.showReactionPickerIndicator` in favor of `StreamMessageWidget.showReactionPicker`.

  ```diff
  StreamMessageWidget(
  - showReactionPickerIndicator: true/false,
  + showReactionPicker: true/false,
  )
  ```
- Updated `video_player` dependency to `^2.7.0`.
- Updated `chewie` dependency to `^1.6.0`.
- Updated `share_plus` dependency to `^7.0.2`.
- Deprecated `StreamUserItem` in favor of `StreamUserListTile`.

## 6.4.0

🐞 Fixed

- [[#1600]](https://github.com/GetStream/stream-chat-flutter/issues/1600) Fixed type `ImageDecoderCallback` not found
  error on pre-Flutter 3.10.0 versions.
- [[#1605]](https://github.com/GetStream/stream-chat-flutter/issues/1605) Fixed Null exception is thrown on message list
  for unread messages when `ScrollToBottomButton` is pressed.
- [[#1615]](https://github.com/GetStream/stream-chat-flutter/issues/1615) Fixed `StreamAttachmentPickerBottomSheet` not
  able to find the `StreamChatTheme` when used in nested MaterialApp.

✅ Added

- Added support for `StreamMessageInput.allowedAttachmentPickerTypes` to specify the allowed attachment picker types.
  [#1601](https://github.com/GetStream/stream-chat-flutter/issues/1376)

  ```dart
  StreamMessageInput(
    ...,
    allowedAttachmentPickerTypes: const [
      AttachmentPickerType.files,
      AttachmentPickerType.images,
    ],
  )
  ```

- Added support for `StreamMessageWidget.onConfirmDeleteTap` to override the default action on delete confirmation.
  [#1604](https://github.com/GetStream/stream-chat-flutter/issues/1604)

  ```dart
  StreamMessageWidget(
    ...,
    onConfirmDeleteTap: (message) async {
      final channel = StreamChannel.of(context).channel;
      await channel.deleteMessage(message, hard: false);
    },
  )
  ```

- Added support for `StreamMessageWidget.quotedMessageBuilder` and `StreamMessageInput.quotedMessageBuilder` to override
  the default quoted message widget. [#1547](https://github.com/GetStream/stream-chat-flutter/issues/1547)

  ```dart
  StreamMessageWidget(
    ...,
    quotedMessageBuilder: (context, message) {
      return Container(
        color: Colors.red,
        child: Text('Quoted Message'),
      );
    },
  )
  ```

- Added support for `StreamChannelAvatar.ownSpaceAvatarBuilder`, `StreamChannelAvatar.oneToOneAvatarBuilder` and
  `StreamChannelAvatar.groupAvatarBuilder` to override the default avatar
  widget.[#1614](https://github.com/GetStream/stream-chat-flutter/issues/1614)

  ```dart
  StreamChannelAvatar(
    ...,
    ownSpaceAvatarBuilder: (context, channel) {
      return Container(
        color: Colors.red,
        child: Text('Own Space Avatar'),
      );
    },
    oneToOneAvatarBuilder: (context, channel) {
      return Container(
        color: Colors.red,
        child: Text('One to One Avatar'),
      );
    },
    groupAvatarBuilder: (context, channel) {
      return Container(
        color: Colors.red,
        child: Text('Group Avatar'),
      );
    },
  )
  ```

## 6.3.0

🐞 Fixed

- [[#1592]](https://github.com/GetStream/stream-chat-flutter/issues/1592) Fixed broken attachment download on web.
- [[#1591]](https://github.com/GetStream/stream-chat-flutter/issues/1591) Fixed `StreamChannelInfoBottomSheet` not
  rendering member list properly.
- [[#1427]](https://github.com/GetStream/stream-chat-flutter/issues/1427) Fixed unable to load asset error for
  `packages/stream_chat_flutter/lib/svgs/video_call_icon.svg`.

🔄 Changed

- Updated `dio` dependency to `^5.2.0`.

## 6.2.0

🐞 Fixed

- [[#1546]](https://github.com/GetStream/stream-chat-flutter/issues/1546)
  Fixed `StreamMessageInputTheme.linkHighlightColor` returning null for default theme.
- [[#1548]](https://github.com/GetStream/stream-chat-flutter/issues/1548) Fixed `StreamMessageInput` urlRegex only
  matching the lowercase `http(s)|ftp`.
- [[#1542]](https://github.com/GetStream/stream-chat-flutter/issues/1542) Handle error thrown in `StreamMessageInput`
  when unable to fetch a link preview.
- [[#1540]](https://github.com/GetStream/stream-chat-flutter/issues/1540) Use `CircularProgressIndicator.adaptive`
  instead of material indicator.
- [[#1490]](https://github.com/GetStream/stream-chat-flutter/issues/1490) Fixed `editMessageInputBuilder` property not
  used in `MessageActionsModal.editMessage` option.
- [[#1544]](https://github.com/GetStream/stream-chat-flutter/issues/1544) Fixed error thrown when unable to fetch
  image/data in Message link preview.
- [[#1482]](https://github.com/GetStream/stream-chat-flutter/issues/1482) Fixed `StreaChannelListTile` not showing
  unread indicator when `currentUser` is not present in the initial member list.
- [[#1487]](https://github.com/GetStream/stream-chat-flutter/issues/1487) Use localized title
  for `WebOrDesktopAttachmentPickerOption` in `StreamMessageInput`.
- [[#1250]](https://github.com/GetStream/stream-chat-flutter/issues/1250) Fixed bottomRow widgetSpans getting resized
  twice when `textScaling` is enabled.
- [[#1498]](https://github.com/GetStream/stream-chat-flutter/issues/1498) Fixed `MessageInput` autocomplete not working
  on non-mobile platforms.
- [[#1576]](https://github.com/GetStream/stream-chat-flutter/issues/1576) Temporary fix for `StreamMessageListView`
  getting broken when loaded at a particular message and a new message is added.

✅ Added

- Added support for `StreamMessageThemeData.urlAttachmentTextMaxLine` to specify the `.maxLines` for the url attachment
  text. [#1543](https://github.com/GetStream/stream-chat-flutter/issues/1543)

🔄 Changed

- Updated `shimmer` dependency to `^3.0.0`.
- Updated `image_gallery_saver` dependency to `^2.0.1`.
- Deprecated `ChannelPreview` in favor of `StreamChannelListTile`.
- Updated `stream_chat_flutter_core` dependency
  to [`6.2.0`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

## 6.1.0

🐞 Fixed

- [[#1502]](https://github.com/GetStream/stream-chat-flutter/issues/1502) Fixed `isOnlyEmoji` method Detects Single
  Hangul
  Consonants as Emoji.
- [[#1505]](https://github.com/GetStream/stream-chat-flutter/issues/1505) Fixed Message bubble disappears for Hangul
  Consonants.
- [[#1476]](https://github.com/GetStream/stream-chat-flutter/issues/1476) Fixed `UserAvatarTransform.userAvatarBuilder`
  works only for otherUser.
- [[#1490]](https://github.com/GetStream/stream-chat-flutter/issues/1490) Fixed `editMessageInputBuilder` property not
  used in message edit widget.
- [[#1523]](https://github.com/GetStream/stream-chat-flutter/issues/1523) Fixed `StreamMessageThemeData` not being
  applied correctly.
- [[#1525]](https://github.com/GetStream/stream-chat-flutter/issues/1525) Fixed `StreamQuotedMessageWidget` message for
  deleted messages not being shown correctly.
- [[#1529]](https://github.com/GetStream/stream-chat-flutter/issues/1529) Fixed `ClipboardData` requires non-nullable
  string as text on Flutter 3.10.
- [[#1533]](https://github.com/GetStream/stream-chat-flutter/issues/1533) Fixed `StreamMessageListView` messages grouped
  incorrectly w.r.t. timestamp.
- [[#1532]](https://github.com/GetStream/stream-chat-flutter/issues/1532) Fixed `StreamMessageWidget` actions dialog
  backdrop filter is cut off by safe area.

✅ Added

- Added `MessageTheme.urlAttachmentHostStyle`, `MessageTheme.urlAttachmentTitleStyle`, and
  `MessageTheme.urlAttachmentTextStyle` to customize the style of the url attachment.
- Added `StreamMessageInput.ogPreviewFilter` to allow users to filter out the og preview
  links. [#1338](https://github.com/GetStream/stream-chat-flutter/issues/1338)

  ```dart
  StreamMessageInput(
    ogPreviewFilter: (matchedUri, messageText) {
      final url = matchedUri.toString();
      if (url.contains('giphy.com')) {
        // Return false to prevent the OG preview from being built.
        return false;
      }
      // Return true to build the OG preview.
      return true;
  ),
  ```

- Added `StreamMessageInput.hintGetter` to allow users to customize the hint text of the message
  input. [#1401](https://github.com/GetStream/stream-chat-flutter/issues/1401)

  ```dart
  StreamMessageInput(
    hintGetter: (context, hintType) {
      switch (hintType) {
        case HintType.searchGif:
          return 'Custom Search Giphy';
        case HintType.addACommentOrSend:
          return 'Custom Add a comment or send';
        case HintType.slowModeOn:
          return 'Custom Slow mode is on';
        case HintType.writeAMessage:
          return 'Custom Write a message';
      }
    },
  ),
  ```

- Added `StreamMessageListView.shrinkWrap` to allow users to shrink wrap the message list view.

🔄 Changed

- Updated `dart` sdk environment range to support `3.0.0`.
- Deprecated `MessageTheme.linkBackgroundColor` in favor of `MessageTheme.urlAttachmentBackgroundColor`.
- Updated `stream_chat_flutter_core` dependency
  to [`6.1.0`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

## 6.0.0

🐞 Fixed

- [[#1456]](https://github.com/GetStream/stream-chat-flutter/issues/1456) Fixed logic for showing that a message was
  read using sending indicator.
- [[#1462]](https://github.com/GetStream/stream-chat-flutter/issues/1462) Fixed support for iPad in the share button for
  images.
- [[#1475]](https://github.com/GetStream/stream-chat-flutter/issues/1475) Fixed typo to fix compilation.

✅ Added

- Now it is possible to customize the max lines of the title of a url attachment. Before it was always 1 line.
- Added `attachmentActionsModalBuilder` parameter to `StreamMessageWidget` that allows to
  customize `AttachmentActionsModal`.
- Added `StreamMessageInput.sendMessageKeyPredicate` and `StreamMessageInput.clearQuotedMessageKeyPredicate` to
  customize the keys used to send and clear the quoted message.

🔄 Changed

- Updated dependencies to resolvable versions.

🚀 Improved

- Improved draw of reaction options. [#1455](https://github.com/GetStream/stream-chat-flutter/pull/1455)

## 5.3.0

🔄 Changed

- Updated `photo_manager` dependency to `^2.5.2`

🐞 Fixed

- [[#1424]](https://github.com/GetStream/stream-chat-flutter/issues/1424) Fixed a render issue when showing messages
  starting with 4 whitespaces.
- Fixed a bug where the `AttachmentPickerBottomSheet` was not able to identify the mobile browser.
- Fixed uploading files on Windows - fixed temp file path.

✅ Added

- New `noPhotoOrVideoLabel` displayed when there is no files to choose.

## 5.2.0

✅ Added

- Added a new `bottomRowBuilderWithDefaultWidget` parameter to `StreamMessageWidget` which contains a third parameter (
  default `BottomRow` widget with `copyWith` method available) to allow easier customization.

🔄 Changed

- Updated `lottie` dependency to `^2.0.0`
- Updated `desktop_drop` dependency to `^0.4.0`
- Updated `connectivity_plus` dependency to `^3.0.2`
- Updated `dart_vlc` dependency to `^0.4.0`
- Updated `file_picker` dependency to `^5.2.4`
- Deprecated `StreamMessageWidget.bottomRowBuilder` in favor of `StreamMessageWidget.bottomRowBuilderWithDefaultWidget`.
- Deprecated `StreamMessageWidget.deletedBottomRowBuilder` in favor
  of `StreamMessageWidget.bottomRowBuilderWithDefaultWidget`.
- Deprecated `StreamMessageWidget.usernameBuilder` in favor of `StreamMessageWidget.bottomRowBuilderWithDefaultWidget`.

🐞 Fixed

- [[#1379]](https://github.com/GetStream/stream-chat-flutter/issues/1379) Fixed "Issues with photo attachments on web",
  where the cached image attachment would not render while uploading.
- Fix render overflow issue with `MessageSearchListTileTitle`. It now uses `Text.rich` instead of `Row`. Better default
  behaviour and allows `TextOverflow`.
- [[1346]](https://github.com/GetStream/stream-chat-flutter/issues/1346) Fixed a render issue while uploading video on
  web.
- [[#1347]](https://github.com/GetStream/stream-chat-flutter/issues/1347) `onReply` not working
  in `AttachmentActionsModal` which is used by `StreamImageAttachment` and `StreamImageGroup`.

## 5.1.0

🐞 Fixed

- Show message custom actions on desktop context menu.
- Can move cursor by left/right arrow in StreamMessageInput on web/desktop.

✅ Added

- `VideoAttachment` now uses `thumbUrl` to show the thumbnail
  if it's available instead of generating them.
- Expose `widthFactor` option in `MessageWidget`
- Add `enableActionAnimation` flag to `StreamMessageInput`

## 5.0.1

🔄 Changed

- Updated `share_plus` dependency to `^4.5.0`

## 5.0.0

- Included the changes from version [4.5.0](#450).

🐞 Fixed

- [[#1326]](https://github.com/GetStream/stream-chat-flutter/issues/1326) Fixed hitting "enter" on
  the android keyboard sends the message instead of going to a new line.

✅ Added

- Added `StreamMemberGridView` and `StreamMemberListView`.
- Added support for additional text field parameters in `StreamMessageInput`
    * `maxLines`
    * `minLines`
    * `textInputAction`
    * `keyboardType`
    * `textCapitalization`
- Added `showStreamAttachmentPickerModalBottomSheet` to show the attachment picker modal bottom sheet.

🔄 Changed

- Removed Emoji picker from `StreamMessageInput`.

## 5.0.0-beta.2

- Included the changes from version [4.4.0](#440) and [4.4.1](#441).

🐞 Fixed

- Fixed the unread message header in the message list view.
- Show dialog after clicking on the camera button and permission is denied.
- Fix Jiffy initialization.
- Fix loading to unread position in `StreamMessageListView`.
- Minor fixes and improvements.

🔄 Changed

- [[#1125]](https://github.com/GetStream/stream-chat-flutter/issues/1125) `defaultUserImage`
  , `placeholderUserImage`, `reactionIcons`, and `enforceUniqueReactions` have been refactored out
  of `StreamChatThemeData` and into the new `StreamChatConfigurationData` class.

✅ Added

- Added `StreamAutocomplete` widget for autocomplete triggers in `StreamMessageInput`.
- Added `StreamMessageInput.customAutocompleteTriggers` to allow users to define their custom
  triggers.

## 5.0.0-beta.1

- 🎉 Initial support for desktop 🖥️ and web 🧑‍💻
    - Right-click context menus for messages and full-screen attachments
    - Upload and download attachments using the native desktop file system
    - Press the "enter" key to send a message
    - If you are quoting a message and have not yet typed any text, you can press the "esc" key to
      remove the quoted message.
    - A dedicated "X" button for removing a quoted message with your mouse
    - Drag and drop attachment files to `StreamMessageInput`
        - New `StreamMessageInput.draggingBorder` property to customize the border color of the
          message input when dropping a file.
    - Message reactions bubbles
    - Hovering over a message reaction will show the users that have reacted to the message
    - Desktop attachment sharing UI
    - Selectable message text
    - Gallery navigation controls with keyboard shortcuts (left and right arrow keys)
    - Appropriate message sizing for large screens
    - Right-click context menu for `StreamMessageListView` items
    - `StreamMessageListView` items not swipeable on desktop & web
    - Video support for Windows & Linux through `dart_vlc`
    - Video support for macOS through `video_player_macos`
    - Replace bottom sheets with dialogs where appropriate
- Other Additions ✅
    - `onQuotedMessageCleared` to `StreamMessageInput`
    - `selected` and `selectedTileColor` to `StreamChannelListTile`
    - `AttachmentUploadStateBuilder.inProgressBuilder` to `AttachmentUploadStateBuilder`
    - `AttachmentUploadStateBuilder.successBuilder` to `AttachmentUploadStateBuilder`
    - `AttachmentUploadStateBuilder.failedBuilder` to `AttachmentUploadStateBuilder`
    - Translations:
        - `couldNotReadBytesFromFileError`
        - `downloadLabel`
        - `toggleMuteUnmuteAction`
        - `toggleMuteUnmuteGroupQuestion`
        - `toggleMuteUnmuteGroupText`
        - `toggleMuteUnmuteUserQuestion`
        - `toggleMuteUnmuteUserText`
    - Deprecated `showConfirmationDialog` in favor of `showConfirmationBottomSheet`
    - Deprecated `showInfoDialog` in favor of `showInfoBottomSheet`
    - Deprecated `wrapAttachmentWidget` in favor of the `WrapAttachmentWidget` class
- Breaking changes 🚧
    - `StreamImageAttachment.size` has been converted from type `Size` to type `BoxConstraints`
    - `StreamFileAttachment.size` has been converted from type `Size` to type `BoxConstraints`
    - `StreamGiphyAttachment.size` has been converted from type `Size` to type `BoxConstraints`
    - `StreamVideoAttachment.size` has been converted from type `Size` to type `BoxConstraints`
    - `StreamVideoThumbnailImage.width` and `StreamVideoThumbnailImage.height` have been removed in
      favor of
      `StreamVideoThumbnailImage.constraints`
- Dependency updates ⬆️
    - `chewie: ^1.3.0` -> `chewie: ^1.3.4`
    - `path_provider: ^2.0.1` -> `path_provider: ^2.0.9`
    - `video_player: ^2.1.0` -> `video_player: ^2.4.5`
- Code Improvements 🔧
    - Extracted many widgets to classes to improve readability, maintainability, and devtools usage.
    - Organized internal directory structure
    - Extracted typedefs to their own file
    - Updated dartdoc documentation
    - Various code readability improvements

## 4.6.0

🐞 Fixed

- [[#1323]](https://github.com/GetStream/stream-chat-flutter/issues/1323): Fix message text hiding
  because of a [flutter bug](https://github.com/flutter/flutter/issues/110628).

## 4.5.0

- Updated `stream_chat_flutter_core` dependency
  to [`4.5.0`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

🐞 Fixed

- [[#882]](https://github.com/GetStream/stream-chat-flutter/issues/882) Lots of unhandled exceptions
  when network is off or spotty.
- Fixes an error where Stream CDN images were not being resized in the message list view.

🚀 Improved

- Automatically resize images that are above a specific pixel count to ensure resizing works:
  getstream.io/chat/docs/go-golang/file_uploads/#image-resizing

✅ Added

- Added `thumbnailSize`, `thumbnailResizeType`, and `thumbnailCropType` params
  to `StreamMessageWidget` to customize the appearance of image attachment thumbnails.

  ```dart
  StreamMessageListView(
    messageBuilder: (context, details, messages, defaultMessage) {
      return defaultMessage.copyWith(
        imageAttachmentThumbnailSize: ...,
        imageAttachmentThumbnailCropType: ...,
        imageAttachmentThumbnailResizeType: ...,
      );
    },
  ),
  ```

- Added `thumbnailSize`, `thumbnailFormat`, `thumbnailQuality` and `thumbnailScale` params
  to `StreamAttachmentPicker` to customize the appearance of image attachment thumbnails.

  ```dart
  StreamMessageInput(
    focusNode: _focusNode,
    messageInputController: _messageInputController,
    attachmentsPickerBuilder: (_, __, picker) {
      return picker.copyWith(
        attachmentThumbnailSize: ...,
        attachmentThumbnailFormat: ...,
        attachmentThumbnailQuality: ...,
        attachmentThumbnailScale: ...,
      );
    },
  ),
  ```

## 4.4.1

🐞 Fixed

- [[#1247]](https://github.com/GetStream/stream-chat-flutter/issues/1247) Fix Jiffy initialization.
- [[#1232]](https://github.com/getstream/stream-chat-flutter/issues/1232) Fix DateDivider not
  showing up in the chat.
- [[#1240]](https://github.com/getstream/stream-chat-flutter/issues/1240) Substitute mentioned user
  ids with user names in system message.
- [[#1228]](https://github.com/GetStream/stream-chat-flutter/issues/1228) Fix image download on iOS.

🔄 Changed

- Changed default maximum attachment size from 20MB to 100MB.

## 4.4.0

🐞 Fixed

- [[#1234]](https://github.com/GetStream/stream-chat-flutter/issues/1234) Fix `ChannelListTile`
  sendingIndicator `isMessageRead` calculation.

## 4.3.0

- Updated `photo_view` dependency to [`0.14.0`](https://pub.dev/packages/photo_view/changelog).

🐞 Fixed

- [[#1180]](https://github.com/GetStream/stream-chat-flutter/issues/1180) Fix file download.
- Fix commands resetting the `StreamMessageInputController.value`.
- [[#996]](https://github.com/GetStream/stream-chat-flutter/issues/996) Videos break bottom photo
  carousal.
- Fix: URLs with path and/or query parameters are not enriched.
- [[#1194]](https://github.com/GetStream/stream-chat-flutter/issues/1194) Request permission to
  access gallery when opening the file picker.

✅ Added

- [[#1011]](https://github.com/GetStream/stream-chat-flutter/issues/1011) Animate the background
  color of pinned messages.
- Added unread messages divider in `StreamMessageListView`.
- Added `StreamMessageListView.unreadMessagesSeparatorBuilder`.
- Now `StreamMessageListView` opens to the oldest unread message by default.

## 4.2.0

🐞 Fixed

- [[#1133]](https://github.com/GetStream/stream-chat-flutter/issues/1133) Visibility override flags
  not being passed to `StreamMessageActionsModal`

## 4.1.0

✅ Added

- [[#1119]](https://github.com/GetStream/stream-chat-flutter/issues/1119) Added an option to disable
  mentions overlay in `StreamMessageInput`
- Deprecated `disableEmojiSuggestionsOverlay` in favor of `enableEmojiSuggestionsOverlay`
  in `StreamMessageInput`

🐞 Fixed

- Fixed attachment picker ui.
- Fixed StreamChannelHeader and StreamThreadHeader subtitle alignment.
- Fixed message widget thread indicator in reverse mode.
- [[#1044]](https://github.com/GetStream/stream-chat-flutter/issues/1044): Refactor
  StreamMessageWidget bottom row to use Text.rich.

🔄 Changed

- Removed `isOwner` condition from `ChannelBottomSheet` and `StreamChannelInfoBottomSheet` for
  delete option tile.

## 4.0.1

- Minor fixes
- Updated `stream_chat_flutter_core` dependency
  to [`4.0.1`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

## 4.0.0

For upgrading to V4, please refer to
the [V4 Migration Guide](https://getstream.io/chat/docs/sdk/flutter/guides/migration_guide_4_0/)

✅ Added

- [[#1087]](https://github.com/GetStream/stream-chat-flutter/issues/1087): Handle limited access to
  camera on iOS.
- `centerTitle` and `elevation` properties to `ChannelHeader`, `ThreadHeader`
  and `ChannelListHeader`.

🐞 Fixed

- [[#1067]](https://github.com/GetStream/stream-chat-flutter/issues/1067): Fix name text overflow in
  reaction card.
- [[#842]](https://github.com/GetStream/stream-chat-flutter/issues/842): show date divider for first
  message.
- Loosen up url check for attachment download.
- Use `ogScrapeUrl` for LinkAttachments.

## 4.0.0-beta.2

✅ Added

- Added support to pass `autoCorrect` to `StreamMessageInput` for the text input field
- Added support to control the visibility of the default emoji suggestions overlay
  in `StreamMessageInput`
- Added support to build custom widget for scrollToBottom in `StreamMessageListView`

🐞 Fixed

- Minor fixes and improvements
  -[[#892]](https://github.com/GetStream/stream-chat-flutter/issues/892): Fix
  default `initialAlignment` in `MessageListView`.
- Fix `MessageInputTheme.inputBackgroundColor` color not being used in some widgets
  of `MessageInput`
- Removed dependency on `visibility_detector`
- [[#1071]](https://github.com/GetStream/stream-chat-flutter/issues/1071): Fixed the way attachment
  actions were handled in full screen

## 4.0.0-beta.1

✅ Added

- Deprecated old widgets in favor of Stream-prefixed ones.
- Use channel capabilities to show/hide actions.
- Deprecated `ChannelListView` in favor of `StreamChannelListView`.
- Deprecated `ChannelPreview` in favor of `StreamChannelListTile`.
- Deprecated `ChannelAvatar` in favor of `StreamChannelAvatar`.
- Deprecated `ChannelName` in favor of `StreamChannelName`.
- Deprecated `MessageInput` in favor of `StreamMessageInput`.
- Separated `MessageInput` widget in smaller components. (For example `CountDownButton`
  , `StreamAttachmentPicker`...)
- Updated `stream_chat_flutter_core` dependency
  to [`4.0.0-beta.0`](https://pub.dev/packages/stream_chat_flutter_core/changelog).
- Added OpenGraph preview support for links in `StreamMessageInput`.
- Removed video compression.

## 3.6.1

- Updated `stream_chat_flutter_core` dependency
  to [`3.6.1`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

## 3.6.0

🐞 Fixed

- Minor fixes and improvements
  -[[#892]](https://github.com/GetStream/stream-chat-flutter/issues/892): Fix
  default `initialAlignment` in `MessageListView`.
- Fix `MessageInputTheme.inputBackgroundColor` color not being used in some widgets
  of `MessageInput`
- Removed dependency on `visibility_detector`

## 3.5.1

🛑️ Breaking Changes

- `pinPermissions` is no longer needed in `MessageListView`.
- `MessageInput` now works with a `MessageInputController` instead of a `TextEditingController`

🐞 Fixed

- Mentions overlay now doesn't overflow when there is not enough height available
- Updated `stream_chat_flutter_core` dependency
  to [`3.5.1`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

✅ Added

- `onLinkTap` for `MessageWidget` can now be passed down to `UrlAttachment`.

## 3.5.0

🐞 Fixed

- [[#888]](https://github.com/GetStream/stream-chat-flutter/issues/888) Fix `unban` command not
  working in `MessageInput`.
- [[#805]](https://github.com/GetStream/stream-chat-flutter/issues/805) Updated chewie dependency
  version to 1.3.0
- Fix `showScrollToBottom` in `MessageListView` not respecting false value.
- Fix default `Channel` route not opening from `ChannelListView` when `ChannelAvatar` is tapped

## 3.4.0

- Updated `stream_chat_flutter_core` dependency
  to [`3.4.0`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

🐞 Fixed

- SVG rendering fixes.
- Use file extension instead of mimeType for downloading files.
- [[#860]](https://github.com/GetStream/stream-chat-flutter/issues/860) CastError while compressing
  Videos.

✅ Added

- Videos can now be auto-played in `FullScreenMedia`
- Extra customisation options for `MessageInput`

🔄 Changed

- Add `didUpdateWidget` override in `MessageInput` widget to handle changes to `focusNode`.

## 3.3.2

- Updated `stream_chat_flutter_core` dependency
  to [`3.3.1`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

## 3.3.1

✅ Added

- `MessageListView` now allows more better control over spacing after messages
  using `spacingWidgetBuilder`.
- `StreamChannel` can now fetch messages around a message ID with the `queryAroundMessage` call.
- Added `MessageListView.keyboardDismissBehavior` property.

🐞 Fixed

- [[#766]](https://github.com/GetStream/stream-chat-flutter/issues/766) `AttachmentActionsModal` now
  has customisation options for actions.
- Fixed `MessageWidget` null errors associated with `channel.memberCount`.
- Fixed adding attachments on web.
- [[#767]](https://github.com/GetStream/stream-chat-flutter/issues/767): Fix `MessageInput` focus
  behaviour when sending messages.
- Fixed user presence indicator not updating correctly.
- Do not use `withData: true` in `FilePicker` calls.
- Fixed read indicator not updating correctly in specific situations.

## 3.2.0

- Updated Dart SDK constraints to `>=2.14.0 <3.0.0`.
- Updated `stream_chat_flutter_core` dependency
  to [`3.2.0`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

🐞 Fixed

- Fixed message highlight animation alignment in `MessageListView`.
- [[#491]](https://github.com/GetStream/stream-chat-flutter/issues/491): Fix `MediaListView` showing
  media in wrong order.
- Fixed `MessageListView` initialIndex not working in some cases.
- Improved `MessageListView` rendering in case of reordering.
- Fix image thumbnail generation when using Stream CDN.

✅ Added

- `MessageListViewThemeData` now accepts a `DecorationImage` as a background image
  for `MessageListView`.

## 3.1.1

- Updated `stream_chat_flutter_core` dependency
  to [`3.1.1`](https://pub.dev/packages/stream_chat_flutter_core/changelog).
- Updated `file_picker`, `image_gallery_saver`, and `video_thumbnail` to the latest versions.

🐞 Fixed

- [[#687]](https://github.com/GetStream/stream-chat-flutter/issues/687): Fix Users losing their
  place in the conversation after replying in threads.
- Fixed floating date stream subscription causing "Bad state: stream has already been listened.”
  error.
- Fixed `String` capitalize extension not working on empty strings.

✅ Added

- Added `MessageInput.customOverlays` property to add custom overlays to the message input.
- Added `MessageInput.mentionAllAppUsers` property to mention all app users in the message input.
- The `MessageInput` now supports local search for channels with less than 100 members.
- Added `MessageListView.paginationLoadingIndicatorBuilder` to override the default loading
  indicator shown while paginating the message list.
- Added new `linkBackgroundColor` in `MessageTheme` for setting background colors of link
  attachments.

⚠️ Deprecated

- `MessageInput.mentionsTileBuilder` is now deprecated in favor
  of `MessageInput.userMentionsTileBuilder`.
- `MentionTile` is now deprecated in favor of `UserMentionsTile`.

## 3.0.0

- Updated `stream_chat_flutter_core` dependency
  to [`3.0.0`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

🛑️ Breaking Changes from `2.2.1`

- `UserListView` `filter` property now is non-nullable.

🐞 Fixed

- [[#668]](https://github.com/GetStream/stream-chat-flutter/issues/668): Fix `MessageInput`
  rendering errors in case there are no actions available to show.
- [[#349]](https://github.com/GetStream/stream-chat-flutter/issues/349): Fix `MessageInput`
  attachment render overflow error.
- `MessageInput` overlays now follow the `MessageInput` focus.
- [[#674]](https://github.com/GetStream/stream-chat-flutter/issues/674): Check scrollController is
  attached before calling jump in MessageListView.
- Fixed `MessageListView` header and footer when `reverse: false`.

🔄 Changed

- Animation curves changed from default `Curves.linear` to `Curves.easeOut` and `Curves.easeIn` for
  attachment controls.
- Removed default padding in `DateDivider` in `MessageListView`

✅ Added

- Added `MessageInput.customPortalOptions` property to add custom overlays to the `MessageInput`.

## 2.2.1

⚠️ Deprecated

- `MessageSearchListView` `paginationParams` property is now deprecated in favor of `limit`.
    ```dart
    // previous
    paginationParams = const PaginationParams(limit: 30)
    
    // new
    limit = 30
    ```
- `UserListView` `pagination` property is now deprecated in favor of `limit`.
    ```dart
    // previous
    pagination = const PaginationParams(limit: 30)
    
    // new
    limit = 30
    ```
- `ChannelListView` `pagination` property is now deprecated in favor of `limit`.
    ```dart
    // previous
    pagination = const PaginationParams(limit: 30)
    
    // new
    limit = 30
    ```

🔄 Changed

- `UserListViewCore` filter property now has a default value.
    ```dart
    filter = const Filter.empty()
    ```

🐞 Fixed

- Fixed `MessageSearchListView` pagination.
- Fixed `MessageWidget` attachment tap callbacks.

## 2.2.1

- Updated `stream_chat_flutter_core` dependency to 2.2.1

## 2.2.0

✅ Added

- [#516](https://github.com/GetStream/stream-chat-flutter/issues/516):
  Added `StreamChatThemeData.placeholderUserImage` for building a widget when the `UserAvatar` image
  is loading
- Added a `backgroundColor` property to the following widgets:
    - `ChannelHeader`
    - `ChannelListHeader`
    - `GalleryHeader`
    - `GalleryFooter`
    - `ThreadHeader`
- Added `MessageInput.attachmentLimit` in order to limit the no. of attachments that can be sent
  with a single message.
- Added `MessageInput.onAttachmentLimitExceed` callback which will be called when
  the `attachmentLimit` is exceeded. This will override the default error alert behaviour.
- Added `MessageInput.attachmentButtonBuilder` and `MessageInput.commandButtonBuilder` for more
  customizations.

```dart
typedef ActionButtonBuilder = Widget Function(
    BuildContext context,
    IconButton defaultActionButton,
    );
```

> **_NOTE:_** The last parameter is the default `ActionButton`
> You can call `.copyWith` to customize just a subset of properties.

- Added slow mode which allows a cooldown period after a user sends a message.

🔄 Changed

Theming has been upgraded! Most theme classes now have `InheritedTheme` classes associated with
them, and have been upgraded with some goodies like `lerp` functions. Here's the full naming
breakdown:

* `AvatarTheme` is now `AvatarThemeData`
* `ChannelHeaderTheme` is now `ChannelHeaderThemeData`
* `ChannelListHeaderTheme` is now `ChannelListHeaderThemeData`
* `ChannelListViewTheme` is now `ChannelListViewThemeData`
* `ChannelPreviewTheme` is now `ChannelPreviewThemeData`
* `MessageInputTheme` is now `MessageInputThemeData`
* `MessageListViewTheme` is now `MessageListViewTheme`
* `MessageSearchListViewTheme` is now `MessageSearchListViewThemeData`
* `MessageTheme` is now `MessageThemeData`
* `UserListViewTheme` is now `UserListViewThemeData`

- Updated core dependency.

🐞 Fixed

- Fixed `MessageInput` textField case where `input` is not enabled if the file picked from the
  camera is null.
- Fixed date dividers position/alignment in non reversed `MessageListView`.
- Fixed `MessageListView` not opening to the right initialMessage
  if `StreamChannel.initialMessageId` is set.
- Fixed null check errors when accessing `message.text` in `MessageWidget` and `MessageListView`;
  this occurred when sending a message with no text.

## 2.1.2

🐞 Fixed

- [#590](https://github.com/GetStream/stream-chat-flutter/issues/590): livestream use case, no
  members when sending message

## 2.1.1

- Updated core dependency

## 2.1.0

✅ Added

- Added `MessageListView.paginationLimit`
- `MessageText` renders message translation if available
- Allow the various ListView widgets to be themed via ThemeData classes
- Added `bottomRowBuilder` and `deletedBottomRowBuilder` that build a widget below a `MessageWidget`

🔄 Changed

- `StreamChat.of(context).user` is now deprecated in favor of `StreamChat.of(context).currentUser`.
- `StreamChat.of(context).userStream` is now deprecated in favor
  of `StreamChat.of(context).currentUserStream`.

🐞 Fixed

- Fix floating date divider not having a fixed size

## 2.0.0

🛑️ Breaking Changes from `1.5.4`

- Migrate this package to null safety
- Renamed `ChannelImage` to `ChannelAvatar`
- Updated `StreamChatThemeData.reactionIcons` to accept custom builder
- Renamed `ColorTheme` properties to reflect the purpose of the colors
    - `ColorTheme.black` -> `ColorTheme.textHighEmphasis`
    - `ColorTheme.grey` -> `ColorTheme.textLowEmphasis`
    - `ColorTheme.greyGainsboro` -> `ColorTheme.disabled`
    - `ColorTheme.greyWhisper` -> `ColorTheme.borders`
    - `ColorTheme.whiteSmoke` -> `ColorTheme.inputBg`
    - `ColorTheme.whiteSnow` -> `ColorTheme.appBg`
    - `ColorTheme.white` -> `ColorTheme.barsBg`
    - `ColorTheme.blueAlice` -> `ColorTheme.linkBg`
    - `ColorTheme.accentBlue` -> `ColorTheme.accentPrimary`
    - `ColorTheme.accentRed` -> `ColorTheme.accentError`
    - `ColorTheme.accentGreen` -> `ColorTheme.accentInfo`

- `ChannelListCore` options property is removed in favor of individual properties
    - `options.state` -> bool state
    - `options.watch` -> bool watch
    - `options.presence` -> bool presence
- `UserListView` options property is removed in favor of individual properties
    - `options.presence` -> bool presence
- Renamed `ImageHeader` to `GalleryHeader`
- Renamed `ImageFooter` to `GalleryFooter`
- `MessageBuilder` and `ParentMessageBuilder` signature is now

```dart
typedef MessageBuilder = Widget Function(
    BuildContext,
    MessageDetails,
    List<Message>,
    MessageWidget defaultMessageWidget,
    );
```

> **_NOTE:_** the last parameter is the default `MessageWidget`
> You can call `.copyWith` to customize just a subset of properties


✅ Added

- Added video compress options (frame and quality) to `MessageInput`
- TypingIndicator now has a property called `parentId` to show typing indicator specific to threads
- [#493](https://github.com/GetStream/stream-chat-flutter/pull/493): add support for messageListView
  header/footer
- `MessageWidget` accepts a `userAvatarBuilder`
- Added pinMessage ui support
- Added `MessageListView.threadSeparatorBuilder` property
- Added `MessageInput.onError` property to allow error handling
- Added `GalleryHeader/GalleryFooter` theme classes

🐞 Fixed

- [#483](https://github.com/GetStream/stream-chat-flutter/issues/483): Keyboard covers input text
  box when editing message
- Modals are shown using the nearest `Navigator` to make using the SDK easier in a nested navigator
  use case
- [#484](https://github.com/GetStream/stream-chat-flutter/issues/484): messages don't update without
  a reload
- `MessageListView` not rendering if the user is not a member of the channel
- Fix `MessageInput` overflow when there are no actions
- Minor fixes and improvements

## 2.0.0-nullsafety.9

🛑️ Breaking Changes from `2.0.0-nullsafety.8`

- Renamed `ColorTheme` properties to reflect the purpose of the colors
    - `ColorTheme.black` -> `ColorTheme.textHighEmphasis`
    - `ColorTheme.grey` -> `ColorTheme.textLowEmphasis`
    - `ColorTheme.greyGainsboro` -> `ColorTheme.disabled`
    - `ColorTheme.greyWhisper` -> `ColorTheme.borders`
    - `ColorTheme.whiteSmoke` -> `ColorTheme.inputBg`
    - `ColorTheme.whiteSnow` -> `ColorTheme.appBg`
    - `ColorTheme.white` -> `ColorTheme.barsBg`
    - `ColorTheme.blueAlice` -> `ColorTheme.linkBg`
    - `ColorTheme.accentBlue` -> `ColorTheme.accentPrimary`
    - `ColorTheme.accentRed` -> `ColorTheme.accentError`
    - `ColorTheme.accentGreen` -> `ColorTheme.accentInfo`

✅ Added

- Added video compress options (frame and quality) to `MessageInput`

## 2.0.0-nullsafety.8

🛑️ Breaking Changes from `2.0.0-nullsafety.7`

- `ChannelListCore` options property is removed in favor of individual properties
    - `options.state` -> bool state
    - `options.watch` -> bool watch
    - `options.presence` -> bool presence
- `UserListView` options property is removed in favor of individual properties
    - `options.presence` -> bool presence
- `MessageBuilder` and `ParentMessageBuilder` signature is now

```dart
typedef MessageBuilder = Widget Function(
    BuildContext,
    MessageDetails,
    List<Message>,
    MessageWidget defaultMessageWidget,
    );
```

> **_NOTE:_** The last parameter is the default `MessageWidget`
> You can call `.copyWith` to customize just a subset of properties.

✅ Added

- TypingIndicator now has a property called `parentId` to show typing indicator specific to threads
- [#493](https://github.com/GetStream/stream-chat-flutter/pull/493): add support for messageListView
  header/footer
- `MessageWidget` accepts a `userAvatarBuilder`

🐞 Fixed

- [#483](https://github.com/GetStream/stream-chat-flutter/issues/483): Keyboard covers input text
  box when editing message
- Modals are shown using the nearest `Navigator` to make using the SDK easier in a nested navigator
  use case
- [#484](https://github.com/GetStream/stream-chat-flutter/issues/484): messages don't update without
  a reload
- `MessageListView` not rendering if the user is not a member of the channel

## 2.0.0-nullsafety.7

- Minor fixes and improvements
- Updated `stream_chat_core` dependency
- Fixed a bug with connectivity implementation

## 2.0.0-nullsafety.6

- Minor fixes and improvements
- Updated `stream_chat_core` dependency
- 🛑 **BREAKING** Updated StreamChatThemeData.reactionIcons to accept custom builder

## 2.0.0-nullsafety.5

- Minor fixes and improvements
- Updated `stream_chat_core` dependency
- Performance improvements
- Added pinMessage ui support
- Added `MessageListView.threadSeparatorBuilder` property

## 2.0.0-nullsafety.4

- Minor fixes and improvements
- Updated `stream_chat_core` dependency
- Improved performance of `MessageWidget` component

## 2.0.0-nullsafety.3

- Fix MessageInput overflow when there are no actions

## 2.0.0-nullsafety.2

- Migrate this package to null safety

## 1.5.4

- Updated `stream_chat_core` dependency

## 1.5.3

- Updated `stream_chat_core` dependency

## 1.5.2

- Fix accessibility text size overflows
- Updated Giphy attachment ui
- Minor fixes and improvements

## 1.5.1

- Fixed unread count not updating while the chat is open

## 1.5.0

- Fixed swipeable visible on navigation back
- Fixed video upload
- `MessageInput`: added more actions locations, merge actions and add `showCommandsButton` property
- 🛑 **BREAKING** Updated AttachmentBuilder signature
- Fixed image reloading on reaction.new

## 1.4.0-beta

- Unfocus `MessageInput` only when sending commands
- Updated default error for `MessageSearchListView`
- Show error messages as system and keep them in the message input
- Remove notification badge logic
- Use shimmer while loading images
- Polished `StreamChatTheme` adding more options and a new `MessageInputTheme` dedicated
  to `MessageInput`
- Add possibility to specify custom message actions using `MessageWidget.customActions`
- Added `MessageListView.onAttachmentTap` callback
- Fixed message newline issue
- Fixed `MessageListView` scroll keyboard behaviour
- Minor fixes and improvements

## 1.3.2-beta

- Updated `stream_chat_core` dependency
- Fixed minor bugs

## 1.3.1-beta

- Updated `stream_chat_core` dependency
- Fixed minor bugs

## 1.3.0-beta

- Added `MessageInputTheme`
- Fixed overflow in `MessageInput` animation
- Delete only image on imagegallery
- Close keyboard after sending a command
- Exposed `customAttachmentBuilders` through `MessageListView`
- Updated `stream_chat_core` dependency

## 1.2.0-beta

- Minor fixes
- Updated `stream_chat_core` dependency

## 1.1.1-beta

- Added MessageInput button color customization options
- Fixed author theme and messageinput background

## 1.1.0-beta

- Update stream_chat_core dependency
- Expose common builders in ListView widgets
- Add support for asynchronous attachment upload while sending a message
- Fixed minor bugs

## 1.0.2-beta

- Update stream_chat_core dependency

## 1.0.1-beta

- Update stream_chat_core dependency

## 1.0.0-beta

- **Refreshed widgets design**
- Improved API documentation
- Updated `stream_chat` dependency to `^1.0.0-beta`
- Extracted sample app into dedicated [repository](https://github.com/GetStream/flutter-samples)
- Re-implemented existing widgets
  using [`stream_chat_flutter_core`](https://pub.dev/packages/stream_chat_flutter_core)

## 0.2.21

- Add `loadingBuilder` in `MessageListView`
- Add `messageFilter` property in `MessageListView`

## 0.2.20+4

- Fix `channelPreview` when the message list is empty

## 0.2.20+3

- Fix reaction picker score indicator

## 0.2.20+2

- Added `shouldAddChannel` to ChannelsBloc in order to check if a channel has to be added to the
  list when a new message arrives

## 0.2.20+1

- Fixed bug that caused video attachment to show the same preview

## 0.2.20

- Implement shadowban

## 0.2.19

- Updated llc dependency
- Added loading builder in channellistview
- Added sendButtonLocation and animationduration to messageinput

## 0.2.18

- Updated llc dependency

## 0.2.17+2

- Expose ChannelsBloc.channelsComparator to sort channels on message.new event

## 0.2.17+1

- Fix mention tap bug

## 0.2.17

- Expose messageInputDecoration as part of the theme

## 0.2.16

- Do not wrap channel preview builder. Users will have to implement they're custom onTap/onLongPress
  implementation
- Make public autofocus field of the TextField of message_input

## 0.2.15

- Add onLongPress on channel when using custom channel builder

## 0.2.14

- Add onMessageTap callbacks

## 0.2.13+2

- Add debounce to on change messageinput listener

## 0.2.13+1

- Use TextEditingController.addListener instead of TextField.onChanged

## 0.2.13

- Update llc dependency
- Send parent_id in typing events
- Expose addition input styling options
- Expose builder for empty channel state

## 0.2.12

- Upgrade dependencies
- Check if user.extraData['image'] is not null before using it

## 0.2.11+1

- Fix error with channel query while handling background notifications

## 0.2.11

- Update llc dependency
- Update widget to use `channel.state.unreadCountStream`

## 0.2.10

- Update llc dependency
- Add `separatorBuilder` to `ChannelListView`

## 0.2.9+1

- Update llc dependency
- Minor bug fixes

## 0.2.9

- Update llc dependency
- Fix example to run on Flutter web

## 0.2.8+4

- fix: Auto capitalize the start of sentences in MessageInput
- Update dependencies

## 0.2.8+3

- Add simple example of channel creation in sample app
- Add back button to the full-screen video view
- Update llc version

## 0.2.8+2

- Add back button to the full-screen view

## 0.2.8+1

- Update LLC dependency
- Update file_picker dependency

## 0.2.8

- Update LLC dependency

## 0.2.7+2

- Fix channellistview loading when client is not initialized
- Update LLC dependency

## 0.2.7

- Update llc dependency
- Fixed a bug that made the SDK crash if it went to background while not connected

## 0.2.6+1

- Update llc dependency

## 0.2.6

- Add `pullToRefresh` property to `ChannelListView`
- Add `onLinkTap` to `MessageWidget`

## 0.2.5

- Implement `didUpdateWidget` in `ChannelListView` to react to setState

## 0.2.4

- Update llc dependency

## 0.2.3

- Add `lockChannelsOrder` parameter to `ChannelsBloc`

## 0.2.2+3

- Fix `ChannelListView` channel hidden behaviour

- Refresh `ChannelListView` on new message from hidden channel

## 0.2.2+1

- Fix some components to implement a splitview example

## 0.2.2

- Add `messageLinks` property to `MessageTheme` to customize links color

## 0.2.1+2

- Update llc dependency

## 0.2.1+1

- Update llc dependency

## 0.2.1

- Better ui components
- Add read indicators
- Add system messages
- Use llc 0.2
- Add `ChannelsBloc` widget to manage a list of channels with pagination

## 0.2.1-alpha+11

- Update llc dependency

## 0.2.1-alpha+10

- Update llc dependency

## 0.2.1-alpha+9

- Add read indicators
- Update llc dependency

## 0.2.1-alpha+8

- User queryMembers for mentions

## 0.2.1-alpha+7

- Update llc dependency

## 0.2.1-alpha+6

- Update llc dependency
- Minor bugfix

## 0.2.1-alpha+4

- Update llc dependency

- Add system messages

## 0.2.1-alpha+3

- Update llc dependency

- Fix hero tag generation for attachment

## 0.2.1-alpha+2

- Fixed reactions bubble going below other messages
- Updated llc dependency

## 0.2.1-alpha+1

- Removed the additional `Navigator` in `StreamChat` widget. It was added to make the app have
  the `StreamChat` widget as ancestor in every route. Now the recommended way to add `StreamChat` to
  your app is using the `builder` property of your `MaterialApp` widget. Otherwise you can use it in
  the usual way, but you need to add a `StreamChat` widget to every route of your app.
  Read [this issue](https://github.com/GetStream/stream-chat-flutter/issues/47) for more
  information.

```dart
  @override
Widget build(BuildContext context) {
  return MaterialApp(
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    themeMode: ThemeMode.system,
    builder: (context, widget) {
      return StreamChat(
        child: widget,
        client: client,
      );
    },
    home: ChannelListPage(),
  );
}
```

- Fix reaction bubble going below previous message on iOS

- Fix message list view reloading messages even if the pagination is ended

## 0.2.1-alpha

- New message widget
- Moved some properties from `MessageListView` to `MessageWidget`
- Added `MessageDetails` property to `MessageBuilder`
- Added example to customize the message using `MessageWidget` (`customize_message_widget.dart`)

## 0.2.0-alpha+15

- Add background color in StreamChatTheme

## 0.2.0-alpha+13

- Handle channel deleted event

## 0.2.0-alpha+11

- Fix message builder and add messageList to it

## 0.2.0-alpha+10

- Add date divider builder

- Fix reply indicator tap

## 0.2.0-alpha+9

- Add `attachmentBuilders` to `MessageWidget` and `MessageListView`

## 0.2.0-alpha+7

- Update llc dependency

## 0.2.0-alpha+5

- Remove dependencies on notification service

- Expose some helping method for integrate offline storage with push notifications

## 0.2.0-alpha+3

- Fix overflow in mentions overlay

## 0.2.0-alpha+2

- Add better mime detection

## 0.2.0-alpha+1

- Fix video loading and error

## 0.2.0-alpha

- Offline storage

- Push notifications

- Minor bug fixes

## 0.1.20s

- Add message configuration properties to MessageListView

## 0.1.19

- Fix video aspect ratio

- Add property to decide whether to enable video fullscreen

- Add property to hide the attachment button

- Do not show send button if an attachment is still uploading

- Unfocus and disable the TextField before opening the camera (workaround for flutter/flutter#42417)

- Add gesture (vertical drag down) to close the keyboard

- Add keyboard type parameters (set it to TextInputType.text to show the submit button that will
  even close the keyboard)

The property showVideoFullScreen was added mainly because of this issue brianegan/chewie#261

## 0.1.18

- Add message list date separators

## 0.1.17

- Add dark theme

## 0.1.16

- Add possibility to show the other users username next to the message timestamp

## 0.1.15

- Fix MessageInput overflow

## 0.1.14

- Add automatic keep alive to streamchat

## 0.1.12

- Fix dependency error on iOS using flutter_form_builder

## 0.1.11

- Fix bug in ChannelPreview when list of messages is empty

## 0.1.10

- Do not automatically dispose Client object when disposing StreamChat widget

## 0.1.9

- Fix message ui overflow

## 0.1.8

- Bug fix

## 0.1.7

- Add chat commands

- Add edit message

## 0.1.6+4

- Add some documentation

## 0.1.5

- Fix channels pagination

## 0.1.4

- Fix message widget builder on reaction

## 0.1.3

- Fix upload attachment

## 0.1.2

- Fix avatar shape

## 0.1.1

- Add ThreadHeader

## 0.0.1

- First release
