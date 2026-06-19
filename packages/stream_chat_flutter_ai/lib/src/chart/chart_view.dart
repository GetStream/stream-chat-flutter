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

Color _seriesColor(int index) => _kSeriesColors[index % _kSeriesColors.length];

/// Renders a [USpec] chart using `fl_chart`.
///
/// Supports [USpecKind.line], [USpecKind.area], [USpecKind.bar], and
/// [USpecKind.pie]. Unsupported kinds fall back to a line chart.
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
  // Shared helpers
  // ---------------------------------------------------------------------------

  List<FlSpot> _toSpots(USeries series) => series.points
      .asMap()
      .entries
      .map((e) => FlSpot(e.key.toDouble(), e.value.y))
      .toList();

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
