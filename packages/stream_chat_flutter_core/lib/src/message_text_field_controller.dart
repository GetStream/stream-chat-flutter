import 'package:flutter/material.dart';

/// A function that takes a [BuildContext] and returns an [InlineSpan].
typedef InlineSpanBuilder = InlineSpan Function(
  BuildContext context,
  String text,
);

/// Controller for the [StreamTextField] widget.
class MessageTextFieldController extends TextEditingController {
  /// Returns a new MessageTextFieldController
  MessageTextFieldController({
    String? text,
    this.textPatternSpan,
  }) : super(text: text);

  /// Returns a new MessageTextFieldController with the given text [value].
  MessageTextFieldController.fromValue(
    TextEditingValue? value, {
    this.textPatternSpan,
  }) : super.fromValue(value);

  /// A map of style to apply to the text matching the RegExp patterns.
  final Map<RegExp, InlineSpanBuilder>? textPatternSpan;

  /// Builds a [TextSpan] from the current text,
  /// highlighting the matches for [textPatternStyle].
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final pattern = textPatternSpan;
    if (pattern == null || pattern.isEmpty) {
      return super.buildTextSpan(
        context: context,
        style: style,
        withComposing: withComposing,
      );
    }

    return TextSpan(text: text, style: style).splitMapJoin(
      RegExp(pattern.keys.map((it) => it.pattern).join('|')),
      onMatch: (match) {
        final text = match[0]!;
        final key = pattern.keys.firstWhere((it) => it.hasMatch(text));
        return pattern[key]?.call(context, text) ??
            TextSpan(
              text: text,
            );
      },
    );
  }
}

extension _TextSpanX on TextSpan {
  TextSpan splitMapJoin(
    Pattern pattern, {
    InlineSpan Function(Match)? onMatch,
    InlineSpan Function(InlineSpan)? onNonMatch,
  }) {
    final children = <InlineSpan>[];

    toPlainText().splitMapJoin(
      pattern,
      onMatch: (match) {
        final span = TextSpan(text: match.group(0), style: style);
        final updated = onMatch?.call(match);
        children.add(updated ?? span);
        return span.toPlainText();
      },
      onNonMatch: (text) {
        final span = TextSpan(text: text, style: style);
        final updatedSpan = onNonMatch?.call(span);
        children.add(updatedSpan ?? span);
        return span.toPlainText();
      },
    );

    return TextSpan(style: style, children: children);
  }
}
