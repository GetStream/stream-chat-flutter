import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:universal_web/web.dart' as web;

const _containerStyles = Styles(
  display: Display.flex,
  flexDirection: FlexDirection.row,
  alignItems: AlignItems.center,
  padding: Padding.symmetric(
    horizontal: Unit.pixels(16),
    vertical: Unit.pixels(12),
  ),
  backgroundColor: Colors.white,
  raw: {
    'border-top': '1px solid #e5e7eb',
    'gap': '8px',
    'flex-shrink': '0',
  },
);

const _inputStyles = Styles(
  flex: Flex(grow: 1),
  fontSize: Unit.pixels(14),
  color: Color('#1a1a1a'),
  raw: {
    'border': '1px solid #e5e7eb',
    'border-radius': '20px',
    'padding': '10px 16px',
    'outline': 'none',
    'background': '#f9fafb',
    'font-family': 'Inter, sans-serif',
    'resize': 'none',
    'line-height': '1.4',
  },
);

const _sendButtonStyles = Styles(
  width: Unit.pixels(40),
  height: Unit.pixels(40),
  radius: BorderRadius.circular(Unit.pixels(20)),
  backgroundColor: Color('#005FFF'),
  color: Colors.white,
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

const _sendButtonDisabledStyles = Styles(
  width: Unit.pixels(40),
  height: Unit.pixels(40),
  radius: BorderRadius.circular(Unit.pixels(20)),
  backgroundColor: Color('#d1d5db'),
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontSize: Unit.pixels(18),
  display: Display.flex,
  alignItems: AlignItems.center,
  justifyContent: JustifyContent.center,
  raw: {
    'border': 'none',
    'flex-shrink': '0',
    'cursor': 'not-allowed',
  },
);

/// A simple text input for composing and sending messages to a [Channel].
///
/// Shows a rounded text area and a circular send button. Pressing Enter (without
/// Shift) or clicking the send button submits the message and clears the field.
class StreamMessageInput extends StatefulComponent {
  /// Creates a [StreamMessageInput].
  const StreamMessageInput({
    required this.channel,
    super.key,
  });

  /// The channel to send messages to.
  final Channel channel;

  @override
  State<StreamMessageInput> createState() => _StreamMessageInputState();
}

class _StreamMessageInputState extends State<StreamMessageInput> {
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
      textarea(
        [],
        key: ValueKey(_resetKey),
        styles: _inputStyles,
        placeholder: 'Send a message',
        rows: 1,
        onInput: (value) => setState(() => _text = value),
        events: {'keydown': _onKeyDown},
      ),
      button(
        styles: canSend ? _sendButtonStyles : _sendButtonDisabledStyles,
        onClick: canSend ? _send : null,
        [Component.text('\u2191')],
      ),
    ]);
  }
}
