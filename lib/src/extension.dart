import 'package:emojis/emoji.dart';
import 'package:characters/characters.dart';

final _emojis = Emoji.all();

//https://pub.dev/documentation/quiver/latest/quiver.strings/isDigit.html
bool isDigit(int rune) => rune ^ 0x30 <= 9;

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  //  Emojis guidelines
  //  1 to 3 emojis: big size with no text bubble.
  //  4+ emojis or emojis+text: standard size with text bubble.
  bool get isOnlyEmoji {
    final characters = this.trim().characters;
    if (characters.isEmpty) return false;
    if (characters.length > 3) return false;
    final containsDigits = characters.any((c) => isDigit(c.runes.first));
    if (containsDigits) return false;
    return characters.every((c) {
      return _emojis.firstWhere(
            (Emoji emoji) => emoji.char.contains(c),
            orElse: () => null,
          ) !=
          null;
    });
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
