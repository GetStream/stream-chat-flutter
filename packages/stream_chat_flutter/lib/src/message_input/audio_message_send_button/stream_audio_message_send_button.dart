import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that displays a sending button.
/// This widget is used when the user is recording an audio message.
class StreamAudioMessageSendButton extends StatefulWidget {
  /// Returns a [StreamAudioMessageSendButton] with the given [overlayOffset],
  /// [onRecordingStart].
  const StreamAudioMessageSendButton({
    super.key,
    this.overlayOffset = 15,
    this.overlayDuration = const Duration(milliseconds: 500),
    this.useHapticFeedback = true,
    required this.recordingController,
  });

  /// The offset to apply to the overlay.
  final double overlayOffset;

  /// The duration of the overlay banner.
  final Duration overlayDuration;

  final StreamRecordingController recordingController;
  /// If true, the button will use haptic feedback when
  /// the user long presses it.
  final bool useHapticFeedback;

  @override
  State<StreamAudioMessageSendButton> createState() =>
      _StreamAudioMessageSendButtonState();
}

class _StreamAudioMessageSendButtonState
    extends State<StreamAudioMessageSendButton> {
  Offset _offset = Offset.zero;
  final _infoBarOverlayController = OverlayPortalController();
  final _lockButtonOverlayController = OverlayPortalController();
  Timer? _lockButtonTimer;

  Color? iconColor;
  Color? iconBackgroundColor;

  double get width => MediaQuery.of(context).size.width;

  @override
  void dispose() {
    if (_infoBarOverlayController.isShowing) {
      _infoBarOverlayController.hide();
    }
    if (_lockButtonOverlayController.isShowing) {
      _lockButtonOverlayController.hide();
    }
    _lockButtonTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioRecordingMessageTheme = AudioRecordingMessageTheme.of(context);

    return ListenableBuilder(
      listenable: widget.recordingController,
      builder: (context, _) => GestureDetector(
        onTap: () => _onTap(context),
        onLongPressMoveUpdate: (details) {
          setState(() {
            _offset = details.offsetFromOrigin;
          });
          if (details.offsetFromOrigin.dx < -(width / 3)) {
            if (widget.useHapticFeedback) {
              HapticFeedback.heavyImpact();
            }
            setState(() {
              iconColor = null;
              iconBackgroundColor = null;
              _offset = Offset.zero;
            });

            if (_lockButtonOverlayController.isShowing) {
              _lockButtonOverlayController.hide();
            }
          }
        },
        onLongPressStart: (details) {
          setState(() {
            iconColor = audioRecordingMessageTheme.audioButtonPressedColor;
            iconBackgroundColor =
                audioRecordingMessageTheme.audioButtonPressedBackgroundColor;
          });
          if (widget.useHapticFeedback) {
            HapticFeedback.selectionClick();
          }
      
          widget.recordingController.record();

          _lockButtonTimer =
              Timer.periodic(const Duration(seconds: 1), (timer) {
            _lockButtonOverlayController.show();
            timer.cancel();
          });
        },
        onLongPressEnd: (details) {
          if (_lockButtonTimer != null && _lockButtonTimer!.isActive) {
            _lockButtonTimer!.cancel();
          }
          if (_lockButtonOverlayController.isShowing) {
            _lockButtonOverlayController.hide();
          }
          if (widget.recordingController.isLocked) {
            return;
          }

          setState(() {
            iconColor = null;
            iconBackgroundColor = null;
          });
      
          widget.recordingController.stop();

          setState(() {
            _offset = Offset.zero;
          });
        },
        child: ChangeNotifierProvider(
          create: (_) => widget.recordingController,
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: widget.recordingController.isLocked
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            secondChild: const MyWidget(),
            firstChild: NotificationListener(
              onNotification: (AudioMessageNotification notification) {
                if (notification is RecordingLockedNotification) {
                  widget.recordingController.lock();
                  return true;
                }
                return false;
              },
              child: GestureStateProvider(
                state: GestureState(
                  offset: _offset,
                ),
                child: OverlayPortal(
                  controller: _lockButtonOverlayController,
                  overlayChildBuilder: (context) => LockButtonOverlay(
                    bottomOffset: _overlayOffset,
                  ),
                  child: OverlayPortal(
                    controller: _infoBarOverlayController,
                    overlayChildBuilder: (context) =>
                        AudioMessageInfoBannerOverlay(
                      bottomOffset: _overlayOffset,
                    ),
                    child: Builder(
                      builder: (context) {
                        final icon = Padding(
                          padding: const EdgeInsets.all(8),
                          child: StreamSvgIcon.iconMic(
                            size: 24,
                            color: iconColor,
                          ),
                        );
      
                        if (!widget.recordingController.isRecording) {
                          return icon;
                        }
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: StreamAudioMessageControllers(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1.5),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: iconBackgroundColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: icon,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Account for the height of the keyboard if it's open
  double get _overlayOffset {
    final box = context.findRenderObject()! as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final bottomPadding =
        (MediaQuery.of(context).size.height - offset.dy) + widget.overlayOffset;

    return bottomPadding;
  }

  Future<void> _onTap(BuildContext context) async {
    if (_infoBarOverlayController.isShowing) return;

    _infoBarOverlayController.show();

    Timer.periodic(
      widget.overlayDuration,
      (timer) {
        timer.cancel();
        _infoBarOverlayController.hide();
      },
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final audioRecordingMessageTheme = AudioRecordingMessageTheme.of(context);
    final iconColor = audioRecordingMessageTheme.recordingIndicatorColorActive;

    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [],
        ),
        Row(
          children: [
            const SizedBox(width: 8),
            StreamSvgIcon.iconMic(
              color: iconColor,
              size: 24,
            ),
            Expanded(
              child: StreamSvgIcon.iconPause(
                color: iconColor,
                size: 24,
              ),
            ),
            StreamSvgIcon.circleUp(
              size: 24,
            ),
          ],
        ),
      ]),
    );
  }
}
