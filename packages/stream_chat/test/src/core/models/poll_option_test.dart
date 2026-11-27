import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

void main() {
  test('PollOption.toData writes the id, the text, its translations and the custom data under their stored keys', () {
    const option = PollOption(id: 'pizza', text: 'Pizza', textI18n: {'it': 'Pizza'}, custom: {'color': 'red'});

    expect(option.toData(), {
      'id': 'pizza',
      'text': 'Pizza',
      'text_i18n': {'it': 'Pizza'},
      'custom': {'color': 'red'},
    });
  });

  test('PollOption.toData leaves out an id and translations that are null', () {
    const option = PollOption(text: 'Pizza');

    expect(option.toData().keys, unorderedEquals(['text', 'custom']));
  });

  test('PollOption.fromData reads back the option written by toData', () {
    const option = PollOption(id: 'pizza', text: 'Pizza', textI18n: {'it': 'Pizza'}, custom: {'color': 'red'});

    expect(PollOption.fromData(option.toData()), option);
  });

  test('PollOption compares its custom data for equality', () {
    const option = PollOption(id: 'pizza', text: 'Pizza', custom: {'color': 'red'});

    expect(option, isNot(option.copyWith(custom: const {'color': 'green'})));
  });

  test('PollOption.copyWith clears an id passed as null', () {
    const option = PollOption(id: 'pizza', text: 'Pizza');

    expect(option.copyWith(id: null).id, isNull);
  });

  test('PollOption.copyWith clears the translations passed as null', () {
    const option = PollOption(id: 'pizza', text: 'Pizza', textI18n: {'it': 'Pizza'});

    expect(option.copyWith(textI18n: null).textI18n, isNull);
  });
}
