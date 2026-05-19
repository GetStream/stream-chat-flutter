import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/app.dart';
import 'package:sample_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before wiring Crashlytics handlers so the error
  // reporters have a live Firebase app to talk to.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Avoid sending Crashlytics reports for crashes that happen during local
  // development; reports still flow in release/profile builds.
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(!kDebugMode);

  /// Captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      // In development mode, simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode, report the framework error to Crashlytics as fatal
      // so it surfaces alongside native crashes.
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    }
  };

  /// Captures errors reported by the platform dispatcher, including async
  /// errors thrown outside the Flutter framework (e.g. from native iOS and
  /// Android code via platform channels).
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      // Print the full stacktrace in debug mode.
      debugPrint('Uncaught platform error: $error\n$stack');
    } else {
      // Send the exception and stack trace to Crashlytics in production mode.
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    // Returning true marks the error as handled so it does not propagate.
    return true;
  };

  runApp(const StreamChatSampleApp());
}
