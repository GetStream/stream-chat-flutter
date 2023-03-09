import 'dart:io';
import 'dart:math';
import 'package:fftea/fftea.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:path_provider/path_provider.dart';

/// Docs
class WaveBarsParser {
  
  static List<double> randomBars() {
    final random = Random();
    return List<double>.generate(60, (_) => random.nextDouble());
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
