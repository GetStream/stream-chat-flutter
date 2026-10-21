// ignore_for_file: avoid_redundant_argument_values

import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/channel', () {
    test('should parse json correctly', () {
      final channel = ChannelModel.fromJson(jsonFixture('channel.json'));
      expect(channel.id, equals('test'));
      expect(channel.type, equals('livestream'));
      expect(channel.cid, equals('livestream:test'));
      expect(channel.custom['cats'], equals(true));
      expect(channel.custom['fruit'], equals(['bananas', 'apples']));
      expect(channel.cooldown, equals(0));
      expect(channel.disabled, isFalse);
      expect(channel.hidden, isTrue);
      expect(channel.muted, isTrue);
      expect(channel.blocked, isFalse);
      expect(channel.truncatedAt, DateTime.parse('2020-01-29T03:22:47.636130Z'));
      expect(channel.truncatedBy?.id, 'truncator');
      expect(channel.truncatedBy?.name, 'Truncator');
      expect(channel.autoTranslationEnabled, isTrue);
      expect(channel.autoTranslationLanguage, 'fr');
    });

    test('should serialize to json correctly', () {
      final channel = ChannelModel(
        type: 'type',
        id: 'id',
        cid: 'a:a',
        custom: {'name': 'cool'},
      );

      expect(
        channel.toJson(),
        {
          'id': 'id',
          'type': 'type',
          'frozen': false,
          'cooldown': 0,
          'name': 'cool',
        },
      );
    });

    test('should serialize to json correctly when frozen is provided', () {
      final channel = ChannelModel(
        type: 'type',
        id: 'id',
        cid: 'a:a',
        custom: {'name': 'cool'},
      );

      expect(
        channel.toJson(),
        {
          'id': 'id',
          'type': 'type',
          'frozen': false,
          'cooldown': 0,
          'name': 'cool',
        },
      );
    });
  });

  test('ChannelModel.toJson leaves out custom data named like a field', () {
    final channel = ChannelModel(
      cid: 'test:cid',
      hidden: true,
      custom: const {'hidden': 'custom', 'id': 'custom', 'color': 'red'},
    );

    expect(channel.toJson(), {
      'id': 'cid',
      'type': 'test',
      'frozen': false,
      'cooldown': 0,
      'color': 'red',
    });
  });

  test('ChannelModel.copyWith keeps the flags it is not given', () {
    final channel = ChannelModel(
      cid: 'test:cid',
      hidden: true,
      truncatedBy: User(id: 'truncator'),
      autoTranslationEnabled: true,
      autoTranslationLanguage: 'fr',
    );

    final newChannel = channel.copyWith(team: 'blue');

    expect(newChannel.hidden, isTrue);
    expect(newChannel.truncatedBy?.id, 'truncator');
    expect(newChannel.autoTranslationEnabled, isTrue);
    expect(newChannel.autoTranslationLanguage, 'fr');
  });

  test('ChannelModel.copyWith does not set a field from custom data named like it', () {
    final channel = ChannelModel(cid: 'test:cid', hidden: true);

    final newChannel = channel.copyWith(custom: const {'hidden': false});

    expect(newChannel.hidden, isTrue);
  });

  test('ChannelModel.copyWith replaces the flags it is given', () {
    final channel = ChannelModel(
      cid: 'test:cid',
      disabled: false,
      hidden: false,
      muted: false,
      blocked: false,
      truncatedAt: DateTime.utc(2026),
      truncatedBy: User(id: 'truncator'),
      autoTranslationEnabled: true,
      autoTranslationLanguage: 'fr',
    );

    final newChannel = channel.copyWith(
      disabled: true,
      hidden: true,
      muted: true,
      blocked: true,
      truncatedAt: DateTime.utc(2026, 2),
      truncatedBy: User(id: 'other'),
      autoTranslationEnabled: false,
      autoTranslationLanguage: 'de',
    );

    expect(newChannel.disabled, isTrue);
    expect(newChannel.hidden, isTrue);
    expect(newChannel.muted, isTrue);
    expect(newChannel.blocked, isTrue);
    expect(newChannel.truncatedAt, DateTime.utc(2026, 2));
    expect(newChannel.truncatedBy?.id, 'other');
    expect(newChannel.autoTranslationEnabled, isFalse);
    expect(newChannel.autoTranslationLanguage, 'de');
  });

  test('ChannelModel.merge keeps the flags the other channel leaves out', () {
    final channel = ChannelModel(
      cid: 'test:cid',
      hidden: true,
      muted: true,
      blocked: true,
      truncatedAt: DateTime.utc(2026),
      truncatedBy: User(id: 'truncator'),
    );

    final merged = channel.merge(ChannelModel(cid: 'test:cid', custom: const {'color': 'red'}));

    expect(merged.hidden, isTrue);
    expect(merged.muted, isTrue);
    expect(merged.blocked, isTrue);
    expect(merged.truncatedAt, DateTime.utc(2026));
    expect(merged.truncatedBy?.id, 'truncator');
  });

  test('ChannelModel.merge takes the custom data from the other channel', () {
    final channel = ChannelModel(cid: 'test:cid', custom: const {'color': 'blue'});

    final merged = channel.merge(ChannelModel(cid: 'test:cid', custom: const {'color': 'red'}));

    expect(merged.custom, {'color': 'red'});
  });

  test('ChannelModel.merge turns auto translation off when the other channel leaves it out', () {
    final channel = ChannelModel(cid: 'test:cid', autoTranslationEnabled: true, autoTranslationLanguage: 'fr');

    final merged = channel.merge(ChannelModel(cid: 'test:cid'));

    expect(merged.autoTranslationEnabled, isFalse);
    expect(merged.autoTranslationLanguage, isNull);
  });

  test('.name should fetch from custom if available', () {
    final channel = ChannelModel(
      cid: 'test:channel',
      custom: const {'name': 'Test Channel'},
    );

    expect(channel.name, 'Test Channel');
  });

  test('.name should return null if not available in custom', () {
    final channel = ChannelModel(
      cid: 'test:channel',
      custom: const {},
    );

    expect(channel.name, isNull);
  });

  test('.name should return null if custom value is not String', () {
    final channel = ChannelModel(
      cid: 'test:channel',
      custom: const {'name': true},
    );

    expect(channel.name, isNull);
  });

  test('.name should return null if custom value is empty', () {
    final channel = ChannelModel(
      cid: 'test:channel',
      custom: const {'name': ''},
    );

    expect(channel.name, isNull);
  });

  test('should parse filterTags from json correctly', () {
    final channel = ChannelModel.fromJson({
      'id': 'test',
      'type': 'livestream',
      'filter_tags': ['tag1', 'tag2', 'tag3'],
    });

    expect(channel.filterTags, equals(['tag1', 'tag2', 'tag3']));
  });

  test('.lastUpdatedAt should return lastMessageAt if newer than createdAt', () {
    final channel = ChannelModel(
      cid: 'test:channel',
      createdAt: DateTime(2023, 6, 10),
      lastMessageAt: DateTime(2023, 6, 15),
    );

    expect(channel.lastUpdatedAt, DateTime(2023, 6, 15));
  });

  test('.lastUpdatedAt should return createdAt if lastMessageAt is null', () {
    final channel = ChannelModel(
      cid: 'test:channel',
      createdAt: DateTime(2023, 6, 10),
    );

    expect(channel.lastUpdatedAt, DateTime(2023, 6, 10));
  });

  test('.lastUpdatedAt should return createdAt if lastMessageAt is older', () {
    final channel = ChannelModel(
      cid: 'test:channel',
      createdAt: DateTime(2023, 6, 10),
      // Truncating a channel moves lastMessageAt back instead of clearing it.
      lastMessageAt: DateTime(1970),
    );

    expect(channel.lastUpdatedAt, DateTime(2023, 6, 10));
  });
}
