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
  StreamChatThemeData({
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

    return defaultTheme.copyWith(
      primaryIconTheme: theme.primaryIconTheme,
      channelTheme: defaultTheme.channelTheme.copyWith(
        inputGradient: LinearGradient(colors: [
          theme.accentColor.withOpacity(.5),
          theme.accentColor,
        ]),
      ),
      ownMessageTheme: defaultTheme.ownMessageTheme.copyWith(
        replies: defaultTheme.ownMessageTheme.replies.copyWith(
          color: theme.accentColor,
        ),
        messageLinks: TextStyle(
          color: theme.accentColor,
        ),
      ),
      otherMessageTheme: defaultTheme.otherMessageTheme.copyWith(
        replies: defaultTheme.otherMessageTheme.replies.copyWith(
          color: theme.accentColor,
        ),
        messageLinks: TextStyle(
          color: theme.accentColor,
        ),
      ),
    );
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
        textTheme: this.textTheme?.copyWith(
              title: textTheme?.title,
              body: textTheme?.body,
              bodyBold: textTheme?.bodyBold,
              captionBold: textTheme?.captionBold,
              footnote: textTheme?.footnote,
              footnoteBold: textTheme?.footnoteBold,
              headline: textTheme?.headline,
              headlineBold: textTheme?.headlineBold,
            ),
        colorTheme: this.colorTheme?.copyWith(
              black: colorTheme?.black,
              grey: colorTheme?.grey,
              greyGainsboro: colorTheme?.greyGainsboro,
              greyWhisper: colorTheme?.greyWhisper,
              whiteSmoke: colorTheme?.whiteSmoke,
              whiteSnow: colorTheme?.whiteSnow,
              white: colorTheme?.white,
              blueAlice: colorTheme?.blueAlice,
            ),
        primaryIconTheme: primaryIconTheme ?? this.primaryIconTheme,
        defaultChannelImage: defaultChannelImage ?? this.defaultChannelImage,
        defaultUserImage: defaultUserImage ?? this.defaultUserImage,
        channelPreviewTheme: this.channelPreviewTheme?.copyWith(
              title: channelPreviewTheme.title,
              subtitle: channelPreviewTheme.subtitle,
              lastMessageAt: channelPreviewTheme.lastMessageAt,
              avatarTheme: channelPreviewTheme.avatarTheme,
            ),
        channelTheme: channelTheme?.copyWith(
              channelHeaderTheme: channelTheme.channelHeaderTheme ??
                  this.channelTheme.channelHeaderTheme,
              messageInputButtonIconTheme:
                  channelTheme.messageInputButtonIconTheme ??
                      this.channelTheme.messageInputButtonIconTheme,
              messageInputButtonTheme: channelTheme.messageInputButtonTheme ??
                  this.channelTheme.messageInputButtonTheme,
              inputGradient:
                  channelTheme.inputGradient ?? this.channelTheme.inputGradient,
              inputBackground: channelTheme.inputBackground ??
                  this.channelTheme.inputBackground,
            ) ??
            this.channelTheme,
        ownMessageTheme: ownMessageTheme?.copyWith(
              messageText: ownMessageTheme?.messageText ??
                  this.ownMessageTheme.messageText,
              messageAuthor: ownMessageTheme?.messageAuthor ??
                  this.ownMessageTheme.messageAuthor,
              messageLinks: ownMessageTheme?.messageLinks ??
                  this.ownMessageTheme.messageLinks,
              createdAt:
                  ownMessageTheme?.createdAt ?? this.ownMessageTheme.createdAt,
              replies: ownMessageTheme?.replies ?? this.ownMessageTheme.replies,
              messageBackgroundColor: ownMessageTheme?.messageBackgroundColor ??
                  this.ownMessageTheme.messageBackgroundColor,
              avatarTheme: ownMessageTheme?.avatarTheme ??
                  this.ownMessageTheme.avatarTheme,
              replyThreadColor: ownMessageTheme?.replyThreadColor ??
                  this.ownMessageTheme.replyThreadColor,
            ) ??
            this.ownMessageTheme,
        otherMessageTheme: otherMessageTheme?.copyWith(
              messageText: otherMessageTheme?.messageText ??
                  this.otherMessageTheme.messageText,
              messageAuthor: otherMessageTheme?.messageAuthor ??
                  this.otherMessageTheme.messageAuthor,
              messageLinks: otherMessageTheme?.messageLinks ??
                  this.otherMessageTheme.messageLinks,
              createdAt: otherMessageTheme?.createdAt ??
                  this.otherMessageTheme.createdAt,
              replies:
                  otherMessageTheme?.replies ?? this.otherMessageTheme.replies,
              messageBackgroundColor:
                  otherMessageTheme?.messageBackgroundColor ??
                      this.otherMessageTheme.messageBackgroundColor,
              avatarTheme: otherMessageTheme?.avatarTheme ??
                  this.otherMessageTheme.avatarTheme,
              replyThreadColor: ownMessageTheme?.replyThreadColor ??
                  this.ownMessageTheme.replyThreadColor,
            ) ??
            this.otherMessageTheme,
        reactionIcons: reactionIcons ?? this.reactionIcons,
      );

  /// Get the default Stream Chat theme
  static StreamChatThemeData getDefaultTheme(ThemeData theme) {
    final accentColor = Color(0xff006cff);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = isDark ? TextTheme.dark() : TextTheme.light();
    final colorTheme = isDark ? ColorTheme.dark() : ColorTheme.light();
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
      ),
      channelTheme: ChannelTheme(
        messageInputButtonIconTheme: theme.iconTheme.copyWith(
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
        inputGradient: LinearGradient(colors: [
          Color(0xFF00AEFF),
          Color(0xFF0076FF),
        ]),
      ),
      ownMessageTheme: MessageTheme(
        messageText: TextStyle(
          fontSize: 14.5,
          color: colorTheme.black,
        ),
        createdAt: TextStyle(
          color: colorTheme.black.withOpacity(.5),
          fontSize: 12,
        ),
        replies: TextStyle(
          color: accentColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        messageBackgroundColor: colorTheme.greyGainsboro,
        reactionsBackgroundColor: colorTheme.white,
        reactionsBorderColor: colorTheme.greyWhisper,
        replyThreadColor: colorTheme.greyWhisper,
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
        messageText: TextStyle(
          fontSize: 14.5,
          color: colorTheme.black,
        ),
        createdAt: TextStyle(
          color: colorTheme.black.withOpacity(.5),
          fontSize: 12,
        ),
        replies: TextStyle(
          color: accentColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        messageLinks: TextStyle(
          color: accentColor,
        ),
        messageBackgroundColor: colorTheme.white,
        replyThreadColor: colorTheme.black.withAlpha(24),
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
          type: 'thumbs_up',
          assetName: 'Icon_thumbs_up_reaction.svg',
        ),
        ReactionIcon(
          type: 'thumbs_down',
          assetName: 'Icon_thumbs_down_reaction.svg',
        ),
        ReactionIcon(
          type: 'lol',
          assetName: 'Icon_LOL_reaction.svg',
        ),
        ReactionIcon(
          type: 'wut',
          assetName: 'Icon_wut_reaction.svg',
        ),
      ],
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
    ),
    this.headlineBold = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    this.headline = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    this.bodyBold = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    this.body = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    this.footnoteBold = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    this.footnote = const TextStyle(
      fontSize: 12,
    ),
    this.captionBold = const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
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
    this.accentRed = const Color(0xffFF3742),
    this.accentGreen = const Color(0xff20E070),
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

  /// Gradient of [MessageInput]
  final Gradient inputGradient;

  /// Background color of [MessageInput]
  final Color inputBackground;

  ChannelTheme({
    this.channelHeaderTheme,
    this.messageInputButtonIconTheme,
    this.messageInputButtonTheme,
    this.inputBackground,
    this.inputGradient,
  });

  /// Creates a copy of [ChannelTheme] with specified attributes overridden.
  ChannelTheme copyWith({
    ChannelHeaderTheme channelHeaderTheme,
    IconThemeData messageInputButtonIconTheme,
    ButtonThemeData messageInputButtonTheme,
    Gradient inputGradient,
    Color inputBackground,
  }) =>
      ChannelTheme(
        channelHeaderTheme: channelHeaderTheme?.copyWith(
              title: channelHeaderTheme?.title ?? this.channelHeaderTheme.title,
              lastMessageAt: channelHeaderTheme?.lastMessageAt ??
                  this.channelHeaderTheme.lastMessageAt,
              avatarTheme: channelHeaderTheme?.avatarTheme ??
                  this.channelHeaderTheme.avatarTheme,
              color: channelHeaderTheme?.color ?? this.channelHeaderTheme.color,
            ) ??
            this.channelHeaderTheme,
        messageInputButtonIconTheme:
            messageInputButtonIconTheme ?? this.messageInputButtonIconTheme,
        messageInputButtonTheme:
            messageInputButtonTheme ?? this.messageInputButtonTheme,
        inputGradient: inputGradient ?? this.inputGradient,
        inputBackground: inputBackground ?? this.inputBackground,
      );
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
}

class MessageTheme {
  final TextStyle messageText;
  final TextStyle messageAuthor;
  final TextStyle messageLinks;
  final TextStyle createdAt;
  final TextStyle replies;
  final Color messageBackgroundColor;
  final Color reactionsBackgroundColor;
  final Color reactionsBorderColor;
  final Color replyThreadColor;
  final AvatarTheme avatarTheme;

  const MessageTheme({
    this.replies,
    this.messageText,
    this.messageAuthor,
    this.messageLinks,
    this.messageBackgroundColor,
    this.reactionsBackgroundColor,
    this.reactionsBorderColor,
    this.replyThreadColor,
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
    AvatarTheme avatarTheme,
    Color reactionsBackgroundColor,
    Color reactionsBorderColor,
    Color replyThreadColor,
  }) =>
      MessageTheme(
        messageText: messageText ?? this.messageText,
        messageAuthor: messageAuthor ?? this.messageAuthor,
        messageLinks: messageLinks ?? this.messageLinks,
        createdAt: createdAt ?? this.createdAt,
        messageBackgroundColor:
            messageBackgroundColor ?? this.messageBackgroundColor,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        replies: replies ?? this.replies,
        reactionsBackgroundColor:
            reactionsBackgroundColor ?? this.reactionsBackgroundColor,
        reactionsBorderColor: reactionsBorderColor ?? this.reactionsBorderColor,
        replyThreadColor: replyThreadColor ?? this.replyThreadColor,
      );
}

class ChannelPreviewTheme {
  final TextStyle title;
  final TextStyle subtitle;
  final TextStyle lastMessageAt;
  final AvatarTheme avatarTheme;
  final Color unreadCounterColor;

  const ChannelPreviewTheme({
    this.title,
    this.subtitle,
    this.lastMessageAt,
    this.avatarTheme,
    this.unreadCounterColor,
  });

  ChannelPreviewTheme copyWith({
    TextStyle title,
    TextStyle subtitle,
    TextStyle lastMessageAt,
    AvatarTheme avatarTheme,
    Color unreadCounterColor,
  }) =>
      ChannelPreviewTheme(
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        lastMessageAt: lastMessageAt ?? this.lastMessageAt,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        unreadCounterColor: unreadCounterColor ?? this.unreadCounterColor,
      );
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
}
