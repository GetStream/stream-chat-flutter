## 6.9.0

- Updated `stream_chat` dependency to [`6.9.0`](https://pub.dev/packages/stream_chat/changelog).

## 6.8.0

- Updated minimum supported `SDK` version to Flutter 3.10/Dart 3.0
- Updated `stream_chat` dependency to [`6.8.0`](https://pub.dev/packages/stream_chat/changelog).

## 6.7.0

- [[#1683]](https://github.com/GetStream/stream-chat-flutter/issues/1683) Fixed SqliteException no such
  column `messages.state`.

## 6.6.0

- Updated `stream_chat` dependency to [`6.6.0`](https://pub.dev/packages/stream_chat/changelog).

## 6.5.0

- Updated minimum supported `SDK` version to Flutter 3.7/Dart 2.19

## 6.4.0

- Updated `stream_chat` dependency to [`6.4.0`](https://pub.dev/packages/stream_chat/changelog).

## 6.3.0

- Updated `stream_chat` dependency to [`6.3.0`](https://pub.dev/packages/stream_chat/changelog).

## 6.2.0

- Added support for `StreamChatPersistenceClient.isConnected` for checking if the client is connected to the database.
- [[#1422]](https://github.com/GetStream/stream-chat-flutter/issues/1422) Removed default values
  from `UserEntity` `createdAt` and `updatedAt` fields.
- Updated `stream_chat` dependency to [`6.2.0`](https://pub.dev/packages/stream_chat/changelog).
- Added support for `StreamChatPersistenceClient.openPersistenceConnection`
  and `StreamChatPersistenceClient.closePersistenceConnection` for opening and closing the database connection.

## 6.1.0

- Updated `dart` sdk environment range to support `3.0.0`.
- Updated `stream_chat` dependency to [`6.1.0`](https://pub.dev/packages/stream_chat/changelog).

## 6.0.0

- Updated `drift` to `^2.7.0`.
- Updated dependencies to resolvable versions.

## 5.1.0

- Reintroduce support for experimental indexedDB on Web.
- Deprecated the `sort` parameter in the getChannelStates method in favor of `channelStateSort`.
- Use the comparator function to sort the channel states and not the channel models.

🐞 Fixed

- Fix offline message pagination.

## 5.0.0

- Included the changes from version [4.3.0](#430) and [4.4.0](#440).

## 5.0.0-beta.1

- Updated `stream_chat` dependency to [`5.0.0-beta.1`](https://pub.dev/packages/stream_chat/changelog).

## 4.4.0

- Allowed experimental use of indexedDb on web with `webUseExperimentalIndexedDb` parameter
  on `StreamChatPersistenceClient`.
  Thanks [geweald](https://github.com/geweald).

## 4.3.0

- Updated `stream_chat` dependency to [`4.4.0`](https://pub.dev/packages/stream_chat/changelog).

## 4.2.0

- Added support for `Channel.ownCapabilities`

## 4.1.0

🔄 Changed

- Deprecated `role` field in `Member` table in favor of `channelRole`

## 4.0.1

- Updated `stream_chat` dependency to [`4.0.1`](https://pub.dev/packages/stream_chat/changelog).

## 4.0.0

- Updated `stream_chat` dependency to [`4.0.0`](https://pub.dev/packages/stream_chat/changelog).

## 4.0.0-beta.0

- Updated `stream_chat` dependency to [`4.0.0-beta.0`](https://pub.dev/packages/stream_chat/changelog).

## 3.1.0

- Bump `drift` to `1.3.0`.

## 3.0.0

- Updated `stream_chat` dependency to [`3.0.0`](https://pub.dev/packages/stream_chat/changelog).
- [[#604]](https://github.com/GetStream/stream-chat-flutter/issues/604) Fix cascade deletion by
  enabling `pragma foreign_keys`.
- Added a new table `PinnedMessageReactions` and dao `PinnedMessageReactionDao` specifically for pinned messages.

## 2.2.0

- Updated llc dependency
- Added support for message.i18n
- Added support for user.language

## 2.1.1

- Updated llc dependency

## 2.1.0

✅ Added

- Added support for `Message.i18n`
- Added support for `User.language`

## 2.0.0

* Migrate this package to null safety
* Minor fixes and improvements

## 2.0.0-nullsafety.8

* Updated llc dependency
* Upgraded moor dependencies and generated files with the latest dependency

## 2.0.0-nullsafety.7

* Update llc dependency
* Minor fixes and improvements

## 2.0.0-nullsafety.5

* Update llc dependency
* Minor fixes and improvements

## 2.0.0-nullsafety.2

* Update llc dependency
* Minor fixes and improvements
* Fixed bug not saving message.mentioned_users

## 2.0.0-nullsafety.1

* Migrate this package to null safety
* Update llc dependency

## 1.5.2

* Fix sorting by last_updated

## 1.5.1

* Improved test coverage to > 95%
* Minor fixes and improvements

## 1.5.0

* Update llc dependency
* Wait for all operations to finish before disconnecting

## 1.4.0-beta

* Update llc dependency

## 1.3.0-beta

* Update llc dependency

## 1.2.0-beta

* Update llc dependency

## 1.1.0-beta

* Update llc dependency

## 1.0.2-beta

* Update llc dependency

## 1.0.1-beta

* Update llc dependency

## 1.0.0-beta

* Initial release