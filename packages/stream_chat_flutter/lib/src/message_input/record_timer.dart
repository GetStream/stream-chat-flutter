import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// Docs
class RecordTimer extends StatefulWidget {
  /// Docs
  RecordTimer({super.key});

  @override
  State<RecordTimer> createState() => _RecordTimerState();
}

class _RecordTimerState extends State<RecordTimer> {
  Duration duration = Duration.zero;
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => {
      _addTime.call(),
    });

    super.initState();
  }

  void _addTime() {
    print('Adding time...');
    final seconds = duration.inSeconds + 1;

    setState(() {
      duration = Duration(seconds: seconds);
    });
  }

  String twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    print('build timer');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds);

    return Text('$minutes:$seconds', style: const TextStyle(fontSize: 18));
  }
}
