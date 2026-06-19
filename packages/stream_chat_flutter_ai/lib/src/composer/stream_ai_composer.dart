import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_ai/src/composer/ai_composer_controller.dart';
import 'package:stream_chat_flutter_ai/src/composer/chat_option.dart';
import 'package:stream_chat_flutter_ai/src/composer/stream_ai_composer_factory.dart';

/// Callback fired when the user taps the send button.
///
/// [text] is the current message text. [selectedOption] is the active
/// [ChatOption], or `null` if the user did not select one.
typedef AiComposerSendCallback = void Function(String text, ChatOption? selectedOption);

/// An AI-aware message composer.
///
/// Renders a text input with:
/// - Suggestion chips ([ChatOption]s) shown above the input when no option is
///   selected.
/// - An inline selected-option chip (with dismiss button) inside the input box.
/// - A **stop** button (instead of send) while [AiComposerController.isGenerating]
///   is `true`.
///
/// All layout regions are customisable via [StreamAIComposerFactory].
///
/// Example:
/// ```dart
/// StreamAIComposer(
///   controller: controller,
///   onSendPressed: (text, option) async {
///     await channel.sendMessage(Message(text: text));
///   },
///   onStopPressed: () => channel.stopAIResponse(),
/// );
/// ```
class StreamAIComposer extends StatefulWidget {
  /// Creates a [StreamAIComposer].
  const StreamAIComposer({
    super.key,
    this.controller,
    required this.onSendPressed,
    this.onStopPressed,
    this.factory = const StreamAIComposerFactory(),
    this.focusNode,
    this.hintText,
    this.minLines = 1,
    this.maxLines = 8,
    this.textInputAction = TextInputAction.newline,
  });

  /// The controller that manages input text, chat options, and generating state.
  ///
  /// If not provided, an internal controller is created and disposed
  /// automatically.
  final AiComposerController? controller;

  /// Called when the user taps the send button.
  final AiComposerSendCallback onSendPressed;

  /// Called when the user taps the stop button while the AI is generating.
  final VoidCallback? onStopPressed;

  /// Factory used to build the leading and trailing slots.
  final StreamAIComposerFactory factory;

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

  @override
  State<StreamAIComposer> createState() => _StreamAIComposerState();
}

class _StreamAIComposerState extends State<StreamAIComposer> {
  late AiComposerController _controller;
  late FocusNode _focusNode;
  bool _ownsController = false;
  bool _ownsFocusNode = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = AiComposerController();
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
  void didUpdateWidget(covariant StreamAIComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (_ownsController) {
        _controller.dispose();
        _ownsController = false;
      }
      if (widget.controller == null) {
        _controller = AiComposerController();
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
    widget.onSendPressed(_controller.text, _controller.selectedChatOption);
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
        final showChips = _controller.chatOptions.isNotEmpty && _controller.selectedChatOption == null;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showChips)
              _ChatOptionChips(
                options: _controller.chatOptions,
                onSelected: _controller.selectChatOption,
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                widget.factory.buildLeading(context, _controller),
                Expanded(
                  child: _InputContainer(
                    controller: _controller,
                    focusNode: _focusNode,
                    hintText: widget.hintText,
                    minLines: widget.minLines,
                    maxLines: widget.maxLines,
                    textInputAction: widget.textInputAction,
                    onSend: _onSend,
                    onStop: _onStop,
                  ),
                ),
                widget.factory.buildTrailing(context, _controller),
              ],
            ),
          ],
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
  });

  final AiComposerController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final VoidCallback onStop;
  final String? hintText;
  final int minLines;
  final int maxLines;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = colorScheme.outlineVariant;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                  ),
                  onSubmitted: (_) {
                    if (textInputAction == TextInputAction.send) onSend();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4, bottom: 4),
                child: _SendStopButton(
                  controller: controller,
                  onSend: onSend,
                  onStop: onStop,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Send / Stop button
// ---------------------------------------------------------------------------

class _SendStopButton extends StatelessWidget {
  const _SendStopButton({
    required this.controller,
    required this.onSend,
    required this.onStop,
  });

  final AiComposerController controller;
  final VoidCallback onSend;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    if (controller.isGenerating) {
      return _IconActionButton(
        icon: Icons.stop_circle_outlined,
        onPressed: onStop,
        tooltip: 'Stop generating',
        color: Theme.of(context).colorScheme.error,
      );
    }

    return _IconActionButton(
      icon: Icons.arrow_upward_rounded,
      onPressed: controller.hasContent ? onSend : null,
      tooltip: 'Send',
      color: Theme.of(context).colorScheme.primary,
    );
  }
}

class _IconActionButton extends StatelessWidget {
  const _IconActionButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    required this.color,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: enabled ? color : color.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Option chips row
// ---------------------------------------------------------------------------

class _ChatOptionChips extends StatelessWidget {
  const _ChatOptionChips({required this.options, required this.onSelected});

  final List<ChatOption> options;
  final ValueChanged<ChatOption> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: options.map((option) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _OptionChip(option: option, onTap: () => onSelected(option)),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({required this.option, required this.onTap});

  final ChatOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ActionChip(
      avatar: option.icon != null ? Icon(option.icon, size: 16) : null,
      label: Text(option.text),
      onPressed: onTap,
      side: BorderSide(color: colorScheme.outlineVariant),
      backgroundColor: colorScheme.surfaceContainerHighest,
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
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (option.icon != null) ...[
            Icon(option.icon, size: 14, color: colorScheme.primary),
            const SizedBox(width: 4),
          ],
          Text(
            option.text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onDismiss,
            borderRadius: BorderRadius.circular(8),
            child: Icon(Icons.close, size: 14, color: colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
