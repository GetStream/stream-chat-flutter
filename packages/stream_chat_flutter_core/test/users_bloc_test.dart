import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/stream_chat_core.dart';
import 'package:stream_chat_flutter_core/src/users_bloc.dart';

import 'matchers/users_matcher.dart';
import 'mocks.dart';

void main() {
  List<User> _generateUsers({
    int count = 3,
    int offset = 0,
  }) {
    return List.generate(
      count,
      (index) {
        index = index + offset;
        return User(
          id: 'testId$index',
          role: 'testRole$index',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          lastActive: DateTime.now(),
          online: true,
          banned: false,
          extraData: {'extra_data_key': 'extraDataValue'},
        );
      },
    );
  }

  testWidgets(
    'usersBlocState.queryUsers() should throw if used where '
    'StreamChat is not present in the widget tree',
    (tester) async {
      final usersBloc = UsersBloc(
        child: Offstage(),
      );

      await tester.pumpWidget(usersBloc);
      expect(tester.takeException(), isInstanceOf<AssertionError>());
    },
  );

  testWidgets(
    'usersBlocState.queryUsers() should emit data through usersStream',
    (tester) async {
      const usersBlocKey = Key('usersBloc');
      const childKey = Key('child');
      final usersBloc = UsersBloc(
        key: usersBlocKey,
        child: Offstage(key: childKey),
      );

      final mockClient = MockClient();

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: usersBloc,
        ),
      );

      final usersBlocState = tester.state<UsersBlocState>(
        find.byKey(usersBlocKey),
      );

      final users = _generateUsers();

      when(() => mockClient.queryUsers(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            pagination: any(named: 'pagination'),
          )).thenAnswer((_) async => QueryUsersResponse()..users = users);

      usersBlocState.queryUsers();

      await expectLater(
        usersBlocState.usersStream,
        emits(isSameUserListAs(users)),
      );

      verify(() => mockClient.queryUsers(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            pagination: any(named: 'pagination'),
          )).called(1);
    },
  );

  testWidgets(
    'usersBlocState.usersStream should emit error '
    'if client.queryUsers() throws',
    (tester) async {
      const usersBlocKey = Key('usersBloc');
      const childKey = Key('child');
      final usersBloc = UsersBloc(
        key: usersBlocKey,
        child: Offstage(key: childKey),
      );

      final mockClient = MockClient();

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: usersBloc,
        ),
      );

      final usersBlocState = tester.state<UsersBlocState>(
        find.byKey(usersBlocKey),
      );

      final error = 'Error! Error! Error!';

      when(() => mockClient.queryUsers(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            pagination: any(named: 'pagination'),
          )).thenThrow(error);

      usersBlocState.queryUsers();

      await expectLater(
        usersBlocState.usersStream,
        emitsError(error),
      );

      verify(() => mockClient.queryUsers(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            pagination: any(named: 'pagination'),
          )).called(1);
    },
  );

  testWidgets(
    'calling usersBlocState.queryUsers() again with an offset '
    'should emit new data through usersStream and also emit loading state '
    'through queryUsersLoading',
    (tester) async {
      const usersBlocKey = Key('usersBloc');
      const childKey = Key('child');
      final usersBloc = UsersBloc(
        key: usersBlocKey,
        child: Offstage(key: childKey),
      );

      final mockClient = MockClient();

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: usersBloc,
        ),
      );

      final usersBlocState = tester.state<UsersBlocState>(
        find.byKey(usersBlocKey),
      );

      final users = _generateUsers();

      when(() => mockClient.queryUsers(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            pagination: any(named: 'pagination'),
          )).thenAnswer((_) async => QueryUsersResponse()..users = users);

      usersBlocState.queryUsers();

      await expectLater(
        usersBlocState.usersStream,
        emits(isSameUserListAs(users)),
      );

      verify(() => mockClient.queryUsers(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            pagination: any(named: 'pagination'),
          )).called(1);

      final offset = users.length;
      final paginatedUsers = _generateUsers(offset: offset);
      final pagination = PaginationParams(offset: offset);

      when(() => mockClient.queryUsers(
                filter: any(named: 'filter'),
                sort: any(named: 'sort'),
                options: any(named: 'options'),
                pagination: pagination,
              ))
          .thenAnswer(
              (_) async => QueryUsersResponse()..users = paginatedUsers);

      usersBlocState.queryUsers(pagination: pagination);

      await Future.wait([
        expectLater(
          usersBlocState.queryUsersLoading,
          emitsInOrder([true, false]),
        ),
        expectLater(
          usersBlocState.usersStream,
          emits(isSameUserListAs(users + paginatedUsers)),
        ),
      ]);

      verify(() => mockClient.queryUsers(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            pagination: pagination,
          )).called(1);
    },
  );

  testWidgets(
    'calling usersBlocState.queryUsers() again with an offset '
    'should emit error through queryUsersLoading if '
    'client.queryUsers() throws',
    (tester) async {
      const usersBlocKey = Key('usersBloc');
      const childKey = Key('child');
      final usersBloc = UsersBloc(
        key: usersBlocKey,
        child: Offstage(key: childKey),
      );

      final mockClient = MockClient();

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: usersBloc,
        ),
      );

      final usersBlocState = tester.state<UsersBlocState>(
        find.byKey(usersBlocKey),
      );

      final users = _generateUsers();

      when(() => mockClient.queryUsers(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            pagination: any(named: 'pagination'),
          )).thenAnswer((_) async => QueryUsersResponse()..users = users);

      usersBlocState.queryUsers();

      await expectLater(
        usersBlocState.usersStream,
        emits(isSameUserListAs(users)),
      );

      verify(() => mockClient.queryUsers(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            pagination: any(named: 'pagination'),
          )).called(1);

      final offset = users.length;
      final pagination = PaginationParams(offset: offset);

      final error = 'Error! Error! Error!';

      when(() => mockClient.queryUsers(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            pagination: pagination,
          )).thenThrow(error);

      usersBlocState.queryUsers(pagination: pagination);

      await expectLater(
        usersBlocState.queryUsersLoading,
        emitsError(error),
      );

      verify(() => mockClient.queryUsers(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            options: any(named: 'options'),
            pagination: pagination,
          )).called(1);
    },
  );
}
