import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group('StreamMessagePreviewTextThemeData', () {
    const full = StreamMessagePreviewTextThemeData(
      draftPrefixStyle: TextStyle(color: Colors.blue),
      senderPrefixStyle: TextStyle(fontWeight: FontWeight.w600),
      deletedContentStyle: TextStyle(color: Colors.grey),
    );

    test('equality + hashCode', () {
      const identical = StreamMessagePreviewTextThemeData(
        draftPrefixStyle: TextStyle(color: Colors.blue),
        senderPrefixStyle: TextStyle(fontWeight: FontWeight.w600),
        deletedContentStyle: TextStyle(color: Colors.grey),
      );
      const different = StreamMessagePreviewTextThemeData(
        deletedContentStyle: TextStyle(color: Colors.red),
      );

      expect(full, identical);
      expect(full, isNot(different));
      expect(full.hashCode, identical.hashCode);
    });

    test('copyWith overrides only specified fields', () {
      final copied = full.copyWith(deletedContentStyle: const TextStyle(color: Colors.red));

      expect(copied.deletedContentStyle, const TextStyle(color: Colors.red));
      expect(copied.draftPrefixStyle, full.draftPrefixStyle);
      expect(copied.senderPrefixStyle, full.senderPrefixStyle);
    });

    test('merge layers the styles of other over this', () {
      const other = StreamMessagePreviewTextThemeData(
        deletedContentStyle: TextStyle(fontStyle: FontStyle.italic),
      );

      final merged = full.merge(other);

      expect(merged.deletedContentStyle?.color, Colors.grey);
      expect(merged.deletedContentStyle?.fontStyle, FontStyle.italic);
      expect(merged.draftPrefixStyle, full.draftPrefixStyle);
      expect(full.merge(null), full);
    });

    test('merge takes the icon size and color of other when set', () {
      const base = StreamMessagePreviewTextThemeData(iconSize: 16, iconColor: Colors.grey);

      final merged = base.merge(const StreamMessagePreviewTextThemeData(iconSize: 12));

      expect(merged.iconSize, 12);
      expect(merged.iconColor, Colors.grey);
    });

    test('lerp at boundaries returns endpoints; at 0.5 interpolates', () {
      const a = StreamMessagePreviewTextThemeData(deletedContentStyle: TextStyle(color: Colors.black));
      const b = StreamMessagePreviewTextThemeData(deletedContentStyle: TextStyle(color: Colors.white));

      expect(StreamMessagePreviewTextThemeData.lerp(a, b, 0)?.deletedContentStyle?.color, Colors.black);
      expect(StreamMessagePreviewTextThemeData.lerp(a, b, 1)?.deletedContentStyle?.color, Colors.white);
      expect(
        StreamMessagePreviewTextThemeData.lerp(a, b, 0.5)?.deletedContentStyle?.color,
        Color.lerp(Colors.black, Colors.white, 0.5),
      );
    });
  });
}
