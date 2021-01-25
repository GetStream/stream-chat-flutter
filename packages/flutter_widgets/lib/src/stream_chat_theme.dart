import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/channel_header.dart';
import 'package:stream_chat_flutter/src/channel_preview.dart';
import 'package:stream_chat_flutter/src/message_input.dart';
import 'package:stream_chat_flutter/src/reaction_icon.dart';
import 'package:stream_chat_flutter/src/utils.dart';

/// Inherited widget providing the [StreamChatThemeData] to the widget tree
class StreamChatTheme extends InheritedWidget {
  final StreamChatThemeData data;

  StreamChatTheme({
    Key key,
    @required this.data,
    Widget child,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(StreamChatTheme old) {
    return data != old.data;
  }

  /// Use this method to get the current [StreamChatThemeData] instance
  static StreamChatThemeData of(BuildContext context) {
    final streamChatTheme =
        context.dependOnInheritedWidgetOfExactType<StreamChatTheme>();

    if (streamChatTheme == null) {
      throw Exception(
        'You must have a StreamChatTheme widget at the top of your widget tree',
      );
    }

    return streamChatTheme.data;
  }
}

/// Theme data
class StreamChatThemeData {
  /// The text themes used in the widgets
  final TextTheme textTheme;

  /// The text themes used in the widgets
  final ColorTheme colorTheme;

  /// Theme of the [ChannelPreview]
  final ChannelPreviewTheme channelPreviewTheme;

  /// Theme of the chat widgets dedicated to a channel
  final ChannelTheme channelTheme;

  /// Theme of the current user messages
  final MessageTheme ownMessageTheme;

  /// Theme of other users messages
  final MessageTheme otherMessageTheme;

  /// The widget that will be built when the channel image is unavailable
  final Widget Function(BuildContext, Channel) defaultChannelImage;

  /// The widget that will be built when the user image is unavailable
  final Widget Function(BuildContext, User) defaultUserImage;

  /// Primary icon theme
  final IconThemeData primaryIconTheme;

  /// Assets used for rendering reactions
  final List<ReactionIcon> reactionIcons;

  /// Create a theme from scratch
  const StreamChatThemeData({
    this.textTheme,
    this.colorTheme,
    this.channelPreviewTheme,
    this.channelTheme,
    this.otherMessageTheme,
    this.ownMessageTheme,
    this.defaultChannelImage,
    this.defaultUserImage,
    this.primaryIconTheme,
    this.reactionIcons,
  });

  /// Create a theme from a Material [Theme]
  factory StreamChatThemeData.fromTheme(ThemeData theme) {
    final defaultTheme = getDefaultTheme(theme);
    final customizedTheme = StreamChatThemeData.fromColorAndTextTheme(
      defaultTheme.colorTheme.copyWith(
        accentBlue: theme.accentColor,
      ),
      defaultTheme.textTheme,
    ).copyWith(
        // primaryIconTheme: theme.primaryIconTheme,
        );
    return defaultTheme.merge(customizedTheme) ?? customizedTheme;
  }

  /// Creates a copy of [StreamChatThemeData] with specified attributes overridden.
  StreamChatThemeData copyWith({
    TextTheme textTheme,
    ColorTheme colorTheme,
    ChannelPreviewTheme channelPreviewTheme,
    ChannelTheme channelTheme,
    MessageTheme ownMessageTheme,
    MessageTheme otherMessageTheme,
    Widget Function(BuildContext, Channel) defaultChannelImage,
    Widget Function(BuildContext, User) defaultUserImage,
    IconThemeData primaryIconTheme,
    List<ReactionIcon> reactionIcons,
  }) =>
      StreamChatThemeData(
        textTheme: textTheme ?? this.textTheme,
        colorTheme: colorTheme ?? this.colorTheme,
        primaryIconTheme: primaryIconTheme ?? this.primaryIconTheme,
        defaultChannelImage: defaultChannelImage ?? this.defaultChannelImage,
        defaultUserImage: defaultUserImage ?? this.defaultUserImage,
        channelPreviewTheme: channelPreviewTheme ?? this.channelPreviewTheme,
        channelTheme: channelTheme ?? this.channelTheme,
        ownMessageTheme: ownMessageTheme ?? this.ownMessageTheme,
        otherMessageTheme: otherMessageTheme ?? this.otherMessageTheme,
        reactionIcons: reactionIcons ?? this.reactionIcons,
      );

  StreamChatThemeData merge(StreamChatThemeData other) {
    if (other == null) return this;
    return copyWith(
      textTheme: textTheme?.merge(other.textTheme) ?? other.textTheme,
      colorTheme: colorTheme?.merge(other.colorTheme) ?? other.colorTheme,
      primaryIconTheme: other.primaryIconTheme,
      defaultChannelImage: other.defaultChannelImage,
      defaultUserImage: other.defaultUserImage,
      channelPreviewTheme:
          channelPreviewTheme?.merge(other.channelPreviewTheme) ??
              other.channelPreviewTheme,
      channelTheme:
          channelTheme?.merge(other.channelTheme) ?? other.channelTheme,
      ownMessageTheme: ownMessageTheme?.merge(other.ownMessageTheme) ??
          other.ownMessageTheme,
      otherMessageTheme: otherMessageTheme?.merge(other.otherMessageTheme) ??
          other.otherMessageTheme,
      reactionIcons: other.reactionIcons,
    );
  }

  static StreamChatThemeData fromColorAndTextTheme(
    ColorTheme colorTheme,
    TextTheme textTheme,
  ) {
    final accentColor = colorTheme.accentBlue;
    return StreamChatThemeData(
      textTheme: textTheme,
      colorTheme: colorTheme,
      primaryIconTheme: IconThemeData(color: colorTheme.black.withOpacity(.5)),
      defaultChannelImage: (context, channel) => SizedBox(),
      defaultUserImage: (context, user) => Center(
        child: CachedNetworkImage(
          filterQuality: FilterQuality.high,
          imageUrl: getRandomPicUrl(user),
          fit: BoxFit.cover,
        ),
      ),
      channelPreviewTheme: ChannelPreviewTheme(
          unreadCounterColor: colorTheme.accentRed,
          avatarTheme: AvatarTheme(
            borderRadius: BorderRadius.circular(20),
            constraints: BoxConstraints.tightFor(
              height: 40,
              width: 40,
            ),
          ),
          title: textTheme.bodyBold,
          subtitle: textTheme.footnote.copyWith(
            color: Color(0xff7A7A7A),
          ),
          lastMessageAt: textTheme.footnote.copyWith(
            color: colorTheme.black.withOpacity(.5),
          ),
          indicatorIconSize: 16.0),
      channelTheme: ChannelTheme(
        messageInputButtonIconTheme: IconThemeData(
          color: accentColor,
        ),
        channelHeaderTheme: ChannelHeaderTheme(
          avatarTheme: AvatarTheme(
            borderRadius: BorderRadius.circular(20),
            constraints: BoxConstraints.tightFor(
              height: 40,
              width: 40,
            ),
          ),
          color: colorTheme.white,
          title: TextStyle(
            fontSize: 14,
            color: colorTheme.black,
          ),
          lastMessageAt: TextStyle(
            fontSize: 11,
            color: colorTheme.black.withOpacity(.5),
          ),
        ),
        inputBackground: colorTheme.white.withAlpha(12),
      ),
      ownMessageTheme: MessageTheme(
        messageText: textTheme.body,
        createdAt: textTheme.footnote.copyWith(color: colorTheme.grey),
        replies: textTheme.footnoteBold.copyWith(color: accentColor),
        messageBackgroundColor: colorTheme.greyGainsboro,
        reactionsBackgroundColor: colorTheme.white,
        reactionsBorderColor: colorTheme.greyWhisper,
        reactionsMaskColor: colorTheme.whiteSnow,
        messageBorderColor: colorTheme.greyGainsboro,
        avatarTheme: AvatarTheme(
          borderRadius: BorderRadius.circular(20),
          constraints: BoxConstraints.tightFor(
            height: 32,
            width: 32,
          ),
        ),
        messageLinks: TextStyle(
          color: accentColor,
        ),
      ),
      otherMessageTheme: MessageTheme(
        reactionsBackgroundColor: colorTheme.greyGainsboro,
        reactionsBorderColor: colorTheme.white,
        reactionsMaskColor: colorTheme.whiteSnow,
        messageText: textTheme.body,
        createdAt: textTheme.footnote.copyWith(color: colorTheme.grey),
        replies: textTheme.footnoteBold.copyWith(color: accentColor),
        messageLinks: TextStyle(
          color: accentColor,
        ),
        messageBackgroundColor: colorTheme.white,
        messageBorderColor: colorTheme.greyWhisper,
        avatarTheme: AvatarTheme(
          borderRadius: BorderRadius.circular(20),
          constraints: BoxConstraints.tightFor(
            height: 32,
            width: 32,
          ),
        ),
      ),
      reactionIcons: [
        ReactionIcon(
          type: 'love',
          assetName: 'Icon_love_reaction.svg',
        ),
        ReactionIcon(
          type: 'like',
          assetName: 'Icon_thumbs_up_reaction.svg',
        ),
        ReactionIcon(
          type: 'sad',
          assetName: 'Icon_thumbs_down_reaction.svg',
        ),
        ReactionIcon(
          type: 'haha',
          assetName: 'Icon_LOL_reaction.svg',
        ),
        ReactionIcon(
          type: 'wow',
          assetName: 'Icon_wut_reaction.svg',
        ),
      ],
    );
  }

  /// Get the default Stream Chat theme
  static StreamChatThemeData getDefaultTheme(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = isDark ? TextTheme.dark() : TextTheme.light();
    final colorTheme = isDark ? ColorTheme.dark() : ColorTheme.light();
    return fromColorAndTextTheme(
      colorTheme,
      textTheme,
    );
  }
}

enum TextThemeType {
  light,
  dark,
}

class TextTheme {
  final TextStyle title;
  final TextStyle headlineBold;
  final TextStyle headline;
  final TextStyle bodyBold;
  final TextStyle body;
  final TextStyle footnoteBold;
  final TextStyle footnote;
  final TextStyle captionBold;

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

  TextTheme copyWith({
    TextThemeType type = TextThemeType.light,
    TextStyle body,
    TextStyle title,
    TextStyle headlineBold,
    TextStyle headline,
    TextStyle bodyBold,
    TextStyle footnoteBold,
    TextStyle footnote,
    TextStyle captionBold,
  }) {
    return type == TextThemeType.light
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
  }

  TextTheme merge(TextTheme other) {
    if (other == null) return this;
    return copyWith(
      body: body?.merge(other.body) ?? other.body,
      title: title?.merge(other.title) ?? other.title,
      headlineBold:
          headlineBold?.merge(other.headlineBold) ?? other.headlineBold,
      headline: headline?.merge(other.headline) ?? other.headline,
      bodyBold: bodyBold?.merge(other.bodyBold) ?? other.bodyBold,
      footnoteBold:
          footnoteBold?.merge(other.footnoteBold) ?? other.footnoteBold,
      footnote: footnote?.merge(other.footnote) ?? other.footnote,
      captionBold: captionBold?.merge(other.captionBold) ?? other.captionBold,
    );
  }
}

enum ColorThemeType {
  light,
  dark,
}

class ColorTheme {
  final Color black;
  final Color grey;
  final Color greyGainsboro;
  final Color greyWhisper;
  final Color whiteSmoke;
  final Color whiteSnow;
  final Color white;
  final Color blueAlice;
  final Color accentBlue;
  final Color accentRed;
  final Color accentGreen;
  final Effect borderTop;
  final Effect borderBottom;
  final Effect shadowIconButton;
  final Effect modalShadow;
  final Color highlight;
  final Color overlay;
  final Color overlayDark;
  final Gradient bgGradient;

  ColorTheme.light({
    this.black = const Color(0xff000000),
    this.grey = const Color(0xff7a7a7a),
    this.greyGainsboro = const Color(0xffdbdbdb),
    this.greyWhisper = const Color(0xffecebeb),
    this.whiteSmoke = const Color(0xfff2f2f2),
    this.whiteSnow = const Color(0xfffcfcfc),
    this.white = const Color(0xffffffff),
    this.blueAlice = const Color(0xffe9f2ff),
    this.accentBlue = const Color(0xff005FFF),
    this.accentRed = const Color(0xffFF3842),
    this.accentGreen = const Color(0xff20E070),
    this.highlight = const Color(0xfffbf4dd),
    this.overlay = const Color.fromRGBO(0, 0, 0, 0.2),
    this.overlayDark = const Color.fromRGBO(0, 0, 0, 0.6),
    this.bgGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [const Color(0xfff7f7f7), const Color(0xfffcfcfc)],
      stops: [0, 1],
    ),
    this.borderTop = const Effect(
        sigmaX: 0,
        sigmaY: -1,
        color: Color(0xff000000),
        blur: 0.0,
        alpha: 0.08),
    this.borderBottom = const Effect(
        sigmaX: 0, sigmaY: 1, color: Color(0xff000000), blur: 0.0, alpha: 0.08),
    this.shadowIconButton = const Effect(
        sigmaX: 0, sigmaY: 2, color: Color(0xff000000), alpha: 0.5, blur: 4.0),
    this.modalShadow = const Effect(
        sigmaX: 0, sigmaY: 0, color: Color(0xff000000), alpha: 1, blur: 8.0),
  });

  ColorTheme.dark({
    this.black = const Color(0xffffffff),
    this.grey = const Color(0xff7a7a7a),
    this.greyGainsboro = const Color(0xff2d2f2f),
    this.greyWhisper = const Color(0xff1c1e22),
    this.whiteSmoke = const Color(0xff13151b),
    this.whiteSnow = const Color(0xff070A0D),
    this.white = const Color(0xff101418),
    this.blueAlice = const Color(0xff00193D),
    this.accentBlue = const Color(0xff005FFF),
    this.accentRed = const Color(0xffFF3742),
    this.accentGreen = const Color(0xff20E070),
    this.borderTop = const Effect(
        sigmaX: 0, sigmaY: -1, color: Color(0xff141924), blur: 0.0),
    this.borderBottom = const Effect(
        sigmaX: 0, sigmaY: 1, color: Color(0xff141924), blur: 0.0, alpha: 1.0),
    this.shadowIconButton = const Effect(
        sigmaX: 0, sigmaY: 2, color: Color(0xff000000), alpha: 0.5, blur: 4.0),
    this.modalShadow = const Effect(
        sigmaX: 0, sigmaY: 0, color: Color(0xff000000), alpha: 1, blur: 8.0),
    this.highlight = const Color(0xff302d22),
    this.overlay = const Color.fromRGBO(0, 0, 0, 0.4),
    this.overlayDark = const Color.fromRGBO(255, 255, 255, 0.6),
    this.bgGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [const Color(0xff101214), const Color(0xff070a0d)],
      stops: [0, 1],
    ),
  });

  ColorTheme copyWith({
    ColorThemeType type = ColorThemeType.light,
    Color black,
    Color grey,
    Color greyGainsboro,
    Color greyWhisper,
    Color whiteSmoke,
    Color whiteSnow,
    Color white,
    Color blueAlice,
    Color accentBlue,
    Color accentRed,
    Color accentGreen,
    Effect borderTop,
    Effect borderBottom,
    Effect shadowIconButton,
    Effect modalShadow,
    Color highlight,
    Color overlay,
    Color overlayDark,
    Gradient bgGradient,
  }) {
    return type == ColorThemeType.light
        ? ColorTheme.light(
            black: black ?? this.black,
            grey: grey ?? this.grey,
            greyGainsboro: greyGainsboro ?? this.greyGainsboro,
            greyWhisper: greyWhisper ?? this.greyWhisper,
            whiteSmoke: whiteSmoke ?? this.whiteSmoke,
            whiteSnow: whiteSnow ?? this.whiteSnow,
            white: white ?? this.white,
            blueAlice: blueAlice ?? this.blueAlice,
            accentBlue: accentBlue ?? this.accentBlue,
            accentRed: accentRed ?? this.accentRed,
            accentGreen: accentGreen ?? this.accentGreen,
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
            black: black ?? this.black,
            grey: grey ?? this.grey,
            greyGainsboro: greyGainsboro ?? this.greyGainsboro,
            greyWhisper: greyWhisper ?? this.greyWhisper,
            whiteSmoke: whiteSmoke ?? this.whiteSmoke,
            whiteSnow: whiteSnow ?? this.whiteSnow,
            white: white ?? this.white,
            blueAlice: blueAlice ?? this.blueAlice,
            accentBlue: accentBlue ?? this.accentBlue,
            accentRed: accentRed ?? this.accentRed,
            accentGreen: accentGreen ?? this.accentGreen,
            borderTop: borderTop ?? this.borderTop,
            borderBottom: borderBottom ?? this.borderBottom,
            shadowIconButton: shadowIconButton ?? this.shadowIconButton,
            modalShadow: modalShadow ?? this.modalShadow,
            highlight: highlight ?? this.highlight,
            overlay: overlay ?? this.overlay,
            overlayDark: overlayDark ?? this.overlayDark,
            bgGradient: bgGradient ?? this.bgGradient,
          );
  }

  ColorTheme merge(ColorTheme other) {
    if (other == null) return this;
    return copyWith(
      black: other.black,
      grey: other.grey,
      greyGainsboro: other.greyGainsboro,
      greyWhisper: other.greyWhisper,
      whiteSmoke: other.whiteSmoke,
      whiteSnow: other.whiteSnow,
      white: other.white,
      blueAlice: other.blueAlice,
      accentBlue: other.accentBlue,
      accentRed: other.accentRed,
      accentGreen: other.accentGreen,
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
  /// Theme of the [ChannelHeader] widget
  final ChannelHeaderTheme channelHeaderTheme;

  /// IconTheme of the send button in [MessageInput]
  final IconThemeData messageInputButtonIconTheme;

  /// Theme of the send button in [MessageInput]
  final ButtonThemeData messageInputButtonTheme;

  /// Background color of [MessageInput]
  final Color inputBackground;

  ChannelTheme({
    this.channelHeaderTheme,
    this.messageInputButtonIconTheme,
    this.messageInputButtonTheme,
    this.inputBackground,
  });

  /// Creates a copy of [ChannelTheme] with specified attributes overridden.
  ChannelTheme copyWith({
    ChannelHeaderTheme channelHeaderTheme,
    IconThemeData messageInputButtonIconTheme,
    ButtonThemeData messageInputButtonTheme,
    Color inputBackground,
  }) =>
      ChannelTheme(
        channelHeaderTheme: channelHeaderTheme ?? this.channelHeaderTheme,
        messageInputButtonIconTheme:
            messageInputButtonIconTheme ?? this.messageInputButtonIconTheme,
        messageInputButtonTheme:
            messageInputButtonTheme ?? this.messageInputButtonTheme,
        inputBackground: inputBackground ?? this.inputBackground,
      );

  ChannelTheme merge(ChannelTheme other) {
    if (other == null) return this;
    return copyWith(
      channelHeaderTheme: channelHeaderTheme?.merge(other.channelHeaderTheme) ??
          other.channelHeaderTheme,
      messageInputButtonIconTheme: messageInputButtonIconTheme
              ?.merge(other.messageInputButtonIconTheme) ??
          other.messageInputButtonIconTheme,
      messageInputButtonTheme: other.messageInputButtonTheme,
      inputBackground: other.inputBackground,
    );
  }
}

class AvatarTheme {
  final BoxConstraints constraints;
  final BorderRadius borderRadius;

  AvatarTheme({
    this.constraints,
    this.borderRadius,
  });

  AvatarTheme copyWith({
    BoxConstraints constraints,
    BorderRadius borderRadius,
  }) =>
      AvatarTheme(
        constraints: constraints ?? this.constraints,
        borderRadius: borderRadius ?? this.borderRadius,
      );

  AvatarTheme merge(AvatarTheme other) {
    if (other == null) return this;
    return copyWith(
      constraints: other.constraints,
      borderRadius: other.borderRadius,
    );
  }
}

class MessageTheme {
  final TextStyle messageText;
  final TextStyle messageAuthor;
  final TextStyle messageLinks;
  final TextStyle createdAt;
  final TextStyle replies;
  final Color messageBackgroundColor;
  final Color messageBorderColor;
  final Color reactionsBackgroundColor;
  final Color reactionsBorderColor;
  final Color reactionsMaskColor;
  final AvatarTheme avatarTheme;

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

  MessageTheme copyWith({
    TextStyle messageText,
    TextStyle messageAuthor,
    TextStyle messageLinks,
    TextStyle createdAt,
    TextStyle replies,
    Color messageBackgroundColor,
    Color messageBorderColor,
    AvatarTheme avatarTheme,
    Color reactionsBackgroundColor,
    Color reactionsBorderColor,
    Color reactionsMaskColor,
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

  MessageTheme merge(MessageTheme other) {
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

class ChannelPreviewTheme {
  final TextStyle title;
  final TextStyle subtitle;
  final TextStyle lastMessageAt;
  final AvatarTheme avatarTheme;
  final Color unreadCounterColor;
  final double indicatorIconSize;

  const ChannelPreviewTheme({
    this.title,
    this.subtitle,
    this.lastMessageAt,
    this.avatarTheme,
    this.unreadCounterColor,
    this.indicatorIconSize,
  });

  ChannelPreviewTheme copyWith({
    TextStyle title,
    TextStyle subtitle,
    TextStyle lastMessageAt,
    AvatarTheme avatarTheme,
    Color unreadCounterColor,
    double indicatorIconSize,
  }) =>
      ChannelPreviewTheme(
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        lastMessageAt: lastMessageAt ?? this.lastMessageAt,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        unreadCounterColor: unreadCounterColor ?? this.unreadCounterColor,
        indicatorIconSize: indicatorIconSize ?? this.indicatorIconSize,
      );

  ChannelPreviewTheme merge(ChannelPreviewTheme other) {
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

class ChannelHeaderTheme {
  final TextStyle title;
  final TextStyle lastMessageAt;
  final AvatarTheme avatarTheme;
  final Color color;

  const ChannelHeaderTheme({
    this.title,
    this.lastMessageAt,
    this.avatarTheme,
    this.color,
  });

  ChannelHeaderTheme copyWith({
    TextStyle title,
    TextStyle lastMessageAt,
    AvatarTheme avatarTheme,
    Color color,
  }) =>
      ChannelHeaderTheme(
        title: title ?? this.title,
        lastMessageAt: lastMessageAt ?? this.lastMessageAt,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        color: color ?? this.color,
      );

  ChannelHeaderTheme merge(ChannelHeaderTheme other) {
    if (other == null) return this;
    return copyWith(
      title: title?.merge(other.title) ?? other.title,
      lastMessageAt:
          lastMessageAt?.merge(other.lastMessageAt) ?? other.lastMessageAt,
      avatarTheme: avatarTheme?.merge(other.avatarTheme) ?? other.avatarTheme,
      color: other.color,
    );
  }
}

class Effect {
  final double sigmaX;
  final double sigmaY;
  final Color color;
  final double alpha;
  final double blur;

  const Effect({
    this.sigmaX,
    this.sigmaY,
    this.color,
    this.alpha,
    this.blur,
  });

  Effect copyWith({
    double sigmaX,
    double sigmaY,
    Color color,
    double alpha,
    double blur,
  }) =>
      Effect(
        sigmaX: sigmaX ?? this.sigmaX,
        sigmaY: sigmaY ?? this.sigmaY,
        color: color ?? this.color,
        alpha: color ?? this.alpha,
        blur: blur ?? this.blur,
      );
}
