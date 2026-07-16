/// No-op stand-in for `firebase_core`, swapped in via `pubspec_overrides.e2e.yaml`.
///
/// Being a pure-Dart package (no `flutter.plugin` section), it removes the Firebase
/// pods / Gradle dependencies from e2e builds entirely: nothing is downloaded,
/// compiled, or initialized. Only the API surface used by `sample_app` is stubbed.
library;

/// No-op replacement for the Firebase entry point.
class Firebase {
  /// Does nothing and returns a dummy [FirebaseApp].
  static Future<FirebaseApp> initializeApp({String? name, FirebaseOptions? options}) async => const FirebaseApp();
}

/// Inert replacement for a configured Firebase app.
class FirebaseApp {
  /// Creates the inert app handle.
  const FirebaseApp();
}

/// Plain data holder matching the real `FirebaseOptions` constructor, so the
/// FlutterFire-generated `firebase_options.dart` compiles unchanged.
class FirebaseOptions {
  /// Mirrors the real constructor's signature; values are never read.
  const FirebaseOptions({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    this.authDomain,
    this.databaseURL,
    this.storageBucket,
    this.measurementId,
    this.trackingId,
    this.deepLinkURLScheme,
    this.androidClientId,
    this.iosClientId,
    this.iosBundleId,
    this.appGroupId,
  });

  /// See the real `firebase_core` for field semantics; all unused here.
  final String apiKey, appId, messagingSenderId, projectId;

  /// Optional platform-specific fields accepted for constructor compatibility.
  final String? authDomain,
      databaseURL,
      storageBucket,
      measurementId,
      trackingId,
      deepLinkURLScheme,
      androidClientId,
      iosClientId,
      iosBundleId,
      appGroupId;
}
