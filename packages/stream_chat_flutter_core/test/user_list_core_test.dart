import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat_flutter_core/src/user_list_core.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'mocks.dart';

void main() {
  const alphabets = 'abcdefghijklmnopqrstuvwxyz';

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
          extraData: {
            'name': '${alphabets[index]}-testName',
          },
        );
      },
    );
  }

  test(
    'should throw assertion error in case listBuilder is null',
    () {
      final userListCore = () => UserListCore(
            listBuilder: null,
            loadingBuilder: (BuildContext context) => Offstage(),
            emptyBuilder: (BuildContext context) => Offstage(),
            errorBuilder: (Object error) => Offstage(),
          );
      expect(userListCore, throwsA(isA<AssertionError>()));
    },
  );

  test(
    'should throw assertion error in case loadingBuilder is null',
    () {
      final userListCore = () => UserListCore(
            listBuilder: (_, __) => Offstage(),
            loadingBuilder: null,
            emptyBuilder: (BuildContext context) => Offstage(),
            errorBuilder: (Object error) => Offstage(),
          );
      expect(userListCore, throwsA(isA<AssertionError>()));
    },
  );

  test(
    'should throw assertion error in case emptyBuilder is null',
    () {
      final userListCore = () => UserListCore(
            listBuilder: (_, __) => Offstage(),
            loadingBuilder: (BuildContext context) => Offstage(),
            emptyBuilder: null,
            errorBuilder: (Object error) => Offstage(),
          );
      expect(userListCore, throwsA(isA<AssertionError>()));
    },
  );

  test(
    'should throw assertion error in case errorBuilder is null',
    () {
      final userListCore = () => UserListCore(
            listBuilder: (_, __) => Offstage(),
            loadingBuilder: (BuildContext context) => Offstage(),
            emptyBuilder: (BuildContext context) => Offstage(),
            errorBuilder: null,
          );
      expect(userListCore, throwsA(isA<AssertionError>()));
    },
  );

  testWidgets(
    'should throw if UserListCore is used where UsersBloc is not present '
    'in the widget tree',
    (tester) async {
      const userListCoreKey = Key('userListCore');
      final userListCore = UserListCore(
        key: userListCoreKey,
        listBuilder: (_, __) => Offstage(),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (Object error) => Offstage(),
      );

      await tester.pumpWidget(userListCore);

      expect(find.byKey(userListCoreKey), findsNothing);
      expect(tester.takeException(), isInstanceOf<Exception>());
    },
  );

  testWidgets(
    'should render UserListCore if used with UsersBloc as an ancestor',
    (tester) async {
      const userListCoreKey = Key('userListCore');
      final userListCore = UserListCore(
        key: userListCoreKey,
        listBuilder: (_, __) => Offstage(),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (Object error) => Offstage(),
      );

      final mockClient = MockClient();

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: UsersBloc(
            child: userListCore,
          ),
        ),
      );

      expect(find.byKey(userListCoreKey), findsOneWidget);
    },
  );

  testWidgets(
    'should assign loadData and paginateData callback to '
    'UserListController if passed',
    (tester) async {
      const userListCoreKey = Key('userListCore');
      final controller = UserListController();
      final userListCore = UserListCore(
        key: userListCoreKey,
        listBuilder: (_, __) => Offstage(),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (Object error) => Offstage(),
        userListController: controller,
      );

      expect(controller.loadData, isNull);
      expect(controller.paginateData, isNull);

      final mockClient = MockClient();

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: UsersBloc(
            child: userListCore,
          ),
        ),
      );

      expect(find.byKey(userListCoreKey), findsOneWidget);
      expect(controller.loadData, isNotNull);
      expect(controller.paginateData, isNotNull);
    },
  );

  testWidgets(
    'should build error widget if usersBlocState.usersStream emits error',
    (tester) async {
      const userListCoreKey = Key('userListCore');
      const errorWidgetKey = Key('errorWidget');
      final userListCore = UserListCore(
        key: userListCoreKey,
        listBuilder: (_, __) => Offstage(),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (Object error) => Container(key: errorWidgetKey),
      );

      final mockClient = MockClient();

      const error = 'Error! Error! Error!';
      when(mockClient.queryUsers(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        pagination: anyNamed('pagination'),
      )).thenThrow(error);

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: UsersBloc(
            child: userListCore,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(errorWidgetKey), findsOneWidget);

      verify(mockClient.queryUsers(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        pagination: anyNamed('pagination'),
      )).called(1);
    },
  );

  testWidgets(
    'should build empty widget if usersBlocState.usersStream emits empty data',
    (tester) async {
      const userListCoreKey = Key('userListCore');
      const emptyWidgetKey = Key('emptyWidget');
      final userListCore = UserListCore(
        key: userListCoreKey,
        listBuilder: (_, __) => Offstage(),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Container(key: emptyWidgetKey),
        errorBuilder: (Object error) => Offstage(),
      );

      final mockClient = MockClient();

      const users = <User>[];
      when(mockClient.queryUsers(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        pagination: anyNamed('pagination'),
      )).thenAnswer((_) async => QueryUsersResponse()..users = users);

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: UsersBloc(
            child: userListCore,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(emptyWidgetKey), findsOneWidget);

      verify(mockClient.queryUsers(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        pagination: anyNamed('pagination'),
      )).called(1);
    },
  );

  testWidgets(
    'should build list widget if usersBlocState.usersStream emits some data',
    (tester) async {
      const userListCoreKey = Key('userListCore');
      const listWidgetKey = Key('listWidget');
      final userListCore = UserListCore(
        key: userListCoreKey,
        listBuilder: (_, __) => Container(key: listWidgetKey),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (Object error) => Offstage(),
      );

      final mockClient = MockClient();

      final users = _generateUsers();
      when(mockClient.queryUsers(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        pagination: anyNamed('pagination'),
      )).thenAnswer((_) async => QueryUsersResponse()..users = users);

      await tester.pumpWidget(
        StreamChatCore(
          client: mockClient,
          child: UsersBloc(
            child: userListCore,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(listWidgetKey), findsOneWidget);

      verify(mockClient.queryUsers(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        pagination: anyNamed('pagination'),
      )).called(1);
    },
  );

  testWidgets(
    'should build list widget with grouped data if groupAlphabetically is true',
    (tester) async {
      const userListCoreKey = Key('userListCore');
      const listWidgetKey = Key('listWidget');
      final userListCore = UserListCore(
        key: userListCoreKey,
        listBuilder: (_, items) => Container(
          key: listWidgetKey,
          child: ListView(
            children: items.map((e) {
              return Container(
                key: Key(e.key),
                child: e.when(
                  headerItem: (heading) => Text(heading),
                  userItem: (user) => Text(user.id),
                ),
              );
            }).toList(growable: false),
          ),
        ),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (Object error) => Offstage(),
        groupAlphabetically: true,
      );

      final mockClient = MockClient();

      final users = _generateUsers();
      when(mockClient.queryUsers(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        pagination: anyNamed('pagination'),
      )).thenAnswer((_) async => QueryUsersResponse()..users = users);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChatCore(
            client: mockClient,
            child: UsersBloc(
              child: userListCore,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(listWidgetKey), findsOneWidget);
      for (final user in users) {
        expect(find.byKey(Key('HEADER-${user.name[0]}')), findsOneWidget);
        expect(find.byKey(Key('USER-${user.id}')), findsOneWidget);
      }

      verify(mockClient.queryUsers(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        pagination: anyNamed('pagination'),
      )).called(1);
    },
  );

  testWidgets(
    'should build list widget with paginated data '
    'on calling channelListCoreState.paginateData',
    (tester) async {
      const userListCoreKey = Key('userListCore');
      const listWidgetKey = Key('listWidget');
      const pagination = PaginationParams();
      final userListCore = UserListCore(
        key: userListCoreKey,
        listBuilder: (_, items) => Container(
          key: listWidgetKey,
          child: ListView(
            children: items.map((e) {
              return Container(
                key: Key(e.key),
                child: e.when(
                  headerItem: (heading) => Text(heading),
                  userItem: (user) => Text(user.id),
                ),
              );
            }).toList(growable: false),
          ),
        ),
        loadingBuilder: (BuildContext context) => Offstage(),
        emptyBuilder: (BuildContext context) => Offstage(),
        errorBuilder: (Object error) => Offstage(),
        pagination: pagination,
        groupAlphabetically: true,
      );

      final mockClient = MockClient();

      final users = _generateUsers();
      when(mockClient.queryUsers(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        pagination: anyNamed('pagination'),
      )).thenAnswer((_) async => QueryUsersResponse()..users = users);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChatCore(
            client: mockClient,
            child: UsersBloc(
              child: userListCore,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(listWidgetKey), findsOneWidget);
      for (final user in users) {
        expect(find.byKey(Key('HEADER-${user.name[0]}')), findsOneWidget);
        expect(find.byKey(Key('USER-${user.id}')), findsOneWidget);
      }

      verify(mockClient.queryUsers(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        pagination: anyNamed('pagination'),
      )).called(1);

      final userListCoreState = tester.state<UserListCoreState>(
        find.byKey(userListCoreKey),
      );

      final offset = users.length;
      final paginatedUsers = _generateUsers(offset: offset);
      final updatedPagination = pagination.copyWith(offset: offset);
      when(mockClient.queryUsers(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        pagination: updatedPagination,
      )).thenAnswer((_) async => QueryUsersResponse()..users = paginatedUsers);

      await userListCoreState.paginateData();

      await tester.pumpAndSettle();

      for (final user in users + paginatedUsers) {
        expect(find.byKey(Key('HEADER-${user.name[0]}')), findsOneWidget);
        expect(find.byKey(Key('USER-${user.id}')), findsOneWidget);
      }

      verify(mockClient.queryUsers(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        pagination: updatedPagination,
      )).called(1);
    },
  );

  testWidgets(
    'should rebuild UserListCore with updated widget data '
    'on calling setState()',
    (tester) async {
      const pagination = PaginationParams();

      StateSetter _stateSetter;
      int limit = pagination.limit;

      const userListCoreKey = Key('userListCore');
      const listWidgetKey = Key('listWidget');
      UserListCore userListCoreBuilder(int limit) => UserListCore(
            key: userListCoreKey,
            listBuilder: (_, items) => Container(
              key: listWidgetKey,
              child: ListView(
                children: items.map((e) {
                  return Container(
                    key: Key(e.key),
                    child: e.when(
                      headerItem: (heading) => Text(heading),
                      userItem: (user) => Text(user.id),
                    ),
                  );
                }).toList(growable: false),
              ),
            ),
            loadingBuilder: (BuildContext context) => Offstage(),
            emptyBuilder: (BuildContext context) => Offstage(),
            errorBuilder: (Object error) => Offstage(),
            pagination: pagination.copyWith(limit: limit),
            groupAlphabetically: true,
          );

      final mockClient = MockClient();

      final users = _generateUsers();
      when(mockClient.queryUsers(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        pagination: anyNamed('pagination'),
      )).thenAnswer((_) async => QueryUsersResponse()..users = users);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamChatCore(
            client: mockClient,
            child: UsersBloc(
              child: StatefulBuilder(builder: (context, stateSetter) {
                // Assigning stateSetter for rebuilding UserListCore
                _stateSetter = stateSetter;
                return userListCoreBuilder(limit);
              }),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(listWidgetKey), findsOneWidget);
      for (final user in users) {
        expect(find.byKey(Key('HEADER-${user.name[0]}')), findsOneWidget);
        expect(find.byKey(Key('USER-${user.id}')), findsOneWidget);
      }

      verify(mockClient.queryUsers(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        pagination: anyNamed('pagination'),
      )).called(1);

      // Rebuilding UserListCore with new pagination limit
      _stateSetter(() => limit = 6);

      final updatedUsers = _generateUsers(count: limit);
      final updatedPagination = pagination.copyWith(limit: limit);
      when(mockClient.queryUsers(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        pagination: updatedPagination,
      )).thenAnswer((_) async => QueryUsersResponse()..users = updatedUsers);

      await tester.pumpAndSettle();

      for (final user in updatedUsers) {
        expect(find.byKey(Key('HEADER-${user.name[0]}')), findsOneWidget);
        expect(find.byKey(Key('USER-${user.id}')), findsOneWidget);
      }

      verify(mockClient.queryUsers(
        filter: anyNamed('filter'),
        sort: anyNamed('sort'),
        options: anyNamed('options'),
        pagination: updatedPagination,
      )).called(1);
    },
  );
}
