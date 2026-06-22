import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/video/vlc/vlc_manager_desktop.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MockClient extends Mock implements StreamChatClient {
  MockClient() {
    when(() => wsConnectionStatus).thenReturn(ConnectionStatus.connected);
    when(() => wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.connected));
    when(() => state).thenReturn(MockClientState());
  }
}

class MockClientState extends Mock implements ClientState {}

class MockChannel extends Mock implements Channel {
  MockChannel({
    this.type = 'test-chanel-type',
    this.id = 'test-channel-id',
    this.ownCapabilities = const [
      ChannelCapability.sendMessage,
      ChannelCapability.uploadFile,
    ],
    Stream<Event>? eventStream,
  }) : _eventStream = eventStream ?? const Stream.empty() {
    registerFallbackValue(DraftMessage());
    when(() => createDraft(any())).thenAnswer((_) async => CreateDraftResponse());
    when(deleteDraft).thenAnswer((_) async => EmptyResponse());
    when(() => deleteDraft(parentId: any(named: 'parentId'))).thenAnswer((_) async => EmptyResponse());
    when(() => currentUserLastMessageAtStream).thenAnswer((_) => Stream.value(null));
  }

  @override
  final String type;

  @override
  final String? id;

  @override
  String? get cid {
    if (id != null) return '$type:$id';
    return null;
  }

  @override
  final List<ChannelCapability> ownCapabilities;

  @override
  Stream<List<ChannelCapability>> get ownCapabilitiesStream {
    return Stream.value(ownCapabilities);
  }

  @override
  Future<bool> get initialized async => true;

  @override
  Future<ChannelState> watch({
    bool presence = false,
    PaginationParams? messagesPagination,
    PaginationParams? membersPagination,
    PaginationParams? watchersPagination,
  }) {
    return Future.value(const ChannelState());
  }

  @override
  // ignore: prefer_expression_function_bodies
  Future<void> keyStroke([String? parentId]) async {
    return;
  }

  final Stream<Event> _eventStream;

  @override
  Stream<Event> on([
    String? eventType,
    String? eventType2,
    String? eventType3,
    String? eventType4,
  ]) {
    if (eventType == null) return _eventStream;
    return _eventStream.where((e) => e.type == eventType);
  }
}

class MockChannelState extends Mock implements ChannelClientState {
  MockChannelState() {
    when(() => typingEvents).thenReturn({});
    when(() => typingEventsStream).thenAnswer((_) => Stream.value({}));
    when(() => unreadCount).thenReturn(0);
    when(() => isUpToDate).thenReturn(true);
    when(() => read).thenReturn([]);
    when(() => draftStream).thenAnswer((_) => Stream.value(null));
    when(() => threadDraftStream(any())).thenAnswer((_) => Stream.value(null));
  }
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockVoidCallback extends Mock {
  void call();
}

class MockValueChanged<T> extends Mock {
  void call(T value);
}

class MockAttachmentHandler extends Mock implements StreamAttachmentHandler {}

class MockMember extends Mock implements Member {}

class MockUser extends Mock implements User {}

class MockOwnUser extends Mock implements OwnUser {}

class MockAttachment extends Mock implements Attachment {}

class MockVlcManagerDesktop extends Mock implements VlcManagerDesktop {}

class MockStreamMemberListController extends Mock implements StreamMemberListController {
  @override
  PagedValue<int, Member> value = const PagedValue.loading();
}

class MockMessage extends Mock implements Message {}
