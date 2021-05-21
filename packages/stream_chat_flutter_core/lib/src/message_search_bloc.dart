import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/stream_chat_core.dart';

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

  /// Calls [StreamChatClient.search] updating
  /// [messagesStream] and [queryMessagesLoading] stream
  Future<void> search({
    required Filter filter,
    Filter? messageFilter,
    List<SortOption>? sort,
    String? query,
    PaginationParams? pagination,
  }) async {
    final client = _streamChatCoreState.client;

    if (_queryMessagesLoadingController.value == true) return;

    if (_messageResponses.hasValue) {
      _queryMessagesLoadingController.add(true);
    }
    try {
      final clear = pagination == null || pagination.offset == 0;

      final oldMessages = List<GetMessageResponse>.from(messageResponses ?? []);

      final messages = await client.search(
        filter,
        sort: sort,
        query: query,
        paginationParams: pagination,
        messageFilters: messageFilter,
      );

      if (clear) {
        _messageResponses.add(messages.results);
      } else {
        final temp = oldMessages + messages.results;
        _messageResponses.add(temp);
      }
      if (_messageResponses.hasValue && _queryMessagesLoadingController.value) {
        _queryMessagesLoadingController.add(false);
      }
    } catch (e, stk) {
      if (_messageResponses.hasValue) {
        _queryMessagesLoadingController.addError(e, stk);
      } else {
        _messageResponses.addError(e, stk);
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
