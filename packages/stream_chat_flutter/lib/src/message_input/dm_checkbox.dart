import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template dmCheckbox}
/// Prompts the user to send a reply to a message thread as a DM.
/// {@endtemplate}
class DmCheckbox extends StatelessWidget {
  /// {@macro dmCheckbox}
  const DmCheckbox({
    super.key,
    required this.foregroundDecoration,
    required this.color,
    required this.onTap,
    required this.crossFadeState,
  });

  /// The decoration to use for the button's foreground.
  final BoxDecoration foregroundDecoration;

  /// The color to use for the button.
  final Color color;

  /// The action to perform when the button is tapped or clicked.
  final VoidCallback onTap;

  /// The [CrossFadeState] of the animation.
  final CrossFadeState crossFadeState;

  @override
  Widget build(BuildContext context) {
    final _streamChatTheme = StreamChatTheme.of(context);
    return Row(
      children: [
        Container(
          height: 16,
          width: 16,
          foregroundDecoration: foregroundDecoration,
          child: Center(
            child: Material(
              borderRadius: BorderRadius.circular(3),
              color: color,
              child: InkWell(
                onTap: onTap,
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  reverseDuration: const Duration(milliseconds: 300),
                  crossFadeState: crossFadeState,
                  firstChild: StreamSvgIcon.check(
                    size: 16,
                    color: _streamChatTheme.colorTheme.barsBg,
                  ),
                  secondChild: const SizedBox(
                    height: 16,
                    width: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            context.translations.alsoSendAsDirectMessageLabel,
            style: _streamChatTheme.textTheme.footnote.copyWith(
              color:
                  _streamChatTheme.colorTheme.textHighEmphasis.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}
