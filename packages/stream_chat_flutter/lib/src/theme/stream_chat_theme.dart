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
    StreamChannelListHeaderThemeData? channelListHeaderTheme,
    StreamChannelHeaderThemeData? channelHeaderTheme,
    Widget Function(BuildContext, User)? defaultUserImage,
    PlaceholderUserImage? placeholderUserImage,
    IconThemeData? primaryIconTheme,
    StreamGalleryHeaderThemeData? imageHeaderTheme,
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
    StreamQuotedMessageThemeData? quotedMessageTheme,
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
      channelListHeaderTheme: channelListHeaderTheme,
      channelHeaderTheme: channelHeaderTheme,
      defaultUserImage: defaultUserImage,
      placeholderUserImage: placeholderUserImage,
      primaryIconTheme: primaryIconTheme,
      galleryHeaderTheme: imageHeaderTheme,
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
      quotedMessageTheme: quotedMessageTheme,
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
    required this.channelListHeaderTheme,
    required this.channelHeaderTheme,
    required this.primaryIconTheme,
    required this.galleryHeaderTheme,
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
    required this.quotedMessageTheme,
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
    final channelHeaderTheme = StreamChannelHeaderThemeData(
      avatarTheme: StreamAvatarThemeData(
        borderRadius: BorderRadius.circular(20),
        constraints: const BoxConstraints.tightFor(
          height: 40,
          width: 40,
        ),
      ),
      color: colorTheme.barsBg,
    );

    return StreamChatThemeData.raw(
      textTheme: textTheme,
      colorTheme: colorTheme,
      primaryIconTheme: iconTheme,
      channelListHeaderTheme: StreamChannelListHeaderThemeData(
        avatarTheme: StreamAvatarThemeData(
          borderRadius: BorderRadius.circular(20),
          constraints: const BoxConstraints.tightFor(
            height: 40,
            width: 40,
          ),
        ),
        color: colorTheme.barsBg,
        titleStyle: textTheme.headlineBold,
      ),
      channelHeaderTheme: channelHeaderTheme,
      galleryHeaderTheme: StreamGalleryHeaderThemeData(
        closeButtonColor: colorTheme.textHighEmphasis,
        backgroundColor: channelHeaderTheme.color,
        iconMenuPointColor: colorTheme.textHighEmphasis,
        titleTextStyle: textTheme.headlineBold,
        bottomSheetBarrierColor: colorTheme.overlay,
      ),
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
      quotedMessageTheme: const StreamQuotedMessageThemeData(),
      channelListItemTheme: const StreamChannelListItemThemeData(),
    );
  }

  /// The text themes used in the widgets
  final StreamTextTheme textTheme;

  /// The color themes used in the widgets
  final StreamColorTheme colorTheme;

  /// Theme of the [StreamChannelListHeader]
  final StreamChannelListHeaderThemeData channelListHeaderTheme;

  /// Theme of the chat widgets dedicated to a channel header
  final StreamChannelHeaderThemeData channelHeaderTheme;

  /// The default style for [StreamGalleryHeader]s below the overall
  /// [StreamChatTheme].
  final StreamGalleryHeaderThemeData galleryHeaderTheme;

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

  /// Theme configuration for the [StreamQuotedMessage] widget.
  final StreamQuotedMessageThemeData quotedMessageTheme;

  /// Theme configuration for the [StreamChannelListItem] widget.
  final StreamChannelListItemThemeData channelListItemTheme;

  /// Theme configuration for the [StreamDraftListTile] widget.
  final StreamDraftListTileThemeData draftListTileTheme;

  /// Creates a copy of [StreamChatThemeData] with specified attributes
  /// overridden.
  StreamChatThemeData copyWith({
    StreamTextTheme? textTheme,
    StreamColorTheme? colorTheme,
    StreamChannelHeaderThemeData? channelHeaderTheme,
    Widget Function(BuildContext, User)? defaultUserImage,
    PlaceholderUserImage? placeholderUserImage,
    IconThemeData? primaryIconTheme,
    StreamChannelListHeaderThemeData? channelListHeaderTheme,
    StreamGalleryHeaderThemeData? galleryHeaderTheme,
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
    StreamQuotedMessageThemeData? quotedMessageTheme,
    StreamChannelListItemThemeData? channelListItemTheme,
  }) => StreamChatThemeData.raw(
    channelListHeaderTheme: this.channelListHeaderTheme.merge(channelListHeaderTheme),
    textTheme: this.textTheme.merge(textTheme),
    colorTheme: this.colorTheme.merge(colorTheme),
    primaryIconTheme: this.primaryIconTheme.merge(primaryIconTheme),
    channelHeaderTheme: this.channelHeaderTheme.merge(channelHeaderTheme),
    galleryHeaderTheme: galleryHeaderTheme ?? this.galleryHeaderTheme,
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
    quotedMessageTheme: quotedMessageTheme ?? this.quotedMessageTheme,
    channelListItemTheme: channelListItemTheme ?? this.channelListItemTheme,
  );

  /// Merge themes
  StreamChatThemeData merge(StreamChatThemeData? other) {
    if (other == null) return this;
    return copyWith(
      channelListHeaderTheme: channelListHeaderTheme.merge(other.channelListHeaderTheme),
      textTheme: textTheme.merge(other.textTheme),
      colorTheme: colorTheme.merge(other.colorTheme),
      primaryIconTheme: other.primaryIconTheme,
      channelHeaderTheme: channelHeaderTheme.merge(other.channelHeaderTheme),
      galleryHeaderTheme: galleryHeaderTheme.merge(other.galleryHeaderTheme),
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
      quotedMessageTheme: quotedMessageTheme.merge(other.quotedMessageTheme),
      channelListItemTheme: channelListItemTheme.merge(other.channelListItemTheme),
    );
  }
}
