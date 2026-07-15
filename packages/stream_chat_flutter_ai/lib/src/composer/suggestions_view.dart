import 'package:flutter/material.dart';

/// Padding inside each suggestion chip — matched when measuring text (see
/// [_SuggestionChip._measureContentWidth]) so the computed width leaves
/// exactly this much room for the label.
const _kChipPadding = EdgeInsets.all(12);

/// A horizontally-scrolling row of free-text quick-reply chips.
///
/// Tapping a chip fires [onSuggestionSelected] with its exact text — the
/// widget itself has no notion of sending a message, so hosts decide what
/// happens next (e.g. populate the composer, or send immediately).
///
/// Mirrors `SuggestionsView` in `stream-chat-swift-ai`
/// (`Sources/StreamChatAI/Composer/SuggestionsView.swift`), which the
/// reference iOS sample docks above its composer on the "new chat" landing
/// screen (no active channel yet):
/// ```swift
/// VStack {
///   Spacer()
///   SuggestionsView(suggestions: predefinedOptions) { messageData in
///     sendMessage(messageData)
///   }
/// }
/// ```
/// This widget only renders the scroll row — the `Spacer`/bottom-docking
/// layout above is left to the host, same as Swift's split between the view
/// and its call site.
///
/// Example:
/// ```dart
/// Column(
///   children: [
///     const Spacer(),
///     AISuggestionsView(
///       suggestions: const [
///         'Create a painting in Renaissance-style',
///         'Help me study vocabulary for an exam',
///       ],
///       onSuggestionSelected: (text) => sendMessage(text),
///     ),
///   ],
/// )
/// ```
class AISuggestionsView extends StatelessWidget {
  /// Creates a [AISuggestionsView].
  const AISuggestionsView({
    super.key,
    required this.suggestions,
    required this.onSuggestionSelected,
    this.itemMaxWidth = 160,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  /// The suggestion strings rendered as chips, in order.
  final List<String> suggestions;

  /// Called with a suggestion's exact text when its chip is tapped.
  final ValueChanged<String> onSuggestionSelected;

  /// The width a chip may grow to before its text wraps/truncates.
  ///
  /// Each chip shrinks to fit its own text — short suggestions get a snug
  /// chip instead of every chip stretching to this same width. Defaults to
  /// `160`, matching `SuggestionsView`'s Swift default.
  final double itemMaxWidth;

  /// Padding around the scrollable row.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = DefaultTextStyle.of(
      context,
    ).style.merge(TextStyle(color: colorScheme.onSurface));
    final textScaler = MediaQuery.textScalerOf(context);
    final textDirection = Directionality.of(context);

    // `IntrinsicHeight` + a plain `Row` (rather than a fixed-height
    // `ListView`, as Swift's `SuggestionsView` uses) lets each chip size to
    // its own 2-line text instead of being hard-clipped to an arbitrary box
    // height.
    return IntrinsicHeight(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final suggestion in suggestions) ...[
              _SuggestionChip(
                key: ValueKey(suggestion),
                text: suggestion,
                textStyle: textStyle,
                textScaler: textScaler,
                textDirection: textDirection,
                maxWidth: itemMaxWidth,
                color: colorScheme.surfaceContainerHigh,
                borderColor: colorScheme.outlineVariant,
                onTap: () => onSuggestionSelected(suggestion),
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }
}

/// A single suggestion chip, sized to snugly fit [text] rather than always
/// stretching to [maxWidth].
class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({
    super.key,
    required this.text,
    required this.textStyle,
    required this.textScaler,
    required this.textDirection,
    required this.maxWidth,
    required this.color,
    required this.borderColor,
    required this.onTap,
  });

  final String text;
  final TextStyle textStyle;
  final TextScaler textScaler;
  final TextDirection textDirection;
  final double maxWidth;
  final Color color;
  final Color borderColor;
  final VoidCallback onTap;

  /// Finds the narrowest width (capped at [maxContentWidth]) that still
  /// fits [text] within 2 lines at the current [textScaler].
  ///
  /// Without this, any suggestion long enough to wrap gets the full
  /// [maxContentWidth] regardless of how much shorter its two lines could
  /// actually be — every wrapping chip ends up the same fixed width instead
  /// of matching its content (which also matters once accessibility text
  /// scaling changes how much text fits per line).
  double _measureContentWidth(double maxContentWidth) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: textDirection,
      textScaler: textScaler,
      maxLines: 2,
    )..layout();

    final naturalWidth = painter.width;
    if (naturalWidth <= maxContentWidth) return naturalWidth;

    painter.layout(maxWidth: maxContentWidth);
    // Even the max width can't fit this in 2 lines (it'll ellipsize) —
    // nothing narrower to gain, so use the full budget.
    if (painter.didExceedMaxLines) return maxContentWidth;

    // Binary search the narrowest width that still fits in 2 lines. Two
    // lines of width `w` hold roughly `2w` worth of single-line content, so
    // `naturalWidth / 2` is a safe lower bound to start from.
    var lo = naturalWidth / 2;
    var hi = maxContentWidth;
    while (hi - lo > 1) {
      final mid = (lo + hi) / 2;
      painter.layout(maxWidth: mid);
      if (painter.didExceedMaxLines) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    return hi;
  }

  @override
  Widget build(BuildContext context) {
    final contentWidth = _measureContentWidth(maxWidth - _kChipPadding.horizontal);

    return DecoratedBox(
      // Same fill/border tokens as the composer's input pill (see
      // `_InputContainer` in chat_composer.dart) so the two read as one
      // connected surface rather than mismatched colors.
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: _kChipPadding,
            child: SizedBox(
              width: contentWidth,
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: textStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
