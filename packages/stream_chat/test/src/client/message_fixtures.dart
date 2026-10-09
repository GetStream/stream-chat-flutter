import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';

import '../fakes.dart';
import 'poll_fixtures.dart';

// Fixtures shared by the client tests whose responses carry messages. The generated message carries a value in every
// field, including the ones the SDK models leave out, so a field the mapping drops changes the compared object; its
// users are the minimal ones from fakes.dart. No two fields of a type hold the same value in all three messages (the
// message, the one it quotes and the leaf ones nested deeper), so a field mapped into the wrong slot changes it too.
// The quoted message carries minimal nested payloads that leave out their optional fields, to compare the defaults.
// Custom data includes keys named like the model's own fields, which the mapping leaves out.

/// A generated message with every field set, nesting one level of messages.
final generatedMessage = api.MessageResponse(
  attachments: [_generatedAttachment, _generatedImageAttachment],
  cid: 'messaging:general',
  command: 'giphy',
  createdAt: DateTime.utc(2026, 1, 1),
  custom: const {'priority': 'high', 'text': 'shadowed', 'html': 'shadowed'},
  deletedAt: DateTime.utc(2026, 1, 3),
  deletedForMe: false,
  deletedReplyCount: 2,
  draft: generatedDraft,
  html: '<p>Hello</p>',
  i18n: const {'fr_text': 'Bonjour', 'language': 'en'},
  id: 'message-id',
  imageLabels: const {
    'cat.png': ['cat'],
  },
  latestReactions: [_generatedReaction],
  member: const api.ChannelMemberPartialResponse(channelRole: 'channel_moderator', notificationsMuted: true),
  mentionedChannel: true,
  mentionedChannelMembers: const {
    'mo': api.ChannelMemberPartialResponse(
      channelRole: 'channel_member',
      custom: {'nickname': 'Mo'},
      notificationsMuted: false,
    ),
  },
  mentionedGroupIds: const ['group-id'],
  mentionedGroups: [
    api.UserGroupResponse(
      createdAt: DateTime.utc(2025, 1, 1),
      createdBy: 'creator',
      description: 'The group',
      id: 'group-id',
      members: [
        api.UserGroupMember(
          appPk: 1,
          createdAt: DateTime.utc(2025, 1, 2),
          groupId: 'group-id',
          isAdmin: true,
          userId: 'member',
        ),
      ],
      name: 'Group',
      teamId: 'blue',
      updatedAt: DateTime.utc(2025, 1, 3),
    ),
  ],
  mentionedHere: false,
  mentionedRoles: const ['admin'],
  mentionedUsers: [fakeUserResponse('mentioned')],
  messageTextUpdatedAt: DateTime.utc(2026, 1, 2, 12),
  mml: '<mml>Hello</mml>',
  moderation: const api.ModerationV2Response(
    action: 'remove',
    blocklistMatched: 'profanity',
    blocklistsMatched: ['profanity'],
    imageHarms: ['nudity'],
    originalText: 'Hullo',
    platformCircumvented: true,
    semanticFilterMatched: 'spam',
    textHarms: ['insult'],
  ),
  ownReactions: [_generatedOwnReaction],
  parentId: 'parent-id',
  pinExpires: DateTime.utc(2026, 2),
  pinned: true,
  pinnedAt: DateTime.utc(2026, 1, 4),
  pinnedBy: fakeUserResponse('pinner'),
  poll: generatedPoll,
  pollId: 'poll-id',
  quotedMessage: _generatedQuotedMessage,
  quotedMessageId: 'quoted-id',
  // The counts and scores the groups were built from; the groups take precedence.
  reactionCounts: const {'love': 1},
  reactionGroups: {
    'love': api.ReactionGroupResponse(
      count: 1,
      firstReactionAt: DateTime.utc(2026, 1, 5),
      lastReactionAt: DateTime.utc(2026, 1, 6),
      latestReactionsBy: [
        api.ReactionGroupUserResponse(createdAt: DateTime.utc(2026, 1, 6), userId: 'reactor'),
      ],
      sumScores: 2,
    ),
  },
  reactionScores: const {'love': 2},
  reminder: api.ReminderResponseData(
    channelCid: 'messaging:general',
    createdAt: DateTime.utc(2026, 1, 7),
    expiresAt: DateTime.utc(2027),
    messageId: 'message-id',
    remindAt: DateTime.utc(2026, 3),
    updatedAt: DateTime.utc(2026, 1, 8),
    userId: 'sender',
  ),
  replyCount: 3,
  restrictedVisibility: const ['luke'],
  shadowed: false,
  sharedLocation: api.SharedLocationResponseData(
    channel: _generatedChannel,
    channelCid: 'messaging:general',
    createdAt: DateTime.utc(2026, 1, 9),
    createdByDeviceId: 'device-id',
    endAt: DateTime.utc(2026, 1, 10),
    latitude: 1.5,
    longitude: 2.5,
    message: generatedLeafMessage('message-id'),
    messageId: 'message-id',
    updatedAt: DateTime.utc(2026, 1, 9, 12),
    userId: 'sender',
  ),
  showInChannel: true,
  silent: true,
  text: 'Hello',
  threadParticipants: [fakeUserResponse('participant')],
  type: 'deleted',
  updatedAt: DateTime.utc(2026, 1, 2),
  user: fakeUserResponse('sender'),
);

/// The [Message] that [generatedMessage] maps to, with the values the mapping creates read off [actual].
///
/// Every received attachment gets a new local id, and a channel compares by identity, so the attachment ids and the
/// channels of the shared location and the draft are taken from [actual]; check those channels' `cid` on their own.
Message expectedMessageLike(Message actual) => Message(
  id: 'message-id',
  text: 'Hello',
  type: 'deleted',
  attachments: [
    _expectedAttachment(actual.attachments.first.id),
    _expectedImageAttachment(actual.attachments.last.id),
  ],
  mentionedChannel: true,
  mentionedGroupIds: const ['group-id'],
  mentionedGroups: [
    UserGroup(
      createdAt: DateTime.utc(2025, 1, 1),
      createdBy: 'creator',
      description: 'The group',
      id: 'group-id',
      members: [
        UserGroupMember(createdAt: DateTime.utc(2025, 1, 2), groupId: 'group-id', isAdmin: true, userId: 'member'),
      ],
      name: 'Group',
      teamId: 'blue',
      updatedAt: DateTime.utc(2025, 1, 3),
    ),
  ],
  mentionedHere: false,
  mentionedRoles: const ['admin'],
  mentionedUsers: [fakeUser('mentioned')],
  silent: true,
  shadowed: false,
  reactionGroups: {
    'love': ReactionGroup(
      count: 1,
      sumScores: 2,
      firstReactionAt: DateTime.utc(2026, 1, 5),
      lastReactionAt: DateTime.utc(2026, 1, 6),
    ),
  },
  latestReactions: [_expectedReaction],
  ownReactions: [_expectedOwnReaction],
  parentId: 'parent-id',
  quotedMessage: _expectedQuotedMessage(actual.quotedMessage!.attachments.single.id),
  quotedMessageId: 'quoted-id',
  replyCount: 3,
  threadParticipants: [fakeUser('participant')],
  showInChannel: true,
  command: 'giphy',
  createdAt: DateTime.utc(2026, 1, 1),
  updatedAt: DateTime.utc(2026, 1, 2),
  deletedAt: DateTime.utc(2026, 1, 3),
  deletedForMe: false,
  messageTextUpdatedAt: DateTime.utc(2026, 1, 2, 12),
  user: fakeUser('sender'),
  pinned: true,
  pinnedAt: DateTime.utc(2026, 1, 4),
  pinExpires: DateTime.utc(2026, 2),
  pinnedBy: fakeUser('pinner'),
  poll: poll,
  pollId: 'poll-id',
  extraData: const {
    'priority': 'high',
    'cid': 'messaging:general',
  },
  // Deleted, but not only for the current user.
  state: MessageState.softDeleted,
  i18n: const {'fr_text': 'Bonjour', 'language': 'en'},
  restrictedVisibility: const ['luke'],
  moderation: const Moderation(
    action: ModerationAction.remove,
    originalText: 'Hullo',
    textHarms: ['insult'],
    imageHarms: ['nudity'],
    blocklistMatched: 'profanity',
    semanticFilterMatched: 'spam',
    platformCircumvented: true,
  ),
  draft: expectedDraft(
    attachmentId: actual.draft!.message.attachments.single.id,
    channel: actual.draft!.channel,
  ),
  reminder: MessageReminder(
    channelCid: 'messaging:general',
    messageId: 'message-id',
    userId: 'sender',
    remindAt: DateTime.utc(2026, 3),
    createdAt: DateTime.utc(2026, 1, 7),
    updatedAt: DateTime.utc(2026, 1, 8),
  ),
  channelRole: 'channel_moderator',
  sharedLocation: Location(
    channelCid: 'messaging:general',
    channel: actual.sharedLocation!.channel,
    messageId: 'message-id',
    message: expectedLeafMessage('message-id'),
    userId: 'sender',
    latitude: 1.5,
    longitude: 2.5,
    createdByDeviceId: 'device-id',
    endAt: DateTime.utc(2026, 1, 10),
    createdAt: DateTime.utc(2026, 1, 9),
    updatedAt: DateTime.utc(2026, 1, 9, 12),
  ),
  html: '<p>Hello</p>',
  mml: '<mml>Hello</mml>',
  imageLabels: const {
    'cat.png': ['cat'],
  },
  deletedReplyCount: 2,
);

final _generatedChannel = api.ChannelResponse(
  cid: 'messaging:general',
  createdAt: DateTime.utc(2026),
  custom: const {},
  disabled: false,
  frozen: false,
  id: 'general',
  type: 'messaging',
  updatedAt: DateTime.utc(2026),
);

// A link preview, read as one whatever type it was sent with.
final _generatedAttachment = api.Attachment(
  actions: const [api.Action(name: 'answer', style: 'primary', text: 'Send', type: 'button', value: 'yes')],
  assetUrl: 'https://example.com/asset.gif',
  authorIcon: 'https://example.com/author.png',
  authorLink: 'https://example.com/author',
  authorName: 'Author',
  color: '#ff0000',
  custom: const {'id': 'attachment-id', 'caption': 'A cat', 'title': 'shadowed'},
  fallback: 'A cat gif',
  fields: const [api.Field(short: true, title: 'Size', value: 'L')],
  footer: 'Footer',
  footerIcon: 'https://example.com/footer.png',
  giphy: api.Images(
    fixedHeight: _imageData('fixed_height'),
    fixedHeightDownsampled: _imageData('fixed_height_downsampled'),
    fixedHeightStill: _imageData('fixed_height_still'),
    fixedWidth: _imageData('fixed_width'),
    fixedWidthDownsampled: _imageData('fixed_width_downsampled'),
    fixedWidthStill: _imageData('fixed_width_still'),
    original: _imageData('original'),
  ),
  imageUrl: 'https://example.com/image.gif',
  ogScrapeUrl: 'https://example.com/scraped',
  originalHeight: 300,
  originalWidth: 400,
  pretext: 'Pretext',
  text: 'Attachment text',
  thumbUrl: 'https://example.com/thumb.gif',
  title: 'Cat',
  titleLink: 'https://example.com/cat',
  type: 'giphy',
);

Attachment _expectedAttachment(String id) => Attachment(
  id: id,
  type: 'giphy',
  titleLink: 'https://example.com/cat',
  title: 'Cat',
  thumbUrl: 'https://example.com/thumb.gif',
  text: 'Attachment text',
  pretext: 'Pretext',
  ogScrapeUrl: 'https://example.com/scraped',
  imageUrl: 'https://example.com/image.gif',
  footerIcon: 'https://example.com/footer.png',
  footer: 'Footer',
  fields: const [
    {'short': true, 'title': 'Size', 'value': 'L'},
  ],
  fallback: 'A cat gif',
  color: '#ff0000',
  authorName: 'Author',
  authorLink: 'https://example.com/author',
  authorIcon: 'https://example.com/author.png',
  assetUrl: 'https://example.com/asset.gif',
  actions: const [Action(name: 'answer', style: 'primary', text: 'Send', type: 'button', value: 'yes')],
  originalWidth: 400,
  originalHeight: 300,
  extraData: {
    'id': 'attachment-id',
    'caption': 'A cat',
    'giphy': {
      for (final rendition in const [
        'fixed_height',
        'fixed_height_downsampled',
        'fixed_height_still',
        'fixed_width',
        'fixed_width_downsampled',
        'fixed_width_still',
        'original',
      ])
        rendition: {
          'frames': '12',
          'height': '200',
          'size': '1024',
          'url': 'https://example.com/$rendition.gif',
          'width': '300',
        },
    },
  },
  uploadState: const UploadState.success(),
);

api.ImageData _imageData(String rendition) => api.ImageData(
  frames: '12',
  height: '200',
  size: '1024',
  url: 'https://example.com/$rendition.gif',
  width: '300',
);

const _generatedImageAttachment = api.Attachment(
  custom: {},
  imageUrl: 'https://example.com/photo.png',
  type: 'image',
);

Attachment _expectedImageAttachment(String id) => Attachment(
  id: id,
  type: 'image',
  imageUrl: 'https://example.com/photo.png',
  uploadState: const UploadState.success(),
);

final _generatedReaction = api.ReactionResponse(
  createdAt: DateTime.utc(2026, 1, 5),
  custom: const {'emoji_code': '❤️', 'mood': 'happy', 'type': 'shadowed'},
  messageId: 'message-id',
  score: 2,
  type: 'love',
  updatedAt: DateTime.utc(2026, 1, 6),
  user: fakeUserResponse('reactor'),
  userId: 'reactor-id',
);

final _expectedReaction = Reaction(
  messageId: 'message-id',
  type: 'love',
  user: fakeUser('reactor'),
  userId: 'reactor-id',
  score: 2,
  emojiCode: '❤️',
  createdAt: DateTime.utc(2026, 1, 5),
  updatedAt: DateTime.utc(2026, 1, 6),
  extraData: const {'mood': 'happy'},
);

final _generatedOwnReaction = api.ReactionResponse(
  createdAt: DateTime.utc(2026, 1, 4, 12),
  custom: const {},
  messageId: 'message-id',
  score: 1,
  type: 'wow',
  updatedAt: DateTime.utc(2026, 1, 4, 13),
  user: fakeUserResponse('owner'),
  userId: 'owner-id',
);

final _expectedOwnReaction = Reaction(
  messageId: 'message-id',
  type: 'wow',
  user: fakeUser('owner'),
  userId: 'owner-id',
  score: 1,
  createdAt: DateTime.utc(2026, 1, 4, 12),
  updatedAt: DateTime.utc(2026, 1, 4, 13),
);

/// A generated draft with every field set, as creating or querying drafts answers it.
final generatedDraft = api.DraftResponse(
  channel: _generatedChannel,
  channelCid: 'messaging:general',
  createdAt: DateTime.utc(2026, 1, 11),
  message: api.DraftPayloadResponse(
    attachments: const [
      api.Attachment(custom: {'caption': 'Notes'}, title: 'notes.pdf', type: 'file'),
    ],
    custom: const {'mood': 'busy', 'text': 'shadowed'},
    html: '<p>Draft</p>',
    id: 'draft-id',
    mentionedUsers: [fakeUserResponse('mentioned')],
    mml: '<mml>Draft</mml>',
    parentId: 'message-id',
    pollId: 'draft-poll-id',
    quotedMessageId: 'draft-quoted-id',
    showInChannel: true,
    silent: false,
    text: 'Draft',
    type: 'system',
  ),
  parentId: 'message-id',
  parentMessage: generatedLeafMessage('message-id'),
  quotedMessage: generatedLeafMessage('draft-quoted-id'),
);

/// The [Draft] that [generatedDraft] maps to.
///
/// The attachment gets a new local id and a channel compares by identity, so both are passed in; check the channel's
/// `cid` on its own.
Draft expectedDraft({required String attachmentId, required ChannelModel? channel}) => Draft(
  channelCid: 'messaging:general',
  channel: channel,
  createdAt: DateTime.utc(2026, 1, 11),
  message: DraftMessage(
    id: 'draft-id',
    text: 'Draft',
    type: 'system',
    attachments: [
      Attachment(
        id: attachmentId,
        type: 'file',
        title: 'notes.pdf',
        extraData: const {'caption': 'Notes'},
        uploadState: const UploadState.success(),
      ),
    ],
    parentId: 'message-id',
    showInChannel: true,
    mentionedUsers: [fakeUser('mentioned')],
    quotedMessageId: 'draft-quoted-id',
    silent: false,
    pollId: 'draft-poll-id',
    extraData: const {'mood': 'busy'},
    html: '<p>Draft</p>',
    mml: '<mml>Draft</mml>',
  ),
  parentId: 'message-id',
  parentMessage: expectedLeafMessage('message-id'),
  quotedMessage: expectedLeafMessage('draft-quoted-id'),
);

// A message with the fields the API always sends, a quoted message and poll id without the objects they point to, and
// minimal attachment, moderation, draft and shared location payloads that leave out their optional fields. Its custom data, and that of
// its attachment and draft, has keys named like fields left out.
final _generatedQuotedMessage = api.MessageResponse(
  attachments: const [
    api.Attachment(
      actions: [api.Action(name: 'reply', text: 'Reply', type: 'button')],
      custom: {'note': 'kept', 'giphy': 'shadowed', 'file': 'shadowed', 'upload_state': 'shadowed'},
      type: 'file',
    ),
  ],
  cid: 'messaging:general',
  createdAt: DateTime.utc(2025, 12, 2),
  custom: const {
    'tag': 'kept',
    'mml': 'shadowed',
    'image_labels': 'shadowed',
    'mentioned_channel_members': 'shadowed',
  },
  deletedReplyCount: 1,
  draft: api.DraftResponse(
    channelCid: 'messaging:general',
    createdAt: DateTime.utc(2025, 12, 3),
    message: const api.DraftPayloadResponse(
      custom: {'mood': 'calm', 'html': 'shadowed', 'mml': 'shadowed'},
      id: 'quoted-draft-id',
      text: 'Later',
    ),
  ),
  html: '<p>Quoted</p>',
  id: 'quoted-id',
  latestReactions: const [],
  mentionedChannel: false,
  mentionedHere: true,
  mentionedUsers: const [],
  moderation: const api.ModerationV2Response(action: 'shadow', originalText: 'Quote'),
  ownReactions: const [],
  pinned: false,
  pollId: 'quoted-poll-id',
  quotedMessageId: 'earlier-id',
  reactionCounts: const {},
  reactionScores: const {},
  replyCount: 0,
  restrictedVisibility: const [],
  shadowed: true,
  sharedLocation: api.SharedLocationResponseData(
    channelCid: 'messaging:general',
    createdAt: DateTime.utc(2025, 12, 4),
    createdByDeviceId: 'other-device-id',
    latitude: 3.5,
    longitude: 4.5,
    messageId: 'quoted-id',
    updatedAt: DateTime.utc(2025, 12, 5),
    userId: 'sender',
  ),
  silent: true,
  text: 'Quoted',
  type: 'regular',
  updatedAt: DateTime.utc(2025, 12, 2),
  user: fakeUserResponse('sender'),
);

Message _expectedQuotedMessage(String attachmentId) => Message(
  id: 'quoted-id',
  text: 'Quoted',
  attachments: [
    Attachment(
      id: attachmentId,
      type: 'file',
      actions: const [Action(name: 'reply', style: 'default', text: 'Reply', type: 'button')],
      extraData: const {'note': 'kept'},
      uploadState: const UploadState.success(),
    ),
  ],
  mentionedChannel: false,
  mentionedHere: true,
  silent: true,
  shadowed: true,
  latestReactions: const [],
  ownReactions: const [],
  quotedMessageId: 'earlier-id',
  createdAt: DateTime.utc(2025, 12, 2),
  updatedAt: DateTime.utc(2025, 12, 2),
  user: fakeUser('sender'),
  pollId: 'quoted-poll-id',
  extraData: const {'tag': 'kept', 'cid': 'messaging:general'},
  state: MessageState.sent,
  restrictedVisibility: const [],
  moderation: const Moderation(action: ModerationAction.shadow, originalText: 'Quote'),
  sharedLocation: Location(
    channelCid: 'messaging:general',
    messageId: 'quoted-id',
    userId: 'sender',
    latitude: 3.5,
    longitude: 4.5,
    createdByDeviceId: 'other-device-id',
    createdAt: DateTime.utc(2025, 12, 4),
    updatedAt: DateTime.utc(2025, 12, 5),
  ),
  draft: Draft(
    channelCid: 'messaging:general',
    createdAt: DateTime.utc(2025, 12, 3),
    message: DraftMessage(id: 'quoted-draft-id', text: 'Later', extraData: const {'mood': 'calm'}),
  ),
  html: '<p>Quoted</p>',
  deletedReplyCount: 1,
);

/// A generated thread with every field set, as querying or fetching threads answers it.
final generatedThread = api.ThreadStateResponse(
  activeParticipantCount: 2,
  channel: _generatedChannel,
  channelCid: 'messaging:general',
  createdAt: DateTime.utc(2026, 2, 1),
  createdBy: fakeUserResponse('creator'),
  createdByUserId: 'creator',
  custom: const {'topic': 'travel', 'title': 'shadowed'},
  deletedAt: DateTime.utc(2026, 2, 3),
  draft: generatedDraft,
  lastMessageAt: DateTime.utc(2026, 2, 4),
  latestReplies: [generatedLeafMessage('reply-id')],
  parentMessage: generatedLeafMessage('parent-id'),
  parentMessageId: 'parent-id',
  participantCount: 3,
  read: [
    api.ReadStateResponse(
      lastDeliveredAt: DateTime.utc(2026, 2, 5),
      lastDeliveredMessageId: 'delivered-id',
      lastRead: DateTime.utc(2026, 2, 6),
      lastReadMessageId: 'reply-id',
      unreadMessages: 1,
      user: fakeUserResponse('reader'),
    ),
  ],
  replyCount: 4,
  threadParticipants: [
    api.ThreadParticipant(
      channelCid: 'messaging:general',
      createdAt: DateTime.utc(2026, 2, 7),
      custom: const {'nickname': 'Rey'},
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

/// The [Thread] that [generatedThread] maps to, with the values the mapping creates read off [actual].
///
/// A channel compares by identity, so the thread's and its draft's channels are taken from [actual], as is the local
/// id of the draft's attachment; check those channels' `cid` on their own.
Thread expectedThreadLike(Thread actual) => Thread(
  activeParticipantCount: 2,
  channel: actual.channel,
  channelCid: 'messaging:general',
  createdAt: DateTime.utc(2026, 2, 1),
  createdBy: fakeUser('creator'),
  createdByUserId: 'creator',
  deletedAt: DateTime.utc(2026, 2, 3),
  draft: expectedDraft(
    attachmentId: actual.draft!.message.attachments.single.id,
    channel: actual.draft!.channel,
  ),
  lastMessageAt: DateTime.utc(2026, 2, 4),
  latestReplies: [expectedLeafMessage('reply-id')],
  parentMessage: expectedLeafMessage('parent-id'),
  parentMessageId: 'parent-id',
  participantCount: 3,
  read: [
    Read(
      lastDeliveredAt: DateTime.utc(2026, 2, 5),
      lastDeliveredMessageId: 'delivered-id',
      lastRead: DateTime.utc(2026, 2, 6),
      lastReadMessageId: 'reply-id',
      unreadMessages: 1,
      user: fakeUser('reader'),
    ),
  ],
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
  extraData: const {'topic': 'travel'},
);

/// A generated message with the id [id] and only the fields the API always sends.
api.MessageResponse generatedLeafMessage(String id) => api.MessageResponse(
  attachments: const [],
  cid: 'messaging:general',
  createdAt: DateTime.utc(2025, 12, 1),
  custom: const {},
  deletedReplyCount: 0,
  html: '<p>Earlier</p>',
  id: id,
  latestReactions: const [],
  mentionedChannel: false,
  mentionedHere: false,
  mentionedUsers: const [],
  ownReactions: const [],
  pinned: true,
  reactionCounts: const {},
  reactionScores: const {},
  replyCount: 0,
  restrictedVisibility: const [],
  shadowed: true,
  silent: false,
  text: 'Earlier',
  type: 'regular',
  updatedAt: DateTime.utc(2025, 12, 1),
  user: fakeUserResponse('sender'),
);

/// The [Message] that [generatedLeafMessage] maps to.
Message expectedLeafMessage(String id) => Message(
  id: id,
  text: 'Earlier',
  mentionedChannel: false,
  mentionedHere: false,
  pinned: true,
  shadowed: true,
  latestReactions: const [],
  ownReactions: const [],
  createdAt: DateTime.utc(2025, 12, 1),
  updatedAt: DateTime.utc(2025, 12, 1),
  user: fakeUser('sender'),
  extraData: const {'cid': 'messaging:general'},
  state: MessageState.sent,
  restrictedVisibility: const [],
  html: '<p>Earlier</p>',
  deletedReplyCount: 0,
);
