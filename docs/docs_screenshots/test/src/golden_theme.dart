import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

// ---------------------------------------------------------------------------
// StreamTheme (stream_core_flutter) — drives new message text rendering
// ---------------------------------------------------------------------------
//
// core.DefaultStreamMessageText reads its text style from
// StreamTheme.of(context).textTheme.bodyDefault. Those styles carry no
// fontFamily by default; when MarkdownBody passes them as the `p` style to
// RichText, RichText does NOT inherit DefaultTextStyle, so Flutter falls back
// to the Ahem test font (black rectangles).
//
// Fix: build a StreamTheme whose textTheme has fontFamily: 'Roboto' applied.
//
// ---------------------------------------------------------------------------
// StreamChatThemeData (stream_chat_flutter) — drives legacy message rendering
// ---------------------------------------------------------------------------
//
// StreamChatThemeData text styles (body, footnote, …) also carry no fontFamily.
// Same Ahem problem for any remaining legacy widgets that go through
// StreamMarkdownMessage → MarkdownBody → RichText.
//
// Fix: merge fontFamily: 'Roboto' into every StreamTextTheme style.

ThemeData docsScreenshotsTheme() {
  final streamTextTheme = core.StreamTextTheme().apply(
    color: core.StreamColorScheme.light().systemText,
    fontFamily: 'Roboto',
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFFFF),
    ),
    extensions: [
      StreamTheme(brightness: Brightness.light, textTheme: streamTextTheme),
    ],
  );
}
