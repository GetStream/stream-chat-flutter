import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_jaspr/src/theme/stream_chat_jaspr_tokens.dart';
import 'package:universal_web/web.dart' as web;

const _containerStyles = Styles(
  display: Display.flex,
  flexDirection: FlexDirection.row,
  alignItems: AlignItems.center,
  padding: Padding.symmetric(
    horizontal: Unit.pixels(StreamSpacing.md),
    vertical: Unit.pixels(StreamSpacing.xs),
  ),
  backgroundColor: StreamColors.white,
  raw: {
    'border-top': '1px solid #EBEEF1',
    'gap': '${StreamSpacing.xs}px',
    'flex-shrink': '0',
  },
);

const _attachButtonStyles = Styles(
  width: Unit.pixels(40),
  height: Unit.pixels(40),
  radius: BorderRadius.circular(Unit.pixels(StreamRadii.pill)),
  backgroundColor: StreamColors.white,
  border: Border.all(color: StreamColors.borderDefault, width: Unit.pixels(1)),
  display: Display.flex,
  alignItems: AlignItems.center,
  justifyContent: JustifyContent.center,
  cursor: Cursor.pointer,
  fontSize: Unit.pixels(20),
  raw: {'flex-shrink': '0', 'line-height': '1'},
);

const _inputStyles = Styles(
  flex: Flex(grow: 1),
  minHeight: Unit.pixels(40),
  fontSize: Unit.pixels(StreamTypography.sizeBase),
  color: StreamColors.textPrimary,
  fontFamily: StreamTypography.fontFamily,
  raw: {
    'border': '1px solid #D5DBE1',
    'border-radius': '${StreamRadii.pill}px',
    'padding': '10px 16px',
    'outline': 'none',
    'background': '#FFFFFF',
    'resize': 'none',
    'line-height': '1.4',
  },
);

const _sendButtonStyles = Styles(
  width: Unit.pixels(40),
  height: Unit.pixels(40),
  radius: BorderRadius.circular(Unit.pixels(StreamRadii.pill)),
  backgroundColor: StreamColors.primary,
  color: StreamColors.white,
  fontWeight: FontWeight.w600,
  fontSize: Unit.pixels(18),
  display: Display.flex,
  alignItems: AlignItems.center,
  justifyContent: JustifyContent.center,
  cursor: Cursor.pointer,
  raw: {
    'border': 'none',
    'flex-shrink': '0',
    'transition': 'background-color 0.15s ease',
  },
);

/// A message composition input for sending messages to a [Channel].
///
/// Renders a `+` attachment button (visual placeholder), a pill-shaped text
/// field and a circular send button. The send button only appears once the
/// user has typed something.
///
/// Pressing Enter (without Shift) or clicking the send button submits the
/// message and clears the field.
class StreamMessageComposer extends StatefulComponent {
  /// Creates a [StreamMessageComposer].
  const StreamMessageComposer({
    required this.channel,
    super.key,
  });

  /// The channel to send messages to.
  final Channel channel;

  @override
  State<StreamMessageComposer> createState() => _StreamMessageComposerState();
}

class _StreamMessageComposerState extends State<StreamMessageComposer> {
  String _text = '';

  /// Incremented after each send to force the textarea element to reset.
  int _resetKey = 0;

  bool _sending = false;

  Future<void> _send() async {
    final text = _text.trim();
    if (text.isEmpty || _sending) return;

    setState(() {
      _text = '';
      _resetKey++;
      _sending = true;
    });

    try {
      await component.channel.sendMessage(Message(text: text));
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  void _onKeyDown(web.Event event) {
    final ke = event as web.KeyboardEvent;
    if (ke.key == 'Enter' && !ke.shiftKey) {
      ke.preventDefault();
      _send();
    }
  }

  @override
  Component build(BuildContext context) {
    final canSend = _text.trim().isNotEmpty && !_sending;

    return div(styles: _containerStyles, [
      // Attachment button (visual placeholder — file upload not yet implemented).
      const button(
        styles: _attachButtonStyles,
        [Component.text('+')],
      ),

      // Pill text field.
      textarea(
        const [],
        key: ValueKey(_resetKey),
        styles: _inputStyles,
        placeholder: 'Send a message',
        rows: 1,
        onInput: (value) => setState(() => _text = value),
        events: {'keydown': _onKeyDown},
      ),

      // Send button — only rendered when there is text to send.
      if (canSend)
        button(
          styles: _sendButtonStyles,
          onClick: _send,
          const [Component.text('↑')],
        ),
    ]);
  }
}
