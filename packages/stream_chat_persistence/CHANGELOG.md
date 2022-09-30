## 5.0.0

- Included the changes from version [4.3.0](#430) and [4.4.0](#440).

## 5.0.0-beta.1

- Updated `stream_chat` dependency to [`5.0.0-beta.1`](https://pub.dev/packages/stream_chat/changelog).

## 4.4.0

- Allowed experimental use of indexedDb on web with `webUseExperimentalIndexedDb` parameter on `StreamChatPersistenceClient`.
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