import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// [MockClient] cannot use `when(() => client.state.currentUser)` — mocktail
/// will treat [ClientState.currentUser] as the value of [StreamChatClient.state].
/// Use this helper instead.
void stubMockClientCurrentUser(MockClient client, OwnUser user) {
  final clientState = MockClientState();
  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(user);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(user));
}

class MockClient extends Mock implements StreamChatClient {
  MockClient() {
    when(() => wsConnectionStatus).thenReturn(ConnectionStatus.connected);
    when(() => wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.connected));
    final mockState = MockClientState();
    when(() => state).thenReturn(mockState);
  }
}

class MockClientState extends Mock implements ClientState {
  MockClientState() {
    when(() => currentUserStream).thenAnswer((_) => Stream.value(OwnUser(id: 'user-id')));
    when(() => currentUser).thenReturn(OwnUser(id: 'user-id'));
  }
}

class MockChannel extends Mock implements Channel {
  MockChannel({
    this.type = 'test-channel-type',
    this.id = 'test-channel-id',
    this.ownCapabilities = const [
      ChannelCapability.sendMessage,
      ChannelCapability.uploadFile,
    ],
  });

  @override
  final String type;

  @override
  final String? id;

  @override
  String? get cid {
    if (id != null) return '$type:$id';
    return null;
  }

  @override
  final List<ChannelCapability> ownCapabilities;

  @override
  Stream<List<ChannelCapability>> get ownCapabilitiesStream {
    return Stream.value(ownCapabilities);
  }

  @override
  Future<bool> get initialized async => true;

  @override
  Future<ChannelState> watch({
    bool presence = false,
    PaginationParams? messagesPagination,
    PaginationParams? membersPagination,
    PaginationParams? watchersPagination,
  }) {
    return Future.value(const ChannelState());
  }

  @override
  // ignore: prefer_expression_function_bodies
  Future<void> keyStroke([String? parentId]) async {
    return;
  }

  @override
  Stream<Event> on([
    String? eventType,
    String? eventType2,
    String? eventType3,
    String? eventType4,
  ]) => const Stream.empty();
}

class MockChannelState extends Mock implements ChannelClientState {
  MockChannelState() {
    when(() => typingEvents).thenReturn({});
    when(() => typingEventsStream).thenAnswer((_) => Stream.value({}));
    when(() => unreadCount).thenReturn(0);
    when(() => unreadCountStream).thenAnswer((_) => Stream.value(0));
    when(() => isUpToDate).thenReturn(true);
    when(() => isUpToDateStream).thenAnswer((_) => Stream.value(true));
    when(() => read).thenReturn([]);
    when(() => readStream).thenAnswer((_) => Stream.value([]));
    when(() => currentUserReadStream).thenAnswer((_) => Stream.value(null));
    when(() => draft).thenReturn(null);
    when(() => draftStream).thenAnswer((_) => Stream.value(null));
    when(() => pinnedMessages).thenReturn([]);
    when(() => pinnedMessagesStream).thenAnswer((_) => Stream.value([]));
    when(() => channelState).thenReturn(const ChannelState());
    when(() => channelStateStream).thenAnswer((_) => Stream.value(const ChannelState()));
  }
}

/// Sets up a [MockChannel] with all stubs required by [StreamMessageComposer].
void setupMockChannel({
  required MockClient client,
  required MockClientState clientState,
  required MockChannel channel,
  required MockChannelState channelState,
  String channelName = 'test',
  List<Message> messages = const [],
  List<Member> members = const [],
}) {
  final allMembers = members.isNotEmpty
      ? members
      : [
          Member(
            userId: 'user-id',
            user: User(
              id: 'user-id',
              image: 'https://docs.fixture/avatar/user-id.png',
            ),
          ),
        ];

  when(() => client.state).thenReturn(clientState);
  when(() => channel.lastMessageAt).thenReturn(DateTime.parse('2020-06-22 12:00:00'));
  when(() => channel.lastMessageAtStream).thenAnswer((_) => Stream.value(DateTime.parse('2020-06-22 12:00:00')));
  when(() => channel.state).thenReturn(channelState);
  when(() => channel.client).thenReturn(client);
  when(channel.getRemainingCooldown).thenReturn(0);
  when(() => channel.isDistinct).thenReturn(false);
  when(() => channel.isMuted).thenReturn(false);
  when(() => channel.isMutedStream).thenAnswer((_) => Stream.value(false));
  when(() => channel.isPinned).thenReturn(false);
  when(() => channel.isPinnedStream).thenAnswer((_) => Stream.value(false));
  when(() => channel.extraDataStream).thenAnswer((_) => Stream.value({'name': channelName}));
  when(() => channel.extraData).thenReturn({'name': channelName});
  when(() => channel.name).thenReturn(channelName);
  when(() => channel.nameStream).thenAnswer((_) => Stream.value(channelName));
  final channelImage = 'https://docs.fixture/avatar/${channel.id}.png';
  when(() => channel.image).thenReturn(channelImage);
  when(() => channel.imageStream).thenAnswer((_) => Stream.value(channelImage));
  when(() => channelState.membersStream).thenAnswer((_) => Stream.value(allMembers));
  when(() => channelState.members).thenReturn(allMembers);
  when(() => channelState.messages).thenReturn(messages);
  when(() => channelState.messagesStream).thenAnswer((_) => Stream.value(messages));
}

/// Creates a [MockChannel] pre-configured with fake data for list views.
MockChannel fakeChannel({
  required MockClient client,
  String id = 'test-channel-id',
  String name = 'General',
  List<Message> messages = const [],
  int unreadCount = 0,
}) {
  final channel = MockChannel(type: 'messaging', id: id);
  final channelState = MockChannelState();
  final clientState = MockClientState();

  setupMockChannel(
    client: client,
    clientState: clientState,
    channel: channel,
    channelState: channelState,
    channelName: name,
    messages: messages,
  );

  when(() => channelState.unreadCount).thenReturn(unreadCount);
  when(() => channelState.unreadCountStream).thenAnswer((_) => Stream.value(unreadCount));

  return channel;
}
