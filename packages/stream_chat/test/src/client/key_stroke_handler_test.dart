// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

mixin OnKeyStrokeEvent {
  Future<Result<void>> call([String? parentId]);
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
    when(() => onStartTyping(any())).thenAnswer((_) async => const Result.success(null));
    when(() => onStopTyping(any())).thenAnswer((_) async => const Result.success(null));

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

  test('KeyStrokeHandler.call completes with the failure of onStartTyping', () async {
    const error = StreamClientException(message: 'boom');
    when(() => onStartTyping(any())).thenAnswer((_) async => const Result.failure(error));

    final result = await keyStrokeHandler.call();

    expect(result.exceptionOrNull(), error);
  });

  test('KeyStrokeHandler.call does not send the stop after onStartTyping fails', () async {
    when(
      () => onStartTyping(any()),
    ).thenAnswer((_) async => const Result.failure(StreamClientException(message: 'boom')));

    await keyStrokeHandler.call();
    await Future<void>.delayed(const Duration(seconds: startTypingEventTimeout));

    verifyNever(() => onStopTyping(any()));
  });

  test('KeyStrokeHandler.call completes with the error onStopTyping throws', () async {
    when(() => onStopTyping(any())).thenAnswer((_) async => throw StateError('boom'));

    await expectLater(keyStrokeHandler.call(), throwsStateError);
  });

  test('KeyStrokeHandler.call completes with the error onStartTyping throws', () async {
    when(() => onStartTyping(any())).thenAnswer((_) async => throw StateError('boom'));

    await expectLater(keyStrokeHandler.call(), throwsStateError);
  });

  test('KeyStrokeHandler.call still sends the stop of a later key stroke when an earlier start fails', () async {
    final startResult = Completer<Result<void>>();
    when(() => onStartTyping(any())).thenAnswer((_) => startResult.future);

    keyStrokeHandler.call();
    final second = keyStrokeHandler.call();
    startResult.complete(const Result.failure(StreamClientException(message: 'boom')));

    expect(await second, isA<Success<void>>());
    verify(() => onStopTyping(any())).called(1);
  });

  test('KeyStrokeHandler.call completes the earlier call with a success when a later key stroke replaces it', () async {
    final first = keyStrokeHandler.call();
    keyStrokeHandler.call();

    expect(await first, isA<Success<void>>());
  });

  test('KeyStrokeHandler.call completes with the failure of the scheduled onStopTyping', () async {
    const error = StreamClientException(message: 'boom');
    when(() => onStopTyping(any())).thenAnswer((_) async => const Result.failure(error));

    final result = await keyStrokeHandler.call();

    expect(result.exceptionOrNull(), error);
  });
}
