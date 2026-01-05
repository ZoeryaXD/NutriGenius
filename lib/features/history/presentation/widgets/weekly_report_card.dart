import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyReportCard extends StatelessWidget {
  final List<double> weeklyData;
  final bool isLandscape;

  const WeeklyReportCard({
    super.key,
    required this.weeklyData,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    double total = weeklyData.fold(0, (sum, item) => sum + item);

    return Container(
      padding: EdgeInsets.all(isLandscape ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Statistik Kalori Mingguan",
            style: TextStyle(
              fontSize: isLandscape ? 14 : 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E7D32),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "${total.toStringAsFixed(0)} kkal minggu ini",
              style: TextStyle(
                fontSize: isLandscape ? 12 : 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(height: isLandscape ? 12 : 24),
          AspectRatio(
            aspectRatio: isLandscape ? 2.2 : 1.5,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => const Color(0xFF2E7D32),
                    tooltipBorderRadius: BorderRadius.circular(8),
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        return LineTooltipItem(
                          '${touchedSpot.y.toInt()} kkal',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                ),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    _buildThresholdLine(3000, const Color(0xFF6366F1)),
                    _buildThresholdLine(2000, Colors.cyan),
                    _buildThresholdLine(1000, Colors.blueAccent),
                  ],
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey[100]!, strokeWidth: 1),
                ),
                titlesData: _buildTitlesData(),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: 3500,
                lineBarsData: [
                  LineChartBarData(
                    spots: weeklyData
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2E7D32), Color(0xFF6366F1)],
                    ),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6366F1).withOpacity(0.2),
                          const Color(0xFF6366F1).withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildLegend(),
        ],
      ),
    );
  }

  HorizontalLine _buildThresholdLine(double y, Color color) {
    return HorizontalLine(
      y: y,
      color: color.withOpacity(0.3),
      strokeWidth: 1,
      dashArray: [5, 5],
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
            if (value.toInt() >= 0 && value.toInt() < days.length) {
              return Text(
                days[value.toInt()],
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              );
            }
            return const SizedBox();
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1000,
          reservedSize: 35,
          getTitlesWidget: (value, meta) => Text(
            value.toInt().toString(),
            style: const TextStyle(fontSize: 9, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    final legendItems = [
      {'val': '3000', 'color': const Color(0xFF6366F1)},
      {'val': '2000', 'color': Colors.cyan},
      {'val': '1000', 'color': Colors.blueAccent},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: legendItems
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 2,
                    decoration: BoxDecoration(
                      color: item['color'] as Color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item['val'] as String,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
