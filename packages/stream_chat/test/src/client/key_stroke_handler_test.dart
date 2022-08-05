// ignore_for_file: avoid_redundant_argument_values

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

mixin OnKeyStrokeEvent {
  Future<void> call([String? parentId]);
}

class OnStartTyping extends Mock implements OnKeyStrokeEvent {}

class OnStopTyping extends Mock implements OnKeyStrokeEvent {}

void main() {
  final onStartTyping = OnStartTyping();
  final onStopTyping = OnStopTyping();
  late KeyStrokeHandler keyStrokeHandler;

  const startTypingEventTimeout = 1;
  const startTypingResendInterval = 2;

  setUp(() {
    when(() => onStartTyping(any())).thenAnswer((_) => Future.value());
    when(() => onStopTyping(any())).thenAnswer((_) => Future.value());

    keyStrokeHandler = KeyStrokeHandler(
      onStartTyping: onStartTyping,
      onStopTyping: onStopTyping,
      startTypingEventTimeout: startTypingEventTimeout,
      startTypingResendInterval: startTypingResendInterval,
    );
  });

  tearDown(() {
    keyStrokeHandler.cancel();
    clearInteractions(onStartTyping);
    clearInteractions(onStopTyping);
  });

  group('call', () {
    test('should work fine', () {
      expect(keyStrokeHandler.call(), completes);
    });

    test('should call onStartTyping', () async {
      keyStrokeHandler.call();
      verify(() => onStartTyping(any())).called(1);
    });

    test('should call onStopTyping', () async {
      keyStrokeHandler
        ..call()
        ..cancel();
      verify(() => onStopTyping(any())).called(1);
    });

    test('should call onStartTyping after startTypingResendInterval', () async {
      final watch = Stopwatch()..start();
      while (watch.elapsed.inSeconds <= startTypingResendInterval) {
        keyStrokeHandler.call();
      }
      watch.stop();
      verify(() => onStartTyping(any())).called(2);
    });

    test('should call onStopTyping after startTypingEventTimeout', () async {
      keyStrokeHandler.call();
      await Future.delayed(const Duration(seconds: startTypingEventTimeout));
      verify(() => onStopTyping(any())).called(1);
    });
  });
}
