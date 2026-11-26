import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';

import '../fakes.dart';
import 'message_fixtures.dart';

// Fixtures shared by the tests of the events the client returns. The values an
// event carries differ from each other and from the ones of the channel it
// nests, so a field mapped into the wrong slot changes the result.

/// The cid of the channel every fixture event belongs to.
const eventCid = 'livestream:event-room';

/// The id of the channel every fixture event belongs to.
const eventChannelId = 'event-room';

/// The type of the channel every fixture event belongs to.
const eventChannelType = 'livestream';

/// The member count every fixture event carries.
const eventMemberCount = 7;

/// The message count every fixture event carries.
const eventMessageCount = 42;

/// The time every fixture event happened at.
final eventCreatedAt = DateTime.utc(2026, 3, 4, 5, 6, 7, 8);

/// The time every fixture event was received at.
final eventReceivedAt = DateTime.utc(2026, 3, 4, 5, 6, 9);

/// The custom data every fixture event carries.
const eventCustom = <String, Object?>{'source': 'event', 'priority': 2};

/// The channel's custom data every fixture event carries.
const eventChannelCustom = <String, Object?>{'color': 'blue'};

/// The team every fixture event belongs to.
const eventTeam = 'blue-team';

/// A generated user with the id [id] and every field set.
api.UserResponseCommonFields generatedEventUser(String id) => api.UserResponseCommonFields(
  avgResponseTime: 120,
  banned: true,
  blockedUserIds: const ['blocked-id'],
  createdAt: DateTime.utc(2024, 1, 2),
  custom: const {'hobby': 'chess'},
  deactivatedAt: DateTime.utc(2024, 1, 3),
  deletedAt: DateTime.utc(2024, 1, 4),
  id: id,
  image: 'https://example.com/$id.png',
  language: 'fr',
  lastActive: DateTime.utc(2024, 1, 5),
  name: 'Name of $id',
  online: true,
  role: 'admin',
  teams: const ['red', 'blue'],
  teamsRole: const {'red': 'admin'},
  updatedAt: DateTime.utc(2024, 1, 6),
);

/// The [User] that [generatedEventUser] maps to.
User expectedEventUser(String id) => User(
  id: id,
  role: 'admin',
  name: 'Name of $id',
  image: 'https://example.com/$id.png',
  createdAt: DateTime.utc(2024, 1, 2),
  updatedAt: DateTime.utc(2024, 1, 6),
  lastActive: DateTime.utc(2024, 1, 5),
  online: true,
  banned: true,
  teams: const ['red', 'blue'],
  language: 'fr',
  teamsRole: const {'red': 'admin'},
  avgResponseTime: 120,
  custom: const {'hobby': 'chess'},
  deactivatedAt: DateTime.utc(2024, 1, 3),
  deletedAt: DateTime.utc(2024, 1, 4),
  blockedUserIds: const ['blocked-id'],
);

/// A generated user with the id [id], their privacy settings and every other
/// field set.
api.UserResponsePrivacyFields generatedEventPrivacyUser(String id) => api.UserResponsePrivacyFields(
  avgResponseTime: 90,
  banned: true,
  blockedUserIds: const ['other-blocked-id'],
  createdAt: DateTime.utc(2024, 3, 2),
  custom: const {'hobby': 'go'},
  deactivatedAt: DateTime.utc(2024, 3, 3),
  deletedAt: DateTime.utc(2024, 3, 4),
  id: id,
  image: 'https://example.com/$id.jpg',
  invisible: true,
  language: 'it',
  lastActive: DateTime.utc(2024, 3, 5),
  name: 'Private $id',
  online: true,
  privacySettings: generatedEventPrivacySettings,
  role: 'guest',
  teams: const ['green'],
  teamsRole: const {'green': 'member'},
  updatedAt: DateTime.utc(2024, 3, 6),
);

/// The [User] that [generatedEventPrivacyUser] maps to.
User expectedEventPrivacyUser(String id) => User(
  id: id,
  role: 'guest',
  name: 'Private $id',
  image: 'https://example.com/$id.jpg',
  createdAt: DateTime.utc(2024, 3, 2),
  updatedAt: DateTime.utc(2024, 3, 6),
  lastActive: DateTime.utc(2024, 3, 5),
  online: true,
  banned: true,
  teams: const ['green'],
  language: 'it',
  invisible: true,
  teamsRole: const {'green': 'member'},
  avgResponseTime: 90,
  custom: const {'hobby': 'go'},
  deactivatedAt: DateTime.utc(2024, 3, 3),
  deletedAt: DateTime.utc(2024, 3, 4),
  blockedUserIds: const ['other-blocked-id'],
);

/// Generated privacy settings with every setting given.
const generatedEventPrivacySettings = api.PrivacySettingsResponse(
  deliveryReceipts: api.DeliveryReceiptsResponse(enabled: false),
  readReceipts: api.ReadReceiptsResponse(enabled: true),
  typingIndicators: api.TypingIndicatorsResponse(enabled: false),
);

/// The [PrivacySettings] that [generatedEventPrivacySettings] maps to.
const expectedEventPrivacySettings = PrivacySettings(
  typingIndicators: TypingIndicators(enabled: false),
  readReceipts: ReadReceipts(enabled: true),
  deliveryReceipts: DeliveryReceipts(enabled: false),
);

/// A generated thread with every field set, as an event carries it.
final generatedEventThread = api.ThreadResponse(
  activeParticipantCount: 2,
  channel: generatedChannel,
  channelCid: 'messaging:general',
  createdAt: DateTime.utc(2026, 2, 1),
  createdBy: fakeUserResponse('creator'),
  createdByUserId: 'creator',
  custom: const {'topic': 'travel'},
  deletedAt: DateTime.utc(2026, 2, 3),
  lastMessageAt: DateTime.utc(2026, 2, 4),
  parentMessage: generatedLeafMessage('parent-id'),
  parentMessageId: 'parent-id',
  participantCount: 3,
  replyCount: 4,
  threadParticipants: [
    api.ThreadParticipant(
      channelCid: 'messaging:general',
      createdAt: DateTime.utc(2026, 2, 7),
      custom: const {},
      lastReadAt: DateTime.utc(2026, 2, 8),
      lastThreadMessageAt: DateTime.utc(2026, 2, 9),
      leftThreadAt: DateTime.utc(2026, 2, 10),
      threadId: 'parent-id',
      user: fakeUserResponse('participant'),
      userId: 'participant',
    ),
  ],
  title: 'Trip',
  updatedAt: DateTime.utc(2026, 2, 2),
);

/// The [Thread] that [generatedEventThread] maps to.
///
/// A channel compares by identity, so the thread's [channel] is passed in;
/// check its `cid` on its own.
Thread expectedEventThread({required ChannelModel? channel}) => Thread(
  activeParticipantCount: 2,
  channel: channel,
  channelCid: 'messaging:general',
  createdAt: DateTime.utc(2026, 2, 1),
  createdBy: fakeUser('creator'),
  createdByUserId: 'creator',
  deletedAt: DateTime.utc(2026, 2, 3),
  lastMessageAt: DateTime.utc(2026, 2, 4),
  parentMessage: expectedLeafMessage('parent-id'),
  parentMessageId: 'parent-id',
  participantCount: 3,
  replyCount: 4,
  threadParticipants: [
    ThreadParticipant(
      channelCid: 'messaging:general',
      createdAt: DateTime.utc(2026, 2, 7),
      lastReadAt: DateTime.utc(2026, 2, 8),
      lastThreadMessageAt: DateTime.utc(2026, 2, 9),
      leftThreadAt: DateTime.utc(2026, 2, 10),
      threadId: 'parent-id',
      user: fakeUser('participant'),
      userId: 'participant',
    ),
  ],
  title: 'Trip',
  updatedAt: DateTime.utc(2026, 2, 2),
  custom: const {'topic': 'travel'},
);

/// A generated reminder with every field set, as an event carries it.
final generatedEventReminder = api.ReminderResponseData(
  channel: generatedChannel,
  channelCid: 'messaging:general',
  createdAt: DateTime.utc(2026, 1, 7),
  expiresAt: DateTime.utc(2027),
  message: generatedLeafMessage('reminded-id'),
  messageId: 'reminded-id',
  remindAt: DateTime.utc(2026, 3),
  updatedAt: DateTime.utc(2026, 1, 8),
  user: fakeUserResponse('reminded'),
  userId: 'reminded',
);

/// The [MessageReminder] that [generatedEventReminder] maps to.
///
/// A channel compares by identity, so the reminder's [channel] is passed in;
/// check its `cid` on its own.
MessageReminder expectedEventReminder({required ChannelModel? channel}) => MessageReminder(
  channelCid: 'messaging:general',
  channel: channel,
  messageId: 'reminded-id',
  message: expectedLeafMessage('reminded-id'),
  userId: 'reminded',
  user: fakeUser('reminded'),
  remindAt: DateTime.utc(2026, 3),
  createdAt: DateTime.utc(2026, 1, 7),
  updatedAt: DateTime.utc(2026, 1, 8),
);

/// A generated scheduled message with every field set, as an event carries it.
final generatedEventScheduledMessage = api.ScheduledMessageResponse(
  channel: const api.ScheduledMessageChannelResponse(
    cid: 'messaging:general',
    id: 'general',
    image: 'https://example.com/general.png',
    name: 'General',
    type: 'messaging',
  ),
  cid: 'messaging:general',
  createdAt: DateTime.utc(2026, 1, 5),
  failureReason: const api.ScheduledMessageFailureReason('channel_frozen'),
  id: 'scheduled-id',
  message: const api.ScheduledMessageContentResponse(custom: {'color': 'red'}, text: 'Good morning'),
  scheduledAt: DateTime.utc(2026, 2),
  status: const api.ScheduledMessageStatus('failed'),
  updatedAt: DateTime.utc(2026, 1, 6),
  user: fakeUserResponse('scheduler'),
);

/// The [ScheduledMessage] that [generatedEventScheduledMessage] maps to.
///
/// Its message takes the id, the sender and the times of the scheduled
/// message.
ScheduledMessage expectedEventScheduledMessage() => ScheduledMessage(
  id: 'scheduled-id',
  cid: 'messaging:general',
  channel: ChannelModel(
    id: 'general',
    type: 'messaging',
    cid: 'messaging:general',
    custom: const {'name': 'General', 'image': 'https://example.com/general.png'},
  ),
  user: fakeUser('scheduler'),
  message: Message(
    id: 'scheduled-id',
    text: 'Good morning',
    user: fakeUser('scheduler'),
    createdAt: DateTime.utc(2026, 2),
    updatedAt: DateTime.utc(2026, 1, 6),
    custom: const {'color': 'red'},
    state: MessageState.sent,
  ),
  scheduledAt: DateTime.utc(2026, 2),
  status: ScheduledMessageStatus.failed,
  failureReason: const ScheduledMessageFailureReason('channel_frozen'),
  createdAt: DateTime.utc(2026, 1, 5),
  updatedAt: DateTime.utc(2026, 1, 6),
);
