import 'dart:async';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:rxdart/rxdart.dart';

const _amplitudeChangeMilliSecondsInterval = 700;

/// Docs
class AudioWaveBars extends StatefulWidget {
  /// Docs
  const AudioWaveBars({
    super.key,
    required this.recorder,
    required this.recordState,
  });

  /// Docs
  final Record recorder;

  /// Docs
  final Stream<RecordState> recordState;

  @override
  State<AudioWaveBars> createState() => _AudioWaveBarsState();
}

class _AudioWaveBarsState extends State<AudioWaveBars> {
  StreamSubscription<Amplitude>? _noiseSubscription;

  @override
  void initState() {
    super.initState();

    widget.recordState.where((event) => event == RecordState.record).flatMap(
          (value) => widget.recorder.onAmplitudeChanged(
            const Duration(
              milliseconds: _amplitudeChangeMilliSecondsInterval,
            ),
          ),
        ).listen(_onNoiseData);
  }

  @override
  void dispose() {
    super.dispose();

    _noiseSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('To implement'),
    );
  }

  void _onNoiseData(Amplitude amplitude) {
    print(
      'Amplitude data: max: ${amplitude.max}, current: ${amplitude.current}',
    );
  }
}
