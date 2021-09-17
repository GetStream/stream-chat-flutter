## Upcoming

⚠️ Deprecated

- `MessageSearchListViewCore` `paginationParams` property is now deprecated in favor of `limit`.
    ```dart
    // previous
    paginationParams = const PaginationParams(limit: 30)
    
    // new
    limit = 30
    ```
- `UserListViewCore` `pagination` property is now deprecated in favor of `limit`.
    ```dart
    // previous
    pagination = const PaginationParams(limit: 30)
    
    // new
    limit = 30
    ```
- `ChannelListViewCore` `pagination` property is now deprecated in favor of `limit`.
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
