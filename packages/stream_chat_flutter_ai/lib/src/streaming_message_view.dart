import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart' show MarkdownStyleSheet;
import 'package:stream_chat_flutter_ai/src/ai_markdown_body.dart';
import 'package:stream_chat_flutter_ai/src/typewriter_builder.dart';

bool get _isDesktopDeviceOrWeb =>
    kIsWeb ||
    defaultTargetPlatform == TargetPlatform.macOS ||
    defaultTargetPlatform == TargetPlatform.windows ||
    defaultTargetPlatform == TargetPlatform.linux;

/// {@template streamingMessageView}
/// A widget that displays a message in a streaming fashion. The message is
/// displayed as if it is being typed out by a typewriter.
///
/// Markdown in the message is fully rendered, including:
/// - Fenced code blocks (with a copy-to-clipboard button and language label).
/// - JSON / chart blocks rendered as interactive charts.
/// {@endtemplate}
class StreamingMessageView extends StatefulWidget {
  /// {@macro streamingMessageView}
  const StreamingMessageView({
    super.key,
    required this.text,
    this.onTapLink,
    this.typingSpeed = const Duration(milliseconds: 10),
    this.onTypewriterStateChanged,
    this.styleSheet,
  });

  /// The text to display in the widget.
  final String text;

  /// Style overrides for the rendered markdown. See
  /// [AIMarkdownBody.styleSheet].
  final MarkdownStyleSheet? styleSheet;

  /// The speed at which the text is typed out.
  ///
  /// Defaults to 10 milliseconds per character.
  final Duration typingSpeed;

  /// Called when the user taps a hyperlink in the rendered markdown.
  ///
  /// If not provided, links are silently ignored.
  final MarkdownTapLinkCallback? onTapLink;

  /// A callback that is called whenever the typewriter state changes.
  final ValueChanged<TypewriterState>? onTypewriterStateChanged;

  @override
  State<StreamingMessageView> createState() => _StreamingMessageViewState();
}

class _StreamingMessageViewState extends State<StreamingMessageView> {
  late String _displayText;
  late final TypewriterController _controller;

  void _onTypewriterValueChanged() {
    final value = _controller.value;
    widget.onTypewriterStateChanged?.call(value.state);
    setState(() => _displayText = value.text);
  }

  @override
  void initState() {
    super.initState();
    _controller = TypewriterController(
      text: widget.text,
      typingSpeed: widget.typingSpeed,
    )..addListener(_onTypewriterValueChanged);

    _displayText = _controller.value.text;
  }

  @override
  void didUpdateWidget(covariant StreamingMessageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _controller.updateText(widget.text);
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTypewriterValueChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AIMarkdownBody(
      data: _displayText,
      selectable: _isDesktopDeviceOrWeb,
      onTapLink: widget.onTapLink,
      styleSheet: widget.styleSheet,
    );
  }
}
