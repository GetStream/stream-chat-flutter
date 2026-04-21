# Localizations Migration Guide

This guide covers the breaking changes to `Translations` and `StreamChatLocalizations` in the Stream Chat Flutter SDK design refresh.

---

## Table of Contents

- [New Required Abstract Members](#new-required-abstract-members)
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
```

> **Note:** The values shown above are the English defaults from `DefaultTranslations`. Provide your own translated strings in place of these.

---

## Changed Default String Values

The following strings changed their default English value in `DefaultTranslations`. If you have not overridden them in a custom `Translations` subclass you do not need to do anything, but you should review whether the new values are appropriate for your app.

| Getter | Old default | New default |
|--------|-------------|-------------|
| `threadReplyLabel` | `'Thread Reply'` | `'Thread'` |
| `threadReplyCountText(int)` | `'$count Thread Replies'` | `count == 1 ? '1 reply' : '$count replies'` |
| `alsoSendAsDirectMessageLabel` | `'Also send as direct message'` | `'Also send in Channel'` |
| `addMoreFilesLabel` | `'Add more files'` | `'Add more'` |
| `emptyMessagesText` | `'There are no messages currently'` | `'No messages yet'` |
| `writeAMessageLabel` | `'Write a message'` | `'Send a message'` |

If your app overrides these in a `Translations` subclass, your custom values are unaffected.

---

## Migration Checklist

- [ ] Search your codebase for any class that `extends Translations` or `extends DefaultTranslations`
- [ ] Add implementations for all 31 new abstract members listed above — the compiler will flag missing ones
- [ ] Review the four changed default string values and decide whether to keep the new defaults or override them to preserve the old text
