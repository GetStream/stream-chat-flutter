import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:stream_chat_flutter_ai/src/chart/chart_view.dart';
import 'package:stream_chat_flutter_ai/src/chart/uspec.dart';
import 'package:stream_chat_flutter_ai/src/code_block_view.dart';

/// Callback fired when the user taps a hyperlink in the rendered markdown.
///
/// Parameters mirror `flutter_markdown_plus`'s `MarkdownTapLinkCallback`:
/// [text] is the link label, [href] is the URL (may be null), and [title] is
/// the optional title attribute.
typedef MarkdownTapLinkCallback = void Function(String text, String? href, String title);

/// The set of languages whose fences are treated as chart blocks.
const _kChartLanguages = {'json', 'chart', 'chartjs', 'echarts', 'plotly', 'vega'};

/// Regex that splits markdown into text and fenced-code segments.
///
/// Group 1: language identifier (possibly empty).
/// Group 2: the raw code content inside the fence.
final _kFenceRegex = RegExp(r'```(\w*)\n([\s\S]*?)```', multiLine: true);

/// A markdown renderer tailored for AI-generated messages.
///
/// Parses the markdown string into segments and renders:
/// - Text segments via [MarkdownBody] (from `flutter_markdown_plus`).
/// - Code fences via [CodeBlockView] (dark box, copy button, language label).
/// - JSON / chart fences via [ChartView] when the content is a valid [USpec];
///   otherwise falls back to [CodeBlockView].
class AiMarkdownBody extends StatelessWidget {
  /// Creates an [AiMarkdownBody].
  const AiMarkdownBody({
    super.key,
    required this.data,
    this.onTapLink,
    this.selectable = false,
  });

  /// The markdown string to render.
  final String data;

  /// Called when the user taps a hyperlink.
  final MarkdownTapLinkCallback? onTapLink;

  /// Whether text content is selectable (pass `true` on desktop / web).
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final segments = _parse(data);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: segments.map((s) => _buildSegment(context, s)).toList(),
    );
  }

  Widget _buildSegment(BuildContext context, _Segment segment) {
    if (segment is _TextSegment) {
      if (segment.text.trim().isEmpty) return const SizedBox.shrink();
      return MarkdownBody(
        data: segment.text,
        selectable: selectable,
        onTapLink: onTapLink != null
            ? (text, href, title) => onTapLink!(text, href, title)
            : null,
      );
    }

    final code = segment as _CodeSegment;

    // Try to render as a chart when the language suggests JSON / chart content.
    if (_kChartLanguages.contains(code.language.toLowerCase())) {
      final spec = USpecParser.tryParse(code.code);
      if (spec != null) return ChartView(spec: spec);
    }

    return CodeBlockView(
      code: code.code,
      language: code.language.isEmpty ? null : code.language,
    );
  }

  // ---------------------------------------------------------------------------
  // Markdown → segment list
  // ---------------------------------------------------------------------------

  static List<_Segment> _parse(String markdown) {
    final segments = <_Segment>[];
    var cursor = 0;

    for (final match in _kFenceRegex.allMatches(markdown)) {
      // Text before this fence.
      if (match.start > cursor) {
        segments.add(_TextSegment(markdown.substring(cursor, match.start)));
      }
      segments.add(_CodeSegment(
        language: match.group(1) ?? '',
        code: (match.group(2) ?? '').trimRight(),
      ));
      cursor = match.end;
    }

    // Trailing text (or the whole string if there were no fences).
    if (cursor < markdown.length) {
      segments.add(_TextSegment(markdown.substring(cursor)));
    }

    return segments;
  }
}

// ---------------------------------------------------------------------------
// Internal segment types
// ---------------------------------------------------------------------------

sealed class _Segment {
  const _Segment();
}

final class _TextSegment extends _Segment {
  const _TextSegment(this.text);

  final String text;
}

final class _CodeSegment extends _Segment {
  const _CodeSegment({required this.language, required this.code});

  final String language;
  final String code;
}
