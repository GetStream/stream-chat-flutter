import 'package:flutter_test/flutter_test.dart';

import '../pages/channel_list_page.dart';
import '../pages/message_list_page.dart';
import '../support/predefined_users.dart';
import '../support/widget_test_extensions.dart';

class UserRobot {
  UserRobot(this.tester);

  final WidgetTester tester;

  Future<UserRobot> login([
    UserCredentials user = PredefinedUsers.currentUser,
  ]) async {
    await tester.scrollToText(user.name);
    await tester.tapText(user.name);
    return this;
  }

  Future<UserRobot> openChannel({int index = 0}) async {
    final tile = find.byType(ChannelListPage.channelTile).at(index);
    await tester.waitUntilVisible(tile);
    await tester.tap(tile);
    await tester.pumpAndSettle();
    return this;
  }

  Future<UserRobot> sendMessage(String text) async {
    await tester.enterTextInField(MessageListPage.composer.inputField, text);
    await tester.tapByKey(MessageListPage.composer.sendButton);
    return this;
  }
}
