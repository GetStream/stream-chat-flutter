import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A callback called when the user starts recording an audio message.
typedef OnRecordingStart = void Function();

/// A callback called when the user ends recording an audio message.
typedef OnRecordingEnd = void Function();

/// A callback called when the user cancels recording an audio message.
typedef OnRecordingCanceled = void Function();

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
    required this.onRecordingStart,
    required this.onRecordingEnd,
    required this.onRecordingCanceled,
  });

  /// The offset to apply to the overlay.
  final double overlayOffset;

  /// The duration of the overlay banner.
  final Duration overlayDuration;

  /// The callback called when the user long presses the button.
  final OnRecordingStart onRecordingStart;

  /// The callback called when the user stops pressing the button.
  final OnRecordingEnd onRecordingEnd;

  /// The callback called when the user cancels the recording.
  final OnRecordingCanceled onRecordingCanceled;

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

  bool _isRecording = false;

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

    return GestureDetector(
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
            _isRecording = false;
          });

          if (_lockButtonOverlayController.isShowing) {
            _lockButtonOverlayController.hide();
          }

          widget.onRecordingCanceled();
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
        widget.onRecordingStart();
        setState(() {
          _isRecording = true;
        });

        _lockButtonTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
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

        setState(() {
          iconColor = null;
          iconBackgroundColor = null;
        });
        widget.onRecordingEnd();
        setState(() {
          _isRecording = false;
          _offset = Offset.zero;
        });
      },
      child: OverlayPortal(
        controller: _lockButtonOverlayController,
        overlayChildBuilder: (context) => LockButtonOverlay(
          bottomOffset: _overlayOffset,
        ),
        child: OverlayPortal(
          controller: _infoBarOverlayController,
          overlayChildBuilder: (context) => AudioMessageInfoBannerOverlay(
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

              if (!_isRecording) {
                return icon;
              }
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureStateProvider(
                        state: GestureState(
                          offset: _offset,
                        ),
                        child: const StreamAudioMessageControllers(),
                      ),
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
