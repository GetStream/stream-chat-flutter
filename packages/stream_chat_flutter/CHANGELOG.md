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

- Added `shouldAddChannel` to ChannelsBloc in order to check if a channel has to be added to the list when a new message arrives

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

- Removed the additional `Navigator` in `StreamChat` widget.
    It was added to make the app have the `StreamChat` widget as ancestor in every route.
    Now the recommended way to add `StreamChat` to your app is using the `builder` property of your `MaterialApp` widget.
    Otherwise you can use it in the usual way, but you need to add a `StreamChat` widget to every route of your app.
    Read [this issue](https://github.com/GetStream/stream-chat-flutter/issues/47) for more information.

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

- Add keyboard type parameters (set it to TextInputType.text to show the submit button that will even close the keyboard)

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