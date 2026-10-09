import 'package:stream_chat/src/core/models/action.dart';
import 'package:test/test.dart';

void main() {
  test('Action compares by value', () {
    const action = Action(name: 'image_action', style: 'primary', text: 'Send', type: 'button', value: 'send');

    expect(
      action,
      const Action(name: 'image_action', style: 'primary', text: 'Send', type: 'button', value: 'send'),
    );
    expect(action, isNot(action.copyWith(value: 'shuffle')));
  });
}
