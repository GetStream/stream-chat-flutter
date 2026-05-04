// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart' hide TextTheme;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamChatTheme}
/// Inherited widget providing the [StreamChatThemeData] to the widget tree
/// {@endtemplate}
class StreamChatTheme extends InheritedWidget {
  /// {@macro streamChatTheme}
  const StreamChatTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// {@macro streamChatThemeData}
  final StreamChatThemeData data;

  @override
  bool updateShouldNotify(StreamChatTheme oldWidget) => data != oldWidget.data;

  /// Use this method to get the current [StreamChatThemeData] instance
  static StreamChatThemeData of(BuildContext context) {
    final streamChatTheme = context.dependOnInheritedWidgetOfExactType<StreamChatTheme>();

    assert(
      streamChatTheme != null,
      'You must have a StreamChatTheme widget at the top of your widget tree',
    );

    return streamChatTheme!.data;
  }
}

/// {@template streamChatThemeData}
/// Theme data for Stream Chat
/// {@endtemplate}
class StreamChatThemeData {
  /// Creates a theme from scratch
  factory StreamChatThemeData({
    Brightness? brightness,
    StreamTextTheme? textTheme,
    StreamColorTheme? colorTheme,
    StreamAppBarThemeData? channelHeaderTheme,
    StreamAppBarThemeData? channelListHeaderTheme,
    StreamAppBarThemeData? threadHeaderTheme,
    StreamAppBarThemeData? galleryHeaderTheme,
    Widget Function(BuildContext, User)? defaultUserImage,
    PlaceholderUserImage? placeholderUserImage,
    IconThemeData? primaryIconTheme,
    StreamGalleryFooterThemeData? imageFooterTheme,
    StreamMessageListViewThemeData? messageListViewTheme,
    StreamPollCreatorThemeData? pollCreatorTheme,
    StreamPollInteractorThemeData? pollInteractorTheme,
    StreamPollOptionsSheetThemeData? pollOptionsSheetTheme,
    StreamPollResultsSheetThemeData? pollResultsSheetTheme,
    StreamPollCommentsSheetThemeData? pollCommentsSheetTheme,
    StreamPollOptionVotesSheetThemeData? pollOptionVotesSheetTheme,
    StreamThreadListTileThemeData? threadListTileTheme,
    StreamDraftListTileThemeData? draftListTileTheme,
    StreamVoiceRecordingAttachmentThemeData? voiceRecordingAttachmentTheme,
    StreamChannelListItemThemeData? channelListItemTheme,
  }) {
    brightness ??= colorTheme?.brightness ?? Brightness.light;
    textTheme ??= StreamTextTheme(brightness: brightness);
    colorTheme ??= StreamColorTheme(brightness: brightness);

    final defaultData = StreamChatThemeData.fromColorAndTextTheme(
      colorTheme,
      textTheme,
    );

    final customizedData = defaultData.copyWith(
      channelHeaderTheme: channelHeaderTheme,
      channelListHeaderTheme: channelListHeaderTheme,
      threadHeaderTheme: threadHeaderTheme,
      galleryHeaderTheme: galleryHeaderTheme,
      defaultUserImage: defaultUserImage,
      placeholderUserImage: placeholderUserImage,
      primaryIconTheme: primaryIconTheme,
      galleryFooterTheme: imageFooterTheme,
      messageListViewTheme: messageListViewTheme,
      pollCreatorTheme: pollCreatorTheme,
      pollInteractorTheme: pollInteractorTheme,
      pollOptionsSheetTheme: pollOptionsSheetTheme,
      pollResultsSheetTheme: pollResultsSheetTheme,
      pollCommentsSheetTheme: pollCommentsSheetTheme,
      pollOptionVotesSheetTheme: pollOptionVotesSheetTheme,
      threadListTileTheme: threadListTileTheme,
      draftListTileTheme: draftListTileTheme,
      voiceRecordingAttachmentTheme: voiceRecordingAttachmentTheme,
      channelListItemTheme: channelListItemTheme,
    );

    return defaultData.merge(customizedData);
  }

  /// Theme initialized with light
  factory StreamChatThemeData.light() => StreamChatThemeData(brightness: Brightness.light);

  /// Theme initialized with dark
  factory StreamChatThemeData.dark() => StreamChatThemeData(brightness: Brightness.dark);

  /// Raw theme initialization
  const StreamChatThemeData.raw({
    required this.textTheme,
    required this.colorTheme,
    required this.channelHeaderTheme,
    required this.channelListHeaderTheme,
    required this.threadHeaderTheme,
    required this.galleryHeaderTheme,
    required this.primaryIconTheme,
    required this.galleryFooterTheme,
    required this.messageListViewTheme,
    required this.pollCreatorTheme,
    required this.pollInteractorTheme,
    required this.pollResultsSheetTheme,
    required this.pollOptionsSheetTheme,
    required this.pollCommentsSheetTheme,
    required this.pollOptionVotesSheetTheme,
    required this.threadListTileTheme,
    required this.draftListTileTheme,
    required this.voiceRecordingAttachmentTheme,
    required this.channelListItemTheme,
  });

  /// Creates a theme from a Material [Theme]
  factory StreamChatThemeData.fromTheme(ThemeData theme) {
    final defaultTheme = StreamChatThemeData(brightness: theme.brightness);
    final customizedTheme = StreamChatThemeData.fromColorAndTextTheme(
      defaultTheme.colorTheme.copyWith(
        accentPrimary: theme.colorScheme.secondary,
      ),
      defaultTheme.textTheme,
    );
    return defaultTheme.merge(customizedTheme);
  }

  /// Creates a theme from a [StreamColorTheme] and a [StreamTextTheme]
  factory StreamChatThemeData.fromColorAndTextTheme(
    StreamColorTheme colorTheme,
    StreamTextTheme textTheme,
  ) {
    final iconTheme = IconThemeData(color: colorTheme.textLowEmphasis);

    return StreamChatThemeData.raw(
      textTheme: textTheme,
      colorTheme: colorTheme,
      primaryIconTheme: iconTheme,
      // Header chrome flows through per-header [StreamAppBarThemeData]
      // entries — defaults are resolved by the design system (background,
      // divider, padding, typography). Override individual fields per
      // header type to customise globally.
      channelHeaderTheme: const StreamAppBarThemeData(),
      channelListHeaderTheme: const StreamAppBarThemeData(),
      threadHeaderTheme: const StreamAppBarThemeData(),
      galleryHeaderTheme: const StreamAppBarThemeData(),
      galleryFooterTheme: StreamGalleryFooterThemeData(
        backgroundColor: colorTheme.barsBg,
        shareIconColor: colorTheme.textHighEmphasis,
        titleTextStyle: textTheme.headlineBold,
        gridIconButtonColor: colorTheme.textHighEmphasis,
        bottomSheetBarrierColor: colorTheme.overlay,
        bottomSheetBackgroundColor: colorTheme.barsBg,
        bottomSheetPhotosTextStyle: textTheme.headlineBold,
        bottomSheetCloseIconColor: colorTheme.textHighEmphasis,
      ),
      messageListViewTheme: StreamMessageListViewThemeData(
        backgroundColor: colorTheme.appBg,
      ),
      pollCreatorTheme: const StreamPollCreatorThemeData(),
      pollInteractorTheme: const StreamPollInteractorThemeData(),
      pollResultsSheetTheme: const StreamPollResultsSheetThemeData(),
      pollOptionsSheetTheme: const StreamPollOptionsSheetThemeData(),
      pollCommentsSheetTheme: const StreamPollCommentsSheetThemeData(),
      pollOptionVotesSheetTheme: const StreamPollOptionVotesSheetThemeData(),
      threadListTileTheme: const StreamThreadListTileThemeData(),
      draftListTileTheme: StreamDraftListTileThemeData(
        backgroundColor: colorTheme.barsBg,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        draftChannelNameStyle: textTheme.bodyBold.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        draftMessageStyle: textTheme.footnote.copyWith(
          color: colorTheme.textLowEmphasis,
        ),
        draftTimestampStyle: textTheme.footnote.copyWith(
          color: colorTheme.textLowEmphasis,
        ),
      ),
      voiceRecordingAttachmentTheme: const StreamVoiceRecordingAttachmentThemeData(),
      channelListItemTheme: const StreamChannelListItemThemeData(),
    );
  }

  /// The text themes used in the widgets
  final StreamTextTheme textTheme;

  /// The color themes used in the widgets
  final StreamColorTheme colorTheme;

  /// The default [StreamAppBar] style applied to [StreamChannelHeader].
  final StreamAppBarThemeData channelHeaderTheme;

  /// The default [StreamAppBar] style applied to [StreamChannelListHeader].
  final StreamAppBarThemeData channelListHeaderTheme;

  /// The default [StreamAppBar] style applied to [StreamThreadHeader].
  final StreamAppBarThemeData threadHeaderTheme;

  /// The default [StreamAppBar] style applied to [StreamGalleryHeader].
  final StreamAppBarThemeData galleryHeaderTheme;

  /// The default style for [StreamGalleryFooter]s below the overall
  /// [StreamChatTheme].
  final StreamGalleryFooterThemeData galleryFooterTheme;

  /// Primary icon theme
  final IconThemeData primaryIconTheme;

  /// Theme configuration for the [StreamMessageListView] widget.
  final StreamMessageListViewThemeData messageListViewTheme;

  /// Theme configuration for the [StreamPollCreatorWidget] widget.
  final StreamPollCreatorThemeData pollCreatorTheme;

  /// Theme configuration for the [StreamPollInteractor] widget.
  final StreamPollInteractorThemeData pollInteractorTheme;

  /// Theme configuration for the [StreamPollResultsSheet] widget.
  final StreamPollResultsSheetThemeData pollResultsSheetTheme;

  /// Theme configuration for the [StreamPollOptionsSheet] widget.
  final StreamPollOptionsSheetThemeData pollOptionsSheetTheme;

  /// Theme configuration for the [StreamPollCommentsSheet] widget.
  final StreamPollCommentsSheetThemeData pollCommentsSheetTheme;

  /// Theme configuration for the [StreamPollOptionVotesSheet] widget.
  final StreamPollOptionVotesSheetThemeData pollOptionVotesSheetTheme;

  /// Theme configuration for the [StreamThreadListTile] widget.
  final StreamThreadListTileThemeData threadListTileTheme;

  /// Theme configuration for the [StreamVoiceRecordingAttachment] widget.
  final StreamVoiceRecordingAttachmentThemeData voiceRecordingAttachmentTheme;

  /// Theme configuration for the [StreamChannelListItem] widget.
  final StreamChannelListItemThemeData channelListItemTheme;

  /// Theme configuration for the [StreamDraftListTile] widget.
  final StreamDraftListTileThemeData draftListTileTheme;

  /// Creates a copy of [StreamChatThemeData] with specified attributes
  /// overridden.
  StreamChatThemeData copyWith({
    StreamTextTheme? textTheme,
    StreamColorTheme? colorTheme,
    StreamAppBarThemeData? channelHeaderTheme,
    StreamAppBarThemeData? channelListHeaderTheme,
    StreamAppBarThemeData? threadHeaderTheme,
    StreamAppBarThemeData? galleryHeaderTheme,
    Widget Function(BuildContext, User)? defaultUserImage,
    PlaceholderUserImage? placeholderUserImage,
    IconThemeData? primaryIconTheme,
    StreamGalleryFooterThemeData? galleryFooterTheme,
    StreamMessageListViewThemeData? messageListViewTheme,
    StreamPollCreatorThemeData? pollCreatorTheme,
    StreamPollInteractorThemeData? pollInteractorTheme,
    StreamPollResultsSheetThemeData? pollResultsSheetTheme,
    StreamPollOptionsSheetThemeData? pollOptionsSheetTheme,
    StreamPollCommentsSheetThemeData? pollCommentsSheetTheme,
    StreamPollOptionVotesSheetThemeData? pollOptionVotesSheetTheme,
    StreamThreadListTileThemeData? threadListTileTheme,
    StreamDraftListTileThemeData? draftListTileTheme,
    StreamVoiceRecordingAttachmentThemeData? voiceRecordingAttachmentTheme,
    StreamChannelListItemThemeData? channelListItemTheme,
  }) => StreamChatThemeData.raw(
    textTheme: this.textTheme.merge(textTheme),
    colorTheme: this.colorTheme.merge(colorTheme),
    channelHeaderTheme: this.channelHeaderTheme.merge(channelHeaderTheme),
    channelListHeaderTheme: this.channelListHeaderTheme.merge(channelListHeaderTheme),
    threadHeaderTheme: this.threadHeaderTheme.merge(threadHeaderTheme),
    galleryHeaderTheme: this.galleryHeaderTheme.merge(galleryHeaderTheme),
    primaryIconTheme: this.primaryIconTheme.merge(primaryIconTheme),
    galleryFooterTheme: galleryFooterTheme ?? this.galleryFooterTheme,
    messageListViewTheme: messageListViewTheme ?? this.messageListViewTheme,
    pollCreatorTheme: pollCreatorTheme ?? this.pollCreatorTheme,
    pollInteractorTheme: pollInteractorTheme ?? this.pollInteractorTheme,
    pollResultsSheetTheme: pollResultsSheetTheme ?? this.pollResultsSheetTheme,
    pollOptionsSheetTheme: pollOptionsSheetTheme ?? this.pollOptionsSheetTheme,
    pollCommentsSheetTheme: pollCommentsSheetTheme ?? this.pollCommentsSheetTheme,
    pollOptionVotesSheetTheme: pollOptionVotesSheetTheme ?? this.pollOptionVotesSheetTheme,
    threadListTileTheme: threadListTileTheme ?? this.threadListTileTheme,
    draftListTileTheme: draftListTileTheme ?? this.draftListTileTheme,
    voiceRecordingAttachmentTheme: voiceRecordingAttachmentTheme ?? this.voiceRecordingAttachmentTheme,
    channelListItemTheme: channelListItemTheme ?? this.channelListItemTheme,
  );

  /// Merge themes
  StreamChatThemeData merge(StreamChatThemeData? other) {
    if (other == null) return this;
    return copyWith(
      textTheme: textTheme.merge(other.textTheme),
      colorTheme: colorTheme.merge(other.colorTheme),
      channelHeaderTheme: channelHeaderTheme.merge(other.channelHeaderTheme),
      channelListHeaderTheme: channelListHeaderTheme.merge(other.channelListHeaderTheme),
      threadHeaderTheme: threadHeaderTheme.merge(other.threadHeaderTheme),
      galleryHeaderTheme: galleryHeaderTheme.merge(other.galleryHeaderTheme),
      primaryIconTheme: other.primaryIconTheme,
      galleryFooterTheme: galleryFooterTheme.merge(other.galleryFooterTheme),
      messageListViewTheme: messageListViewTheme.merge(other.messageListViewTheme),
      pollCreatorTheme: pollCreatorTheme.merge(other.pollCreatorTheme),
      pollInteractorTheme: pollInteractorTheme.merge(other.pollInteractorTheme),
      pollResultsSheetTheme: pollResultsSheetTheme.merge(other.pollResultsSheetTheme),
      pollOptionsSheetTheme: pollOptionsSheetTheme.merge(other.pollOptionsSheetTheme),
      pollCommentsSheetTheme: pollCommentsSheetTheme.merge(other.pollCommentsSheetTheme),
      pollOptionVotesSheetTheme: pollOptionVotesSheetTheme.merge(other.pollOptionVotesSheetTheme),
      threadListTileTheme: threadListTileTheme.merge(other.threadListTileTheme),
      draftListTileTheme: draftListTileTheme.merge(other.draftListTileTheme),
      voiceRecordingAttachmentTheme: voiceRecordingAttachmentTheme.merge(other.voiceRecordingAttachmentTheme),
      channelListItemTheme: channelListItemTheme.merge(other.channelListItemTheme),
    );
  }
}
