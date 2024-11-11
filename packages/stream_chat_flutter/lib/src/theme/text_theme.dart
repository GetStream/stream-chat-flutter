import 'package:flutter/material.dart';

/// {@template text_theme}
/// Class for holding text theme
/// {@endtemplate}
class StreamTextTheme {
  /// Initialise light text theme
  StreamTextTheme.light({
    this.title = const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    this.headline = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    this.headlineBold = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    this.body = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    this.bodyBold = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    this.footnote = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    this.footnoteBold = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    this.captionBold = const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
  });

  /// Initialise with dark theme
  StreamTextTheme.dark({
    this.title = const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    this.headline = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    this.headlineBold = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    this.body = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    this.bodyBold = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    this.footnote = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    this.footnoteBold = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    this.captionBold = const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
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
  StreamTextTheme copyWith({
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
          ? StreamTextTheme.light(
              body: body ?? this.body,
              title: title ?? this.title,
              headlineBold: headlineBold ?? this.headlineBold,
              headline: headline ?? this.headline,
              bodyBold: bodyBold ?? this.bodyBold,
              footnoteBold: footnoteBold ?? this.footnoteBold,
              footnote: footnote ?? this.footnote,
              captionBold: captionBold ?? this.captionBold,
            )
          : StreamTextTheme.dark(
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
  StreamTextTheme merge(StreamTextTheme? other) {
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
