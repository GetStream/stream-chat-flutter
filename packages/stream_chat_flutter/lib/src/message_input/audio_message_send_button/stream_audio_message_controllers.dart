import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/message_input/audio_message_send_button/stream_audio_message_gesture_state.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Widget that displays the audio recording controls.
class StreamAudioMessageControllers extends StatefulWidget {
  /// Creates a new StreamAudioMessageControllers
  const StreamAudioMessageControllers({super.key});

  @override
  State<StreamAudioMessageControllers> createState() =>
      _StreamAudioMessageControllersState();
}

class _StreamAudioMessageControllersState
    extends State<StreamAudioMessageControllers> with TickerProviderStateMixin {
  Color? iconColor;
  DateTime? _startTime;
  Timer? _timer;
  late final AnimationController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final audioRecordingMessageTheme = AudioRecordingMessageTheme.of(context);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _controller.forward();

    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        timer.cancel();
        if (mounted) {
          setState(() {
            iconColor =
                audioRecordingMessageTheme.recordingIndicatorColorActive;
            _startTime = DateTime.now();
          });
        }
      },
    );

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_startTime == null) {
          return;
        }
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  String get duration {
    if (_startTime == null) {
      return '0:00';
    }
    final diff = DateTime.now().difference(_startTime!);
    return '${diff.inMinutes}:${diff.inSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final audioRecordingMessageTheme = AudioRecordingMessageTheme.of(context);

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeIn,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          StreamSvgIcon.iconMic(
            color: iconColor,
            size: 24,
          ),
          if (_startTime != null) ...[
            const SizedBox(width: 8),
            SizedBox(
              width: 50,
              child: Text(
                duration,
                style: TextStyle(
                  fontSize: 16,
                  color: audioRecordingMessageTheme.recordingIndicatorColorIdle,
                ),
              ),
            ),
          ] else
            const SizedBox(width: 58),
          const Expanded(
            child: _CancelRecordingPanel(
              key: ValueKey('cancelRecordingPanel'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelRecordingPanel extends StatefulWidget {
  const _CancelRecordingPanel({super.key});

  @override
  State<_CancelRecordingPanel> createState() => _CancelRecordingPanelState();
}

class _CancelRecordingPanelState extends State<_CancelRecordingPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioRecordingMessageTheme = AudioRecordingMessageTheme.of(context);

    final state = GestureStateProvider.maybeOf(context);
    final offset = state?.offset;
    final width = MediaQuery.of(context).size.width / 3;
    final opacity = offset != null ? 1 - (offset.dx.abs() / width) : 1.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: offset != null ? Offset(offset.dx, 0) : Offset.zero,
          child: Opacity(
            opacity: max(min(opacity, 1), 0),
            child: child,
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Slide to cancel',
            style: TextStyle(
              fontSize: 16,
              color: audioRecordingMessageTheme.cancelTextColor,
            ),
          ),
          StreamSvgIcon.left(
            size: 24,
            color: audioRecordingMessageTheme.cancelTextColor,
          ),
        ],
      ),
    );
  }
}
