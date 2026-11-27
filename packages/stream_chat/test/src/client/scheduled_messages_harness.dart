import 'package:clock/clock.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';
import '../utils.dart';
import '../ws/fake_chat_server.dart';

// Fixtures and a connected client shared by the scheduled message tests.

const testCid = 'messaging:general';

final testUser = User(id: 'test-user-id');
final testToken = testUserToken(testUser.id).rawValue;
// The error a request on a scheduled message that no longer exists gets.
final missingError = apiException(
  code: StreamErrorCode.notFound,
  message: 'UpdateScheduledMessage failed with error: "scheduled message a not found"',
  statusCode: 404,
);

// The error a request on a scheduled message quoting a deleted message gets.
final quoteDeletedError = apiException(
  code: StreamErrorCode.notFound,
  message: 'UpdateScheduledMessage failed with error: "Can\'t quote this message. The message has been deleted"',
  statusCode: 404,
);
const offline = StreamNetworkException(message: 'No connection');

// The codes of the errors that refuse a scheduled message request because the
// time is too far ahead, the message can no longer be changed, is being sent,
// was changed at the same time, was already sent, or was deleted.
const scheduledAtTooFarCode = 116;
const scheduledMessageNotEditableCode = 120;
const scheduledMessageSendingCode = 121;
const scheduledMessageConflictCode = 122;
const scheduledMessageAlreadySentCode = 123;
const scheduledMessageCanceledCode = 124;

// The error that refuses a scheduled message request with [code].
StreamApiException refusedWith(int code) {
  return apiException(code: StreamErrorCode(code), message: 'Refused');
}

// The time the scheduling tests run at, and the time they schedule for.
final now = DateTime.utc(2026, 10, 30, 12);
final scheduledAt = now.add(const Duration(days: 1));

// An error that refuses to schedule a message.
final rejected = apiException(message: 'Too many scheduled messages');

// The response for [message] scheduled as [scheduledMessage].
ScheduleMessageResponse scheduled(Message message, ScheduledMessage scheduledMessage) {
  return ScheduleMessageResponse()
    ..message = message
    ..scheduledMessage = scheduledMessage;
}

// The response for [message] when its time had passed and it was sent.
ScheduleMessageResponse sentRightAway(Message message) {
  return ScheduleMessageResponse()..message = message;
}

// A scheduled message in a channel other than [testCid].
final elsewhere = fakeScheduledMessage('there', cid: 'messaging:other', scheduledAt: DateTime.utc(2026, 11, 3));

// A scheduled message as the server returns it, or, unless [isOnServer], one
// never on the server, which has no server dates.
ScheduledMessage fakeScheduledMessage(
  String id, {
  String cid = testCid,
  DateTime? scheduledAt,
  DateTime? updatedAt,
  String text = 'Good morning',
  String? parentId,
  ScheduledMessageStatus status = ScheduledMessageStatus.scheduled,
  ScheduledMessageFailure? failure,
  bool isOnServer = true,
}) => ScheduledMessage(
  id: id,
  cid: cid,
  user: testUser,
  message: Message(id: id, text: text, parentId: parentId),
  scheduledAt: scheduledAt ?? DateTime.utc(2026, 11, 2, 9),
  status: status,
  failure: failure,
  createdAt: isOnServer ? DateTime.utc(2026, 10, 29) : null,
  updatedAt: isOnServer ? updatedAt ?? DateTime.utc(2026, 10, 29) : null,
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

// A query for the page after [next]; null is the first.
Matcher pageAfter(String? next) => isA<ScheduledMessagesQuery>().having((q) => q.next, 'next', next);

// Pumps the events the client emits for its own changes.
// Awaits [request], expecting it to throw [throws] when given.
Future<void> expectRequest(Future<Object?> request, Object? throws) async {
  if (throws == null) {
    await request;
    return;
  }

  await expectLater(request, throwsA(throws));
}

Future<void> settle() => pumpEventQueue();

// Gives each test a client connected as [testUser] on a fake API, with the
// scheduled messages loaded unless [loaded] is false.
ScheduledMessageHarness useScheduledMessageClient({bool loaded = true}) {
  final harness = ScheduledMessageHarness();

  setUpAll(() {
    registerFallbackValue(FakeMessage());
    registerFallbackValue(const PaginationParams());
    registerFallbackValue(const ScheduledMessagesQuery());
    registerFallbackValue(<ScheduledMessageStatus>[]);
    registerFallbackValue(DateTime.utc(2026));
    registerFallbackValue(<String, Object?>{});
  });

  setUp(() async {
    final api = harness.api = FakeChatApi();
    final fileUploader = harness.fileUploader = MockAttachmentFileUploader();
    harness.logs.clear();
    final client = harness.client = StreamChatClient(
      'test-api-key',
      defaultApi: FakeDefaultApi(),
      chatApi: api,
      wsProvider: FakeChatServer().connect,
      attachmentFileUploaderProvider: (_) => fileUploader,
      logConfig: StreamLogConfig(handler: _CapturingHandler(harness.logs.add)),
    );
    addTearDown(client.dispose);
    await client.connectUser(testUser, testToken);
    // The connection recovers once connected, before anything is loaded.
    await settle();
    if (loaded) await harness.loadAllScheduledMessages();
  });

  return harness;
}

// A client connected as [testUser] on a fake API, and the helpers that drive
// it. Each test gets a new client.
class ScheduledMessageHarness {
  late FakeChatApi api;
  late MockAttachmentFileUploader fileUploader;
  late StreamChatClient client;

  // The messages the client logged.
  final logs = <String>[];

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

  // The statuses the scheduled message [id] is listed with while [run] runs,
  // one for each copy of it listed, and null when it stops being listed. What
  // [run] throws is thrown, so a test of a failing request asserts it.
  Future<List<ScheduledMessageStatus?>> statusesDuring(
    Future<void> Function() run, {
    String id = 'a',
  }) async {
    ScheduledMessage? listed(List<ScheduledMessage> scheduledMessages) {
      return scheduledMessages.where((it) => it.id == id).firstOrNull;
    }

    final statuses = <ScheduledMessageStatus?>[];
    var last = listed(client.state.scheduledMessages);
    final subscription = client.state.scheduledMessagesStream.listen((scheduledMessages) {
      final copy = listed(scheduledMessages);
      if (copy == last) return;

      last = copy;
      statuses.add(copy?.status);
    });

    try {
      await run();
      await settle();
    } finally {
      await subscription.cancel();
    }

    return statuses;
  }

  // Makes the client hold [messages], as if each had just been scheduled.
  Future<void> hold(List<ScheduledMessage> messages) async {
    for (final message in messages) {
      await receive(EventType.scheduledMessageCreated, message);
    }
  }

  // Schedules [message] at [scheduledAt], then lets the events it emits
  // through.
  Future<ScheduleMessageResponse> schedule(Message message) async {
    try {
      return await withClock(
        Clock.fixed(now),
        () => client.scheduleMessage(message, 'general', 'messaging', scheduledAt: scheduledAt),
      );
    } finally {
      await settle();
    }
  }

  // Answers scheduling [message] at [scheduledAt] with [answer].
  void stubSchedule(Message message, Future<ScheduleMessageResponse> Function() answer) {
    when(
      () => api.scheduledMessages.scheduleMessage('general', 'messaging', message, scheduledAt),
    ).thenAnswer((_) => answer());
  }

  // Schedules [message] while the server can't be reached.
  Future<ScheduledMessage> scheduleUnreachable(Message message) async {
    stubSchedule(message, () async => throw offline);
    await expectLater(schedule(message), throwsA(offline));
    return client.state.scheduledMessages.single;
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
      () => api.scheduledMessages.queryScheduledMessages(any(that: pageAfter(next))),
    ).thenAnswer((_) => answer());
  }

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
}

// Hands the message of each record the client logs to [_onMessage].
class _CapturingHandler extends StreamLogHandler {
  const _CapturingHandler(this._onMessage);

  final void Function(String message) _onMessage;

  @override
  void handle(StreamLogRecord record) => _onMessage(record.message);
}
