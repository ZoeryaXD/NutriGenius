import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyReportCard extends StatelessWidget {
  final List<double> weeklyCalories;
  final double totalCalories;
  final double dailyAverage;

  const WeeklyReportCard({
    super.key,
    required this.weeklyCalories,
    required this.totalCalories,
    required this.dailyAverage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    double maxVal = 0;
    for (var val in weeklyCalories) {
      if (val > maxVal) maxVal = val;
    }
    double dynamicMaxY = maxVal < 1500 ? 2000 : maxVal + 500;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem(
                "Total",
                "${totalCalories.toInt()} kkal",
                colorScheme,
                isDark,
              ),
              _statItem(
                "Rata-rata",
                "${dailyAverage.toInt()} kkal",
                colorScheme,
                isDark,
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 180,
            child: LineChart(_chartData(colorScheme, isDark, dynamicMaxY)),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String val, ColorScheme cs, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(
          val,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  LineChartData _chartData(ColorScheme cs, bool isDark, double maxY) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => cs.primary,
          tooltipRoundedRadius: 8,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              return LineTooltipItem(
                "${touchedSpot.y.toInt()} kkal",
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              );
            }).toList();
          },
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1000,
        getDrawingHorizontalLine:
            (v) => FlLine(
              color: isDark ? Colors.white10 : Colors.grey[200]!,
              strokeWidth: 1,
            ),
      ),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (v, meta) {
              const days = [
                'Senin',
                'Selasa',
                'Rabu',
                'Kamis',
                'Jumat',
                'Sabtu',
                'Minggu',
              ];

              final index = v.toInt();
              if (index < 0 || index > 6) return const SizedBox();

              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  days[index],
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            7,
            (i) => FlSpot(i.toDouble(), weeklyCalories[i]),
          ),
          isCurved: true,
          color: cs.primary,
          barWidth: 4,
          dotData: FlDotData(
            show: true,
            getDotPainter:
                (s, p, b, i) => FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: cs.primary,
                ),
          ),
          belowBarData: BarAreaData(
            show: true,
            color: cs.primary.withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}
