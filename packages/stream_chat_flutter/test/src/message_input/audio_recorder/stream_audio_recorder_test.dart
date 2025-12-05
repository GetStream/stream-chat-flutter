import 'package:alchemist/alchemist.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/misc/audio_waveform.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../../utils/finders.dart';

void main() {
  group('StreamAudioRecorderButton', () {
    final fakeAudioRecording = Attachment(
      type: AttachmentType.voiceRecording,
      file: AttachmentFile(
        size: 1000000,
        path: 'voice_recordings/test.m4a',
      ),
      extraData: {
        'duration': 3000,
        'waveform_data': List.filled(50, 0.5),
      },
    );

    testWidgets(
      'renders mic icon in idle state',
      (tester) async {
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            const StreamAudioRecorderButton(
              recordState: RecordStateIdle(),
            ),
          ),
        );

        expect(find.bySvgIcon(StreamSvgIcons.mic), findsOneWidget);
      },
    );

    testWidgets(
      'calls onRecordStart when long pressed',
      (tester) async {
        var recordStartCalled = false;
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: const RecordStateIdle(),
              onRecordStart: () {
                recordStartCalled = true;
              },
            ),
          ),
        );

        final center = tester.getCenter(find.byType(StreamAudioRecorderButton));
        await tester.startGesture(center);
        await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));

        expect(recordStartCalled, true);
      },
    );

    testWidgets(
      'shows recording UI when in RecordStateRecordingHold',
      (tester) async {
        final recordingState = RecordStateRecordingHold(
          duration: const Duration(seconds: 5),
          waveform: List.filled(50, 0.5),
        );

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: recordingState,
              onRecordStart: () {},
            ),
          ),
        );

        expect(find.byType(PlaybackTimerIndicator), findsOneWidget);
        expect(find.byType(SlideToCancelIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'calls onRecordFinish when long press is released',
      (tester) async {
        var onRecordFinishCalled = false;
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: const RecordStateRecordingHold(),
              onRecordFinish: () {
                onRecordFinishCalled = true;
              },
            ),
          ),
        );

        final center = tester.getCenter(find.byType(RecordButton));
        final gesture = await tester.startGesture(center);
        await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
        await gesture.up();

        expect(onRecordFinishCalled, true);
      },
    );

    testWidgets(
      'calls onRecordCancel when dragged left beyond threshold',
      (tester) async {
        const cancelThreshold = 60.0;

        var onRecordCancelCalled = false;
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: const RecordStateRecordingHold(),
              cancelRecordThreshold: cancelThreshold,
              onRecordCancel: () {
                onRecordCancelCalled = true;
              },
            ),
          ),
        );

        final center = tester.getCenter(find.byType(RecordButton));
        final gesture = await tester.startGesture(center);
        await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
        // Move beyond threshold
        await gesture.moveBy(const Offset(-cancelThreshold, 0));

        expect(onRecordCancelCalled, true);
      },
    );

    testWidgets(
      'calls onRecordLock when dragged up beyond threshold',
      (tester) async {
        const lockThreshold = 60.0;

        var lockCalled = false;
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: const RecordStateRecordingHold(),
              lockRecordThreshold: lockThreshold,
              onRecordLock: () {
                lockCalled = true;
              },
            ),
          ),
        );

        final center = tester.getCenter(find.byType(RecordButton));
        final gesture = await tester.startGesture(center);
        await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
        // Move beyond threshold
        await gesture.moveBy(const Offset(0, -lockThreshold));

        expect(lockCalled, true);
      },
    );

    testWidgets(
      'shows locked recording UI when in RecordStateRecordingLocked',
      (tester) async {
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: RecordStateRecordingLocked(
                duration: const Duration(seconds: 5),
                waveform: List.filled(50, 0.5),
              ),
            ),
          ),
        );

        expect(find.byType(StreamAudioWaveform), findsOneWidget);
        expect(find.bySvgIcon(StreamSvgIcons.delete), findsOneWidget);
        expect(find.bySvgIcon(StreamSvgIcons.stop), findsOneWidget);
        expect(find.bySvgIcon(StreamSvgIcons.checkSend), findsOneWidget);
      },
    );

    testWidgets(
      'calls onRecordCancel when delete is tap in RecordStateRecordingLocked',
      (tester) async {
        var onRecordCancelCalled = false;
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: RecordStateRecordingLocked(
                duration: const Duration(seconds: 5),
                waveform: List.filled(50, 0.5),
              ),
              onRecordCancel: () {
                onRecordCancelCalled = true;
              },
            ),
          ),
        );

        await tester.tap(find.bySvgIcon(StreamSvgIcons.delete));

        expect(onRecordCancelCalled, true);
      },
    );

    testWidgets(
      'calls onRecordStop when stop is tap in RecordStateRecordingLocked',
      (tester) async {
        var onRecordStopCalled = false;
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: RecordStateRecordingLocked(
                duration: const Duration(seconds: 5),
                waveform: List.filled(50, 0.5),
              ),
              onRecordStop: () {
                onRecordStopCalled = true;
              },
            ),
          ),
        );

        await tester.tap(find.bySvgIcon(StreamSvgIcons.stop));

        expect(onRecordStopCalled, true);
      },
    );

    testWidgets(
      'calls onRecordFinish when checkSend is tap RecordStateRecordingLocked',
      (tester) async {
        var onRecordFinishCalled = false;
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: RecordStateRecordingLocked(
                duration: const Duration(seconds: 5),
                waveform: List.filled(50, 0.5),
              ),
              onRecordFinish: () {
                onRecordFinishCalled = true;
              },
            ),
          ),
        );

        await tester.tap(find.bySvgIcon(StreamSvgIcons.checkSend));

        expect(onRecordFinishCalled, true);
      },
    );

    testWidgets(
      'shows stopped recording UI with playback controls',
      (tester) async {
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: RecordStateStopped(
                audioRecording: fakeAudioRecording,
              ),
            ),
          ),
        );

        expect(find.byType(PlaybackControlButton), findsOneWidget);
        expect(find.byType(PlaybackTimerText), findsOneWidget);
        expect(find.byType(StreamAudioWaveformSlider), findsOneWidget);
        expect(find.bySvgIcon(StreamSvgIcons.delete), findsOneWidget);
        expect(find.bySvgIcon(StreamSvgIcons.checkSend), findsOneWidget);
      },
    );

    testWidgets(
      'calls onRecordFinish when checkSend is tap in RecordStateStopped',
      (tester) async {
        var onRecordFinishCalled = false;
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: RecordStateStopped(
                audioRecording: fakeAudioRecording,
              ),
              onRecordFinish: () {
                onRecordFinishCalled = true;
              },
            ),
          ),
        );

        await tester.tap(find.bySvgIcon(StreamSvgIcons.checkSend));

        expect(onRecordFinishCalled, true);
      },
    );

    testWidgets(
      'calls onRecordFinish when delete is tap in RecordStateStopped',
      (tester) async {
        var onRecordCancelCalled = false;
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: RecordStateStopped(
                audioRecording: fakeAudioRecording,
              ),
              onRecordCancel: () {
                onRecordCancelCalled = true;
              },
            ),
          ),
        );

        await tester.tap(find.bySvgIcon(StreamSvgIcons.delete));

        expect(onRecordCancelCalled, true);
      },
    );

    testWidgets(
      'calls feedback.onRecordStart when long pressed',
      (tester) async {
        var feedbackCalled = false;
        final customFeedback = _TestFeedback(
          onStart: () => feedbackCalled = true,
        );

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: const RecordStateIdle(),
              feedback: customFeedback,
              onRecordStart: () {},
            ),
          ),
        );

        final center = tester.getCenter(find.byType(StreamAudioRecorderButton));

        await tester.startGesture(center);
        await tester.pump(kLongPressTimeout);
        await tester.pumpAndSettle();

        expect(feedbackCalled, isTrue);
      },
    );

    testWidgets(
      'calls feedback.onRecordFinish when long press is released',
      (tester) async {
        var feedbackCalled = false;
        final customFeedback = _TestFeedback(
          onFinish: () => feedbackCalled = true,
        );

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: const RecordStateRecordingHold(),
              feedback: customFeedback,
              onRecordFinish: () {},
            ),
          ),
        );

        final center = tester.getCenter(find.byType(RecordButton));
        final gesture = await tester.startGesture(center);
        await tester.pump(kLongPressTimeout);
        await gesture.up();

        expect(feedbackCalled, isTrue);
      },
    );

    testWidgets(
      'calls feedback.onRecordLock when dragged up beyond threshold',
      (tester) async {
        const lockThreshold = 60.0;
        var feedbackCalled = false;
        final customFeedback = _TestFeedback(
          onLock: () => feedbackCalled = true,
        );

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: const RecordStateRecordingHold(),
              lockRecordThreshold: lockThreshold,
              feedback: customFeedback,
              onRecordLock: () {},
            ),
          ),
        );

        final center = tester.getCenter(find.byType(RecordButton));
        final gesture = await tester.startGesture(center);
        await tester.pump(kLongPressTimeout);
        await gesture.moveBy(const Offset(0, -lockThreshold));

        expect(feedbackCalled, isTrue);
      },
    );

    testWidgets(
      'calls feedback.onRecordCancel when dragged left beyond threshold',
      (tester) async {
        const cancelThreshold = 60.0;
        var feedbackCalled = false;
        final customFeedback = _TestFeedback(
          onCancel: () => feedbackCalled = true,
        );

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: const RecordStateRecordingHold(),
              cancelRecordThreshold: cancelThreshold,
              feedback: customFeedback,
              onRecordCancel: () {},
            ),
          ),
        );

        final center = tester.getCenter(find.byType(RecordButton));
        final gesture = await tester.startGesture(center);
        await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
        await gesture.moveBy(const Offset(-cancelThreshold, 0));

        expect(feedbackCalled, isTrue);
      },
    );

    testWidgets(
      'calls feedback.onRecordStop when stop is tapped in locked state',
      (tester) async {
        var feedbackCalled = false;
        final customFeedback = _TestFeedback(
          onStop: () => feedbackCalled = true,
        );

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: RecordStateRecordingLocked(
                duration: const Duration(seconds: 5),
                waveform: List.filled(50, 0.5),
              ),
              feedback: customFeedback,
              onRecordStop: () {},
            ),
          ),
        );

        await tester.tap(find.bySvgIcon(StreamSvgIcons.stop));

        expect(feedbackCalled, isTrue);
      },
    );

    testWidgets(
      'calls feedback.onRecordCancel when delete is tapped in locked state',
      (tester) async {
        var feedbackCalled = false;
        final customFeedback = _TestFeedback(
          onCancel: () => feedbackCalled = true,
        );

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: RecordStateRecordingLocked(
                duration: const Duration(seconds: 5),
                waveform: List.filled(50, 0.5),
              ),
              feedback: customFeedback,
              onRecordCancel: () {},
            ),
          ),
        );

        await tester.tap(find.bySvgIcon(StreamSvgIcons.delete));

        expect(feedbackCalled, isTrue);
      },
    );

    testWidgets(
      'calls feedback.onRecordFinish when checkSend is tapped in locked state',
      (tester) async {
        var feedbackCalled = false;
        final customFeedback = _TestFeedback(
          onFinish: () => feedbackCalled = true,
        );

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: RecordStateRecordingLocked(
                duration: const Duration(seconds: 5),
                waveform: List.filled(50, 0.5),
              ),
              feedback: customFeedback,
              onRecordFinish: () {},
            ),
          ),
        );

        await tester.tap(find.bySvgIcon(StreamSvgIcons.checkSend));

        expect(feedbackCalled, isTrue);
      },
    );

    testWidgets(
      'calls feedback.onRecordCancel when delete is tapped in stopped state',
      (tester) async {
        var feedbackCalled = false;
        final customFeedback = _TestFeedback(
          onCancel: () => feedbackCalled = true,
        );

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: RecordStateStopped(
                audioRecording: fakeAudioRecording,
              ),
              feedback: customFeedback,
              onRecordCancel: () {},
            ),
          ),
        );

        await tester.tap(find.bySvgIcon(StreamSvgIcons.delete));

        expect(feedbackCalled, isTrue);
      },
    );

    testWidgets(
      'calls feedback.onRecordFinish when checkSend is tapped in stopped state',
      (tester) async {
        var feedbackCalled = false;
        final customFeedback = _TestFeedback(
          onFinish: () => feedbackCalled = true,
        );

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: RecordStateStopped(
                audioRecording: fakeAudioRecording,
              ),
              feedback: customFeedback,
              onRecordFinish: () {},
            ),
          ),
        );

        await tester.tap(find.bySvgIcon(StreamSvgIcons.checkSend));

        expect(feedbackCalled, isTrue);
      },
    );

    testWidgets(
      'calls feedback.onRecordStartCancel when long press is canceled',
      (tester) async {
        var feedbackCalled = false;
        final customFeedback = _TestFeedback(
          onStartCancel: () => feedbackCalled = true,
        );

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: const RecordStateIdle(),
              feedback: customFeedback,
              onRecordStartCancel: () {},
            ),
          ),
        );

        final center = tester.getCenter(find.byType(StreamAudioRecorderButton));
        final gesture = await tester.startGesture(center);
        // Cancel before long press timeout completes
        await tester.pump(kLongPressTimeout - const Duration(milliseconds: 50));
        await gesture.cancel();

        expect(feedbackCalled, isTrue);
      },
    );

    testWidgets(
      'does not call feedback when disabled',
      (tester) async {
        var feedbackCalled = false;
        final customFeedback = _TestFeedback(
          enableFeedback: false,
          onStart: () => feedbackCalled = true,
        );

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamAudioRecorderButton(
              recordState: const RecordStateIdle(),
              feedback: customFeedback,
              onRecordStart: () {},
            ),
          ),
        );

        final center = tester.getCenter(find.byType(StreamAudioRecorderButton));
        await tester.startGesture(center);
        await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));

        expect(feedbackCalled, isFalse);
      },
    );

    for (final brightness in Brightness.values) {
      goldenTest(
        '[${brightness.name}] -> should look fine in idol state',
        fileName: 'stream_audio_recorder_button_idle_${brightness.name}',
        constraints: const BoxConstraints.tightFor(width: 400, height: 160),
        builder: () => _wrapWithStreamChatApp(
          brightness: brightness,
          const StreamAudioRecorderButton(
            recordState: RecordStateIdle(),
          ),
        ),
      );

      goldenTest(
        '[${brightness.name}] -> should look fine in recording hold state',
        fileName:
            'stream_audio_recorder_button_recording_hold_${brightness.name}',
        constraints: const BoxConstraints.tightFor(width: 400, height: 160),
        builder: () => _wrapWithStreamChatApp(
          brightness: brightness,
          StreamAudioRecorderButton(
            recordState: RecordStateRecordingHold(
              duration: const Duration(seconds: 5),
              waveform: List.filled(50, 0.5),
            ),
          ),
        ),
      );

      goldenTest(
        '[${brightness.name}] -> should look fine in recording locked state',
        fileName:
            'stream_audio_recorder_button_recording_locked_${brightness.name}',
        constraints: const BoxConstraints.tightFor(width: 400, height: 160),
        builder: () => _wrapWithStreamChatApp(
          brightness: brightness,
          StreamAudioRecorderButton(
            recordState: RecordStateRecordingLocked(
              duration: const Duration(seconds: 5),
              waveform: List.filled(50, 0.5),
            ),
            onRecordCancel: () {},
            onRecordStop: () {},
            onRecordFinish: () {},
          ),
        ),
      );

      goldenTest(
        '[${brightness.name}] -> should look fine in recording stopped state',
        fileName:
            'stream_audio_recorder_button_recording_stopped_${brightness.name}',
        constraints: const BoxConstraints.tightFor(width: 400, height: 160),
        builder: () => _wrapWithStreamChatApp(
          brightness: brightness,
          StreamAudioRecorderButton(
            recordState: RecordStateStopped(
              audioRecording: fakeAudioRecording,
            ),
            onRecordCancel: () {},
            onRecordFinish: () {},
          ),
        ),
      );
    }
  });
}

Widget _wrapWithStreamChatApp(
  Widget widget, {
  Brightness? brightness,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Portal(
      child: StreamChatTheme(
        data: StreamChatThemeData(brightness: brightness),
        child: Builder(builder: (context) {
          final theme = StreamChatTheme.of(context);
          return Scaffold(
            backgroundColor: theme.colorTheme.appBg,
            bottomNavigationBar: Material(
              elevation: 10,
              color: theme.colorTheme.barsBg,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: widget,
              ),
            ),
          );
        }),
      ),
    ),
  );
}

class _TestFeedback extends AudioRecorderFeedback {
  _TestFeedback({
    this.onStart,
    this.onFinish,
    this.onLock,
    this.onCancel,
    this.onStop,
    this.onStartCancel,
    super.enableFeedback = true,
  });

  final VoidCallback? onStart;
  final VoidCallback? onFinish;
  final VoidCallback? onLock;
  final VoidCallback? onCancel;
  final VoidCallback? onStop;
  final VoidCallback? onStartCancel;

  @override
  Future<void> onRecordStart(BuildContext context) async {
    if (enableFeedback) onStart?.call();
  }

  @override
  Future<void> onRecordFinish(BuildContext context) async {
    if (enableFeedback) onFinish?.call();
  }

  @override
  Future<void> onRecordLock(BuildContext context) async {
    if (enableFeedback) onLock?.call();
  }

  @override
  Future<void> onRecordCancel(BuildContext context) async {
    if (enableFeedback) onCancel?.call();
  }

  @override
  Future<void> onRecordStop(BuildContext context) async {
    if (enableFeedback) onStop?.call();
  }

  @override
  Future<void> onRecordStartCancel(BuildContext context) async {
    if (enableFeedback) onStartCancel?.call();
  }
}
