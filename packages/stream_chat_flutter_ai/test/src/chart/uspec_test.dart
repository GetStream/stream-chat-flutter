import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_ai/src/chart/uspec.dart';

void main() {
  group('USpecParser.tryParse', () {
    test('returns null for garbage input', () {
      expect(USpecParser.tryParse('not json'), isNull);
    });

    test('returns null for unrecognised JSON shapes', () {
      expect(USpecParser.tryParse('{"foo": "bar"}'), isNull);
    });

    group('native USpec schema', () {
      test('parses kind and series', () {
        final spec = USpecParser.tryParse('''
        {
          "kind": "bar",
          "series": [
            {"name": "Sales", "points": [{"x": "Jan", "y": 10}, {"x": "Feb", "y": 20}]}
          ]
        }
        ''');

        expect(spec, isNotNull);
        expect(spec!.kind, USpecKind.bar);
        expect(spec.series, hasLength(1));
        expect(spec.series.first.points.map((p) => p.y), [10, 20]);
      });

      test('parses optional size/z fields and beginAtZeroY', () {
        final spec = USpecParser.tryParse('''
        {
          "kind": "bubble",
          "beginAtZeroY": true,
          "series": [
            {"name": "S", "points": [{"x": "A", "y": 5, "size": 12}]}
          ]
        }
        ''');

        expect(spec, isNotNull);
        expect(spec!.kind, USpecKind.bubble);
        expect(spec.beginAtZeroY, isTrue);
        expect(spec.series.first.points.first.size, 12);
      });
    });

    group('Chart.js schema', () {
      test('parses a line chart', () {
        final spec = USpecParser.tryParse('''
        {
          "type": "line",
          "data": {
            "labels": ["Jan", "Feb"],
            "datasets": [{"label": "Sales", "data": [10, 20]}]
          }
        }
        ''');

        expect(spec, isNotNull);
        expect(spec!.kind, USpecKind.line);
        expect(spec.series.first.points.map((p) => p.x), ['Jan', 'Feb']);
      });

      test('parses a pie chart', () {
        final spec = USpecParser.tryParse('''
        {
          "type": "pie",
          "data": {
            "labels": ["A", "B"],
            "datasets": [{"label": "Pie", "data": [30, 70]}]
          }
        }
        ''');

        expect(spec, isNotNull);
        expect(spec!.kind, USpecKind.pie);
        expect(spec.series.first.points.map((p) => p.x), ['A', 'B']);
      });

      test('parses scatter with object values {x, y, r}', () {
        final spec = USpecParser.tryParse('''
        {
          "type": "scatter",
          "data": {
            "datasets": [{"label": "S", "data": [{"x": 1, "y": 2, "r": 5}, {"x": 3, "y": 4}]}]
          }
        }
        ''');

        expect(spec, isNotNull);
        expect(spec!.kind, USpecKind.scatter);
        final points = spec.series.first.points;
        expect(points, hasLength(2));
        expect(points.first.size, 5);
        expect(points.last.size, isNull);
      });

      test('parses bubble with object values {x, y, r}', () {
        final spec = USpecParser.tryParse('''
        {
          "type": "bubble",
          "data": {
            "datasets": [{"label": "S", "data": [{"x": 1, "y": 2, "r": 20}]}]
          }
        }
        ''');

        expect(spec, isNotNull);
        expect(spec!.kind, USpecKind.bubble);
        expect(spec.series.first.points.first.size, 20);
      });

      test('maps radar to bar and polarArea to pie', () {
        final radar = USpecParser.tryParse('''
        {"type": "radar", "data": {"labels": ["A"], "datasets": [{"label": "S", "data": [1]}]}}
        ''');
        expect(radar!.kind, USpecKind.bar);

        final polarArea = USpecParser.tryParse('''
        {"type": "polarArea", "data": {"labels": ["A"], "datasets": [{"label": "S", "data": [1]}]}}
        ''');
        expect(polarArea!.kind, USpecKind.pie);
      });

      test('reads options.scales.y.beginAtZero', () {
        final spec = USpecParser.tryParse('''
        {
          "type": "bar",
          "data": {"labels": ["A"], "datasets": [{"label": "S", "data": [1]}]},
          "options": {"scales": {"y": {"beginAtZero": true}}}
        }
        ''');

        expect(spec!.beginAtZeroY, isTrue);
      });
    });

    group('Plotly schema', () {
      test('parses a single-spec heatmap', () {
        final spec = USpecParser.tryParse('''
        {
          "type": "heatmap",
          "data": {"z": [[1, 2], [3, 4]], "x": ["a", "b"], "y": ["r1", "r2"]},
          "layout": {"title": "Heat"}
        }
        ''');

        expect(spec, isNotNull);
        expect(spec!.kind, USpecKind.heatmap);
        expect(spec.series, hasLength(2));
        expect(spec.series.first.points.map((p) => p.z), [1, 2]);
        expect(spec.title, 'Heat');
      });

      test('parses a figure with a heatmap trace', () {
        final spec = USpecParser.tryParse('''
        {
          "data": [{"type": "heatmap", "z": [[1, 2]], "x": ["a", "b"], "y": ["r1"]}],
          "layout": {"title": {"text": "Fig"}}
        }
        ''');

        expect(spec, isNotNull);
        expect(spec!.kind, USpecKind.heatmap);
        expect(spec.title, 'Fig');
      });
    });

    group('ECharts schema', () {
      test('parses a category series', () {
        final spec = USpecParser.tryParse('''
        {
          "title": {"text": "Chart"},
          "xAxis": {"data": ["Mon", "Tue"]},
          "series": [{"name": "S", "type": "bar", "data": [1, 2]}]
        }
        ''');

        expect(spec, isNotNull);
        expect(spec!.kind, USpecKind.bar);
        expect(spec.title, 'Chart');
        expect(spec.series.first.points.map((p) => p.x), ['Mon', 'Tue']);
      });

      test('parses a pie series encoded as [{name, value}]', () {
        final spec = USpecParser.tryParse('''
        {
          "xAxis": {},
          "series": [{"name": "S", "type": "pie", "data": [{"name": "Android", "value": 71.9}]}]
        }
        ''');

        expect(spec, isNotNull);
        expect(spec!.kind, USpecKind.pie);
        expect(spec.series.first.points.first.x, 'Android');
        expect(spec.series.first.points.first.y, 71.9);
      });
    });

    group('Highcharts schema', () {
      test('maps column to bar', () {
        final spec = USpecParser.tryParse('''
        {
          "title": {"text": "HC"},
          "xAxis": {"categories": ["A", "B"]},
          "series": [{"name": "S", "type": "column", "data": [5, 6]}]
        }
        ''');

        expect(spec, isNotNull);
        expect(spec!.kind, USpecKind.bar);
        expect(spec.series.first.points.map((p) => p.x), ['A', 'B']);
      });
    });

    group('Vega-Lite schema', () {
      test('maps bar mark', () {
        final spec = USpecParser.tryParse('''
        {
          "data": {"values": [{"cat": "A", "val": 3}, {"cat": "B", "val": 5}]},
          "mark": "bar",
          "encoding": {"x": {"field": "cat"}, "y": {"field": "val"}}
        }
        ''');

        expect(spec, isNotNull);
        expect(spec!.kind, USpecKind.bar);
        expect(spec.series, hasLength(1));
      });

      test('maps point mark to scatter', () {
        final spec = USpecParser.tryParse('''
        {
          "data": {"values": [{"x": 1, "y": 2}]},
          "mark": "point",
          "encoding": {"x": {"field": "x"}, "y": {"field": "y"}}
        }
        ''');

        expect(spec!.kind, USpecKind.scatter);
      });

      test('maps rect mark to heatmap', () {
        final spec = USpecParser.tryParse('''
        {
          "data": {"values": [{"x": 1, "y": 2}]},
          "mark": "rect",
          "encoding": {"x": {"field": "x"}, "y": {"field": "y"}}
        }
        ''');

        expect(spec!.kind, USpecKind.heatmap);
      });

      test('groups rows by the color field into separate series', () {
        final spec = USpecParser.tryParse('''
        {
          "data": {
            "values": [
              {"x": 1, "y": 2, "grp": "A"},
              {"x": 2, "y": 3, "grp": "B"}
            ]
          },
          "mark": "line",
          "encoding": {"x": {"field": "x"}, "y": {"field": "y"}, "color": {"field": "grp"}}
        }
        ''');

        expect(spec!.series, hasLength(2));
      });
    });

    group('Flat pie schema', () {
      test('parses label/value pairs', () {
        final spec = USpecParser.tryParse('''
        {
          "type": "pie",
          "title": "Flat",
          "data": [{"label": "A", "value": 1}, {"label": "B", "value": 2}]
        }
        ''');

        expect(spec, isNotNull);
        expect(spec!.kind, USpecKind.pie);
        expect(spec.series.first.points.map((p) => p.x), ['A', 'B']);
      });
    });
  });
}
