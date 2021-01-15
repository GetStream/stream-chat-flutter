import 'package:emojis/emoji.dart';
import 'package:characters/characters.dart';

final _emojis = Emoji.all();

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
    final regExp = RegExp('[0-9]');
    return characters.every((c) {
      return !regExp.hasMatch(c) &&
          _emojis.firstWhere(
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
