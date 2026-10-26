import 'dart:convert';
import 'dart:math';

import 'package:uuid/uuid.dart';

const allureResultMarker = 'ALLURE-RESULT::';
const allureAttachmentMarker = 'ALLURE-ATTACH::';

/// Lightweight per-test outcome marker, emitted once per test as
/// `E2E-TEST::<status>::<base64(name)>`. The Fastlane lane parses these to
/// retry **only** the tests that failed in an attempt (rather than re-running
/// the whole file); the name is base64-encoded to survive any characters in
/// the test description. Separate from [allureResultMarker] (which carries the
/// full report payload) so retry attribution stays cheap and delimiter-safe.
const allureTestStatusMarker = 'E2E-TEST::';

const _chunkSize = 900;

enum AllureStatus { passed, failed, broken, skipped }

class _Attachment {
  _Attachment({required this.name, required this.source, required this.type});

  final String name;
  final String source;
  final String type;

  Map<String, Object?> toJson() => {'name': name, 'source': source, 'type': type};
}

class _Step {
  _Step(this.name, this.start);

  final String name;
  final int start;
  int? stop;
  AllureStatus status = AllureStatus.passed;
  Map<String, String>? statusDetails;
  final List<_Step> steps = [];

  Map<String, Object?> toJson() => {
    'name': name,
    'status': status.name,
    if (statusDetails != null) 'statusDetails': statusDetails,
    'stage': 'finished',
    'start': start,
    'stop': stop,
    'steps': [for (final s in steps) s.toJson()],
  };
}

class _Result {
  _Result({
    required this.uuid,
    required this.name,
    required this.fullName,
    required this.start,
    required this.labels,
  });

  final String uuid;
  final String name;
  final String fullName;
  final int start;
  int? stop;
  AllureStatus status = AllureStatus.passed;
  Map<String, String>? statusDetails;
  final List<Map<String, String>> labels;
  final List<_Step> steps = [];
  final List<_Attachment> attachments = [];

  Map<String, Object?> toJson() => {
    'uuid': uuid,
    'historyId': base64.encode(utf8.encode(fullName)),
    'name': name,
    'fullName': fullName,
    'status': status.name,
    if (statusDetails != null) 'statusDetails': statusDetails,
    'stage': 'finished',
    'start': start,
    'stop': stop,
    'labels': labels,
    'steps': [for (final s in steps) s.toJson()],
    'attachments': [for (final a in attachments) a.toJson()],
  };
}

class Allure {
  Allure._();

  static final Allure instance = Allure._();

  _Result? _result;
  _Step? _openStep;

  int get _now => DateTime.now().millisecondsSinceEpoch;

  void startTest({
    required String name,
    required String fullName,
    Map<String, String> labels = const {},
  }) {
    _openStep = null;
    _result = _Result(
      uuid: const Uuid().v4(),
      name: name,
      fullName: fullName,
      start: _now,
      labels: [
        for (final entry in labels.entries) {'name': entry.key, 'value': entry.value},
      ],
    );
  }

  /// Records a BDD step marker. The statements that run after this call, up to
  /// the next [beginStep] (or the end of the test), are the step's body — so a
  /// step needs no closure and reads like the native `step("...") { ... }`.
  ///
  /// A failure in the body is attributed to whichever step is open when the
  /// test stops (see [stopTest]).
  void beginStep(String name) {
    final result = _result;
    if (result == null) return;
    _closeOpenStep();
    final step = _Step(name, _now);
    result.steps.add(step);
    _openStep = step;
  }

  void _closeOpenStep({AllureStatus? status, String? message, String? trace}) {
    final step = _openStep;
    if (step == null) return;
    step.stop = _now;
    if (status != null && status != AllureStatus.passed) {
      step
        ..status = status
        ..statusDetails = {
          if (message != null) 'message': message,
          if (trace != null) 'trace': trace,
        };
    }
    _openStep = null;
  }

  /// Attaches a binary artifact (e.g. a screenshot) to the current test.
  ///
  /// The bytes are streamed to the device log as chunked
  /// `ALLURE-ATTACH::<source>:<seq>:<base64>` markers (the same transport as
  /// results); `collect_allure_results` reassembles them into
  /// `allure-results/<source>` and this entry references it. Register before
  /// [stopTest] so the reference is included in the emitted result JSON.
  void attachBytes(
    String name,
    List<int> bytes, {
    required String type,
    required String ext,
  }) {
    final result = _result;
    if (result == null || bytes.isEmpty) return;
    final source = '${const Uuid().v4()}-attachment.$ext';
    result.attachments.add(_Attachment(name: name, source: source, type: type));
    _emitChunked(allureAttachmentMarker, source, base64.encode(bytes));
  }

  /// Attaches a text artifact (e.g. the widget hierarchy or a log) to the
  /// current test. See [attachBytes].
  void attachText(
    String name,
    String content, {
    String type = 'text/plain',
    String ext = 'txt',
  }) {
    if (content.isEmpty) return;
    attachBytes(name, utf8.encode(content), type: type, ext: ext);
  }

  void _emitChunked(String marker, String key, String encoded) {
    for (var i = 0, seq = 0; i < encoded.length; i += _chunkSize, seq++) {
      final chunk = encoded.substring(i, min(i + _chunkSize, encoded.length));
      print('$marker$key:$seq:$chunk');
    }
  }

  void stopTest({
    required AllureStatus status,
    Object? message,
    StackTrace? trace,
  }) {
    final result = _result;
    if (result == null) return;
    // Close the step that was open when the test ended, propagating a failure
    // to it so the report points at the step whose body actually threw.
    _closeOpenStep(
      status: status,
      message: message?.toString(),
      trace: trace?.toString(),
    );
    result
      ..status = status
      ..stop = _now;
    if (message != null) {
      result.statusDetails = {
        'message': '$message',
        if (trace != null) 'trace': '$trace',
      };
    }

    _emitChunked(allureResultMarker, result.uuid, base64.encode(utf8.encode(jsonEncode(result.toJson()))));
    // Compact outcome line for the Fastlane retry logic (see the marker doc).
    print('$allureTestStatusMarker${status.name}::${base64.encode(utf8.encode(result.name))}');
    _result = null;
  }
}
