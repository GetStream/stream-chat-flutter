import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.SendMessageRequest(message: api.MessageRequest())));

  test('StreamChatClient.sendMessage sends the message and returns the sent message', () async {
    final message = Message(
      id: 'message-id',
      text: 'Hi @mo @channel @here @admins @Group',
      type: MessageType.regular,
      attachments: [
        Attachment(type: 'image', imageUrl: 'https://cdn.example.com/cat.png', custom: const {'size': 10}),
      ],
      mentionedUsers: [User(id: 'mo')],
      mentionedChannel: true,
      mentionedHere: false,
      mentionedRoles: const ['admins'],
      mentionedGroups: [
        UserGroup(id: 'group-id', name: 'Group', createdAt: DateTime.utc(2025), updatedAt: DateTime.utc(2025)),
      ],
      parentId: 'parent-id',
      quotedMessageId: 'quoted-id',
      showInChannel: true,
      silent: false,
      pinned: true,
      pinExpires: DateTime.utc(2026, 1, 1),
      pollId: 'poll-id',
      restrictedVisibility: const ['mo'],
      sharedLocation: Location(
        latitude: 1.5,
        longitude: 2.5,
        createdByDeviceId: 'device-id',
        endAt: DateTime.utc(2026, 2, 1),
      ),
      custom: const {'priority': 'high'},
    );
    final request = api.SendMessageRequest(
      message: api.MessageRequest(
        id: 'message-id',
        text: 'Hi @mo @channel @here @admins @Group',
        type: api.MessageRequestType.regular,
        attachments: const [
          api.Attachment(
            type: 'image',
            imageUrl: 'https://cdn.example.com/cat.png',
            actions: [],
            custom: {'size': 10},
          ),
        ],
        mentionedUsers: const ['mo'],
        mentionedChannel: true,
        mentionedHere: false,
        mentionedRoles: const ['admins'],
        mentionedGroupIds: const ['group-id'],
        parentId: 'parent-id',
        quotedMessageId: 'quoted-id',
        showInChannel: true,
        silent: false,
        pinned: true,
        pinExpires: DateTime.utc(2026, 1, 1),
        pollId: 'poll-id',
        restrictedVisibility: const ['mo'],
        sharedLocation: api.SharedLocation(
          latitude: 1.5,
          longitude: 2.5,
          createdByDeviceId: 'device-id',
          endAt: DateTime.utc(2026, 2, 1),
        ),
        custom: const {'priority': 'high'},
      ),
      skipPush: true,
      skipEnrichUrl: false,
    );

    final defaultApi = MockDefaultApi();
    when(() => defaultApi.sendMessage(type: 'messaging', id: 'general', sendMessageRequest: request)).thenAnswer(
      (_) async => Result.success(api.SendMessageResponse(duration: '0.01ms', message: generatedMessage)),
    );
    final client = _client(defaultApi);

    final res = await client.sendMessage(message, 'general', 'messaging', skipPush: true, skipEnrichUrl: false);

    final response = res.getOrNull()!;
    final sent = response.message;
    // A channel compares by identity, so it is checked on its own.
    expect(sent.sharedLocation?.channel?.cid, 'messaging:general');
    expect(sent.draft?.channel?.cid, 'messaging:general');
    expect(response, SendMessageResponse(duration: '0.01ms', message: expectedMessageLike(sent)));
    verify(() => defaultApi.sendMessage(type: 'messaging', id: 'general', sendMessageRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.sendMessage sends only the mentions the text still contains', () async {
    final message = Message(
      id: 'message-id',
      text: 'Hi @administrator',
      mentionedUsers: [User(id: 'mo')],
      mentionedChannel: true,
      mentionedHere: true,
      mentionedRoles: const ['admin'],
      mentionedGroups: [
        UserGroup(id: 'group-id', name: 'Group', createdAt: DateTime.utc(2025), updatedAt: DateTime.utc(2025)),
      ],
    );

    final request = await _sentRequest(message);

    expect(request.mentionedUsers, isEmpty);
    expect(request.mentionedChannel, isFalse);
    expect(request.mentionedHere, isFalse);
    expect(request.mentionedRoles, isEmpty);
    expect(request.mentionedGroupIds, isEmpty);
  });

  test('StreamChatClient.sendMessage writes the command into the text', () async {
    final message = Message(id: 'message-id', text: 'cats', command: 'giphy');

    final request = await _sentRequest(message);

    expect(request.text, '/giphy cats');
  });

  test('StreamChatClient.sendMessage writes a command without text as the command and null', () async {
    final message = Message(id: 'message-id', command: 'giphy');

    final request = await _sentRequest(message);

    expect(request.text, '/giphy null');
  });

  test('StreamChatClient.sendMessage sends the text as is when the command is empty', () async {
    final message = Message(id: 'message-id', text: 'cats', command: '');

    final request = await _sentRequest(message);

    expect(request.text, 'cats');
  });

  test('StreamChatClient.sendMessage sends no type other than regular or system', () async {
    final message = Message(id: 'message-id', text: 'Hi', type: MessageType.ephemeral);

    final request = await _sentRequest(message);

    expect(request.type, isNull);
  });

  test('StreamChatClient.sendMessage returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.sendMessage(
        type: 'messaging',
        id: 'general',
        sendMessageRequest: any(named: 'sendMessageRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.sendMessage(Message(id: 'message-id', text: 'Hi'), 'general', 'messaging');

    expect(res.exceptionOrNull(), error);
  });
}

// Sends [message] through a client and returns the message request it built.
Future<api.MessageRequest> _sentRequest(Message message) async {
  final defaultApi = MockDefaultApi();
  when(
    () => defaultApi.sendMessage(
      type: 'messaging',
      id: 'general',
      sendMessageRequest: any(named: 'sendMessageRequest'),
    ),
  ).thenAnswer((_) async => Result.success(api.SendMessageResponse(duration: '0.01ms', message: generatedMessage)));
  final client = _client(defaultApi);

  await client.sendMessage(message, 'general', 'messaging');

  final captured = verify(
    () => defaultApi.sendMessage(
      type: 'messaging',
      id: 'general',
      sendMessageRequest: captureAny(named: 'sendMessageRequest'),
    ),
  ).captured;
  return (captured.single as api.SendMessageRequest).message;
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
