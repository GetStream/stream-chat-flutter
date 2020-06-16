import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/channel_header.dart';
import 'package:stream_chat_flutter/src/channel_preview.dart';
import 'package:stream_chat_flutter/src/message_input.dart';

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
  /// Primary color of the chat widgets
  final Color primaryColor;

  /// Secondary color of the chat widgets
  final Color secondaryColor;

  /// Accent color of the chat widgets
  final Color accentColor;

  /// Background color of the chat widgets
  final Color backgroundColor;

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

  /// Create a theme from scratch
  StreamChatThemeData({
    this.primaryColor,
    this.secondaryColor,
    this.accentColor,
    this.backgroundColor,
    this.channelPreviewTheme,
    this.channelTheme,
    this.otherMessageTheme,
    this.ownMessageTheme,
    this.defaultChannelImage,
    this.defaultUserImage,
    this.primaryIconTheme,
  });

  /// Create a theme from a Material [Theme]
  factory StreamChatThemeData.fromTheme(ThemeData theme) {
    final defaultTheme = getDefaultTheme(theme);

    return defaultTheme.copyWith(
      accentColor: theme.accentColor,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColor: theme.colorScheme.primary,
      secondaryColor: theme.colorScheme.secondary,
      backgroundColor: theme.scaffoldBackgroundColor,
      channelTheme: ChannelTheme(
        inputGradient: LinearGradient(colors: [
          theme.accentColor.withOpacity(.5),
          theme.accentColor,
        ]),
      ),
      ownMessageTheme: MessageTheme(
        replies: defaultTheme.ownMessageTheme.replies.copyWith(
          color: theme.accentColor,
        ),
      ),
      otherMessageTheme: MessageTheme(
        replies: defaultTheme.ownMessageTheme.replies.copyWith(
          color: theme.accentColor,
        ),
      ),
    );
  }

  /// Creates a copy of [StreamChatThemeData] with specified attributes overridden.
  StreamChatThemeData copyWith({
    Color primaryColor,
    Color secondaryColor,
    Color accentColor,
    Color backgroundColor,
    ChannelPreviewTheme channelPreviewTheme,
    ChannelTheme channelTheme,
    MessageTheme ownMessageTheme,
    MessageTheme otherMessageTheme,
    Widget Function(BuildContext, Channel) defaultChannelImage,
    Widget Function(BuildContext, User) defaultUserImage,
    IconThemeData primaryIconTheme,
  }) =>
      StreamChatThemeData(
        primaryColor: primaryColor ?? this.primaryColor,
        secondaryColor: secondaryColor ?? this.secondaryColor,
        primaryIconTheme: primaryIconTheme ?? this.primaryIconTheme,
        accentColor: accentColor ?? this.accentColor,
        defaultChannelImage: defaultChannelImage ?? this.defaultChannelImage,
        defaultUserImage: defaultUserImage ?? this.defaultUserImage,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        channelPreviewTheme: channelPreviewTheme?.copyWith(
              title:
                  channelPreviewTheme.title ?? this.channelPreviewTheme.title,
              subtitle: channelPreviewTheme.subtitle ??
                  this.channelPreviewTheme.subtitle,
              lastMessageAt: channelPreviewTheme.lastMessageAt ??
                  this.channelPreviewTheme.lastMessageAt,
              avatarTheme: channelPreviewTheme.avatarTheme ??
                  this.channelPreviewTheme.avatarTheme,
            ) ??
            this.channelPreviewTheme,
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
              messageMention: ownMessageTheme?.messageMention ??
                  this.ownMessageTheme.messageMention,
              createdAt:
                  ownMessageTheme?.createdAt ?? this.ownMessageTheme.createdAt,
              replies: ownMessageTheme?.replies ?? this.ownMessageTheme.replies,
              messageBackgroundColor: ownMessageTheme?.messageBackgroundColor ??
                  this.ownMessageTheme.messageBackgroundColor,
              avatarTheme: ownMessageTheme?.avatarTheme ??
                  this.ownMessageTheme.avatarTheme,
            ) ??
            this.ownMessageTheme,
        otherMessageTheme: otherMessageTheme?.copyWith(
              messageText: otherMessageTheme?.messageText ??
                  this.otherMessageTheme.messageText,
              messageAuthor: otherMessageTheme?.messageAuthor ??
                  this.otherMessageTheme.messageAuthor,
              messageMention: otherMessageTheme?.messageMention ??
                  this.otherMessageTheme.messageMention,
              createdAt: otherMessageTheme?.createdAt ??
                  this.otherMessageTheme.createdAt,
              replies:
                  otherMessageTheme?.replies ?? this.otherMessageTheme.replies,
              messageBackgroundColor:
                  otherMessageTheme?.messageBackgroundColor ??
                      this.otherMessageTheme.messageBackgroundColor,
              avatarTheme: otherMessageTheme?.avatarTheme ??
                  this.otherMessageTheme.avatarTheme,
            ) ??
            this.otherMessageTheme,
      );

  /// Get the default Stream Chat theme
  static StreamChatThemeData getDefaultTheme(ThemeData theme) {
    final accentColor = Color(0xff006cff);
    final isDark = theme.brightness == Brightness.dark;
    return StreamChatThemeData(
      accentColor: accentColor,
      primaryColor: isDark ? Colors.black : Colors.white,
      primaryIconTheme:
          IconThemeData(color: isDark ? Colors.white : Colors.black),
      defaultChannelImage: (context, channel) => SizedBox(),
      backgroundColor: isDark ? Colors.black : Colors.white,
      defaultUserImage: (context, user) => Center(
        child: Text(
          user.name?.substring(0, 1) ?? '',
          style: TextStyle(color: Colors.white),
        ),
      ),
      channelPreviewTheme: ChannelPreviewTheme(
        unreadCounterColor: Color(0xffd0021B),
        avatarTheme: AvatarTheme(
          borderRadius: BorderRadius.circular(20),
          constraints: BoxConstraints.tightFor(
            height: 40,
            width: 40,
          ),
        ),
        title: TextStyle(
          fontSize: 14,
          color: isDark ? Colors.white : Colors.black,
        ),
        subtitle: TextStyle(
          fontSize: 12.5,
          color: isDark ? Colors.white : Colors.black,
        ),
        lastMessageAt: TextStyle(
          fontSize: 11,
          color: isDark
              ? Colors.white.withOpacity(.5)
              : Colors.black.withOpacity(.5),
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
          color: isDark ? Colors.black : Colors.white,
          title: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white : Colors.black,
          ),
          lastMessageAt: TextStyle(
            fontSize: 11,
            color: isDark
                ? Colors.white.withOpacity(.5)
                : Colors.black.withOpacity(.5),
          ),
        ),
        inputBackground:
            isDark ? Colors.black.withAlpha(12) : Colors.white.withAlpha(12),
        inputGradient: LinearGradient(colors: [
          Color(0xFF00AEFF),
          Color(0xFF0076FF),
        ]),
      ),
      ownMessageTheme: MessageTheme(
        messageText: TextStyle(
          fontSize: 15,
          color: isDark ? Colors.white : Colors.black,
        ),
        createdAt: TextStyle(
          color: isDark
              ? Colors.white.withOpacity(.5)
              : Colors.black.withOpacity(.5),
          fontSize: 11,
        ),
        replies: TextStyle(
          color: accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        messageBackgroundColor: Color(0xffE6E6E6),
        avatarTheme: AvatarTheme(
          borderRadius: BorderRadius.circular(20),
          constraints: BoxConstraints.tightFor(
            height: 32,
            width: 32,
          ),
        ),
      ),
      otherMessageTheme: MessageTheme(
        messageText: TextStyle(
          fontSize: 15,
          color: isDark ? Colors.white : Colors.black,
        ),
        createdAt: TextStyle(
          color: isDark
              ? Colors.white.withOpacity(.5)
              : Colors.black.withOpacity(.5),
          fontSize: 11,
        ),
        replies: TextStyle(
          color: accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        messageBackgroundColor: isDark ? Colors.black : Colors.white,
        avatarTheme: AvatarTheme(
          borderRadius: BorderRadius.circular(20),
          constraints: BoxConstraints.tightFor(
            height: 32,
            width: 32,
          ),
        ),
      ),
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
  final TextStyle messageMention;
  final TextStyle createdAt;
  final TextStyle replies;
  final Color messageBackgroundColor;
  final AvatarTheme avatarTheme;

  const MessageTheme({
    this.replies,
    this.messageText,
    this.messageAuthor,
    this.messageMention,
    this.messageBackgroundColor,
    this.avatarTheme,
    this.createdAt,
  });

  MessageTheme copyWith({
    TextStyle messageText,
    TextStyle messageAuthor,
    TextStyle messageMention,
    TextStyle createdAt,
    TextStyle replies,
    Color messageBackgroundColor,
    Color otherMessageBackgroundColor,
    AvatarTheme avatarTheme,
  }) =>
      MessageTheme(
        messageText: messageText ?? this.messageText,
        messageAuthor: messageAuthor ?? this.messageAuthor,
        messageMention: messageMention ?? this.messageMention,
        createdAt: createdAt ?? this.createdAt,
        messageBackgroundColor:
            messageBackgroundColor ?? this.messageBackgroundColor,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        replies: replies ?? this.replies,
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
