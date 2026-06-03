## Upcoming

🛑️ Breaking

- Renamed `attachmentsUploadProgressText` parameter `remaining` → `completed`
  and reworded the translation across all locales to report completed count
  instead of remaining.
- Renamed English `threadReplyLabel` (`'Thread'` → `'Thread Reply'`) and
  `markAsUnreadLabel` (`'Mark as Unread'` → `'Mark Unread'`).
- Reworded Korean `threadReplyLabel` (`'스레드 응답입니다'` → `'스레드 답변'`)
  to drop the declarative copula so it reads as a menu label.
- Renamed `questionsLabel` getter → `questionLabel({bool isPlural = false})`
  method across all supported locales.
- Renamed `endVoteConfirmationText` → `endVoteConfirmationTitle` across all
  supported locales; English default changed to `'End This Poll?'`.
- Renamed `slowModeOnLabel` getter → `slowModeOnLabel(int cooldownTimeOut)`
  method across all supported locales. The default now renders a live
  countdown (English default: `'Slow mode ON'` → `'Slow mode, wait
  ${cooldownTimeOut}s\u2026'`).

✅ Added

- Added `fileTypeNotSupportedError(String? extension)` translation for all
  supported locales. Used by the message composer when an attachment's
  extension or MIME type is rejected.
- Added `toggleBlockUnblockUserText` translation for all supported locales.
- Added `threadLabel` translation for all supported locales, used by the
  `StreamThreadHeader` default title.
- Added `commandUsernameLabel` translation (default `@username`) for all supported
  locales. Used by the message composer placeholder when user-target commands
  (`/mute`, `/unmute`, `/ban`, `/unban`) are active.
- Added `unsupportedAttachmentLabel` translation for all supported locales.
- Added `linkAttachmentText` translation for all supported locales (used by
  `MessagePreviewFormatter` for link-preview attachments).
- Added `confirmLabel`, `emptyReactionsText`, `loadingReactionsError`, and
  `tapToRemoveReactionLabel` translations for all supported locales.
- Added `justNowLabel`, `replyToUserLabel`, `multipleAnswersDescription`,
  `maximumVotesPerPersonDescription`, `anonymousPollDescription`,
  `suggestAnOptionDescription`, and `addACommentDescription` translations for
  all supported locales.
- Added `totalVoteCountLabel({int? count})` translation for all supported
  locales.
- Added `viewAllLabel` translation for all supported locales.
- Added `pollVotesLabel` translation for all supported locales.
- Added `endVoteConfirmationMessage` translation for all supported locales.
- Added `reactionsCountText(int count)` translation for all supported locales.
- Added `photosAndVideosLabel` translation (default `Photos & Videos`) for all
  supported locales. Used by the new media gallery preview footer's thumbnail-
  grid sheet header.

🔄 Changed

- Reworded `emptyMessagesText` across all locales to the shorter "No messages
  yet" style (English default: `'There are no messages currently'` →
  `'No messages yet'`) to match the redesigned empty state copy.
- Reworded `writeAMessageLabel` across all locales to use a "Send a message"
  style (English default: `'Write a message'` → `'Send a message'`) to match
  the redesigned message composer placeholder.
- Reworded `endVoteLabel` English override from `'End Vote'` to `'End Poll'`.
- Reworded `flagLabel`, `cancelLabel` and `deleteLabel` defaults from uppercase to sentence case across all supported locales (e.g. English: `'FLAG'` → `'Flag'`, `'CANCEL'` → `'Cancel'`, `'DELETE'` → `'Delete'`) so dialog buttons render in the same case as the rest of the system.

## 9.24.0

- Updated `stream_chat_flutter` dependency to [`9.24.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 10.0.0-beta.13

🛑️ Breaking
- SDK Redesign Changes. For more details, please refer to the [migration guide](https://github.com/GetStream/stream-chat-flutter/blob/210ff93f955be3f85c62e860309bd9aa240a5446/migrations).
  The SDK redesign introduces a fresher default UI, but also better APIs for customization of the components.

## 10.0.0-beta.12

- Included the changes from version [`9.23.0`](https://pub.dev/packages/stream_chat_localizations/changelog).

## 9.23.0

- Fixed Italian translation for `unreadMessagesSeparatorText` (was incorrectly showing French text "Nouveaux messages" instead of Italian "Nuovi messaggi").

## 10.0.0-beta.11

- Included the changes from version [`9.22.0`](https://pub.dev/packages/stream_chat_localizations/changelog).

## 9.22.0

- Added translations for new `deletePollOptionLabel` label.
- Added translations for new `deletePollOptionQuestion` text.

## 10.0.0-beta.10

- Included the changes from version [`9.21.0`](https://pub.dev/packages/stream_chat_localizations/changelog).

## 9.21.0

- Updated `stream_chat_flutter` dependency to [`9.21.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 10.0.0-beta.9

- Included the changes from version [`9.20.0`](https://pub.dev/packages/stream_chat_localizations/changelog).

## 9.20.0

- Updated `stream_chat_flutter` dependency to [`9.20.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 10.0.0-beta.8

- Included the changes from version [`9.19.0`](https://pub.dev/packages/stream_chat_localizations/changelog).

## 9.19.0

- Updated `stream_chat_flutter` dependency to [`9.19.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 10.0.0-beta.7

- Included the changes from version [`9.18.0`](https://pub.dev/packages/stream_chat_localizations/changelog).

## 9.18.0

- Updated `stream_chat_flutter` dependency to [`9.18.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 10.0.0-beta.6

- Included the changes from version [`9.17.0`](https://pub.dev/packages/stream_chat_localizations/changelog).

## 9.17.0

- Updated `stream_chat_flutter` dependency to [`9.17.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 10.0.0-beta.5

- Included the changes from version [`9.16.0`](https://pub.dev/packages/stream_chat_localizations/changelog).

## 9.16.0

- Updated `stream_chat_flutter` dependency to [`9.16.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 10.0.0-beta.4

- Added translations for new `locationLabel` label.

- Included the changes from version [`9.15.0`](https://pub.dev/packages/stream_chat_localizations/changelog).

## 9.15.0

- Updated `stream_chat_flutter` dependency to [`9.15.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 10.0.0-beta.3

- Included the changes from version [`9.14.0`](https://pub.dev/packages/stream_chat_localizations/changelog).

## 9.14.0

- Updated `stream_chat_flutter` dependency to [`9.14.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 10.0.0-beta.2

- Included the changes from version [`9.13.0`](https://pub.dev/packages/stream_chat_localizations/changelog).

## 9.13.0

- Updated `stream_chat_flutter` dependency to [`9.13.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 10.0.0-beta.1

- Updated `stream_chat_flutter` dependency to [`10.0.0-beta.1`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 9.12.0

- Updated `stream_chat_flutter` dependency to [`9.12.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 9.11.0

- Updated `stream_chat_flutter` dependency to [`9.11.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 9.10.0

- Updated `stream_chat_flutter` dependency to [`9.10.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 9.9.0

- Added translations for new `draftLabel` label.
- Added translations for new `endLabel` label.
- Added translations for new `endVoteConfirmationText` text.

## 9.8.0

- Updated `stream_chat_flutter` dependency to [`9.8.0`](https://pub.dev/packages/stream_chat/changelog).

## 9.7.0

- Added translations for new `sendAnywayLabel` label.
- Added translations for new `moderatedMessageBlockedText` text.
- Added translations for new `moderationReviewModalTitle` text.
- Added translations for new `moderationReviewModalDescription` text.
- Added translations for new `emptyMessagePreviewText` text.
- Added translations for new `voiceRecordingText` text.
- Added translations for new `audioAttachmentText` text.
- Added translations for new `imageAttachmentText` text.
- Added translations for new `videoAttachmentText` text.
- Added translations for new `pollYouVotedText` text.
- Added translations for new `pollSomeoneVotedText` text.
- Added translations for new `pollYouCreatedText` text.
- Added translations for new `pollSomeoneCreatedText` text.
- Added translations for new `systemMessageLabel` label.

## 9.6.0

- Updated `stream_chat_flutter` dependency to [`9.6.0`](https://pub.dev/packages/stream_chat/changelog).

## 9.5.0

- Updated `stream_chat_flutter` dependency to [`9.5.0`](https://pub.dev/packages/stream_chat/changelog).

## 9.4.0

- Updated minimum Flutter version to 3.27.4 for the SDK.

## 9.3.0

- Added translations for new `slideToCancelLabel` label.
- Added translations for new `holdToRecordLabel` label.

## 9.2.0

- Updated `stream_chat_flutter` dependency to [`9.2.0+1`](https://pub.dev/packages/stream_chat/changelog).

## 9.1.0

- Added translations for new `repliedToLabel` label.
- Added translations for new `newThreadsLabel` label.

## 9.0.0

- Added multiple new localization strings related to poll creation and validation.
- Added multiple new localization strings related to poll message interactions.
- Updated minimum Flutter version to 3.24.5 for the SDK.

## 8.3.0

- Updated `stream_chat_flutter` dependency to [`8.3.0`](https://pub.dev/packages/stream_chat/changelog).

## 8.2.0

- Updated `stream_chat_flutter` dependency to [`8.2.0`](https://pub.dev/packages/stream_chat/changelog).

## 8.1.0

- Updated `stream_chat_flutter` dependency to [`8.1.0`](https://pub.dev/packages/stream_chat/changelog).

## 8.0.0

- Updated `stream_chat_flutter` dependency to [`8.0.0`](https://pub.dev/packages/stream_chat/changelog).

## 7.3.0

🔄 Changed

- Changed minimum Flutter version to 3.19 for the SDK.
- Updated `stream_chat_flutter` dependency to [`7.3.0`](https://pub.dev/packages/stream_chat/changelog).

## 7.2.2

- Updated `stream_chat_flutter` dependency to [`7.2.2`](https://pub.dev/packages/stream_chat/changelog).

## 7.2.1

- Updated `stream_chat_flutter` dependency to [`7.2.1`](https://pub.dev/packages/stream_chat/changelog).
  
## 7.2.0-hotfix.1

- Updated `stream_chat_flutter` dependency to [`7.2.0-hotfix.1`](https://pub.dev/packages/stream_chat/changelog).

# 7.2.0

* Updated `stream_chat_flutter` dependency to [`7.2.0`](https://pub.dev/packages/stream_chat_flutter/changelog).
  
## 7.1.0

* Updated `stream_chat_flutter` dependency to [`7.1.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 7.0.2

* Updated `stream_chat_flutter` dependency to [`7.0.2`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 7.0.1

* Updated `stream_chat_flutter` dependency to [`7.0.1`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 7.0.0

* Updated minimum supported `SDK` version to Flutter 3.13/Dart 3.1
* Updated `stream_chat_flutter` dependency to [`7.0.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 5.12.0

* Updated `stream_chat_flutter` dependency to [`6.12.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 5.11.0

* Updated `stream_chat_flutter` dependency to [`6.11.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 5.10.0

* Updated `stream_chat_flutter` dependency to [`6.10.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 5.9.0

* Updated minimum supported `SDK` version to Flutter 3.10/Dart 3.0
* Updated `stream_chat_flutter` dependency to [`6.9.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 5.8.0

* Updated `stream_chat_flutter` dependency to [`6.8.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 5.7.0

* Updated `stream_chat_flutter` dependency to [`6.7.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 5.6.0

* Updated minimum supported `SDK` version to Flutter 3.7/Dart 2.19
* Updated `stream_chat_flutter` dependency to [`6.6.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 5.5.0

* Updated `stream_chat_flutter` dependency to [`6.5.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 5.4.0

* Updated `stream_chat_flutter` dependency to [`6.4.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 5.3.0

* Updated `stream_chat_flutter` dependency to [`6.3.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 5.2.0

* Updated `stream_chat_flutter` dependency to [`6.2.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 5.1.0

* Updated `dart` sdk environment range to support `3.0.0`.
* Updated `stream_chat_flutter` dependency to [`6.1.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 5.0.0

* Updated `stream_chat_flutter` dependency to [`6.0.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 4.1.0

✅ Added

* Added support
  for [Catalan](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_ca.dart)
  locale.
* Added translations for new `noPhotoOrVideoLabel` label.
* Changed text in New messages separator. Now is doesn't count the new messages and only shows "New messages". All the
  translations were updated.

🔄 Changed

* Some of the `Spanish` translations have been updated/changed for better understanding.
* Some of the `Catalan` translations have been updated/changed for better understanding.

## 4.0.0

🔄 Changed

* Removed `emojiMatchingQueryText` string.

## 4.0.0-beta.2

* Included the changes from version [3.3.0](#330).

## 4.0.0-beta.1

✅ Added

* `couldNotReadBytesFromFileError` with translations
* `downloadLabel` with translations
* `toggleMuteUnmuteAction` with translations
* `toggleMuteUnmuteGroupQuestion` with translations
* `toggleMuteUnmuteGroupText` with translations
* `toggleMuteUnmuteUserQuestion` with translations
* `toggleMuteUnmuteUserText` with translations

## 3.3.0

* Added support
  for [Norwegian](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_no.dart)
  locale.

## 3.2.0

✅ Added

* Added support for `unreadMessagesSeparatorText` translation.

## 3.1.0

* Added support
  for [German](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_de.dart)
  locale.

## 3.0.0

* Added translations for viewLibrary.

## 3.0.0-beta.1

* Updated `stream_chat_flutter` dependency to [`4.0.0-beta.1`](https://pub.dev/packages/stream_chat_flutter/changelog).

## 2.1.0

✅ Added

* Added support
  for [Portuguese](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_pt.dart)
  locale.

🔄 Changed

* Some of the `Japanese` translations have been updated/changed for better understanding.

## 2.0.0

* Updated `stream_chat_flutter` dependency to [`3.0.0`](https://pub.dev/packages/stream_chat_flutter/changelog).

🐞 Fixed

* Fixed typos in `Italian` translations.

## 1.1.0

✅ Added

* Added support
  for [Spanish](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_es.dart)
  locale.
* Added support
  for [Korean](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_ko.dart)
  locale.
* Added support
  for [Japanese](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_ja.dart)
  locale.
* Added translations for cooldown mode.
* Added translations for attachmentLimitExceed.

🔄 Changed

* Some of the `Hindi` translations have been updated/changed for better understanding.
    - 'रिप्लाई' -> 'जवाब दें'
    - 'तस्वीरें' -> 'फ़ोटोज'
    - 'बिता हुआ कल' -> 'कल'
    - 'चैनल मौन है' -> 'चैनल म्यूट है'

## 1.0.2

* Updated `stream_chat_flutter` dependency

## 1.0.1

* Minor Fixes

## 1.0.0

* Initial Release with support for 4 locales
    - [English](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_en.dart)
    - [Hindi](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_hi.dart)
    - [Italian](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_it.dart)
    - [French](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_fr.dart)
