import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';

import 'stream_chat.dart';

/// Widget dedicated to the management of a message list with pagination
class MessageSearchBloc extends StatefulWidget {
  /// The widget child
  final Widget child;

  /// Instantiate a new MessageSearchBloc
  const MessageSearchBloc({
    Key key,
    @required this.child,
  }) : super(key: key);

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

  /// Calls [Client.search] updating [queryMessagesLoading] stream
  Future<void> search({
    Map<String, dynamic> filter,
    Map<String, dynamic> messageFilter,
    List<SortOption> sort,
    String query,
    PaginationParams pagination,
  }) async {
    final client = StreamChat.of(context).client;

    if (client.state?.user == null ||
        _queryMessagesLoadingController.value == true) {
      return;
    }
    _queryMessagesLoadingController.add(true);
    try {
      final clear = pagination == null ||
          pagination.offset == null ||
          pagination.offset == 0;

      final oldMessages = List<GetMessageResponse>.from(messageResponses ?? []);

      final messageResponse = await client.search(
        filter,
        sort,
        query,
        pagination,
        messageFilters: messageFilter,
      );

      if (clear) {
        _messageResponses.add(messageResponse.results);
      } else {
        final temp = oldMessages + messageResponse.results;
        _messageResponses.add(temp);
      }

      _queryMessagesLoadingController.add(false);
    } catch (err, stackTrace) {
      _queryMessagesLoadingController.addError(err, stackTrace);
    }
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
