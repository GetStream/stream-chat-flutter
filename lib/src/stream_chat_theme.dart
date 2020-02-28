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
  final MessageTheme ownMessageTheme;
  final MessageTheme otherMessageTheme;

  StreamChatThemeData({
    this.primaryColor,
    this.secondaryColor,
    this.accentColor,
    this.channelPreviewTheme,
    this.channelTheme,
    this.otherMessageTheme,
    this.ownMessageTheme,
  });

  factory StreamChatThemeData.fromTheme(ThemeData theme) {
    final defaultTheme = getDefaultTheme(theme);

    return defaultTheme.copyWith(
      accentColor: theme.accentColor,
      primaryColor: theme.colorScheme.primary,
      secondaryColor: theme.colorScheme.secondary,
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

  StreamChatThemeData copyWith({
    Color primaryColor,
    Color secondaryColor,
    Color accentColor,
    ChannelPreviewTheme channelPreviewTheme,
    ChannelTheme channelTheme,
    MessageTheme ownMessageTheme,
    MessageTheme otherMessageTheme,
  }) =>
      StreamChatThemeData(
        primaryColor: primaryColor ?? this.primaryColor,
        secondaryColor: secondaryColor ?? this.secondaryColor,
        accentColor: accentColor ?? this.accentColor,
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

  static StreamChatThemeData getDefaultTheme(ThemeData theme) {
    final accentColor = Color(0xff006cff);
    return StreamChatThemeData(
      accentColor: accentColor,
      primaryColor: Colors.white,
      channelPreviewTheme: ChannelPreviewTheme(
        avatarTheme: AvatarTheme(
          borderRadius: BorderRadius.circular(20),
          constraints: BoxConstraints.tightFor(
            height: 40,
            width: 40,
          ),
        ),
        title: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        subtitle: TextStyle(
          fontSize: 13,
          color: Colors.black,
        ),
        lastMessageAt: TextStyle(
          fontSize: 11,
          color: Colors.black.withOpacity(.5),
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
          color: Colors.white,
          title: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          lastMessageAt: TextStyle(
            fontSize: 11,
            color: Colors.black.withOpacity(.5),
          ),
        ),
        inputBackground: Colors.black.withAlpha(12),
        inputGradient: LinearGradient(colors: [
          Color(0xFF00AEFF),
          Color(0xFF0076FF),
        ]),
      ),
      ownMessageTheme: MessageTheme(
        messageText: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
        createdAt: TextStyle(
          color: Colors.black.withOpacity(.5),
          fontSize: 11,
        ),
        replies: TextStyle(
          color: accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        messageBackgroundColor: Color(0xffebebeb),
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
          color: Colors.black,
        ),
        createdAt: TextStyle(
          color: Colors.black.withOpacity(.5),
          fontSize: 11,
        ),
        replies: TextStyle(
          color: accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        messageBackgroundColor: Colors.white,
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
