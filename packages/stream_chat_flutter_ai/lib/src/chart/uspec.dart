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

  /// Bubble chart (a scatter chart whose point size encodes a third value).
  bubble,

  /// Heatmap — a grid whose cell intensity encodes a value.
  heatmap,

  /// Histogram — a bar chart of binned values.
  histogram,
}

/// A single data point in a chart series.
class UPoint {
  /// Creates a [UPoint].
  const UPoint({required this.x, required this.y, this.size, this.z});

  /// The x-axis label for this point.
  final String x;

  /// The y-axis value for this point.
  final double y;

  /// Optional point size, used by [USpecKind.bubble] to scale the marker.
  final double? size;

  /// Optional intensity value, used by [USpecKind.heatmap] cells.
  final double? z;
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
/// - Plotly (single-spec and figure) heatmaps.
/// - ECharts (`xAxis` + `series` fields).
/// - Highcharts (`xAxis` + `series` fields).
/// - Vega-Lite (`data.values` + `mark` + `encoding` fields).
/// - A flat pie schema (`type: "pie"` + `data: [{label, value}]`).
class USpec {
  /// Creates a [USpec].
  const USpec({
    required this.kind,
    required this.series,
    this.title,
    this.xLabel,
    this.yLabel,
    this.beginAtZeroY = false,
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

  /// Whether the y-axis should be forced to start at zero.
  final bool beginAtZeroY;
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
      return _tryUSpec(decoded) ??
          _tryChartJs(decoded) ??
          _tryPlotly(decoded) ??
          _tryECharts(decoded) ??
          _tryHighcharts(decoded) ??
          _tryVegaLite(decoded) ??
          _tryPieFlat(decoded);
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
          points.add(
            UPoint(
              x: p['x']?.toString() ?? '',
              y: y,
              size: (p['size'] as num?)?.toDouble(),
              z: (p['z'] as num?)?.toDouble(),
            ),
          );
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
      beginAtZeroY: json['beginAtZeroY'] == true,
    );
  }

  // ---------------------------------------------------------------------------
  // Chart.js format: { type, data: { labels, datasets: [{label, data}] }, options }
  // ---------------------------------------------------------------------------

  static USpec? _tryChartJs(Map<String, dynamic> json) {
    final rawData = json['data'];
    if (rawData is! Map<String, dynamic>) return null;

    final datasets = rawData['datasets'];
    if (datasets is! List || datasets.isEmpty) return null;

    final rawType = (json['type'] as String?)?.toLowerCase() ?? 'bar';
    final labels = (rawData['labels'] as List?)?.map((l) => l.toString()).toList();
    final options = json['options'];
    final scales = options is Map<String, dynamic> ? options['scales'] : null;
    final scaleY = scales is Map<String, dynamic> ? scales['y'] : null;
    final beginAtZero = scaleY is Map<String, dynamic> && scaleY['beginAtZero'] == true;

    // pie/doughnut: first dataset's values become slices, using labels as names.
    if (rawType == 'pie' || rawType == 'doughnut') {
      final ds = datasets.first;
      if (ds is! Map<String, dynamic>) return null;
      final rawValues = ds['data'];
      if (rawValues is! List) return null;
      final points = <UPoint>[];
      for (var i = 0; i < rawValues.length; i++) {
        final y = _asDouble(rawValues[i]);
        if (y == null) continue;
        final label = labels != null && i < labels.length ? labels[i] : i.toString();
        points.add(UPoint(x: label, y: y));
      }
      if (points.isEmpty) return null;
      return USpec(
        title: json['title']?.toString(),
        kind: USpecKind.pie,
        series: [USeries(name: ds['label']?.toString() ?? 'Pie', points: points)],
      );
    }

    final kind = _parseKind(rawType);
    final series = <USeries>[];
    for (final ds in datasets) {
      if (ds is! Map<String, dynamic>) continue;
      final rawValues = ds['data'];
      if (rawValues is! List) continue;

      final points = <UPoint>[];
      if (labels != null) {
        // Arrays aligned with labels — each value may be a number or an
        // object `{x, y, r}` (scatter/bubble encoded with labels present).
        for (var i = 0; i < labels.length; i++) {
          final raw = i < rawValues.length ? rawValues[i] : null;
          final (y, size) = _asPointValue(raw);
          if (y == null) continue;
          points.add(UPoint(x: labels[i], y: y, size: size));
        }
      } else {
        // No labels: values are objects `{x, y, r}` (scatter/bubble).
        for (final raw in rawValues) {
          if (raw is! Map<String, dynamic>) continue;
          final x = _asDouble(raw['x']);
          final y = _asDouble(raw['y']);
          if (x == null || y == null) continue;
          points.add(UPoint(x: _numToString(x), y: y, size: _asDouble(raw['r'])));
        }
      }
      series.add(USeries(name: ds['label']?.toString() ?? 'Series', points: points));
    }
    if (series.isEmpty) return null;

    return USpec(
      title: json['title']?.toString(),
      kind: kind,
      series: series,
      beginAtZeroY: beginAtZero,
    );
  }

  /// Decodes a Chart.js dataset value that may be a plain number or an
  /// object `{y, r}` (radar/scatter/bubble aligned to labels). Returns the
  /// `(y, size)` pair, or `(null, null)` if it can't be decoded.
  static (double?, double?) _asPointValue(dynamic raw) {
    if (raw == null) return (null, null);
    if (raw is num) return (raw.toDouble(), null);
    if (raw is Map<String, dynamic>) {
      return (_asDouble(raw['y']), _asDouble(raw['r']));
    }
    return (null, null);
  }

  // ---------------------------------------------------------------------------
  // Plotly heatmap: single-spec { type: "heatmap", data: {z, x, y}, layout }
  // or figure { data: [{type: "heatmap", z, x, y}], layout }
  // ---------------------------------------------------------------------------

  static USpec? _tryPlotly(Map<String, dynamic> json) {
    // Single-spec form.
    final singleType = (json['type'] as String?)?.toLowerCase();
    if (singleType == 'heatmap' && json['data'] is Map<String, dynamic>) {
      return _mapPlotlyHeatmap(json['data'] as Map<String, dynamic>, json['layout'] as Map<String, dynamic>?);
    }

    // Figure form: a list of traces, use the first heatmap trace.
    final traces = json['data'];
    if (traces is List) {
      for (final t in traces) {
        if (t is Map<String, dynamic> && (t['type'] as String?)?.toLowerCase() == 'heatmap' && t['z'] != null) {
          return _mapPlotlyHeatmap(t, json['layout'] as Map<String, dynamic>?);
        }
      }
    }
    return null;
  }

  static USpec? _mapPlotlyHeatmap(Map<String, dynamic> data, Map<String, dynamic>? layout) {
    final rawZ = data['z'];
    if (rawZ is! List) return null;

    final xCats = (data['x'] as List?)?.map((e) => e.toString()).toList();
    final yCats = (data['y'] as List?)?.map((e) => e.toString()).toList();

    final series = <USeries>[];
    for (var i = 0; i < rawZ.length; i++) {
      final row = rawZ[i];
      if (row is! List) continue;
      final yName = yCats != null && i < yCats.length ? yCats[i] : i.toString();
      final points = <UPoint>[];
      for (var j = 0; j < row.length; j++) {
        final val = _asDouble(row[j]);
        if (val == null) continue;
        final xName = xCats != null && j < xCats.length ? xCats[j] : j.toString();
        points.add(UPoint(x: xName, y: 0, z: val));
      }
      series.add(USeries(name: yName, points: points));
    }
    if (series.isEmpty) return null;

    return USpec(
      title: _plotlyAxisTitle(layout?['title']),
      kind: USpecKind.heatmap,
      xLabel: _plotlyAxisTitle((layout?['xaxis'] as Map<String, dynamic>?)?['title']),
      yLabel: _plotlyAxisTitle((layout?['yaxis'] as Map<String, dynamic>?)?['title']),
      series: series,
    );
  }

  static String? _plotlyAxisTitle(dynamic raw) {
    if (raw is String) return raw;
    if (raw is Map<String, dynamic>) return raw['text']?.toString();
    return null;
  }

  // ---------------------------------------------------------------------------
  // ECharts: { title: {text}, xAxis: {data}, series: [{name, type, data}] }
  // ---------------------------------------------------------------------------

  static USpec? _tryECharts(Map<String, dynamic> json) {
    final rawSeries = json['series'];
    if (rawSeries is! List || rawSeries.isEmpty || json['xAxis'] is! Map<String, dynamic>) return null;

    final xAxis = json['xAxis'] as Map<String, dynamic>;
    // Highcharts also shapes its axis as `{xAxis: {...}, series: [...]}`, but
    // keys its categories under `categories` rather than `data` — defer to
    // the Highcharts adapter when that's the only axis key present.
    if (xAxis.containsKey('categories') && !xAxis.containsKey('data')) return null;

    final categories = (xAxis['data'] as List?)?.map((e) => e.toString()).toList();
    final title = _wrappedTitle(json['title']);

    final series = <USeries>[];
    String? firstType;
    for (final s in rawSeries) {
      if (s is! Map<String, dynamic>) continue;
      final rawData = s['data'];
      if (rawData is! List) continue;
      final type = (s['type'] as String?)?.toLowerCase();
      firstType ??= type;

      final points = <UPoint>[];
      if (type == 'pie') {
        // ECharts pie encodes data as [{name, value}, ...].
        for (final d in rawData) {
          if (d is! Map<String, dynamic>) continue;
          final value = _asDouble(d['value']);
          if (value == null) continue;
          points.add(UPoint(x: d['name']?.toString() ?? '', y: value));
        }
      } else {
        for (var i = 0; i < rawData.length; i++) {
          final d = rawData[i];
          final x = categories != null && i < categories.length ? categories[i] : i.toString();
          if (d is num) {
            points.add(UPoint(x: x, y: d.toDouble()));
          } else if (d is List && d.length >= 2) {
            final xv = _asDouble(d[0]);
            final yv = _asDouble(d[1]);
            if (yv != null) points.add(UPoint(x: xv != null ? _numToString(xv) : x, y: yv));
          } else if (d is Map<String, dynamic>) {
            final value = _asDouble(d['value']);
            if (value == null) continue;
            final name = d['name']?.toString() ?? d['x']?.toString() ?? x;
            points.add(UPoint(x: name, y: value));
          }
        }
      }
      series.add(USeries(name: s['name']?.toString() ?? 'Series', points: points));
    }
    if (series.isEmpty) return null;

    final kind = switch (firstType) {
      'bar' => USpecKind.bar,
      'line' => USpecKind.line,
      'scatter' => USpecKind.scatter,
      'pie' => USpecKind.pie,
      _ => USpecKind.line,
    };

    return USpec(title: title, kind: kind, series: series);
  }

  static String? _wrappedTitle(dynamic raw) {
    if (raw is String) return raw;
    if (raw is Map<String, dynamic>) return raw['text']?.toString();
    return null;
  }

  // ---------------------------------------------------------------------------
  // Highcharts: { title: {text}, xAxis: {categories}, series: [{name, type, data}] }
  // ---------------------------------------------------------------------------

  static USpec? _tryHighcharts(Map<String, dynamic> json) {
    final rawSeries = json['series'];
    if (rawSeries is! List || rawSeries.isEmpty || json['xAxis'] is! Map<String, dynamic>) return null;

    final xAxis = json['xAxis'] as Map<String, dynamic>;
    final categories = (xAxis['categories'] as List?)?.map((e) => e.toString()).toList();
    final title = _wrappedTitle(json['title']);

    final series = <USeries>[];
    String? firstType;
    for (final s in rawSeries) {
      if (s is! Map<String, dynamic>) continue;
      final rawData = s['data'];
      if (rawData is! List) continue;
      firstType ??= (s['type'] as String?)?.toLowerCase();

      final points = <UPoint>[];
      for (var i = 0; i < rawData.length; i++) {
        final d = rawData[i];
        final x = categories != null && i < categories.length ? categories[i] : i.toString();
        if (d is num) {
          points.add(UPoint(x: x, y: d.toDouble()));
        } else if (d is List && d.length >= 2) {
          final xv = _asDouble(d[0]);
          final yv = _asDouble(d[1]);
          if (yv != null) points.add(UPoint(x: xv != null ? _numToString(xv) : x, y: yv));
        }
      }
      series.add(USeries(name: s['name']?.toString() ?? 'Series', points: points));
    }
    if (series.isEmpty) return null;

    final kind = switch (firstType) {
      'bar' || 'column' => USpecKind.bar,
      'line' || 'spline' => USpecKind.line,
      'scatter' => USpecKind.scatter,
      'pie' => USpecKind.pie,
      _ => USpecKind.line,
    };

    return USpec(title: title, kind: kind, series: series);
  }

  // ---------------------------------------------------------------------------
  // Vega-Lite (subset): { data: {values}, mark, encoding: {x, y, color, size} }
  // ---------------------------------------------------------------------------

  static USpec? _tryVegaLite(Map<String, dynamic> json) {
    final data = json['data'];
    final mark = json['mark'];
    final encoding = json['encoding'];
    if (data is! Map<String, dynamic> || mark == null || encoding is! Map<String, dynamic>) return null;

    final rows = data['values'];
    if (rows is! List) return null;

    final xField = (encoding['x'] as Map<String, dynamic>?)?['field']?.toString() ?? 'x';
    final yField = (encoding['y'] as Map<String, dynamic>?)?['field']?.toString() ?? 'y';
    final colorField = (encoding['color'] as Map<String, dynamic>?)?['field']?.toString();
    final sizeField = (encoding['size'] as Map<String, dynamic>?)?['field']?.toString();

    final groups = <String, List<UPoint>>{};
    for (final r in rows) {
      if (r is! Map<String, dynamic>) continue;
      final xRaw = r[xField];
      final xDouble = xRaw is String ? null : _asDouble(xRaw);
      final xStr = xRaw is String ? xRaw : (xDouble != null ? _numToString(xDouble) : '');
      final y = _asDouble(r[yField]) ?? 0;
      final key = colorField != null ? (r[colorField]?.toString() ?? 'Series') : 'Series';
      final size = sizeField != null ? _asDouble(r[sizeField]) : null;
      (groups[key] ??= []).add(UPoint(x: xStr, y: y, size: size));
    }
    if (groups.isEmpty) return null;

    final series = groups.entries.map((e) => USeries(name: e.key, points: e.value)).toList();

    final markStr = mark is String ? mark : (mark is Map<String, dynamic> ? mark['type']?.toString() : null);
    final kind = switch (markStr?.toLowerCase()) {
      'line' => USpecKind.line,
      'bar' => USpecKind.bar,
      'area' => USpecKind.area,
      'point' => USpecKind.scatter,
      'rect' => USpecKind.heatmap,
      _ => USpecKind.line,
    };

    return USpec(kind: kind, series: series);
  }

  // ---------------------------------------------------------------------------
  // Flat pie: { type: "pie", title, data: [{label, value}] }
  // ---------------------------------------------------------------------------

  static USpec? _tryPieFlat(Map<String, dynamic> json) {
    if ((json['type'] as String?)?.toLowerCase() != 'pie') return null;
    final rawData = json['data'];
    if (rawData is! List) return null;

    final points = <UPoint>[];
    for (final d in rawData) {
      if (d is! Map<String, dynamic>) continue;
      final value = _asDouble(d['value']);
      if (value == null) continue;
      points.add(UPoint(x: d['label']?.toString() ?? '', y: value));
    }
    if (points.isEmpty) return null;

    final title = json['title']?.toString();
    return USpec(
      title: title,
      kind: USpecKind.pie,
      series: [USeries(name: title ?? 'Pie', points: points)],
    );
  }

  // ---------------------------------------------------------------------------
  // Shared helpers
  // ---------------------------------------------------------------------------

  static USpecKind _parseKind(String raw) => switch (raw.toLowerCase()) {
    'pie' || 'doughnut' || 'polararea' => USpecKind.pie,
    'bar' || 'column' || 'radar' => USpecKind.bar,
    'area' => USpecKind.area,
    'scatter' => USpecKind.scatter,
    'bubble' => USpecKind.bubble,
    'heatmap' => USpecKind.heatmap,
    'histogram' => USpecKind.histogram,
    _ => USpecKind.line,
  };

  static double? _asDouble(dynamic raw) {
    if (raw is num) return raw.toDouble();
    if (raw is bool) return raw ? 1 : 0;
    if (raw is String) return double.tryParse(raw);
    return null;
  }

  static String _numToString(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : value.toString();
}
