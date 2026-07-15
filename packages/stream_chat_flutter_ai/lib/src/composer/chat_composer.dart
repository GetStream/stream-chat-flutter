import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_chat_flutter_ai/src/composer/chat_composer_controller.dart';
import 'package:stream_chat_flutter_ai/src/composer/chat_composer_factory.dart';
import 'package:stream_chat_flutter_ai/src/composer/chat_option.dart';
import 'package:stream_chat_flutter_ai/src/composer/composer_action_button.dart';
import 'package:stream_chat_flutter_ai/src/composer/speech_to_text_button.dart';

/// Callback fired when the user taps the send button.
///
/// [text] is the current message text. [selectedOption] is the active
/// [ChatOption], or `null` if the user did not select one. [attachments] is
/// the list of images the user picked via the composer's attachment button.
typedef ChatComposerSendCallback =
    void Function(
      String text,
      ChatOption? selectedOption,
      List<XFile> attachments,
    );

/// An AI-aware message composer.
///
/// Renders a text input with:
/// - An inline selected-option chip (with dismiss button) inside the input
///   box once a [ChatOption] is selected — see `ComposerAttachmentSheet`,
///   which lists [ChatComposerController.chatOptions] alongside the photo
///   picker, opened from the composer's leading "+" button by default.
/// - A row of image thumbnails above the input when the user has picked
///   attachments (see [ChatComposerFactory.buildLeading]).
/// - A single circular trailing control that morphs between voice input
///   (empty field), send (field has content), and stop (while
///   [ChatComposerController.isGenerating] is `true`).
///
/// All layout regions are customisable via [ChatComposerFactory].
///
/// Example:
/// ```dart
/// ChatComposer(
///   controller: controller,
///   onSendPressed: (text, option, attachments) async {
///     await myBackend.sendMessage(text, attachments);
///   },
///   onStopPressed: () => myBackend.stopGenerating(),
/// );
/// ```
class ChatComposer extends StatefulWidget {
  /// Creates a [ChatComposer].
  const ChatComposer({
    super.key,
    this.controller,
    required this.onSendPressed,
    this.onStopPressed,
    this.factory = const ChatComposerFactory(),
    this.focusNode,
    this.hintText,
    this.minLines = 1,
    this.maxLines = 8,
    this.textInputAction = TextInputAction.newline,
    this.enableSpeechToText = false,
  });

  /// The controller that manages input text, chat options, attachments, and
  /// generating state.
  ///
  /// If not provided, an internal controller is created and disposed
  /// automatically.
  final ChatComposerController? controller;

  /// Called when the user taps the send button.
  final ChatComposerSendCallback onSendPressed;

  /// Called when the user taps the stop button while the AI is generating.
  final VoidCallback? onStopPressed;

  /// Factory used to build the leading and trailing slots.
  final ChatComposerFactory factory;

  /// Focus node for the text field.
  final FocusNode? focusNode;

  /// Placeholder text shown when the text field is empty.
  final String? hintText;

  /// Minimum number of lines in the text field.
  final int minLines;

  /// Maximum number of lines the text field may grow to before scrolling.
  final int maxLines;

  /// The action shown on the keyboard's action button.
  final TextInputAction textInputAction;

  /// Whether to show a voice-input button in place of the send button when
  /// the text field is empty.
  ///
  /// When `true`, the composer's single trailing control shows a mic while
  /// the field is empty and the AI isn't generating a response, and morphs
  /// into the send button as soon as the user types (or the stop button
  /// while generating). Requires the platform permissions documented on
  /// [SpeechToTextButton]. Defaults to `false`.
  final bool enableSpeechToText;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  late ChatComposerController _controller;
  late FocusNode _focusNode;
  bool _ownsController = false;
  bool _ownsFocusNode = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = ChatComposerController();
      _ownsController = true;
    } else {
      _controller = widget.controller!;
    }
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    } else {
      _focusNode = widget.focusNode!;
    }
  }

  @override
  void didUpdateWidget(covariant ChatComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (_ownsController) {
        _controller.dispose();
        _ownsController = false;
      }
      if (widget.controller == null) {
        _controller = ChatComposerController();
        _ownsController = true;
      } else {
        _controller = widget.controller!;
      }
    }
    if (widget.focusNode != oldWidget.focusNode) {
      if (_ownsFocusNode) {
        _focusNode.dispose();
        _ownsFocusNode = false;
      }
      if (widget.focusNode == null) {
        _focusNode = FocusNode();
        _ownsFocusNode = true;
      } else {
        _focusNode = widget.focusNode!;
      }
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  void _onSend() {
    if (!_controller.hasContent) return;
    widget.onSendPressed(
      _controller.text,
      _controller.selectedChatOption,
      _controller.attachments,
    );
    _controller.clear();
    _focusNode.requestFocus();
  }

  void _onStop() {
    widget.onStopPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final leading = widget.factory.buildLeading(context, _controller);
        final trailing = widget.factory.buildTrailing(context, _controller);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                // Centered, not `.end` — the pill is taller than the fixed-size
                // leading/trailing circles (its height grows with multi-line
                // text), and bottom-aligning them dumps 100% of that extra
                // height above the circles as a lopsided gap. Centering keeps
                // the circles evenly inset, matching the reference Android
                // layout, where both the "+" and mic sit centered within the
                // pill's height rather than flush to its bottom edge.
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (leading != null) ...[leading, const SizedBox(width: 8)],
                  Expanded(
                    child: _InputContainer(
                      controller: _controller,
                      focusNode: _focusNode,
                      hintText: widget.hintText,
                      minLines: widget.minLines,
                      maxLines: widget.maxLines,
                      textInputAction: widget.textInputAction,
                      enableSpeechToText: widget.enableSpeechToText,
                      onSend: _onSend,
                      onStop: _onStop,
                    ),
                  ),
                  if (trailing != null) ...[const SizedBox(width: 8), trailing],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Input container
// ---------------------------------------------------------------------------

class _InputContainer extends StatelessWidget {
  const _InputContainer({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onStop,
    this.hintText,
    this.minLines = 1,
    this.maxLines = 8,
    this.textInputAction = TextInputAction.newline,
    this.enableSpeechToText = false,
  });

  final ChatComposerController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final VoidCallback onStop;
  final String? hintText;
  final int minLines;
  final int maxLines;
  final TextInputAction textInputAction;
  final bool enableSpeechToText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = colorScheme.outlineVariant;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (controller.selectedChatOption != null)
            _SelectedOptionChip(
              option: controller.selectedChatOption!,
              onDismiss: controller.clearSelectedChatOption,
            ),
          if (controller.attachments.isNotEmpty)
            _AttachmentThumbnails(
              attachments: controller.attachments,
              onRemove: controller.removeAttachment,
            ),
          Row(
            // Centered so the trailing mic/send/stop circle sits evenly
            // inset within the pill instead of flush to one edge — see the
            // comment on the outer Row in `_ChatComposerState.build`.
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: controller.textEditingController,
                  focusNode: focusNode,
                  minLines: minLines,
                  maxLines: maxLines,
                  textInputAction: textInputAction,
                  decoration: InputDecoration(
                    hintText: hintText ?? 'Ask anything…',
                    hintStyle: TextStyle(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                  ),
                  onSubmitted: (_) {
                    if (textInputAction == TextInputAction.send) onSend();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                  child: _TrailingControl(
                    key: ValueKey(
                      _trailingState(controller, enableSpeechToText),
                    ),
                    controller: controller,
                    onSend: onSend,
                    onStop: onStop,
                    enableSpeechToText: enableSpeechToText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Identifies which of the trailing control's states is currently active, so
/// [AnimatedSwitcher] can key on it and animate transitions between them.
String _trailingState(
  ChatComposerController controller,
  bool enableSpeechToText,
) {
  if (controller.isGenerating) return 'stop';
  if (controller.hasContent) return 'send';
  if (enableSpeechToText) return 'mic';
  return 'send-disabled';
}

// ---------------------------------------------------------------------------
// Trailing control (mic / send / stop — one morphing button)
// ---------------------------------------------------------------------------

class _TrailingControl extends StatelessWidget {
  const _TrailingControl({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onStop,
    required this.enableSpeechToText,
  });

  final ChatComposerController controller;
  final VoidCallback onSend;
  final VoidCallback onStop;
  final bool enableSpeechToText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (controller.isGenerating) {
      return ComposerActionButton(
        icon: Icons.stop_rounded,
        onPressed: onStop,
        tooltip: 'Stop generating',
        color: colorScheme.error,
      );
    }

    if (controller.hasContent) {
      return ComposerActionButton(
        icon: Icons.arrow_upward_rounded,
        onPressed: onSend,
        tooltip: 'Send',
        color: colorScheme.primary,
      );
    }

    if (enableSpeechToText) {
      return SpeechToTextButton(controller: controller);
    }

    return ComposerActionButton(
      icon: Icons.arrow_upward_rounded,
      onPressed: null,
      tooltip: 'Send',
      color: colorScheme.primary,
    );
  }
}

// ---------------------------------------------------------------------------
// Attachment thumbnails
// ---------------------------------------------------------------------------

class _AttachmentThumbnails extends StatelessWidget {
  const _AttachmentThumbnails({
    required this.attachments,
    required this.onRemove,
  });

  final List<XFile> attachments;
  final ValueChanged<XFile> onRemove;

  static const double _size = 64;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: SizedBox(
        height: _size,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: attachments.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final file = attachments[index];
            return _AttachmentThumbnail(
              key: ValueKey(file.path),
              file: file,
              onRemove: () => onRemove(file),
            );
          },
        ),
      ),
    );
  }
}

class _AttachmentThumbnail extends StatelessWidget {
  const _AttachmentThumbnail({
    super.key,
    required this.file,
    required this.onRemove,
  });

  final XFile file;
  final VoidCallback onRemove;

  static const double _size = 64;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: _size,
      height: _size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: _size,
              height: _size,
              child: FutureBuilder<Uint8List>(
                future: file.readAsBytes(),
                builder: (context, snapshot) {
                  final bytes = snapshot.data;
                  if (bytes == null) {
                    return ColoredBox(color: colorScheme.surface);
                  }
                  return Image.memory(bytes, fit: BoxFit.cover);
                },
              ),
            ),
          ),
          Positioned(
            top: -6,
            right: -6,
            child: InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Selected option chip (inline in input box)
// ---------------------------------------------------------------------------

class _SelectedOptionChip extends StatelessWidget {
  const _SelectedOptionChip({required this.option, required this.onDismiss});

  final ChatOption option;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 2),
      child: Align(
        alignment: Alignment.centerLeft,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 6, 8, 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (option.icon != null) ...[
                  Icon(option.icon, size: 18, color: colorScheme.onPrimaryContainer),
                  const SizedBox(width: 6),
                ],
                Text(
                  option.text,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: onDismiss,
                  borderRadius: BorderRadius.circular(10),
                  child: Icon(Icons.close, size: 18, color: colorScheme.onPrimaryContainer),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
