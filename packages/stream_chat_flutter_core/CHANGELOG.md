## 4.0.0-beta.0

✅ Added

- Added `MessageInputController` to hold `Message` related data.
- Deprecated old widgets in favor of Stream-prefixed ones.
- Deprecated `ChannelsBloc` in favor of `StreamChannelListController` to control the channel list.
- Added `MessageTextFieldController` to be used with the new `StreamTextField` ui widget.

- Updated `stream_chat` dependency to [`4.0.0-beta.0`](https://pub.dev/packages/stream_chat/changelog).

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
- [[#848]](https://github.com/GetStream/stream-chat-flutter/issues/848) Fixed "Bad state: Cannot add new events after calling close" by replacing all `.add` methods with a new `.safeAdd`.

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
- [[#673]](https://github.com/GetStream/stream-chat-flutter/issues/673): Fix `Core Widgets` not getting rebuild with new
  data on configuration change.

## 2.2.1

- Updated `stream_chat` dependency to 2.2.1

## 2.2.0

🛑️ Breaking Changes from `2.1.1`

- Renamed `BetterStreamBuilder.loadingBuilder` to `.noDataBuilder`

🔄 Changed

- `BetterStreamBuilder.initialData` is now nullable/not-required.

🐞 Fixed

- [#612](https://github.com/GetStream/stream-chat-flutter/issues/612) `ChannelListView` pagination doesn't work after
  refresh

## 2.1.1

- Updated llc dependency

## 2.1.0

🛑️ Breaking Changes from `2.0.0`

- Changed default message filter of `MessageListCore`

✅ Added

- Added `MessageListCore.paginationLimit`

🔄 Changed

- `StreamChatCore.of(context).user` is now deprecated in favor of `StreamChatCore.of(context).currentUser`.
- `StreamChatCore.of(context).userStream` is now deprecated in favor of `StreamChatCore.of(context).currentUserStream`.

## 2.0.0

🛑️ Breaking Changes from `1.5.3`

- migrate this package to null safety
- `channelsBloc.queryChannels()`, `ChannelListCore` options param/property is removed in favor of individual
  params/properties
    - `options.state` -> bool state
    - `options.watch` -> bool watch
    - `options.presence` -> bool presence
- `usersBloc.queryUsers()`, `UserListCore` options param/property is removed in favor of individual params/properties
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

- `channelsBloc.queryChannels()`, `ChannelListCore` options param/property is removed in favor of individual
  params/properties
    - `options.state` -> bool state
    - `options.watch` -> bool watch
    - `options.presence` -> bool presence
- `usersBloc.queryUsers()`, `UserListCore` options param/property is removed in favor of individual params/properties
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
