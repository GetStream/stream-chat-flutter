## Upcoming Beta Changes

🐞 Fixed

- `StreamUserAvatar` with `StreamAvatarSize.xxl` now uses `StreamOnlineIndicatorSize.xxl` (20px) instead of `xl` (16px), matching the Chat SDK design system spec.
- `StreamMessageComposer` no longer clobbers pre-populated composer state (text, quoted message, attachments) when the channel's draft stream emits its initial `null` (no draft on server). The reset now fires only on an actual non-null → null transition, distinguishing "no draft yet" from "draft was removed".

✅ Added

- Added `BlockUser` / `UnblockUser` default message actions, dispatching to `StreamChatClient.blockUser` / `unblockUser`.

🔄 Internal / Non-breaking

- Reordered the default message actions to match the design system.
- Renamed default English `threadReplyLabel` (`'Thread'` → `'Thread Reply'`) and `markAsUnreadLabel` (`'Mark as Unread'` → `'Mark Unread'`).
- `StreamThreadHeader` default title now sources from the new `threadLabel` translation key instead of `threadReplyLabel`, restoring the short `'Thread'` header.

- `ReactionIconResolver.supportedReactions` is now wired to the full emoji picker sheet opened by the "+" button in `StreamMessageReactionPicker` and the add-emoji chip in `ReactionDetailSheet`. Override `supportedReactions` on a custom resolver to control which reactions appear in the full picker grid.

- Composer UI primitives (`StreamMessageComposerInputField`, `VoiceRecordingCallback`, and the outer/inner layout containers) are now owned by `stream_chat_flutter` and exported from this package. They were previously supplied by `stream_core_flutter`. The public API of `StreamMessageComposer` / `StreamChatMessageInput` and its sub-components is unchanged.
- Re-export `StreamAvatarTheme` and `StreamAvatarThemeData` from `stream_core_flutter` so consumers can theme avatars without adding a separate `stream_core_flutter` import.

🛑️ Breaking

- `StreamChatConfigurationData.draftMessagesEnabled` now defaults to `true`. Draft messages are enabled out of the box; pass `draftMessagesEnabled: false` to opt out.
- `StreamChatConfigurationData.enforceUniqueReactions` now defaults to `false`. Users can add multiple distinct reaction types to a message by default; pass `enforceUniqueReactions: true` to restore the previous behaviour.
- `StreamMessageComposer.enableVoiceRecording` now defaults to `true`. The voice recording button is shown out of the box; pass `enableVoiceRecording: false` to opt out.
- `StreamMessageListView` had its large set of configuration and builder parameters reorganized. Behavior flags (e.g. `swipeToReply`, `markReadWhenAtTheBottom`, `showScrollToBottom`, `reverse`, `paginationLimit`, `scrollPhysics`, etc.) moved to `StreamMessageListViewConfiguration`, passed directly as `StreamMessageListView.config`. Custom builder callbacks (`headerBuilder`, `footerBuilder`, `loadingBuilder`, `emptyBuilder`, `errorBuilder`, `messageListBuilder`, `parentMessageBuilder`, `dateDividerBuilder`, `floatingDateDividerBuilder`, `threadSeparatorBuilder`, `unreadMessagesSeparatorBuilder`, `scrollToBottomBuilder`, `paginationLoadingIndicatorBuilder`, `spacingWidgetBuilder`, `systemMessageBuilder`, `ephemeralMessageBuilder`, `moderatedMessageBuilder`) moved to `StreamMessageListViewBuilders`, passed directly as `StreamMessageListView.builders`. The `messageBuilder` parameter is back at the root of the constructor as before.
- Bumped `file_picker` to `^11.0.0` to resolve [#2599](https://github.com/GetStream/stream-chat-flutter/issues/2599). Apps depending on `file_picker` directly must also upgrade past `11.0.0`, which replaces the instance-based `FilePicker.platform.*` API with static `FilePicker.*` methods.
- Renamed `StreamMessageComposer.messageInputController` parameter to `messageComposerController`.
- Removed `StreamDraftListView`, `StreamDraftListTile`, `StreamDraftListTileTheme`, and `StreamDraftListTileThemeData` from the SDK. Also removed `StreamChatThemeData.draftListTileTheme`. Refer to the sample app for a reference implementation using `StreamDraftListController` and `PagedValueListView`.
- Renamed `StreamMessageComposerInput` → `StreamMessageComposerInputCenter` (and `DefaultStreamMessageComposerInput` → `DefaultStreamMessageComposerInputCenter`). The name `StreamMessageComposerInput` is now the input container widget (assembles header, leading, center, trailing).
- Renamed `MessageComposerInputProps` → `MessageComposerInputCenterProps`. The name `MessageComposerInputProps` now refers to the new container widget's props.
- Renamed `messageComposerInput` builder key in `streamChatComponentBuilders` → `messageComposerInputCenter`. The name `messageComposerInput` now overrides the whole input container.
- Replaced `StreamMessageInput.hintGetter` with `placeholderBuilder` over a sealed `MessageInputPlaceholder`.
  See [`migrations/redesign/message_composer.md`](../../migrations/redesign/message_composer.md).
- Removed `StreamMessageListView.unreadIndicatorBuilder`; use `StreamComponentFactory.jumpToUnreadButton`.
- Renamed `UnreadIndicatorButton.onTap` → `onJumpTap`.
- Renamed stream icons to remove the size suffix from the icon names.
- Removed `StreamAttachmentUploadStateBuilder.successBuilder` and the `SuccessBuilder` typedef (unreachable).
- Removed `StreamFileAttachmentThumbnail`; use `StreamImageAttachmentThumbnail` / `StreamVideoAttachmentThumbnail` or `StreamFileTypeIcon.fromMimeType(...)`.
- Removed `StreamMessageThemeData` (ownMessageTheme / otherMessageTheme) and `StreamMessageInputThemeData` (messageInputTheme).
- Removed `StreamChannelPreviewThemeData` (channelPreviewTheme).
- Removed the public `MessageDetails` class. The new `messageBuilder` signature no longer receives it — use `StreamChat.of(context).currentUser` and `StreamMessageLayout.of(context)` instead. See [`migrations/redesign/message_list.md`](../../migrations/redesign/message_list.md#removed-messagedetails).
- Renamed `StreamPollOptionsDialog` / `StreamPollResultsDialog` / `StreamPollOptionVotesDialog` / `StreamPollCommentsDialog` (and their `show*` helpers and `...DialogThemeData` types) → `...Sheet`. They now render as modal bottom sheets.
- Replaced `StreamPollCreatorDialog` / `StreamPollCreatorFullScreenDialog` (and `showStreamPollCreatorDialog`) with a single `StreamPollCreatorSheet` (`showStreamPollCreatorSheet`) that renders as a modal bottom sheet, matching the other poll sheets. `StreamPollCreatorWidget` gained an optional `scrollController` parameter.
- Removed `primaryActionStyle` and `secondaryActionStyle` from `StreamPollCreatorThemeData`. Use the new `sheetHeaderStyle.trailingStyle` / `sheetHeaderStyle.leadingStyle` instead — see [`migrations/redesign/attachments_and_polls.md`](../../migrations/redesign/attachments_and_polls.md).
- Redesigned `StreamPollOptionsSheetThemeData`, `StreamPollResultsSheetThemeData`, `StreamPollOptionVotesSheetThemeData` and `StreamPollCommentsSheetThemeData` — see [`migrations/redesign/attachments_and_polls.md`](../../migrations/redesign/attachments_and_polls.md).
- Renamed `Translations.questionsLabel` getter → `questionLabel({bool isPlural = false})` method.
- Renamed `Translations.endVoteConfirmationText` → `endVoteConfirmationTitle`; English default changed to `'End This Poll?'`.
- Renamed `Translations.slowModeOnLabel` getter → `slowModeOnLabel(int cooldownTimeOut)` method; English default changed from `'Slow mode ON'` to `'Slow mode, wait ${cooldownTimeOut}s\u2026'`. While slow mode is active for the current user the composer text input is now disabled and the trailing send button is replaced by a disabled countdown button showing the remaining seconds, matching the redesigned Figma. See [`migrations/redesign/message_composer.md`](../../migrations/redesign/message_composer.md).
- Reworded `Translations.endVoteLabel` English default to `'End Poll'`.
- Removed `AttachmentButton`, `StreamQuotedMessageWidget`, `EditMessageSheet`, `StreamMessageSendButton` and `DesktopReactionsBuilder`.
- Removed `StreamChannelGridView`, `StreamChannelGridTile` and `StreamMessageSearchGridView`.
- `StreamMessageActionConfirmationModal.cancelActionTitle` / `confirmActionTitle` are now nullable and fall back to `Translations.cancelLabel` / `confirmLabel`.
- Renamed `Translations.attachmentsUploadProgressText` parameter `remaining` → `completed`.
- Updated several `Translations` default strings and added new abstract members — see [`migrations/redesign/localizations.md`](../../migrations/redesign/localizations.md).
- Renamed `MuteIconPosition` → `AttributePosition` (values `title` → `inlineTitle`, `subtitle` → `trailingBottom`) and `StreamChannelListItemThemeData.muteIconPosition` → `attributePosition`. Now controls both mute and pin icons in `StreamChannelListTile`.
- Removed `AttachmentModalSheet`, `ErrorAlertSheet` and `StreamChannelInfoBottomSheet`.
- Removed `StreamMarkdownMessage`; use `StreamMessageText` (re-exported from `stream_core_flutter`) instead.
- Renamed message item components to align with Android Compose and SwiftUI conventions:
  - `StreamMessageWidget` → `StreamMessageItem` (file moved to `message_item.dart`).
  - `DefaultStreamMessage` → `DefaultStreamMessageItem`.
  - `StreamMessageWidgetProps` → `StreamMessageItemProps`.
  - `StreamMessageWidgetBuilder` typedef → `StreamMessageItemBuilder`.
  - `StreamMessageAnnotations` → `StreamMessageHeader`.
  - `StreamMessageMetadata` → `StreamMessageFooter`.
  - `ParseAttachments` → `StreamMessageAttachments`.
  - `streamChatComponentBuilders(messageWidget: ...)` → `messageItem: ...`.
  - `StreamMessageContent(annotation: ..., metadata: ...)` → `header: ..., footer: ...`.
  See [`migrations/redesign/message_widget.md`](../../migrations/redesign/message_widget.md).
- Redesigned the full-screen media viewer:
  - Replaced `StreamFullScreenMedia` (and its `StreamFullScreenMediaBuilder` / `FullScreenMediaWidget` / `FullScreenMediaDesktop` / `fsm_stub` variants) with a single cross-platform `StreamMediaGalleryPreview`. Renamed `mediaAttachmentPackages` → `attachments`, `startIndex` → `initialIndex`; dropped `userName`, `sentAt`, `onReplyMessage`, `onShowMessage` and `attachmentActionsModalBuilder` from its surface.
  - Renamed `StreamGalleryHeader` → `StreamMediaGalleryPreviewHeader` and `StreamGalleryFooter` → `StreamMediaGalleryPreviewFooter`, rebuilt on `StreamAppBar` / `StreamBottomAppBar`. Both shrank to a `title` (+ optional `subtitle`) and minimal action callbacks; the more-actions overflow header was removed.
  - Renamed `StreamAttachmentPackage` → `StreamMediaGalleryAttachment` and added a `Message.toMediaGalleryAttachments({filter})` extension.
  - Removed `VideoPackage`, `DesktopVideoPackage` and `GalleryNavigationItem` from the public API — each preview page now owns its own player state internally.
  - Removed `StreamMessageItem.onShowMessage` / `attachmentActionsModalBuilder` and the matching `StreamMessageListView` / `StreamMessageContent` props; those callbacks no longer have a destination after the gallery overflow was removed.
  - Removed `StreamChatThemeData.galleryHeaderTheme`, `StreamChatThemeData.galleryFooterTheme` (and the `imageFooterTheme:` constructor parameter) and the `StreamGalleryFooterThemeData` class. Header / footer chrome now flows through `StreamAppBarThemeData` / `StreamBottomAppBarThemeData`.
  - Removed the unused `StreamAvatarThemeData`.
  See [`migrations/redesign/media_viewer.md`](../../migrations/redesign/media_viewer.md).

✅ Added

- Video attachments use the shared `StreamVideoPlayIndicator` for the play-button overlay.
- Redesigned `StreamSystemMessage` / `StreamModeratedMessage` with a pill-shaped style and visual customisation props.
- Added visual customisation props to `ThreadSeparator` and `UnreadMessagesSeparator`.
- Added `StreamUnsupportedAttachment` and `UnsupportedAttachmentBuilder` for unrecognised attachment types.
- Added `StreamMediaGallery` — a 3-up thumbnail grid that pairs with `StreamMediaGalleryPreview`. Each tile surfaces the sender's avatar (`StreamUserAvatar`) plus a video duration badge for video attachments. Used by `StreamMediaGalleryPreviewFooter`'s gallery-grid sheet and ready to drop into channel-level media listings. Customisable via `streamChatComponentBuilders(mediaGallery: ...)`.
- Added `StreamMediaGalleryPreview` — the redesigned full-screen swipeable viewer. Built on the design system's `StreamMediaViewer`, `StreamAppBar` and `StreamBottomAppBar`. Customisable via `streamChatComponentBuilders(mediaGalleryPreview: ...)`. Exposes `StreamMediaGalleryPreviewScope` so per-page widgets (e.g. videos) can react to the active page.
- Added `StreamVideoPlayer` — the platform-aware video backend used by `StreamMediaGalleryPreview`. Pauses itself when its page is no longer active and resumes on return.
- Added `Translations.photosAndVideosLabel` — used by the footer's thumbnail-grid sheet header.
- Added `StreamQuotedMessage` and `StreamQuotedMessageThemeData` for the quoted message preview.
- `MessagePreviewFormatter` now renders `AttachmentType.urlPreview` messages with a link icon and caption / OG title / `linkAttachmentText` fallback.
- Added `StreamPollCardStyle`, `StreamPollQuestionStyle` and `StreamPollOptionVotesStyle` shared style classes for the poll sheets.
- Added a total vote count footer and per-option "View all" action to `StreamPollResultsSheet`.
- Added a `sheetHeaderStyle` field to each poll sheet theme data (including `StreamPollCreatorThemeData`).
- Re-exported `StreamSheetHeader`, `StreamSheetHeaderStyle`, `StreamSheetHeaderTheme` and `StreamSheetHeaderThemeData` from `stream_core_flutter`.
- Re-exported `showStreamSheet`, `StreamSheet`, `StreamSheetDragHandle`, `StreamSheetRoute`, `StreamSheetTransition`, `StreamSheetScrollableWidgetBuilder`, `StreamSheetTheme` and `StreamSheetThemeData` from `stream_core_flutter`. Poll sheets (`StreamPollOptionsSheet`, `StreamPollResultsSheet`, `StreamPollOptionVotesSheet`, `StreamPollCommentsSheet`, `StreamPollCreatorSheet`) now present as Stream-styled modal bottom sheets via `showStreamSheet`. See [`migrations/redesign/attachments_and_polls.md`](../../migrations/redesign/attachments_and_polls.md).
- Re-exported `StreamMessageAttachment` and `StreamMessageAttachmentStyle` from `stream_core_flutter`.
- Added a `BoxFit? fit` parameter to `ThumbnailSizeCalculator.calculate` (null defaults to `BoxFit.scaleDown`, matching `paintImage`) so callers using `cover` / `fill` get a bitmap large enough to render without upscale blur.
- Added `Translations.totalVoteCountLabel({int? count})`, `viewAllLabel`, `pollVotesLabel`, `endVoteConfirmationMessage` and `questionLabel({bool isPlural = false})`.
- Added `Translations.reactionsCountText(int count)` for the reaction-detail sheet header.
- Added `StreamChannelListTile.isPinned` — renders a pin icon alongside the existing mute icon for pinned channels.
- Exported `StreamScrollViewLoadMoreError` and `StreamScrollViewLoadMoreIndicator` from the public API.
- Exported `StreamTimestamp`, `DateFormatter`, `formatDate` and `formatRecentDateTime` from the public API.
- Added `DateTimeComparisonUtils` extension on `DateTime` (`isToday`, `isYesterday`, `isWithinLastMinute`, `isWithinLastWeek`, `isInSameYear`, `isSame(other, unit:)`) and the `DateTimeUnit` enum (`year` / `month` / `day` / `hour` / `minute` / `second` / `millisecond` / `microsecond`). All getters compare in local time and read the current instant via `package:clock`, so they're testable under `withClock(...)`.

🔄 Changed

- Widened `share_plus` to `>=12.0.2 <14.0.0` so apps can adopt the latest major. Raised minimum versions of bundled UI/media dependencies (`cached_network_image`, `chewie`, `desktop_drop`, `diacritic`, `file_selector`, `flutter_markdown`, `flutter_svg`, `gal`, `image_picker`, `image_size_getter`, `jiffy`, `just_audio`, `lottie`, `media_kit`, `media_kit_video`, `photo_manager`, `url_launcher`, `video_player`) to current resolved versions.
- Changed the default `StreamChat.backgroundKeepAlive` from 1 minute to 15 seconds,
  matching `StreamChatCore`. See `stream_chat_flutter_core` changelog for rationale.
- `StreamPhotoGalleryTile` now auto-sizes the platform thumbnail request from the tile's layout × DPR (132px fallback) instead of always asking for 400×400, so cells decode only what they paint. Pass an explicit `thumbnailSize` to override.
- `formatRecentDateTime` reworked to a five-state cascade matching the Figma design system: `Just now` (< 1 min) / `Today at H:mm` / `Yesterday at H:mm` / `Weekday at H:mm` (within the last week) / `MMM do at H:mm` (older). Previously emitted `formatDate`-style output with the time appended.

🐞 Fixed

- Set supported emojis for the reaction picker and detail sheet to the full set of supported emojis from `stream_core_flutter`.
- Fixed `StreamCommandAutocompleteOptions` and `StreamMentionAutocompleteOptions` expanding to half the screen height — both now cap at a fixed max height (208px / 176px) and scroll internally so the list can't dominate the screen or overlap the header.
- Fixed the "Add an option" button in the poll creator looking like a tappable empty option row while disabled. The button is now hidden when adding a new option isn't allowed (an existing option is empty, or the maximum has been reached) instead of rendering as a disabled lookalike.
- Fixed voice recording duration label jumping by ~1 second when playback starts. The recording timer tracks duration in whole seconds, so the stored value can be up to 1 second longer than the actual audio file. The player now resolves this by keeping the larger of the stored and player-reported durations, matching the strategy used by the iOS SDK.
- Fixed voice message time label displaying elapsed time instead of remaining time.
- Fixed RTL layout for the scroll-to-bottom button, swipe-to-reply icon, and voice recording lock button.
- Fixed draft stream updates clobbering the composer while editing a message.
- Fixed retries of in-flight sends being routed through `updateMessage` instead of `sendMessage`.
- Fixed composer attachment button staying rotated at 45° after the inline picker was dismissed.
- Fixed composer focus being lost after selecting a command from the attachment picker.
- Fixed gallery attachment picker empty placeholder using an oversized icon.
- Fixed gallery attachment picker permission placeholder not being centered and inconsistent grid and "add more" tile spacing.
- Fixed `EndOfFrameCallbackWidget` showing a generic error string when its callback throws.
- Fixed unintended Material ink ripple on message tap.
- Standardised empty and error states across channel, thread, draft, member, user, message search, poll vote, reaction and photo gallery scroll views.
- Standardised list separators across thread, draft, member, user and message search scroll views to match the channel scroll view.
- Fixed `StreamPhotoGalleryTile` missing rounded corners and its badges not mirroring in RTL.
- Fixed the "thread reply" action showing on parent messages while already inside their thread view.
- Fixed poll vote progress bars re-animating from zero whenever the poll message was re-mounted in the message list (e.g. on jump-to-message, scrolling, or after new messages were sent).
- Voice recording playback now pauses automatically when the app moves to the background.
- Fixed voice recording playback resetting on the first tap after the app returned from the background. `StreamVoiceRecordingAttachmentPlaylist.didUpdateWidget` now compares the projected playlist (content-based equality on track uri / title / duration / waveform) instead of the raw `Attachment` list, so re-syncs that mint fresh client-side `Attachment` UUIDs no longer trip a needless `updatePlaylist()` mid-playback.
- Fixed `PollAddCommentDialog` and `PollSuggestOptionDialog` accepting whitespace-only or unchanged submissions; the confirm action now disables when the trimmed text is empty or matches the initial value.
- Fixed `StreamPhotoGalleryTile` using a hand-rolled icon as its loading placeholder and silently rendering nothing on decode failure. Now uses the shared `StreamImageLoadingPlaceholder` while loading and `StreamImageErrorPlaceholder` if the thumbnail fails to load.
- Fixed poll, attachment-action, and message-action dialog buttons rendering their labels in uppercase (e.g. `CANCEL`, `SEND`, `FLAG`, `DELETE`); they now use the localized labels as-is so they match the rest of the system.
- Fixed tapping a quoted parent message inside a thread doing nothing (or kicking back to the channel). The thread message list now resolves the parent slot directly and scrolls/highlights it instead of falling through to `loadChannelAtMessage`.
- Fixed the jump-to-message highlight starting before the scroll settled, which made the fade barely visible (or invisible if the target hadn't been mounted yet). The message list now awaits the scroll, then plays a 1s hold + 1s ease-out fade — closer to the highlight feel in Slack's permalink jump.

## Upcoming Changes

🐞 Fixed

- Fixed `StreamMessageListView` not auto-scrolling to the bottom on the user's own outgoing message
  until the server confirmed it.
- Fixed `StreamMessageListView` tripping `A RenderViewport exceeded its maximum number of layout
  cycles` under mid-list anchored layout. `ScrollablePositionedList` now preserves the scroll offset
  across reanchors instead of resetting it to 0.
- Fixed `RenderBox was not laid out` thrown by `MessageCard._updateWidthLimit` when the attachments
  subtree was detached between scheduling the post-frame callback and it firing (e.g. the list was
  rebuilt or the message removed). Added a `hasSize` guard before reading `RenderBox.size`.

🚀 Improved

- `ScrollablePositionedList.padding` now accepts `EdgeInsetsGeometry` (resolved against
  `Directionality`), and `scrollTo` lands the target at the content-area edge by adjusting for
  leading padding.

## 9.24.0

✅ Added

- `StreamMessageListView` now accepts `maximumMessageLimit` to cap the loaded message list. See
  `MessageListCore` for the trim semantics.

🐞 Fixed

- Fixed `StreamMessageListView` thread page crashing with `StateError` when the parent message was no
  longer present in the channel's loaded messages (e.g. filtered, shadowed, or paginated out). The
  thread now falls back to the captured parent message in that case.

🚀 Improved

- `StreamMessageListView`'s `markRead` / `markThreadRead` now fire on the leading edge of their 1s
  debounce window, so the first read receipt after entering a channel or sending a message hits the
  server immediately instead of waiting for the trailing edge. The redundant local `unreadCount = 0`
  short-circuit on own-message send was removed — the leading-edge mark plus `readStream` updates
  now keep the unread badge in sync without an extra `setState`.

## 10.0.0-beta.13

🛑️ Breaking
- SDK Redesign Changes. For more details, please refer to the [migration guide](https://github.com/GetStream/stream-chat-flutter/blob/210ff93f955be3f85c62e860309bd9aa240a5446/migrations).
  The SDK redesign introduces a fresher default UI, but also better APIs for customization of the components.

## 10.0.0-beta.12

🐞 Fixed

- Fixed regression in `emoji_code` support for reactions.

🛑️ Breaking

- Replaced `ArgumentError` with typed errors in `StreamAttachmentPickerController`:
  `AttachmentTooLargeError` (file size exceeds limit) and `AttachmentLimitReachedError`
  (attachment count exceeds limit). [[#2476]](https://github.com/GetStream/stream-chat-flutter/issues/2476)
- By default the preview of the last message will show deleted message indicator instead of filtering it out. 

For more details, please refer to the [migration guide](../../migrations/v10-migration.md).

- Included the changes from version [`9.23.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 9.23.0

🐞 Fixed

- Fixed `StreamChannelAvatar` crashing with `RangeError` when user/channel name is empty.
- Fixed audio tone bleeding into recorded voice message when playing custom feedback sound on recording start.
- Fixed poll dialog AppBar back button color not being themeable. [[#2484]](https://github.com/GetStream/stream-chat-flutter/issues/2484)

## 10.0.0-beta.11

- Included the changes from version [`9.22.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 9.22.0

✅ Added

- Added haptic and system sound feedback for voice recording interactions. Feedback can be
  customized by extending `AudioRecorderFeedback` or using `AudioRecorderFeedbackWrapper` with
  custom callbacks. [[#2463]](https://github.com/GetStream/stream-chat-flutter/issues/2463)
- Added support for deleting options while creating a poll in
  `StreamPollCreator`. [[#2453]](https://github.com/GetStream/stream-chat-flutter/issues/2453)

🐞 Fixed

- Fixed focus randomly shifting to poll title while editing option text in poll
  creator. [[#2464]](https://github.com/GetStream/stream-chat-flutter/issues/2464)

## 10.0.0-beta.10

- Included the changes from version [`9.21.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 9.21.0

🐞 Fixed

- Fixed StreamGallery not respecting the safe area for fullscreen
  media. [[#2454]](https://github.com/GetStream/stream-chat-flutter/issues/2454)

## 10.0.0-beta.9

✅ Added

- Added `reactionIndicatorBuilder` parameter to `StreamMessageWidget` for customizing reaction
  indicators. Users can now display reaction counts alongside emojis on mobile, matching desktop/web
  behavior. Fixes [#2434](https://github.com/GetStream/stream-chat-flutter/issues/2434).
  ```dart
  // Example: Show reaction count next to emoji
  StreamMessageWidget(
    message: message,
    reactionIndicatorBuilder: (context, message, onTap) {
      return StreamReactionIndicator(
        message: message,
        onTap: onTap,
        reactionIcons: StreamChatConfiguration.of(context).reactionIcons,
        reactionIconBuilder: (context, icon) {
          final count = message.reactionGroups?[icon.type]?.count ?? 0;
          return Row(
            children: [
              icon.build(context),
              const SizedBox(width: 4),
              Text('$count'),
            ],
          );
        },
      );
    },
  )
  ```

- Added `reactionIconBuilder` and `backgroundColor` parameters to `StreamReactionPicker`.
- Exported `StreamReactionIndicator` and related components (`ReactionIndicatorBuilder`,
  `ReactionIndicatorIconBuilder`, `ReactionIndicatorIcon`, `ReactionIndicatorIconList`).

🛑️ Breaking

- `onAttachmentTap` callback signature changed to include `BuildContext` as first parameter and
  returns `FutureOr<bool>` to indicate if handled.
  ```dart
  // Before
  StreamMessageWidget(
    message: message,
    onAttachmentTap: (message, attachment) {
      // Could only override - no way to fallback to default behavior
      if (attachment.type == 'location') {
        showLocationDialog(context, attachment);
      }
      // Other attachment types lost default behavior
    },
  )
  
  // After
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

- `ReactionPickerIconList` constructor changed: removed `message` parameter, changed `reactionIcons`
  type to `List<ReactionPickerIcon>`, renamed `onReactionPicked` to `onIconPicked`.

For more details, please refer to the [migration guide](../../migrations/v10-migration.md).

- Included the changes from version [`9.20.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 9.20.0

✅ Added

- Added delivered status to `SendingIndicator` (double grey check for delivered, double accentPrimary check for read).
- Added `isMessageDelivered` parameter to `SendingIndicator` widget.
- Added `MessagePreviewFormatter` interface and `StreamMessagePreviewFormatter` implementation for
  customizing message preview text formatting in channel lists and draft messages.
- Added `messagePreviewFormatter` property to `StreamChatConfigurationData` for global customization
  of message preview formatting.
- Added formatter properties to theme data classes for customizing date/timestamp
  formatting. [[#2312]](https://github.com/GetStream/stream-chat-flutter/issues/2312) [[#2406]](https://github.com/GetStream/stream-chat-flutter/issues/2406)

🐞 Fixed

- Fixed mistakenly passing the hyperlink text to the `onLinkTap` callback instead of the actual `href`.
- Fixed high memory usage when displaying multiple image
  attachments. [[#2228]](https://github.com/GetStream/stream-chat-flutter/issues/2228)

## 10.0.0-beta.8

🛑️ Breaking

- `onCustomAttachmentPickerResult` has been removed. Use `onAttachmentPickerResult` which returns `FutureOr<bool>` to indicate if the result was handled.
  ```dart
  // Before
  StreamMessageInput(
    onCustomAttachmentPickerResult: (result) {
      // Handle custom location attachment
      final location = result.data['location'];
      sendLocationMessage(location);
    },
  )
  
  // After
  StreamMessageInput(
    onAttachmentPickerResult: (result) {
      if (result is CustomAttachmentPickerResult) {
        // Handle custom location attachment
        final location = result.data['location'];
        sendLocationMessage(location);
        return true; // Skip default handling
      }
      return false; // Use default handling for built-in types
    },
  )
  ```

- `customAttachmentPickerOptions` has been removed. Use `attachmentPickerOptionsBuilder` to modify, reorder, or extend default options.
  ```dart
  // Before - could only add custom options
  StreamMessageInput(
    customAttachmentPickerOptions: [
      TabbedAttachmentPickerOption(
        key: 'location',
        icon: Icon(Icons.location_on),
        // ...
      ),
    ],
  )
  
  // After - can now modify, filter, or extend default options
  StreamMessageInput(
    attachmentPickerOptionsBuilder: (context, defaultOptions) {
      return [
        ...defaultOptions, // Keep all default options
        TabbedAttachmentPickerOption(
          key: 'location',
          icon: Icon(Icons.location_on),
          // ...
        ),
      ];
    },
  )
  ```
  
For more details, please refer to the [migration guide](../../migrations/v10-migration.md).

- Included the changes from version [`9.19.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 9.19.0

✅ Added

- Added `StreamMessageListView.floatingDateDividerBuilder` in order to specifically customize the
  floating date divider.
- Added spacing to typing indicator.

## 10.0.0-beta.7

✅ Added

- Added support for `StreamMessageWidget.deletedMessageBuilder` to customize the deleted message UI.

- Included the changes from version [`9.18.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 9.18.0

🐞 Fixed

- Fixed `StreamMessageListView` not marking thread messages as read when scrolled to the bottom of the list.
- Fixed `StreamMessageInput` not validating draft messages before creating/updating them.

## 10.0.0-beta.6

🐞 Fixed

- Fixed users with `sendReply` capability unable to send replies in threads.
- Fixed delete/flag message dialogs executing action when dialog is dismissed without confirmation.

- Included the changes from version [`9.17.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 9.17.0

✅ Added

- Added `messageBackgroundGradient` property to `StreamMessageThemeData` for gradient message
  backgrounds.

🐞 Fixed

- Fixed `.replaceMentions` not escaping special characters in the username.
- Fixed videos not being saved to gallery correctly on mobile
  platforms. [[#2357]](https://github.com/GetStream/stream-chat-flutter/issues/2357)
- Fixed unread indicator button using hardcoded white color instead of theme color
  `colorTheme.barsBg`. [[#2366]](https://github.com/GetStream/stream-chat-flutter/issues/2366)
- Fixed `GradientAvatars` for users with same-length IDs would have identical
  colors. [[#2369]](https://github.com/GetStream/stream-chat-flutter/issues/2369)

## 10.0.0-beta.5

- Included the changes from version [`9.16.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 9.16.0

🐞 Fixed

- Fixed context menu being truncated and scrollable on web when there was enough space to display it
  fully. [[#2317]](https://github.com/GetStream/stream-chat-flutter/issues/2317)
- Fixed `StreamMessageInput` cooldown resume error if channel state is not yet initialized.
  [[#2338]](https://github.com/GetStream/stream-chat-flutter/issues/2338)

✅ Added

- Added `padding` and `textInputMargin` to `StreamMessageInput` to allow fine-tuning the layout.

## 10.0.0-beta.4

✅ Added

- Added `emojiCode` property to `StreamReactionIcon` to support custom emojis in reactions.
- Updated default reaction builders with standard emoji codes. (`❤️`, `👍`, `👎`, `😂`, `😮`)
- Added `StreamChatConfiguration.maybeOf()` method for safe context access in async operations.

- Included the changes from version [`9.15.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 9.15.0

✅ Added

- Added `bottom` and `bottomOpacity` to the `StreamChannelHeader` widget.
- Added `StreamChat.maybeOf()` method for safe context access in async operations.

🐞 Fixed

- Fixed `StreamMessageInput` crashes with "Null check operator used on a null value" when async
  operations continue after widget unmounting.

## 10.0.0-beta.3

🛑️ Breaking

- **Deprecated API Cleanup**: Removed all deprecated classes, methods, and properties for the v10 major release:
  - **Removed Classes**: `DmCheckbox` (use `DmCheckboxListTile`), `StreamIconThemeSvgIcon` (use `StreamSvgIcon`), `StreamVoiceRecordingThemeData` (use `StreamVoiceRecordingAttachmentThemeData`), `StreamVoiceRecordingLoading`, `StreamVoiceRecordingSlider` (use `StreamAudioWaveformSlider`), `StreamVoiceRecordingPlayer` (use `StreamVoiceRecordingAttachment`), `StreamVoiceRecordingListPlayer` (use `StreamVoiceRecordingAttachmentPlaylist`)
  - **Removed Properties**: `reactionIcons` and `voiceRecordingTheme` from `StreamChatTheme`, `isThreadConversation` from `FloatingDateDivider`, `idleSendButton` and `activeSendButton` from `StreamMessageInput`, `isCommandEnabled` and `isEditEnabled` from `StreamMessageSendButton`, `assetName`, `width`, and `height` from `StreamSvgIcon`
  - **Removed Constructor Parameters**: `useNativeAttachmentPickerOnMobile` from various components, `allowCompression` from `StreamAttachmentHandler.pickFile()` and `StreamFilePicker` (use `compressionQuality` instead), `cid` from `StreamUnreadIndicator` constructor
  - **Removed Methods**: `lastUnreadMessage()` from message list extensions (use `StreamChannel.getFirstUnreadMessage`), `loadBuffer()` and `_loadAsync()` from `StreamVideoThumbnailImage`
  - **StreamSvgIcon Refactoring**: Removed 80+ deprecated factory constructors. Use `StreamSvgIcon(icon: StreamSvgIcons.iconName)` instead of factory constructors like `StreamSvgIcon.add()`
- `PollMessage` widget has been removed and replaced with `PollAttachment` for better integration with the attachment system. Polls can now be customized through `PollAttachmentBuilder` or by creating custom poll attachment widgets via the attachment builder system.
- `AttachmentPickerType` enum has been replaced with a sealed class to support extensible custom types like contact and location pickers. Use built-in types like `AttachmentPickerType.images` or define your own via `CustomAttachmentPickerType`.
- `StreamAttachmentPickerOption` has been replaced with two sealed classes to support layout-specific picker options: `SystemAttachmentPickerOption` for system pickers (e.g. camera, files) and `TabbedAttachmentPickerOption` for tabbed pickers (e.g. gallery, polls, location).
- `showStreamAttachmentPickerModalBottomSheet` now returns a `StreamAttachmentPickerResult` instead of `AttachmentPickerValue` for improved type safety and clearer intent handling.
- `StreamMobileAttachmentPickerBottomSheet` has been renamed to `StreamTabbedAttachmentPickerBottomSheet`, and `StreamWebOrDesktopAttachmentPickerBottomSheet` has been renamed to `StreamSystemAttachmentPickerBottomSheet` to better reflect their respective layouts.

For more details, please refer to the [migration guide](../../migrations/v10-migration.md).

✅ Added

- Added `extraData` field to `AttachmentPickerValue` to support storing and retrieving custom picker state (e.g. tab-specific config).
- Added `customAttachmentPickerOptions` to `StreamMessageInput` to allow injecting custom picker tabs like contact and location pickers.
- Added `onCustomAttachmentPickerResult` callback to `StreamMessageInput` to handle results returned by custom picker tabs.

- Included the changes from version [`9.14.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 9.14.0

🐞 Fixed

- Fixed `StreamMessageInput` tries to expand to full height when used in a unconstrained environment.
- Fixed `StreamCommandAutocompleteOptions` to style the command name with `textHighEmphasis` style.

## 10.0.0-beta.2

- Included the changes from version [`9.13.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 9.13.0

🐞 Fixed

- Fixed `FloatingDateDivider` not showing the correct date when the latest message was too big and
  exceeded the viewport main axis size.
- Fixed `ScrollToBottom` button always showing when the latest message was too big and exceeded the
  viewport main axis size.

## 10.0.0-beta.1

🛑️ Breaking

- `StreamReactionPicker` now requires reactions to be explicitly handled via `onReactionPicked`. *(Automatic handling is no longer supported.)*
- `StreamMessageAction` is now generic `(StreamMessageAction<T>)`, enhancing type safety. Individual onTap callbacks have been removed; actions are now handled centrally by widgets like `StreamMessageWidget.onCustomActionTap` or modals using action types.
- `StreamMessageReactionsModal` no longer requires the `messageTheme` parameter. The theme now automatically derives from the `reverse` property.
- `StreamMessageWidget` no longer requires the `showReactionTail` parameter. The reaction picker tail is now always shown when the reaction picker is visible.

For more details, please refer to the [migration guide](../../migrations/v10-migration.md).

✅ Added

- Added new `StreamMessageActionsBuilder` which provides a list of actions to be displayed in the message actions modal.
- Added new `StreamMessageActionConfirmationModal` for confirming destructive actions like delete or flag.
- Added new `StreamMessageModal` and `showStreamMessageModal` for consistent message-related modals with improved transitions and backdrop effects.
  ```dart
  showStreamMessageModal(
    context: context,
    ...other parameters,
    builder: (context) => StreamMessageModal(
      ...other parameters,
      headerBuilder: (context) => YourCustomHeader(),
      contentBuilder: (context) => YourCustomContent(),
    ),
  );
  ```
- Added `desktopOrWeb` parameter to `PlatformWidgetBuilder` to allow specifying a single builder for both desktop and web platforms.
- Added `reactionPickerBuilder` to `StreamMessageActionsModal`, `StreamMessageReactionsModal`, and `StreamMessageWidget` to enable custom reaction picker widgets.
- Added `StreamReactionIcon.defaultReactions` providing a predefined list of common reaction icons.
- Exported `StreamMessageActionsModal` and `StreamModeratedMessageActionsModal` which are now based on `StreamMessageModal` for consistent styling and behavior.

## 9.12.0

✅ Added

- Added support for `MessageReminder` feature, which allows users to bookmark or set reminders
  for specific messages in a channel.

## 9.11.0

🐞 Fixed

- Fixed `StreamMessageInput` throwing exception when a non-initialized `Channel` is used.

🔄 Changed

- Updated `just_audio` dependency to `">=0.9.38 <0.11.0"`.

## 9.10.0

🔄 Changed

- Updated `share_plus` dependency to `^11.0.0`.
- Updated `desktop_drop` dependency to `">=0.5.0 <0.7.0"`.

## 9.9.0

✅ Added

- Added support for Draft messages preview.
- Added a new `StreamDraftListView` for displaying draft messages.
- Added a confirmation dialog for end vote in Polls. [[#2211]](https://github.com/GetStream/stream-chat-flutter/issues/2211)

🐞 Fixed

- [[#2182]](https://github.com/GetStream/stream-chat-flutter/issues/2182) Fixes StreamMessageInput not listening to channel capabilities.

🔄 Changed

- Exported `StreamQuotedMessageWidget` to allow customization of quoted messages using `StreamMessageWidget.quotedMessageBuilder`.

## 9.8.0

🐞 Fixed

- [[#2184]](https://github.com/GetStream/stream-chat-flutter/issues/2184) Fixed messages not being
  marked as read when scrolled to the bottom.
- [[#2187]](https://github.com/GetStream/stream-chat-flutter/issues/2187) Fixed `MessageListView`
  scrolling back up after reaching bottom when unread indicator or scroll to bottom button is
  tapped.
- [[#2085]](https://github.com/GetStream/stream-chat-flutter/issues/2085) Fixed handling of read
  events in the Channel class.
- [[#2150]](https://github.com/GetStream/stream-chat-flutter/issues/2150) Fixed Push notifications
  for mentions shows user ID instead of Username.
- [[#2203]](https://github.com/GetStream/stream-chat-flutter/issues/2203) Fixed StreamMessageInput
  shows Poll option even if polls are disabled in channel config.

## 9.7.0

🐞 Fixed

- [[#2118]](https://github.com/GetStream/stream-chat-flutter/issues/2118) Fixed invalid assertions
  applied on message input command and attachment button.
- [[#2042]](https://github.com/GetStream/stream-chat-flutter/issues/2042) Fixed `StreamMessageInput`
  send message predicate to properly handle shift+enter for new lines and improve message text validation.

✅ Added

- Added support for new message moderation feature in the SDK.

## 9.6.0

🐞 Fixed

- [[#2137]](https://github.com/GetStream/stream-chat-flutter/issues/2137) Fixed message input
  buttons not being able to customized.
- [[#1775]](https://github.com/GetStream/stream-chat-flutter/issues/1775) Fix incorrect message order.

## 9.5.0

🐞 Fixed

- Fixed `StreamMessageInput` not able to edit the ogAttachments.
- Fixed `MessageWidget` showing pinned background for deleted messages.

✅ Added

- Introduced `StreamMessageInput.useSystemAttachmentPicker` for system media picker support.
- Introduced `StreamMessageThemeData.messageDeletedStyle` to style the text on a deleted message.

🔄 Changed

- Updated the message list view to prevent pinning messages that have restricted visibility.
- Deprecated `StreamMessageInput.useNativeAttachmentPickerOnMobile` in favor of `StreamMessageInput.useSystemAttachmentPicker`.

## 9.4.0

🔄 Changed

- Updated minimum Flutter version to 3.27.4 for the SDK.
- Replaced [image_gallery_saver_plus](https://pub.dev/packages/image_gallery_saver_plus) with [gal](https://pub.dev/packages/gal)

## 9.3.0

✅ Added

- Added support for `voiceRecording` type attachments.

🔄 Changed

- Deprecated `PlayListItem` in favor of `PlaylistTrack`.
- Deprecated `StreamVoiceRecordingListPlayer` in favor of `StreamVoiceRecordingAttachmentPlaylist`.
- Deprecated `StreamVoiceRecordingLoading` as it is no longer used.
- Deprecated `StreamVoiceRecordingPlayer` in favor of `StreamVoiceRecordingAttachment`.
- Deprecated `StreamVoiceRecordingSlider` in favor of `StreamAudioWaveformSlider`.
- Deprecated `VoiceRecordingAttachmentBuilder` in favor of `VoiceRecordingAttachmentPlaylistBuilder`.
- Deprecated `StreamVoiceRecordingTheme` in favor of `StreamVoiceRecordingAttachmentTheme`.

## 9.2.0+1

- Remove untracked files from the package.

## 9.2.0

🐞 Fixed

- Fixed `StreamChannel` not available in the widget tree for various poll-related dialogs.

## 9.1.0

✅ Added

- Added a new `StreamThreadListView` widget to load and display list of threads.
- Added a new `StreamUnreadThreadsBanner` widget to display count of unread threads.
- Added new `StreamUnreadIndicator.channels` and `StreamUnreadIndicator.threads` constructors to
  display unread channels and threads respectively.

🔄 Changed

- Deprecated `StreamUnreadIndicator` cid property in favor of `StreamUnreadIndicator.channels`
  constructor.

## 9.0.0

🛑️ Breaking

- The `StreamAttachmentPickerController` has been restructured to improve flexibility and support
  additional use cases like poll management.
    - Previously managed a `List<Attachment>` but now manages an `AttachmentPickerValue` object,
      which includes:
        - `attachments`: A list of attachments.
        - `poll`: A new field for managing polls.

✅ Added

- Added a new `StreamPollCreator` widget to facilitate poll creation within the chat interface.
- Added a new `PollMessage` widget to display poll messages within the chat interface.

🔄 Changed

- Updated minimum Flutter version to 3.24.5 for the SDK.

## 8.3.0

✅ Added

- Added several new widgets to enhance the AI assistant features.
    - `StreamingMessageView` to show AI assistant messages with streaming animation.
    - `AITypingIndicatorView` to show AI typing indicator.

✅ Added

- Added several new widgets to enhance the AI assistant features.
    - `StreamingMessageView` to show AI assistant messages with streaming animation.
    - `AITypingIndicatorView` to show AI typing indicator.

🐞 Fixed

- [[#2030]](https://github.com/GetStream/stream-chat-flutter/issues/2030) Fixed `video_thumbnail`
  Namespace not specified.

## 8.2.0

✅ Added

- Added `onThreadTap` parameter to `MessageWidgetContent` to enable thread tap action.
- Messages by default now show an "Edited" label if text is edited. Use `showEditedLabel` to disable
  this functionality.

🐞 Fixed

- Fixed locale conversion in jiffy.

🔄 Changed

- Updated `stream_chat_flutter_core` dependency to [
  `8.2.0`](https://pub.dev/packages/stream_chat/changelog).

## 8.1.0

🐞 Fixed

- Fixed enrichment errors causing some URLs to enrich twice.
- Added option to use the native attachment picker on mobile

🔄 Changed

- Changed minimum Flutter version to 3.22 for the SDK.

## 8.0.0

🐞 Fixed

- Fixed null errors in web from markdown.
- Fixed bug causing background events to be sent in foreground.

## 7.3.0

🐞 Fixed

- Fixed copy message function.

🔄 Changed

- Changed minimum Flutter version to 3.19 for the SDK.
- Updated `stream_chat_flutter_core` dependency to [
  `7.3.0`](https://pub.dev/packages/stream_chat/changelog).

## 7.2.2

✅ Added

- Added `customAttachmentBuilders` parameter for `StreamAttachmentWidgetBuilder.defaultBuilders`.
- `attachmentBuilders` parameter for `StreamMessageWidget` now only expects custom builders.
- Added `StreamMediaAttachmentBuilder` widget to show media attachments in a message.

🐞 Fixed

- Added export for `message_widget_content_components.dart` to allow for easier customization of
  message content components.
- Fixed error when channel image is not set.
- Fixes reaction picker tail showing up unexpectedly.
- Copying a message now replaces the User IDs with user names.
- Exported thumbnail widgets from the package.
- Extends predicates for sending and clearing messages to mobile.

🔄 Changed

- Updated `stream_chat_flutter_core` dependency to [
  `7.2.2`](https://pub.dev/packages/stream_chat/changelog).

## 7.2.1

✅ Added

- Added `VoiceRecordingAttachmentBuilder`, for displaying voice recording attachments in the chat.

🐞 Fixed

- Fixed wrong calculation of the last unread message indicator.

## 7.2.0-hotfix.1

🔄 Changed

- Updated `stream_chat_flutter_core` dependency to [
  `7.2.0-hotfix.1`](https://pub.dev/packages/stream_chat/changelog).

## 7.2.0

✅ Added
`StreamMessageListView` will now by default show unread indicator floating on top of the message
list that will scroll to last read message when tapped and mark channel as unread when dismissed.

- Added `showUnreadIndicator` parameter to `StreamMessageListView` that controls visibility of new
  channel unread indicator
- Added `unreadIndicatorBuilder` parameter to `StreamMessageListView` that allows to provide custom
  unread indicator builder
- Added `markReadWhenAtTheBottom` parameter to `StreamMessageListView` that will toggle, previously
  default, behaviour of marking channel as read when message list is scrolled to the bottom (now
  default is `false`)
- Added `showUnreadCountOnScrollToBottom` parameter to `StreamMessageListView` that will toggle,
  previously shown by default, unread messages counter on the scroll to bottom button (no default is
  `false`)

Added Mark as Unread option to `StreamMessageWidget` context menu that will show for non-thread
messages of other users and mark channel as unread from selected message onwards.

- Added `showMarkUnreadMessage` to  `StreamMessageWidget` that controls visibility of Mark as Unread
  option.

## 7.1.0

🐞 Fixed

- Fixed quoted message having 0 bottom padding. All sides now have 8 padding

🔄 Changed

- Updated `photo_manager` dependency to `^3.0.0`
- Updated `lottie` to `>=2.6.0 <4.0.0`

## 7.0.2

✅ Added

- Added `ActionsBuilder` signature for function which will return default actions and allows past
  custom actions.
- Added `spaceBetweenActions` parameter for `StreamMessageInput` to control distance between actions

🐞 Fixed

- Removed double focus on `StreamMessageInput` when `focusNode` is provided for web and desktop.
- Optionally call `onThreadTap` in `BottomRow` to avoid `Null check operator used on a null value`

## 7.0.1

🐞 Fixed

- [[#1804]](https://github.com/GetStream/stream-chat-flutter/issues/1804) Fixed
  `StreamAttachmentWidgetBuilder`` is not accessible in 7.0.0.
- Updated `stream_chat_flutter_core` dependency
  to [`7.0.1`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

## 7.0.0

🛑️ Breaking

- Removed deprecated `ChannelPreview` widget. Use `StreamChannelListTile` instead.
- Removed deprecated `ChannelPreviewBuilder`, Use `StreamChannelListViewIndexedWidgetBuilder`
  instead.
- Removed deprecated `StreamUserItem` widget. Use `StreamUserListTile` instead.
- Removed deprecated `ReturnActionType` enum, No longer used.
- Removed deprecated `StreamMessageInput.attachmentThumbnailBuilders` parameter. Use
  `StreamMessageInput.mediaAttachmentBuilder` instead.
- Removed deprecated `MessageListView.onMessageSwiped` parameter. Try wrapping the `MessageWidget`
  with
  a `Swipeable`, `Dismissible` or a custom widget to achieve the swipe to reply behaviour.
- Removed deprecated `MessageWidget.showReactionPickerIndicator` parameter. Use
  `MessageWidget.showReactionPicker`
  instead.
- Removed deprecated `MessageWidget.bottomRowBuilder` parameter. Use
  `MessageWidget.bottomRowBuilderWithDefaultWidget`
  instead.
- Removed deprecated `MessageWidget.deletedBottomRowBuilder` parameter.
  Use `MessageWidget.deletedBottomRowBuilderWithDefaultWidget` instead.
- Removed deprecated `MessageWidget.usernameBuilder` parameter. Use
  `MessageWidget.usernameBuilderWithDefaultWidget`
  instead.
- Removed deprecated `MessageTheme.linkBackgroundColor` parameter. Use
  `MessageTheme.urlAttachmentBackgroundColor`
  instead.
- Removed deprecated `showConfirmationDialog` method. Use `showConfirmationBottomSheet` instead.
- Removed deprecated `showInfoDialog` method. Use `showInfoBottomSheet` instead.
- Removed deprecated `wrapAttachmentWidget` method. Use `WrapAttachmentWidget` class instead.
- Removed deprecated `showReactionPickerTail` parameter. Use `showReactionPicker` instead.

✅ Added

- Added support for `StreamMessageInput.contentInsertionConfiguration` to specify the content
  insertion configuration.
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

- Updated `jiffy` dependency to `^6.2.1`.
- Updated minimum supported `SDK` version to Flutter 3.13/Dart 3.1
- Updated `stream_chat_flutter_core` dependency
  to [`7.0.0`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

# 6.12.0

🐞 Fixed

- Fix render overflow issue with `StreamTypingIndicator`. It now uses `Flexible`
  inside `Row`.

- [[#1759]](https://github.com/GetStream/stream-chat-flutter/issues/1759) Fixed
  The Reaction Picker is not being removed when I set showReactionPicker to false.

# 6.11.0

🐞 Fixed

- [[#1740]](https://github.com/GetStream/stream-chat-flutter/issues/1740) Fixed
  Plugin `video_player:macos` has multiple possible implementations.

# 6.10.0

🐞 Fixed

- [[#1721]](https://github.com/GetStream/stream-chat-flutter/issues/1721)
  Fixed `StreamMessageInput.allowedAttachmentPickerTypes` not working on mobile devices.

✅ Added

- Added support for overriding the `MessageWidget.onReactionsHover` callback.
  > **Note**
  > Used only in desktop devices (web and desktop).

## 6.9.0

🐞 Fixed

- [[#1702]](https://github.com/GetStream/stream-chat-flutter/issues/1702)
  Fixed `Message.replaceMentions` not treating `@usernames` as mentions.
- [[#1694]](https://github.com/GetStream/stream-chat-flutter/issues/1694) Fixed Video player buttons
  getting covered by bottom toolbar.

✅ Added

- Added support for listening error events in AttachmentPickerBottomSheet.
- Added support for overriding the `MessageWidget.onReactionTap` callback.
- Added support for `StreamMessageInput.contentInsertionConfiguration` to specify the content
  insertion configuration.
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
- Updated `stream_chat_flutter_core` dependency
  to [`6.8.0`](https://pub.dev/packages/stream_chat_flutter_core/changelog).
- Updated jiffy dependency to ^6.2.1.

## 6.8.1

🐞 Fixed

- Fixed `StreamMessageInput` always sending message as `system`.

## 6.8.0

🔄 Changed

- Updated `stream_chat_flutter_core` dependency
  to [`6.7.0`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

## 6.7.0

🔄 Changed

- Updated `stream_chat_flutter_core` dependency
  to [`6.6.0`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

## 6.6.0

🔄 Changed

- Updated minimum supported `SDK` version to Flutter 3.7/Dart 2.19

## 6.5.0

🐞 Fixed

- [[#1620]](https://github.com/GetStream/stream-chat-flutter/issues/1620) Fixed messages Are Not
  Hard Deleting even
  after overriding the `onConfirmDeleteTap` callback.
- [[#1621]](https://github.com/GetStream/stream-chat-flutter/issues/1621) Fixed `createdAtStyle`
  null check error
  in `SendingIndicatorBuilder`.
- [[#1069]](https://github.com/GetStream/stream-chat-flutter/issues/1069) Fixed message swipe to
  reply using same
  direction for both current user and other users. It now uses `SwipeDirection.startToEnd` for
  current user
  and `SwipeDirection.endToStart` for other users.
- [[#1590]](https://github.com/GetStream/stream-chat-flutter/issues/1590)
  Fixed `StreamMessageWidget.showReactionPickerIndicator` not toggling the reaction picker indicator
  visibility.
- [[#1639]](https://github.com/GetStream/stream-chat-flutter/issues/1639) Fixed attachments not
  showing in gallery view
  even after saving them to the device.
  > **Note**
  > This fix depends on the [image_gallery_saver](https://pub.dev/packages/image_gallery_saver)
  plugin. Make sure to add
  necessary permissions in your App as per the plugin documentation.
- [[#1642]](https://github.com/GetStream/stream-chat-flutter/issues/1642)
  Fixed `StreamMessageWidget.widthFactor` not
  working on web and desktop platforms.

✅ Added

- Added support for customizing attachments in `StreamMessageInput`. Use various properties
  mentioned
  below. [#1511](https://github.com/GetStream/stream-chat-flutter/issues/1511)
    * `StreamMessageInput.attachmentListBuilder` to customize the attachment list.
    * `StreamMessageInput.fileAttachmentListBuilder` to customize the file attachment list.
    * `StreamMessageInput.mediaAttachmentListBuilder` to customize the media attachment list.
      Includes images, videos
      and gifs.
    * `StreamMessageInput.fileAttachmentBuilder` to customize the file attachment item shown
      in `FileAttachmentList`.
    * `StreamMessageInput.mediaAttachmentBuilder` to customize the media attachment item shown in
      `MediaAttachmentList`.


- Added `StreamMessageInput.quotedMessageAttachmentThumbnailBuilders` to customize the thumbnail
  builders for quoted
  message attachments.

🔄 Changed

- Deprecated `StreamMessageInput.attachmentThumbnailBuilders` in favor
  of `StreamMessageInput.mediaAttachmentBuilder`.
- Deprecated `StreamMessageListView.onMessageSwiped`. Try wrapping the `MessageWidget` with
  a `Swipeable`, `Dismissible`
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
- Deprecated `StreamMessageWidget.showReactionPickerIndicator` in favor
  of `StreamMessageWidget.showReactionPicker`.

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

- [[#1600]](https://github.com/GetStream/stream-chat-flutter/issues/1600) Fixed
  type `ImageDecoderCallback` not found
  error on pre-Flutter 3.10.0 versions.
- [[#1605]](https://github.com/GetStream/stream-chat-flutter/issues/1605) Fixed Null exception is
  thrown on message list
  for unread messages when `ScrollToBottomButton` is pressed.
- [[#1615]](https://github.com/GetStream/stream-chat-flutter/issues/1615)
  Fixed `StreamAttachmentPickerBottomSheet` not
  able to find the `StreamChatTheme` when used in nested MaterialApp.

✅ Added

- Added support for `StreamMessageInput.allowedAttachmentPickerTypes` to specify the allowed
  attachment picker types.
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

- Added support for `StreamMessageWidget.onConfirmDeleteTap` to override the default action on
  delete confirmation.
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

- Added support for `StreamMessageWidget.quotedMessageBuilder`
  and `StreamMessageInput.quotedMessageBuilder` to override
  the default quoted message
  widget. [#1547](https://github.com/GetStream/stream-chat-flutter/issues/1547)

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

- Added support
  for `StreamChannelAvatar.ownSpaceAvatarBuilder`, `StreamChannelAvatar.oneToOneAvatarBuilder` and
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

- [[#1592]](https://github.com/GetStream/stream-chat-flutter/issues/1592) Fixed broken attachment
  download on web.
- [[#1591]](https://github.com/GetStream/stream-chat-flutter/issues/1591)
  Fixed `StreamChannelInfoBottomSheet` not
  rendering member list properly.
- [[#1427]](https://github.com/GetStream/stream-chat-flutter/issues/1427) Fixed unable to load asset
  error for
  `packages/stream_chat_flutter/lib/svgs/video_call_icon.svg`.

🔄 Changed

- Updated `dio` dependency to `^5.2.0`.

## 6.2.0

🐞 Fixed

- [[#1546]](https://github.com/GetStream/stream-chat-flutter/issues/1546)
  Fixed `StreamMessageInputTheme.linkHighlightColor` returning null for default theme.
- [[#1548]](https://github.com/GetStream/stream-chat-flutter/issues/1548) Fixed `StreamMessageInput`
  urlRegex only
  matching the lowercase `http(s)|ftp`.
- [[#1542]](https://github.com/GetStream/stream-chat-flutter/issues/1542) Handle error thrown
  in `StreamMessageInput`
  when unable to fetch a link preview.
- [[#1540]](https://github.com/GetStream/stream-chat-flutter/issues/1540)
  Use `CircularProgressIndicator.adaptive`
  instead of material indicator.
- [[#1490]](https://github.com/GetStream/stream-chat-flutter/issues/1490)
  Fixed `editMessageInputBuilder` property not
  used in `MessageActionsModal.editMessage` option.
- [[#1544]](https://github.com/GetStream/stream-chat-flutter/issues/1544) Fixed error thrown when
  unable to fetch
  image/data in Message link preview.
- [[#1482]](https://github.com/GetStream/stream-chat-flutter/issues/1482)
  Fixed `StreaChannelListTile` not showing
  unread indicator when `currentUser` is not present in the initial member list.
- [[#1487]](https://github.com/GetStream/stream-chat-flutter/issues/1487) Use localized title
  for `WebOrDesktopAttachmentPickerOption` in `StreamMessageInput`.
- [[#1250]](https://github.com/GetStream/stream-chat-flutter/issues/1250) Fixed bottomRow
  widgetSpans getting resized
  twice when `textScaling` is enabled.
- [[#1498]](https://github.com/GetStream/stream-chat-flutter/issues/1498) Fixed `MessageInput`
  autocomplete not working
  on non-mobile platforms.
- [[#1576]](https://github.com/GetStream/stream-chat-flutter/issues/1576) Temporary fix
  for `StreamMessageListView`
  getting broken when loaded at a particular message and a new message is added.

✅ Added

- Added support for `StreamMessageThemeData.urlAttachmentTextMaxLine` to specify the `.maxLines` for
  the url attachment
  text. [#1543](https://github.com/GetStream/stream-chat-flutter/issues/1543)

🔄 Changed

- Updated `shimmer` dependency to `^3.0.0`.
- Updated `image_gallery_saver` dependency to `^2.0.1`.
- Deprecated `ChannelPreview` in favor of `StreamChannelListTile`.
- Updated `stream_chat_flutter_core` dependency
  to [`6.2.0`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

## 6.1.0

🐞 Fixed

- [[#1502]](https://github.com/GetStream/stream-chat-flutter/issues/1502) Fixed `isOnlyEmoji` method
  Detects Single
  Hangul
  Consonants as Emoji.
- [[#1505]](https://github.com/GetStream/stream-chat-flutter/issues/1505) Fixed Message bubble
  disappears for Hangul
  Consonants.
- [[#1476]](https://github.com/GetStream/stream-chat-flutter/issues/1476)
  Fixed `UserAvatarTransform.userAvatarBuilder`
  works only for otherUser.
- [[#1490]](https://github.com/GetStream/stream-chat-flutter/issues/1490)
  Fixed `editMessageInputBuilder` property not
  used in message edit widget.
- [[#1523]](https://github.com/GetStream/stream-chat-flutter/issues/1523)
  Fixed `StreamMessageThemeData` not being
  applied correctly.
- [[#1525]](https://github.com/GetStream/stream-chat-flutter/issues/1525)
  Fixed `StreamQuotedMessageWidget` message for
  deleted messages not being shown correctly.
- [[#1529]](https://github.com/GetStream/stream-chat-flutter/issues/1529) Fixed `ClipboardData`
  requires non-nullable
  string as text on Flutter 3.10.
- [[#1533]](https://github.com/GetStream/stream-chat-flutter/issues/1533)
  Fixed `StreamMessageListView` messages grouped
  incorrectly w.r.t. timestamp.
- [[#1532]](https://github.com/GetStream/stream-chat-flutter/issues/1532)
  Fixed `StreamMessageWidget` actions dialog
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
- Deprecated `MessageTheme.linkBackgroundColor` in favor
  of `MessageTheme.urlAttachmentBackgroundColor`.
- Updated `stream_chat_flutter_core` dependency
  to [`6.1.0`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

## 6.0.0

🐞 Fixed

- [[#1456]](https://github.com/GetStream/stream-chat-flutter/issues/1456) Fixed logic for showing
  that a message was
  read using sending indicator.
- [[#1462]](https://github.com/GetStream/stream-chat-flutter/issues/1462) Fixed support for iPad in
  the share button for
  images.
- [[#1475]](https://github.com/GetStream/stream-chat-flutter/issues/1475) Fixed typo to fix
  compilation.

✅ Added

- Now it is possible to customize the max lines of the title of a url attachment. Before it was
  always 1 line.
- Added `attachmentActionsModalBuilder` parameter to `StreamMessageWidget` that allows to
  customize `AttachmentActionsModal`.
- Added `StreamMessageInput.sendMessageKeyPredicate`
  and `StreamMessageInput.clearQuotedMessageKeyPredicate` to
  customize the keys used to send and clear the quoted message.

🔄 Changed

- Updated dependencies to resolvable versions.

🚀 Improved

- Improved draw of reaction
  options. [#1455](https://github.com/GetStream/stream-chat-flutter/pull/1455)

## 5.3.0

🔄 Changed

- Updated `photo_manager` dependency to `^2.5.2`

🐞 Fixed

- [[#1424]](https://github.com/GetStream/stream-chat-flutter/issues/1424) Fixed a render issue when
  showing messages
  starting with 4 whitespaces.
- Fixed a bug where the `AttachmentPickerBottomSheet` was not able to identify the mobile browser.
- Fixed uploading files on Windows - fixed temp file path.

✅ Added

- New `noPhotoOrVideoLabel` displayed when there is no files to choose.

## 5.2.0

✅ Added

- Added a new `bottomRowBuilderWithDefaultWidget` parameter to `StreamMessageWidget` which contains
  a third parameter (
  default `BottomRow` widget with `copyWith` method available) to allow easier customization.

🔄 Changed

- Updated `lottie` dependency to `^2.0.0`
- Updated `desktop_drop` dependency to `^0.4.0`
- Updated `connectivity_plus` dependency to `^3.0.2`
- Updated `dart_vlc` dependency to `^0.4.0`
- Updated `file_picker` dependency to `^5.2.4`
- Deprecated `StreamMessageWidget.bottomRowBuilder` in favor
  of `StreamMessageWidget.bottomRowBuilderWithDefaultWidget`.
- Deprecated `StreamMessageWidget.deletedBottomRowBuilder` in favor
  of `StreamMessageWidget.bottomRowBuilderWithDefaultWidget`.
- Deprecated `StreamMessageWidget.usernameBuilder` in favor
  of `StreamMessageWidget.bottomRowBuilderWithDefaultWidget`.

🐞 Fixed

- [[#1379]](https://github.com/GetStream/stream-chat-flutter/issues/1379) Fixed "Issues with photo
  attachments on web",
  where the cached image attachment would not render while uploading.
- Fix render overflow issue with `MessageSearchListTileTitle`. It now uses `Text.rich` instead
  of `Row`. Better default
  behaviour and allows `TextOverflow`.
- [[1346]](https://github.com/GetStream/stream-chat-flutter/issues/1346) Fixed a render issue while
  uploading video on
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
- Added `showStreamAttachmentPickerModalBottomSheet` to show the attachment picker modal bottom
  sheet.

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
