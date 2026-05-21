# Localizations Migration Guide

This guide covers the breaking changes to `Translations` and `StreamChatLocalizations` in the Stream Chat Flutter SDK design refresh.

---

## Table of Contents

- [New Required Abstract Members](#new-required-abstract-members)
- [Renamed Abstract Members](#renamed-abstract-members)
- [Changed Method Signatures](#changed-method-signatures)
- [Changed Default String Values](#changed-default-string-values)
- [Migration Checklist](#migration-checklist)

---

## New Required Abstract Members

If you have a custom `Translations` subclass (used to provide custom localization strings), it **will fail to compile** unless you add implementations for the following new abstract members.

### New getters and methods

Add these to your `Translations` subclass:

```dart
// Channel/message list empty states
@override
String get noConversationsYetText => 'No conversations yet';

@override
String get replyToStartThreadText => 'Reply to a message to start a thread';

@override
String get sendMessageToStartConversationText => 'Send a message to start the conversation';

// Message annotation labels
@override
String get savedForLaterLabel => 'Saved for later';

@override
String get repliedToThreadAnnotationLabel => 'Replied to a thread';

@override
String get alsoSentInChannelAnnotationLabel => 'Also sent in channel';

@override
String get viewLabel => 'View';

// Reminder labels
@override
String get reminderSetLabel => 'Reminder set';

@override
String reminderAtText(String time) => 'Today at $time';

// Channel list attachment previews
@override
String get fileAttachmentText => 'File';

@override
String get linkAttachmentText => 'Link';

@override
String filesAttachmentCountText(int count) => count == 1 ? 'File' : '$count files';

@override
String photosAttachmentCountText(int count) => count == 1 ? 'Photo' : '$count photos';

@override
String videosAttachmentCountText(int count) => count == 1 ? 'Video' : '$count videos';

// Attachment picker labels
@override
String get createPollPromptLabel => 'Create a poll and let everyone vote!';

@override
String get takePhotoAndShareLabel => 'Take a photo and share';

@override
String get takeVideoAndShareLabel => 'Take a video and share';

@override
String get openCameraLabel => 'Open camera';

@override
String get selectFilesToShareLabel => 'Select files to share';

@override
String get openFilesLabel => 'Open files';

// Reactions list / detail sheet
@override
String get emptyReactionsText => 'No reactions yet';

@override
String get loadingReactionsError => 'Error loading reactions';

@override
String get tapToRemoveReactionLabel => 'Tap to remove';

@override
String reactionsCountText(int count) =>
    count == 1 ? '1 Reaction' : '$count Reactions';

// Confirmation dialogs
@override
String get confirmLabel => 'CONFIRM';

// Relative timestamps
@override
String get justNowLabel => 'Just now';

// Composer reply header
@override
String replyToUserLabel(String userName) => 'Reply to $userName';

// Poll creator toggle descriptions
@override
String get multipleAnswersDescription => 'Select more than one option';

@override
String maximumVotesPerPersonDescription([Range<int>? range]) {
  final (:min, :max) = range ?? (min: 2, max: 10);
  return 'Choose between $min\u2013$max options';
}

@override
String get anonymousPollDescription => 'Hide who voted';

@override
String get suggestAnOptionDescription => 'Let others add options';

@override
String get addACommentDescription => 'Allow others to add comments';

// Channel header subtitle for group channels
@override
String membersCountWithOnlineText({
  required int memberCount,
  required int onlineCount,
}) {
  final members = membersCountText(memberCount);
  if (onlineCount <= 0) return members;
  return '$members, ${watchersCountText(onlineCount)}';
}

// Composer placeholder for user-target commands (`/mute`, `/unmute`, `/ban`, `/unban`)
@override
String get commandUsernameLabel => '@username';

// Poll results dialog footer
@override
String totalVoteCountLabel({int? count}) => switch (count) {
  null || < 1 => '0 votes total',
  1 => '1 vote total',
  _ => '$count votes total',
};

// Generic "view all" CTA (used by the poll results dialog footer action)
@override
String get viewAllLabel => 'View all';

// Poll option votes dialog app bar title
@override
String get pollVotesLabel => 'Votes';

// Poll end-vote confirmation dialog body
@override
String get endVoteConfirmationMessage =>
    'Do you want to end this poll now? Nobody will be able to vote in this poll anymore.';
```

> **Note:** The values shown above are the English defaults from `DefaultTranslations`. Provide your own translated strings in place of these.

---

## Renamed Abstract Members

The following members were renamed. If you have overridden them in a custom `Translations` subclass you must update the override signature; otherwise the compiler will flag the old name as an unknown member.

| Old member                           | New member                                      | Notes                                                                                                                                                                                                                                                                                     |
| ------------------------------------ | ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `String get questionsLabel`          | `String questionLabel({bool isPlural = false})` | Now mirrors `optionLabel({bool isPlural})`. Pass `isPlural: true` to get the previous plural value, or call with no arguments for the singular "Question" label used in the poll results/options dialogs.                                                                                 |
| `String get endVoteConfirmationText` | `String get endVoteConfirmationTitle`           | Renamed to reflect that this string is the dialog title rather than body text; see also the new default value in [Changed Default String Values](#changed-default-string-values).                                                                                                         |
| `String get slowModeOnLabel`         | `String slowModeOnLabel(int cooldownTimeOut)`   | Now takes the remaining cooldown in seconds so the placeholder can render a live countdown (default English: `'Slow mode, wait ${cooldownTimeOut}s\u2026'`). The composer text input is also disabled and the trailing send button shows the remaining seconds while slow mode is active. |

Example migration:

```dart
// Before
@override
String get questionsLabel => 'Questions';

// After
@override
String questionLabel({bool isPlural = false}) {
  if (isPlural) return 'Questions';
  return 'Question';
}
```

If you previously read `translations.questionsLabel`, replace it with `translations.questionLabel(isPlural: true)` to preserve the original plural behavior, or `translations.questionLabel()` where the singular form is appropriate.

---

## Changed Method Signatures

### `attachmentsUploadProgressText`

The `remaining:` parameter has been renamed to `completed:` and now represents the number of attachments that **have** been uploaded (rather than the number left). The total remains unchanged.

**Before:**

```dart
@override
String attachmentsUploadProgressText({
  required int remaining,
  required int total,
}) => 'Uploaded ${total - remaining} of $total ...';

// Caller
translations.attachmentsUploadProgressText(remaining: 2, total: 5)
```

**After:**

```dart
@override
String attachmentsUploadProgressText({
  required int completed,
  required int total,
}) => 'Uploaded $completed of $total ...';

// Caller
translations.attachmentsUploadProgressText(completed: 3, total: 5)
```

If your custom `Translations` subclass overrides this method, update both the parameter name and the body (subtract is no longer needed — `completed` is the value you want to display directly).

---

## Changed Default String Values

The following strings changed their default English value in `DefaultTranslations`. If you have not overridden them in a custom `Translations` subclass you do not need to do anything, but you should review whether the new values are appropriate for your app.

| Getter                                                     | Old default                                | New default                                 |
| ---------------------------------------------------------- | ------------------------------------------ | ------------------------------------------- |
| `threadReplyLabel`                                         | `'Thread Reply'`                           | `'Thread'`                                  |
| `threadReplyCountText(int)`                                | `'$count Thread Replies'`                  | `count == 1 ? '1 reply' : '$count replies'` |
| `alsoSendAsDirectMessageLabel`                             | `'Also send as direct message'`            | `'Also send in Channel'`                    |
| `addMoreFilesLabel`                                        | `'Add more files'`                         | `'Add more'`                                |
| `emptyMessagesText`                                        | `'There are no messages currently'`        | `'No messages yet'`                         |
| `writeAMessageLabel`                                       | `'Write a message'`                        | `'Send a message'`                          |
| `endVoteConfirmationTitle` (was `endVoteConfirmationText`) | `'Are you sure you want to end the vote?'` | `'End This Poll?'`                          |
| `endVoteLabel`                                             | `'End Vote'`                               | `'End Poll'`                                |

If your app overrides these in a `Translations` subclass, your custom values are unaffected.

---

## Migration Checklist

- [ ] Search your codebase for any class that `extends Translations` or `extends DefaultTranslations`
- [ ] Add implementations for all 35 new abstract members listed above — the compiler will flag missing ones
- [ ] Update the signature of any `questionsLabel` override to `questionLabel({bool isPlural = false})`, and replace any call to `translations.questionsLabel` with `translations.questionLabel(isPlural: true)`
- [ ] Rename any `endVoteConfirmationText` override (and consumer) to `endVoteConfirmationTitle`
- [ ] Update the signature of any `slowModeOnLabel` override from `String get slowModeOnLabel` to `String slowModeOnLabel(int cooldownTimeOut)`, and update consumers to pass the cooldown seconds (e.g. `translations.slowModeOnLabel(cooldownTimeOut)`)
- [ ] Update any `attachmentsUploadProgressText` override and call site — rename `remaining:` to `completed:` and adjust the body / argument to pass the number already uploaded (no more `total - remaining`)
- [ ] Review the changed default string values and decide whether to keep the new defaults or override them to preserve the old text
