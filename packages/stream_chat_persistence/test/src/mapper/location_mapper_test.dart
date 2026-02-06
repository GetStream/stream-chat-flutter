import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/mapper/location_mapper.dart';

void main() {
  group('LocationMapper', () {
    test('toLocation should map the entity into Location', () {
      final createdAt = DateTime.now();
      final updatedAt = DateTime.now();
      final endAt = DateTime.timestamp().add(const Duration(hours: 1));

      final entity = LocationEntity(
        channelCid: 'testCid',
        userId: 'testUserId',
        messageId: 'testMessageId',
        latitude: 40.7128,
        longitude: -74.0060,
        createdByDeviceId: 'testDeviceId',
        endAt: endAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final location = entity.toLocation();

      expect(location, isA<Location>());
      expect(location.channelCid, entity.channelCid);
      expect(location.userId, entity.userId);
      expect(location.messageId, entity.messageId);
      expect(location.latitude, entity.latitude);
      expect(location.longitude, entity.longitude);
      expect(location.createdByDeviceId, entity.createdByDeviceId);
      expect(location.endAt, entity.endAt);
      expect(location.createdAt, entity.createdAt);
      expect(location.updatedAt, entity.updatedAt);
    });

    test('toEntity should map the Location into LocationEntity', () {
      final createdAt = DateTime.timestamp();
      final updatedAt = DateTime.timestamp();
      final endAt = DateTime.timestamp().add(const Duration(hours: 1));

      final location = Location(
        channelCid: 'testCid',
        userId: 'testUserId',
        messageId: 'testMessageId',
        latitude: 40.7128,
        longitude: -74.0060,
        createdByDeviceId: 'testDeviceId',
        endAt: endAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final entity = location.toEntity();

      expect(entity, isA<LocationEntity>());
      expect(entity.channelCid, location.channelCid);
      expect(entity.userId, location.userId);
      expect(entity.messageId, location.messageId);
      expect(entity.latitude, location.latitude);
      expect(entity.longitude, location.longitude);
      expect(entity.createdByDeviceId, location.createdByDeviceId);
      expect(entity.endAt, location.endAt);
      expect(entity.createdAt, location.createdAt);
      expect(entity.updatedAt, location.updatedAt);
    });

    test('roundtrip conversion should preserve data', () {
      final createdAt = DateTime.timestamp();
      final updatedAt = DateTime.timestamp();
      final endAt = DateTime.timestamp().add(const Duration(hours: 1));

      final originalLocation = Location(
        channelCid: 'testCid',
        userId: 'testUserId',
        messageId: 'testMessageId',
        latitude: 40.7128,
        longitude: -74.0060,
        createdByDeviceId: 'testDeviceId',
        endAt: endAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final entity = originalLocation.toEntity();
      final convertedLocation = entity.toLocation();

      expect(convertedLocation.channelCid, originalLocation.channelCid);
      expect(convertedLocation.userId, originalLocation.userId);
      expect(convertedLocation.messageId, originalLocation.messageId);
      expect(convertedLocation.latitude, originalLocation.latitude);
      expect(convertedLocation.longitude, originalLocation.longitude);
      expect(convertedLocation.createdByDeviceId, originalLocation.createdByDeviceId);
      expect(convertedLocation.endAt, originalLocation.endAt);
      expect(convertedLocation.createdAt, originalLocation.createdAt);
      expect(convertedLocation.updatedAt, originalLocation.updatedAt);
    });

    test('should handle live location conversion', () {
      final endAt = DateTime.timestamp().add(const Duration(hours: 1));
      final location = Location(
        channelCid: 'testCid',
        userId: 'testUserId',
        messageId: 'testMessageId',
        latitude: 40.7128,
        longitude: -74.0060,
        createdByDeviceId: 'testDeviceId',
        endAt: endAt,
      );

      final entity = location.toEntity();
      final convertedLocation = entity.toLocation();

      expect(convertedLocation.isLive, isTrue);
      expect(convertedLocation.isStatic, isFalse);
      expect(convertedLocation.endAt, endAt);
    });

    test('should handle static location conversion', () {
      final location = Location(
        channelCid: 'testCid',
        userId: 'testUserId',
        messageId: 'testMessageId',
        latitude: 40.7128,
        longitude: -74.0060,
        createdByDeviceId: 'testDeviceId',
        // No endAt = static location
      );

      final entity = location.toEntity();
      final convertedLocation = entity.toLocation();

      expect(convertedLocation.isLive, isFalse);
      expect(convertedLocation.isStatic, isTrue);
      expect(convertedLocation.endAt, isNull);
    });
  });
}
