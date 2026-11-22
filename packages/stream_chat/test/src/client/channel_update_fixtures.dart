import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import 'message_fixtures.dart';

/// The system message the channel update tests send.
final systemMessage = Message(id: 'system-id', text: 'Welcome');

/// The request [systemMessage] is sent as.
const systemMessageRequest = api.MessageRequest(
  id: 'system-id',
  text: 'Welcome',
  type: api.MessageRequestType.regular,
  attachments: [],
  mentionedUsers: [],
  silent: false,
  pinned: false,
  custom: {},
);

/// A generated update response with a channel, a member and a message.
api.UpdateChannelResponse generatedUpdateChannelResponse() => api.UpdateChannelResponse(
  duration: '0.01ms',
  channel: api.ChannelResponse(
    cid: 'messaging:general',
    id: 'general',
    type: 'messaging',
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026, 2),
    custom: const {'name': 'General'},
    disabled: false,
    frozen: false,
  ),
  members: [fakeChannelMemberResponse()],
  message: generatedLeafMessage('system-id'),
);

/// Expects [response] to be what [generatedUpdateChannelResponse] maps to.
void expectUpdateChannelResponse(UpdateChannelResponse? response) {
  expect(response!.duration, '0.01ms');
  expect(response.channel!.cid, 'messaging:general');
  expect(response.channel!.custom, {'name': 'General'});
  expect(response.channel!.createdAt, DateTime.utc(2026));
  expect(response.members, [fakeChannelMember()]);
  expect(response.message, expectedLeafMessage('system-id'));
}
