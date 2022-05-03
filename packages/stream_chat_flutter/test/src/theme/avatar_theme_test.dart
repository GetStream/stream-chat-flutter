import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test('AvatarThemeData copyWith, ==, hashCode basics', () {
    expect(const StreamAvatarThemeData(),
        const StreamAvatarThemeData().copyWith());
    expect(const StreamAvatarThemeData().hashCode,
        const StreamAvatarThemeData().copyWith().hashCode);
  });

  group('AvatarThemeData lerps correctly', () {
    test('Lerp completely', () {
      expect(
          const StreamAvatarThemeData()
              .lerp(_avatarThemeDataControl1, _avatarThemeDataControl2, 1),
          _avatarThemeDataControl2);
    });

    test('Lerp halfway', () {
      expect(
          const StreamAvatarThemeData()
              .lerp(_avatarThemeDataControl1, _avatarThemeDataControl2, 0.5),
          _avatarThemeDataControlMidLerp);
    });
  });

  test('Merging two AvatarThemeData results in the latter', () {
    expect(_avatarThemeDataControl1.merge(_avatarThemeDataControl2),
        _avatarThemeDataControl2);
  });
}

const _avatarThemeDataControl1 = StreamAvatarThemeData();

final _avatarThemeDataControlMidLerp = StreamAvatarThemeData(
  borderRadius: BorderRadius.circular(16),
  constraints: const BoxConstraints.tightFor(
    height: 33,
    width: 33,
  ),
);

final _avatarThemeDataControl2 = StreamAvatarThemeData(
  borderRadius: BorderRadius.circular(12),
  constraints: const BoxConstraints.tightFor(
    height: 34,
    width: 34,
  ),
);
