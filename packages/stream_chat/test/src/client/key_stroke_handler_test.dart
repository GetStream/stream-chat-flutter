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

    test('moving from the channel to a thread stops typing in the channel and starts it in the thread', () {
      keyStrokeHandler
        ..call()
        ..call('parent-id');

      verifyInOrder([
        () => onStartTyping(null),
        () => onStopTyping(null),
        () => onStartTyping('parent-id'),
      ]);
    });

    test('moving from a thread to the channel stops typing in the thread and starts it in the channel', () {
      keyStrokeHandler
        ..call('parent-id')
        ..call();

      verifyInOrder([
        () => onStartTyping('parent-id'),
        () => onStopTyping('parent-id'),
        () => onStartTyping(null),
      ]);
    });

    test('typing again in the same context does not restart typing', () {
      keyStrokeHandler
        ..call('parent-id')
        ..call('parent-id');

      verify(() => onStartTyping('parent-id')).called(1);
      verifyNever(() => onStopTyping(any()));
    });

    test('should call onStopTyping after startTypingEventTimeout', () async {
      keyStrokeHandler.call();
      await Future.delayed(const Duration(seconds: startTypingEventTimeout));
      verify(() => onStopTyping(any())).called(1);
    });
  });
}
