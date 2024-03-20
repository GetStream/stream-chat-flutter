import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that displays a banner with usage information message.
class AudioMessageInfoBannerOverlay extends StatelessWidget {
  /// Returns an [AudioMessageInfoBannerOverlay] with the given [bottomOffset].§
  const AudioMessageInfoBannerOverlay({
    super.key,
    required this.bottomOffset,
  });

  /// The offset to apply to the overlay.
  final double bottomOffset;

  @override
  Widget build(BuildContext context) {
    final audioRecordingMessageTheme = AudioRecordingMessageTheme.of(context);

    return Positioned(
      bottom: bottomOffset,
      child: DefaultTextStyle(
        style: TextStyle(
          color: audioRecordingMessageTheme.audioButtonColor,
          fontSize: 15,
        ),
        child: Container(
          height: 28,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: audioRecordingMessageTheme.audioButtonBannerColor,
          ),
          child: const Text('Hold to start recording.'),
        ),
      ),
    );
  }
}

/// A widget that displays a lock button.
class LockButtonOverlay extends StatelessWidget {
  /// Returns a [LockButtonOverlay] with the given [bottomOffset].
  const LockButtonOverlay({
    super.key,
    required this.bottomOffset,
  });

  /// The offset to apply to the overlay.
  final double bottomOffset;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottomOffset,
      right: 0,
      child: const _LockButton(
        key: ValueKey('lockButton'),
      ),
    );
  }
}

class _LockButton extends StatefulWidget {
  const _LockButton({
    super.key,
  });

  @override
  State<_LockButton> createState() => _LockButtonState();
}

class _LockButtonState extends State<_LockButton>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioRecordingMessageTheme = AudioRecordingMessageTheme.of(context);

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(_controller),
      child: Container(
        padding: const EdgeInsets.all(8),
        width: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: audioRecordingMessageTheme.lockButtonBackgroundColor,
        ),
        child: Column(
          children: [
            StreamSvgIcon.iconLock(
              size: 24,
              color: audioRecordingMessageTheme.lockButtonForegroundColor,
            ),
            const SizedBox(height: 8),
            StreamSvgIcon.up(
              size: 24,
              color: audioRecordingMessageTheme.lockButtonForegroundColor,
            ),
          ],
        ),
      ),
    );
  }
}
