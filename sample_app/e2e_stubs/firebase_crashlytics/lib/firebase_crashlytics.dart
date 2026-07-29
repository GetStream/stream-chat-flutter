/// No-op stand-in for `firebase_crashlytics`, swapped in via `pubspec_overrides.e2e.yaml`.
///
/// See the `firebase_core` stub for the rationale. Only the API surface used by
/// `sample_app` is stubbed; every call silently does nothing.
library;

import 'package:flutter/foundation.dart';

/// No-op replacement for the Crashlytics reporter.
class FirebaseCrashlytics {
  FirebaseCrashlytics._();

  /// The shared no-op instance.
  static final FirebaseCrashlytics instance = FirebaseCrashlytics._();

  /// Does nothing. The positional bool must match the real API's signature.
  // ignore: avoid_positional_boolean_parameters
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {}

  /// Does nothing.
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) async {}

  /// Does nothing.
  Future<void> recordFlutterFatalError(FlutterErrorDetails flutterErrorDetails) async {}
}
