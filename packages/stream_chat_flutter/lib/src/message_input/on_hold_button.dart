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
    required this.iconIdle,
    required this.iconActive,
  });

  /// Docs
  factory OnHoldButton.audioRecord({
    IconData? iconIdle,
    IconData? iconActive,
  }) {
    final _audioRecorder = Record();

    Future<void> _start(BuildContext context) async {
      try {
        if (await _audioRecorder.hasPermission()) {
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
          StreamChannel.of(context).channel.sendMessage(
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
      final path = await _audioRecorder.stop();
      recordingFinishedCallback(path!, context);
    }

    return OnHoldButton(
      onHoldStart: _start,
      onHoldStop: _stop,
      iconIdle: iconIdle ?? Icons.mic,
      iconActive: iconActive ?? Icons.stop,
    );
  }

  /// Docs
  final HoldStartCallback onHoldStart;

  /// Docs
  final HoldStopCallback onHoldStop;

  /// Docs
  final IconData iconIdle;

  /// Docs
  final IconData iconActive;

  @override
  State<OnHoldButton> createState() => _OnHoldButtonState();
}

class _OnHoldButtonState extends State<OnHoldButton> {
  bool _isHolding = false;

  Future<void> _start(BuildContext context) async {
    widget.onHoldStart.call(context);
    setState(() {
      _isHolding = true;
    });
  }

  Future<void> _stop(BuildContext context) async {
    widget.onHoldStop.call(context);
    setState(() => _isHolding = false);
  }

  @override
  Widget build(BuildContext context) {
    final color = _isHolding
        ? Colors.red.withOpacity(0.3)
        : StreamChatTheme.of(context).primaryIconTheme.color;

    return GestureDetector(
      onTap: () {
        _isHolding ? _stop(context) : _start(context);
      },
      child: Icon(
        _isHolding ? widget.iconActive : widget.iconIdle,
        color: color,
      ),
    );
  }
}
