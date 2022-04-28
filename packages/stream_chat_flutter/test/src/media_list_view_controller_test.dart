import 'package:stream_chat_flutter/src/media_list_view_controller.dart';
import 'package:test/test.dart';

void main() {
  test('should update media', () {
    final controller = MediaListViewController();

    expect(controller.shouldUpdateMedia, false);

    controller.updateMedia(newValue: true);
    expect(controller.shouldUpdateMedia, true);

    controller.dispose();
  });

  test('should notify listeners on update media', () {
    final controller = MediaListViewController();

    var callCount = 0;
    void updateCallsSpy() => callCount++;

    controller.addListener(updateCallsSpy);

    expect(callCount, 0);
    controller.updateMedia(newValue: false);
    expect(controller.shouldUpdateMedia, false);
    expect(callCount, 1);

    controller.updateMedia(newValue: true);
    expect(controller.shouldUpdateMedia, true);
    expect(callCount, 2);

    controller
      ..removeListener(updateCallsSpy)
      ..dispose();
  });
}
