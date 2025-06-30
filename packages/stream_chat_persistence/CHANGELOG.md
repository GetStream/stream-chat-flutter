## 10.0.0-beta.1

- Updated `stream_chat` dependency to [`10.0.0-beta.1`](https://pub.dev/packages/stream_chat/changelog).

## 9.13.0

- Updated `stream_chat` dependency to [`9.13.0`](https://pub.dev/packages/stream_chat/changelog).

## 9.12.0

- Updated `stream_chat` dependency to [`9.12.0`](https://pub.dev/packages/stream_chat/changelog).

## 9.11.0

- Added support for `Message.reactionGroups` field.

## 9.10.0

- Fixed an issue in the `getChannelStates` method where `paginationParams.offset` greater than the
  available channel count would cause an exception. The method now properly handles this edge case.

## 9.9.0

- Added support for `User.teamsRole` field.

## 9.8.0

- Added `pinnedAt` and `archivedAt` fields on `Member`.
- Added support for DraftMessages.

## 9.7.0

- Updated `stream_chat` dependency to [`9.7.0`](https://pub.dev/packages/stream_chat/changelog).

## 9.6.0

- Updated `stream_chat` dependency to [`9.6.0`](https://pub.dev/packages/stream_chat/changelog).

## 9.5.0

- Added support for `Message.restrictedVisibility` field.
- Added support for `Member.extraData` field.

## 9.4.0

- Updated minimum Flutter version to 3.27.4 for the SDK.

## 9.3.0

- Updated `stream_chat` dependency to [`9.3.0`](https://pub.dev/packages/stream_chat/changelog).

## 9.2.0

- Updated `stream_chat` dependency to [`9.2.0`](https://pub.dev/packages/stream_chat/changelog).

## 9.1.0

- Updated `stream_chat` dependency to [`9.1.0`](https://pub.dev/packages/stream_chat/changelog).

## 9.0.0

- Added support for `Poll` and `PollVote` entities in the database.
- Updated minimum Flutter version to 3.24.5 for the SDK.

## 8.3.0

- Updated `stream_chat` dependency to [`8.3.0`](https://pub.dev/packages/stream_chat/changelog).

## 8.2.0

- Updated `stream_chat` dependency to [`8.2.0`](https://pub.dev/packages/stream_chat/changelog).

## 8.1.0

- Updated `stream_chat` dependency to [`8.1.0`](https://pub.dev/packages/stream_chat/changelog).

## 8.0.0

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

## 7.2.0

- Updated `stream_chat` dependency to [`7.2.0`](https://pub.dev/packages/stream_chat/changelog).

## 7.1.0

- Updated `stream_chat` dependency to [`7.1.0`](https://pub.dev/packages/stream_chat/changelog).

## 7.0.2

- Updated `stream_chat` dependency to [`7.0.2`](https://pub.dev/packages/stream_chat/changelog).

## 7.0.1

- Updated `stream_chat` dependency to [`7.0.1`](https://pub.dev/packages/stream_chat/changelog).

## 7.0.0

- Updated minimum supported `SDK` version to Flutter 3.13/Dart 3.1
- 🛑 **BREAKING** Removed deprecated `getChannelStates.sort` parameter. Use `getChannelStates.channelStateSort` instead.

## 6.10.0

- Updated `stream_chat` dependency to [`6.10.0`](https://pub.dev/packages/stream_chat/changelog).

## 6.9.0

- Updated `stream_chat` dependency to [`6.9.0`](https://pub.dev/packages/stream_chat/changelog).

## 6.8.0

- Updated minimum supported `SDK` version to Flutter 3.10/Dart 3.0
- Updated `stream_chat` dependency to [`6.8.0`](https://pub.dev/packages/stream_chat/changelog).

## 6.7.0

- [[#1683]](https://github.com/GetStream/stream-chat-flutter/issues/1683) Fixed SqliteException no such column `messages.state`.
- Updated `stream_chat` dependency to [`6.7.0`](https://pub.dev/packages/stream_chat/changelog).

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
- [[#604]](https://github.com/GetStream/stream-chat-flutter/issues/604) Fix cascade deletion by enabling `pragma foreign_keys`.
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