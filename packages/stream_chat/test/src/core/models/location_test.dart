import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/location.dart';
import 'package:stream_chat/src/core/models/location_coordinates.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:test/test.dart';

void main() {
  group('Location', () {
    const latitude = 37.7749;
    const longitude = -122.4194;
    const createdByDeviceId = 'device_123';

    final location = Location(
      latitude: latitude,
      longitude: longitude,
      createdByDeviceId: createdByDeviceId,
    );

    test('should create a valid instance with minimal parameters', () {
      expect(location.latitude, equals(latitude));
      expect(location.longitude, equals(longitude));
      expect(location.createdByDeviceId, equals(createdByDeviceId));
      expect(location.endAt, isNull);
      expect(location.channelCid, isNull);
      expect(location.channel, isNull);
      expect(location.messageId, isNull);
      expect(location.message, isNull);
      expect(location.userId, isNull);
      expect(location.createdAt, isA<DateTime>());
      expect(location.updatedAt, isA<DateTime>());
    });

    test('should create a valid instance with all parameters', () {
      final createdAt = DateTime.parse('2023-01-01T00:00:00.000Z');
      final updatedAt = DateTime.parse('2023-01-01T01:00:00.000Z');
      final endAt = DateTime.parse('2024-12-31T23:59:59.999Z');
      final channel = ChannelModel(
        cid: 'test:channel',
        id: 'channel',
        type: 'test',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final message = Message(
        id: 'message_123',
        text: 'Test message',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final fullLocation = Location(
        channelCid: 'test:channel',
        channel: channel,
        messageId: 'message_123',
        message: message,
        userId: 'user_123',
        latitude: latitude,
        longitude: longitude,
        createdByDeviceId: createdByDeviceId,
        endAt: endAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(fullLocation.channelCid, equals('test:channel'));
      expect(fullLocation.channel, equals(channel));
      expect(fullLocation.messageId, equals('message_123'));
      expect(fullLocation.message, equals(message));
      expect(fullLocation.userId, equals('user_123'));
      expect(fullLocation.latitude, equals(latitude));
      expect(fullLocation.longitude, equals(longitude));
      expect(fullLocation.createdByDeviceId, equals(createdByDeviceId));
      expect(fullLocation.endAt, equals(endAt));
      expect(fullLocation.createdAt, equals(createdAt));
      expect(fullLocation.updatedAt, equals(updatedAt));
    });

    test('should correctly serialize to JSON', () {
      final json = location.toJson();

      expect(json['latitude'], equals(latitude));
      expect(json['longitude'], equals(longitude));
      expect(json['created_by_device_id'], equals(createdByDeviceId));
      expect(json['end_at'], isNull);
      expect(json.containsKey('channel_cid'), isFalse);
      expect(json.containsKey('channel'), isFalse);
      expect(json.containsKey('message_id'), isFalse);
      expect(json.containsKey('message'), isFalse);
      expect(json.containsKey('user_id'), isFalse);
      expect(json.containsKey('created_at'), isFalse);
      expect(json.containsKey('updated_at'), isFalse);
    });

    test('should serialize live location with endAt correctly', () {
      final endAt = DateTime.parse('2024-12-31T23:59:59.999Z');
      final liveLocation = Location(
        latitude: latitude,
        longitude: longitude,
        createdByDeviceId: createdByDeviceId,
        endAt: endAt,
      );

      final json = liveLocation.toJson();

      expect(json['latitude'], equals(latitude));
      expect(json['longitude'], equals(longitude));
      expect(json['created_by_device_id'], equals(createdByDeviceId));
      expect(json['end_at'], equals('2024-12-31T23:59:59.999Z'));
    });

    test('should return correct coordinates', () {
      final coordinates = location.coordinates;

      expect(coordinates, isA<LocationCoordinates>());
      expect(coordinates.latitude, equals(latitude));
      expect(coordinates.longitude, equals(longitude));
    });

    test('isActive should return true for active live location', () {
      final futureDate = DateTime.now().add(const Duration(hours: 1));
      final activeLocation = Location(
        latitude: latitude,
        longitude: longitude,
        createdByDeviceId: createdByDeviceId,
        endAt: futureDate,
      );

      expect(activeLocation.isActive, isTrue);
      expect(activeLocation.isExpired, isFalse);
    });

    test('isActive should return false for expired live location', () {
      final pastDate = DateTime.now().subtract(const Duration(hours: 1));
      final expiredLocation = Location(
        latitude: latitude,
        longitude: longitude,
        createdByDeviceId: createdByDeviceId,
        endAt: pastDate,
      );

      expect(expiredLocation.isActive, isFalse);
      expect(expiredLocation.isExpired, isTrue);
    });

    test('isLive should return true for live location', () {
      final futureDate = DateTime.now().add(const Duration(hours: 1));
      final liveLocation = Location(
        latitude: latitude,
        longitude: longitude,
        createdByDeviceId: createdByDeviceId,
        endAt: futureDate,
      );

      expect(liveLocation.isLive, isTrue);
      expect(liveLocation.isStatic, isFalse);
    });

    test('equality should work correctly', () {
      final location1 = Location(
        channelCid: 'test:channel',
        messageId: 'message_123',
        userId: 'user_123',
        latitude: latitude,
        longitude: longitude,
        createdByDeviceId: createdByDeviceId,
        endAt: DateTime.parse('2024-12-31T23:59:59.999Z'),
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final location2 = Location(
        channelCid: 'test:channel',
        messageId: 'message_123',
        userId: 'user_123',
        latitude: latitude,
        longitude: longitude,
        createdByDeviceId: createdByDeviceId,
        endAt: DateTime.parse('2024-12-31T23:59:59.999Z'),
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final location3 = Location(
        channelCid: 'test:channel',
        messageId: 'message_123',
        userId: 'user_123',
        latitude: 40.7128, // Different latitude
        longitude: longitude,
        createdByDeviceId: createdByDeviceId,
        endAt: DateTime.parse('2024-12-31T23:59:59.999Z'),
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      expect(location1, equals(location2));
      expect(location1.hashCode, equals(location2.hashCode));
      expect(location1, isNot(equals(location3)));
    });
  });
}
