import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  final answer = PollVote(
    id: 'answer-1',
    answerText: 'I like yellow',
    answerTextI18n: const {'language': 'en', 'nl_text': 'Ik hou van geel'},
  );

  final poll = Poll(
    id: 'poll-1',
    name: 'Favourite colour?',
    nameI18n: const {'language': 'en', 'nl_text': 'Favoriete kleur?'},
    description: 'Pick one',
    descriptionI18n: const {'language': 'en', 'nl_text': 'Kies er een'},
    options: const [
      PollOption(id: 'option-1', text: 'Red', textI18n: {'language': 'en', 'nl_text': 'Rood'}),
      PollOption(id: 'option-2', text: 'Blue'),
    ],
    latestAnswers: [answer],
    ownVotesAndAnswers: [answer],
  );

  test('Poll.translatedName returns the translation into the given language', () {
    expect(poll.translatedName('nl'), 'Favoriete kleur?');
  });

  test('Poll.translatedName returns null for the language the poll was written in', () {
    // The server echoes a self-referential entry for the source language.
    final echoed = poll.copyWith(nameI18n: const {'language': 'en', 'en_text': 'Favourite colour?'});

    expect(echoed.translatedName('en'), isNull);
  });

  test('Poll.translatedName returns null for a null or empty language', () {
    expect(poll.translatedName(null), isNull);
    expect(poll.translatedName(''), isNull);
  });

  test('Poll.originalLanguage falls back to the language of the options', () {
    final optionsOnly = Poll(
      name: 'Favourite colour?',
      options: const [
        PollOption(text: 'Red', textI18n: {'language': 'en', 'nl_text': 'Rood'}),
      ],
    );

    expect(optionsOnly.originalLanguage, 'en');
  });

  test('Poll.hasTranslation is true when only an option is translated', () {
    final optionsOnly = Poll(
      name: 'Favourite colour?',
      options: const [
        PollOption(text: 'Red', textI18n: {'language': 'en', 'nl_text': 'Rood'}),
      ],
    );

    expect(optionsOnly.hasTranslation('nl'), isTrue);
  });

  test('Poll.hasTranslation ignores translated answers', () {
    final answersOnly = Poll(
      name: 'Favourite colour?',
      options: const [PollOption(text: 'Red')],
      latestAnswers: [answer],
    );

    expect(answersOnly.hasTranslation('nl'), isFalse);
  });

  test('Poll.translate replaces the name, description, options and answers with their translations', () {
    final translated = poll.translate('nl');

    expect(translated.name, 'Favoriete kleur?');
    expect(translated.description, 'Kies er een');
    expect(translated.options.map((it) => it.text), ['Rood', 'Blue']);
    expect(translated.latestAnswers.single.answerText, 'Ik hou van geel');
    expect(translated.ownAnswers.single.answerText, 'Ik hou van geel');
  });

  test('Poll.translate keeps the ids the poll is acted on by', () {
    final translated = poll.translate('nl');

    expect(translated.id, poll.id);
    expect(translated.options.map((it) => it.id), ['option-1', 'option-2']);
    expect(translated.latestAnswers.single.id, answer.id);
  });

  test('Poll.translate returns the same poll for a null or empty language', () {
    expect(poll.translate(null), same(poll));
    expect(poll.translate(''), same(poll));
  });

  test('PollOption.translate returns the same option when it has no translation', () {
    const option = PollOption(id: 'option-2', text: 'Blue');

    expect(option.translate('nl'), same(option));
  });

  test('PollVote.translatedAnswerText returns the translation into the given language', () {
    expect(answer.translatedAnswerText('nl'), 'Ik hou van geel');
  });

  test('Message.translate translates the poll of a message without text', () {
    final message = Message(poll: poll);

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
}
