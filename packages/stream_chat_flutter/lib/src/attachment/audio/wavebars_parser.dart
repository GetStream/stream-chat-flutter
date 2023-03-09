import 'dart:io';
import 'dart:math';
import 'package:just_waveform/just_waveform.dart';
import 'package:path_provider/path_provider.dart';

/// Docs
class WaveBarsParser {
  static List<int> randomBars() {
    final random = Random();
    return List<int>.generate(60, (_) => random.nextInt(100)).toList();
  }

  static Future<List<double>> parseBarsJustWave(String audioFilePath) async {
    print('getTemporaryDirectory');
    final outputFile = await getTemporaryDirectory().then(
      (tempDirectory) => File('${tempDirectory.path}/waveform.wave}'),
    );

    final waveValues = await JustWaveform.extract(
      audioInFile: File(audioFilePath),
      waveOutFile: outputFile,
      zoom: const WaveformZoom.samplesPerPixel(1),
    ).firstWhere((waveProgress) => waveProgress.progress == 1.0);

    return waveValues.waveform?.data.map((e) => e.abs() / 32768).toList() ?? [];
  }
}
