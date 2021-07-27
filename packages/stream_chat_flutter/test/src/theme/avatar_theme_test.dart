import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test('AvatarThemeData copyWith, ==, hashCode basics', () {
    expect(const AvatarThemeData(), const AvatarThemeData().copyWith());
    expect(const AvatarThemeData().hashCode,
        const AvatarThemeData().copyWith().hashCode);
  });

  group('AvatarThemeData lerps correctly', () {
    test('Lerp completely', () {
      expect(
          const AvatarThemeData()
              .lerp(_avatarThemeDataControl1, _avatarThemeDataControl2, 1),
          _avatarThemeDataControl2);
    });

    test('Lerp halfway', () {
      expect(
          const AvatarThemeData()
              .lerp(_avatarThemeDataControl1, _avatarThemeDataControl2, 0.5),
          _avatarThemeDataControlMidLerp);
    });
  });

  test('Merging two AvatarThemeData results in the latter', () {
    expect(_avatarThemeDataControl1.merge(_avatarThemeDataControl2),
        _avatarThemeDataControl2);
  });
}

const _avatarThemeDataControl1 = AvatarThemeData();

final _avatarThemeDataControlMidLerp = AvatarThemeData(
  borderRadius: BorderRadius.circular(16),
  constraints: const BoxConstraints.tightFor(
    height: 33,
    width: 33,
  ),
);

final _avatarThemeDataControl2 = AvatarThemeData(
  borderRadius: BorderRadius.circular(12),
  constraints: const BoxConstraints.tightFor(
    height: 34,
    width: 34,
  ),
);
