import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  test('Single conversation', () async {
    final inputFinder = find.byValueKey('messageInputText');
    final sendButtonFinder = find.byValueKey('sendButton');
    final messageListViewFinder = find.byValueKey('messageListView');

    FlutterDriver driver = await FlutterDriver.connect();
    // Connect to the Flutter driver before running any tests.

    await sleep(Duration(seconds: 5));

    await driver.waitFor(inputFinder);

    await driver.tap(inputFinder);

    await sleep(Duration(seconds: 1));

    await driver.enterText('hey');

    await sleep(Duration(seconds: 1));

    await driver.tap(sendButtonFinder);

    await sleep(Duration(seconds: 1));

    await driver.scroll(
      messageListViewFinder,
      0,
      2000,
      Duration(seconds: 1),
    );

    await sleep(Duration(seconds: 1));

    // Close the connection to the driver after the tests have completed.
    await sleep(Duration(seconds: 5));
    if (driver != null) {
      await driver.close();
    }
  });
}
