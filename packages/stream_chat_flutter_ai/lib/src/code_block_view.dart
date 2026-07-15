import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _kBgColor = Color(0xFF1E1E1E);
const _kFgColor = Color(0xFFD4D4D4);
const _kLabelColor = Color(0xFF858585);

/// Renders a fenced code block with a dark background, monospace text, a
/// copy-to-clipboard button, and an optional language label.
class CodeBlockView extends StatelessWidget {
  /// Creates a [CodeBlockView].
  const CodeBlockView({super.key, required this.code, this.language});

  /// The raw code text (without the surrounding fences).
  final String code;

  /// The language identifier from the opening fence, e.g. `dart`, `python`.
  final String? language;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: _kBgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(language: language, code: code),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SelectableText(
              code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: _kFgColor,
                height: 1.5,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.language, required this.code});

  final String? code;
  final String? language;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
      child: Row(
        children: [
          if (language != null && language!.isNotEmpty)
            Text(
              language!,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: _kLabelColor,
              ),
            ),
          const Spacer(),
          _CopyButton(code: code ?? ''),
        ],
      ),
    );
  }
}

class _CopyButton extends StatefulWidget {
  const _CopyButton({required this.code});

  final String code;

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  Future<void> _onTap() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _onTap,
      icon: Icon(
        _copied ? Icons.check : Icons.content_copy,
        size: 16,
        color: _copied ? Colors.greenAccent : _kLabelColor,
      ),
      tooltip: _copied ? 'Copied!' : 'Copy code',
      style: IconButton.styleFrom(
        minimumSize: const Size(32, 32),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
