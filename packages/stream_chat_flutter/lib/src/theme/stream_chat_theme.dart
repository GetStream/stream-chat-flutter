import 'package:flutter/material.dart' hide TextTheme;
import 'package:stream_chat_flutter/src/theme/poll_comments_dialog_theme.dart';
import 'package:stream_chat_flutter/src/theme/poll_interactor_theme.dart';
import 'package:stream_chat_flutter/src/theme/poll_option_votes_dialog_theme.dart';
import 'package:stream_chat_flutter/src/theme/poll_options_dialog_theme.dart';
import 'package:stream_chat_flutter/src/theme/poll_results_dialog_theme.dart';
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
    final streamChatTheme =
        context.dependOnInheritedWidgetOfExactType<StreamChatTheme>();

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
    StreamChannelPreviewThemeData? channelPreviewTheme,
    StreamChannelHeaderThemeData? channelHeaderTheme,
    StreamMessageThemeData? otherMessageTheme,
    StreamMessageThemeData? ownMessageTheme,
    StreamMessageInputThemeData? messageInputTheme,
    Widget Function(BuildContext, User)? defaultUserImage,
    PlaceholderUserImage? placeholderUserImage,
    IconThemeData? primaryIconTheme,
    @Deprecated('Use StreamChatConfigurationData.reactionIcons instead')
    List<StreamReactionIcon>? reactionIcons,
    StreamGalleryHeaderThemeData? imageHeaderTheme,
    StreamGalleryFooterThemeData? imageFooterTheme,
    StreamMessageListViewThemeData? messageListViewTheme,
    StreamVoiceRecordingThemeData? voiceRecordingTheme,
    StreamPollCreatorThemeData? pollCreatorTheme,
    StreamPollInteractorThemeData? pollInteractorTheme,
    StreamPollOptionsDialogThemeData? pollOptionsDialogTheme,
    StreamPollResultsDialogThemeData? pollResultsDialogTheme,
    StreamPollCommentsDialogThemeData? pollCommentsDialogTheme,
    StreamPollOptionVotesDialogThemeData? pollOptionVotesDialogTheme,
  }) {
    brightness ??= colorTheme?.brightness ?? Brightness.light;
    final isDark = brightness == Brightness.dark;
    textTheme ??= isDark ? StreamTextTheme.dark() : StreamTextTheme.light();
    colorTheme ??= isDark ? StreamColorTheme.dark() : StreamColorTheme.light();

    final defaultData = StreamChatThemeData.fromColorAndTextTheme(
      colorTheme,
      textTheme,
    );

    final customizedData = defaultData.copyWith(
      channelListHeaderTheme: channelListHeaderTheme,
      channelPreviewTheme: channelPreviewTheme,
      channelHeaderTheme: channelHeaderTheme,
      otherMessageTheme: otherMessageTheme,
      ownMessageTheme: ownMessageTheme,
      messageInputTheme: messageInputTheme,
      defaultUserImage: defaultUserImage,
      placeholderUserImage: placeholderUserImage,
      primaryIconTheme: primaryIconTheme,
      //ignore: deprecated_member_use_from_same_package
      reactionIcons: reactionIcons,
      galleryHeaderTheme: imageHeaderTheme,
      galleryFooterTheme: imageFooterTheme,
      messageListViewTheme: messageListViewTheme,
      voiceRecordingTheme: voiceRecordingTheme,
      pollCreatorTheme: pollCreatorTheme,
      pollInteractorTheme: pollInteractorTheme,
      pollOptionsDialogTheme: pollOptionsDialogTheme,
      pollResultsDialogTheme: pollResultsDialogTheme,
      pollCommentsDialogTheme: pollCommentsDialogTheme,
      pollOptionVotesDialogTheme: pollOptionVotesDialogTheme,
    );

    return defaultData.merge(customizedData);
  }

  /// Theme initialized with light
  factory StreamChatThemeData.light() =>
      StreamChatThemeData(brightness: Brightness.light);

  /// Theme initialized with dark
  factory StreamChatThemeData.dark() =>
      StreamChatThemeData(brightness: Brightness.dark);

  /// Raw theme initialization
  const StreamChatThemeData.raw({
    required this.textTheme,
    required this.colorTheme,
    required this.channelListHeaderTheme,
    required this.channelPreviewTheme,
    required this.channelHeaderTheme,
    required this.otherMessageTheme,
    required this.ownMessageTheme,
    required this.messageInputTheme,
    required this.primaryIconTheme,
    required this.galleryHeaderTheme,
    required this.galleryFooterTheme,
    required this.messageListViewTheme,
    required this.voiceRecordingTheme,
    required this.pollCreatorTheme,
    required this.pollInteractorTheme,
    required this.pollResultsDialogTheme,
    required this.pollOptionsDialogTheme,
    required this.pollCommentsDialogTheme,
    required this.pollOptionVotesDialogTheme,
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
    final accentColor = colorTheme.accentPrimary;
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
      titleStyle: textTheme.headlineBold,
      subtitleStyle: textTheme.footnote.copyWith(
        color: const Color(0xff7A7A7A),
      ),
    );
    final channelPreviewTheme = StreamChannelPreviewThemeData(
      unreadCounterColor: colorTheme.accentError,
      avatarTheme: StreamAvatarThemeData(
        borderRadius: BorderRadius.circular(20),
        constraints: const BoxConstraints.tightFor(
          height: 40,
          width: 40,
        ),
      ),
      titleStyle: textTheme.bodyBold,
      subtitleStyle: textTheme.footnote.copyWith(
        color: const Color(0xff7A7A7A),
      ),
      lastMessageAtStyle: textTheme.footnote.copyWith(
        // ignore: deprecated_member_use
        color: colorTheme.textHighEmphasis.withOpacity(0.5),
      ),
      indicatorIconSize: 16,
    );
    return StreamChatThemeData.raw(
      textTheme: textTheme,
      colorTheme: colorTheme,
      primaryIconTheme: iconTheme,
      channelPreviewTheme: channelPreviewTheme,
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
      ownMessageTheme: StreamMessageThemeData(
        messageAuthorStyle:
            textTheme.footnote.copyWith(color: colorTheme.textLowEmphasis),
        messageTextStyle: textTheme.body,
        createdAtStyle:
            textTheme.footnote.copyWith(color: colorTheme.textLowEmphasis),
        repliesStyle: textTheme.footnoteBold.copyWith(color: accentColor),
        messageBackgroundColor: colorTheme.borders,
        messageBorderColor: colorTheme.borders,
        reactionsBackgroundColor: colorTheme.barsBg,
        reactionsBorderColor: colorTheme.borders,
        reactionsMaskColor: colorTheme.appBg,
        avatarTheme: StreamAvatarThemeData(
          borderRadius: BorderRadius.circular(20),
          constraints: const BoxConstraints.tightFor(
            height: 32,
            width: 32,
          ),
        ),
        messageLinksStyle: TextStyle(color: accentColor),
        urlAttachmentBackgroundColor: colorTheme.linkBg,
        urlAttachmentHostStyle: textTheme.bodyBold.copyWith(color: accentColor),
        urlAttachmentTitleStyle: textTheme.footnoteBold,
        urlAttachmentTextStyle: textTheme.footnote,
        urlAttachmentTitleMaxLine: 1,
        urlAttachmentTextMaxLine: 3,
      ),
      otherMessageTheme: StreamMessageThemeData(
        reactionsBackgroundColor: colorTheme.borders,
        reactionsBorderColor: colorTheme.borders,
        reactionsMaskColor: colorTheme.appBg,
        messageTextStyle: textTheme.body,
        createdAtStyle:
            textTheme.footnote.copyWith(color: colorTheme.textLowEmphasis),
        messageAuthorStyle:
            textTheme.footnote.copyWith(color: colorTheme.textLowEmphasis),
        repliesStyle: textTheme.footnoteBold.copyWith(color: accentColor),
        messageLinksStyle: TextStyle(color: accentColor),
        messageBackgroundColor: colorTheme.barsBg,
        messageBorderColor: colorTheme.borders,
        avatarTheme: StreamAvatarThemeData(
          borderRadius: BorderRadius.circular(20),
          constraints: const BoxConstraints.tightFor(
            height: 32,
            width: 32,
          ),
        ),
        urlAttachmentBackgroundColor: colorTheme.linkBg,
        urlAttachmentHostStyle: textTheme.bodyBold.copyWith(color: accentColor),
        urlAttachmentTitleStyle: textTheme.footnoteBold,
        urlAttachmentTextStyle: textTheme.footnote,
        urlAttachmentTitleMaxLine: 1,
        urlAttachmentTextMaxLine: 3,
      ),
      messageInputTheme: StreamMessageInputThemeData(
        borderRadius: BorderRadius.circular(20),
        sendAnimationDuration: const Duration(milliseconds: 300),
        actionButtonColor: colorTheme.accentPrimary,
        actionButtonIdleColor: colorTheme.textLowEmphasis,
        expandButtonColor: colorTheme.accentPrimary,
        sendButtonColor: colorTheme.accentPrimary,
        sendButtonIdleColor: colorTheme.disabled,
        inputBackgroundColor: colorTheme.barsBg,
        inputTextStyle: textTheme.body,
        linkHighlightColor: colorTheme.accentPrimary,
        idleBorderGradient: LinearGradient(
          colors: [
            colorTheme.disabled,
            colorTheme.disabled,
          ],
        ),
        activeBorderGradient: LinearGradient(
          colors: [
            colorTheme.disabled,
            colorTheme.disabled,
          ],
        ),
      ),
      galleryHeaderTheme: StreamGalleryHeaderThemeData(
        closeButtonColor: colorTheme.textHighEmphasis,
        backgroundColor: channelHeaderTheme.color,
        iconMenuPointColor: colorTheme.textHighEmphasis,
        titleTextStyle: textTheme.headlineBold,
        subtitleTextStyle: channelPreviewTheme.subtitleStyle,
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
        backgroundColor: colorTheme.barsBg,
      ),
      voiceRecordingTheme: colorTheme.brightness == Brightness.dark
          ? StreamVoiceRecordingThemeData.dark()
          : StreamVoiceRecordingThemeData.light(),
      pollCreatorTheme: StreamPollCreatorThemeData(
        backgroundColor: colorTheme.appBg,
        appBarBackgroundColor: colorTheme.barsBg,
        appBarElevation: 1,
        appBarTitleStyle: textTheme.headlineBold.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        questionTextFieldFillColor: colorTheme.inputBg,
        questionHeaderStyle: textTheme.headline.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        questionTextFieldStyle: textTheme.headline.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        questionTextFieldErrorStyle: textTheme.footnote.copyWith(
          color: colorTheme.accentError,
        ),
        questionTextFieldBorderRadius: BorderRadius.circular(12),
        optionsTextFieldFillColor: colorTheme.inputBg,
        optionsHeaderStyle: textTheme.headline.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        optionsTextFieldStyle: textTheme.headline.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        optionsTextFieldErrorStyle: textTheme.footnote.copyWith(
          color: colorTheme.accentError,
        ),
        optionsTextFieldBorderRadius: BorderRadius.circular(12),
        switchListTileFillColor: colorTheme.inputBg,
        switchListTileTitleStyle: textTheme.headline.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        switchListTileErrorStyle: textTheme.footnote.copyWith(
          color: colorTheme.accentError,
        ),
        switchListTileBorderRadius: BorderRadius.circular(12),
      ),
      pollInteractorTheme: StreamPollInteractorThemeData(
        pollTitleStyle: textTheme.headlineBold.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        pollSubtitleStyle: textTheme.footnote.copyWith(
          color: colorTheme.textLowEmphasis,
        ),
        pollOptionTextStyle: textTheme.headline.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        pollOptionVoteCountTextStyle: textTheme.footnote.copyWith(
          color: colorTheme.textLowEmphasis,
        ),
        pollOptionCheckboxShape: const CircleBorder(),
        pollOptionCheckboxCheckColor: Colors.white,
        pollOptionCheckboxActiveColor: colorTheme.accentPrimary,
        pollOptionCheckboxBorderSide: BorderSide(
          width: 2,
          color: colorTheme.disabled,
        ),
        pollOptionVotesProgressBarMinHeight: 4,
        pollOptionVotesProgressBarTrackColor: colorTheme.disabled,
        pollOptionVotesProgressBarValueColor: colorTheme.accentPrimary,
        pollOptionVotesProgressBarWinnerColor: colorTheme.accentInfo,
        pollOptionVotesProgressBarBorderRadius: BorderRadius.circular(4),
        pollActionButtonStyle: TextButton.styleFrom(
          textStyle: textTheme.headline,
          foregroundColor: colorTheme.accentPrimary,
        ),
        pollActionDialogTitleStyle: textTheme.headlineBold.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        pollActionDialogTextFieldStyle: textTheme.headline.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        pollActionDialogTextFieldBorderRadius: BorderRadius.circular(12),
        pollActionDialogTextFieldFillColor: colorTheme.inputBg,
      ),
      pollResultsDialogTheme: StreamPollResultsDialogThemeData(
        backgroundColor: colorTheme.appBg,
        appBarElevation: 1,
        appBarBackgroundColor: colorTheme.barsBg,
        appBarTitleTextStyle: textTheme.headlineBold.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        pollTitleTextStyle: textTheme.headlineBold.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        pollTitleDecoration: BoxDecoration(
          color: colorTheme.inputBg,
          borderRadius: BorderRadius.circular(12),
        ),
        pollOptionsDecoration: BoxDecoration(
          color: colorTheme.inputBg,
          borderRadius: BorderRadius.circular(12),
        ),
        pollOptionsWinnerDecoration: BoxDecoration(
          color: colorTheme.inputBg,
          borderRadius: BorderRadius.circular(12),
        ),
        pollOptionsTextStyle: textTheme.headlineBold.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        pollOptionsWinnerTextStyle: textTheme.headlineBold.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        pollOptionsVoteCountTextStyle: textTheme.headline.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        pollOptionsWinnerVoteCountTextStyle: textTheme.headline.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        pollOptionsShowAllVotesButtonStyle: TextButton.styleFrom(
          textStyle: textTheme.headline,
          foregroundColor: colorTheme.accentPrimary,
        ),
      ),
      pollOptionsDialogTheme: StreamPollOptionsDialogThemeData(
        backgroundColor: colorTheme.appBg,
        appBarElevation: 1,
        appBarBackgroundColor: colorTheme.barsBg,
        appBarTitleTextStyle: textTheme.headlineBold.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        pollTitleTextStyle: textTheme.headlineBold.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        pollTitleDecoration: BoxDecoration(
          color: colorTheme.inputBg,
          borderRadius: BorderRadius.circular(12),
        ),
        pollOptionsListViewDecoration: BoxDecoration(
          color: colorTheme.inputBg,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      pollCommentsDialogTheme: StreamPollCommentsDialogThemeData(
        backgroundColor: colorTheme.appBg,
        appBarElevation: 1,
        appBarBackgroundColor: colorTheme.barsBg,
        appBarTitleTextStyle: textTheme.headlineBold.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        pollCommentItemBackgroundColor: colorTheme.inputBg,
        pollCommentItemBorderRadius: BorderRadius.circular(12),
        updateYourCommentButtonStyle: TextButton.styleFrom(
          textStyle: textTheme.headlineBold,
          foregroundColor: colorTheme.accentPrimary,
          backgroundColor: colorTheme.inputBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
        ),
      ),
      pollOptionVotesDialogTheme: StreamPollOptionVotesDialogThemeData(
        backgroundColor: colorTheme.appBg,
        appBarElevation: 1,
        appBarBackgroundColor: colorTheme.barsBg,
        appBarTitleTextStyle: textTheme.headlineBold.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        pollOptionVoteCountTextStyle: textTheme.headline.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        pollOptionWinnerVoteCountTextStyle: textTheme.headline.copyWith(
          color: colorTheme.textHighEmphasis,
        ),
        pollOptionVoteItemBackgroundColor: colorTheme.inputBg,
        pollOptionVoteItemBorderRadius: BorderRadius.circular(12),
      ),
    );
  }

  /// The text themes used in the widgets
  final StreamTextTheme textTheme;

  /// The color themes used in the widgets
  final StreamColorTheme colorTheme;

  /// Theme of the [StreamChannelPreview]
  final StreamChannelPreviewThemeData channelPreviewTheme;

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

  /// Theme of the current user messages
  final StreamMessageThemeData ownMessageTheme;

  /// Theme of other users messages
  final StreamMessageThemeData otherMessageTheme;

  /// Theme dedicated to the [StreamMessageInput] widget
  final StreamMessageInputThemeData messageInputTheme;

  /// Primary icon theme
  final IconThemeData primaryIconTheme;

  /// Theme configuration for the [StreamMessageListView] widget.
  final StreamMessageListViewThemeData messageListViewTheme;

  /// Theme configuration for the [StreamVoiceRecordingListPLayer] widget.
  final StreamVoiceRecordingThemeData voiceRecordingTheme;

  /// Theme configuration for the [StreamPollCreatorWidget] widget.
  final StreamPollCreatorThemeData pollCreatorTheme;

  /// Theme configuration for the [StreamPollInteractor] widget.
  final StreamPollInteractorThemeData pollInteractorTheme;

  /// Theme configuration for the [StreamPollResultsDialog] widget.
  final StreamPollResultsDialogThemeData pollResultsDialogTheme;

  /// Theme configuration for the [StreamPollOptionsDialog] widget.
  final StreamPollOptionsDialogThemeData pollOptionsDialogTheme;

  /// Theme configuration for the [StreamPollCommentsDialog] widget.
  final StreamPollCommentsDialogThemeData pollCommentsDialogTheme;

  /// Theme configuration for the [StreamPollOptionVotesDialog] widget.
  final StreamPollOptionVotesDialogThemeData pollOptionVotesDialogTheme;

  /// Creates a copy of [StreamChatThemeData] with specified attributes
  /// overridden.
  StreamChatThemeData copyWith({
    StreamTextTheme? textTheme,
    StreamColorTheme? colorTheme,
    StreamChannelPreviewThemeData? channelPreviewTheme,
    StreamChannelHeaderThemeData? channelHeaderTheme,
    StreamMessageThemeData? ownMessageTheme,
    StreamMessageThemeData? otherMessageTheme,
    StreamMessageInputThemeData? messageInputTheme,
    Widget Function(BuildContext, User)? defaultUserImage,
    PlaceholderUserImage? placeholderUserImage,
    IconThemeData? primaryIconTheme,
    StreamChannelListHeaderThemeData? channelListHeaderTheme,
    @Deprecated('Use StreamChatConfigurationData.reactionIcons instead')
    List<StreamReactionIcon>? reactionIcons,
    StreamGalleryHeaderThemeData? galleryHeaderTheme,
    StreamGalleryFooterThemeData? galleryFooterTheme,
    StreamMessageListViewThemeData? messageListViewTheme,
    StreamVoiceRecordingThemeData? voiceRecordingTheme,
    StreamPollCreatorThemeData? pollCreatorTheme,
    StreamPollInteractorThemeData? pollInteractorTheme,
    StreamPollResultsDialogThemeData? pollResultsDialogTheme,
    StreamPollOptionsDialogThemeData? pollOptionsDialogTheme,
    StreamPollCommentsDialogThemeData? pollCommentsDialogTheme,
    StreamPollOptionVotesDialogThemeData? pollOptionVotesDialogTheme,
  }) =>
      StreamChatThemeData.raw(
        channelListHeaderTheme:
            this.channelListHeaderTheme.merge(channelListHeaderTheme),
        textTheme: this.textTheme.merge(textTheme),
        colorTheme: this.colorTheme.merge(colorTheme),
        primaryIconTheme: this.primaryIconTheme.merge(primaryIconTheme),
        channelPreviewTheme:
            this.channelPreviewTheme.merge(channelPreviewTheme),
        channelHeaderTheme: this.channelHeaderTheme.merge(channelHeaderTheme),
        ownMessageTheme: this.ownMessageTheme.merge(ownMessageTheme),
        otherMessageTheme: this.otherMessageTheme.merge(otherMessageTheme),
        messageInputTheme: this.messageInputTheme.merge(messageInputTheme),
        galleryHeaderTheme: galleryHeaderTheme ?? this.galleryHeaderTheme,
        galleryFooterTheme: galleryFooterTheme ?? this.galleryFooterTheme,
        messageListViewTheme: messageListViewTheme ?? this.messageListViewTheme,
        voiceRecordingTheme: voiceRecordingTheme ?? this.voiceRecordingTheme,
        pollCreatorTheme: pollCreatorTheme ?? this.pollCreatorTheme,
        pollInteractorTheme: pollInteractorTheme ?? this.pollInteractorTheme,
        pollResultsDialogTheme:
            pollResultsDialogTheme ?? this.pollResultsDialogTheme,
        pollOptionsDialogTheme:
            pollOptionsDialogTheme ?? this.pollOptionsDialogTheme,
        pollCommentsDialogTheme:
            pollCommentsDialogTheme ?? this.pollCommentsDialogTheme,
        pollOptionVotesDialogTheme:
            pollOptionVotesDialogTheme ?? this.pollOptionVotesDialogTheme,
      );

  /// Merge themes
  StreamChatThemeData merge(StreamChatThemeData? other) {
    if (other == null) return this;
    return copyWith(
      channelListHeaderTheme:
          channelListHeaderTheme.merge(other.channelListHeaderTheme),
      textTheme: textTheme.merge(other.textTheme),
      colorTheme: colorTheme.merge(other.colorTheme),
      primaryIconTheme: other.primaryIconTheme,
      channelPreviewTheme: channelPreviewTheme.merge(other.channelPreviewTheme),
      channelHeaderTheme: channelHeaderTheme.merge(other.channelHeaderTheme),
      ownMessageTheme: ownMessageTheme.merge(other.ownMessageTheme),
      otherMessageTheme: otherMessageTheme.merge(other.otherMessageTheme),
      messageInputTheme: messageInputTheme.merge(other.messageInputTheme),
      galleryHeaderTheme: galleryHeaderTheme.merge(other.galleryHeaderTheme),
      galleryFooterTheme: galleryFooterTheme.merge(other.galleryFooterTheme),
      messageListViewTheme:
          messageListViewTheme.merge(other.messageListViewTheme),
      voiceRecordingTheme: voiceRecordingTheme.merge(other.voiceRecordingTheme),
      pollCreatorTheme: pollCreatorTheme.merge(other.pollCreatorTheme),
      pollInteractorTheme: pollInteractorTheme.merge(other.pollInteractorTheme),
      pollResultsDialogTheme:
          pollResultsDialogTheme.merge(other.pollResultsDialogTheme),
      pollOptionsDialogTheme:
          pollOptionsDialogTheme.merge(other.pollOptionsDialogTheme),
      pollCommentsDialogTheme:
          pollCommentsDialogTheme.merge(other.pollCommentsDialogTheme),
      pollOptionVotesDialogTheme:
          pollOptionVotesDialogTheme.merge(other.pollOptionVotesDialogTheme),
    );
  }
}
