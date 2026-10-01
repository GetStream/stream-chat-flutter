import 'package:stream_chat/src/core/models/poll_option.dart';
import 'package:test/test.dart';

void main() {
  test('PollOption.toData writes the id, the text and the custom data under their stored keys', () {
    const option = PollOption(id: 'pizza', text: 'Pizza', extraData: {'color': 'red'});

    expect(option.toData(), {
      'id': 'pizza',
      'text': 'Pizza',
      'extra_data': {'color': 'red'},
    });
  });

  test('PollOption.toData leaves out an id that is null', () {
    const option = PollOption(text: 'Pizza');

    expect(option.toData().keys, unorderedEquals(['text', 'extra_data']));
  });

  test('PollOption.fromData reads back the option written by toData', () {
    const option = PollOption(id: 'pizza', text: 'Pizza', extraData: {'color': 'red'});

    expect(PollOption.fromData(option.toData()), option);
  });

  test('PollOption compares its custom data for equality', () {
    const option = PollOption(id: 'pizza', text: 'Pizza', extraData: {'color': 'red'});

    expect(option, isNot(option.copyWith(extraData: const {'color': 'green'})));
  });
}
