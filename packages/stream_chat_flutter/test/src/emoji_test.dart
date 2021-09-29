import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/emoji/emoji.dart';

void main() {
  group('src/emoji', () {
    test('${Emoji.byShortName} should bring the correct emoji', () {
      final resultEmoji = Emoji.byShortName('smiley');
      expect(resultEmoji, _mockEmoji);
    });
  });
}

final _mockEmoji = Emoji(
    name: 'grinning face with big eyes',
    char: '\u{1F603}',
    shortName: 'smiley',
    emojiGroup: EmojiGroup.smileysEmotion,
    emojiSubgroup: EmojiSubgroup.faceSmiling,
    keywords: [
      'face',
      'mouth',
      'open',
      'smile',
      'uc6',
      'smiley',
      'happy',
      'silly',
      'laugh',
      'good',
      'smile',
      'teeth',
      'fun',
      'smileys',
      'mood',
      'emotion',
      'emotions',
      'emotional',
      'hooray',
      'cheek',
      'cheeky',
      'excited',
      'feliz',
      'heureux',
      'cheerful',
      'delighted',
      'ecstatic',
      'elated',
      'glad',
      'joy',
      'merry',
      'funny',
      'laughing',
      'lol',
      'rofl',
      'lmao',
      'lmfao',
      'hilarious',
      'ha',
      'haha',
      'chuckle',
      'comedy',
      'giggle',
      'hehe',
      'joyful',
      'laugh out loud',
      'rire',
      'tee hee',
      'jaja',
      'good job',
      'nice',
      'well done',
      'bravo',
      'congratulations',
      'congrats',
      'smiles',
      'dentist',
      ':-D',
      '=D'
    ]);
