import 'package:stream_chat/src/ws/timer_helper.dart';
import 'package:test/test.dart';

void main() {
  late TimerHelper timerHelper;

  setUp(() {
    timerHelper = TimerHelper();
  });

  tearDown(() {
    timerHelper.cancelAllTimers();
  });

  test('setTimer', () async {
    expect(timerHelper.hasTimers, isFalse);

    var count = 0;
    void callback() => count += 1;

    timerHelper.setTimer(
      const Duration(milliseconds: 500),
      callback,
    );

    expect(count, 0);
    await Future.delayed(const Duration(milliseconds: 500));
    expect(count, 1);

    expect(timerHelper.hasTimers, isTrue);
  });

  test('setImmediateTimer', () async {
    var count = 0;
    void callback() => count += 1;

    timerHelper.setTimer(
      const Duration(milliseconds: 500),
      callback,
      immediate: true,
    );

    expect(count, 1);
    await Future.delayed(const Duration(milliseconds: 500));
    expect(count, 2);
  });

  test('setPeriodicTimer', () async {
    expect(timerHelper.hasTimers, isFalse);
    var count = 0;
    void callback() => count += 1;

    timerHelper.setTimer(
      const Duration(milliseconds: 500),
      callback,
    );

    expect(count, 0);
    await Future.delayed(const Duration(milliseconds: 500));
    expect(count, 1);

    expect(timerHelper.hasTimers, isTrue);
  });

  test('setImmediatePeriodicTimer', () async {
    var count = 0;
    void callback(_) => count += 1;

    timerHelper.setPeriodicTimer(
      const Duration(milliseconds: 500),
      callback,
      immediate: true,
    );

    expect(count, 1);
    await Future.delayed(const Duration(milliseconds: 500));
    expect(count, 2);
  });

  test('cancelTimer', () {
    expect(timerHelper.hasTimers, isFalse);
    final id = timerHelper.setTimer(const Duration(seconds: 3), () {});
    expect(timerHelper.hasTimers, isTrue);
    timerHelper.cancelTimer(id);
    expect(timerHelper.hasTimers, isFalse);
  });

  test('cancelAllTimers', () {
    expect(timerHelper.hasTimers, isFalse);
    timerHelper
      ..setTimer(const Duration(seconds: 3), () {})
      ..setTimer(const Duration(seconds: 6), () {})
      ..setTimer(const Duration(seconds: 9), () {});
    expect(timerHelper.hasTimers, isTrue);
    timerHelper.cancelAllTimers();
    expect(timerHelper.hasTimers, isFalse);
  });
}
