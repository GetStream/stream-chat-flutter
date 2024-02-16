import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
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
  late final AnimationController _controller;
  late final StreamRecordingController _recordingController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final audioRecordingMessageTheme = AudioRecordingMessageTheme.of(context);

    _recordingController = context.watch<StreamRecordingController>();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _controller.forward();

    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (mounted) {
          setState(() {
            iconColor =
                audioRecordingMessageTheme.recordingIndicatorColorActive;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get duration {
    if (!_recordingController.isRecording) {
      return '0:00';
    }
    final duration = _recordingController.duration;
    return '${duration.inMinutes}:${duration.inSeconds.toString().padLeft(2, '0')}';
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
          if (_recordingController.isRecording) ...[
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
