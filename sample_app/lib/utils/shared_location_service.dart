import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sample_app/utils/location_provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class SharedLocationService {
  SharedLocationService({
    required StreamChatClient client,
    LocationProvider? locationProvider,
  })  : _client = client,
        _locationProvider = locationProvider ?? LocationProvider();

  final StreamChatClient _client;
  final LocationProvider _locationProvider;

  StreamSubscription<Position>? _positionSubscription;
  StreamSubscription<List<Location>>? _activeLiveLocationsSubscription;

  Future<void> initialize() async {
    _activeLiveLocationsSubscription?.cancel();
    _activeLiveLocationsSubscription = _client.state.activeLiveLocationsStream
        .distinct((prev, curr) => prev.length == curr.length)
        .listen((locations) async {
      // If there are no more active locations to update, stop tracking.
      if (locations.isEmpty) return _stopTrackingLocation();

      // Otherwise, start tracking the user's location.
      return _startTrackingLocation();
    });

    return _client.getActiveLiveLocations().ignore();
  }

  Future<void> _startTrackingLocation() async {
    if (_positionSubscription != null) return;

    // Start listening to the position stream.
    _positionSubscription = _locationProvider.positionStream
        .throttleTime(const Duration(seconds: 3))
        .listen(_onPositionUpdate);

    return _locationProvider.startTracking();
  }

  void _stopTrackingLocation() {
    _locationProvider.stopTracking();

    // Stop tracking the user's location
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  void _onPositionUpdate(Position position) {
    // Handle location updates, e.g., update the UI or send to server
    final activeLiveLocations = _client.state.activeLiveLocations;
    if (activeLiveLocations.isEmpty) return _stopTrackingLocation();

    // Update all active live locations
    for (final location in activeLiveLocations) {
      // Skip if the location is not live or has expired
      if (location.isLive && location.isExpired) continue;

      // Skip if the location does not have a messageId
      final messageId = location.messageId;
      if (messageId == null) continue;

      // Update the live location with the new position
      _client.updateLiveLocation(
        messageId: messageId,
        createdByDeviceId: location.createdByDeviceId,
        location: LocationCoordinates(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    }
  }

  /// Clean up resources
  Future<void> dispose() async {
    _stopTrackingLocation();

    _activeLiveLocationsSubscription?.cancel();
    _activeLiveLocationsSubscription = null;
  }
}
