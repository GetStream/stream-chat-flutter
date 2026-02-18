import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

class StreamMessageComposerRecordingOngoing extends StatelessWidget {
  const StreamMessageComposerRecordingOngoing({super.key, required this.audioRecorderController});
  final StreamAudioRecorderController audioRecorderController;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;
    final icons = context.streamIcons;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 48,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 48,
            width: 48,
            alignment: Alignment.center,
            child: Icon(
              icons.microphone,
              color: context.streamColorScheme.accentError,
              size: 20,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: audioRecorderController,
            builder: (context, state, child) {
              final duration = state is RecordStateRecording ? state.duration : Duration.zero;
              return Text(
                duration.toMinutesAndSeconds(),
                style: textTheme.captionEmphasis.copyWith(
                  color: colorScheme.textPrimary,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              );
            },
          ),
          const SizedBox(width: 23),
          GradientText(
            'Slide to cancel',
            style: context.streamTextTheme.bodyDefault,
            gradient: LinearGradient(
              colors: [colorScheme.textPrimary, colorScheme.textTertiary],
            ),
          ),
          SizedBox(width: context.streamSpacing.xxs),
          Icon(icons.chevronLeft, color: colorScheme.textTertiary, size: 20),
        ],
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
