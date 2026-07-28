import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  late MockClient client;
  late MockClientState clientState;

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
  });

  StreamChatNetworkError dioError(DioExceptionType type) => StreamChatNetworkError.fromDioException(
    DioException(
      requestOptions: RequestOptions(path: '/'),
      type: type,
    ),
  );

  // Pumps StreamChat and renders the default error state it installs for the
  // given [error], via DefaultStreamChannelBuilders.errorBuilderOf.
  Future<void> pumpDefaultError(WidgetTester tester, Object error) {
    return tester.pumpWidget(
      MaterialApp(
        home: StreamChat(
          client: client,
          child: Scaffold(
            body: Builder(
              builder: (context) {
                final errorBuilder = DefaultStreamChannelBuilders.errorBuilderOf(context);
                return errorBuilder(context, error, null);
              },
            ),
          ),
        ),
      ),
    );
  }

  group('default channel error builder installed by StreamChat', () {
    testWidgets('shows the no-internet copy for connection errors', (tester) async {
      await pumpDefaultError(tester, dioError(DioExceptionType.connectionError));

      expect(find.byType(StreamScrollViewErrorWidget), findsOneWidget);
      expect(find.text('No Internet Connection'), findsOneWidget);
      expect(find.text('Please check your internet connection'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('shows the slow-connection copy for timeouts', (tester) async {
      await pumpDefaultError(tester, dioError(DioExceptionType.receiveTimeout));

      expect(find.text('Slow Internet Connection'), findsOneWidget);
      expect(
        find.text('There seems to be a problem with your internet connection'),
        findsOneWidget,
      );
    });

    testWidgets('shows a generic message and never the raw error', (tester) async {
      final error = StreamChatNetworkError.raw(
        code: -1,
        message: 'super secret internal failure',
        statusCode: 500,
      );

      await pumpDefaultError(tester, error);

      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Oops, something went wrong'), findsOneWidget);
      expect(find.textContaining('StreamChatNetworkError'), findsNothing);
      expect(find.textContaining('super secret internal failure'), findsNothing);
    });
  });

  testWidgets(
    'StreamChat installs a themed default channel loading builder',
    (tester) async {
      Color? expectedBackground;

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  expectedBackground = context.streamColorScheme.backgroundApp;
                  final loadingBuilder = DefaultStreamChannelBuilders.loadingBuilderOf(context);
                  return loadingBuilder(context);
                },
              ),
            ),
          ),
        ),
      );

      // The installed default shows a spinner on the themed app background.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final material = tester.widget<Material>(
        find
            .ancestor(
              of: find.byType(CircularProgressIndicator),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(material.color, expectedBackground);
    },
  );
}
