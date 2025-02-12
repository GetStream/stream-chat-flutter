import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class NewGroupChatState extends ChangeNotifier {
  final users = <User>{};

  void addUser(User user) {
    if (!users.contains(user)) {
      users.add(user);
      notifyListeners();
    }
  }

  void removeUser(User user) {
    if (users.contains(user)) {
      users.remove(user);
      notifyListeners();
    }
  }

  void addOrRemoveUser(User user) {
    if (users.contains(user)) {
      users.remove(user);
    } else {
      users.add(user);
    }
    notifyListeners();
  }
}
