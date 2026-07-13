import 'package:stream_chat/src/core/util/string_sort_normalizer.dart';
import 'package:test/test.dart';

void main() {
  group('normalizeStringForSort', () {
    // Cases mirror the backend's `TestNormalizeName` at
    // https://github.com/GetStream/chat/blob/b92bf7991752a29e9f67b6ffe69b0bc529f5c48c/lib/combined/utils/text_test.go#L300-L341
    // so any drift between client and server for these inputs shows up here.
    group('backend TestNormalizeName parity', () {
      const cases = <(String description, String input, String expected)>[
        ('empty', '', ''),
        ('simple lowercase', 'hello', 'hello'),
        ('uppercase', 'HELLO', 'hello'),
        ('mixed case', 'Hello World', 'hello world'),

        // Backend guarantees NormalizeName never stems — same for us.
        ('no stem running', 'running', 'running'),
        ('no stem dogs', 'dogs', 'dogs'),

        // Diacritic folding.
        ('diacritics', 'résumé', 'resume'),
        ('turkish', 'Günaydın', 'gunaydin'),

        // Apostrophe handling: inner apostrophe preserved, only trailing/
        // leading U+0027 apostrophes are trimmed.
        ('apostrophe', "O'Brien", "o'brien"),

        // NormalizeName does NOT apply space normalization, so symbols pass
        // through.
        ('numbers and symbols preserved', '123!@#', '123!@#'),
      ];

      for (final (description, input, expected) in cases) {
        test(description, () {
          expect(normalizeStringForSort(input), expected);
        });
      }
    });

    // Vietnamese-preserved chars must survive the fold — the backend keeps
    // them out of `UnicodeNormalizationMap` via `IsVietnameseSpecificRune`.
    group('Vietnamese preservation', () {
      test('preserves đ / Đ (U+0110 / U+0111)', () {
        expect(normalizeStringForSort('Đăng'), 'đang'); // ă folds to a
        expect(normalizeStringForSort('đủ'), 'đủ'); // đ + ủ both Vietnamese
      });

      test('preserves ơ / Ơ, ư / Ư (horn letters)', () {
        expect(normalizeStringForSort('Ơn'), 'ơn');
        expect(normalizeStringForSort('Ư'), 'ư');
      });

      test('preserves the U+1EA0..U+1EF1 tone-marked block', () {
        // "Tiếng Việt rất đẹp và phức tạp" — the "và" folds (à not
        // Vietnamese-specific); everything else with tone marks stays.
        // Matches the backend's `NormalizeText` expected output for the
        // same input at text_test.go:152.
        expect(
          normalizeStringForSort('Tiếng Việt rất đẹp và phức tạp'),
          'tiếng việt rất đẹp va phức tạp',
        );
      });

      test('non-preserved diacritics on shared Latin letters still fold', () {
        // `ă` (U+0103, A-with-breve) is used in Vietnamese but is NOT in
        // the preserved ranges — backend folds it too.
        expect(normalizeStringForSort('Ăn'), 'an');
      });
    });

    group('ligatures and stroked letters (per diacritic package)', () {
      test('folds Ł, Ø, Æ, Þ', () {
        expect(normalizeStringForSort('Łukasz'), 'lukasz');
        expect(normalizeStringForSort('Øystein'), 'oystein');
        expect(normalizeStringForSort('Ægon'), 'aegon');
        expect(normalizeStringForSort('Þór'), 'thor');
      });

      test('strips decomposed combining marks (U+0300..U+036F)', () {
        // 'e' + U+0301 (combining acute) — should decompose to 'e'.
        expect(normalizeStringForSort('éowyn'), 'eowyn');
      });
    });

    // Backend's `Normalize` early-exits on Japanese (Hiragana / Katakana),
    // Thai, and Vietnamese-specific runes so they aren't touched by the
    // diacritic-fold or combining-mark strip. We mirror that.
    group('script preservation', () {
      test('preserves Hiragana', () {
        expect(normalizeStringForSort('こんにちは'), 'こんにちは');
      });

      test('preserves Katakana', () {
        expect(normalizeStringForSort('カタカナ'), 'カタカナ');
      });

      test('preserves Thai (including combining marks in the Thai block)', () {
        // Thai vowels ั / ี are combining marks (Unicode `Mn`) outside
        // U+0300..U+036F, so they'd survive `diacritic` regardless, but the
        // explicit preservation makes intent match backend.
        expect(normalizeStringForSort('สวัสดี'), 'สวัสดี');
      });

      test('mixed script: Latin folds, Japanese passes through', () {
        expect(normalizeStringForSort('Hi こんにちは'), 'hi こんにちは');
      });

      test('preserves Japanese combining sound marks (U+3099, U+309A)', () {
        // U+3099 and U+309A are `Mn` category codepoints that live inside
        // the Hiragana range — a decomposed `が` is `か` + U+3099. Without
        // the Japanese-range early exit, an aggressive combining-mark
        // strip would drop the sound mark and lose phonetic information.
        const kaVoiced = 'が'; // か + combining voiced sound mark
        const kaSemi = 'か゚'; // か + combining semi-voiced sound mark

        expect(normalizeStringForSort(kaVoiced), kaVoiced);
        expect(normalizeStringForSort(kaSemi), kaSemi);
      });
    });

    group('trimming', () {
      test('strips only U+0027 apostrophes from both ends', () {
        expect(normalizeStringForSort("'Ali"), 'ali');
        expect(normalizeStringForSort("Ali'"), 'ali');
        expect(normalizeStringForSort("'Ali'"), 'ali');
      });

      test('curly Unicode apostrophes (U+2019) are not trimmed', () {
        expect(normalizeStringForSort('’Ali'), '’ali');
      });

      test('trims surrounding whitespace after apostrophes', () {
        expect(normalizeStringForSort('  Ali  '), 'ali');
        // Backend runs `TrimApostrophe` before `TrimSpace` in a single pass,
        // so surrounding whitespace shields inner apostrophes: the outer
        // spaces prevent apostrophe trimming, then only the spaces get
        // stripped. Client mirrors this exactly.
        expect(normalizeStringForSort("  'Ali'  "), "'ali'");
      });
    });
  });
}
