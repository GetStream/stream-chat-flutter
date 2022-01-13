import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide TextTheme;
import 'package:stream_chat_flutter/src/channel_preview.dart';
import 'package:stream_chat_flutter/src/gradient_avatar.dart';
import 'package:stream_chat_flutter/src/message_input/message_input.dart';
import 'package:stream_chat_flutter/src/reaction_icon.dart';
import 'package:stream_chat_flutter/src/theme/themes.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Inherited widget providing the [StreamChatThemeData] to the widget tree
class StreamChatTheme extends InheritedWidget {
  /// Constructor for creating a [StreamChatTheme]
  const StreamChatTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  /// Theme data
  final StreamChatThemeData data;

  @override
  bool updateShouldNotify(StreamChatTheme old) => data != old.data;

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

/// Theme data
class StreamChatThemeData {
  /// Create a theme from scratch
  factory StreamChatThemeData({
    Brightness? brightness,
    TextTheme? textTheme,
    ColorTheme? colorTheme,
    ChannelListHeaderThemeData? channelListHeaderTheme,
    ChannelPreviewThemeData? channelPreviewTheme,
    ChannelHeaderThemeData? channelHeaderTheme,
    MessageThemeData? otherMessageTheme,
    MessageThemeData? ownMessageTheme,
    MessageInputThemeData? messageInputTheme,
    Widget Function(BuildContext, User)? defaultUserImage,
    Widget Function(BuildContext, User)? placeholderUserImage,
    IconThemeData? primaryIconTheme,
    List<ReactionIcon>? reactionIcons,
    GalleryHeaderThemeData? imageHeaderTheme,
    GalleryFooterThemeData? imageFooterTheme,
    MessageListViewThemeData? messageListViewTheme,
    ChannelListViewThemeData? channelListViewTheme,
    UserListViewThemeData? userListViewTheme,
    MessageSearchListViewThemeData? messageSearchListViewTheme,
  }) {
    brightness ??= colorTheme?.brightness ?? Brightness.light;
    final isDark = brightness == Brightness.dark;
    textTheme ??= isDark ? TextTheme.dark() : TextTheme.light();
    colorTheme ??= isDark ? ColorTheme.dark() : ColorTheme.light();

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
      reactionIcons: reactionIcons,
      galleryHeaderTheme: imageHeaderTheme,
      galleryFooterTheme: imageFooterTheme,
      messageListViewTheme: messageListViewTheme,
      channelListViewTheme: channelListViewTheme,
      userListViewTheme: userListViewTheme,
      messageSearchListViewTheme: messageSearchListViewTheme,
    );

    return defaultData.merge(customizedData);
  }

  /// Theme initialised with light
  factory StreamChatThemeData.light() =>
      StreamChatThemeData(brightness: Brightness.light);

  /// Theme initialised with dark
  factory StreamChatThemeData.dark() =>
      StreamChatThemeData(brightness: Brightness.dark);

  /// Raw theme init
  const StreamChatThemeData.raw({
    required this.textTheme,
    required this.colorTheme,
    required this.channelListHeaderTheme,
    required this.channelPreviewTheme,
    required this.channelHeaderTheme,
    required this.otherMessageTheme,
    required this.ownMessageTheme,
    required this.messageInputTheme,
    required this.defaultUserImage,
    this.placeholderUserImage,
    required this.primaryIconTheme,
    required this.reactionIcons,
    required this.galleryHeaderTheme,
    required this.galleryFooterTheme,
    required this.messageListViewTheme,
    required this.channelListViewTheme,
    required this.userListViewTheme,
    required this.messageSearchListViewTheme,
  });

  /// Create a theme from a Material [Theme]
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

  /// Create theme from color and text theme
  factory StreamChatThemeData.fromColorAndTextTheme(
    ColorTheme colorTheme,
    TextTheme textTheme,
  ) {
    final accentColor = colorTheme.accentPrimary;
    final iconTheme =
        IconThemeData(color: colorTheme.textHighEmphasis.withOpacity(0.5));
    final channelHeaderTheme = ChannelHeaderThemeData(
      avatarTheme: AvatarThemeData(
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
    final channelPreviewTheme = ChannelPreviewThemeData(
      unreadCounterColor: colorTheme.accentError,
      avatarTheme: AvatarThemeData(
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
        color: colorTheme.textHighEmphasis.withOpacity(0.5),
      ),
      indicatorIconSize: 16,
    );
    return StreamChatThemeData.raw(
      textTheme: textTheme,
      colorTheme: colorTheme,
      primaryIconTheme: iconTheme,
      defaultUserImage: (context, user) => Center(
        child: GradientAvatar(
          name: user.name,
          userId: user.id,
        ),
      ),
      channelPreviewTheme: channelPreviewTheme,
      channelListHeaderTheme: ChannelListHeaderThemeData(
        avatarTheme: AvatarThemeData(
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
      ownMessageTheme: MessageThemeData(
        messageAuthorStyle:
            textTheme.footnote.copyWith(color: colorTheme.textLowEmphasis),
        messageTextStyle: textTheme.body,
        createdAtStyle:
            textTheme.footnote.copyWith(color: colorTheme.textLowEmphasis),
        repliesStyle: textTheme.footnoteBold.copyWith(color: accentColor),
        messageBackgroundColor: colorTheme.disabled,
        reactionsBackgroundColor: colorTheme.barsBg,
        reactionsBorderColor: colorTheme.borders,
        reactionsMaskColor: colorTheme.appBg,
        messageBorderColor: colorTheme.disabled,
        avatarTheme: AvatarThemeData(
          borderRadius: BorderRadius.circular(20),
          constraints: const BoxConstraints.tightFor(
            height: 32,
            width: 32,
          ),
        ),
        messageLinksStyle: TextStyle(
          color: accentColor,
        ),
        linkBackgroundColor: colorTheme.linkBg,
      ),
      otherMessageTheme: MessageThemeData(
        reactionsBackgroundColor: colorTheme.disabled,
        reactionsBorderColor: colorTheme.barsBg,
        reactionsMaskColor: colorTheme.appBg,
        messageTextStyle: textTheme.body,
        createdAtStyle:
            textTheme.footnote.copyWith(color: colorTheme.textLowEmphasis),
        messageAuthorStyle:
            textTheme.footnote.copyWith(color: colorTheme.textLowEmphasis),
        repliesStyle: textTheme.footnoteBold.copyWith(color: accentColor),
        messageLinksStyle: TextStyle(
          color: accentColor,
        ),
        messageBackgroundColor: colorTheme.barsBg,
        messageBorderColor: colorTheme.borders,
        avatarTheme: AvatarThemeData(
          borderRadius: BorderRadius.circular(20),
          constraints: const BoxConstraints.tightFor(
            height: 32,
            width: 32,
          ),
        ),
        linkBackgroundColor: colorTheme.linkBg,
      ),
      messageInputTheme: MessageInputThemeData(
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
      reactionIcons: [
        ReactionIcon(
          type: 'love',
          builder: (context, highlighted, size) {
            final theme = StreamChatTheme.of(context);
            return StreamSvgIcon.loveReaction(
              color: highlighted
                  ? theme.colorTheme.accentPrimary
                  : theme.primaryIconTheme.color!.withOpacity(0.5),
              size: size,
            );
          },
        ),
        ReactionIcon(
          type: 'like',
          builder: (context, highlighted, size) {
            final theme = StreamChatTheme.of(context);
            return StreamSvgIcon.thumbsUpReaction(
              color: highlighted
                  ? theme.colorTheme.accentPrimary
                  : theme.primaryIconTheme.color!.withOpacity(0.5),
              size: size,
            );
          },
        ),
        ReactionIcon(
          type: 'sad',
          builder: (context, highlighted, size) {
            final theme = StreamChatTheme.of(context);
            return StreamSvgIcon.thumbsDownReaction(
              color: highlighted
                  ? theme.colorTheme.accentPrimary
                  : theme.primaryIconTheme.color!.withOpacity(0.5),
              size: size,
            );
          },
        ),
        ReactionIcon(
          type: 'haha',
          builder: (context, highlighted, size) {
            final theme = StreamChatTheme.of(context);
            return StreamSvgIcon.lolReaction(
              color: highlighted
                  ? theme.colorTheme.accentPrimary
                  : theme.primaryIconTheme.color!.withOpacity(0.5),
              size: size,
            );
          },
        ),
        ReactionIcon(
          type: 'wow',
          builder: (context, highlighted, size) {
            final theme = StreamChatTheme.of(context);
            return StreamSvgIcon.wutReaction(
              color: highlighted
                  ? theme.colorTheme.accentPrimary
                  : theme.primaryIconTheme.color!.withOpacity(0.5),
              size: size,
            );
          },
        ),
      ],
      galleryHeaderTheme: GalleryHeaderThemeData(
        closeButtonColor: colorTheme.textHighEmphasis,
        backgroundColor: channelHeaderTheme.color,
        iconMenuPointColor: colorTheme.textHighEmphasis,
        titleTextStyle: textTheme.headlineBold,
        subtitleTextStyle: channelPreviewTheme.subtitleStyle,
        bottomSheetBarrierColor: colorTheme.overlay,
      ),
      galleryFooterTheme: GalleryFooterThemeData(
        backgroundColor: colorTheme.barsBg,
        shareIconColor: colorTheme.textHighEmphasis,
        titleTextStyle: textTheme.headlineBold,
        gridIconButtonColor: colorTheme.textHighEmphasis,
        bottomSheetBarrierColor: colorTheme.overlay,
        bottomSheetBackgroundColor: colorTheme.barsBg,
        bottomSheetPhotosTextStyle: textTheme.headlineBold,
        bottomSheetCloseIconColor: colorTheme.textHighEmphasis,
      ),
      messageListViewTheme: MessageListViewThemeData(
        backgroundColor: colorTheme.barsBg,
      ),
      channelListViewTheme: ChannelListViewThemeData(
        backgroundColor: colorTheme.appBg,
      ),
      userListViewTheme: UserListViewThemeData(
        backgroundColor: colorTheme.appBg,
      ),
      messageSearchListViewTheme: MessageSearchListViewThemeData(
        backgroundColor: colorTheme.appBg,
      ),
    );
  }

  /// The text themes used in the widgets
  final TextTheme textTheme;

  /// The color themes used in the widgets
  final ColorTheme colorTheme;

  /// Theme of the [ChannelPreview]
  final ChannelPreviewThemeData channelPreviewTheme;

  /// Theme of the [ChannelListHeader]
  final ChannelListHeaderThemeData channelListHeaderTheme;

  /// Theme of the chat widgets dedicated to a channel header
  final ChannelHeaderThemeData channelHeaderTheme;

  /// The default style for [GalleryHeader]s below the overall
  /// [StreamChatTheme].
  final GalleryHeaderThemeData galleryHeaderTheme;

  /// The default style for [GalleryFooter]s below the overall
  /// [StreamChatTheme].
  final GalleryFooterThemeData galleryFooterTheme;

  /// Theme of the current user messages
  final MessageThemeData ownMessageTheme;

  /// Theme of other users messages
  final MessageThemeData otherMessageTheme;

  /// Theme dedicated to the [MessageInput] widget
  final MessageInputThemeData messageInputTheme;

  /// The widget that will be built when the user image is unavailable
  final Widget Function(BuildContext, User) defaultUserImage;

  /// The widget that will be built when the user image is loading
  final Widget Function(BuildContext, User)? placeholderUserImage;

  /// Primary icon theme
  final IconThemeData primaryIconTheme;

  /// Assets used for rendering reactions
  final List<ReactionIcon> reactionIcons;

  /// Theme configuration for the [MessageListView] widget.
  final MessageListViewThemeData messageListViewTheme;

  /// Theme configuration for the [ChannelListView] widget.
  final ChannelListViewThemeData channelListViewTheme;

  /// Theme configuration for the [UserListView] widget.
  final UserListViewThemeData userListViewTheme;

  /// Theme configuration for the [MessageSearchListView] widget.
  final MessageSearchListViewThemeData messageSearchListViewTheme;

  /// Creates a copy of [StreamChatThemeData] with specified attributes
  /// overridden.
  StreamChatThemeData copyWith({
    TextTheme? textTheme,
    ColorTheme? colorTheme,
    ChannelPreviewThemeData? channelPreviewTheme,
    ChannelHeaderThemeData? channelHeaderTheme,
    MessageThemeData? ownMessageTheme,
    MessageThemeData? otherMessageTheme,
    MessageInputThemeData? messageInputTheme,
    Widget Function(BuildContext, User)? defaultUserImage,
    Widget Function(BuildContext, User)? placeholderUserImage,
    IconThemeData? primaryIconTheme,
    ChannelListHeaderThemeData? channelListHeaderTheme,
    List<ReactionIcon>? reactionIcons,
    GalleryHeaderThemeData? galleryHeaderTheme,
    GalleryFooterThemeData? galleryFooterTheme,
    MessageListViewThemeData? messageListViewTheme,
    ChannelListViewThemeData? channelListViewTheme,
    UserListViewThemeData? userListViewTheme,
    MessageSearchListViewThemeData? messageSearchListViewTheme,
  }) =>
      StreamChatThemeData.raw(
        channelListHeaderTheme:
            this.channelListHeaderTheme.merge(channelListHeaderTheme),
        textTheme: this.textTheme.merge(textTheme),
        colorTheme: this.colorTheme.merge(colorTheme),
        primaryIconTheme: this.primaryIconTheme.merge(primaryIconTheme),
        defaultUserImage: defaultUserImage ?? this.defaultUserImage,
        placeholderUserImage: placeholderUserImage ?? this.placeholderUserImage,
        channelPreviewTheme:
            this.channelPreviewTheme.merge(channelPreviewTheme),
        channelHeaderTheme: this.channelHeaderTheme.merge(channelHeaderTheme),
        ownMessageTheme: this.ownMessageTheme.merge(ownMessageTheme),
        otherMessageTheme: this.otherMessageTheme.merge(otherMessageTheme),
        messageInputTheme: this.messageInputTheme.merge(messageInputTheme),
        reactionIcons: reactionIcons ?? this.reactionIcons,
        galleryHeaderTheme: galleryHeaderTheme ?? this.galleryHeaderTheme,
        galleryFooterTheme: galleryFooterTheme ?? this.galleryFooterTheme,
        messageListViewTheme: messageListViewTheme ?? this.messageListViewTheme,
        channelListViewTheme: channelListViewTheme ?? this.channelListViewTheme,
        userListViewTheme: userListViewTheme ?? this.userListViewTheme,
        messageSearchListViewTheme:
            messageSearchListViewTheme ?? this.messageSearchListViewTheme,
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
      defaultUserImage: other.defaultUserImage,
      placeholderUserImage: other.placeholderUserImage,
      channelPreviewTheme: channelPreviewTheme.merge(other.channelPreviewTheme),
      channelHeaderTheme: channelHeaderTheme.merge(other.channelHeaderTheme),
      ownMessageTheme: ownMessageTheme.merge(other.ownMessageTheme),
      otherMessageTheme: otherMessageTheme.merge(other.otherMessageTheme),
      messageInputTheme: messageInputTheme.merge(other.messageInputTheme),
      reactionIcons: other.reactionIcons,
      galleryHeaderTheme: galleryHeaderTheme.merge(other.galleryHeaderTheme),
      galleryFooterTheme: galleryFooterTheme.merge(other.galleryFooterTheme),
      messageListViewTheme:
          messageListViewTheme.merge(other.messageListViewTheme),
      channelListViewTheme:
          channelListViewTheme.merge(other.channelListViewTheme),
      userListViewTheme: userListViewTheme.merge(other.userListViewTheme),
      messageSearchListViewTheme:
          messageSearchListViewTheme.merge(other.messageSearchListViewTheme),
    );
  }
}
