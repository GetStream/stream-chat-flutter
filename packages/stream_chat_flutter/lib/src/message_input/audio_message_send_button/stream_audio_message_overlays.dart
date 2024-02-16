import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

const double _kLockButtonShrinkHeight = 24;
const double _kOffsetVelocityMultiplier = 0.3;

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
    final state = GestureStateProvider.maybeOf(context);
    final offset = state?.offset ?? Offset.zero;
    final isRecordingLocked = context.select(
      (StreamRecordingController c) => c.isLocked,
    );
    final lowerLimit =
        isRecordingLocked == true ? _kLockButtonShrinkHeight : 0;

    return Positioned(
      bottom: bottomOffset +
          (offset.dy.abs() * _kOffsetVelocityMultiplier)
              .clamp(lowerLimit, _kLockButtonShrinkHeight),
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

    final state = GestureStateProvider.maybeOf(context);
    final offset = state?.offset;
    final calculatedSize = _kLockButtonShrinkHeight -
        ((offset?.dy ?? 0).abs() * _kOffsetVelocityMultiplier)
            .clamp(0.0, _kLockButtonShrinkHeight);

    final isRecordingLocked = context.select(
      (StreamRecordingController c) => c.isLocked,
    );
    if (calculatedSize == 0 && !isRecordingLocked) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.dispatchNotification(const RecordingLockedNotification());
      });
    }
    final arrowSize = isRecordingLocked == true ? 0.0 : calculatedSize;

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
              color: arrowSize <= 0
                  ? audioRecordingMessageTheme.lockButtonForegroundColorLocked
                  : audioRecordingMessageTheme.lockButtonForegroundColor,
            ),
            const SizedBox(height: 8),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: StreamSvgIcon.up(
                size: arrowSize,
                color: audioRecordingMessageTheme.lockButtonForegroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
