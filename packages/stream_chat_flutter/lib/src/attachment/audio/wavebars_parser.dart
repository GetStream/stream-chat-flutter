import 'dart:io';
import 'package:fftea/fftea.dart';

/// Docs
class WaveBarsParser {
  void parseWavebars(File audioFile) {
    final audioData =
        audioFile.readAsBytesSync().map((e) => (e - 128) / 128).toList();

    final dataSize = audioData.length;

    //
    // STFT(audioData.length)
    //     .realFft(audioData)
    //     .map((c) => c.abs() / dataSize)
    //     .toList();
  }
}
