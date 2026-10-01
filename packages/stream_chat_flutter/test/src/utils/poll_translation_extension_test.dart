import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test('Poll.translatedName returns the translation into the given language', () {
    final poll = Poll(
      name: 'Favourite colour?',
      nameI18n: const {'language': 'en', 'nl_text': 'Favoriete kleur?'},
      options: const [PollOption(text: 'Red')],
    );

    expect(poll.translatedName('nl'), 'Favoriete kleur?');
  });

  test('Poll.translatedName returns null for the language the poll was written in', () {
    // The server echoes a self-referential entry for the source language.
    final poll = Poll(
      name: 'Favourite colour?',
      nameI18n: const {'language': 'en', 'en_text': 'Favourite colour?'},
      options: const [PollOption(text: 'Red')],
    );

    expect(poll.translatedName('en'), isNull);
  });

  test('Poll.translatedName returns null for a null language', () {
    final poll = Poll(
      name: 'Favourite colour?',
      nameI18n: const {'language': 'en', 'nl_text': 'Favoriete kleur?'},
      options: const [PollOption(text: 'Red')],
    );

    expect(poll.translatedName(null), isNull);
  });

  test('Poll.translatedName returns null for an empty language', () {
    final poll = Poll(
      name: 'Favourite colour?',
      nameI18n: const {'language': 'en', 'nl_text': 'Favoriete kleur?'},
      options: const [PollOption(text: 'Red')],
    );

    expect(poll.translatedName(''), isNull);
  });

  test('Poll.originalLanguage falls back to the language of the options', () {
    final poll = Poll(
      name: 'Favourite colour?',
      options: const [
        PollOption(text: 'Red', textI18n: {'language': 'en', 'nl_text': 'Rood'}),
      ],
    );

    expect(poll.originalLanguage, 'en');
  });

  test('Poll.originalLanguage falls back to the language of the description', () {
    final poll = Poll(
      name: 'Lieblingsfarbe?',
      description: 'Wähle eine',
      descriptionI18n: const {'language': 'de', 'nl_text': 'Kies er een'},
      options: const [
        PollOption(text: 'Red', textI18n: {'language': 'en', 'nl_text': 'Rood'}),
      ],
    );

    expect(poll.originalLanguage, 'de');
  });

  test('Poll.hasTranslation is true when only an option is translated', () {
    final poll = Poll(
      name: 'Favourite colour?',
      options: const [
        PollOption(text: 'Red', textI18n: {'language': 'en', 'nl_text': 'Rood'}),
      ],
    );

    expect(poll.hasTranslation('nl'), isTrue);
  });

  test('Poll.hasTranslation ignores translated answers', () {
    final poll = Poll(
      name: 'Favourite colour?',
      options: const [PollOption(text: 'Red')],
      latestAnswers: [_translatedAnswer()],
    );

    expect(poll.hasTranslation('nl'), isFalse);
  });

  test('Message.translate leaves its poll as written', () {
    final message = Message(
      text: 'Hello',
      i18n: const {'language': 'en', 'nl_text': 'Hallo'},
      poll: _translatedPoll(),
    );

    expect(message.translate('nl').poll, same(message.poll));
  });

  test('PollVote.translatedAnswerText returns the translation into the given language', () {
    expect(_translatedAnswer().translatedAnswerText('nl'), 'Ik hou van geel');
  });

  test('Message.hasTranslation is true when only its poll is translated', () {
    final message = Message(poll: _translatedPoll());

    expect(message.hasTranslation('nl'), isTrue);
  });

  test('Message.hasTranslation is true when only its text is translated', () {
    final message = Message(text: 'Hello', i18n: const {'language': 'en', 'nl_text': 'Hallo'});

    expect(message.hasTranslation('nl'), isTrue);
  });

  test('Message.hasTranslation is false for the language the message and its poll were written in', () {
    final message = Message(
      text: 'Hello',
      i18n: const {'language': 'en', 'en_text': 'Hello', 'nl_text': 'Hallo'},
      poll: _translatedPoll(),
    );

    expect(message.hasTranslation('en'), isFalse);
  });
}

PollVote _translatedAnswer() => PollVote(
  id: 'answer-1',
  answerText: 'I like yellow',
  answerTextI18n: const {'language': 'en', 'nl_text': 'Ik hou van geel'},
);

// A poll written in English, translated into Dutch except for its second
// option.
Poll _translatedPoll() => Poll(
  name: 'Favourite colour?',
  nameI18n: const {'language': 'en', 'nl_text': 'Favoriete kleur?'},
  description: 'Pick one',
  descriptionI18n: const {'language': 'en', 'nl_text': 'Kies er een'},
  options: const [
    PollOption(text: 'Red', textI18n: {'language': 'en', 'nl_text': 'Rood'}),
    PollOption(text: 'Blue'),
  ],
);
