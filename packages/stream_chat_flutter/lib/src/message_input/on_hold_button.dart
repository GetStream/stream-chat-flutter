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
    required this.icon,
  });

  /// Docs
  factory OnHoldButton.audioRecord({
    IconData? icon,
    VoidCallback? onHoldStart,
    VoidCallback? onHoldStop,
    Function(Attachment)? onRecordedAudio,
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

    void recordingFinishedCallback(String path) async {
      final uri = Uri.parse(path);
      final file = File(uri.path);

      final attachment = await file.length().then(
            (fileSize) => Attachment(
              type: 'voicenote',
              file: AttachmentFile(
                size: fileSize,
                path: uri.path,
              ),
            ),
          );

      await onRecordedAudio?.call(attachment);
    }

    Future<void> _stop(BuildContext context) async {
      onHoldStop?.call();
      final path = await _audioRecorder.stop();
      recordingFinishedCallback(path!);
    }

    return OnHoldButton(
      onHoldStart: _start,
      onHoldStop: _stop,
      icon: icon ?? Icons.mic,
    );
  }

  /// Docs
  final HoldStartCallback onHoldStart;

  /// Docs
  final HoldStopCallback onHoldStop;

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

  @override
  Widget build(BuildContext context) {
    final color = StreamChatTheme.of(context).primaryIconTheme.color;

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
      child: Icon(
        widget.icon,
        color: color,
      ),
    );

    return SizedBox(
      height: 30,
      width: 30,
      child: gestureDetector,
    );
  }
}
