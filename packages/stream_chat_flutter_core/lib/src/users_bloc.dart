import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Widget dedicated to the management of a users list with pagination.
///
/// [UsersBloc] can be access at anytime by using the static [of] method
/// using Flutter's [BuildContext].
///
/// API docs: https://getstream.io/chat/docs/flutter-dart/init_and_users/
class UsersBloc extends StatefulWidget {
  /// Instantiate a new [UsersBloc]. The parameter [child] must be supplied and
  /// not null.
  const UsersBloc({
    required this.child,
    Key? key,
  }) : super(key: key);

  /// The widget child
  final Widget child;

  @override
  UsersBlocState createState() => UsersBlocState();

  /// Use this method to get the current [UsersBlocState] instance
  static UsersBlocState of(BuildContext context) {
    UsersBlocState? state;

    state = context.findAncestorStateOfType<UsersBlocState>();

    assert(
      state != null,
      'You must have a UsersBloc widget as ancestor',
    );

    return state!;
  }
}

/// The current state of the [UsersBloc]
class UsersBlocState extends State<UsersBloc>
    with AutomaticKeepAliveClientMixin {
  /// The current users list
  List<User>? get users => _usersController.valueOrNull;

  /// The current users list as a stream
  Stream<List<User>> get usersStream => _usersController.stream;

  final _usersController = BehaviorSubject<List<User>>();

  final _queryUsersLoadingController = BehaviorSubject.seeded(false);

  /// The stream notifying the state of queryUsers call
  Stream<bool> get queryUsersLoading => _queryUsersLoadingController.stream;

  late StreamChatCoreState _streamChatCore;

  bool _paginationEnded = false;

  /// The Query Users method allows you to search for users and see if they are
  /// online/offline.
  /// [API Reference](https://getstream.io/chat/docs/flutter-dart/query_users/?language=dart)
  Future<void> queryUsers({
    Filter? filter,
    List<SortOption>? sort,
    bool? presence,
    PaginationParams pagination = const PaginationParams(limit: 30),
  }) async {
    final client = _streamChatCore.client;

    final offset = pagination.offset;
    final clear = offset == null || offset == 0;

    if (clear && _paginationEnded) {
      _paginationEnded = false;
    }

    if ((!clear && _paginationEnded) || _queryUsersLoadingController.value) {
      return;
    }

    if (_usersController.hasValue) {
      _queryUsersLoadingController.add(true);
    }

    try {
      final oldUsers = List<User>.from(users ?? []);

      final usersResponse = await client.queryUsers(
        filter: filter,
        sort: sort,
        presence: presence,
        pagination: pagination,
      );

      final newUsers = usersResponse.users;
      if (clear) {
        _usersController.add(usersResponse.users);
      } else {
        final temp = oldUsers + usersResponse.users;
        _usersController.add(temp);
      }
      if (_usersController.hasValue && _queryUsersLoadingController.value) {
        _queryUsersLoadingController.add(false);
      }
      if (newUsers.isEmpty || newUsers.length < pagination.limit) {
        _paginationEnded = true;
      }
    } catch (e, stk) {
      // reset loading controller
      _queryUsersLoadingController.add(false);
      if (_usersController.hasValue) {
        _queryUsersLoadingController.addError(e, stk);
      } else {
        _usersController.addError(e, stk);
      }
    }
  }

  @override
  void didChangeDependencies() {
    _streamChatCore = StreamChatCore.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  void dispose() {
    _usersController.close();
    _queryUsersLoadingController.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
