import 'dart:convert';

/// Supported chart types.
enum USpecKind {
  /// Line chart.
  line,

  /// Bar chart.
  bar,

  /// Pie chart.
  pie,

  /// Area chart (rendered as a filled line chart).
  area,

  /// Scatter chart.
  scatter,
}

/// A single data point in a chart series.
class UPoint {
  /// Creates a [UPoint].
  const UPoint({required this.x, required this.y});

  /// The x-axis label for this point.
  final String x;

  /// The y-axis value for this point.
  final double y;
}

/// A named series of data points.
class USeries {
  /// Creates a [USeries].
  const USeries({required this.name, required this.points});

  /// The series name (shown in legends).
  final String name;

  /// The data points that make up this series.
  final List<UPoint> points;
}

/// Unified chart specification — the internal representation used by [ChartView].
///
/// Parsed from JSON code fences in AI messages. Supports a subset of the
/// formats recognised by the iOS stream-chat-swift-ai library:
/// - Direct USpec JSON (`kind` + `series` fields).
/// - Chart.js format (`type` + `data.labels` + `data.datasets` fields).
class USpec {
  /// Creates a [USpec].
  const USpec({
    required this.kind,
    required this.series,
    this.title,
    this.xLabel,
    this.yLabel,
  });

  /// The chart type.
  final USpecKind kind;

  /// One or more data series.
  final List<USeries> series;

  /// Optional chart title.
  final String? title;

  /// Optional x-axis label.
  final String? xLabel;

  /// Optional y-axis label.
  final String? yLabel;
}

/// Parses JSON strings from AI code blocks into [USpec] chart data.
///
/// Returns `null` if the JSON is not recognisable as chart data.
class USpecParser {
  USpecParser._();

  /// Tries to parse [jsonText] as a [USpec].
  ///
  /// Returns `null` if the text is not valid JSON or doesn't match any
  /// recognised chart schema.
  static USpec? tryParse(String jsonText) {
    try {
      final decoded = jsonDecode(jsonText.trim());
      if (decoded is! Map<String, dynamic>) return null;
      return _tryUSpec(decoded) ?? _tryChartJs(decoded);
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // USpec format: { kind, series: [{name, points: [{x, y}]}], ... }
  // ---------------------------------------------------------------------------

  static USpec? _tryUSpec(Map<String, dynamic> json) {
    final rawKind = json['kind'];
    final rawSeries = json['series'];
    if (rawKind == null || rawSeries is! List) return null;

    final kind = _parseKind(rawKind.toString());
    final series = <USeries>[];
    for (final s in rawSeries) {
      if (s is! Map<String, dynamic>) continue;
      final points = <UPoint>[];
      final rawPoints = s['points'];
      if (rawPoints is List) {
        for (final p in rawPoints) {
          if (p is! Map<String, dynamic>) continue;
          final y = (p['y'] as num?)?.toDouble();
          if (y == null) continue;
          points.add(UPoint(x: p['x']?.toString() ?? '', y: y));
        }
      }
      series.add(USeries(name: s['name']?.toString() ?? '', points: points));
    }
    if (series.isEmpty) return null;

    return USpec(
      kind: kind,
      series: series,
      title: json['title']?.toString(),
      xLabel: json['xLabel']?.toString(),
      yLabel: json['yLabel']?.toString(),
    );
  }

  // ---------------------------------------------------------------------------
  // Chart.js format: { type, data: { labels, datasets: [{label, data}] } }
  // ---------------------------------------------------------------------------

  static USpec? _tryChartJs(Map<String, dynamic> json) {
    final rawData = json['data'];
    if (rawData is! Map<String, dynamic>) return null;

    final datasets = rawData['datasets'];
    if (datasets is! List || datasets.isEmpty) return null;

    final rawType = (json['type'] as String?)?.toLowerCase() ?? 'bar';
    final kind = _parseKind(rawType);

    final labels = (rawData['labels'] as List?)?.map((l) => l.toString()).toList() ?? <String>[];

    final series = <USeries>[];
    for (final ds in datasets) {
      if (ds is! Map<String, dynamic>) continue;
      final rawValues = ds['data'];
      if (rawValues is! List) continue;

      final points = <UPoint>[];
      for (var i = 0; i < rawValues.length; i++) {
        final val = rawValues[i];
        final y = (val is num) ? val.toDouble() : null;
        if (y == null) continue;
        points.add(UPoint(x: i < labels.length ? labels[i] : '$i', y: y));
      }
      series.add(USeries(name: ds['label']?.toString() ?? '', points: points));
    }
    if (series.isEmpty) return null;

    return USpec(kind: kind, series: series);
  }

  static USpecKind _parseKind(String raw) => switch (raw.toLowerCase()) {
    'pie' || 'doughnut' => USpecKind.pie,
    'bar' || 'histogram' || 'column' => USpecKind.bar,
    'area' => USpecKind.area,
    'scatter' || 'bubble' => USpecKind.scatter,
    _ => USpecKind.line,
  };
}
