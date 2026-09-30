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

  test('Message.translate translates the name, description and options of its poll', () {
    final translated = Message(poll: _translatedPoll()).translate('nl').poll!;

    expect(translated.name, 'Favoriete kleur?');
    expect(translated.description, 'Kies er een');
    expect(translated.options.map((it) => it.text), ['Rood', 'Blue']);
  });

  test('Message.translate leaves the answers of its poll as written', () {
    final translated = Message(poll: _translatedPoll()).translate('nl').poll!;

    expect(translated.latestAnswers.single.answerText, 'I like yellow');
  });

  test('Message.translate leaves the own answers of its poll as written', () {
    final translated = Message(poll: _translatedPoll()).translate('nl').poll!;

    expect(translated.ownAnswers.single.answerText, 'I like yellow');
  });

  test('Message.translate keeps the ids the poll is acted on by', () {
    final translated = Message(poll: _translatedPoll()).translate('nl').poll!;

    expect(translated.id, 'poll-1');
    expect(translated.options.map((it) => it.id), ['option-1', 'option-2']);
    expect(translated.latestAnswers.single.id, 'answer-1');
  });

  test('Message.translate returns the same message for a null language', () {
    final message = Message(poll: _translatedPoll());

    expect(message.translate(null), same(message));
  });

  test('Message.translate returns the same message for an empty language', () {
    final message = Message(poll: _translatedPoll());

    expect(message.translate(''), same(message));
  });

  test('Message.translate translates the poll of a message without text', () {
    final message = Message(poll: _translatedPoll());

    expect(message.translate('nl').poll?.name, 'Favoriete kleur?');
  });

  test('Message.translate returns the same message when its poll has no translation', () {
    final message = Message(
      poll: Poll(
        name: 'Favourite colour?',
        options: const [PollOption(text: 'Red')],
      ),
    );

    expect(message.translate('nl'), same(message));
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
// option, with one answer that is the current user's own.
Poll _translatedPoll() => Poll(
  id: 'poll-1',
  name: 'Favourite colour?',
  nameI18n: const {'language': 'en', 'nl_text': 'Favoriete kleur?'},
  description: 'Pick one',
  descriptionI18n: const {'language': 'en', 'nl_text': 'Kies er een'},
  options: const [
    PollOption(id: 'option-1', text: 'Red', textI18n: {'language': 'en', 'nl_text': 'Rood'}),
    PollOption(id: 'option-2', text: 'Blue'),
  ],
  latestAnswers: [_translatedAnswer()],
  ownVotesAndAnswers: [_translatedAnswer()],
);
