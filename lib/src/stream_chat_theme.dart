import 'package:flutter/material.dart';

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

  static StreamChatThemeData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StreamChatTheme>().data;
  }
}

class StreamChatThemeData {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final ChannelPreviewTheme channelPreviewTheme;
  final ChannelTheme channelTheme;
  final MessageTheme messageTheme;

  StreamChatThemeData({
    this.primaryColor,
    this.secondaryColor,
    this.accentColor,
    this.channelPreviewTheme,
    this.channelTheme,
    this.messageTheme,
  });

  factory StreamChatThemeData.fromTheme(ThemeData theme) {
    return StreamChatThemeData(
      accentColor: theme.accentColor,
      primaryColor: theme.colorScheme.primary,
      secondaryColor: theme.colorScheme.secondary,
    );
  }

  StreamChatThemeData copyWith({
    Color primaryColor,
    Color secondaryColor,
    Color accentColor,
    ChannelPreviewTheme channelPreviewTheme,
    ChannelTheme channelTheme,
    MessageTheme messageTheme,
  }) =>
      StreamChatThemeData(
        primaryColor: primaryColor ?? this.primaryColor,
        secondaryColor: secondaryColor ?? this.secondaryColor,
        accentColor: accentColor ?? this.accentColor,
        channelPreviewTheme: channelPreviewTheme ?? this.channelPreviewTheme,
        channelTheme: channelTheme ?? this.channelTheme,
        messageTheme: messageTheme ?? this.messageTheme,
      );
}

class ChannelTheme {
  final ChannelHeaderTheme channelHeaderTheme;
  final IconThemeData messageInputButtonIconTheme;
  final ButtonThemeData messageInputButtonTheme;
  final Gradient inputGradient;
  final Color inputBackground;

  ChannelTheme({
    this.channelHeaderTheme,
    this.messageInputButtonIconTheme,
    this.messageInputButtonTheme,
    this.inputBackground,
    this.inputGradient,
  });

  ChannelTheme copyWith({
    ChannelHeaderTheme channelHeaderTheme,
    IconThemeData messageInputButtonIconTheme,
    ButtonThemeData messageInputButtonTheme,
    Gradient inputGradient,
    Color inputBackground,
  }) =>
      ChannelTheme(
        channelHeaderTheme: channelHeaderTheme ?? this.channelHeaderTheme,
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
  final String fontFamily;
  final Color ownMessageBackgroundColor;
  final Color otherMessageBackgroundColor;
  final AvatarTheme avatarTheme;

  const MessageTheme({
    this.messageText,
    this.messageAuthor,
    this.messageMention,
    this.fontFamily,
    this.ownMessageBackgroundColor,
    this.otherMessageBackgroundColor,
    this.avatarTheme,
    this.createdAt,
  });

  MessageTheme copyWith({
    TextStyle messageText,
    TextStyle messageAuthor,
    TextStyle messageMention,
    TextStyle createdAt,
    String fontFamily,
    Color ownMessageBackgroundColor,
    Color otherMessageBackgroundColor,
    AvatarTheme avatarTheme,
  }) =>
      MessageTheme(
        messageText: messageText ?? this.messageText,
        messageAuthor: messageAuthor ?? this.messageAuthor,
        messageMention: messageMention ?? this.messageMention,
        createdAt: createdAt ?? this.createdAt,
        fontFamily: fontFamily ?? this.fontFamily,
        ownMessageBackgroundColor:
            ownMessageBackgroundColor ?? this.ownMessageBackgroundColor,
        otherMessageBackgroundColor:
            otherMessageBackgroundColor ?? this.otherMessageBackgroundColor,
        avatarTheme: avatarTheme ?? this.avatarTheme,
      );
}

class ChannelPreviewTheme {
  final TextStyle title;
  final TextStyle subtitle;
  final TextStyle lastMessageAt;
  final AvatarTheme avatarTheme;

  const ChannelPreviewTheme({
    this.title,
    this.subtitle,
    this.lastMessageAt,
    this.avatarTheme,
  });

  ChannelPreviewTheme copyWith({
    TextStyle title,
    TextStyle subtitle,
    TextStyle lastMessageAt,
    AvatarTheme avatarTheme,
  }) =>
      ChannelPreviewTheme(
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        lastMessageAt: lastMessageAt ?? this.lastMessageAt,
        avatarTheme: avatarTheme ?? this.avatarTheme,
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
