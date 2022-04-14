## 4.0.0-beta.2

✅ Added

- Added support to pass `autoCorrect` to `StreamMessageInput` for the text input field
- Added support to control the visibility of the default emoji suggestions overlay
- Added support to build custom widget for scrollToBottom in `StreamMessageListView`

🐞 Fixed

- Minor fixes and improvements
-[[#892]](https://github.com/GetStream/stream-chat-flutter/issues/892): Fix default `initialAlignment` in `MessageListView`.
- Fix `MessageInputTheme.inputBackgroundColor` color not being used in some widgets of `MessageInput`
- Removed dependency on `visibility_detector`
- [[#1071]](https://github.com/GetStream/stream-chat-flutter/issues/1071): Fixed the way attachment actions were handled in full screen

## 4.0.0-beta.1

✅ Added

- Deprecated old widgets in favor of Stream-prefixed ones.
- Use channel capabilities to show/hide actions.
- Deprecated `ChannelListView` in favor of `StreamChannelListView`.
- Deprecated `ChannelPreview` in favor of `StreamChannelListTile`.
- Deprecated `ChannelAvatar` in favor of `StreamChannelAvatar`.
- Deprecated `ChannelName` in favor of `StreamChannelName`.
- Deprecated `MessageInput` in favor of `StreamMessageInput`.
- Separated `MessageInput` widget in smaller components. (For example `CountDownButton`, `StreamAttachmentPicker`...)
- Updated `stream_chat_flutter_core` dependency to [`4.0.0-beta.0`](https://pub.dev/packages/stream_chat_flutter_core/changelog).
- Added OpenGraph preview support for links in `StreamMessageInput`.
- Removed video compression.

## 3.6.1

- Updated `stream_chat_flutter_core` dependency to [`3.6.1`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

## 3.6.0

🐞 Fixed

- Minor fixes and improvements
-[[#892]](https://github.com/GetStream/stream-chat-flutter/issues/892): Fix default `initialAlignment` in `MessageListView`.
- Fix `MessageInputTheme.inputBackgroundColor` color not being used in some widgets of `MessageInput`
- Removed dependency on `visibility_detector`

## 3.5.1

🛑️ Breaking Changes

- `pinPermissions` is no longer needed in `MessageListView`.
- `MessageInput` now works with a `MessageInputController` instead of a `TextEditingController`

🐞 Fixed

- Mentions overlay now doesn't overflow when there is not enough height available
- Updated `stream_chat_flutter_core` dependency to [`3.5.1`](https://pub.dev/packages/stream_chat_flutter_core/changelog).


✅ Added

- `onLinkTap` for `MessageWidget` can now be passed down to `UrlAttachment`.


## 3.5.0

🐞 Fixed

- [[#888]](https://github.com/GetStream/stream-chat-flutter/issues/888) Fix `unban` command not working in `MessageInput`.
- [[#805]](https://github.com/GetStream/stream-chat-flutter/issues/805) Updated chewie dependency version to 1.3.0
- Fix `showScrollToBottom` in `MessageListView` not respecting false value.
- Fix default `Channel` route not opening from `ChannelListView` when `ChannelAvatar` is tapped

## 3.4.0

- Updated `stream_chat_flutter_core` dependency to [`3.4.0`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

🐞 Fixed

- SVG rendering fixes.
- Use file extension instead of mimeType for downloading files.
- [[#860]](https://github.com/GetStream/stream-chat-flutter/issues/860) CastError while compressing Videos.

✅ Added

- Videos can now be auto-played in `FullScreenMedia`
- Extra customisation options for `MessageInput`

🔄 Changed

- Add `didUpdateWidget` override in `MessageInput` widget to handle changes to `focusNode`.

## 3.3.2

- Updated `stream_chat_flutter_core` dependency to [`3.3.1`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

## 3.3.1

✅ Added

- `MessageListView` now allows more better control over spacing after messages using `spacingWidgetBuilder`.
- `StreamChannel` can now fetch messages around a message ID with the `queryAroundMessage` call.
- Added `MessageListView.keyboardDismissBehavior` property.

🐞 Fixed

- [[#766]](https://github.com/GetStream/stream-chat-flutter/issues/766) `AttachmentActionsModal` now has customisation options for actions.
- Fixed `MessageWidget` null errors associated with `channel.memberCount`.
- Fixed adding attachments on web.
- [[#767]](https://github.com/GetStream/stream-chat-flutter/issues/767): Fix `MessageInput` focus behaviour when sending messages.
- Fixed user presence indicator not updating correctly.
- Do not use `withData: true` in `FilePicker` calls.
- Fixed read indicator not updating correctly in specific situations.

## 3.2.0

- Updated Dart SDK constraints to `>=2.14.0 <3.0.0`.
- Updated `stream_chat_flutter_core` dependency to [`3.2.0`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

🐞 Fixed

- Fixed message highlight animation alignment in `MessageListView`.
- [[#491]](https://github.com/GetStream/stream-chat-flutter/issues/491): Fix `MediaListView` showing media in wrong order.
- Fixed `MessageListView` initialIndex not working in some cases.
- Improved `MessageListView` rendering in case of reordering.
- Fix image thumbnail generation when using Stream CDN.

✅ Added

- `MessageListViewThemeData` now accepts a `DecorationImage` as a background image for `MessageListView`.

## 3.1.1

- Updated `stream_chat_flutter_core` dependency to [`3.1.1`](https://pub.dev/packages/stream_chat_flutter_core/changelog).
- Updated `file_picker`, `image_gallery_saver`, and `video_thumbnail` to the latest versions.

🐞 Fixed

- [[#687]](https://github.com/GetStream/stream-chat-flutter/issues/687): Fix Users losing their place in the conversation after replying in threads.
- Fixed floating date stream subscription causing "Bad state: stream has already been listened.” error.
- Fixed `String` capitalize extension not working on empty strings.

✅ Added

- Added `MessageInput.customOverlays` property to add custom overlays to the message input.
- Added `MessageInput.mentionAllAppUsers` property to mention all app users in the message input.
- The `MessageInput` now supports local search for channels with less than 100 members.
- Added `MessageListView.paginationLoadingIndicatorBuilder` to override the default loading indicator shown while paginating the message list.
- Added new `linkBackgroundColor` in `MessageTheme` for setting background colors of link attachments.

⚠️ Deprecated

- `MessageInput.mentionsTileBuilder` is now deprecated in favor of `MessageInput.userMentionsTileBuilder`.
- `MentionTile` is now deprecated in favor of `UserMentionsTile`.

## 3.0.0

- Updated `stream_chat_flutter_core` dependency to [`3.0.0`](https://pub.dev/packages/stream_chat_flutter_core/changelog).

🛑️ Breaking Changes from `2.2.1`

- `UserListView` `filter` property now is non-nullable.

🐞 Fixed

- [[#668]](https://github.com/GetStream/stream-chat-flutter/issues/668): Fix `MessageInput` rendering errors in case
  there are no actions available to show.
- [[#349]](https://github.com/GetStream/stream-chat-flutter/issues/349): Fix `MessageInput` attachment render overflow error.
- `MessageInput` overlays now follow the `MessageInput` focus.
- [[#674]](https://github.com/GetStream/stream-chat-flutter/issues/674): Check scrollController is attached before calling jump in MessageListView.
- Fixed `MessageListView` header and footer when `reverse: false`.

🔄 Changed

- Animation curves changed from default `Curves.linear` to `Curves.easeOut` and `Curves.easeIn` for attachment controls.
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
  Added `StreamChatThemeData.placeholderUserImage` for building a widget when the `UserAvatar` image is loading
- Added a `backgroundColor` property to the following widgets:
    - `ChannelHeader`
    - `ChannelListHeader`
    - `GalleryHeader`
    - `GalleryFooter`
    - `ThreadHeader`
- Added `MessageInput.attachmentLimit` in order to limit the no. of attachments that can be sent with a single message.
- Added `MessageInput.onAttachmentLimitExceed` callback which will be called when the `attachmentLimit` is exceeded.
  This will override the default error alert behaviour.
- Added `MessageInput.attachmentButtonBuilder` and `MessageInput.commandButtonBuilder` for more customizations.

```dart
typedef ActionButtonBuilder = Widget Function(
    BuildContext context,
    IconButton defaultActionButton,
    );
```

> **_NOTE:_** The last parameter is the default `ActionButton`
You can call `.copyWith` to customize just a subset of properties.

- Added slow mode which allows a cooldown period after a user sends a message.

🔄 Changed

Theming has been upgraded! Most theme classes now have `InheritedTheme` classes associated with them, and have been
upgraded with some goodies like `lerp` functions. Here's the full naming breakdown:

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

- Fixed `MessageInput` textField case where `input` is not enabled if the file picked from the camera is null.
- Fixed date dividers position/alignment in non reversed `MessageListView`.
- Fixed `MessageListView` not opening to the right initialMessage if `StreamChannel.initialMessageId` is set.
- Fixed null check errors when accessing `message.text` in `MessageWidget` and `MessageListView`; this occurred when
  sending a message with no text.

## 2.1.2

🐞 Fixed

- [#590](https://github.com/GetStream/stream-chat-flutter/issues/590): livestream use case, no members when sending
  message

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
- `StreamChat.of(context).userStream` is now deprecated in favor of `StreamChat.of(context).currentUserStream`.

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
You can call `.copyWith` to customize just a subset of properties


✅ Added

- Added video compress options (frame and quality) to `MessageInput`
- TypingIndicator now has a property called `parentId` to show typing indicator specific to threads
- [#493](https://github.com/GetStream/stream-chat-flutter/pull/493): add support for messageListView header/footer
- `MessageWidget` accepts a `userAvatarBuilder`
- Added pinMessage ui support
- Added `MessageListView.threadSeparatorBuilder` property
- Added `MessageInput.onError` property to allow error handling
- Added `GalleryHeader/GalleryFooter` theme classes

🐞 Fixed

- [#483](https://github.com/GetStream/stream-chat-flutter/issues/483): Keyboard covers input text box when editing
  message
- Modals are shown using the nearest `Navigator` to make using the SDK easier in a nested navigator use case
- [#484](https://github.com/GetStream/stream-chat-flutter/issues/484): messages don't update without a reload
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
You can call `.copyWith` to customize just a subset of properties.

✅ Added

- TypingIndicator now has a property called `parentId` to show typing indicator specific to threads
- [#493](https://github.com/GetStream/stream-chat-flutter/pull/493): add support for messageListView header/footer
- `MessageWidget` accepts a `userAvatarBuilder`

🐞 Fixed

- [#483](https://github.com/GetStream/stream-chat-flutter/issues/483): Keyboard covers input text box when editing
  message
- Modals are shown using the nearest `Navigator` to make using the SDK easier in a nested navigator use case
- [#484](https://github.com/GetStream/stream-chat-flutter/issues/484): messages don't update without a reload
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
- Polished `StreamChatTheme` adding more options and a new `MessageInputTheme` dedicated to `MessageInput`
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
- Improved api documentation
- Updated `stream_chat` dependency to `^1.0.0-beta`
- Extracted sample app into dedicated [repo](https://github.com/GetStream/flutter-samples)
- Reimplemented existing widgets using [stream_chat_flutter_core](https://pub.dev/packages/stream_chat_flutter_core)

## 0.2.21

- Add `loadingBuilder` in `MessageListView`
- Add `messageFilter` property in `MessageListView`

## 0.2.20+4

- Fix channelPreview when the message list is empty

## 0.2.20+3

- Fix reaction picker score indicator

## 0.2.20+2

- Added `shouldAddChannel` to ChannelsBloc in order to check if a channel has to be added to the list when a new message
  arrives

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

- Do not wrap channel preview builder. Users will have to implement they're custom onTap/onLongPress implementation
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

- Removed the additional `Navigator` in `StreamChat` widget. It was added to make the app have the `StreamChat` widget
  as ancestor in every route. Now the recommended way to add `StreamChat` to your app is using the `builder` property of
  your `MaterialApp` widget. Otherwise you can use it in the usual way, but you need to add a `StreamChat` widget to
  every route of your app. Read [this issue](https://github.com/GetStream/stream-chat-flutter/issues/47) for more
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

- Add keyboard type parameters (set it to TextInputType.text to show the submit button that will even close the
  keyboard)

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