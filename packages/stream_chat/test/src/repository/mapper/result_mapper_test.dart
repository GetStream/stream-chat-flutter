import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/repository/mapper/result_mapper.dart';
import 'package:stream_core/stream_core.dart';
import 'package:test/test.dart';

void main() {
  test('Result.ignoreResult turns a success into a success with no value', () {
    const result = Result.success(api.DurationResponse(duration: '0.01ms'));

    final ignored = result.ignoreResult();

    expect(ignored, const Result<void>.success(null));
    expect(ignored, isNot(isA<Success<api.DurationResponse>>()));
  });

  test('Result.ignoreResult keeps the error and stack trace of a failure', () {
    final error = StateError('boom');
    final stackTrace = StackTrace.current;
    final result = Result<api.DurationResponse>.failure(error, stackTrace);

    expect(result.ignoreResult(), Result<void>.failure(error, stackTrace));
  });
}
