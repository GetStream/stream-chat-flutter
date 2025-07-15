// ignore_for_file: close_sinks

import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

const notificationTitle = 'Live Location Tracking';
const notificationText = 'Your location is being tracked live.';

class LocationProvider {
  factory LocationProvider() => _instance;
  LocationProvider._();

  static final LocationProvider _instance = LocationProvider._();

  Stream<Position> get positionStream => _positionStreamController.stream;
  final _positionStreamController = StreamController<Position>.broadcast();

  StreamSubscription<Position>? _positionSubscription;

  /// Opens the device's location settings page.
  ///
  /// Returns [true] if the location settings page could be opened, otherwise
  /// [false] is returned.
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  /// Get current static location
  Future<Position?> getCurrentLocation() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return null;

    return Geolocator.getCurrentPosition();
  }

  /// Start live tracking
  Future<void> startTracking({
    int distanceFilter = 10,
    LocationAccuracy accuracy = LocationAccuracy.high,
    ActivityType activityType = ActivityType.automotiveNavigation,
  }) async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return;

    final settings = switch (CurrentPlatform.type) {
      PlatformType.android => AndroidSettings(
          accuracy: accuracy,
          distanceFilter: distanceFilter,
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            setOngoing: true,
            notificationText: notificationText,
            notificationTitle: notificationTitle,
            notificationIcon: AndroidResource(name: 'ic_notification'),
          ),
        ),
      PlatformType.ios || PlatformType.macOS => AppleSettings(
          accuracy: accuracy,
          activityType: activityType,
          distanceFilter: distanceFilter,
          showBackgroundLocationIndicator: true,
          pauseLocationUpdatesAutomatically: true,
        ),
      _ => LocationSettings(
          accuracy: accuracy,
          distanceFilter: distanceFilter,
        )
    };

    _positionSubscription?.cancel(); // avoid duplicate subscriptions
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen(
      _positionStreamController.safeAdd,
      onError: _positionStreamController.safeAddError,
    );
  }

  /// Stop live tracking
  void stopTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  Future<bool> _handlePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return switch (permission) {
      LocationPermission.denied || LocationPermission.deniedForever => false,
      _ => true,
    };
  }
}
