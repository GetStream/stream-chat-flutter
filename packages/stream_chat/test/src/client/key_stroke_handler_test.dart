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

    test('should pass parentId to onStartTyping', () async {
      const parentId = 'parent-123';
      await keyStrokeHandler.call(parentId);
      verify(() => onStartTyping(parentId)).called(1);
    });

    test('should pass parentId to onStopTyping', () async {
      const parentId = 'parent-456';
      keyStrokeHandler.call(parentId);
      await Future.delayed(
        const Duration(seconds: startTypingEventTimeout + 1),
      );
      verify(() => onStopTyping(parentId)).called(1);
    });

    test('should handle multiple rapid calls', () async {
      for (var i = 0; i < 10; i++) {
        keyStrokeHandler.call();
        await Future.delayed(const Duration(milliseconds: 100));
      }
      // Should only call onStartTyping once within the resend interval
      verify(() => onStartTyping(any())).called(1);
    });

    test('should cancel previous timer on new call', () async {
      await keyStrokeHandler.call();
      await Future.delayed(const Duration(milliseconds: 500));
      await keyStrokeHandler.call();
      await Future.delayed(
        const Duration(seconds: startTypingEventTimeout + 1),
      );
      // Should only call onStopTyping once
      verify(() => onStopTyping(any())).called(1);
    });

    test('should handle different parentIds', () async {
      await keyStrokeHandler.call('parent-1');
      keyStrokeHandler.cancel();

      await keyStrokeHandler.call('parent-2');
      keyStrokeHandler.cancel();

      verify(() => onStartTyping('parent-1')).called(1);
      verify(() => onStartTyping('parent-2')).called(1);
      verify(() => onStopTyping('parent-1')).called(1);
      verify(() => onStopTyping('parent-2')).called(1);
    });

    test('should handle null parentId', () async {
      await keyStrokeHandler.call(null);
      verify(() => onStartTyping(null)).called(1);
    });
  });

  group('cancel', () {
    test('should cancel ongoing typing', () async {
      await keyStrokeHandler.call();
      keyStrokeHandler.cancel();
      verify(() => onStopTyping(any())).called(1);
    });

    test('should cancel timer', () async {
      keyStrokeHandler.call();
      keyStrokeHandler.cancel();
      await Future.delayed(
        const Duration(seconds: startTypingEventTimeout + 1),
      );
      // Should only call onStopTyping once from cancel, not from timer
      verify(() => onStopTyping(any())).called(1);
    });

    test('should handle cancel when not typing', () {
      keyStrokeHandler.cancel();
      verifyNever(() => onStopTyping(any()));
    });

    test('should handle multiple cancel calls', () async {
      await keyStrokeHandler.call();
      keyStrokeHandler.cancel();
      keyStrokeHandler.cancel();
      keyStrokeHandler.cancel();
      // Should only call onStopTyping once
      verify(() => onStopTyping(any())).called(1);
    });

    test('should allow restart after cancel', () async {
      await keyStrokeHandler.call('parent-1');
      keyStrokeHandler.cancel();
      await keyStrokeHandler.call('parent-2');

      verify(() => onStartTyping('parent-1')).called(1);
      verify(() => onStopTyping('parent-1')).called(1);
      verify(() => onStartTyping('parent-2')).called(1);
    });
  });

  group('error handling', () {
    test('should handle onStartTyping error', () async {
      when(() => onStartTyping(any())).thenThrow(Exception('Start error'));

      expect(
        keyStrokeHandler.call(),
        throwsException,
      );
    });

    test('should handle onStopTyping error', () async {
      when(() => onStopTyping(any())).thenThrow(Exception('Stop error'));

      keyStrokeHandler.call();
      await Future.delayed(
        const Duration(seconds: startTypingEventTimeout + 1),
      );

      verify(() => onStopTyping(any())).called(1);
    });

    test('should handle async onStartTyping error', () async {
      when(() => onStartTyping(any())).thenAnswer(
        (_) => Future.error(Exception('Async start error')),
      );

      expect(
        keyStrokeHandler.call(),
        throwsException,
      );
    });

    test('should handle async onStopTyping error', () async {
      when(() => onStopTyping(any())).thenAnswer(
        (_) => Future.error(Exception('Async stop error')),
      );

      keyStrokeHandler.call();
      await Future.delayed(
        const Duration(seconds: startTypingEventTimeout + 1),
      );

      verify(() => onStopTyping(any())).called(1);
    });

    test('should suppress error when cancel calls onStopTyping', () async {
      when(() => onStopTyping(any())).thenAnswer(
        (_) => Future.error(Exception('Stop error')),
      );

      await keyStrokeHandler.call();
      // Should not throw even though onStopTyping throws
      expect(() => keyStrokeHandler.cancel(), returnsNormally);
    });
  });

  group('timing behavior', () {
    test('should respect startTypingEventTimeout', () async {
      const customTimeout = 3;
      final customHandler = KeyStrokeHandler(
        onStartTyping: onStartTyping,
        onStopTyping: onStopTyping,
        startTypingEventTimeout: customTimeout,
      );

      try {
        customHandler.call();
        await Future.delayed(const Duration(seconds: customTimeout - 1));
        verifyNever(() => onStopTyping(any()));

        await Future.delayed(const Duration(seconds: 2));
        verify(() => onStopTyping(any())).called(1);
      } finally {
        customHandler.cancel();
      }
    });

    test('should respect startTypingResendInterval', () async {
      const customInterval = 5;
      final customHandler = KeyStrokeHandler(
        onStartTyping: onStartTyping,
        onStopTyping: onStopTyping,
        startTypingResendInterval: customInterval,
      );

      try {
        await customHandler.call();
        verify(() => onStartTyping(any())).called(1);

        // Wait less than interval, should not resend
        await Future.delayed(const Duration(seconds: customInterval - 1));
        await customHandler.call();
        verify(() => onStartTyping(any())).called(1);

        // Wait more than interval, should resend
        await Future.delayed(const Duration(seconds: customInterval + 1));
        await customHandler.call();
        verify(() => onStartTyping(any())).called(2);
      } finally {
        customHandler.cancel();
      }
    });
  });

  group('completer behavior', () {
    test('should complete future on stop typing', () async {
      final future = keyStrokeHandler.call();
      await Future.delayed(
        const Duration(seconds: startTypingEventTimeout + 1),
      );
      await expectLater(future, completes);
    });

    test('should complete future on cancel', () async {
      final future = keyStrokeHandler.call();
      keyStrokeHandler.cancel();
      await expectLater(future, completes);
    });

    test('should handle multiple concurrent calls', () async {
      final futures = <Future<void>>[];
      for (var i = 0; i < 5; i++) {
        futures.add(keyStrokeHandler.call());
        await Future.delayed(const Duration(milliseconds: 100));
      }

      keyStrokeHandler.cancel();

      // All futures should complete
      await expectLater(Future.wait(futures), completes);
    });
  });
}