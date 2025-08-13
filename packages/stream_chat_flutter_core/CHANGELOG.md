## 9.16.0

🐞 Fixed

- Fixed `MessageListCore` not properly loading and paginating thread replies.

✅ Added

- Added methods for paginating thread replies in `StreamChannel`.

## 9.15.0

✅ Added

- Added `StreamChatCore.maybeOf()` method for safe context access in async operations.
- Added `StreamChannel.maybeOf()` method for safe context access in async operations.

🐞 Fixed

- Fixed `MessageListCore.dispose()` crash when channel reload fails due to insufficient permissions.
- Fixed incorrect parent message comparison in `MessageListCore.didUpdateWidget()`.
- Ensure `StreamChannel` future builder completes after channel
  initialization. [[#2323]](https://github.com/GetStream/stream-chat-flutter/issues/2323)

## 9.14.0

🐞 Fixed

- Fixed cached messages are cleared from channels with unread messages when accessed
  offline. [[#2083]](https://github.com/GetStream/stream-chat-flutter/issues/2083)

## 9.13.0

🐞 Fixed

- Fixed pagination end detection logic to properly determine when the top or bottom of the message
  list has been reached.

## 9.12.0

✅ Added

- Added `StreamMessageReminderListController` to manage the list of message reminders.

## 9.11.0

- Updated `stream_chat` dependency to [`9.11.0`](https://pub.dev/packages/stream_chat/changelog).

## 9.10.0

🐞 Fixed

- Fixed an issue with `StreamChannel` where loading channel at `lastReadMessageId` might fail
  if the channel exceeds the member threshold. This is now handled gracefully by falling back to loading
  the channel at the `lastRead` date.

🔄 Changed

- Updated `freezed_annotation` dependency to `">=2.4.1 <4.0.0"`.

## 9.9.0

✅ Added

- Added `StreamDraftListController` to manage the list of draft messages.
- Added support for Filtering and Sorting in the `StreamThreadListController`.

## 9.8.0

✅ Added

- Added `StreamChannelState.getFirstUnreadMessage` to get the first unread message in the channel.
- Added support for Channel pinning and archiving.

## 9.7.0

🐞 Fixed

- Fixed issue with not being able to use a non-initialized `Channel` in `StreamChannel`
  widget. [#2080](https://github.com/GetStream/stream-chat-flutter/issues/2080)

🔄 Changed

- Updated `StreamChannel` to provide proper background colors in the `defaultLoadingBuilder` and `defaultErrorBuilder`
- Removed redundant `Material` widget wrapping in the `build` method of `StreamChannelState`

## 9.6.0

🔄 Changed

- Increase range of allowed version `device_info_plus`.

## 9.5.0

🔄 Changed

- Simplified the logic for setting and clearing OG attachments by removing the `_ogAttachment` field
  and directly working with the attachments list.
- Added proper userAgent and systemEnvironment information for better diagnostics and analytics.

🐞 Fixed
- type '_$Loading<int, Channel>' is not a subtype of type 'Success<int, Channel>' in type cast [#1894](https://github.com/GetStream/stream-chat-flutter/issues/1894)

## 9.4.0

- Updated minimum Flutter version to 3.27.4 for the SDK.

## 9.3.0

- Updated `stream_chat` dependency to [`9.3.0`](https://pub.dev/packages/stream_chat/changelog).

## 9.2.0

- Updated `stream_chat` dependency to [`9.2.0`](https://pub.dev/packages/stream_chat/changelog).

## 9.1.0

✅ Added

- Added `StreamThreadListController` to load and paginate list of threads.

## 9.0.0

✅ Added

- Added `StreamPollController` to create and manage a poll based on the passed configs.
- Added `StreamPollVoteListController` to manage the list of votes for a poll.

🔄 Changed

- Updated minimum Flutter version to 3.24.5 for the SDK.

## 8.3.0

- Updated `stream_chat` dependency to [`8.3.0`](https://pub.dev/packages/stream_chat/changelog).

## 8.2.0

- Updated `stream_chat` dependency to [`8.2.0`](https://pub.dev/packages/stream_chat/changelog).

## 8.1.0

🔄 Changed

- Changed minimum Flutter version to 3.22 for the SDK.
- Updated `stream_chat` dependency to [`8.1.0`](https://pub.dev/packages/stream_chat/changelog).

## 8.0.0

🐞 Fixed

- Fixed bug causing background events to be sent in foreground.

🔄 Changed

- Updated `stream_chat` dependency to [`8.0.0`](https://pub.dev/packages/stream_chat/changelog).

## 7.3.0

🔄 Changed

- Changed minimum Flutter version to 3.19 for the SDK.
- Updated `stream_chat` dependency to [`7.3.0`](https://pub.dev/packages/stream_chat/changelog).

## 7.2.2

- Updated `stream_chat` dependency to [`7.2.2`](https://pub.dev/packages/stream_chat/changelog).

## 7.2.1

- Updated `stream_chat` dependency to [`7.2.1`](https://pub.dev/packages/stream_chat/changelog).

## 7.2.0-hotfix.1

- Updated `stream_chat` dependency to [`7.2.0-hotfix.1`](https://pub.dev/packages/stream_chat/changelog).
- Reverted the `connectivity_plus` dependency bump causing [1889](https://github.com/GetStream/stream-chat-flutter/issues/1889)

## 7.2.0

- Updated `stream_chat` dependency to [`7.2.0`](https://pub.dev/packages/stream_chat/changelog).

## 7.1.0

- Updated `stream_chat` dependency to [`7.1.0`](https://pub.dev/packages/stream_chat/changelog).

## 7.0.2

- Updated `stream_chat` dependency to [`7.0.2`](https://pub.dev/packages/stream_chat/changelog).

## 7.0.1

- Updated `stream_chat` dependency to [`7.0.1`](https://pub.dev/packages/stream_chat/changelog).

## 7.0.0

- 🛑 **BREAKING** Removed deprecated `StreamChannelListController.sort` parameter.
  Use `StreamChannelListController.channelStateSort` instead.
- Updated minimum supported `SDK` version to Flutter 3.13/Dart 3.1
- Updated `stream_chat` dependency to [`7.0.0`](https://pub.dev/packages/stream_chat/changelog).

## 6.11.0

🐞 Fixed

- [[#1754]](https://github.com/GetStream/stream-chat-flutter/pull/1754) Fixed video attachment uploading.

## 6.10.0

- Added mixin support to `StreamChannelListEventHandler`.

## 6.9.0

- Added support for `StreamChannel.loadingBuilder` and `StreamChannel.errorBuilder` to customize
  loading and error states.

## 6.8.0

- Updated minimum supported `SDK` version to Flutter 3.10/Dart 3.0
- Updated `stream_chat` dependency to [`6.8.0`](https://pub.dev/packages/stream_chat/changelog).

## 6.7.0

- Updated `stream_chat` dependency to [`6.7.0`](https://pub.dev/packages/stream_chat/changelog).

## 6.6.0

- Updated `stream_chat` dependency to [`6.6.0`](https://pub.dev/packages/stream_chat/changelog).

## 6.5.0

- Updated minimum supported `SDK` version to Flutter 3.7/Dart 2.19
- Updated `stream_chat` dependency to [`6.5.0`](https://pub.dev/packages/stream_chat/changelog).

## 6.4.0

- Updated `stream_chat` dependency to [`6.4.0`](https://pub.dev/packages/stream_chat/changelog).

## 6.3.0

- Updated `stream_chat` dependency to [`6.3.0`](https://pub.dev/packages/stream_chat/changelog).

## 6.2.0

- Fixed `StreamMessageInputController.textPatternStyle` not matching case-insensitive patterns.
- Updated `connectivity_plus` dependency to `^4.0.0`
- Fixed `StreamChannel` shows black screen while loading in some cases.
- Updated `stream_chat` dependency to [`6.2.0`](https://pub.dev/packages/stream_chat/changelog).

## 6.1.0

- Updated `dart` sdk environment range to support `3.0.0`.
- Updated `stream_chat` dependency to [`6.1.0`](https://pub.dev/packages/stream_chat/changelog).
- [[#1356]](https://github.com/GetStream/stream-chat-flutter/issues/1356) Channel doesn't auto
  display again after being
  hidden.
- [[#1540]](https://github.com/GetStream/stream-chat-flutter/issues/1540)
  Use `CircularProgressIndicator.adaptive`
  instead of material indicator.

## 6.0.0

- Updated dependencies to resolvable versions.

## 5.3.0

- Updated `stream_chat` dependency to [`5.3.0`](https://pub.dev/packages/stream_chat/changelog).

## 5.2.0

🔄 Changed

- Updated `connectivity_plus` dependency to `^3.0.2`

## 5.1.0

- Deprecated the `sort` parameter in the `StreamChannelListController` in favor
  of `channelStateSort`.

## 5.0.0

- Included the changes from version [4.5.0](#450).

✅ Added

- Added `StreamMemberListController`.

## 5.0.0-beta.2

- Included the changes from version [4.4.0](#440) and [4.4.1](#441).

## 5.0.0-beta.1

- Updated `stream_chat` dependency
  to [`5.0.0-beta.1`](https://pub.dev/packages/stream_chat/changelog).
- Removed deprecated code.

## 4.6.0

- Updated `stream_chat` dependency to [`4.6.0`](https://pub.dev/packages/stream_chat/changelog).

## 4.5.0

- Updated `stream_chat` dependency to [`4.5.0`](https://pub.dev/packages/stream_chat/changelog).
- [#1269](https://github.com/GetStream/stream-chat-flutter/issues/1269)
  Fix `ChannelListEventHandler` castError at PagedValue.asSuccess.
- [#1241](https://github.com/GetStream/stream-chat-flutter/issues/1241) StreamChannelListView load
  more indicator non stop.

## 4.4.1

- Updated `stream_chat` dependency to [`4.4.1`](https://pub.dev/packages/stream_chat/changelog).

## 4.4.0

- Updated `stream_chat` dependency to [`4.4.0`](https://pub.dev/packages/stream_chat/changelog).

## 4.3.0

- Updated `stream_chat` dependency to [`4.3.0`](https://pub.dev/packages/stream_chat/changelog).

## 4.2.0

- Updated `stream_chat` dependency to [`4.2.0`](https://pub.dev/packages/stream_chat/changelog).

🔄 Changed

- Deprecated `before` and `after` parameters in `StreamChannel.queryAroundMessage`. Use `limit`
  instead.
- Deprecated `before` and `after` parameters in `StreamChannel.loadChannelAtMessage`. Use `limit`
  instead.

## 4.1.0

- Updated `stream_chat` dependency to [`4.1.0`](https://pub.dev/packages/stream_chat/changelog).

## 4.0.1

- Minor fixes
- Updated `stream_chat` dependency to [`4.0.1`](https://pub.dev/packages/stream_chat/changelog).

## 4.0.0

For upgrading to V4, please refer to
the [V4 Migration Guide](https://getstream.io/chat/docs/sdk/flutter/guides/migration_guide_4_0/)

- Deprecated `UsersBloc` in favor of `StreamUserListController` to control the user list.
- Deprecated `MessageSearchBloc` in favor of `StreamMessageSearchListController` to control the user
  list.

## 4.0.0-beta.2

- Updated `stream_chat` dependency
  to [`4.0.0-beta.2`](https://pub.dev/packages/stream_chat/changelog).

## 4.0.0-beta.0

✅ Added

- Added `MessageInputController` to hold `Message` related data.
- Deprecated old widgets in favor of Stream-prefixed ones.
- Deprecated `ChannelsBloc` in favor of `StreamChannelListController` to control the channel list.
- Added `MessageTextFieldController` to be used with the new `StreamTextField` ui widget.

- Updated `stream_chat` dependency
  to [`4.0.0-beta.0`](https://pub.dev/packages/stream_chat/changelog).

## 3.6.1

- Updated `stream_chat` dependency to [`3.6.1`](https://pub.dev/packages/stream_chat/changelog).

## 3.6.0

- Updated `stream_chat` dependency to [`3.6.0`](https://pub.dev/packages/stream_chat/changelog).

## 3.5.1

- Updated `stream_chat` dependency to [`3.5.1`](https://pub.dev/packages/stream_chat/changelog).

## 3.5.0

- Updated `stream_chat` dependency to [`3.5.0`](https://pub.dev/packages/stream_chat/changelog).

## 3.4.0

- Updated `stream_chat` dependency to [`3.4.0`](https://pub.dev/packages/stream_chat/changelog).

🐞 Fixed

- Do not move a channel to top if the new message is from a thread.
- [[#848]](https://github.com/GetStream/stream-chat-flutter/issues/848) Fixed "Bad state: Cannot add
  new events after calling close" by replacing all `.add` methods with a new `.safeAdd`.

## 3.3.1

- Updated `stream_chat` dependency to [`3.3.1`](https://pub.dev/packages/stream_chat/changelog).

## 3.3.0

- Updated `stream_chat` dependency to [`3.3.0`](https://pub.dev/packages/stream_chat/changelog).

## 3.2.0

- Updated `stream_chat` dependency to [`3.2.0`](https://pub.dev/packages/stream_chat/changelog).

## 3.1.1

- Updated `stream_chat` dependency to [`3.1.1`](https://pub.dev/packages/stream_chat/changelog).

## 3.0.0

- Updated `stream_chat` dependency to [`3.0.0`](https://pub.dev/packages/stream_chat/changelog).

🛑️ Breaking Changes from `2.2.1`

- `MessageSearchListViewCore` `paginationParams` property is now deprecated in favor of `limit`.
    ```dart
    // previous
    paginationParams = const PaginationParams(limit: 30)
    
    // new
    limit = 30
    ```
- `UserListCore` `pagination` property is now deprecated in favor of `limit`.
    ```dart
    // previous
    pagination = const PaginationParams(limit: 30)
    
    // new
    limit = 30
    ```
- `ChannelListCore` `pagination` property is now deprecated in favor of `limit`.
    ```dart
    // previous
    pagination = const PaginationParams(limit: 30)
    
    // new
    limit = 30
    ```

- `UserListCore` `filter` property now is non-nullable.

🔄 Changed

- `UserListCore` filter property now has a default value.
    ```dart
    filter = const Filter.empty()
    ```

🐞 Fixed

- Fixed `MessageSearchBloc` pagination.
- [[#673]](https://github.com/GetStream/stream-chat-flutter/issues/673): Fix `Core Widgets` not
  getting rebuild with new data on configuration change.

## 2.2.1

- Updated `stream_chat` dependency to 2.2.1

## 2.2.0

🛑️ Breaking Changes from `2.1.1`

- Renamed `BetterStreamBuilder.loadingBuilder` to `.noDataBuilder`

🔄 Changed

- `BetterStreamBuilder.initialData` is now nullable/not-required.

🐞 Fixed

- [#612](https://github.com/GetStream/stream-chat-flutter/issues/612) `ChannelListView` pagination
  doesn't work after refresh

## 2.1.1

- Updated llc dependency

## 2.1.0

🛑️ Breaking Changes from `2.0.0`

- Changed default message filter of `MessageListCore`

✅ Added

- Added `MessageListCore.paginationLimit`

🔄 Changed

- `StreamChatCore.of(context).user` is now deprecated in favor
  of `StreamChatCore.of(context).currentUser`.
- `StreamChatCore.of(context).userStream` is now deprecated in favor
  of `StreamChatCore.of(context).currentUserStream`.

## 2.0.0

🛑️ Breaking Changes from `1.5.3`

- migrate this package to null safety
- `channelsBloc.queryChannels()`, `ChannelListCore` options param/property is removed in favor of
  individual params/properties
    - `options.state` -> bool state
    - `options.watch` -> bool watch
    - `options.presence` -> bool presence
- `usersBloc.queryUsers()`, `UserListCore` options param/property is removed in favor of individual
  params/properties
    - `options.presence` -> bool presence

✅ Added

- Monitor connection using `connectivity_plus` package

🐞 Fixed

- Minor fixes
- Performance improvements

## 2.0.0-nullsafety.9

- Update llc dependency

## 2.0.0-nullsafety.8

🛑️ Breaking Changes from `2.0.0-nullsafety.7`

- `channelsBloc.queryChannels()`, `ChannelListCore` options param/property is removed in favor of
  individual params/properties
    - `options.state` -> bool state
    - `options.watch` -> bool watch
    - `options.presence` -> bool presence
- `usersBloc.queryUsers()`, `UserListCore` options param/property is removed in favor of individual
  params/properties
    - `options.presence` -> bool presence

## 2.0.0-nullsafety.7

* Fixed a bug with connectivity implementation

## 2.0.0-nullsafety.6

* Update llc dependency
* Minor fixes and improvements

## 2.0.0-nullsafety.5

* Update llc dependency
* Minor fixes and improvements
* Performance improvements
* Monitor connection using `connectivity_plus` package

## 2.0.0-nullsafety.3

* Update llc dependency
* Minor fixes and improvements

## 2.0.0-nullsafety.2

* Fix ChannelsBloc not performing calls if pagination ended

## 2.0.0-nullsafety.1

* Migrate this package to null safety
* Update llc dependency

## 1.5.3

* Fix ChannelsBloc not performing calls if pagination ended

## 1.5.2

* Update llc dependency

## 1.5.1

* Improved test coverage to > 90%
* Minor fixes and improvements

## 1.5.0

* Minor fixes and improvements

## 1.4.0-beta

* Added `MessageListCore.messageFilter` to filter messages locally
* Minor fixes and improvements

## 1.3.2-beta

* Update llc dependency

## 1.3.1-beta

* Update llc dependency

## 1.3.0-beta

* Update llc dependency
* Minor fixes

## 1.2.0-beta

* Update llc dependency
* Minor fixes

## 1.1.0-beta

* Update llc dependency

## 1.0.2-beta

* Update llc dependency

## 1.0.1-beta

* Update llc dependency

## 1.0.0-beta

* First release
