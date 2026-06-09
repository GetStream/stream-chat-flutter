import 'package:equatable/equatable.dart';

/// {@template locationInfo}
/// A model class representing a location with latitude and longitude.
/// {@endtemplate}
class LocationCoordinates extends Equatable {
  /// {@macro locationInfo}
  const LocationCoordinates({
    required this.latitude,
    required this.longitude,
  });

  /// The latitude of the location.
  final double latitude;

  /// The longitude of the location.
  final double longitude;

  /// Creates a copy of [LocationCoordinates] with specified attributes
  /// overridden.
  LocationCoordinates copyWith({
    double? latitude,
    double? longitude,
  }) {
    return LocationCoordinates(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [latitude, longitude];
}
