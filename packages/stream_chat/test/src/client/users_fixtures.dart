import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';

// Fixtures shared by the user update client tests. The generated user carries a
// value in every field a [User] maps, none of them its default, so a field the
// mapping drops or swaps changes the compared user.

/// The user [updateUsersResponse] carries, as the client returns it.
User updatedUser() => User(
  id: 'user-id',
  role: 'admin',
  name: 'Updated Name',
  image: 'https://example.com/updated.png',
  createdAt: DateTime.utc(2026, 9, 1),
  updatedAt: DateTime.utc(2026, 9, 2),
  lastActive: DateTime.utc(2026, 9, 3),
  online: true,
  banned: true,
  banExpires: DateTime.utc(2026, 9, 4),
  teams: const ['team-a'],
  language: 'de',
  invisible: false,
  teamsRole: const {'team-a': 'member'},
  avgResponseTime: 42,
  custom: const {'favorite_color': 'green'},
  deactivatedAt: DateTime.utc(2026, 9, 5),
  deletedAt: DateTime.utc(2026, 9, 6),
  shadowBanned: false,
  blockedUserIds: const ['blocked-user'],
);

/// A generated response whose user sets every field.
api.UpdateUsersResponse updateUsersResponse() => api.UpdateUsersResponse(
  duration: '4.21ms',
  membershipDeletionTaskId: '',
  users: {
    'user-id': api.FullUserResponse(
      id: 'user-id',
      role: 'admin',
      name: 'Updated Name',
      image: 'https://example.com/updated.png',
      createdAt: DateTime.utc(2026, 9, 1),
      updatedAt: DateTime.utc(2026, 9, 2),
      lastActive: DateTime.utc(2026, 9, 3),
      online: true,
      banned: true,
      banExpires: DateTime.utc(2026, 9, 4),
      teams: const ['team-a'],
      language: 'de',
      invisible: false,
      teamsRole: const {'team-a': 'member'},
      avgResponseTime: 42,
      custom: const {'favorite_color': 'green'},
      deactivatedAt: DateTime.utc(2026, 9, 5),
      deletedAt: DateTime.utc(2026, 9, 6),
      shadowBanned: false,
      revokeTokensIssuedBefore: DateTime.utc(2026, 9, 7),
      blockedUserIds: const ['blocked-user'],
      channelMutes: const [],
      devices: const [],
      mutes: const [],
      latestHiddenChannels: const ['messaging:hidden'],
      totalUnreadCount: 5,
      unreadChannels: 2,
      unreadCount: 4,
      unreadThreads: 1,
    ),
  },
);
