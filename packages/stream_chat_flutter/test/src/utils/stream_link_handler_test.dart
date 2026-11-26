import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/utils/open_link.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  late List<String> launched;

  setUp(() {
    launched = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/url_launcher'),
      (call) async {
        if (call.method != 'launch') return false;
        launched.add((call.arguments as Map)['url'] as String);
        return true;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/url_launcher'),
      null,
    );
  });

  for (final url in ['https://example.com/a', 'http://example.com', 'mailto:team@example.com']) {
    testWidgets('opens $url', (tester) async {
      final context = await _pumpContext(tester);

      final opened = await const StreamLinkHandler().open(context, Uri.parse(url));

      expect(opened, isTrue);
      expect(launched, [url]);
    });
  }

  testWidgets('opens a link without a scheme as http', (tester) async {
    final context = await _pumpContext(tester);

    await const StreamLinkHandler().open(context, Uri.parse('example.com/docs'));

    expect(launched, ['http://example.com/docs']);
  });

  for (final url in ['tel:+123456', 'sms:+123456', 'myapp://pay?amount=1', 'intent://scan', 'javascript:alert(1)']) {
    testWidgets('does not open $url', (tester) async {
      final context = await _pumpContext(tester);

      final opened = await const StreamLinkHandler().open(context, Uri.parse(url));

      expect(opened, isFalse);
      expect(launched, isEmpty);
    });
  }

  testWidgets('opens the schemes it is given', (tester) async {
    final context = await _pumpContext(tester);

    final opened = await const StreamLinkHandler(schemes: {'tel'}).open(context, Uri.parse('tel:+123456'));

    expect(opened, isTrue);
    expect(launched, ['tel:+123456']);
  });

  testWidgets('keeps opening the default schemes when more are added to them', (tester) async {
    final context = await _pumpContext(tester);
    const handler = StreamLinkHandler(schemes: {...StreamLinkHandler.defaultSchemes, 'tel'});

    await handler.open(context, Uri.parse('https://example.com'));

    expect(launched, ['https://example.com']);
  });

  testWidgets('reports a link the platform could not open as not opened', (tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/url_launcher'),
      (_) async => throw PlatformException(code: 'ACTIVITY_NOT_FOUND'),
    );
    final context = await _pumpContext(tester);

    final opened = await const StreamLinkHandler().open(context, Uri.parse('https://example.com'));

    expect(opened, isFalse);
  });

  testWidgets('openLink opens links with the configured link handler', (tester) async {
    final handler = _RecordingLinkHandler();
    final context = await _pumpContext(tester, configuration: StreamChatConfigurationData(linkHandler: handler));

    await openLink(context, 'myapp://pay');

    expect(handler.opened, [Uri.parse('myapp://pay')]);
  });

  testWidgets('openLink shows a snack bar for a link it does not open', (tester) async {
    final context = await _pumpContext(tester);

    await openLink(context, 'myapp://pay');
    await tester.pump();

    expect(launched, isEmpty);
    expect(find.byType(SnackBar), findsOneWidget);
  });
}

Future<BuildContext> _pumpContext(
  WidgetTester tester, {
  StreamChatConfigurationData? configuration,
}) async {
  late BuildContext context;
  final home = Scaffold(
    body: Builder(
      builder: (it) {
        context = it;
        return const SizedBox.shrink();
      },
    ),
  );

  await tester.pumpWidget(
    MaterialApp(
      home: switch (configuration) {
        final data? => StreamChatConfiguration(data: data, child: home),
        _ => home,
      },
    ),
  );
  return context;
}

class _RecordingLinkHandler extends StreamLinkHandler {
  final opened = <Uri>[];

  @override
  Future<bool> open(BuildContext context, Uri uri) async {
    opened.add(uri);
    return true;
  }
}
