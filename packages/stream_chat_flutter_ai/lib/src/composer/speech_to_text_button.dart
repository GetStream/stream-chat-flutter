import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:stream_chat_flutter_ai/src/composer/ai_composer_controller.dart';
import 'package:stream_chat_flutter_ai/src/composer/composer_action_button.dart';

/// A microphone button that feeds speech-to-text results directly into an
/// [AIComposerController]'s text field.
///
/// Rendered as one of the states of [StreamAIComposer]'s single trailing
/// control — the composer only builds this widget while the field is empty
/// and the AI is not generating, so it does not re-check either condition
/// itself. While listening, it shows an animated recording indicator and the
/// recognised speech appears in the text field in real time. Tapping again
/// stops recognition.
///
/// Platform permissions must be configured before the button can work:
///
/// **iOS** — add to `ios/Runner/Info.plist`:
/// ```xml
/// <key>NSMicrophoneUsageDescription</key>
/// <string>Microphone access is needed for voice input.</string>
/// <key>NSSpeechRecognitionUsageDescription</key>
/// <string>Speech recognition is used to convert your voice to text.</string>
/// ```
///
/// **Android** — add to `android/app/src/main/AndroidManifest.xml`:
/// ```xml
/// <uses-permission android:name="android.permission.RECORD_AUDIO"/>
/// ```
///
/// **macOS** — add to `macos/Runner/Info.plist`:
/// ```xml
/// <key>NSMicrophoneUsageDescription</key>
/// <string>Microphone access is needed for voice input.</string>
/// <key>NSSpeechRecognitionUsageDescription</key>
/// <string>Speech recognition is used to convert your voice to text.</string>
/// ```
/// And enable the audio input entitlement in
/// `macos/Runner/DebugProfile.entitlements`:
/// ```xml
/// <key>com.apple.security.device.audio-input</key>
/// <true/>
/// <key>com.apple.security.device.microphone</key>
/// <true/>
/// ```
///
/// For a single control that toggles between voice input and send — matching
/// the reference iOS/Android AI sample apps — pass
/// `StreamAIComposer(enableSpeechToText: true, ...)` instead of placing this
/// widget manually; that swaps this button in for the send button's own slot
/// while the field is empty, rather than showing two separate buttons side
/// by side.
///
/// To place it elsewhere instead (e.g. always visible in a custom slot), use
/// it directly via [StreamAIComposerFactory]:
/// ```dart
/// class MyFactory extends StreamAIComposerFactory {
///   @override
///   Widget buildLeading(BuildContext context, AIComposerController controller) {
///     return SpeechToTextButton(controller: controller);
///   }
/// }
/// ```
class SpeechToTextButton extends StatefulWidget {
  /// Creates a [SpeechToTextButton].
  const SpeechToTextButton({
    super.key,
    required this.controller,
    this.onError,
    this.onStatus,
    this.localeId,
    this.listenFor = const Duration(seconds: 30),
    this.pauseFor = const Duration(seconds: 3),
  });

  /// The controller whose text field receives recognised words.
  final AIComposerController controller;

  /// Called when speech recognition encounters an error.
  final void Function(SpeechRecognitionError error)? onError;

  /// Called when the recognition engine status changes.
  ///
  /// Common status strings: `'listening'`, `'notListening'`, `'done'`.
  final void Function(String status)? onStatus;

  /// BCP-47 locale identifier (e.g. `'en-US'`).
  ///
  /// Defaults to the device's current locale when `null`.
  final String? localeId;

  /// Maximum duration of a single recognition session.
  final Duration listenFor;

  /// How long to wait after the user stops speaking before ending the session.
  final Duration pauseFor;

  @override
  State<SpeechToTextButton> createState() => _SpeechToTextButtonState();
}

class _SpeechToTextButtonState extends State<SpeechToTextButton> with SingleTickerProviderStateMixin {
  final _speech = SpeechToText();
  bool _isAvailable = false;
  bool _isListening = false;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _initialize();
  }

  Future<void> _initialize() async {
    final available = await _speech.initialize(
      onError: (error) {
        widget.onError?.call(error);
        if (mounted) setState(() => _isListening = false);
      },
      onStatus: (status) {
        widget.onStatus?.call(status);
        final listening = status == SpeechToText.listeningStatus;
        if (mounted && listening != _isListening) {
          setState(() => _isListening = listening);
        }
      },
    );
    if (mounted) setState(() => _isAvailable = available);
  }

  Future<void> _toggle() async {
    if (_isListening) {
      await _speech.stop();
      return;
    }
    await _speech.listen(
      onResult: _onResult,
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
        localeId: widget.localeId,
        listenFor: widget.listenFor,
        pauseFor: widget.pauseFor,
      ),
    );
  }

  void _onResult(SpeechRecognitionResult result) {
    final words = result.recognizedWords;
    widget.controller.textEditingController
      ..text = words
      ..selection = TextSelection.collapsed(offset: words.length);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        // The composer only builds this widget while the field is empty and
        // the AI isn't generating (see `_trailingState` in
        // stream_ai_composer.dart), so the only remaining reason to hide is
        // the platform speech recognizer being unavailable.
        if (!_isAvailable) {
          return const SizedBox.shrink();
        }

        final colorScheme = Theme.of(context).colorScheme;
        final color = _isListening ? colorScheme.error : colorScheme.primary;

        return _isListening
            ? AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _pulseAnimation.value,
                    child: child,
                  );
                },
                child: _MicButton(color: color, onTap: _toggle, recording: true),
              )
            : _MicButton(color: color, onTap: _toggle, recording: false);
      },
    );
  }
}

class _MicButton extends StatelessWidget {
  const _MicButton({required this.color, required this.onTap, required this.recording});

  final Color color;
  final VoidCallback onTap;
  final bool recording;

  @override
  Widget build(BuildContext context) {
    return ComposerActionButton(
      icon: recording ? Icons.stop_rounded : Icons.mic_none_rounded,
      onPressed: onTap,
      tooltip: recording ? 'Stop recording' : 'Voice input',
      color: color,
    );
  }
}
