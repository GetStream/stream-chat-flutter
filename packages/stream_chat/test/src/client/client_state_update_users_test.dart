import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';

void main() {
  test('StreamChatClient does not emit users for an event without a user', () async {
    final client = _client();
    final emitted = _usersEmittedAfterNow(client);

    client.handleEvent(Event(type: 'call.session_participant_count_updated'));
    await pumpEventQueue();

    expect(emitted, isEmpty);
  });

  test('ClientState.updateUser does not emit users for a user stored with the same data', () async {
    final client = _client();
    final user = User(id: 'u1', name: 'Alice', updatedAt: DateTime.utc(2026));
    client.state.updateUser(user);
    final emitted = _usersEmittedAfterNow(client);

    client.state.updateUser(user.copyWith());
    await pumpEventQueue();

    expect(emitted, isEmpty);
  });

  test('ClientState.updateUsers merges a changed user into the stored users', () {
    final client = _client();
    final alice = User(id: 'u1', name: 'Alice');
    final bob = User(id: 'u2', name: 'Bob');
    client.state.updateUsers([alice, bob]);

    final renamedAlice = alice.copyWith(name: 'Alicia');
    client.state.updateUsers([renamedAlice, bob]);

    expect(client.state.users, {'u1': renamedAlice, 'u2': bob});
  });

  test('ClientState.updateUser does not emit users for a user whose only change is updatedAt', () async {
    final client = _client();
    final user = User(id: 'u1', updatedAt: DateTime.utc(2026));
    client.state.updateUser(user);
    final emitted = _usersEmittedAfterNow(client);

    client.state.updateUser(user.copyWith(updatedAt: DateTime.utc(2026, 2)));
    await pumpEventQueue();

    expect(emitted, isEmpty);
  });

  test('ClientState.updateUser stores a user whose only change is createdAt', () {
    final client = _client();
    final user = User(id: 'u1', createdAt: DateTime.utc(2026));
    client.state.updateUser(user);

    client.state.updateUser(user.copyWith(createdAt: DateTime.utc(2026, 2)));

    expect(client.state.users['u1']?.createdAt, DateTime.utc(2026, 2));
  });

  test('ClientState.updateUsers keeps the last copy of a user listed more than once', () {
    final client = _client();
    final stored = User(id: 'u1', name: 'Alice');
    client.state.updateUser(stored);

    client.state.updateUsers([stored.copyWith(name: 'Alicia'), stored]);

    expect(client.state.users['u1'], stored);
  });

  test('ClientState.updateUsers does not emit users when the last copy of a user is the stored one', () async {
    final client = _client();
    final stored = User(id: 'u1', name: 'Alice');
    client.state.updateUser(stored);
    final emitted = _usersEmittedAfterNow(client);

    client.state.updateUsers([stored.copyWith(name: 'Alicia'), stored]);
    await pumpEventQueue();

    expect(emitted, isEmpty);
  });

  test('ClientState.updateUsers keeps the order of stored users and adds new ones in the order listed', () {
    final client = _client();
    final alice = User(id: 'u1', name: 'Alice');
    final bob = User(id: 'u2', name: 'Bob');
    client.state.updateUsers([alice, bob]);

    client.state.updateUsers([
      User(id: 'u3', name: 'Carol'),
      bob.copyWith(name: 'Robert'),
      User(id: 'u4', name: 'Dave'),
      alice.copyWith(name: 'Alicia'),
    ]);

    expect(client.state.users.keys, ['u1', 'u2', 'u3', 'u4']);
  });
}

StreamChatClient _client() {
  final client = StreamChatClient('test-api-key', chatApi: FakeChatApi(), defaultApi: FakeDefaultApi());
  addTearDown(client.dispose);
  return client;
}

// The users [client] emits from now on.
//
// The current value, which is replayed to new listeners, is left out.
List<Map<String, User>> _usersEmittedAfterNow(StreamChatClient client) {
  final emitted = <Map<String, User>>[];
  final subscription = client.state.usersStream.skip(1).listen(emitted.add);
  addTearDown(subscription.cancel);
  return emitted;
}
