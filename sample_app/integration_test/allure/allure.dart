import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart' show TestFailure;
import 'package:uuid/uuid.dart';

const allureResultMarker = 'ALLURE-RESULT::';
const _chunkSize = 900;

enum AllureStatus { passed, failed, broken, skipped }

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
  };
}

class Allure {
  Allure._();

  static final Allure instance = Allure._();

  _Result? _result;
  final List<_Step> _stepStack = [];

  int get _now => DateTime.now().millisecondsSinceEpoch;

  void startTest({
    required String name,
    required String fullName,
    Map<String, String> labels = const {},
  }) {
    _stepStack.clear();
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

  Future<T> step<T>(String name, Future<T> Function() body) async {
    final step = _Step(name, _now);
    (_stepStack.isNotEmpty ? _stepStack.last.steps : _result?.steps)?.add(step);
    _stepStack.add(step);
    try {
      return await body();
    } on TestFailure catch (e) {
      step
        ..status = AllureStatus.failed
        ..statusDetails = {'message': '$e'};
      rethrow;
    } catch (e) {
      step
        ..status = AllureStatus.broken
        ..statusDetails = {'message': '$e'};
      rethrow;
    } finally {
      step.stop = _now;
      _stepStack.removeLast();
    }
  }

  void stopTest({
    required AllureStatus status,
    Object? message,
    StackTrace? trace,
  }) {
    final result = _result;
    if (result == null) return;
    result
      ..status = status
      ..stop = _now;
    if (message != null) {
      result.statusDetails = {
        'message': '$message',
        if (trace != null) 'trace': '$trace',
      };
    }

    final encoded = base64.encode(utf8.encode(jsonEncode(result.toJson())));
    for (var i = 0, seq = 0; i < encoded.length; i += _chunkSize, seq++) {
      final chunk = encoded.substring(i, min(i + _chunkSize, encoded.length));
      print('$allureResultMarker${result.uuid}:$seq:$chunk');
    }
    _result = null;
  }
}
