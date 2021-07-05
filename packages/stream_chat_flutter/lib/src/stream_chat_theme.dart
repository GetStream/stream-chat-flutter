import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/channel_header.dart';
import 'package:stream_chat_flutter/src/channel_preview.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/message_input.dart';
import 'package:stream_chat_flutter/src/reaction_icon.dart';
import 'package:stream_chat_flutter/src/utils.dart';
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
    ChannelListHeaderTheme? channelListHeaderTheme,
    ChannelPreviewTheme? channelPreviewTheme,
    ChannelTheme? channelTheme,
    MessageTheme? otherMessageTheme,
    MessageTheme? ownMessageTheme,
    MessageInputTheme? messageInputTheme,
    Widget Function(BuildContext, Channel)? defaultChannelImage,
    Widget Function(BuildContext, User)? defaultUserImage,
    IconThemeData? primaryIconTheme,
    List<ReactionIcon>? reactionIcons,
  }) {
    brightness ??= colorTheme?.brightness ?? Brightness.light;
    final isDark = brightness == Brightness.dark;
    textTheme ??= isDark ? TextTheme.dark() : TextTheme.light();
    colorTheme ??= isDark ? ColorTheme.dark() : ColorTheme.light();

    final defaultData = fromColorAndTextTheme(
      colorTheme,
      textTheme,
    );

    final customizedData = defaultData.copyWith(
      channelListHeaderTheme: channelListHeaderTheme,
      channelPreviewTheme: channelPreviewTheme,
      channelTheme: channelTheme,
      otherMessageTheme: otherMessageTheme,
      ownMessageTheme: ownMessageTheme,
      messageInputTheme: messageInputTheme,
      defaultChannelImage: defaultChannelImage,
      defaultUserImage: defaultUserImage,
      primaryIconTheme: primaryIconTheme,
      reactionIcons: reactionIcons,
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
    required this.channelTheme,
    required this.otherMessageTheme,
    required this.ownMessageTheme,
    required this.messageInputTheme,
    required this.defaultChannelImage,
    required this.defaultUserImage,
    required this.primaryIconTheme,
    required this.reactionIcons,
  });

  /// Create a theme from a Material [Theme]
  factory StreamChatThemeData.fromTheme(ThemeData theme) {
    final defaultTheme = StreamChatThemeData(brightness: theme.brightness);
    final customizedTheme = StreamChatThemeData.fromColorAndTextTheme(
      defaultTheme.colorTheme.copyWith(
        accentPrimary: theme.accentColor,
      ),
      defaultTheme.textTheme,
    );
    return defaultTheme.merge(customizedTheme);
  }

  /// The text themes used in the widgets
  final TextTheme textTheme;

  /// The color themes used in the widgets
  final ColorTheme colorTheme;

  /// Theme of the [ChannelPreview]
  final ChannelPreviewTheme channelPreviewTheme;

  /// Theme of the [ChannelListHeader]
  final ChannelListHeaderTheme channelListHeaderTheme;

  /// Theme of the chat widgets dedicated to a channel
  final ChannelTheme channelTheme;

  /// Theme of the current user messages
  final MessageTheme ownMessageTheme;

  /// Theme of other users messages
  final MessageTheme otherMessageTheme;

  /// Theme dedicated to the [MessageInput] widget
  final MessageInputTheme messageInputTheme;

  /// The widget that will be built when the channel image is unavailable
  final Widget Function(BuildContext, Channel) defaultChannelImage;

  /// The widget that will be built when the user image is unavailable
  final Widget Function(BuildContext, User) defaultUserImage;

  /// Primary icon theme
  final IconThemeData primaryIconTheme;

  /// Assets used for rendering reactions
  final List<ReactionIcon> reactionIcons;

  /// Creates a copy of [StreamChatThemeData] with specified attributes
  /// overridden.
  StreamChatThemeData copyWith({
    TextTheme? textTheme,
    ColorTheme? colorTheme,
    ChannelPreviewTheme? channelPreviewTheme,
    ChannelTheme? channelTheme,
    MessageTheme? ownMessageTheme,
    MessageTheme? otherMessageTheme,
    MessageInputTheme? messageInputTheme,
    Widget Function(BuildContext, Channel)? defaultChannelImage,
    Widget Function(BuildContext, User)? defaultUserImage,
    IconThemeData? primaryIconTheme,
    ChannelListHeaderTheme? channelListHeaderTheme,
    List<ReactionIcon>? reactionIcons,
  }) =>
      StreamChatThemeData.raw(
        channelListHeaderTheme:
            this.channelListHeaderTheme.merge(channelListHeaderTheme),
        textTheme: this.textTheme.merge(textTheme),
        colorTheme: this.colorTheme.merge(colorTheme),
        primaryIconTheme: this.primaryIconTheme.merge(primaryIconTheme),
        defaultChannelImage: defaultChannelImage ?? this.defaultChannelImage,
        defaultUserImage: defaultUserImage ?? this.defaultUserImage,
        channelPreviewTheme:
            this.channelPreviewTheme.merge(channelPreviewTheme),
        channelTheme: this.channelTheme.merge(channelTheme),
        ownMessageTheme: this.ownMessageTheme.merge(ownMessageTheme),
        otherMessageTheme: this.otherMessageTheme.merge(otherMessageTheme),
        messageInputTheme: this.messageInputTheme.merge(messageInputTheme),
        reactionIcons: reactionIcons ?? this.reactionIcons,
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
      defaultChannelImage: other.defaultChannelImage,
      defaultUserImage: other.defaultUserImage,
      channelPreviewTheme: channelPreviewTheme.merge(other.channelPreviewTheme),
      channelTheme: channelTheme.merge(other.channelTheme),
      ownMessageTheme: ownMessageTheme.merge(other.ownMessageTheme),
      otherMessageTheme: otherMessageTheme.merge(other.otherMessageTheme),
      messageInputTheme: messageInputTheme.merge(other.messageInputTheme),
      reactionIcons: other.reactionIcons,
    );
  }

  /// Create theme from color and text theme
  // ignore: prefer_constructors_over_static_methods
  static StreamChatThemeData fromColorAndTextTheme(
    ColorTheme colorTheme,
    TextTheme textTheme,
  ) {
    final accentColor = colorTheme.accentPrimary;
    final iconTheme =
        IconThemeData(color: colorTheme.textHighEmphasis.withOpacity(.5));
    return StreamChatThemeData.raw(
      textTheme: textTheme,
      colorTheme: colorTheme,
      primaryIconTheme: iconTheme,
      defaultChannelImage: (context, channel) => const SizedBox(),
      defaultUserImage: (context, user) => Center(
        child: CachedNetworkImage(
          filterQuality: FilterQuality.high,
          imageUrl: getRandomPicUrl(user),
          fit: BoxFit.cover,
        ),
      ),
      channelPreviewTheme: ChannelPreviewTheme(
        unreadCounterColor: colorTheme.accentError,
        avatarTheme: AvatarTheme(
          borderRadius: BorderRadius.circular(20),
          constraints: const BoxConstraints.tightFor(
            height: 40,
            width: 40,
          ),
        ),
        title: textTheme.bodyBold,
        subtitle: textTheme.footnote.copyWith(
          color: const Color(0xff7A7A7A),
        ),
        lastMessageAt: textTheme.footnote.copyWith(
          color: colorTheme.textHighEmphasis.withOpacity(.5),
        ),
        indicatorIconSize: 16,
      ),
      channelListHeaderTheme: ChannelListHeaderTheme(
        avatarTheme: AvatarTheme(
          borderRadius: BorderRadius.circular(20),
          constraints: const BoxConstraints.tightFor(
            height: 40,
            width: 40,
          ),
        ),
        color: colorTheme.barsBg,
        title: textTheme.headlineBold,
      ),
      channelTheme: ChannelTheme(
        channelHeaderTheme: ChannelHeaderTheme(
          avatarTheme: AvatarTheme(
            borderRadius: BorderRadius.circular(20),
            constraints: const BoxConstraints.tightFor(
              height: 40,
              width: 40,
            ),
          ),
          color: colorTheme.barsBg,
          title: textTheme.headlineBold,
          subtitle: textTheme.footnote.copyWith(
            color: const Color(0xff7A7A7A),
          ),
        ),
      ),
      ownMessageTheme: MessageTheme(
        messageAuthor:
            textTheme.footnote.copyWith(color: colorTheme.textLowEmphasis),
        messageText: textTheme.body,
        createdAt:
            textTheme.footnote.copyWith(color: colorTheme.textLowEmphasis),
        replies: textTheme.footnoteBold.copyWith(color: accentColor),
        messageBackgroundColor: colorTheme.disabled,
        reactionsBackgroundColor: colorTheme.barsBg,
        reactionsBorderColor: colorTheme.borders,
        reactionsMaskColor: colorTheme.appBg,
        messageBorderColor: colorTheme.disabled,
        avatarTheme: AvatarTheme(
          borderRadius: BorderRadius.circular(20),
          constraints: const BoxConstraints.tightFor(
            height: 32,
            width: 32,
          ),
        ),
        messageLinks: TextStyle(
          color: accentColor,
        ),
      ),
      otherMessageTheme: MessageTheme(
        reactionsBackgroundColor: colorTheme.disabled,
        reactionsBorderColor: colorTheme.barsBg,
        reactionsMaskColor: colorTheme.appBg,
        messageText: textTheme.body,
        createdAt:
            textTheme.footnote.copyWith(color: colorTheme.textLowEmphasis),
        messageAuthor:
            textTheme.footnote.copyWith(color: colorTheme.textLowEmphasis),
        replies: textTheme.footnoteBold.copyWith(color: accentColor),
        messageLinks: TextStyle(
          color: accentColor,
        ),
        messageBackgroundColor: colorTheme.barsBg,
        messageBorderColor: colorTheme.borders,
        avatarTheme: AvatarTheme(
          borderRadius: BorderRadius.circular(20),
          constraints: const BoxConstraints.tightFor(
            height: 32,
            width: 32,
          ),
        ),
      ),
      messageInputTheme: MessageInputTheme(
        borderRadius: BorderRadius.circular(20),
        sendAnimationDuration: const Duration(milliseconds: 300),
        actionButtonColor: colorTheme.accentPrimary,
        actionButtonIdleColor: colorTheme.textLowEmphasis,
        expandButtonColor: colorTheme.accentPrimary,
        sendButtonColor: colorTheme.accentPrimary,
        sendButtonIdleColor: colorTheme.disabled,
        inputBackground: colorTheme.barsBg,
        inputTextStyle: textTheme.body,
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
                  : theme.primaryIconTheme.color!.withOpacity(.5),
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
                  : theme.primaryIconTheme.color!.withOpacity(.5),
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
                  : theme.primaryIconTheme.color!.withOpacity(.5),
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
                  : theme.primaryIconTheme.color!.withOpacity(.5),
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
                  : theme.primaryIconTheme.color!.withOpacity(.5),
              size: size,
            );
          },
        ),
      ],
    );
  }
}

/// Class for holding text theme
class TextTheme {
  /// Initialise light text theme
  TextTheme.light({
    this.title = const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    this.headlineBold = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    this.headline = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    this.bodyBold = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    this.body = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    this.footnoteBold = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    this.footnote = const TextStyle(
      fontSize: 12,
      color: Colors.black,
    ),
    this.captionBold = const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  });

  /// Initialise with dark theme
  TextTheme.dark({
    this.title = const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    this.headlineBold = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    this.headline = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    this.bodyBold = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    this.body = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    this.footnoteBold = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    this.footnote = const TextStyle(
      fontSize: 12,
      color: Colors.white,
    ),
    this.captionBold = const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  });

  /// Text theme for title
  final TextStyle title;

  /// Body Text theme for headline
  final TextStyle headlineBold;

  /// Text theme for headline
  final TextStyle headline;

  /// Bold Text theme for body
  final TextStyle bodyBold;

  /// Text theme body
  final TextStyle body;

  /// Bold Text theme for footnote
  final TextStyle footnoteBold;

  /// Text theme for footnote
  final TextStyle footnote;

  /// Bold Text theme for caption
  final TextStyle captionBold;

  /// Copy with theme
  TextTheme copyWith({
    Brightness brightness = Brightness.light,
    TextStyle? body,
    TextStyle? title,
    TextStyle? headlineBold,
    TextStyle? headline,
    TextStyle? bodyBold,
    TextStyle? footnoteBold,
    TextStyle? footnote,
    TextStyle? captionBold,
  }) =>
      brightness == Brightness.light
          ? TextTheme.light(
              body: body ?? this.body,
              title: title ?? this.title,
              headlineBold: headlineBold ?? this.headlineBold,
              headline: headline ?? this.headline,
              bodyBold: bodyBold ?? this.bodyBold,
              footnoteBold: footnoteBold ?? this.footnoteBold,
              footnote: footnote ?? this.footnote,
              captionBold: captionBold ?? this.captionBold,
            )
          : TextTheme.dark(
              body: body ?? this.body,
              title: title ?? this.title,
              headlineBold: headlineBold ?? this.headlineBold,
              headline: headline ?? this.headline,
              bodyBold: bodyBold ?? this.bodyBold,
              footnoteBold: footnoteBold ?? this.footnoteBold,
              footnote: footnote ?? this.footnote,
              captionBold: captionBold ?? this.captionBold,
            );

  /// Merge text theme
  TextTheme merge(TextTheme? other) {
    if (other == null) return this;
    return copyWith(
      body: body.merge(other.body),
      title: title.merge(other.title),
      headlineBold: headlineBold.merge(other.headlineBold),
      headline: headline.merge(other.headline),
      bodyBold: bodyBold.merge(other.bodyBold),
      footnoteBold: footnoteBold.merge(other.footnoteBold),
      footnote: footnote.merge(other.footnote),
      captionBold: captionBold.merge(other.captionBold),
    );
  }
}

/// Theme that holds colors
class ColorTheme {
  /// Initialise with light theme
  ColorTheme.light({
    this.textHighEmphasis = const Color(0xff000000),
    this.textLowEmphasis = const Color(0xff7a7a7a),
    this.disabled = const Color(0xffdbdbdb),
    this.borders = const Color(0xffecebeb),
    this.inputBg = const Color(0xfff2f2f2),
    this.appBg = const Color(0xfffcfcfc),
    this.barsBg = const Color(0xffffffff),
    this.linkBg = const Color(0xffe9f2ff),
    this.accentPrimary = const Color(0xff005FFF),
    this.accentError = const Color(0xffFF3842),
    this.accentInfo = const Color(0xff20E070),
    this.highlight = const Color(0xfffbf4dd),
    this.overlay = const Color.fromRGBO(0, 0, 0, 0.2),
    this.overlayDark = const Color.fromRGBO(0, 0, 0, 0.6),
    this.bgGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xfff7f7f7), Color(0xfffcfcfc)],
      stops: [0, 1],
    ),
    this.borderTop = const Effect(
        sigmaX: 0, sigmaY: -1, color: Color(0xff000000), blur: 0, alpha: 0.08),
    this.borderBottom = const Effect(
        sigmaX: 0, sigmaY: 1, color: Color(0xff000000), blur: 0, alpha: 0.08),
    this.shadowIconButton = const Effect(
        sigmaX: 0, sigmaY: 2, color: Color(0xff000000), alpha: 0.5, blur: 4),
    this.modalShadow = const Effect(
        sigmaX: 0, sigmaY: 0, color: Color(0xff000000), alpha: 1, blur: 8),
  }) : brightness = Brightness.light;

  /// Initialise with dark theme
  ColorTheme.dark({
    this.textHighEmphasis = const Color(0xffffffff),
    this.textLowEmphasis = const Color(0xff7a7a7a),
    this.disabled = const Color(0xff2d2f2f),
    this.borders = const Color(0xff1c1e22),
    this.inputBg = const Color(0xff13151b),
    this.appBg = const Color(0xff070A0D),
    this.barsBg = const Color(0xff101418),
    this.linkBg = const Color(0xff00193D),
    this.accentPrimary = const Color(0xff005FFF),
    this.accentError = const Color(0xffFF3742),
    this.accentInfo = const Color(0xff20E070),
    this.borderTop = const Effect(
      sigmaX: 0,
      sigmaY: -1,
      color: Color(0xff141924),
      blur: 0,
    ),
    this.borderBottom = const Effect(
      sigmaX: 0,
      sigmaY: 1,
      color: Color(0xff141924),
      blur: 0,
      alpha: 1,
    ),
    this.shadowIconButton = const Effect(
      sigmaX: 0,
      sigmaY: 2,
      color: Color(0xff000000),
      alpha: 0.5,
      blur: 4,
    ),
    this.modalShadow = const Effect(
      sigmaX: 0,
      sigmaY: 0,
      color: Color(0xff000000),
      alpha: 1,
      blur: 8,
    ),
    this.highlight = const Color(0xff302d22),
    this.overlay = const Color.fromRGBO(0, 0, 0, 0.4),
    this.overlayDark = const Color.fromRGBO(255, 255, 255, 0.6),
    this.bgGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xff101214),
        Color(0xff070a0d),
      ],
      stops: [0, 1],
    ),
  }) : brightness = Brightness.dark;

  ///
  final Color textHighEmphasis;

  ///
  final Color textLowEmphasis;

  ///
  final Color disabled;

  ///
  final Color borders;

  ///
  final Color inputBg;

  ///
  final Color appBg;

  ///
  final Color barsBg;

  ///
  final Color linkBg;

  ///
  final Color accentPrimary;

  ///
  final Color accentError;

  ///
  final Color accentInfo;

  ///
  final Effect borderTop;

  ///
  final Effect borderBottom;

  ///
  final Effect shadowIconButton;

  ///
  final Effect modalShadow;

  ///
  final Color highlight;

  ///
  final Color overlay;

  ///
  final Color overlayDark;

  ///
  final Gradient bgGradient;

  ///
  final Brightness brightness;

  /// Copy with theme
  ColorTheme copyWith({
    Brightness brightness = Brightness.light,
    Color? textHighEmphasis,
    Color? textLowEmphasis,
    Color? disabled,
    Color? borders,
    Color? inputBg,
    Color? appBg,
    Color? barsBg,
    Color? linkBg,
    Color? accentPrimary,
    Color? accentError,
    Color? accentInfo,
    Effect? borderTop,
    Effect? borderBottom,
    Effect? shadowIconButton,
    Effect? modalShadow,
    Color? highlight,
    Color? overlay,
    Color? overlayDark,
    Gradient? bgGradient,
  }) =>
      brightness == Brightness.light
          ? ColorTheme.light(
              textHighEmphasis: textHighEmphasis ?? this.textHighEmphasis,
              textLowEmphasis: textLowEmphasis ?? this.textLowEmphasis,
              disabled: disabled ?? this.disabled,
              borders: borders ?? this.borders,
              inputBg: inputBg ?? this.inputBg,
              appBg: appBg ?? this.appBg,
              barsBg: barsBg ?? this.barsBg,
              linkBg: linkBg ?? this.linkBg,
              accentPrimary: accentPrimary ?? this.accentPrimary,
              accentError: accentError ?? this.accentError,
              accentInfo: accentInfo ?? this.accentInfo,
              borderTop: borderTop ?? this.borderTop,
              borderBottom: borderBottom ?? this.borderBottom,
              shadowIconButton: shadowIconButton ?? this.shadowIconButton,
              modalShadow: modalShadow ?? this.modalShadow,
              highlight: highlight ?? this.highlight,
              overlay: overlay ?? this.overlay,
              overlayDark: overlayDark ?? this.overlayDark,
              bgGradient: bgGradient ?? this.bgGradient,
            )
          : ColorTheme.dark(
              textHighEmphasis: textHighEmphasis ?? this.textHighEmphasis,
              textLowEmphasis: textLowEmphasis ?? this.textLowEmphasis,
              disabled: disabled ?? this.disabled,
              borders: borders ?? this.borders,
              inputBg: inputBg ?? this.inputBg,
              appBg: appBg ?? this.appBg,
              barsBg: barsBg ?? this.barsBg,
              linkBg: linkBg ?? this.linkBg,
              accentPrimary: accentPrimary ?? this.accentPrimary,
              accentError: accentError ?? this.accentError,
              accentInfo: accentInfo ?? this.accentInfo,
              borderTop: borderTop ?? this.borderTop,
              borderBottom: borderBottom ?? this.borderBottom,
              shadowIconButton: shadowIconButton ?? this.shadowIconButton,
              modalShadow: modalShadow ?? this.modalShadow,
              highlight: highlight ?? this.highlight,
              overlay: overlay ?? this.overlay,
              overlayDark: overlayDark ?? this.overlayDark,
              bgGradient: bgGradient ?? this.bgGradient,
            );

  /// Merge color theme
  ColorTheme merge(ColorTheme? other) {
    if (other == null) return this;
    return copyWith(
      textHighEmphasis: other.textHighEmphasis,
      textLowEmphasis: other.textLowEmphasis,
      disabled: other.disabled,
      borders: other.borders,
      inputBg: other.inputBg,
      appBg: other.appBg,
      barsBg: other.barsBg,
      linkBg: other.linkBg,
      accentPrimary: other.accentPrimary,
      accentError: other.accentError,
      accentInfo: other.accentInfo,
      highlight: other.highlight,
      overlay: other.overlay,
      overlayDark: other.overlayDark,
      bgGradient: other.bgGradient,
      borderTop: other.borderTop,
      borderBottom: other.borderBottom,
      shadowIconButton: other.shadowIconButton,
      modalShadow: other.modalShadow,
    );
  }
}

/// Channel theme data
class ChannelTheme {
  /// Constructor for creating [ChannelTheme]
  ChannelTheme({
    required this.channelHeaderTheme,
  });

  /// Theme of the [ChannelHeader] widget
  final ChannelHeaderTheme channelHeaderTheme;

  /// Creates a copy of [ChannelTheme] with specified attributes overridden.
  ChannelTheme copyWith({
    ChannelHeaderTheme? channelHeaderTheme,
  }) =>
      ChannelTheme(
        channelHeaderTheme: channelHeaderTheme ?? this.channelHeaderTheme,
      );

  /// Merge with theme
  ChannelTheme merge(ChannelTheme? other) {
    if (other == null) return this;
    return copyWith(
      channelHeaderTheme: channelHeaderTheme.merge(other.channelHeaderTheme),
    );
  }
}

/// Theme for avatar
class AvatarTheme {
  /// Constructor for creating [AvatarTheme]
  AvatarTheme({
    BoxConstraints? constraints,
    BorderRadius? borderRadius,
  })  : _constraints = constraints,
        _borderRadius = borderRadius;

  final BoxConstraints? _constraints;
  final BorderRadius? _borderRadius;

  /// Get constraints for avatar
  BoxConstraints get constraints =>
      _constraints ??
      const BoxConstraints.tightFor(
        height: 32,
        width: 32,
      );

  /// Get border radius
  BorderRadius get borderRadius => _borderRadius ?? BorderRadius.circular(20);

  /// Copy with another theme
  AvatarTheme copyWith({
    BoxConstraints? constraints,
    BorderRadius? borderRadius,
  }) =>
      AvatarTheme(
        constraints: constraints ?? _constraints,
        borderRadius: borderRadius ?? _borderRadius,
      );

  /// Merge with another AvatarTheme
  AvatarTheme merge(AvatarTheme? other) {
    if (other == null) return this;
    return copyWith(
      constraints: other._constraints,
      borderRadius: other._borderRadius,
    );
  }
}

/// Class for getting message theme
class MessageTheme {
  /// Constructor into [MessageTheme]
  const MessageTheme({
    this.replies,
    this.messageText,
    this.messageAuthor,
    this.messageLinks,
    this.messageBackgroundColor,
    this.messageBorderColor,
    this.reactionsBackgroundColor,
    this.reactionsBorderColor,
    this.reactionsMaskColor,
    this.avatarTheme,
    this.createdAt,
  });

  /// Text style for message text
  final TextStyle? messageText;

  /// Text style for message author
  final TextStyle? messageAuthor;

  /// Text style for message links
  final TextStyle? messageLinks;

  /// Text style for created at text
  final TextStyle? createdAt;

  /// Text style for replies
  final TextStyle? replies;

  /// Color for messageBackgroundColor
  final Color? messageBackgroundColor;

  /// Color for message border color
  final Color? messageBorderColor;

  /// Color for reactions
  final Color? reactionsBackgroundColor;

  /// Colors reaction border
  final Color? reactionsBorderColor;

  /// Color for reaction mask
  final Color? reactionsMaskColor;

  /// Theme of the avatar
  final AvatarTheme? avatarTheme;

  /// Copy with a theme
  MessageTheme copyWith({
    TextStyle? messageText,
    TextStyle? messageAuthor,
    TextStyle? messageLinks,
    TextStyle? createdAt,
    TextStyle? replies,
    Color? messageBackgroundColor,
    Color? messageBorderColor,
    AvatarTheme? avatarTheme,
    Color? reactionsBackgroundColor,
    Color? reactionsBorderColor,
    Color? reactionsMaskColor,
  }) =>
      MessageTheme(
        messageText: messageText ?? this.messageText,
        messageAuthor: messageAuthor ?? this.messageAuthor,
        messageLinks: messageLinks ?? this.messageLinks,
        createdAt: createdAt ?? this.createdAt,
        messageBackgroundColor:
            messageBackgroundColor ?? this.messageBackgroundColor,
        messageBorderColor: messageBorderColor ?? this.messageBorderColor,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        replies: replies ?? this.replies,
        reactionsBackgroundColor:
            reactionsBackgroundColor ?? this.reactionsBackgroundColor,
        reactionsBorderColor: reactionsBorderColor ?? this.reactionsBorderColor,
        reactionsMaskColor: reactionsMaskColor ?? this.reactionsMaskColor,
      );

  /// Merge with a theme
  MessageTheme merge(MessageTheme? other) {
    if (other == null) return this;
    return copyWith(
      messageText: messageText?.merge(other.messageText) ?? other.messageText,
      messageAuthor:
          messageAuthor?.merge(other.messageAuthor) ?? other.messageAuthor,
      messageLinks:
          messageLinks?.merge(other.messageLinks) ?? other.messageLinks,
      createdAt: createdAt?.merge(other.createdAt) ?? other.createdAt,
      replies: replies?.merge(other.replies) ?? other.replies,
      messageBackgroundColor: other.messageBackgroundColor,
      messageBorderColor: other.messageBorderColor,
      avatarTheme: avatarTheme?.merge(other.avatarTheme) ?? other.avatarTheme,
      reactionsBackgroundColor: other.reactionsBackgroundColor,
      reactionsBorderColor: other.reactionsBorderColor,
      reactionsMaskColor: other.reactionsMaskColor,
    );
  }
}

/// Theme for channel preview
class ChannelPreviewTheme {
  /// Constructor for creating [ChannelPreviewTheme]
  const ChannelPreviewTheme({
    this.title,
    this.subtitle,
    this.lastMessageAt,
    this.avatarTheme,
    this.unreadCounterColor,
    this.indicatorIconSize,
  });

  /// Theme for title
  final TextStyle? title;

  /// Theme for subtitle
  final TextStyle? subtitle;

  /// Theme of last message at
  final TextStyle? lastMessageAt;

  /// Avatar theme
  final AvatarTheme? avatarTheme;

  /// Unread counter color
  final Color? unreadCounterColor;

  /// Indicator icon size
  final double? indicatorIconSize;

  /// Copy with theme
  ChannelPreviewTheme copyWith({
    TextStyle? title,
    TextStyle? subtitle,
    TextStyle? lastMessageAt,
    AvatarTheme? avatarTheme,
    Color? unreadCounterColor,
    double? indicatorIconSize,
  }) =>
      ChannelPreviewTheme(
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        lastMessageAt: lastMessageAt ?? this.lastMessageAt,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        unreadCounterColor: unreadCounterColor ?? this.unreadCounterColor,
        indicatorIconSize: indicatorIconSize ?? this.indicatorIconSize,
      );

  /// Merge with theme
  ChannelPreviewTheme merge(ChannelPreviewTheme? other) {
    if (other == null) return this;
    return copyWith(
      title: title?.merge(other.title) ?? other.title,
      subtitle: subtitle?.merge(other.subtitle) ?? other.subtitle,
      lastMessageAt:
          lastMessageAt?.merge(other.lastMessageAt) ?? other.lastMessageAt,
      avatarTheme: avatarTheme?.merge(other.avatarTheme) ?? other.avatarTheme,
      unreadCounterColor: other.unreadCounterColor,
    );
  }
}

/// Theme for [ChannelHeader]
class ChannelHeaderTheme {
  /// Constructor for creating a [ChannelHeaderTheme]
  const ChannelHeaderTheme({
    this.title,
    this.subtitle,
    this.avatarTheme,
    this.color,
  });

  /// Theme for title
  final TextStyle? title;

  /// Theme for subtitle
  final TextStyle? subtitle;

  /// Theme for avatar
  final AvatarTheme? avatarTheme;

  /// Color for [ChannelHeaderTheme]
  final Color? color;

  /// Copy with theme
  ChannelHeaderTheme copyWith({
    TextStyle? title,
    TextStyle? subtitle,
    AvatarTheme? avatarTheme,
    Color? color,
  }) =>
      ChannelHeaderTheme(
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        color: color ?? this.color,
      );

  /// Merge with other [ChannelHeaderTheme]
  ChannelHeaderTheme merge(ChannelHeaderTheme? other) {
    if (other == null) return this;
    return copyWith(
      title: title?.merge(other.title) ?? other.title,
      subtitle: subtitle?.merge(other.subtitle) ?? other.subtitle,
      avatarTheme: avatarTheme?.merge(other.avatarTheme) ?? other.avatarTheme,
      color: other.color,
    );
  }
}

/// Theme dedicated to the [ChannelListHeader]
class ChannelListHeaderTheme {
  /// Returns a new [ChannelListHeaderTheme]
  const ChannelListHeaderTheme({
    this.title,
    this.avatarTheme,
    this.color,
  });

  /// Style of the title text
  final TextStyle? title;

  /// Theme dedicated to the userAvatar
  final AvatarTheme? avatarTheme;

  /// Background color of the appbar
  final Color? color;

  /// Returns a new [ChannelListHeaderTheme] replacing some of its properties
  ChannelListHeaderTheme copyWith({
    TextStyle? title,
    AvatarTheme? avatarTheme,
    Color? color,
  }) =>
      ChannelListHeaderTheme(
        title: title ?? this.title,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        color: color ?? this.color,
      );

  /// Merges [this] [ChannelListHeaderTheme] with the [other]
  ChannelListHeaderTheme merge(ChannelListHeaderTheme? other) {
    if (other == null) return this;
    return copyWith(
      title: title?.merge(other.title) ?? other.title,
      avatarTheme: avatarTheme?.merge(other.avatarTheme) ?? other.avatarTheme,
      color: other.color,
    );
  }
}

/// Defines the theme dedicated to the [MessageInput] widget
class MessageInputTheme {
  /// Returns a new [MessageInputTheme]
  const MessageInputTheme({
    this.sendAnimationDuration,
    this.actionButtonColor,
    this.sendButtonColor,
    this.actionButtonIdleColor,
    this.sendButtonIdleColor,
    this.inputBackground,
    this.inputTextStyle,
    this.inputDecoration,
    this.activeBorderGradient,
    this.idleBorderGradient,
    this.borderRadius,
    this.expandButtonColor,
  });

  /// Duration of the [MessageInput] send button animation
  final Duration? sendAnimationDuration;

  /// Background color of [MessageInput] send button
  final Color? sendButtonColor;

  /// Background color of [MessageInput] action buttons
  final Color? actionButtonColor;

  /// Background color of [MessageInput] send button
  final Color? sendButtonIdleColor;

  /// Background color of [MessageInput] action buttons
  final Color? actionButtonIdleColor;

  /// Background color of [MessageInput] expand button
  final Color? expandButtonColor;

  /// Background color of [MessageInput]
  final Color? inputBackground;

  /// TextStyle of [MessageInput]
  final TextStyle? inputTextStyle;

  /// InputDecoration of [MessageInput]
  final InputDecoration? inputDecoration;

  /// Border gradient when the [MessageInput] is not focused
  final Gradient? idleBorderGradient;

  /// Border gradient when the [MessageInput] is focused
  final Gradient? activeBorderGradient;

  /// Border radius of [MessageInput]
  final BorderRadius? borderRadius;

  /// Returns a new [MessageInputTheme] replacing some of its properties
  MessageInputTheme copyWith({
    Duration? sendAnimationDuration,
    Color? inputBackground,
    Color? actionButtonColor,
    Color? sendButtonColor,
    Color? actionButtonIdleColor,
    Color? sendButtonIdleColor,
    Color? expandButtonColor,
    TextStyle? inputTextStyle,
    InputDecoration? inputDecoration,
    Gradient? activeBorderGradient,
    Gradient? idleBorderGradient,
    BorderRadius? borderRadius,
  }) =>
      MessageInputTheme(
        sendAnimationDuration:
            sendAnimationDuration ?? this.sendAnimationDuration,
        inputBackground: inputBackground ?? this.inputBackground,
        actionButtonColor: actionButtonColor ?? this.actionButtonColor,
        sendButtonColor: sendButtonColor ?? this.sendButtonColor,
        actionButtonIdleColor:
            actionButtonIdleColor ?? this.actionButtonIdleColor,
        expandButtonColor: expandButtonColor ?? this.expandButtonColor,
        inputTextStyle: inputTextStyle ?? this.inputTextStyle,
        sendButtonIdleColor: sendButtonIdleColor ?? this.sendButtonIdleColor,
        inputDecoration: inputDecoration ?? this.inputDecoration,
        activeBorderGradient: activeBorderGradient ?? this.activeBorderGradient,
        idleBorderGradient: idleBorderGradient ?? this.idleBorderGradient,
        borderRadius: borderRadius ?? this.borderRadius,
      );

  /// Merges [this] [MessageInputTheme] with the [other]
  MessageInputTheme merge(MessageInputTheme? other) {
    if (other == null) return this;
    return copyWith(
      sendAnimationDuration: other.sendAnimationDuration,
      inputBackground: other.inputBackground,
      actionButtonColor: other.actionButtonColor,
      actionButtonIdleColor: other.actionButtonIdleColor,
      sendButtonColor: other.sendButtonColor,
      sendButtonIdleColor: other.sendButtonIdleColor,
      inputTextStyle:
          inputTextStyle?.merge(other.inputTextStyle) ?? other.inputTextStyle,
      inputDecoration: inputDecoration?.merge(other.inputDecoration) ??
          other.inputDecoration,
      activeBorderGradient: other.activeBorderGradient,
      idleBorderGradient: other.idleBorderGradient,
      borderRadius: other.borderRadius,
      expandButtonColor: other.expandButtonColor,
    );
  }
}

/// Effect store
class Effect {
  /// Constructor for creating [Effect]
  const Effect({
    this.sigmaX,
    this.sigmaY,
    this.color,
    this.alpha,
    this.blur,
  });

  ///
  final double? sigmaX;

  ///
  final double? sigmaY;

  ///
  final Color? color;

  ///
  final double? alpha;

  ///
  final double? blur;

  /// Copy with new effect
  Effect copyWith({
    double? sigmaX,
    double? sigmaY,
    Color? color,
    double? alpha,
    double? blur,
  }) =>
      Effect(
        sigmaX: sigmaX ?? this.sigmaX,
        sigmaY: sigmaY ?? this.sigmaY,
        color: color ?? this.color,
        alpha: color as double? ?? this.alpha,
        blur: blur ?? this.blur,
      );
}
