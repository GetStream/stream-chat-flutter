// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/localization/translations.dart';
import 'package:stream_chat_flutter/src/utils/date_formatter.dart';

/// Defines the accessibility (a11y) resource values used by the Stream Chat
/// widgets.
///
/// These values are attached to widgets via [Semantics], `tooltip:` params,
/// [Icon.semanticLabel], or dispatched imperatively via
/// [SemanticsService.announce]. They target screen readers and other
/// assistive technologies, and are surfaced through
/// [Translations.accessibility].
///
/// See also:
///
///  * [DefaultAccessibilityTranslations], the default, English-only,
///    implementation of this interface.
///  * [Translations.accessibility], the getter that surfaces this on
///    [Translations].
abstract class AccessibilityTranslations {
  /// Creates the base [AccessibilityTranslations] with the given `localeName`.
  ///
  /// Subclasses forward the locale via `super.localeName` in their constructor.
  const AccessibilityTranslations({required this.localeName});

  /// The BCP-47 locale name this translation instance targets (e.g. `'en'`,
  /// `'de'`, `'fr'`). Used to bind [Intl.withLocale] / [DateFormat] to the
  /// correct locale when formatting dates and durations for screen readers.
  final String localeName;

  /// The tooltip for the send button in a [StreamMessageComposer].
  String get sendMessageTooltip;

  /// The tooltip for the send button in a [StreamMessageComposer] when
  /// editing an existing message.
  String get saveEditTooltip;

  /// The tooltip for the send button in a [StreamMessageComposer] when
  /// sending a slash command.
  String get sendCommandTooltip;

  /// The tooltip for the slow-mode countdown button in a
  /// [StreamMessageComposer], showing the remaining `seconds` before the
  /// user can send another message.
  String slowModeTooltip({required int seconds});

  /// The accessibility label for the voice-record button in a
  /// [StreamMessageComposer].
  String get recordVoiceRecordingLabel;

  /// The tooltip for the cancel button while a voice recording is in
  /// progress.
  String get cancelRecordingTooltip;

  /// The tooltip for the stop button while a voice recording is in
  /// progress.
  String get stopRecordingTooltip;

  /// The tooltip for the send button on a completed voice recording.
  String get sendRecordingTooltip;

  /// The accessibility label announcing the current recording `duration`
  /// on the locked-recording UI, e.g. 'Recording duration, 1 minute 23
  /// seconds' in United States English.
  String recordingDurationLabel({required Duration duration});

  /// The accessibility label for the play button in a voice-recording
  /// preview (in the composer, before send), embedding the total
  /// `duration`.
  String voiceRecordingPreviewPlayLabel({required Duration duration});

  /// The accessibility label for the pause button in a voice-recording
  /// preview (in the composer, before send), embedding the total
  /// `duration`.
  String voiceRecordingPreviewPauseLabel({required Duration duration});

  /// The tooltip for the attachment-picker button in a
  /// [StreamMessageComposer].
  String get attachmentPickerTooltip;

  /// The verbose hint read by VoiceOver on the attachment-picker toggle
  /// when the picker is closed (i.e. tapping will open it).
  String get attachmentPickerOpenHint;

  /// The verbose hint read by VoiceOver on the attachment-picker toggle
  /// when the picker is open (i.e. tapping will close it).
  String get attachmentPickerCloseHint;

  /// The `onTapHint` read by TalkBack on the attachment-picker toggle
  /// when the picker is closed. TalkBack prepends "double-tap to ".
  String get attachmentPickerOpenTapHint;

  /// The `onTapHint` read by TalkBack on the attachment-picker toggle
  /// when the picker is open. TalkBack prepends "double-tap to ".
  String get attachmentPickerCloseTapHint;

  /// The live-region announcement fired when the attachment picker opens.
  String get attachmentPickerOpenedAnnouncement;

  /// The live-region announcement fired when the attachment picker closes.
  String get attachmentPickerClosedAnnouncement;

  /// The accessibility label for a voice-recording attachment, including
  /// the `duration` when known.
  String voiceRecordingAttachmentLabel({Duration? duration});

  /// The accessibility label for a video attachment, including the
  /// `title` when set.
  String videoAttachmentLabel({String? title});

  /// The accessibility label for a GIF attachment.
  String get gifAttachmentLabel;

  /// The accessibility label for a photo attachment, including the
  /// `title` when set.
  String imageAttachmentLabel({String? title});

  /// The tooltip for the play button on a sent voice-recording
  /// attachment.
  String get voiceRecordingPlayTooltip;

  /// The tooltip for the pause button on a sent voice-recording
  /// attachment.
  String get voiceRecordingPauseTooltip;

  /// The tooltip shown while a voice-recording attachment is loading.
  String get voiceRecordingLoadingTooltip;

  /// The accessibility label for the channel-info affordance on a
  /// [StreamChannelHeader]'s avatar.
  String get channelInfoLabel;

  /// The accessibility label for the message-actions icon in a message
  /// actions modal.
  String get messageActionsLabel;

  /// The accessibility label for an image tile in the attachment-picker
  /// gallery, including a locale-aware timestamp for `createdAt` when
  /// provided.
  String galleryImageLabel({DateTime? createdAt});

  /// The accessibility label for a video tile in the attachment-picker
  /// gallery, including a locale-aware timestamp for `createdAt` and a
  /// spelled-out `duration` when provided.
  String galleryVideoLabel({
    DateTime? createdAt,
    Duration? duration,
  });

  /// The `onTapHint` on [Semantics] for a gallery tile that would be
  /// selected on tap.
  String get selectMediaTapHint;

  /// The `onTapHint` on [Semantics] for a gallery tile that would be
  /// deselected on tap.
  String get deselectMediaTapHint;

  /// The screen-reader prefix for own last-message previews, e.g. `"You"`.
  ///
  /// Combined with the message body as `"You\n2 photos"`.
  String get outgoingMessagePreviewLabel;

  /// The screen-reader prefix for group-channel last-message previews from
  /// another user.
  ///
  /// Combined with the body as `"Alice\n2 photos"`, or `"Message\n2 photos"`
  /// when [senderName] is null.
  String incomingMessagePreviewLabel({String? senderName});

  /// The screen-reader type label for a poll last-message preview, e.g.
  /// `"Poll"`.
  ///
  /// Prepended to the question so `"ee"` becomes `"Poll\nee"`.
  String get pollPreviewLabel;

  /// The screen-reader prefix for draft last-message previews, e.g.
  /// `"Draft"`.
  ///
  /// Combined with the draft body as `"Draft\nReply in progress"`.
  String get draftPreviewLabel;

  /// The screen-reader label for a message-delivery indicator while the
  /// message is sending, e.g. `"Sending"`.
  String get messageSendingStatusLabel;

  /// The screen-reader label for a message-delivery indicator once the
  /// message has been server-acknowledged but not delivered, e.g. `"Sent"`.
  String get messageSentStatusLabel;

  /// The screen-reader label for a message-delivery indicator once the
  /// message has been delivered but not read, e.g. `"Delivered"`.
  String get messageDeliveredStatusLabel;

  /// The screen-reader label for a message-delivery indicator once the
  /// message has been read by the recipient, e.g. `"Read"`.
  String get messageReadStatusLabel;

  /// The screen-reader phrasing for a batch of unread messages, e.g.
  /// `"9 unread messages"` / `"1 unread message"`.
  ///
  /// Only invoked when `count > 0`.
  String unreadMessagesLabel({required int count});

  /// The screen-reader label for the avatar on a group channel, e.g.
  /// `"Group"`.
  String get channelGroupLabel;

  /// The screen-reader prefix for system / channel-event last-message
  /// previews, e.g. `"System"`.
  ///
  /// Combined with the event text as `"System\nAlice was added to the
  /// channel"`.
  String get systemMessagePreviewLabel;

  /// The screen-reader label for the muted-channel indicator on a channel
  /// list row.
  String get channelMutedLabel;

  /// The screen-reader label for the pinned-channel indicator on a channel
  /// list row.
  String get channelPinnedLabel;

  /// The tooltip for the save-poll button in a poll creator.
  String get savePollTooltip;

  /// The tooltip for the remove-option button in a poll option row,
  /// including the `optionText` when non-empty.
  String removePollOptionTooltip({String? optionText});

  /// The live-region announcement fired when a hold-to-record gesture
  /// begins.
  String get recordingStartedAnnouncement;

  /// The live-region announcement fired when a recording is locked, i.e.
  /// the finger was released while sliding up.
  String get recordingLockedAnnouncement;

  /// The live-region announcement fired when the user stops a locked
  /// recording, entering the review/preview state (the recording is not
  /// yet attached to the composer).
  String get recordingStoppedAnnouncement;

  /// The live-region announcement fired when a recording is cancelled.
  String get recordingCancelledAnnouncement;

  /// The live-region announcement fired when a recording is finalized
  /// and attached to the composer as a voice message.
  String get recordingCompletedAnnouncement;

  /// The live-region announcement fired when a single photo attachment is
  /// added to the composer.
  String get imageAttachmentAddedAnnouncement;

  /// The live-region announcement fired when a single photo attachment is
  /// removed from the composer.
  String get imageAttachmentRemovedAnnouncement;

  /// The live-region announcement fired when a single video attachment is
  /// added to the composer.
  String get videoAttachmentAddedAnnouncement;

  /// The live-region announcement fired when a single video attachment is
  /// removed from the composer.
  String get videoAttachmentRemovedAnnouncement;

  /// The live-region announcement fired when a single GIF attachment is
  /// added to the composer.
  String get gifAttachmentAddedAnnouncement;

  /// The live-region announcement fired when a single GIF attachment is
  /// removed from the composer.
  String get gifAttachmentRemovedAnnouncement;

  /// The live-region announcement fired when a single file attachment is
  /// added to the composer.
  String get fileAttachmentAddedAnnouncement;

  /// The live-region announcement fired when a single file attachment is
  /// removed from the composer.
  String get fileAttachmentRemovedAnnouncement;

  /// The live-region announcement fired when a single voice-recording
  /// attachment is added to the composer.
  String get voiceRecordingAttachmentAddedAnnouncement;

  /// The live-region announcement fired when a single voice-recording
  /// attachment is removed from the composer.
  String get voiceRecordingAttachmentRemovedAnnouncement;

  /// The live-region announcement fired when a single attachment of
  /// unspecified type is added to the composer.
  String get attachmentAddedAnnouncement;

  /// The live-region announcement fired when a single attachment of
  /// unspecified type is removed from the composer.
  String get attachmentRemovedAnnouncement;

  /// The live-region announcement fired when `count` attachments are
  /// added to the composer at once.
  String attachmentsAddedAnnouncement({required int count});

  /// The live-region announcement fired when `count` attachments are
  /// removed from the composer at once.
  String attachmentsRemovedAnnouncement({required int count});

  /// Formats `dateTime` as a locale-aware natural-language timestamp
  /// suitable for screen-reader announcements, e.g. 'March 15, 2026,
  /// 10:30 AM' in United States English.
  String formatDateTime(DateTime dateTime);

  /// Formats `date` as a locale-aware bucketed natural-language timestamp
  /// for screen-reader announcements, e.g. `"Just now"`, `"Today at 2:30 PM"`,
  /// `"Yesterday at 2:30 PM"`, `"Saturday at 2:30 PM"`, `"Jan 15 at 2:30 PM"`,
  /// or `"Jan 15, 2024 at 2:30 PM"` for older dates.
  ///
  /// Ordinals and compact abbreviations (`"15th"`, `"1m"`) are avoided —
  /// some TTS engines mispronounce them.
  String formatRecentDateTime(DateTime date);

  /// Formats `duration` as a spelled-out natural-language string for
  /// screen-reader announcements, e.g. `"1 minute 23 seconds"`.
  String formatDuration(Duration duration);
}

/// US English strings for the Stream Chat accessibility translations.
///
/// See also:
///
///  * [AccessibilityTranslations], the interface this implements.
///  * [Translations.accessibility], which returns an instance of this
///    class when no [StreamChatLocalizations] delegate is registered.
class DefaultAccessibilityTranslations extends AccessibilityTranslations {
  /// Creates a default English [AccessibilityTranslations] implementation.
  const DefaultAccessibilityTranslations({super.localeName = 'en'});

  @override
  String get sendMessageTooltip => 'Send message';

  @override
  String get saveEditTooltip => 'Save edit';

  @override
  String get sendCommandTooltip => 'Send command';

  @override
  String slowModeTooltip({required int seconds}) {
    if (seconds == 1) return 'Slow mode: 1 second';
    return 'Slow mode: $seconds seconds';
  }

  @override
  String get recordVoiceRecordingLabel => 'Record voice message';

  @override
  String get cancelRecordingTooltip => 'Cancel recording';

  @override
  String get stopRecordingTooltip => 'Stop recording';

  @override
  String get sendRecordingTooltip => 'Send recording';

  @override
  String recordingDurationLabel({required Duration duration}) {
    return 'Recording duration, ${formatDuration(duration)}';
  }

  @override
  String voiceRecordingPreviewPlayLabel({required Duration duration}) {
    return 'Play voice recording, ${formatDuration(duration)}';
  }

  @override
  String voiceRecordingPreviewPauseLabel({required Duration duration}) {
    return 'Pause voice recording, ${formatDuration(duration)}';
  }

  @override
  String get attachmentPickerTooltip => 'Toggle attachment picker';

  @override
  String get attachmentPickerOpenHint => 'double tap to open attachment picker';

  @override
  String get attachmentPickerCloseHint => 'double tap to close attachment picker';

  @override
  String get attachmentPickerOpenTapHint => 'open attachment picker';

  @override
  String get attachmentPickerCloseTapHint => 'close attachment picker';

  @override
  String get attachmentPickerOpenedAnnouncement => 'Attachment picker opened';

  @override
  String get attachmentPickerClosedAnnouncement => 'Attachment picker closed';

  @override
  String voiceRecordingAttachmentLabel({Duration? duration}) {
    if (duration == null) return 'Voice message';
    return 'Voice message, ${formatDuration(duration)}';
  }

  @override
  String videoAttachmentLabel({String? title}) {
    if (title == null || title.isEmpty) return 'Video';
    return 'Video, $title';
  }

  @override
  String get gifAttachmentLabel => 'GIF';

  @override
  String imageAttachmentLabel({String? title}) {
    if (title == null || title.isEmpty) return 'Photo';
    return 'Photo, $title';
  }

  @override
  String get voiceRecordingPlayTooltip => 'Play';

  @override
  String get voiceRecordingPauseTooltip => 'Pause';

  @override
  String get voiceRecordingLoadingTooltip => 'Loading';

  @override
  String get channelInfoLabel => 'Channel info';

  @override
  String get messageActionsLabel => 'Message actions';

  @override
  String galleryImageLabel({DateTime? createdAt}) {
    if (createdAt == null) return 'Photo';
    return 'Photo, ${formatDateTime(createdAt)}';
  }

  @override
  String galleryVideoLabel({
    DateTime? createdAt,
    Duration? duration,
  }) {
    final parts = <String>[
      'Video',
      if (duration != null) formatDuration(duration),
      if (createdAt != null) formatDateTime(createdAt),
    ];
    return parts.join(', ');
  }

  @override
  String get selectMediaTapHint => 'select';

  @override
  String get deselectMediaTapHint => 'deselect';

  @override
  String get outgoingMessagePreviewLabel => 'You';

  @override
  String incomingMessagePreviewLabel({String? senderName}) {
    return senderName ?? 'Message';
  }

  @override
  String get pollPreviewLabel => 'Poll';

  @override
  String get draftPreviewLabel => 'Draft';

  @override
  String get messageSendingStatusLabel => 'Sending';

  @override
  String get messageSentStatusLabel => 'Sent';

  @override
  String get messageDeliveredStatusLabel => 'Delivered';

  @override
  String get messageReadStatusLabel => 'Read';

  @override
  String unreadMessagesLabel({required int count}) {
    return Intl.plural(
      count,
      one: '$count unread message',
      other: '$count unread messages',
      locale: localeName,
    );
  }

  @override
  String get channelGroupLabel => 'Group';

  @override
  String get systemMessagePreviewLabel => 'System';

  @override
  String get channelMutedLabel => 'muted';

  @override
  String get channelPinnedLabel => 'pinned';

  @override
  String get savePollTooltip => 'Save poll';

  @override
  String removePollOptionTooltip({String? optionText}) {
    final trimmed = optionText?.trim();
    if (trimmed == null || trimmed.isEmpty) return 'Remove option';
    return 'Remove option $trimmed';
  }

  @override
  String get recordingStartedAnnouncement => 'Recording started. Slide left to cancel. Slide up to lock.';

  @override
  String get recordingLockedAnnouncement => 'Recording locked';

  @override
  String get recordingStoppedAnnouncement => 'Recording stopped';

  @override
  String get recordingCancelledAnnouncement => 'Recording cancelled';

  @override
  String get recordingCompletedAnnouncement => 'Recording complete';

  @override
  String get imageAttachmentAddedAnnouncement => 'Photo added';

  @override
  String get imageAttachmentRemovedAnnouncement => 'Photo removed';

  @override
  String get videoAttachmentAddedAnnouncement => 'Video added';

  @override
  String get videoAttachmentRemovedAnnouncement => 'Video removed';

  @override
  String get gifAttachmentAddedAnnouncement => 'GIF added';

  @override
  String get gifAttachmentRemovedAnnouncement => 'GIF removed';

  @override
  String get fileAttachmentAddedAnnouncement => 'File added';

  @override
  String get fileAttachmentRemovedAnnouncement => 'File removed';

  @override
  String get voiceRecordingAttachmentAddedAnnouncement => 'Voice message added';

  @override
  String get voiceRecordingAttachmentRemovedAnnouncement => 'Voice message removed';

  @override
  String get attachmentAddedAnnouncement => 'Attachment added';

  @override
  String get attachmentRemovedAnnouncement => 'Attachment removed';

  @override
  String attachmentsAddedAnnouncement({required int count}) {
    return Intl.plural(
      count,
      one: '$count attachment added',
      other: '$count attachments added',
      locale: localeName,
    );
  }

  @override
  String attachmentsRemovedAnnouncement({required int count}) {
    return Intl.plural(
      count,
      one: '$count attachment removed',
      other: '$count attachments removed',
      locale: localeName,
    );
  }

  @override
  String formatDateTime(DateTime dateTime) {
    final jiffy = Jiffy.parseFromDateTime(dateTime);
    return '${jiffy.EEEE}, ${jiffy.yMMMMd}, ${jiffy.jm}';
  }

  @override
  String formatRecentDateTime(DateTime date) {
    if (date.isWithinLastMinute) return 'Just now';

    final localDate = date.toLocal();
    final jiffyDate = Jiffy.parseFromDateTime(localDate);
    final time = jiffyDate.jm;

    if (localDate.isToday) return 'Today at $time';
    if (localDate.isYesterday) return 'Yesterday at $time';
    if (localDate.isWithinLastWeek) return '${jiffyDate.EEEE} at $time';
    if (localDate.isInSameYear) {
      return '${jiffyDate.format(pattern: 'MMM d')} at $time';
    }
    return '${jiffyDate.format(pattern: 'MMM d, yyyy')} at $time';
  }

  @override
  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final parts = <String>[
      if (hours > 0) Intl.plural(hours, one: '$hours hour', other: '$hours hours', locale: localeName),
      if (minutes > 0) Intl.plural(minutes, one: '$minutes minute', other: '$minutes minutes', locale: localeName),
      if (seconds > 0 || (hours == 0 && minutes == 0))
        Intl.plural(seconds, one: '$seconds second', other: '$seconds seconds', locale: localeName),
    ];
    return parts.join(', ');
  }
}
