import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/video/vlc/vlc_manager_desktop.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MockClient extends Mock implements StreamChatClient {
  MockClient() {
    when(() => wsConnectionStatus).thenReturn(ConnectionStatus.connected);
    when(() => wsConnectionStatusStream)
        .thenAnswer((_) => Stream.value(ConnectionStatus.connected));
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
  });

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
    return Future.value(ChannelState());
  }

  @override
  // ignore: prefer_expression_function_bodies
  Future<void> keyStroke([String? parentId]) async {
    return;
  }
}

class MockChannelState extends Mock implements ChannelClientState {
  MockChannelState() {
    when(() => typingEvents).thenReturn({});
    when(() => typingEventsStream).thenAnswer((_) => Stream.value({}));
    when(() => unreadCount).thenReturn(0);
    when(() => read).thenReturn([]);
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

class MockStreamMemberListController extends Mock
    implements StreamMemberListController {
  @override
  PagedValue<int, Member> value = const PagedValue.loading();
}

class MockMessage extends Mock implements Message {}
