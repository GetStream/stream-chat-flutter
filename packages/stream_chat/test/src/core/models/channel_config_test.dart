import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

void main() {
  ChannelConfig config({PushLevel? pushLevel, ChatPreferences? chatPreferences}) => ChannelConfig(
    automod: 'simple',
    commands: [Command(name: 'giphy', description: 'Post a random gif', args: '[text]', set: CommandSet.fun)],
    connectEvents: true,
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026, 2),
    maxMessageLength: 5000,
    messageRetention: 'infinite',
    mutes: true,
    reactions: true,
    readEvents: true,
    replies: true,
    search: true,
    polls: true,
    pushLevel: pushLevel,
    pushNotifications: false,
    chatPreferences: chatPreferences,
    typingEvents: true,
    uploads: true,
    urlEnrichment: true,
    skipLastMsgUpdateForSystemMsgs: true,
    userMessageReminders: true,
    markMessagesPending: true,
    deliveryEvents: true,
    sharedLocations: true,
  );

  test('ChannelConfig.toData writes every field under its stored key', () {
    expect(
      config(
        pushLevel: PushLevel.directMentions,
        chatPreferences: const ChatPreferences(directMentions: ChatPreferenceLevel.all),
      ).toData(),
      {
        'automod': 'simple',
        'commands': [
          {'name': 'giphy', 'description': 'Post a random gif', 'args': '[text]', 'set': 'fun_set'},
        ],
        'connect_events': true,
        'created_at': '2026-01-01T00:00:00.000Z',
        'updated_at': '2026-02-01T00:00:00.000Z',
        'max_message_length': 5000,
        'message_retention': 'infinite',
        'mutes': true,
        'reactions': true,
        'read_events': true,
        'replies': true,
        'search': true,
        'polls': true,
        'push_level': 'direct_mentions',
        'push_notifications': false,
        'chat_preferences': {'direct_mentions': 'all'},
        'typing_events': true,
        'uploads': true,
        'url_enrichment': true,
        'skip_last_msg_update_for_system_msgs': true,
        'user_message_reminders': true,
        'mark_messages_pending': true,
        'delivery_events': true,
        'shared_locations': true,
      },
    );
  });

  test('ChannelConfig.toData writes a missing push level and chat preferences as null', () {
    final data = config().toData();

    expect(data, containsPair('push_level', null));
    expect(data, containsPair('chat_preferences', null));
  });

  test('ChannelConfig.fromData reads back the configuration written by toData', () {
    final data = config(
      pushLevel: PushLevel.directMentions,
      chatPreferences: const ChatPreferences(directMentions: ChatPreferenceLevel.all),
    ).toData();

    expect(ChannelConfig.fromData(data).toData(), data);
  });
}
