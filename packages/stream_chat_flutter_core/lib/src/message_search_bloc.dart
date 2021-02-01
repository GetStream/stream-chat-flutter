import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';

import 'stream_chat_core.dart';

/// [MessageSearchBloc] is used to manage a list of messages with pagination.
/// This class can be used to load messages, perform queries, etc.
///
/// [MessageSearchBloc] can be access at anytime by using the static [of] method
/// using Flutter's [BuildContext].
///
// API docs: https://getstream.io/chat/docs/flutter-dart/send_message/
class MessageSearchBloc extends StatefulWidget {
  /// Instantiate a new MessageSearchBloc
  const MessageSearchBloc({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  /// The widget child
  final Widget child;

  @override
  MessageSearchBlocState createState() => MessageSearchBlocState();

  /// Use this method to get the current [MessageSearchBlocState] instance
  static MessageSearchBlocState of(BuildContext context) {
    MessageSearchBlocState state;

    state = context.findAncestorStateOfType<MessageSearchBlocState>();

    if (state == null) {
      throw Exception('You must have a MessageSearchBloc widget as ancestor');
    }

    return state;
  }
}

/// The current state of the [MessageSearchBloc]
class MessageSearchBlocState extends State<MessageSearchBloc>
    with AutomaticKeepAliveClientMixin {
  /// The current messages list
  List<GetMessageResponse> get messageResponses => _messageResponses.value;

  /// The current messages list as a stream
  Stream<List<GetMessageResponse>> get messagesStream =>
      _messageResponses.stream;

  final BehaviorSubject<List<GetMessageResponse>> _messageResponses =
      BehaviorSubject();

  final BehaviorSubject<bool> _queryMessagesLoadingController =
      BehaviorSubject.seeded(false);

  /// The stream notifying the state of queryUsers call
  Stream<bool> get queryMessagesLoading =>
      _queryMessagesLoadingController.stream;

  /// Calls [Client.search] updating [messageResponses] stream
  Future<void> search({
    Map<String, dynamic> filter,
    Map<String, dynamic> messageFilter,
    List<SortOption> sort,
    String query,
    PaginationParams pagination,
  }) async {
    _messageResponses.add(null);
    try {
      final messages = await _search(
        filter: filter,
        messageFilter: messageFilter,
        sort: sort,
        query: query,
        pagination: pagination,
      );
      _messageResponses.add(messages.results);
    } catch (err, stk) {
      _messageResponses.addError(err, stk);
    }
  }

  /// Calls [Client.search] updating [queryMessagesLoading] stream
  Future<void> loadMore({
    Map<String, dynamic> filter,
    Map<String, dynamic> messageFilter,
    List<SortOption> sort,
    String query,
    PaginationParams pagination,
  }) async {
    if (_queryMessagesLoadingController.value == true) {
      return;
    }
    _queryMessagesLoadingController.add(true);
    try {
      final clear = pagination == null ||
          pagination.offset == null ||
          pagination.offset == 0;

      final oldMessages = List<GetMessageResponse>.from(messageResponses ?? []);

      final messages = await _search(
        filter: filter,
        messageFilter: messageFilter,
        sort: sort,
        query: query,
        pagination: pagination,
      );

      if (clear) {
        _messageResponses.add(messages.results);
      } else {
        final temp = oldMessages + messages.results;
        _messageResponses.add(temp);
      }

      _queryMessagesLoadingController.add(false);
    } catch (err, stackTrace) {
      _queryMessagesLoadingController.addError(err, stackTrace);
    }
  }

  Future<SearchMessagesResponse> _search({
    Map<String, dynamic> filter,
    Map<String, dynamic> messageFilter,
    List<SortOption> sort,
    String query,
    PaginationParams pagination,
  }) {
    final client = StreamChatCore.of(context).client;
    return client.search(
      filter,
      sort,
      query,
      pagination,
      messageFilters: messageFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
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
