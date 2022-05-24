import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/channel', () {
    test('should parse json correctly', () {
      final channel = ChannelModel.fromJson(jsonFixture('channel.json'));
      expect(channel.id, equals('test'));
      expect(channel.type, equals('livestream'));
      expect(channel.cid, equals('livestream:test'));
      expect(channel.extraData['cats'], equals(true));
      expect(channel.extraData['fruit'], equals(['bananas', 'apples']));
      expect(channel.cooldown, equals(0));
    });

    test('should serialize to json correctly', () {
      final channel = ChannelModel(
        type: 'type',
        id: 'id',
        cid: 'a:a',
        extraData: {'name': 'cool'},
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
        extraData: {'name': 'cool'},
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

  test('hidden property and extraData manipulation', () {
    final channel = ChannelModel(cid: 'test:cid', hidden: false);

    expect(channel.hidden, false);
    expect(channel.extraData['hidden'], false);
    print(channel.toJson());
    expect(channel.toJson(), {
      'id': 'cid',
      'type': 'test',
      'frozen': false,
      'cooldown': 0,
      'hidden': false,
    });
    expect(ChannelModel.fromJson(channel.toJson()).toJson(), {
      'id': 'cid',
      'type': 'test',
      'frozen': false,
      'cooldown': 0,
      'hidden': false,
    });

    var newChannel = channel.copyWith(
      extraData: {'hidden': true},
    );

    expect(newChannel.extraData['hidden'], true);
    expect(newChannel.hidden, true);

    newChannel = channel.copyWith(
      hidden: false,
    );

    expect(newChannel.extraData['hidden'], false);
    expect(newChannel.hidden, false);

    newChannel = channel.copyWith(
      hidden: true,
      extraData: {'hidden': true},
    );

    expect(newChannel.extraData['hidden'], true);
    expect(newChannel.hidden, true);
  });

  test('disabled property and extraData manipulation', () {
    final channel = ChannelModel(cid: 'test:cid', disabled: false);

    expect(channel.disabled, false);
    expect(channel.extraData['disabled'], false);
    print(channel.toJson());
    expect(channel.toJson(), {
      'id': 'cid',
      'type': 'test',
      'frozen': false,
      'cooldown': 0,
      'disabled': false,
    });
    expect(ChannelModel.fromJson(channel.toJson()).toJson(), {
      'id': 'cid',
      'type': 'test',
      'frozen': false,
      'cooldown': 0,
      'disabled': false,
    });

    var newChannel = channel.copyWith(
      extraData: {'disabled': true},
    );

    expect(newChannel.extraData['disabled'], true);
    expect(newChannel.disabled, true);

    newChannel = channel.copyWith(
      hidden: false,
    );

    expect(newChannel.extraData['disabled'], false);
    expect(newChannel.disabled, false);

    newChannel = channel.copyWith(
      hidden: true,
      extraData: {'disabled': true},
    );

    expect(newChannel.extraData['disabled'], true);
    expect(newChannel.disabled, true);
  });

  test('truncatedAt property and extraData manipulation', () {
    final currentDate = DateTime.now();
    final channel = ChannelModel(cid: 'test:cid', truncatedAt: currentDate);

    expect(channel.truncatedAt, currentDate);
    expect(channel.extraData['truncated_at'], currentDate.toIso8601String());
    print(channel.toJson());
    expect(channel.toJson(), {
      'id': 'cid',
      'type': 'test',
      'frozen': false,
      'cooldown': 0,
      'truncated_at': currentDate.toIso8601String(),
    });
    expect(ChannelModel.fromJson(channel.toJson()).toJson(), {
      'id': 'cid',
      'type': 'test',
      'frozen': false,
      'cooldown': 0,
      'truncated_at': currentDate.toIso8601String(),
    });

    final dateOne = DateTime.now();
    var newChannel = channel.copyWith(
      extraData: {'truncated_at': dateOne.toIso8601String()},
    );

    expect(newChannel.extraData['truncated_at'], dateOne.toIso8601String());
    expect(newChannel.truncatedAt, dateOne);

    final dateTwo = DateTime.now();
    newChannel = channel.copyWith(
      truncatedAt: dateTwo,
    );

    expect(newChannel.extraData['truncated_at'], dateTwo.toIso8601String());
    expect(newChannel.truncatedAt, dateTwo);

    final dateThree = DateTime.now();
    newChannel = channel.copyWith(
      truncatedAt: dateThree,
      extraData: {'truncated_at': dateThree.toIso8601String()},
    );

    expect(newChannel.extraData['truncated_at'], dateThree.toIso8601String());
    expect(newChannel.truncatedAt, dateThree);
  });
}
