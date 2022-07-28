## 5.0.0-beta.2

 - **REFACTOR**: Deprecate `.user`, `.userStream` in favor of `.currentUser`, `.currentUserStream`.
 - **REFACTOR**: remove deprecated code and cleanup.
 - **REFACTOR**: Deprecate v3.
 - **REFACTOR**: improve message input controller.
 - **FIX**: analysis issues.
 - **FIX**: fix message pagination parameters.
 - **FIX**: fix channel list pagination spinner (#375).
 - **FIX**: fix lazy load scroll view.
 - **FIX**: Replaced all `StreamController.add()` with `.safeAdd()` to fix bad state errors.
 - **FIX**: do not move a channel when the new message is a thread reply.
 - **FIX**: allow scroll notification bubbling in lazy load scroll view.
 - **FIX**: dispose channel on deletion.
 - **FIX**: fix tests.
 - **FIX**: default message filter.
 - **FIX**: fix analysis.
 - **FIX**: tests.
 - **FIX**: dry run stuff.
 - **FIX**: analysis and text.
 - **FIX**: Added CHANGELOG.md and pubspec.yaml changes.
 - **FIX**: fix loading to unread position.
 - **FIX**: `ChannelListView` pagination on refresh.
 - **FIX**: message search pagination.
 - **FIX**: match oldWidget objects using jsonEncode.
 - **FIX**: fix analysis.
 - **FIX**: minor.
 - **FIX**: Fix attachment upload state uneven progress. (#315).
 - **FEAT**: add dart_code_metrics.
 - **FEAT**: improve add support for `mentionAllAppUsers` in `UserMentionsOverlay`.
 - **FEAT**: send used package in the headers.
 - **FEAT**: Added first widgets.
 - **FEAT**: deprecate `pagination` in favor of `limit`.
 - **FEAT**: Add default empty filter in `UserListView`.
 - **FEAT**: Added a queryAround implementation.
 - **FEAT**: Improve pagination invocation by using paginationEnded flag.
 - **FEAT**: Added a queryAround implementation.
 - **FEAT**: add StreamAutocomplete (#1263).
 - **FEAT**: Added new widgets.
 - **FEAT**: add name get, set and update on Channel.
 - **FEAT**: Extracted visible_footnote.dart, corrected default filter.
 - **FEAT**: Added a queryAround implementation.
 - **FEAT**: Added new ui package.
 - **FEAT**: Apply team lints to core package (#334).
 - **FEAT**: added customization options in main widgets (#312).
 - **FEAT**: handle ogAttachment modification via message_input_controller.dart.
 - **FEAT**: minor fixes and improvements.
 - **FEAT**: Add support for messages filter in `MessageListView` and `MessageListCore` (#303).
 - **FEAT**: improve the message for skipping the event.
 - **FEAT**: add remaining v4 list-views.
 - **FEAT**: Added better README.md for both packages, added LICENSE.
 - **FEAT**: added PagedValueGridView, added additional params in ListViews.
 - **FEAT**: add grid views, minor refactoring.
 - **FEAT**: Added a queryAround implementation.
 - **FEAT**: Converted message_list_view.dart.
 - **FEAT**: Added fixes and user_list_view.dart.
 - **FEAT**: Added channel_list new implementation, fixed upper repo.
 - **FEAT**: Added load data to controllers.
 - **FEAT**: Created example app.
 - **FEAT**: Added exports.
 - **FEAT**: Removed theme and added new widgets.
 - **FEAT**: only handle the latest events in channelEventSubscription.
 - **DOCS**: change paginationParams to limit.
 - **DOCS**: fix example folder link.

## Upcoming 

- Included the changes from version [4.4.0](#440) and [4.4.1](#441).

## 5.0.0-beta.1

- Updated `stream_chat` dependency to [`5.0.0-beta.1`](https://pub.dev/packages/stream_chat/changelog).
- Removed deprecated code.

## 4.4.1

- Updated `stream_chat` dependency to [`4.4.1`](https://pub.dev/packages/stream_chat/changelog).

## 4.4.0

- Updated `stream_chat` dependency to [`4.4.0`](https://pub.dev/packages/stream_chat/changelog).

## 4.3.0

- Updated `stream_chat` dependency to [`4.3.0`](https://pub.dev/packages/stream_chat/changelog).

## 4.2.0

- Updated `stream_chat` dependency to [`4.2.0`](https://pub.dev/packages/stream_chat/changelog).

🔄 Changed

- Deprecated `before` and `after` parameters in `StreamChannel.queryAroundMessage`. Use `limit` instead.
- Deprecated `before` and `after` parameters in `StreamChannel.loadChannelAtMessage`. Use `limit` instead.

## 4.1.0

- Updated `stream_chat` dependency to [`4.1.0`](https://pub.dev/packages/stream_chat/changelog).

## 4.0.1

- Minor fixes
- Updated `stream_chat` dependency to [`4.0.1`](https://pub.dev/packages/stream_chat/changelog).

## 4.0.0

For upgrading to V4, please refer to the [V4 Migration Guide](https://getstream.io/chat/docs/sdk/flutter/guides/migration_guide_4_0/)

- Deprecated `UsersBloc` in favor of `StreamUserListController` to control the user list.
- Deprecated `MessageSearchBloc` in favor of `StreamMessageSearchListController` to control the user list.

## 4.0.0-beta.2

- Updated `stream_chat` dependency to [`4.0.0-beta.2`](https://pub.dev/packages/stream_chat/changelog).

## 4.0.0-beta.0

✅ Added

- Added `MessageInputController` to hold `Message` related data.
- Deprecated old widgets in favor of Stream-prefixed ones.
- Deprecated `ChannelsBloc` in favor of `StreamChannelListController` to control the channel list.
- Added `MessageTextFieldController` to be used with the new `StreamTextField` ui widget.

- Updated `stream_chat` dependency to [`4.0.0-beta.0`](https://pub.dev/packages/stream_chat/changelog).

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
