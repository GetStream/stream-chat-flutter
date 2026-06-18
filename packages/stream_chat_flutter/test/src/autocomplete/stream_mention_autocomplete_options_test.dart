import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';
import '../mocks.dart';

typedef _MentionTestMocks = ({MockClient client, MockChannel channel});

_MentionTestMocks _setupMocks({
  List<ChannelCapability> ownCapabilities = const [],
  List<Member> members = const [],
  List<User> watchers = const [],
  String? team,
  int? memberCount,
}) {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel(ownCapabilities: ownCapabilities);
  final channelState = MockChannelState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
  when(() => channel.state).thenReturn(channelState);
  when(() => channel.client).thenReturn(client);
  when(() => channel.team).thenReturn(team);
  // Default to "all members cached" so tests that don't care about the gating
  // exercise the local-search branch.
  when(() => channel.memberCount).thenReturn(memberCount ?? members.length);
  when(() => channelState.members).thenReturn(members);
  when(() => channelState.watchers).thenReturn(watchers);

  return (client: client, channel: channel);
}

Widget _buildMentionOptionsBody({
  required MockClient client,
  required MockChannel channel,
  String query = '',
  bool mentionAllAppUsers = false,
}) {
  return StreamChatConfiguration(
    data: StreamChatConfigurationData(),
    child: StreamChatTheme(
      data: StreamChatThemeData(),
      child: Scaffold(
        body: StreamMentionAutocompleteOptions(
          query: query,
          channel: channel,
          client: mentionAllAppUsers ? client : null,
          mentionAllAppUsers: mentionAllAppUsers,
        ),
      ),
    ),
  );
}

Future<void> _pumpMentionOptions(
  WidgetTester tester, {
  required MockClient client,
  required MockChannel channel,
  String query = '',
  bool mentionAllAppUsers = false,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: _buildMentionOptionsBody(
        client: client,
        channel: channel,
        query: query,
        mentionAllAppUsers: mentionAllAppUsers,
      ),
    ),
  );

  await tester.pumpAndSettle();
}

void main() {
  group('broadcasts', () {
    const bothBroadcastCapabilities = [
      ChannelCapability.notifyChannel,
      ChannelCapability.notifyHere,
    ];

    testWidgets(
      'empty query shows both @channel and @here when both capabilities are set',
      (tester) async {
        final mocks = _setupMocks(ownCapabilities: bothBroadcastCapabilities);

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: '',
        );

        expect(find.text('@channel'), findsOneWidget);
        expect(find.text('@here'), findsOneWidget);
      },
    );

    testWidgets(
      'query "c" shows @channel only',
      (tester) async {
        final mocks = _setupMocks(ownCapabilities: bothBroadcastCapabilities);

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'c',
        );

        expect(find.text('@channel'), findsOneWidget);
        expect(find.text('@here'), findsNothing);
      },
    );

    testWidgets(
      'query "h" shows @here only',
      (tester) async {
        final mocks = _setupMocks(ownCapabilities: bothBroadcastCapabilities);

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'h',
        );

        expect(find.text('@here'), findsOneWidget);
        expect(find.text('@channel'), findsNothing);
      },
    );

    testWidgets(
      'query "channel" shows @channel only',
      (tester) async {
        final mocks = _setupMocks(ownCapabilities: bothBroadcastCapabilities);

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'channel',
        );

        expect(find.text('@channel'), findsOneWidget);
        expect(find.text('@here'), findsNothing);
      },
    );

    testWidgets(
      'query "here" shows @here only',
      (tester) async {
        final mocks = _setupMocks(ownCapabilities: bothBroadcastCapabilities);

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'here',
        );

        expect(find.text('@here'), findsOneWidget);
        expect(find.text('@channel'), findsNothing);
      },
    );

    testWidgets(
      'query "HE" matches @here case-insensitively',
      (tester) async {
        final mocks = _setupMocks(ownCapabilities: bothBroadcastCapabilities);

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'HE',
        );

        expect(find.text('@here'), findsOneWidget);
        expect(find.text('@channel'), findsNothing);
      },
    );

    testWidgets(
      'query "xyz" shows neither broadcast',
      (tester) async {
        final mocks = _setupMocks(ownCapabilities: bothBroadcastCapabilities);

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'xyz',
        );

        expect(find.text('@channel'), findsNothing);
        expect(find.text('@here'), findsNothing);
      },
    );

    testWidgets(
      'query "channels" (longer than "channel") shows neither broadcast',
      (tester) async {
        final mocks = _setupMocks(ownCapabilities: bothBroadcastCapabilities);

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'channels',
        );

        expect(find.text('@channel'), findsNothing);
        expect(find.text('@here'), findsNothing);
      },
    );

    testWidgets(
      'missing notifyChannel capability hides @channel even with empty query',
      (tester) async {
        final mocks = _setupMocks(
          ownCapabilities: const [ChannelCapability.notifyHere],
        );

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: '',
        );

        expect(find.text('@channel'), findsNothing);
        expect(find.text('@here'), findsOneWidget);
      },
    );

    testWidgets(
      'missing notifyHere capability hides @here even with empty query',
      (tester) async {
        final mocks = _setupMocks(
          ownCapabilities: const [ChannelCapability.notifyChannel],
        );

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: '',
        );

        expect(find.text('@here'), findsNothing);
        expect(find.text('@channel'), findsOneWidget);
      },
    );

    testWidgets(
      'both broadcast capabilities missing hides @channel and @here',
      (tester) async {
        final mocks = _setupMocks(ownCapabilities: const []);

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: '',
        );

        expect(find.text('@channel'), findsNothing);
        expect(find.text('@here'), findsNothing);
      },
    );
  });

  group('roles', () {
    Role buildRole(String name) => Role(
      name: name,
      custom: false,
      scopes: const [],
      createdAt: DateTime.utc(2024),
      updatedAt: DateTime.utc(2024),
    );

    testWidgets(
      'empty query does not call searchRoles even when notifyRole capability is set',
      (tester) async {
        final mocks = _setupMocks(
          ownCapabilities: const [ChannelCapability.notifyRole],
        );
        when(
          () => mocks.client.searchRoles(any()),
        ).thenAnswer((_) async => SearchRolesResponse()..roles = []);

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: '',
        );

        verifyNever(() => mocks.client.searchRoles(any()));
      },
    );

    testWidgets(
      'non-empty query does not call searchRoles when notifyRole capability is missing',
      (tester) async {
        final mocks = _setupMocks(ownCapabilities: const []);
        when(
          () => mocks.client.searchRoles(any()),
        ).thenAnswer((_) async => SearchRolesResponse()..roles = []);

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'admin',
        );

        verifyNever(() => mocks.client.searchRoles(any()));
      },
    );

    testWidgets(
      'non-empty query with notifyRole capability calls searchRoles and renders matching role tiles',
      (tester) async {
        final mocks = _setupMocks(
          ownCapabilities: const [ChannelCapability.notifyRole],
        );
        when(() => mocks.client.searchRoles('admin')).thenAnswer(
          (_) async => SearchRolesResponse()..roles = [buildRole('admin')],
        );

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'admin',
        );

        expect(find.text('@admin'), findsOneWidget);
        verify(() => mocks.client.searchRoles('admin')).called(1);
      },
    );

    testWidgets(
      'searchRoles error is swallowed and does not blank the list',
      (tester) async {
        final mocks = _setupMocks(
          ownCapabilities: const [
            ChannelCapability.notifyRole,
            ChannelCapability.notifyChannel,
          ],
        );
        when(
          () => mocks.client.searchRoles(any()),
        ).thenThrow(StateError('test error'));

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'c',
        );

        expect(find.text('@channel'), findsOneWidget);
        expect(find.textContaining('admin'), findsNothing);
      },
    );
  });

  group('user groups', () {
    UserGroup buildUserGroup(String name, {List<UserGroupMember>? members}) => UserGroup(
      id: 'group-$name',
      name: name,
      members: members,
      createdAt: DateTime.utc(2024),
      updatedAt: DateTime.utc(2024),
    );

    testWidgets(
      'empty query does not call searchUserGroups even when notifyGroup capability is set',
      (tester) async {
        final mocks = _setupMocks(
          ownCapabilities: const [ChannelCapability.notifyGroup],
        );
        when(
          () => mocks.client.searchUserGroups(any(), teamId: any(named: 'teamId')),
        ).thenAnswer((_) async => SearchUserGroupsResponse()..userGroups = []);

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: '',
        );

        verifyNever(
          () => mocks.client.searchUserGroups(any(), teamId: any(named: 'teamId')),
        );
      },
    );

    testWidgets(
      'non-empty query does not call searchUserGroups when notifyGroup capability is missing',
      (tester) async {
        final mocks = _setupMocks(ownCapabilities: const []);
        when(
          () => mocks.client.searchUserGroups(any(), teamId: any(named: 'teamId')),
        ).thenAnswer((_) async => SearchUserGroupsResponse()..userGroups = []);

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'eng',
        );

        verifyNever(
          () => mocks.client.searchUserGroups(any(), teamId: any(named: 'teamId')),
        );
      },
    );

    testWidgets(
      'non-empty query with notifyGroup capability calls searchUserGroups and renders matching group tiles',
      (tester) async {
        final mocks = _setupMocks(
          ownCapabilities: const [ChannelCapability.notifyGroup],
        );
        when(
          () => mocks.client.searchUserGroups('eng', teamId: any(named: 'teamId')),
        ).thenAnswer(
          (_) async => SearchUserGroupsResponse()..userGroups = [buildUserGroup('engineering')],
        );

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'eng',
        );

        expect(find.text('@engineering'), findsOneWidget);
        verify(
          () => mocks.client.searchUserGroups('eng', teamId: null),
        ).called(1);
      },
    );

    testWidgets(
      'non-empty query forwards channel.team as teamId to searchUserGroups',
      (tester) async {
        final mocks = _setupMocks(
          ownCapabilities: const [ChannelCapability.notifyGroup],
          team: 'team-blue',
        );
        when(
          () => mocks.client.searchUserGroups('eng', teamId: any(named: 'teamId')),
        ).thenAnswer(
          (_) async => SearchUserGroupsResponse()..userGroups = [buildUserGroup('engineering')],
        );

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'eng',
        );

        verify(
          () => mocks.client.searchUserGroups('eng', teamId: 'team-blue'),
        ).called(1);
      },
    );

    testWidgets(
      'searchUserGroups error is swallowed and does not blank the list',
      (tester) async {
        final mocks = _setupMocks(
          ownCapabilities: const [
            ChannelCapability.notifyGroup,
            ChannelCapability.notifyHere,
          ],
        );
        when(
          () => mocks.client.searchUserGroups(any(), teamId: any(named: 'teamId')),
        ).thenThrow(StateError('test error'));

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'h',
        );

        expect(find.text('@here'), findsOneWidget);
        expect(find.textContaining('engineering'), findsNothing);
      },
    );
  });

  group('users', () {
    Member buildMember(String id, String name) => Member(
      userId: id,
      user: User(id: id, name: name),
    );

    testWidgets('query does not call queryUser or queryMembers when createMention capability is missing', (
      tester,
    ) async {
      final mocks = _setupMocks(ownCapabilities: const []);

      await _pumpMentionOptions(
        tester,
        client: mocks.client,
        channel: mocks.channel,
        query: 'ali',
      );

      verifyNever(
        () => mocks.channel.queryMembers(
          filter: any(named: 'filter'),
          pagination: any(named: 'pagination'),
        ),
      );
      verifyNever(
        () => mocks.client.queryUsers(
          presence: any(named: 'presence'),
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      );
    });

    testWidgets(
      'all members cached use in-memory search and skip queryMembers API call',
      (tester) async {
        final mocks = _setupMocks(
          ownCapabilities: const [ChannelCapability.createMention],
          members: [
            buildMember('alice-id', 'Alice'),
            buildMember('bob-id', 'Bob'),
            buildMember('charlie-id', 'Charlie'),
          ],
          memberCount: 3,
        );

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'ali',
        );

        expect(find.text('Alice'), findsOneWidget);
        expect(find.text('Bob'), findsNothing);
        verifyNever(
          () => mocks.channel.queryMembers(
            filter: any(named: 'filter'),
            pagination: any(named: 'pagination'),
          ),
        );
      },
    );

    testWidgets(
      'partial cache (memberCount > cached members) triggers queryMembers API call',
      (tester) async {
        final mocks = _setupMocks(
          ownCapabilities: const [ChannelCapability.createMention],
          members: [
            buildMember('user-1', 'User 1'),
            buildMember('user-2', 'User 2'),
          ],
          memberCount: 50,
        );
        when(
          () => mocks.channel.queryMembers(
            filter: any(named: 'filter'),
            pagination: any(named: 'pagination'),
          ),
        ).thenAnswer(
          (_) async => QueryMembersResponse()..members = [buildMember('alice-id', 'Alice')],
        );

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'alice',
        );

        expect(find.text('Alice'), findsOneWidget);
        verify(
          () => mocks.channel.queryMembers(
            filter: any(named: 'filter'),
            pagination: any(named: 'pagination'),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'null memberCount falls back to remote queryMembers',
      (tester) async {
        final mocks = _setupMocks(
          ownCapabilities: const [ChannelCapability.createMention],
          members: [buildMember('cached-id', 'Cached')],
          memberCount: null,
        );
        when(() => mocks.channel.memberCount).thenReturn(null);
        when(
          () => mocks.channel.queryMembers(
            filter: any(named: 'filter'),
            pagination: any(named: 'pagination'),
          ),
        ).thenAnswer(
          (_) async => QueryMembersResponse()..members = [buildMember('alice-id', 'Alice')],
        );

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'alice',
        );

        expect(find.text('Alice'), findsOneWidget);
        verify(
          () => mocks.channel.queryMembers(
            filter: any(named: 'filter'),
            pagination: any(named: 'pagination'),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'local search includes watchers',
      (tester) async {
        final mocks = _setupMocks(
          ownCapabilities: const [ChannelCapability.createMention],
          members: [buildMember('alice-id', 'Alice')],
          watchers: [User(id: 'wally-id', name: 'Wally')],
        );

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'wal',
        );

        expect(find.text('Wally'), findsOneWidget);
      },
    );

    testWidgets(
      'local results render alphabetically by name',
      (tester) async {
        final mocks = _setupMocks(
          ownCapabilities: const [ChannelCapability.createMention],
          members: [
            buildMember('c-id', 'Charlie'),
            buildMember('a-id', 'Alice'),
            buildMember('b-id', 'Bob'),
          ],
        );

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: '',
        );

        final aliceY = tester.getTopLeft(find.text('Alice')).dy;
        final bobY = tester.getTopLeft(find.text('Bob')).dy;
        final charlieY = tester.getTopLeft(find.text('Charlie')).dy;
        expect(aliceY, lessThan(bobY));
        expect(bobY, lessThan(charlieY));
      },
    );

    testWidgets(
      'remote queryMembers results render in server order',
      (tester) async {
        final mocks = _setupMocks(
          ownCapabilities: const [ChannelCapability.createMention],
          members: [buildMember('cached-id', 'Cached')],
          memberCount: 50,
        );
        when(
          () => mocks.channel.queryMembers(
            filter: any(named: 'filter'),
            pagination: any(named: 'pagination'),
          ),
        ).thenAnswer(
          (_) async => QueryMembersResponse()
            ..members = [
              buildMember('c-id', 'Charlie'),
              buildMember('a-id', 'Alice'),
              buildMember('b-id', 'Bob'),
            ],
        );

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'abc',
        );

        final charlieY = tester.getTopLeft(find.text('Charlie')).dy;
        final aliceY = tester.getTopLeft(find.text('Alice')).dy;
        final bobY = tester.getTopLeft(find.text('Bob')).dy;
        expect(charlieY, lessThan(aliceY));
        expect(aliceY, lessThan(bobY));
      },
    );

    testWidgets(
      'mentionAllAppUsers calls client.queryUsers instead of channel.queryMembers',
      (tester) async {
        final mocks = _setupMocks(ownCapabilities: const [ChannelCapability.createMention]);
        when(
          () => mocks.client.queryUsers(
            presence: any(named: 'presence'),
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          ),
        ).thenAnswer(
          (_) async => QueryUsersResponse()..users = [User(id: 'alice-id', name: 'Alice')],
        );

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'alice',
          mentionAllAppUsers: true,
        );

        expect(find.text('Alice'), findsOneWidget);
        verify(
          () => mocks.client.queryUsers(
            presence: any(named: 'presence'),
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          ),
        ).called(1);
        verifyNever(
          () => mocks.channel.queryMembers(
            filter: any(named: 'filter'),
            pagination: any(named: 'pagination'),
          ),
        );
      },
    );

    testWidgets(
      'queryMembers error is swallowed and does not blank the list',
      (tester) async {
        final mocks = _setupMocks(
          ownCapabilities: const [
            ChannelCapability.notifyHere,
            ChannelCapability.createMention,
          ],
          members: [buildMember('cached-id', 'Cached')],
          memberCount: 50,
        );
        when(
          () => mocks.channel.queryMembers(
            filter: any(named: 'filter'),
            pagination: any(named: 'pagination'),
          ),
        ).thenThrow(StateError('test error'));

        await _pumpMentionOptions(
          tester,
          client: mocks.client,
          channel: mocks.channel,
          query: 'h',
        );

        expect(find.text('@here'), findsOneWidget);
        expect(find.text('Alice'), findsNothing);
      },
    );
  });

  testWidgets(
    'renders tiles in order: broadcasts -> roles -> groups -> users',
    (tester) async {
      final mocks = _setupMocks(
        ownCapabilities: const [
          ChannelCapability.notifyHere,
          ChannelCapability.notifyRole,
          ChannelCapability.notifyGroup,
          ChannelCapability.createMention,
        ],
        members: [
          Member(
            userId: 'hannah-id',
            user: User(id: 'hannah-id', name: 'Hannah'),
          ),
        ],
      );
      when(() => mocks.client.searchRoles('h')).thenAnswer(
        (_) async => SearchRolesResponse()
          ..roles = [
            Role(
              name: 'host',
              custom: false,
              scopes: const [],
              createdAt: DateTime.utc(2024),
              updatedAt: DateTime.utc(2024),
            ),
          ],
      );
      when(
        () => mocks.client.searchUserGroups('h', teamId: any(named: 'teamId')),
      ).thenAnswer(
        (_) async => SearchUserGroupsResponse()
          ..userGroups = [
            UserGroup(
              id: 'hr-id',
              name: 'hr',
              createdAt: DateTime.utc(2024),
              updatedAt: DateTime.utc(2024),
            ),
          ],
      );

      await _pumpMentionOptions(
        tester,
        client: mocks.client,
        channel: mocks.channel,
        query: 'h',
      );

      final hereY = tester.getTopLeft(find.text('@here')).dy;
      final roleY = tester.getTopLeft(find.text('@host')).dy;
      final groupY = tester.getTopLeft(find.text('@hr')).dy;
      final userY = tester.getTopLeft(find.text('Hannah')).dy;

      expect(hereY, lessThan(roleY));
      expect(roleY, lessThan(groupY));
      expect(groupY, lessThan(userY));
    },
  );

  group('goldens', () {
    goldenTest(
      'broadcasts-only autocomplete',
      fileName: 'stream_mention_autocomplete_options_broadcasts',
      constraints: const BoxConstraints.tightFor(width: 360, height: 160),
      builder: () {
        final mocks = _setupMocks(
          ownCapabilities: const [
            ChannelCapability.notifyChannel,
            ChannelCapability.notifyHere,
          ],
        );
        return MaterialAppWrapper(
          home: _buildMentionOptionsBody(
            client: mocks.client,
            channel: mocks.channel,
          ),
        );
      },
    );

    goldenTest(
      'mixed autocomplete with broadcast, role, group, and user',
      fileName: 'stream_mention_autocomplete_options_mixed',
      constraints: const BoxConstraints.tightFor(width: 360, height: 260),
      builder: () {
        final mocks = _setupMocks(
          ownCapabilities: const [
            ChannelCapability.notifyHere,
            ChannelCapability.notifyRole,
            ChannelCapability.notifyGroup,
            ChannelCapability.createMention,
          ],
          members: [
            Member(
              userId: 'hannah-id',
              user: User(id: 'hannah-id', name: 'Hannah'),
            ),
          ],
        );
        when(() => mocks.client.searchRoles('h')).thenAnswer(
          (_) async => SearchRolesResponse()
            ..roles = [
              Role(
                name: 'host',
                custom: false,
                scopes: const [],
                createdAt: DateTime.utc(2024),
                updatedAt: DateTime.utc(2024),
              ),
            ],
        );
        when(
          () => mocks.client.searchUserGroups('h', teamId: any(named: 'teamId')),
        ).thenAnswer(
          (_) async => SearchUserGroupsResponse()
            ..userGroups = [
              UserGroup(
                id: 'hr-id',
                name: 'hr',
                createdAt: DateTime.utc(2024),
                updatedAt: DateTime.utc(2024),
              ),
            ],
        );
        return MaterialAppWrapper(
          home: _buildMentionOptionsBody(
            client: mocks.client,
            channel: mocks.channel,
            query: 'h',
          ),
        );
      },
    );
  });
}
