import 'package:faker_dart/faker_dart.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

List<Message> generateConversation(
  int count, {
  List<User>? users,
  int? noOfUsers,
  int unreadCount = 0,
}) {
  assert(
      users == null || noOfUsers == null,
      'Only one of users or noOfUsers '
      'should be provided');
  assert(count > 0, 'Count should be greater than 0');
  assert(count > unreadCount, 'Count should be greater than unreadCount');

  users ??= generateUsers(noOfUsers!);

  final faker = Faker.instance;

  final messages = <Message>[];
  for (var i = 0; i < count - unreadCount; i++) {
    final user = users[i % users.length];
    messages.add(
      Message(
        id: faker.datatype.uuid(),
        text: faker.lorem.sentence(),
        user: user,
        createdAt: DateTime.now().subtract(Duration(minutes: i)),
      ),
    );
  }

  for (var i = 0; i < unreadCount; i++) {
    final user = users.where((element) => element is! OwnUser).first;
    messages.add(
      Message(
        id: faker.datatype.uuid(),
        text: faker.lorem.sentence(),
        user: user,
        createdAt:
            DateTime.now().subtract(Duration(minutes: i + count - unreadCount)),
      ),
    );
  }

  return messages;
}

List<User> generateUsers(int count) {
  final faker = Faker.instance;
  final users = <User>[];
  for (var i = 0; i < count; i++) {
    users.add(
      User(
        id: faker.datatype.uuid(),
        name: faker.name.fullName(),
      ),
    );
  }

  return users;
}
