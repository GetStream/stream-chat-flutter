import 'package:diacritic/diacritic.dart';
import 'package:meta/meta.dart';

const _maxAscii = 0x7F;
const _apostrophe = 0x0027;

// Japanese: Hiragana + Katakana blocks.
const _hiraganaStart = 0x3040;
const _hiraganaEnd = 0x309F;
const _katakanaStart = 0x30A0;
const _katakanaEnd = 0x30FF;

// Thai.
const _thaiStart = 0x0E00;
const _thaiEnd = 0x0E7F;

// Vietnamese: tone-marked Latin range + unique letters (Đ/đ, Ơ/ơ, Ư/ư).
const _vietnameseToneStart = 0x1EA0;
const _vietnameseToneEnd = 0x1EF1;
const _vietnameseDUpper = 0x0110;
const _vietnameseDLower = 0x0111;
const _vietnameseOHornUpper = 0x01A0;
const _vietnameseOHornLower = 0x01A1;
const _vietnameseUHornUpper = 0x01AF;
const _vietnameseUHornLower = 0x01B0;

/// Normalizes `value` into a client-side sort key that matches how the
/// backend sorts by name.
///
/// Applied in order:
///
/// 1. Fold Latin diacritics and ligatures — `é → e`, `Ł → l`, `Æ → ae`.
/// 2. Preserve Japanese, Thai, and Vietnamese-specific runes unchanged.
/// 3. Lowercase.
/// 4. Trim leading/trailing ASCII apostrophes (U+0027) then whitespace.
///
/// Mirrors backend [`NormalizeName`][ref].
///
/// [ref]: https://github.com/GetStream/chat/blob/b92bf7991752a29e9f67b6ffe69b0bc529f5c48c/lib/combined/utils/text.go#L88-L95
@internal
String normalizeStringForSort(String value) {
  if (value.isEmpty) return value;
  final folded = value.runes.map(_foldRune).join();
  return _trimApostropheEdges(folded.toLowerCase()).trim();
}

// Returns the sort form of `rune`. ASCII and preserved-script runes pass
// through unchanged; everything else routes through `removeDiacritics`.
String _foldRune(int rune) {
  if (rune <= _maxAscii) return String.fromCharCode(rune);
  if (_isJapaneseRune(rune)) return String.fromCharCode(rune);
  if (_isThaiRune(rune)) return String.fromCharCode(rune);
  if (_isVietnameseSpecificRune(rune)) return String.fromCharCode(rune);

  return removeDiacritics(String.fromCharCode(rune));
}

// Trims leading/trailing U+0027 apostrophes from `value`. Curly Unicode
// variants (U+2018, U+2019, U+201B) are intentionally not matched —
// mirrors the backend's `IsApostrophe` predicate.
String _trimApostropheEdges(String value) {
  var start = 0;
  var end = value.length;
  while (start < end && value.codeUnitAt(start) == _apostrophe) {
    start += 1;
  }
  while (end > start && value.codeUnitAt(end - 1) == _apostrophe) {
    end -= 1;
  }
  if (start == 0 && end == value.length) return value;

  return value.substring(start, end);
}

bool _isJapaneseRune(int rune) {
  if (rune >= _hiraganaStart && rune <= _hiraganaEnd) return true;
  if (rune >= _katakanaStart && rune <= _katakanaEnd) return true;

  return false;
}

bool _isThaiRune(int rune) {
  if (rune >= _thaiStart && rune <= _thaiEnd) return true;

  return false;
}

bool _isVietnameseSpecificRune(int rune) {
  if (rune >= _vietnameseToneStart && rune <= _vietnameseToneEnd) return true;
  if (rune == _vietnameseDLower || rune == _vietnameseDUpper) return true;
  if (rune == _vietnameseOHornLower || rune == _vietnameseOHornUpper) return true;
  if (rune == _vietnameseUHornLower || rune == _vietnameseUHornUpper) return true;

  return false;
}
