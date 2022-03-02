import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class DmCheckbox extends StatelessWidget {
  const DmCheckbox({
    Key? key,
    required this.foregroundDecoration,
    required this.color,
    required this.onTap,
    required this.crossFadeState,
  }) : super(key: key);

  final BoxDecoration foregroundDecoration;
  final Color color;
  final VoidCallback onTap;
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
