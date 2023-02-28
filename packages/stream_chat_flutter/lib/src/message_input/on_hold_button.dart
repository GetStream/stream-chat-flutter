import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Docs
typedef RecordCallback = void Function(String);

/// Docs
typedef HoldStartCallback = Future<void> Function(BuildContext);

/// Docs
typedef HoldStopCallback = Future<void> Function(BuildContext);

/// Docs
class OnHoldButton extends StatefulWidget {
  /// Docs
  const OnHoldButton({
    super.key,
    required this.onHoldStart,
    required this.onHoldStop,
    required this.onHoldCancel,
    required this.icon,
  });

  /// Docs
  factory OnHoldButton.audioRecord({
    IconData? icon,
    VoidCallback? onHoldStart,
    VoidCallback? onHoldStop,
    VoidCallback? onHoldCancel,
  }) {
    final _audioRecorder = Record();

    Future<void> _start(BuildContext context) async {
      try {
        if (await _audioRecorder.hasPermission()) {
          onHoldStart?.call();
          await _audioRecorder.start();
        }
      } catch (e) {
        print(e);
      }
    }

    void recordingFinishedCallback(String path, BuildContext context) {
      final uri = Uri.parse(path);
      final file = File(uri.path);

      file.length().then(
            (fileSize) {
          StreamChannel
              .of(context)
              .channel
              .sendMessage(
            Message(
              attachments: [
                Attachment(
                  type: 'voicenote',
                  file: AttachmentFile(
                    size: fileSize,
                    path: uri.path,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    Future<void> _stop(BuildContext context) async {
      onHoldStop?.call();
      final path = await _audioRecorder.stop();
      recordingFinishedCallback(path!, context);
    }

    Future<void> _cancel(BuildContext context) async {
      onHoldCancel?.call();
      await _audioRecorder.stop();
    }

    return OnHoldButton(
      onHoldStart: _start,
      onHoldStop: _stop,
      onHoldCancel: _cancel,
      icon: icon ?? Icons.mic,
    );
  }

  /// Docs
  final HoldStartCallback onHoldStart;

  /// Docs
  final HoldStopCallback onHoldStop;

  /// Docs
  final HoldStopCallback onHoldCancel;

  /// Docs
  final IconData icon;

  @override
  State<OnHoldButton> createState() => _OnHoldButtonState();
}

class _OnHoldButtonState extends State<OnHoldButton> {
  bool _isHolding = false;
  double posX = 0;

  Future<void> _start(BuildContext context) async {
    print('start recording...');
    widget.onHoldStart.call(context);
  }

  Future<void> _stop(BuildContext context) async {
    print('stop recording...');
    widget.onHoldStop.call(context);
  }

  Future<void> _cancel(BuildContext context) async {
    print('cancel recording...');
    widget.onHoldCancel.call(context);
  }

  @override
  Widget build(BuildContext context) {
    final color = StreamChatTheme
        .of(context)
        .primaryIconTheme
        .color;

    final buttonAnimated = AnimatedPositioned(
      duration: const Duration(milliseconds: 100),
      left: posX,
      key: const ValueKey("item 1"),
      child: Container(
        height: 20,
        width: 20,
        alignment: Alignment.center,
        child: Icon(
          widget.icon,
          color: color,
        ),
      ),
    );

    final gestureDetector = GestureDetector(
      onTapDown: (details) {
        setState(() {
          _isHolding = true;
        });
        _start(context);
      },
      onTapUp: (details) {
        if (_isHolding) {
          _stop(context);
        }
        setState(() {
          _isHolding = false;
        });
      },
      onHorizontalDragUpdate: (details) {
        if (details.localPosition.dx < 0 && _isHolding) {
          setState(() {
            posX = details.localPosition.dx;
          });
        }

        print('posX: $posX');

        if (details.localPosition.dx < -100 && _isHolding) {
          print('canceling record');
          _cancel(context);
          setState(() {
            posX = 0;
            _isHolding = false;
          });
        }
      },
      onHorizontalDragEnd: (details) {
        if (_isHolding) {
          _stop(context);
        }
        setState(() {
          posX = 0;
          _isHolding = false;
        });
      },
    );

    return Container(
      height: 24,
      width: 60,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(left: 8),
      child: Stack(
        children: [buttonAnimated, gestureDetector],
      ),
    );
  }
}
