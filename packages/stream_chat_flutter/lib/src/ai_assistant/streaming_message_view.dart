import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stream_chat_flutter/src/ai_assistant/stream_typewriter_builder.dart';
import 'package:stream_chat_flutter/src/misc/markdown_message.dart';
import 'package:stream_chat_flutter/src/utils/device_segmentation.dart';
import 'package:stream_chat_flutter/src/utils/helpers.dart';

/// {@template streamingMessageView}
/// A widget that displays a message in a streaming fashion. The message is
/// displayed as if it is being typed out by a typewriter.
/// {@endtemplate}
class StreamingMessageView extends StatefulWidget {
  /// {@macro streamingMessageView}
  const StreamingMessageView({
    super.key,
    required this.text,
    this.onTapLink,
    this.typingSpeed = const Duration(milliseconds: 10),
    this.onTypewriterStateChanged,
  });

  /// The text to display in the widget.
  final String text;

  /// The speed at which the text is typed out.
  ///
  /// Defaults to 10 milliseconds per character.
  final Duration typingSpeed;

  /// Called when the user taps a link in the message.
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
    return StreamMarkdownMessage(
      data: _displayText,
      selectable: isDesktopDeviceOrWeb,
      onTapLink: switch (widget.onTapLink) {
        final onTapLink? => onTapLink,
        _ => (String link, String? href, String title) {
            if (href != null) launchURL(context, href);
          },
      },
    );
  }
}
