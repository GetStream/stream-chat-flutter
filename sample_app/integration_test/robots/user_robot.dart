import 'package:patrol/patrol.dart';

import '../pages/channel_list_page.dart';
import '../pages/message_list_page.dart';
import '../support/predefined_users.dart';

class UserRobot {
  UserRobot(this.$);

  final PatrolIntegrationTester $;

  Future<UserRobot> login([
    UserCredentials user = PredefinedUsers.currentUser,
  ]) async {
    final entry = $(user.name);
    await entry.scrollTo();
    await entry.tap();
    return this;
  }

  Future<UserRobot> openChannel({int index = 0}) async {
    final tile = $(ChannelListPage.channelTile).at(index);
    await tile.waitUntilVisible();
    await tile.tap();
    return this;
  }

  Future<UserRobot> sendMessage(String text) async {
    await $(MessageListPage.composer.inputField).enterText(text);
    await $(MessageListPage.composer.sendButton).tap();
    return this;
  }
}
