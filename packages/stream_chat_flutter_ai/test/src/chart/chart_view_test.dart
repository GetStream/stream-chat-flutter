import 'package:alchemist/alchemist.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_ai/src/chart/chart_view.dart';
import 'package:stream_chat_flutter_ai/src/chart/uspec.dart';

void main() {
  group('ChartView', () {
    testWidgets('line renders LineChart', (tester) async {
      await tester.pumpWidget(_wrap(const ChartView(spec: _lineSpec)));
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('area renders LineChart', (tester) async {
      await tester.pumpWidget(_wrap(const ChartView(spec: _areaSpec)));
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('bar renders BarChart', (tester) async {
      await tester.pumpWidget(_wrap(const ChartView(spec: _barSpec)));
      expect(find.byType(BarChart), findsOneWidget);
    });

    testWidgets('pie renders PieChart', (tester) async {
      await tester.pumpWidget(_wrap(const ChartView(spec: _pieSpec)));
      expect(find.byType(PieChart), findsOneWidget);
    });

    testWidgets('scatter renders ScatterChart (not a line fallback)', (tester) async {
      await tester.pumpWidget(_wrap(const ChartView(spec: _scatterSpec)));
      expect(find.byType(ScatterChart), findsOneWidget);
      expect(find.byType(LineChart), findsNothing);
    });

    testWidgets('bubble renders ScatterChart (not a line fallback)', (tester) async {
      await tester.pumpWidget(_wrap(const ChartView(spec: _bubbleSpec)));
      expect(find.byType(ScatterChart), findsOneWidget);
      expect(find.byType(LineChart), findsNothing);
    });

    testWidgets('histogram renders BarChart (not a line fallback)', (tester) async {
      await tester.pumpWidget(_wrap(const ChartView(spec: _histogramSpec)));
      expect(find.byType(BarChart), findsOneWidget);
      expect(find.byType(LineChart), findsNothing);
    });

    testWidgets('heatmap renders a placeholder, not a line fallback', (tester) async {
      await tester.pumpWidget(_wrap(const ChartView(spec: _heatmapSpec)));
      expect(find.text('Heatmap'), findsOneWidget);
      expect(find.byType(LineChart), findsNothing);
    });

    group('golden', () {
      for (final entry in _goldenCases.entries) {
        goldenTest(
          '${entry.key} chart',
          fileName: 'chart_view_${entry.key}',
          constraints: const BoxConstraints.tightFor(width: 320, height: 260),
          builder: () => _wrap(ChartView(spec: entry.value)),
        );
      }
    });
  });
}

const _goldenCases = {
  'line': _lineSpec,
  'area': _areaSpec,
  'bar': _barSpec,
  'pie': _pieSpec,
  'scatter': _scatterSpec,
  'bubble': _bubbleSpec,
  'histogram': _histogramSpec,
  'heatmap': _heatmapSpec,
};

const _lineSpec = USpec(
  kind: USpecKind.line,
  series: [
    USeries(
      name: 'Sales',
      points: [
        UPoint(x: 'Jan', y: 10),
        UPoint(x: 'Feb', y: 25),
        UPoint(x: 'Mar', y: 18),
      ],
    ),
  ],
);

const _areaSpec = USpec(
  kind: USpecKind.area,
  series: [
    USeries(
      name: 'Sales',
      points: [
        UPoint(x: 'Jan', y: 10),
        UPoint(x: 'Feb', y: 25),
        UPoint(x: 'Mar', y: 18),
      ],
    ),
  ],
);

const _barSpec = USpec(
  kind: USpecKind.bar,
  series: [
    USeries(
      name: 'Sales',
      points: [
        UPoint(x: 'Jan', y: 10),
        UPoint(x: 'Feb', y: 25),
        UPoint(x: 'Mar', y: 18),
      ],
    ),
  ],
);

const _pieSpec = USpec(
  kind: USpecKind.pie,
  series: [
    USeries(
      name: 'Share',
      points: [
        UPoint(x: 'A', y: 40),
        UPoint(x: 'B', y: 35),
        UPoint(x: 'C', y: 25),
      ],
    ),
  ],
);

const _scatterSpec = USpec(
  kind: USpecKind.scatter,
  series: [
    USeries(
      name: 'S',
      points: [
        UPoint(x: '1', y: 3),
        UPoint(x: '2', y: 7),
        UPoint(x: '3', y: 2),
        UPoint(x: '4', y: 9),
      ],
    ),
  ],
);

const _bubbleSpec = USpec(
  kind: USpecKind.bubble,
  series: [
    USeries(
      name: 'S',
      points: [
        UPoint(x: '1', y: 3, size: 8),
        UPoint(x: '2', y: 7, size: 25),
        UPoint(x: '3', y: 2, size: 40),
      ],
    ),
  ],
);

const _histogramSpec = USpec(
  kind: USpecKind.histogram,
  series: [
    USeries(
      name: 'Distribution',
      points: [
        UPoint(x: '', y: 1),
        UPoint(x: '', y: 2),
        UPoint(x: '', y: 2),
        UPoint(x: '', y: 3),
        UPoint(x: '', y: 3),
        UPoint(x: '', y: 3),
        UPoint(x: '', y: 8),
        UPoint(x: '', y: 9),
        UPoint(x: '', y: 10),
      ],
    ),
  ],
);

const _heatmapSpec = USpec(
  kind: USpecKind.heatmap,
  series: [
    USeries(
      name: 'Row 1',
      points: [
        UPoint(x: 'A', y: 0, z: 1),
        UPoint(x: 'B', y: 0, z: 5),
      ],
    ),
    USeries(
      name: 'Row 2',
      points: [
        UPoint(x: 'A', y: 0, z: 3),
        UPoint(x: 'B', y: 0, z: 9),
      ],
    ),
  ],
);

Widget _wrap(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: Center(child: child)),
  );
}
