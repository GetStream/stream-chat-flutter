import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/avatar_theme.dart';

/// {@template message_theme_data}
/// Class for getting message theme
/// {@endtemplate}
// ignore: prefer-match-file-name
class StreamMessageThemeData with Diagnosticable {
  /// Creates a [StreamMessageThemeData].
  const StreamMessageThemeData({
    this.repliesStyle,
    this.messageTextStyle,
    this.messageAuthorStyle,
    this.messageLinksStyle,
    this.messageDeletedStyle,
    this.messageBackgroundColor,
    this.messageBackgroundGradient,
    this.messageBorderColor,
    this.reactionsBackgroundColor,
    this.reactionsBorderColor,
    this.reactionsMaskColor,
    this.avatarTheme,
    this.createdAtStyle,
    this.urlAttachmentBackgroundColor,
    this.urlAttachmentHostStyle,
    this.urlAttachmentTitleStyle,
    this.urlAttachmentTextStyle,
    this.urlAttachmentTitleMaxLine,
    this.urlAttachmentTextMaxLine,
  });

  /// Text style for message text
  final TextStyle? messageTextStyle;

  /// Text style for message author
  final TextStyle? messageAuthorStyle;

  /// Text style for message links
  final TextStyle? messageLinksStyle;

  /// Text style for created at text
  final TextStyle? createdAtStyle;

  /// Text style for the text on a deleted message
  /// If not set [messageTextStyle] is used with [FontStyle.italic] and
  /// [createdAtStyle.color].
  final TextStyle? messageDeletedStyle;

  /// Text style for replies
  final TextStyle? repliesStyle;

  /// Color for messageBackgroundColor
  final Color? messageBackgroundColor;

  /// Gradient for message background. Takes precedence over messageBackgroundColor
  /// when both are provided.
  final Gradient? messageBackgroundGradient;

  /// Color for message border color
  final Color? messageBorderColor;

  /// Color for reactions
  final Color? reactionsBackgroundColor;

  /// Colors reaction border
  final Color? reactionsBorderColor;

  /// Color for reaction mask
  final Color? reactionsMaskColor;

  /// Theme of the avatar
  final StreamAvatarThemeData? avatarTheme;

  /// Background color for messages with url attachments.
  final Color? urlAttachmentBackgroundColor;

  /// Color for url attachment host.
  final TextStyle? urlAttachmentHostStyle;

  /// Color for url attachment title.
  final TextStyle? urlAttachmentTitleStyle;

  /// Color for url attachment text.
  final TextStyle? urlAttachmentTextStyle;

  /// Max number of lines in Url link title.
  final int? urlAttachmentTitleMaxLine;

  /// Max number of lines in Url link text.
  final int? urlAttachmentTextMaxLine;

  /// Copy with a theme
  StreamMessageThemeData copyWith({
    TextStyle? messageTextStyle,
    TextStyle? messageAuthorStyle,
    TextStyle? messageLinksStyle,
    TextStyle? messageDeletedStyle,
    TextStyle? createdAtStyle,
    TextStyle? repliesStyle,
    Color? messageBackgroundColor,
    Gradient? messageBackgroundGradient,
    Color? messageBorderColor,
    StreamAvatarThemeData? avatarTheme,
    Color? reactionsBackgroundColor,
    Color? reactionsBorderColor,
    Color? reactionsMaskColor,
    Color? urlAttachmentBackgroundColor,
    TextStyle? urlAttachmentHostStyle,
    TextStyle? urlAttachmentTitleStyle,
    TextStyle? urlAttachmentTextStyle,
    int? urlAttachmentTitleMaxLine,
    int? urlAttachmentTextMaxLine,
  }) {
    return StreamMessageThemeData(
      messageTextStyle: messageTextStyle ?? this.messageTextStyle,
      messageAuthorStyle: messageAuthorStyle ?? this.messageAuthorStyle,
      messageLinksStyle: messageLinksStyle ?? this.messageLinksStyle,
      createdAtStyle: createdAtStyle ?? this.createdAtStyle,
      messageDeletedStyle: messageDeletedStyle ?? this.messageDeletedStyle,
      messageBackgroundColor:
          messageBackgroundColor ?? this.messageBackgroundColor,
      messageBackgroundGradient:
          messageBackgroundGradient ?? this.messageBackgroundGradient,
      messageBorderColor: messageBorderColor ?? this.messageBorderColor,
      avatarTheme: avatarTheme ?? this.avatarTheme,
      repliesStyle: repliesStyle ?? this.repliesStyle,
      reactionsBackgroundColor:
          reactionsBackgroundColor ?? this.reactionsBackgroundColor,
      reactionsBorderColor: reactionsBorderColor ?? this.reactionsBorderColor,
      reactionsMaskColor: reactionsMaskColor ?? this.reactionsMaskColor,
      urlAttachmentBackgroundColor:
          urlAttachmentBackgroundColor ?? this.urlAttachmentBackgroundColor,
      urlAttachmentHostStyle:
          urlAttachmentHostStyle ?? this.urlAttachmentHostStyle,
      urlAttachmentTitleStyle:
          urlAttachmentTitleStyle ?? this.urlAttachmentTitleStyle,
      urlAttachmentTextStyle:
          urlAttachmentTextStyle ?? this.urlAttachmentTextStyle,
      urlAttachmentTitleMaxLine:
          urlAttachmentTitleMaxLine ?? this.urlAttachmentTitleMaxLine,
      urlAttachmentTextMaxLine:
          urlAttachmentTextMaxLine ?? this.urlAttachmentTextMaxLine,
    );
  }

  /// Linearly interpolate from one [StreamMessageThemeData] to another.
  StreamMessageThemeData lerp(
    StreamMessageThemeData a,
    StreamMessageThemeData b,
    double t,
  ) {
    return StreamMessageThemeData(
      avatarTheme:
          const StreamAvatarThemeData().lerp(a.avatarTheme!, b.avatarTheme!, t),
      messageAuthorStyle:
          TextStyle.lerp(a.messageAuthorStyle, b.messageAuthorStyle, t),
      createdAtStyle: TextStyle.lerp(a.createdAtStyle, b.createdAtStyle, t),
      messageDeletedStyle:
          TextStyle.lerp(a.messageDeletedStyle, b.messageDeletedStyle, t),
      messageBackgroundColor:
          Color.lerp(a.messageBackgroundColor, b.messageBackgroundColor, t),
      messageBackgroundGradient:
          t < 0.5 ? a.messageBackgroundGradient : b.messageBackgroundGradient,
      messageBorderColor:
          Color.lerp(a.messageBorderColor, b.messageBorderColor, t),
      messageLinksStyle:
          TextStyle.lerp(a.messageLinksStyle, b.messageLinksStyle, t),
      messageTextStyle:
          TextStyle.lerp(a.messageTextStyle, b.messageTextStyle, t),
      reactionsBackgroundColor: Color.lerp(
        a.reactionsBackgroundColor,
        b.reactionsBackgroundColor,
        t,
      ),
      reactionsBorderColor:
          Color.lerp(a.messageBorderColor, b.reactionsBorderColor, t),
      reactionsMaskColor:
          Color.lerp(a.reactionsMaskColor, b.reactionsMaskColor, t),
      repliesStyle: TextStyle.lerp(a.repliesStyle, b.repliesStyle, t),
      urlAttachmentBackgroundColor: Color.lerp(
        a.urlAttachmentBackgroundColor,
        b.urlAttachmentBackgroundColor,
        t,
      ),
      urlAttachmentHostStyle:
          TextStyle.lerp(a.urlAttachmentHostStyle, b.urlAttachmentHostStyle, t),
      urlAttachmentTextStyle: TextStyle.lerp(
        a.urlAttachmentTextStyle,
        b.urlAttachmentTextStyle,
        t,
      ),
      urlAttachmentTitleStyle: TextStyle.lerp(
        a.urlAttachmentTitleStyle,
        b.urlAttachmentTitleStyle,
        t,
      ),
      urlAttachmentTitleMaxLine: lerpDouble(
        a.urlAttachmentTitleMaxLine,
        b.urlAttachmentTitleMaxLine,
        t,
      )?.round(),
      urlAttachmentTextMaxLine: lerpDouble(
        a.urlAttachmentTextMaxLine,
        b.urlAttachmentTextMaxLine,
        t,
      )?.round(),
    );
  }

  /// Merge with a theme
  StreamMessageThemeData merge(StreamMessageThemeData? other) {
    if (other == null) return this;
    return copyWith(
      messageTextStyle: messageTextStyle?.merge(other.messageTextStyle) ??
          other.messageTextStyle,
      messageAuthorStyle: messageAuthorStyle?.merge(other.messageAuthorStyle) ??
          other.messageAuthorStyle,
      messageLinksStyle: messageLinksStyle?.merge(other.messageLinksStyle) ??
          other.messageLinksStyle,
      createdAtStyle:
          createdAtStyle?.merge(other.createdAtStyle) ?? other.createdAtStyle,
      messageDeletedStyle:
          messageDeletedStyle?.merge(other.messageDeletedStyle) ??
              other.messageDeletedStyle,
      repliesStyle:
          repliesStyle?.merge(other.repliesStyle) ?? other.repliesStyle,
      messageBackgroundColor: other.messageBackgroundColor,
      messageBackgroundGradient: other.messageBackgroundGradient,
      messageBorderColor: other.messageBorderColor,
      avatarTheme: avatarTheme?.merge(other.avatarTheme) ?? other.avatarTheme,
      reactionsBackgroundColor: other.reactionsBackgroundColor,
      reactionsBorderColor: other.reactionsBorderColor,
      reactionsMaskColor: other.reactionsMaskColor,
      urlAttachmentBackgroundColor: other.urlAttachmentBackgroundColor,
      urlAttachmentHostStyle: other.urlAttachmentHostStyle,
      urlAttachmentTitleStyle: other.urlAttachmentTitleStyle,
      urlAttachmentTextStyle: other.urlAttachmentTextStyle,
      urlAttachmentTitleMaxLine: other.urlAttachmentTitleMaxLine,
      urlAttachmentTextMaxLine: other.urlAttachmentTextMaxLine,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamMessageThemeData &&
          runtimeType == other.runtimeType &&
          messageTextStyle == other.messageTextStyle &&
          messageAuthorStyle == other.messageAuthorStyle &&
          messageLinksStyle == other.messageLinksStyle &&
          createdAtStyle == other.createdAtStyle &&
          messageDeletedStyle == other.messageDeletedStyle &&
          repliesStyle == other.repliesStyle &&
          messageBackgroundColor == other.messageBackgroundColor &&
          messageBackgroundGradient == other.messageBackgroundGradient &&
          messageBorderColor == other.messageBorderColor &&
          reactionsBackgroundColor == other.reactionsBackgroundColor &&
          reactionsBorderColor == other.reactionsBorderColor &&
          reactionsMaskColor == other.reactionsMaskColor &&
          avatarTheme == other.avatarTheme &&
          urlAttachmentBackgroundColor == other.urlAttachmentBackgroundColor &&
          urlAttachmentHostStyle == other.urlAttachmentHostStyle &&
          urlAttachmentTitleStyle == other.urlAttachmentTitleStyle &&
          urlAttachmentTextStyle == other.urlAttachmentTextStyle &&
          urlAttachmentTitleMaxLine == other.urlAttachmentTitleMaxLine &&
          urlAttachmentTextMaxLine == other.urlAttachmentTextMaxLine;

  @override
  int get hashCode =>
      messageTextStyle.hashCode ^
      messageAuthorStyle.hashCode ^
      messageLinksStyle.hashCode ^
      createdAtStyle.hashCode ^
      messageDeletedStyle.hashCode ^
      repliesStyle.hashCode ^
      messageBackgroundColor.hashCode ^
      messageBackgroundGradient.hashCode ^
      messageBorderColor.hashCode ^
      reactionsBackgroundColor.hashCode ^
      reactionsBorderColor.hashCode ^
      reactionsMaskColor.hashCode ^
      avatarTheme.hashCode ^
      urlAttachmentBackgroundColor.hashCode ^
      urlAttachmentHostStyle.hashCode ^
      urlAttachmentTitleStyle.hashCode ^
      urlAttachmentTextStyle.hashCode ^
      urlAttachmentTitleMaxLine.hashCode ^
      urlAttachmentTextMaxLine.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('messageTextStyle', messageTextStyle))
      ..add(DiagnosticsProperty('messageAuthorStyle', messageAuthorStyle))
      ..add(DiagnosticsProperty('messageLinksStyle', messageLinksStyle))
      ..add(DiagnosticsProperty('createdAtStyle', createdAtStyle))
      ..add(DiagnosticsProperty('messageDeletedStyle', messageDeletedStyle))
      ..add(DiagnosticsProperty('repliesStyle', repliesStyle))
      ..add(ColorProperty('messageBackgroundColor', messageBackgroundColor))
      ..add(DiagnosticsProperty('messageBackgroundGradient', messageBackgroundGradient))
      ..add(ColorProperty('messageBorderColor', messageBorderColor))
      ..add(DiagnosticsProperty('avatarTheme', avatarTheme))
      ..add(ColorProperty('reactionsBackgroundColor', reactionsBackgroundColor))
      ..add(ColorProperty('reactionsBorderColor', reactionsBorderColor))
      ..add(ColorProperty('reactionsMaskColor', reactionsMaskColor))
      ..add(ColorProperty(
        'urlAttachmentBackgroundColor',
        urlAttachmentBackgroundColor,
      ))
      ..add(DiagnosticsProperty(
        'urlAttachmentHostStyle',
        urlAttachmentHostStyle,
      ))
      ..add(DiagnosticsProperty(
        'urlAttachmentTitleStyle',
        urlAttachmentTitleStyle,
      ))
      ..add(DiagnosticsProperty(
        'urlAttachmentTextStyle',
        urlAttachmentTextStyle,
      ))
      ..add(DiagnosticsProperty(
        'urlAttachmentTitleMaxLine',
        urlAttachmentTitleMaxLine,
      ))
      ..add(DiagnosticsProperty(
        'urlAttachmentTextMaxLine',
        urlAttachmentTextMaxLine,
      ));
  }
}
