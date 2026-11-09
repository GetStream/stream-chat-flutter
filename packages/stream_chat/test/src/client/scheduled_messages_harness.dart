import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/http/token.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';

// Fixtures and a connected client shared by the scheduled message tests.

const testCid = 'messaging:general';

final testUser = User(id: 'test-user-id');
final testToken = Token.development(testUser.id).rawValue;
final missingError = StreamChatNetworkError(ChatErrorCode.doesNotExist, statusCode: 404);
final offline = StreamChatNetworkError.raw(code: -1, message: 'No connection');

// The codes of the errors that refuse a scheduled message request because the
// message is being sent, was already sent, or was deleted.
const scheduledMessageSendingCode = 121;
const scheduledMessageAlreadySentCode = 123;
const scheduledMessageCanceledCode = 124;

// The number of scheduled messages the client asks for per page when it loads
// all of them.
const loadPageSize = 100;

// A scheduled message in a channel other than [testCid].
final elsewhere = fakeScheduledMessage(
  'there',
  cid: 'messaging:other',
  scheduledAt: DateTime.utc(2026, 11, 3),
);

ScheduledMessage fakeScheduledMessage(
  String id, {
  String cid = testCid,
  DateTime? scheduledAt,
  DateTime? updatedAt,
  String text = 'Good morning',
  String? parentId,
  ScheduledMessageStatus status = ScheduledMessageStatus.scheduled,
  ScheduledMessageFailureReason? failureReason,
}) => ScheduledMessage(
  id: id,
  cid: cid,
  user: testUser,
  message: Message(id: id, text: text, parentId: parentId),
  scheduledAt: scheduledAt ?? DateTime.utc(2026, 11, 2, 9),
  status: status,
  failureReason: failureReason,
  createdAt: DateTime.utc(2026, 10, 29),
  updatedAt: updatedAt ?? DateTime.utc(2026, 10, 29),
);

QueryScheduledMessagesResponse fakePage(List<ScheduledMessage> messages, {String? next}) {
  return QueryScheduledMessagesResponse()
    ..scheduledMessages = messages
    ..next = next;
}

UpdateScheduledMessageResponse fakeUpdate(ScheduledMessage message) {
  return UpdateScheduledMessageResponse()..scheduledMessage = message;
}

DeleteScheduledMessageResponse fakeDelete(ScheduledMessage message) {
  return DeleteScheduledMessageResponse()..scheduledMessage = message;
}

SendScheduledMessageNowResponse fakeSendNow(ScheduledMessage message) {
  return SendScheduledMessageNowResponse()..scheduledMessage = message;
}

List<String> idsOf(List<ScheduledMessage>? messages) => [for (final it in messages ?? const []) it.id];

late FakeChatApi api;
late StreamChatClient client;

// Gives each test a client connected as [testUser] on a fake API, with the
// scheduled messages loaded unless [loaded] is false.
void useScheduledMessageClient({bool loaded = true}) {
  setUpAll(() {
    registerFallbackValue(FakeMessage());
    registerFallbackValue(const PaginationParams());
    registerFallbackValue(const ScheduledMessagesQuery());
    registerFallbackValue(<ScheduledMessageStatus>[]);
    registerFallbackValue(DateTime.utc(2026));
    registerFallbackValue(<String, Object?>{});
  });

  setUp(() async {
    api = FakeChatApi();
    client = StreamChatClient('test-api-key', chatApi: api, ws: FakeWebSocket());
    when(() => api.general.getAppSettings()).thenAnswer(
      (_) async => GetAppSettingsResponse()..app = const AppSettings(name: 'test'),
    );
    addTearDown(client.dispose);
    await client.connectUser(testUser, testToken);
    // The connection recovers once connected, before anything is loaded.
    await settle();
    if (loaded) await loadAllScheduledMessages();
  });
}

// Loads an empty list, so the scheduled messages count as all loaded.
Future<void> loadAllScheduledMessages() async {
  stubQuery(fakePage(const []));
  await client.loadScheduledMessages();
  clearInteractions(api.scheduledMessages);
}

// Delivers [type] for [message] the way a web-socket event arrives.
Future<void> receive(String type, ScheduledMessage message) async {
  client.handleEvent(Event(type: type, cid: message.cid, scheduledMessage: message, isLocal: false));
  await settle();
}

// Makes the client hold [messages], as if each had just been scheduled.
Future<void> hold(List<ScheduledMessage> messages) async {
  for (final message in messages) {
    await receive(EventType.scheduledMessageCreated, message);
  }
}

// Answers every query with [response].
void stubQuery(QueryScheduledMessagesResponse response) {
  when(
    () => api.scheduledMessages.queryScheduledMessages(any()),
  ).thenAnswer((_) async => response);
}

// Answers a query for the page after [next] with [answer]; null is the first.
void stubPage(String? next, Future<QueryScheduledMessagesResponse> Function() answer) {
  when(
    () => api.scheduledMessages.queryScheduledMessages(ScheduledMessagesQuery(limit: loadPageSize, next: next)),
  ).thenAnswer((_) => answer());
}

// Pumps the events the client emits for its own changes.
Future<void> settle() => pumpEventQueue();

// Answers every query of the channel [testCid] with [channelState].
void stubQueryChannel(ChannelState channelState) {
  when(
    () => api.channel.queryChannel(
      'messaging',
      channelId: 'general',
      channelData: any(named: 'channelData'),
      state: any(named: 'state'),
      watch: any(named: 'watch'),
      presence: any(named: 'presence'),
      messagesPagination: any(named: 'messagesPagination'),
      membersPagination: any(named: 'membersPagination'),
      watchersPagination: any(named: 'watchersPagination'),
      includeScheduledMessages: any(named: 'includeScheduledMessages'),
    ),
  ).thenAnswer((_) async => channelState);
}

// Answers every channel list query with [channelStates].
void stubQueryChannels(List<ChannelState> channelStates) {
  when(
    () => api.channel.queryChannels(
      filter: any(named: 'filter'),
      state: any(named: 'state'),
      watch: any(named: 'watch'),
      presence: any(named: 'presence'),
      includeScheduledMessages: any(named: 'includeScheduledMessages'),
      paginationParams: any(named: 'paginationParams'),
    ),
  ).thenAnswer((_) async => QueryChannelsResponse()..channels = channelStates);
}
