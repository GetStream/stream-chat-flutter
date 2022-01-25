import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/stream_chat_core.dart';
import 'package:stream_chat_flutter_core/src/stream_controller_extension.dart';

/// [MessageSearchBloc] is used to manage a list of messages with pagination.
/// This class can be used to load messages, perform queries, etc.
///
/// [MessageSearchBloc] can be access at anytime by using the static [of] method
/// using Flutter's [BuildContext].
///
/// API docs: https://getstream.io/chat/docs/flutter-dart/send_message/
class MessageSearchBloc extends StatefulWidget {
  /// Instantiate a new MessageSearchBloc
  const MessageSearchBloc({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// The widget child
  final Widget child;

  @override
  MessageSearchBlocState createState() => MessageSearchBlocState();

  /// Use this method to get the current [MessageSearchBlocState] instance
  static MessageSearchBlocState of(BuildContext context) {
    MessageSearchBlocState? state;

    state = context.findAncestorStateOfType<MessageSearchBlocState>();

    assert(
      state != null,
      'You must have a MessageSearchBloc widget as ancestor',
    );

    return state!;
  }
}

/// The current state of the [MessageSearchBloc]
class MessageSearchBlocState extends State<MessageSearchBloc>
    with AutomaticKeepAliveClientMixin {
  late StreamChatCoreState _streamChatCoreState;

  /// The key used to paginate next items.
  String? nextId;

  /// The key used to paginate previous items.
  String? previousId;

  /// The current messages list
  List<GetMessageResponse>? get messageResponses =>
      _messageResponses.valueOrNull;

  /// The current messages list as a stream
  Stream<List<GetMessageResponse>> get messagesStream =>
      _messageResponses.stream;

  final _messageResponses = BehaviorSubject<List<GetMessageResponse>>();

  final _queryMessagesLoadingController = BehaviorSubject.seeded(false);

  /// The stream notifying the state of queryUsers call
  Stream<bool> get queryMessagesLoading =>
      _queryMessagesLoadingController.stream;

  bool _paginationEnded = false;

  /// Calls [StreamChatClient.search] updating
  /// [messagesStream] and [queryMessagesLoading] stream
  Future<void> search({
    required Filter filter,
    Filter? messageFilter,
    List<SortOption>? sort,
    String? query,
    PaginationParams pagination = const PaginationParams(limit: 30),
  }) async {
    final client = _streamChatCoreState.client;

    var clear = false;
    if (sort != null) {
      clear |= pagination.next == null;
    } else {
      final offset = pagination.offset;
      clear |= offset == null || offset == 0;
    }

    if (clear && _paginationEnded) {
      _paginationEnded = false;
    }

    if ((!clear && _paginationEnded) || _queryMessagesLoadingController.value) {
      return;
    }

    if (_messageResponses.hasValue) {
      _queryMessagesLoadingController.safeAdd(true);
    }
    try {
      final oldMessages = List<GetMessageResponse>.from(messageResponses ?? []);

      final response = await client.search(
        filter,
        sort: sort,
        query: query,
        paginationParams: pagination,
        messageFilters: messageFilter,
      );

      final next = response.next;
      final previous = response.previous;

      nextId = next != null && next.isNotEmpty
          ? next
          : /*reset nextId if we get nothing*/ null;
      previousId = previous != null && previous.isNotEmpty
          ? previous
          : /*reset previousId if we get nothing*/ null;

      final newMessages = response.results;
      if (clear) {
        _messageResponses.safeAdd(newMessages);
      } else {
        final temp = oldMessages + newMessages;
        _messageResponses.safeAdd(temp);
      }
      if (_messageResponses.hasValue && _queryMessagesLoadingController.value) {
        _queryMessagesLoadingController.safeAdd(false);
      }
      if (newMessages.isEmpty || newMessages.length < pagination.limit) {
        _paginationEnded = true;
      }
    } catch (e, stk) {
      // reset loading controller
      _queryMessagesLoadingController.safeAdd(false);
      if (_messageResponses.hasValue) {
        _queryMessagesLoadingController.safeAddError(e, stk);
      } else {
        _messageResponses.safeAddError(e, stk);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  void didChangeDependencies() {
    _streamChatCoreState = StreamChatCore.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _messageResponses.close();
    _queryMessagesLoadingController.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
