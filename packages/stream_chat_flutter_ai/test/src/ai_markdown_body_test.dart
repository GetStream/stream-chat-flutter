import 'package:alchemist/alchemist.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_ai/stream_chat_flutter_ai.dart';

const _mixedContent = '''
Here's a quick summary of the data, with the code used to compute it:

```python
def average(values):
    return sum(values) / len(values)
```

And the resulting trend:

```chartjs
{
  "type": "bar",
  "data": {
    "labels": ["Jan", "Feb", "Mar"],
    "datasets": [{"label": "Sales", "data": [10, 25, 18]}]
  }
}
```
''';

void main() {
  group('AIMarkdownBody', () {
    testWidgets('renders text, code block, and chart together', (tester) async {
      await tester.pumpWidget(_wrap(const AIMarkdownBody(data: _mixedContent)));

      expect(find.textContaining("Here's a quick summary"), findsOneWidget);
      expect(find.byType(CodeBlockView), findsOneWidget);
      expect(find.byType(BarChart), findsOneWidget);
    });

    goldenTest(
      'mixed text, code block, and chart',
      fileName: 'ai_markdown_body_mixed_content',
      constraints: const BoxConstraints(maxWidth: 400, maxHeight: 700),
      builder: () => _wrap(const AIMarkdownBody(data: _mixedContent)),
    );
  });
}

Widget _wrap(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Align(alignment: Alignment.topLeft, child: child),
    ),
  );
}
