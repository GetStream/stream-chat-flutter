import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_ai/src/chart/uspec.dart';

const _kChartHeight = 220.0;

const _kSeriesColors = [
  Color(0xFF4A90D9),
  Color(0xFFE67E22),
  Color(0xFF2ECC71),
  Color(0xFFE74C3C),
  Color(0xFF9B59B6),
  Color(0xFF1ABC9C),
];

/// The fixed marker radius used for [USpecKind.scatter] points.
const _kScatterRadius = 6.0;

/// The [UPoint.size]-to-radius clamp range used for [USpecKind.bubble] points.
const _kBubbleRadiusRange = (min: 6.0, max: 40.0);

/// The number of buckets a [USpecKind.histogram] is binned into.
const _kHistogramBinCount = 10;

Color _seriesColor(int index) => _kSeriesColors[index % _kSeriesColors.length];

/// Renders a [USpec] chart using `fl_chart`.
///
/// Supports [USpecKind.line], [USpecKind.area], [USpecKind.bar],
/// [USpecKind.pie], [USpecKind.scatter], [USpecKind.bubble], and
/// [USpecKind.histogram]. [USpecKind.heatmap] renders as a placeholder — a
/// full grid render is not yet implemented (`fl_chart` has no native
/// heatmap widget).
class ChartView extends StatelessWidget {
  /// Creates a [ChartView].
  const ChartView({super.key, required this.spec});

  /// The chart data to display.
  final USpec spec;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kChartHeight,
      padding: const EdgeInsets.only(top: 8, right: 16, bottom: 8),
      child: switch (spec.kind) {
        USpecKind.pie => _buildPieChart(),
        USpecKind.bar => _buildBarChart(),
        USpecKind.scatter => _buildScatterChart(bubble: false),
        USpecKind.bubble => _buildScatterChart(bubble: true),
        USpecKind.histogram => _buildHistogramChart(),
        USpecKind.heatmap => _buildHeatmapPlaceholder(),
        _ => _buildLineChart(),
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Line / area chart
  // ---------------------------------------------------------------------------

  Widget _buildLineChart() {
    final filled = spec.kind == USpecKind.area;
    final lineBarsData = spec.series.asMap().entries.map((e) {
      final color = _seriesColor(e.key);
      return LineChartBarData(
        spots: _toSpots(e.value),
        color: color,
        dotData: const FlDotData(show: false),
        belowBarData: filled ? BarAreaData(show: true, color: color.withValues(alpha: 0.15)) : BarAreaData(show: false),
      );
    }).toList();

    final labels = spec.series.isNotEmpty ? spec.series.first.points.map((p) => p.x).toList() : <String>[];

    return LineChart(
      LineChartData(
        lineBarsData: lineBarsData,
        titlesData: _titlesData(labels),
        gridData: _gridData(),
        borderData: FlBorderData(show: false),
        minY: spec.beginAtZeroY ? 0 : null,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Bar chart
  // ---------------------------------------------------------------------------

  Widget _buildBarChart() {
    final labels = spec.series.isNotEmpty ? spec.series.first.points.map((p) => p.x).toList() : <String>[];
    final pointCount = labels.length;
    final seriesCount = spec.series.length;

    final groups = List.generate(pointCount, (xi) {
      final rods = List.generate(seriesCount, (si) {
        final points = spec.series[si].points;
        final y = xi < points.length ? points[xi].y : 0.0;
        return BarChartRodData(toY: y, color: _seriesColor(si), width: 10);
      });
      return BarChartGroupData(x: xi, barRods: rods, barsSpace: 4);
    });

    return BarChart(
      BarChartData(
        barGroups: groups,
        titlesData: _titlesData(labels),
        gridData: _gridData(),
        borderData: FlBorderData(show: false),
        barTouchData: const BarTouchData(enabled: false),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Pie chart
  // ---------------------------------------------------------------------------

  Widget _buildPieChart() {
    // For pie charts, use the first series; each point is one slice.
    final points = spec.series.isNotEmpty ? spec.series.first.points : <UPoint>[];
    final sections = points.asMap().entries.map((e) {
      return PieChartSectionData(
        value: e.value.y,
        color: _seriesColor(e.key),
        title: e.value.x,
        radius: 80,
        titleStyle: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
      );
    }).toList();

    return PieChart(PieChartData(sections: sections, sectionsSpace: 2));
  }

  // ---------------------------------------------------------------------------
  // Scatter / bubble chart
  // ---------------------------------------------------------------------------

  Widget _buildScatterChart({required bool bubble}) {
    final spots = <ScatterSpot>[];
    for (final entry in spec.series.asMap().entries) {
      final color = _seriesColor(entry.key);
      for (final point in entry.value.points) {
        final x = double.tryParse(point.x) ?? spots.length.toDouble();
        final radius = bubble ? _bubbleRadius(point.size) : _kScatterRadius;
        spots.add(
          ScatterSpot(
            x,
            point.y,
            dotPainter: FlDotCirclePainter(radius: radius, color: color),
          ),
        );
      }
    }

    return ScatterChart(
      ScatterChartData(
        scatterSpots: spots,
        titlesData: _titlesData(const []),
        gridData: _gridData(),
        borderData: FlBorderData(show: false),
        minY: spec.beginAtZeroY ? 0 : null,
      ),
    );
  }

  /// Clamps a bubble's [UPoint.size] into a sane pixel radius range, falling
  /// back to the fixed scatter radius when no size is provided.
  double _bubbleRadius(double? size) {
    if (size == null) return _kScatterRadius;
    return size.clamp(_kBubbleRadiusRange.min, _kBubbleRadiusRange.max).toDouble();
  }

  // ---------------------------------------------------------------------------
  // Histogram
  // ---------------------------------------------------------------------------

  Widget _buildHistogramChart() {
    final values = spec.series.isNotEmpty ? spec.series.first.points.map((p) => p.y).toList() : <double>[];
    final bins = _makeBins(values, _kHistogramBinCount);

    final groups = bins.asMap().entries.map((e) {
      return BarChartGroupData(
        x: e.key,
        barRods: [BarChartRodData(toY: e.value.count.toDouble(), color: _seriesColor(0), width: 10)],
      );
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: groups,
        titlesData: _titlesData(bins.map((b) => b.label).toList()),
        gridData: _gridData(),
        borderData: FlBorderData(show: false),
        barTouchData: const BarTouchData(enabled: false),
      ),
    );
  }

  /// Bins [values] into [targetBins] equal-width buckets between their min
  /// and max, mirroring Swift's `makeBins`.
  List<_HistogramBin> _makeBins(List<double> values, int targetBins) {
    if (values.isEmpty) return const [];
    final minV = values.reduce((a, b) => a < b ? a : b);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    if (maxV <= minV) return const [];

    final bins = targetBins < 1 ? 1 : targetBins;
    final step = (maxV - minV) / bins;
    final counts = List<int>.filled(bins, 0);
    for (final v in values) {
      final idx = ((v - minV) / step).floor().clamp(0, bins - 1);
      counts[idx]++;
    }

    return List.generate(bins, (i) {
      final lo = minV + i * step;
      final hi = minV + (i + 1) * step;
      return _HistogramBin(label: '${lo.toStringAsFixed(1)}–${hi.toStringAsFixed(1)}', count: counts[i]);
    });
  }

  // ---------------------------------------------------------------------------
  // Heatmap (deferred — placeholder render)
  // ---------------------------------------------------------------------------

  Widget _buildHeatmapPlaceholder() {
    return const Center(
      child: Text('Heatmap', style: TextStyle(fontSize: 13, color: Colors.black54)),
    );
  }

  // ---------------------------------------------------------------------------
  // Shared helpers
  // ---------------------------------------------------------------------------

  List<FlSpot> _toSpots(USeries series) =>
      series.points.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.y)).toList();

  FlTitlesData _titlesData(List<String> labels) => FlTitlesData(
    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 28,
        getTitlesWidget: (value, meta) {
          final i = value.toInt();
          if (i < 0 || i >= labels.length) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              labels[i],
              style: const TextStyle(fontSize: 10),
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
    ),
  );

  FlGridData _gridData() => FlGridData(
    drawVerticalLine: false,
    horizontalInterval: null,
    getDrawingHorizontalLine: (_) => const FlLine(color: Color(0x1A000000), strokeWidth: 1),
  );
}

/// A single bucket produced by [ChartView._makeBins].
class _HistogramBin {
  const _HistogramBin({required this.label, required this.count});

  final String label;
  final int count;
}
