import 'package:characters/characters.dart';
import 'package:emojis/emoji.dart';
import 'package:file_picker/file_picker.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

final _emojis = Emoji.all();

/// String extension
extension StringExtension on String {
  /// Returns the capitalized string
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Returns whether the string contains only emoji's or not.
  ///
  ///  Emojis guidelines
  ///  1 to 3 emojis: big size with no text bubble.
  ///  4+ emojis or emojis+text: standard size with text bubble.
  bool get isOnlyEmoji {
    final characters = trim().characters;
    if (characters.isEmpty) return false;
    if (characters.length > 3) return false;
    return characters.every((c) => _emojis.map((e) => e.char).contains(c));
  }
}

/// List extension
extension IterableX<T> on Iterable<T> {
  /// Insert any item<T> inBetween the list items
  List<T> insertBetween(T item) => expand((e) sync* {
        yield item;
        yield e;
      }).skip(1).toList(growable: false);
}

///
extension PlatformFileX on PlatformFile {
  ///
  AttachmentFile get toAttachmentFile => AttachmentFile(
        path: path,
        name: name,
        bytes: bytes,
        size: size,
      );
}
